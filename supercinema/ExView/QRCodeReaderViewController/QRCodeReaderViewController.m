/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "QRCodeReaderViewController.h"
#import "QRCameraSwitchButton.h"
#import "QRCodeReaderView.h"
#import "ZXingObjC.h"


#define mainHeight     [[UIScreen mainScreen] bounds].size.height
#define mainWidth      [[UIScreen mainScreen] bounds].size.width
#define navBarHeight   self.navigationController.navigationBar.frame.size.height

@interface QRCodeReaderViewController () <AVCaptureMetadataOutputObjectsDelegate,QRCodeReaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) QRCameraSwitchButton *switchCameraButton;
@property (strong, nonatomic) QRCodeReaderView     *cameraView;
@property (strong, nonatomic) AVAudioPlayer        *beepPlayer;
@property (strong, nonatomic) UIButton             *cancelButton;
@property (strong, nonatomic) UIImageView          *imgLine;
@property (strong, nonatomic) UILabel              *lblTip;
@property (strong, nonatomic) NSTimer              *timerScan;

@property (strong, nonatomic) AVCaptureDevice            *defaultDevice;
@property (strong, nonatomic) AVCaptureDeviceInput       *defaultDeviceInput;
@property (strong, nonatomic) AVCaptureDevice            *frontDevice;
@property (strong, nonatomic) AVCaptureDeviceInput       *frontDeviceInput;
@property (strong, nonatomic) AVCaptureMetadataOutput    *metadataOutput;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic) CIDetector *detector;

@property (copy, nonatomic) void (^completionBlock) (NSString *);

@end

@implementation QRCodeReaderViewController

- (id)init
{
    NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
    NSData* data = [[NSData alloc] initWithContentsOfFile:wavPath];
    _beepPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    
    return [self initWithCancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")];
}

- (id)initWithCancelButtonTitle:(NSString *)cancelTitle
{
    if ((self = [super init])) {
        self.view.backgroundColor = [UIColor blackColor];

        [self setupAVComponents];
        [self configureDefaultComponents];
        [self setupUIComponentsWithCancelButtonTitle:cancelTitle];
        [self setupAutoLayoutConstraints];

        [_cameraView.layer insertSublayer:self.previewLayer atIndex:0];
        
    }
    return self;
}

+ (instancetype)readerWithCancelButtonTitle:(NSString *)cancelTitle
{
  return [[self alloc] initWithCancelButtonTitle:cancelTitle];
}

-(void) viewDidAppear:(BOOL)animated
{
//    [self._locationManager requestLocationWithReGeocode:YES completionBlock:self._completionBlock];
    if( [[Config getLocationInfo] objectForKey:@"longitude"] ==nil && [[[Config getLocationInfo] objectForKey:@"longitude"] length] == 0 )
    {
        [self._locationManager requestLocationWithReGeocode:YES completionBlock:self._completionBlock];
    }
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startScanning];
    
    //本地存在定位信息
    if( [[Config getLocationInfo] objectForKey:@"longitude"] !=nil && [[[Config getLocationInfo] objectForKey:@"longitude"] length] >0 )
    {
        self._longitude = [[Config getLocationInfo] objectForKey:@"longitude"];
        self._latitude = [[Config getLocationInfo] objectForKey:@"latitude"];
    }
    else
    {
//        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..."  withBlur:NO allowTap:NO];
        [self location];
        [self configLocationManager];
    }
    
}
#pragma mark 配置定位信息
-(void)location
{
    __weak __typeof__(self) weakSelf = self;
    self._completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            //如果为定位失败的error，则不进行后续操作
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        //得到定位信息
        if (location)
        {
//            if (regeocode)
//            {
//                NSLog(@"%@ \n %@-%@-%.2fm", regeocode.formattedAddress,regeocode.citycode, regeocode.adcode, location.horizontalAccuracy);
//            }
           
            weakSelf._longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
            weakSelf._latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
            weakSelf._cityName = [NSString stringWithFormat:@"%@",regeocode.formattedAddress];
            
            [weakSelf saveLoacationPostion:weakSelf._longitude latitude:weakSelf._latitude citycode:[NSString stringWithFormat:@"%@",regeocode.citycode]];
        }
    };
}

