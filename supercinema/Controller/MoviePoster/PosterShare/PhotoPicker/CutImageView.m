//
//  CutImageView.m
//  supercinema
//
//  Created by mapollo91 on 28/3/17.
//
//

#import "CutImageView.h"


@interface CutImageView ()

@end

@implementation CutImageView

-(id)initWithFrame:(CGRect)frame imageURL:(NSString *)imageBigUrl smallUrl:(NSString *)smallUrl control:(float)control nav:(UINavigationController *)nav
{
    self = [super initWithFrame:frame];
    if(self)
    {
        navigationController = nav;
        //状态栏显示
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        self.backgroundColor = [UIColor blackColor];
        _imageInBigURL = imageBigUrl;
        _imageInSmallURL = smallUrl;
        
        _fClipControl = control;
        
        [self initController];
    }
    return self;
}

-(void)initController
{
    //self.view.userInteractionEnabled = NO;
    /*==============滑动背景==============*/
    _scrollBG = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-BottomHeight)];
    _scrollBG.backgroundColor = [UIColor clearColor];
    [self addSubview:_scrollBG];
    
    /*==============需要裁剪的图片==============*/
    _imageCut = [[UIImageView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-BottomHeight-SCREEN_WIDTH)/2, SCREEN_WIDTH, SCREEN_WIDTH)];
    _imageCut.backgroundColor = [UIColor clearColor];
    _imageCut.image = [UIImage imageNamed:@"image_cutLoading_Big.png"];
    //        _imageCut.image = [UIImage imageNamed:@"image_NoDataOrder.png"];
    [_scrollBG addSubview:_imageCut];
    
    /*==============遮盖蒙层==============*/
    //顶部
    _viewTop = [[UIView alloc] initWithFrame:CGRectZero];
    _viewTop.backgroundColor = RGBA(0, 0, 0, 0.6);
    [self addSubview:_viewTop];
    
    //中间
    _labelMid = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelMid.backgroundColor = [UIColor clearColor];
    _labelMid.layer.borderColor = RGBA(255, 255, 255, 1).CGColor;
    _labelMid.layer.borderWidth = 1.0;
    //_labelMid.userInteractionEnabled = YES;
    [self addSubview:_labelMid];
    
    //下方
    _viewBottom = [[UIView alloc] initWithFrame:CGRectZero];
    _viewBottom.backgroundColor = RGBA(0, 0, 0, 0.6);
    [self addSubview:_viewBottom];
    
    /*==============下方背景==============*/
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-BottomHeight, SCREEN_WIDTH, BottomHeight)];
    viewBG.backgroundColor = RGBA(0, 0, 0, 0.7);
    [self addSubview:viewBG];
    
    //取消按钮
    _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, BottomHeight)];
    _btnCancel.backgroundColor = [UIColor clearColor];
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancel setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [_btnCancel .titleLabel setFont:MKFONT(17)];
    [_btnCancel addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [viewBG addSubview:_btnCancel];
    
    //裁剪按钮
    _btnCutImage = [[UIButton alloc] initWithFrame:CGRectMake(viewBG.frame.size.width-64, 0, 64, BottomHeight)];
    _btnCutImage.backgroundColor = [UIColor clearColor];
    [_btnCutImage setTitle:@"确定" forState:UIControlStateNormal];
    [_btnCutImage setTitleColor:RGBA(255, 255,255, 1) forState:UIControlStateNormal];
    [_btnCutImage .titleLabel setFont:MKFONT(17)];
    [_btnCutImage addTarget:self action:@selector(onButtonClipImage:) forControlEvents:UIControlEventTouchUpInside];
    [viewBG addSubview:_btnCutImage];
    
    
    __weak typeof(self) weakSelf = self;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:_imageInBigURL]
                          options:0
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            if (!error && image)
                            {
                                _imageIn = image;
                            }
                            else
                            {
                                _imageIn = [UIImage imageNamed:@"img_ticketMovie_default.png"];
                            }
                            //设置属性
                            [weakSelf setFrameAndAttribute];
                        }];
    
    //设置属性
//    [self setFrameAndAttribute];
}

