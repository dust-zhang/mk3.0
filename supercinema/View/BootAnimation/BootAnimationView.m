//
//  BootAnimationView.m
//  supercinema
//
//  Created by dust on 16/11/23.
//
//

#import "BootAnimationView.h"
#import "UserModel.h"

@implementation BootAnimationView


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        _longitude = @"";
        _latitude = @"";
        [self getLocalCoordinate];
        [self loadkeepLoginAPI];
        [self getSystemConfig];
        self.frame = frame;
        [self startVideoPlay];

        UIButton *btnClose = [[UIButton alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 20, 40, 40)];
        [btnClose setTitle:@"跳过" forState:UIControlStateNormal];
        [btnClose.titleLabel setFont:MKFONT(13)];
        [btnClose.layer setCornerRadius:20 ];
        [btnClose.layer setMasksToBounds:YES];
        [btnClose setBackgroundColor:RGBA(0, 0, 0, 0.5)];
        [btnClose addTarget:self action:@selector(moviePlayFinish) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnClose];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rePlayMovie) name:NOTIFITION_CONTINUEPLAY   object:nil];
        
//        [self addCinemaBrowsingHistory:[Config getCinemaId] ];
        
    }
    return self;
}

#pragma mark 切换影院记录
-(void) addCinemaBrowsingHistory:(NSString *)cinemaId
{
    if ([cinemaId length] > 0 )
    {
        [ServicesCinema addCinemaBrowseRecord:@"" longitude:@"" lastVisitCinemaId:cinemaId model:^(RequestResult *model) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void) loadkeepLoginAPI
{
    [ServicesUser keepLogin:_longitude latitude:_latitude lastVisitCinemaId:[Config getCinemaId] model:^(RequestResult *headModel)
    {
        [Config saveCredential:headModel.loginResult.credential];
        [Config saveUserType:[headModel.loginResult.passportType stringValue]];
       
    } failure:^(NSError *error) {
         
    }];

}

#pragma mark - 定位获取本地坐标
-(void)getLocalCoordinate
{
    if (!self._locationMgr)
    {
        //定位功能可用，开始定位
        self._locationMgr = [[CLLocationManager alloc] init];
        self._locationMgr.delegate = self;
        // 设置定位精度
        self._locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
        self._locationMgr.distanceFilter = 100.0f;
        if(SYSTEMVERSION >= 8)
        {
            [self._locationMgr requestWhenInUseAuthorization];
        }
    }
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled])
    {
        if (status != kCLAuthorizationStatusDenied)
        {
            [self._locationMgr startUpdatingLocation];
        }
    }
}

#pragma mark - 获取定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self._locationMgr stopUpdatingLocation];
    CLLocation *cl = [locations objectAtIndex:0];
    self._localCoordinate = cl.coordinate;
    
    _longitude = [NSString stringWithFormat:@"%f",self._localCoordinate.longitude];
    _latitude = [NSString stringWithFormat:@"%f",self._localCoordinate.latitude];
}


// 获取定位失败回调方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self._locationMgr stopUpdatingLocation];
    self._locationMgr = nil;
}


#pragma mark 获取系统配置
-(void)getSystemConfig
{
    [ServicesSystem  getSystemConfig:[Config getDeviceToken] clientId:[Config getGeTuiId] model:^(RequestResult *model)
    {
         
    } failure:^(NSError *error) {
         
    }];
}

-(void)startVideoPlay
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"startVideo" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:file];
    
    self._startPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayFinish)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self._startPlayer];
    // play movie
    self._startPlayer.controlStyle = MPMovieControlStyleNone;
    self._startPlayer.shouldAutoplay = YES;
    self._startPlayer.repeatMode = MPMovieRepeatModeNone;
    [self._startPlayer setFullscreen:YES animated:YES];
    self._startPlayer.scalingMode = MPMovieScalingModeAspectFill;
    [self._startPlayer.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self addSubview:self._startPlayer.view];
    [self._startPlayer play];
}

-(void)rePlayMovie
{
    if (self._startPlayer)
    {
        [self._startPlayer play];
    }
}

-(void)moviePlayFinish
{
    [self._startPlayer stop];
    [self._startPlayer.view removeFromSuperview];
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_LOADSYSTEMNOTICE object:nil];
}

- (void)dealloc
{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_CONTINUEPLAY];
    [[NSNotificationCenter defaultCenter] removeObserver:MPMoviePlayerPlaybackDidFinishNotification];
}


@end