-(void)saveLoacationPostion:(NSString *)longitude latitude:(NSString *)latitude citycode:(NSString *)citycode
{
    NSDictionary *dic = @{@"longitude":longitude,
                          @"latitude":latitude,
                          @"citycode":citycode};
    if ([[Tool urlIsNull:longitude] length] > 0 &&
        [[Tool urlIsNull:latitude] length] > 0 &&
        [[Tool urlIsNull:citycode] length] > 0)
    {
        [Config saveLocationInfo:dic];
    }
}

- (void)configLocationManager
{
    self._locationManager = [[AMapLocationManager alloc] init];
    [self._locationManager setDelegate:self];
    //设置期望定位精度
    [self._locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //设置不允许系统暂停定位
    [self._locationManager setPausesLocationUpdatesAutomatically:NO];
    //设置允许在后台定位
    [self._locationManager setAllowsBackgroundLocationUpdates:NO];
    //设置定位超时时间
    [self._locationManager setLocationTimeout:6];
    //设置逆地理超时时间
    [self._locationManager setReGeocodeTimeout:3];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [Tool hideTabBar];
    _isOpen = FALSE;
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self stopScanning];
  [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  _previewLayer.frame = self.view.bounds;
}

- (BOOL)shouldAutorotate
{
  return YES;
}

- (void)scanAnimate
{
    _imgLine.frame = CGRectMake(0, _cameraView.innerViewRect.origin.y, mainWidth, 12);
    [UIView animateWithDuration:2 animations:^{
        _imgLine.frame = CGRectMake(_imgLine.frame.origin.x, _imgLine.frame.origin.y + _cameraView.innerViewRect.size.height - 6, _imgLine.frame.size.width, _imgLine.frame.size.height);
    }];
}

- (void)loadView:(CGRect)rect
{
    _imgLine.frame = CGRectMake(0, _cameraView.innerViewRect.origin.y, mainWidth, 12);
    [self scanAnimate];
}

#pragma mark - Managing the Orientation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
  
  [_cameraView setNeedsDisplay];
  
  if (self.previewLayer.connection.isVideoOrientationSupported) {
    self.previewLayer.connection.videoOrientation = [[self class] videoOrientationFromInterfaceOrientation:toInterfaceOrientation];
  }
}

+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  switch (interfaceOrientation) {
    case UIInterfaceOrientationLandscapeLeft:
      return AVCaptureVideoOrientationLandscapeLeft;
    case UIInterfaceOrientationLandscapeRight:
      return AVCaptureVideoOrientationLandscapeRight;
    case UIInterfaceOrientationPortrait:
      return AVCaptureVideoOrientationPortrait;
    default:
      return AVCaptureVideoOrientationPortraitUpsideDown;
  }
}

#pragma mark - Managing the Block

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock
{
    self.completionBlock = completionBlock;
}

#pragma mark - Initializing the AV Components