-(void)setFrameAndAttribute
{
    if(_imageIn!=nil)
    {
        _imageCut.image = _imageIn;
    }
    
    if(_fClipControl==0)
    {
        _fClipControl = 1;
    }
    
    _midSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*_fClipControl);
    CGSize c = _imageCut.image.size;
    
    float img_height = c.height*SCREEN_WIDTH/c.width;
    
    _scrollBG.minimumZoomScale = 1.0f;
    _scrollBG.maximumZoomScale = 2.0f;
    _scrollBG.bouncesZoom = YES;
    _scrollBG.userInteractionEnabled = YES;
    _scrollBG.delegate = self;
    _scrollBG.showsHorizontalScrollIndicator    = NO;
    _scrollBG.showsVerticalScrollIndicator      = NO;
    
    _scrollBG.contentMode = UIViewContentModeCenter;
    _scrollBG.scrollEnabled = YES;
    _imageCut.frame = CGRectMake(0,(SCREEN_HEIGHT-BottomHeight-_midSize.height)/2, SCREEN_WIDTH, img_height);
    //滑动的距离中间的高
    _scrollBG.contentSize = CGSizeMake(SCREEN_WIDTH, img_height+(SCREEN_HEIGHT-BottomHeight-_midSize.height));
    _scrollBG.frame =  CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-BottomHeight);
    //clipsToBounds (当它取值为 YES 时，剪裁超出父视图范围的子视图部分；当它取值为 NO 时，不剪裁子视图)
    _scrollBG.clipsToBounds = NO;
    
    _viewTop.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-BottomHeight-_midSize.height)/2);
    _labelMid.frame = CGRectMake(0, (SCREEN_HEIGHT-BottomHeight-_midSize.height)/2, SCREEN_WIDTH, _midSize.height);
    _viewBottom.frame = CGRectMake(0, SCREEN_HEIGHT-BottomHeight- (SCREEN_HEIGHT-BottomHeight-_midSize.height)/2, SCREEN_WIDTH, (SCREEN_HEIGHT-BottomHeight-_midSize.height)/2);
    
    //设置滚动位置
    [_scrollBG setContentOffset:CGPointMake(0, (img_height-_midSize.height)/2) animated:NO];
}

#pragma mark 取消按钮
-(void)closeView:(UIButton *)sender
{
    [self close];
}

#pragma mark ScrollDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"viewForZoomingInScrollView");
    return _imageCut;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //        CGFloat xcenter = scrollView.center.x, ycenter = scrollView.center.y;
    //        if(xcenter>=480)
    //        {
    //            xcenter=160;
    //        }
    //        xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 :xcenter;
    //
    //        ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 :ycenter;
    //
    //        _imageCut.center = CGPointMake(xcenter, ycenter);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if(scrollView.zoomScale==1)
    {
        //        m_imageView.frame =self.bounds;
        
        CGSize c = _imageCut.image.size;
        
        float img_height = c.height*SCREEN_WIDTH/c.width;
        _scrollBG.contentSize = CGSizeMake(SCREEN_WIDTH, img_height+(SCREEN_HEIGHT-BottomHeight-_midSize.height));
    }
    else
    {
        CGSize s = _scrollBG.contentSize;
        CGSize c = _imageCut.image.size;
        
        float img_height = c.height*SCREEN_WIDTH/c.width;
        _scrollBG.contentSize = CGSizeMake(s.width,s.width/SCREEN_WIDTH*(img_height)+(SCREEN_HEIGHT-BottomHeight-_midSize.height));
    }
}

#pragma mark 确定按钮
-(void)onButtonClipImage:(UIButton *)sender
{
    [Config saveSelectImageUrl:_imageInBigURL key:@"movieShareBigUrl"];
    
    [navigationController popViewControllerAnimated:NO];
    
    if(_imageCut.image==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"原图不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIImage *image = [self screenShotAction];
    image = [self cutImage:image];
    
//    //刷新海报分享页
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:image forKey:@"returnImg"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_POSTERSHAREIMAGE object:dic];
    
    [Config saveSelectImageUrl:_imageInSmallURL key:@"movieShareSmallUrl"];
   
    if ([self.delegate respondsToSelector:@selector(CutImageDelegate:)])
    {
        [self.delegate CutImageDelegate:image];
    }
    
    [self close];
}

//进行裁剪图片
-(UIImage *)screenShotAction
{
    //先截屏
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    //写入相册
    //    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

//裁剪
- (UIImage *)cutImage:(UIImage *)image
{
    //需要裁剪的宽高范围
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(_labelMid.frame.origin.x+1, _labelMid.frame.origin.y+1, _labelMid.frame.size.width-2, _labelMid.frame.size.height-2));
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return thumbScale;
}

//修改拍摄照片的水平度不然会旋转90度
-(UIImage *)fixOrientation:(UIImage *)aImage
{
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(void)close
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if (self)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(1.3, 1.3);
                             self.alpha=0;
                         }completion:^(BOOL finish){
                             [self removeFromSuperview];
                         }];
        
    }
}


@end
