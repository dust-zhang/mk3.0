//
//  ShareCardView.m
//  supercinema
//
//  Created by mapollo91 on 12/4/17.
//
//

#import "ShareCardView.h"
#import "ThirdShareFactory.h"

@implementation ShareCardView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    if (self)
    {
        self.frame = frame;
        _isClickBlank = NO;
    }
    return self;
}

-(void)drawView
{
    /*******关闭按钮*******/
    UIButton *btnClose = [[UIButton alloc ] initWithFrame:CGRectMake(0, 27, 94/2, 60/2)];
    [btnClose setImage:[UIImage imageNamed:@"btn_closeWhite.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(onButtonCloseView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClose];
    
    /*******分享内容*******/
    _scrollViewContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _scrollViewContent.backgroundColor = [UIColor clearColor];
    _scrollViewContent.delegate = self;
    [self addSubview:_scrollViewContent];
    
    //整体的View背景
     _viewOverallBG = [self.delegate shareCardView];
    _viewOverallBG.frame = CGRectMake(35, SCREEN_HEIGHT, _viewOverallBG.frame.size.width, _viewOverallBG.frame.size.height);
    [_scrollViewContent addSubview:_viewOverallBG];
    
    //添加点击事件（点击空白收起分享）
    UITapGestureRecognizer *clickBlank = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPackUpShare:)];
    [clickBlank setNumberOfTapsRequired:1];//点击一次
    clickBlank.delegate = self;
    clickBlank.cancelsTouchesInView = NO;//设置可点击
    [self addGestureRecognizer:clickBlank];
    
    /*******保存 & 分享*******/
    //保存 & 分享背景
    _viewSaveShareBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];//SCREEN_HEIGHT-44
    _viewSaveShareBG.backgroundColor = [UIColor blackColor];
    [self addSubview:_viewSaveShareBG];
    
    //保存按钮
    UIButton *btnSaveShare = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    btnSaveShare.backgroundColor = [UIColor clearColor];
    [btnSaveShare setTitle:@"保存" forState:UIControlStateNormal];
    [btnSaveShare setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    [btnSaveShare .titleLabel setFont:MKFONT(15)];//按钮字体大小
    [btnSaveShare addTarget:self action:@selector(onButtonSaveShare:) forControlEvents:UIControlEventTouchUpInside];
    [_viewSaveShareBG addSubview:btnSaveShare];
    
    //分享
    UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-81, 0, 80, 44)];
    btnShare.backgroundColor = [UIColor clearColor];
    [btnShare setTitle:@"分享" forState:UIControlStateNormal];
    [btnShare setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    [btnShare .titleLabel setFont:MKFONT(15)];//按钮字体大小
    [btnShare addTarget:self action:@selector(onButtonBounceShare) forControlEvents:UIControlEventTouchUpInside];
    [_viewSaveShareBG addSubview:btnShare];
    
    /*******分享到*******/
    //分享到...
    float fShareTypeMargin; //分享按钮边距
    float fButtonTypeSize;  //分享按钮宽高比例
    float fLabelShareToMargin;  //分享标签间距
    float fLabelLineMargin;     //分享分割线间距
    float fBtnCancelHeight;     //分享取消按钮的高
    
    _fViewShareToBGHeight = 0;  //分享背景高度
    if (IPhone5)
    {
        fShareTypeMargin = 40.5;
        fButtonTypeSize = 34.5;
        fLabelShareToMargin = 17;
        fLabelLineMargin = 25;
        fBtnCancelHeight = 45;
        _fViewShareToBGHeight = 156;
    }
    else if (IPhone6plus)
    {
        fShareTypeMargin = 157/3;
        fButtonTypeSize = 133/3;
        fLabelShareToMargin = 66/3;
        fLabelLineMargin = 100/3;
        fBtnCancelHeight = 88/3+15;
        _fViewShareToBGHeight = (66+66+133+100+1+44+44)/3+17+15;
    }
    else
    {
        fShareTypeMargin = 47.5;
        fButtonTypeSize = 40;
        fLabelShareToMargin = 20;
        fLabelLineMargin = 30;
        fBtnCancelHeight= 45;
        _fViewShareToBGHeight = 172.5;
    }
    
    //分享到背景
    _viewShareToBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _fViewShareToBGHeight)];
    _viewShareToBG.backgroundColor = [UIColor whiteColor];
    [self addSubview:_viewShareToBG];
    
    //渐变蒙层
    _imageShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 6)];
    _imageShadow.backgroundColor = [UIColor clearColor];
    _imageShadow.image = [UIImage imageNamed:@"img_shadowPosterShare.png"];
    [self addSubview:_imageShadow];
    
    //分享到标签
    UILabel *labelShareTo = [[UILabel alloc] initWithFrame:CGRectMake(0, fLabelShareToMargin, _viewShareToBG.frame.size.width, 17)];
    labelShareTo.backgroundColor = [UIColor clearColor];
    [labelShareTo setFont:MKFONT(17)];
    [labelShareTo setTextColor:RGBA(51, 51, 51, 1)];
    [labelShareTo setTextAlignment:NSTextAlignmentCenter];
    [labelShareTo setText:@"分享到"];
    [_viewShareToBG addSubview:labelShareTo];
    
    //分享到滑动
    UIScrollView *scrollViewShareTo = [[UIScrollView alloc] initWithFrame:CGRectMake(0, labelShareTo.frame.origin.y+labelShareTo.frame.size.height, SCREEN_WIDTH, fLabelShareToMargin+fButtonTypeSize+fLabelLineMargin)];
    scrollViewShareTo.backgroundColor = [UIColor clearColor];
    scrollViewShareTo.delegate = self;
    //    scrollViewShareTo.pagingEnabled = YES;
    [scrollViewShareTo setShowsHorizontalScrollIndicator:NO];//隐藏滚动条
    [_viewShareToBG addSubview:scrollViewShareTo];
    
    //分享按钮间隙
    float fBtnMargin;
    fBtnMargin = (scrollViewShareTo.frame.size.width-fShareTypeMargin*2-fButtonTypeSize*5)/4;
    
    //分享按钮
    NSArray *arrShareImage = @[@"button_shareSolid_weichat.png",@"button_shareSolid_weichat_friend.png",@"button_shareSolid_weibo.png",@"button_shareSolid_qq_friend.png",@"button_shareSolid_qzone.png"];
    for (int i=0; i<5; i++)
    {
        UIButton *btnShareType = [[UIButton alloc] initWithFrame:CGRectMake(fShareTypeMargin+i*(fButtonTypeSize+fBtnMargin), fLabelShareToMargin, fButtonTypeSize, fButtonTypeSize)];
        btnShareType.backgroundColor=[UIColor clearColor];
        [btnShareType setImage:[UIImage imageNamed:arrShareImage[i]] forState:UIControlStateNormal];
        [btnShareType.imageView setContentMode:UIViewContentModeScaleAspectFit];
        btnShareType.tag = i;
        [btnShareType addTarget:self action:@selector(onButtonShare:) forControlEvents:UIControlEventTouchUpInside];
        [scrollViewShareTo addSubview:btnShareType];
    }
    scrollViewShareTo.contentSize = CGSizeMake(scrollViewShareTo.frame.size.width, scrollViewShareTo.frame.size.height);
    
    //可滑动并且居中
    //    scrollViewShareTo.contentSize = CGSizeMake(47.5+60*5+27.5, scrollViewShareTo.frame.size.height);
    //    if (scrollViewShareTo.contentSize.width > SCREEN_WIDTH)z
    //    {
    //        [scrollViewShareTo setContentOffset:CGPointMake((scrollViewShareTo.contentSize.width-SCREEN_WIDTH)/2,0) animated:YES];
    //    }
    
    //分割线
    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, scrollViewShareTo.frame.origin.y+scrollViewShareTo.frame.size.height, _viewShareToBG.frame.size.width, 0.5)];
    labelLine.backgroundColor = RGBA(0, 0, 0, 0.05);
    [_viewShareToBG addSubview:labelLine];
    
    //取消按钮
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, labelLine.frame.origin.y+labelLine.frame.size.height, _viewShareToBG.frame.size.width, fBtnCancelHeight)];
    btnCancel.backgroundColor = [UIColor clearColor];
    [btnCancel setTitle:@"收起" forState:UIControlStateNormal];
    [btnCancel .titleLabel setFont:MKFONT(15)];
    [btnCancel setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(onButtonCancel) forControlEvents:UIControlEventTouchUpInside];
    [_viewShareToBG addSubview:btnCancel];
    
    //计算滑动内容高度
    _scrollViewContent.contentSize = CGSizeMake(_scrollViewContent.frame.size.width, _viewOverallBG.frame.size.height+230);
}