- (void)setupUIComponentsWithCancelButtonTitle:(NSString *)cancelButtonTitle
{
    self.cameraView                                       = [[QRCodeReaderView alloc] init];
    _cameraView.translatesAutoresizingMaskIntoConstraints = NO;
    _cameraView.clipsToBounds                             = YES;
    _cameraView.delegate                                  = self;
    [self.view addSubview:_cameraView];

    self.cancelButton                                       = [[UIButton alloc] init];
    self.cancelButton.hidden                                = YES;
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    
    
    CGFloat c_width = mainWidth - 100;
    CGFloat s_height = mainHeight - 40;
    CGFloat y = (s_height - c_width) / 2 - s_height / 6;
    
    //返回按钮
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(15, 44/2, 40, 40)];
    [btnBack setImage:[UIImage imageNamed:@"btn_QRBack.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(onButtonMainView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    //开关灯
    _btnOpenCloseFlashlight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-55, 44/2, 40, 40)];
    [_btnOpenCloseFlashlight setImage:[UIImage imageNamed:@"btn_QRCloseFlashlight.png"] forState:UIControlStateNormal];
    [_btnOpenCloseFlashlight addTarget:self action:@selector(onButtonOpenCloseLight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnOpenCloseFlashlight];

    //相册
    UIButton *btnOpenAlbum = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-105, 44/2, 40, 40)];
    [btnOpenAlbum setImage:[UIImage imageNamed:@"btn_QROpenAlbum.png"] forState:UIControlStateNormal];
    [btnOpenAlbum addTarget:self action:@selector(onButtonAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOpenAlbum];

    UILabel *labelQRTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 68/2, SCREEN_WIDTH, 17)];
    [labelQRTitle setText:@"二维码"];
    [labelQRTitle setTextColor:RGBA(255, 255, 255,1)];
    [labelQRTitle setFont:MKBOLDFONT(17)];
    [labelQRTitle setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:labelQRTitle];
    
    _lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0,y + 90 + c_width, mainWidth, 15)];
    _lblTip.text = @"将二维码放入框内，即可自动扫描";
    _lblTip.textColor = RGBA(255, 255, 255,0.6);
    _lblTip.font = MKFONT(12);
    _lblTip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lblTip];
    
    CGFloat corWidth = 25;
    
    UIImageView* img1 = [[UIImageView alloc] initWithFrame:CGRectMake(49.5, y + 78, corWidth, corWidth)];
    img1.image = [UIImage imageNamed:@"cor1.png"];
    [self.view addSubview:img1];
    
    UIImageView* img2 = [[UIImageView alloc] initWithFrame:CGRectMake(25 + c_width, y + 78, corWidth, corWidth)];
    img2.image = [UIImage imageNamed:@"cor2.png"];
    [self.view addSubview:img2];
    
    UIImageView* img3 = [[UIImageView alloc] initWithFrame:CGRectMake(49.5, y + c_width + 54, corWidth, corWidth)];
    img3.image = [UIImage imageNamed:@"cor3.png"];
    [self.view addSubview:img3];
    
    UIImageView* img4 = [[UIImageView alloc] initWithFrame:CGRectMake(25 + c_width, y + c_width + 54, corWidth, corWidth)];
    img4.image = [UIImage imageNamed:@"cor4.png"];
    [self.view addSubview:img4];
    
    
    _imgLine = [[UIImageView alloc] init];
    _imgLine.image = [UIImage imageNamed:@"image_QRScan.png"];
    [self.view addSubview:_imgLine];
    
}

#pragma mark 开关灯
-(void) onButtonOpenCloseLight
{
    if (_isOpen)
    {
        [MobClick event:mainViewbtn4];
        [self turnOffLed];
    }
    else
    {
        [MobClick event:mainViewbtn3];
        [self turnOnLed];
    }
}

-(void)turnOnLed
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOn];
        [device unlockForConfiguration];
        _isOpen = TRUE;
        [_btnOpenCloseFlashlight setImage:[UIImage imageNamed:@"btn_QROpenFlashlight.png"] forState:UIControlStateNormal];
    }
}

-(void)turnOffLed
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        [device unlockForConfiguration];
        _isOpen = FALSE;
        [_btnOpenCloseFlashlight setImage:[UIImage imageNamed:@"btn_QRCloseFlashlight.png"] forState:UIControlStateNormal];
    }
}

#pragma mark 返回主页
-(void)onButtonMainView
{
    [MobClick event:mainViewbtn5];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupAutoLayoutConstraints
{
  NSDictionary *views = NSDictionaryOfVariableBindings(_cameraView, _cancelButton);
  
  [self.view addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView][_cancelButton(0)]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:
   [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_cancelButton]-|" options:0 metrics:nil views:views]];
  
  if (_switchCameraButton) {
    NSDictionary *switchViews = NSDictionaryOfVariableBindings(_switchCameraButton);
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_switchCameraButton(50)]" options:0 metrics:nil views:switchViews]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_switchCameraButton(70)]|" options:0 metrics:nil views:switchViews]];
  }
}

- (void)setupAVComponents
{
  self.defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  
  if (_defaultDevice) {
    self.defaultDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_defaultDevice error:nil];
    self.metadataOutput     = [[AVCaptureMetadataOutput alloc] init];
    self.session            = [[AVCaptureSession alloc] init];
    self.previewLayer       = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
      if (device.position == AVCaptureDevicePositionFront) {
        self.frontDevice = device;
      }
    }
    
    if (_frontDevice) {
      self.frontDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_frontDevice error:nil];
    }
  }
}

- (void)configureDefaultComponents
{
  [_session addOutput:_metadataOutput];
  
  if (_defaultDeviceInput) {
    [_session addInput:_defaultDeviceInput];
  }
  
  [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
  if ([[_metadataOutput availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]) {
    [_metadataOutput setMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode ]];
  }
  [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
  [_previewLayer setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  
  if ([_previewLayer.connection isVideoOrientationSupported]) {
    
      _previewLayer.connection.videoOrientation = [[self class] videoOrientationFromInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
  }
}

- (void)switchDeviceInput
{
  if (_frontDeviceInput) {
    [_session beginConfiguration];
    
    AVCaptureDeviceInput *currentInput = [_session.inputs firstObject];
    [_session removeInput:currentInput];
    
    AVCaptureDeviceInput *newDeviceInput = (currentInput.device.position == AVCaptureDevicePositionFront) ? _defaultDeviceInput : _frontDeviceInput;
    [_session addInput:newDeviceInput];
    
    [_session commitConfiguration];
  }
}

#pragma mark - Catching Button Events

- (void)cancelAction:(UIButton *)button
{
  [self stopScanning];
  
  if (_completionBlock) {
    _completionBlock(nil);
  }
  
  if (_delegate && [_delegate respondsToSelector:@selector(readerDidCancel:)]) {
    [_delegate readerDidCancel:self];
  }
}

- (void)switchCameraAction:(UIButton *)button
{
  [self switchDeviceInput];
}

#pragma mark - Controlling Reader

- (void)startScanning;
{
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
    
    if(_timerScan)
    {
        [_timerScan invalidate];
        _timerScan = nil;
    }
    
    _timerScan = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scanAnimate) userInfo:nil repeats:YES];
}

- (void)stopScanning;
{
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
    if(_timerScan)
    {
        [_timerScan invalidate];
        _timerScan = nil;
    }
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate Methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for(AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]
            && [current.type isEqualToString:AVMetadataObjectTypeQRCode])
        {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];

            [self stopScanning];

            if (_completionBlock) {
                [_beepPlayer play];
                _completionBlock(scannedResult);
            }

            if (_delegate && [_delegate respondsToSelector:@selector(reader:didScanResult:)])
            {
                [self.navigationController popViewControllerAnimated:YES];
                [_delegate reader:self didScanResult:scannedResult];
                [self addScanLog:scannedResult];
            }

            break;
        }
    }
}

#pragma mark 记录扫描结果
-(void)addScanLog:(NSString *)scannedResult
{
    [ServicesSystem addScanLog:self._cityName latitude:self._latitude longitude:self._longitude scanContent:scannedResult mdoel:^(RequestResult *model)
    {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Checking the Metadata Items Types
+ (BOOL)isAvailable
{
  @autoreleasepool {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (!captureDevice) {
      return NO;
    }
    
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!deviceInput || error) {
      return NO;
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    if (![output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
      return NO;
    }
    
    return YES;
  }
}

#pragma mark - Checking RightBarButtonItem
-(void)onButtonAlbum
{
    [MobClick event:mainViewbtn2];
    if(SYSTEMVERSION >= 8){
        self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracy }];
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- ( void )imagePickerController:( UIImagePickerController *)picker didFinishPickingMediaWithInfo:( NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //返回到登录页电池条变色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if(SYSTEMVERSION >= 8){
        NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >=1) {
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            if (_completionBlock) {
                [_beepPlayer play];
                _completionBlock(scannedResult);
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(reader:didScanResult:)])
            {
                 [self.navigationController popViewControllerAnimated:YES];
                [_delegate reader:self didScanResult:scannedResult];
            }
        }

    }
    else{
        CGImageRef imageToDecode = image.CGImage;
        
        ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
        ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
        
        NSError *error = nil;
        
        ZXDecodeHints *hints = [ZXDecodeHints hints];
        
        ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
        ZXResult *result = [reader decode:bitmap
                                    hints:hints
                                    error:&error];
        
        //NSLog(@"%@",result);
        NSString* scannedResult = [NSString stringWithFormat:@"%@",result];
        if (_completionBlock) {
            [_beepPlayer play];
            _completionBlock(scannedResult);
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(reader:didScanResult:)])
        {
            [self.navigationController popViewControllerAnimated:YES];
            [_delegate reader:self didScanResult:scannedResult];
        }
    }
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
@end