#pragma mark 分享按钮
-(void)onButtonShare:(UIButton*)sender
{
    UIImage *imageShare = [self bulidShareImage];
    shareType type = [ThirdShareFactory getShareType:sender.tag];
    BaseShare *baseShare = [ThirdShareFactory getShareInstance:type];
    if(baseShare == nil){
        [Tool showWarningTip:@"分享类型不存在" time:2];
        return;
    }
    [baseShare shareImage:imageShare];
}

#pragma mark 点击了空白
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

-(void)onPackUpShare:(UITapGestureRecognizer *)sender
{
    //收起分享到
    if (_isClickBlank)
    {
        //弹出
        [self onButtonBounceShare];
    }
    else
    {
        //收起
        [self onButtonPackUpShare];
    }
}

#pragma mark 生成图片
-(UIImage *)bulidShareImage
{
    if ([self.delegate respondsToSelector:@selector(hideShareViewSubview:)])
    {
        [self.delegate hideShareViewSubview:(_viewOverallBG)];
    }

    UIImage *imageShare = [ImageOperation makeImageWithView:_viewOverallBG];
    if ([self.delegate respondsToSelector:@selector(showShareViewSubview:)])
    {
        [self.delegate showShareViewSubview:(_viewOverallBG)];
    }
    return imageShare;
}

#pragma mark 保存分享
-(void)onButtonSaveShare:(UIButton *)sender
{
    UIImage *imageShare = [self bulidShareImage];
    
    UIImageWriteToSavedPhotosAlbum(imageShare, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"无法保存：请在\"设置-隐私-相片\"选项中，允许超级电影院访问您的照片。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    }
    else
    {
        [Tool showSuccessTip:@"保存图片成功" time:2];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark 取消按钮
-(void)onButtonCancel
{
    NSLog(@"点击了取消");
    //收起分享
    [self onButtonPackUpShare];
}

#pragma mark 弹起 - 整个View
-(void)bounceViews
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         _viewOverallBG.frame = CGRectMake(_viewOverallBG.frame.origin.x, 36, _viewOverallBG.frame.size.width, _viewOverallBG.frame.size.height);
                         
                     }completion:^(BOOL finish){
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              _viewShareToBG.frame = CGRectMake(0, SCREEN_HEIGHT-_fViewShareToBGHeight, SCREEN_WIDTH, _fViewShareToBGHeight);
                                              _imageShadow.frame = CGRectMake(0, SCREEN_HEIGHT-_fViewShareToBGHeight-6, SCREEN_WIDTH, 6);
                                              _viewSaveShareBG.frame = CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44);
                                              
                                          }completion:^(BOOL finish){
                                              
                                          }];
                     }];
}

#pragma mark 收起 - 整个View
-(void)packUpViews
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5
                     animations:^{
                         _viewShareToBG.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _fViewShareToBGHeight);
                         _imageShadow.frame = CGRectMake(0, SCREEN_HEIGHT-6, SCREEN_WIDTH, 6);
                         _viewSaveShareBG.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
                         
                     }completion:^(BOOL finish){
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              _viewOverallBG.frame = CGRectMake(_viewOverallBG.frame.origin.x, SCREEN_HEIGHT, _viewOverallBG.frame.size.width, _viewOverallBG.frame.size.height);
                                              
                                          }completion:^(BOOL finish){
                                              [UIView animateWithDuration:0.2
                                                               animations:^{
                                                                   weakSelf.transform = CGAffineTransformMakeScale(1.3, 1.3);
                                                                   weakSelf.alpha=0;
                                                                   
                                                               }completion:^(BOOL finish){
                                                                   [weakSelf removeFromSuperview];
                                                                   
                                                                   if ([weakSelf.delegate respondsToSelector:@selector(cancelView)])
                                                                   {
                                                                       [weakSelf.delegate cancelView];
                                                                   }
                                                               }];
                                          }];
                     }];
}

#pragma mark 弹起 - 分享按钮类型框
-(void)onButtonBounceShare
{
    NSLog(@"点击分享");
    _isClickBlank = NO;
    //弹出分享到
    [UIView animateWithDuration:0.3
                     animations:^{
                         _viewShareToBG.frame  = CGRectMake(0, SCREEN_HEIGHT-_fViewShareToBGHeight, SCREEN_WIDTH, _fViewShareToBGHeight);
                         _imageShadow.frame = CGRectMake(0, SCREEN_HEIGHT-_fViewShareToBGHeight-6, SCREEN_WIDTH, 6);
                     }completion:^(BOOL finish){
                     }];
}

#pragma mark 收起 - 分享按钮类型框
-(void)onButtonPackUpShare
{
    _isClickBlank = YES;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _viewShareToBG.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _fViewShareToBGHeight);
                         _imageShadow.frame = CGRectMake(0, SCREEN_HEIGHT-6, SCREEN_WIDTH, 6);
                     }completion:^(BOOL finish){
                     }];
}

#pragma mark 关闭按钮
-(void)onButtonCloseView
{
    //收起View
    [self packUpViews];
}



@end
