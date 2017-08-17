//
//  CinemaShareView.m
//  supercinema
//
//  Created by mapollo91 on 10/4/17.
//
//

#import "CinemaShareView.h"


#define BUTTON_TAG 2046



@implementation CinemaShareView

-(id)initWithParentView:(UIView *)parentView model:(CinemaShareInfoModel*)model cinemaName:(NSString *)cinemaName navigation:(UINavigationController *)navigation
{
    self = [super init];
    if (self)
    {
        _nav = navigation;
        [Config saveSelectImageUrl:nil key:@"cinemaShareUrl"];
        self._cinemaShareInfoModel = model;
        _cinemaName = cinemaName;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCinemaImage:) name:NOTIFITION_CINEMASHAREIMAGE object:nil];
        [self showView:parentView];
    }
    return self;
}

-(void)showView:(UIView *)parentView
{
    self._shareCardView = [[ShareCardView alloc] initWithFrame:CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height)];
    self._shareCardView.delegate = self;
    [self._shareCardView drawView];
    [parentView addSubview:self._shareCardView];

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5
                     animations:^{
                         weakSelf._shareCardView.transform = CGAffineTransformMakeScale(1, 1);
                         weakSelf._shareCardView.alpha=1;
                         
                     }completion:^(BOOL finish){
                         [weakSelf._shareCardView bounceViews];
                     }];
}

#pragma mark ShareCardViewDelegate
//画卡片View
-(UIView *)shareCardView
{
    //整体的View背景
    UIView *viewOverallBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-35*2, (SCREEN_WIDTH-35*2)/0.7)];
    viewOverallBG.backgroundColor = [UIColor whiteColor];
    
    /*====================影院信息====================*/
    //影院地址（自适应高）
    UILabel *labelCinemaAddress = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, viewOverallBG.frame.size.width-15*2, 15)];
    labelCinemaAddress.backgroundColor = [UIColor clearColor];
    [labelCinemaAddress setFont:MKBOLDFONT(15)];
    [labelCinemaAddress setTextColor:RGBA(51, 51, 51, 1)];
    [labelCinemaAddress setTextAlignment:NSTextAlignmentLeft];
    [labelCinemaAddress setText:_cinemaName];//[Config getCinemaName]
    labelCinemaAddress.numberOfLines = 0;
    labelCinemaAddress.lineBreakMode = NSLineBreakByCharWrapping;
    [labelCinemaAddress sizeToFit];
    labelCinemaAddress.frame = CGRectMake(15, 20, viewOverallBG.frame.size.width-15*2, labelCinemaAddress.frame.size.height);
    [viewOverallBG addSubview:labelCinemaAddress];
    
    //影院推荐语（自适应高_后台限制最多30个字，用户不能编辑）
    UILabel *labelCinemaReaso = [[UILabel alloc] initWithFrame:CGRectMake(labelCinemaAddress.frame.origin.x,
                                                                           labelCinemaAddress.frame.origin.y+labelCinemaAddress.frame.size.height+8,
                                                                           labelCinemaAddress.frame.size.width,
                                                                           12)];
    labelCinemaReaso.backgroundColor = [UIColor clearColor];
    [labelCinemaReaso setFont:MKFONT(12)];
    [labelCinemaReaso setTextColor:RGBA(51, 51, 51, 1)];
    [labelCinemaReaso setTextAlignment:NSTextAlignmentLeft];
    if ([self._cinemaShareInfoModel.shareTitle length] > 0)
    {
        [labelCinemaReaso setText:self._cinemaShareInfoModel.shareTitle];
    }
    else
    {
        [labelCinemaReaso setText:@"我发现了一家很棒的影院哦！"];
    }
    labelCinemaReaso.numberOfLines = 0;
    labelCinemaReaso.lineBreakMode = NSLineBreakByCharWrapping;
    [labelCinemaReaso sizeToFit];
    labelCinemaReaso.frame = CGRectMake(labelCinemaAddress.frame.origin.x,
                                         labelCinemaAddress.frame.origin.y+labelCinemaAddress.frame.size.height+8,
                                         labelCinemaAddress.frame.size.width,
                                         labelCinemaReaso.frame.size.height);
    [viewOverallBG addSubview:labelCinemaReaso];
    
    /*====================影院海报信息====================*/
    //黑色背景
    self._viewBlackBG = [[UIView alloc] initWithFrame:CGRectMake(labelCinemaAddress.frame.origin.x,
                                                                 labelCinemaReaso.frame.origin.y+labelCinemaReaso.frame.size.height+15,
                                                                 viewOverallBG.frame.size.width-15*2,
                                                                 viewOverallBG.frame.size.width-15*2)];
    self._viewBlackBG.backgroundColor = [UIColor blackColor];
    [viewOverallBG addSubview:self._viewBlackBG];
    
    //图片海报
    self._imagePoster = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self._viewBlackBG.frame.size.width, self._viewBlackBG.frame.size.height)];
    self._imagePoster.backgroundColor = [UIColor clearColor];
    self._imagePoster.userInteractionEnabled = YES;//图片可以响应点击事件
    [self._viewBlackBG addSubview:self._imagePoster];
    UIImage *defaultImg = [UIImage imageNamed:@"img_cinemaShare_defaultBig.png"];
    //海报
    if([self._cinemaShareInfoModel.shareImage length] > 0)
    {
        __weak typeof(self) weakSelf = self;
        [self._imagePoster sd_setImageWithURL:[NSURL URLWithString:[Tool urlIsNull:self._cinemaShareInfoModel.shareImage]] placeholderImage:defaultImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGRect targetRect = [ImageOperation imageViewSize:image.size cutImageSize:weakSelf._viewBlackBG.frame.size];
            UIImage *resultImage = [ImageOperation cutImageNew:image cutFrame:targetRect];
            weakSelf._imagePoster.image = resultImage;
            weakSelf._imagePoster.frame = CGRectMake(0, 0, weakSelf._viewBlackBG.frame.size.width,
                                            weakSelf._viewBlackBG.frame.size.height);
        }];
    }
    else
    {
        [self._imagePoster setImage:defaultImg];
    }
    
    //添加点击事件（点击海报更换图片）
    UITapGestureRecognizer *clickPoster = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPackUpChangePoster:)];
    [clickPoster setNumberOfTapsRequired:1];//点击一次
    clickPoster.delegate = self;
    clickPoster.cancelsTouchesInView = NO;//设置可点击
    [self._viewBlackBG addGestureRecognizer:clickPoster];
    
    //蒙层
    UIView *viewPosterCover = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, self._imagePoster.frame.size.width, self._imagePoster.frame.size.height)];
    viewPosterCover.backgroundColor = RGBA(0, 0, 0, 0.1);
    [self._viewBlackBG addSubview:viewPosterCover];
    
    //改变图片按钮
    UIButton *btnChangePoster = [[UIButton alloc] initWithFrame:CGRectMake(self._imagePoster.frame.size.width-10-40, 7, 40, 40)];
    btnChangePoster.backgroundColor = [UIColor clearColor];
    btnChangePoster.tag = BUTTON_TAG;
    btnChangePoster.hidden = NO;
    btnChangePoster.layer.masksToBounds = YES;
    [btnChangePoster.layer setCornerRadius:20.f];  //设置圆角
    [btnChangePoster setBackgroundImage:[UIImage imageNamed:@"btn_changeImage.png"] forState:UIControlStateNormal];
    [self._viewBlackBG addSubview:btnChangePoster];
    
    /*====================日期 & 节假日====================*/
    //日期 & 节假日背景
    UIView *viewShareReasonBG = [[UIView alloc] initWithFrame:CGRectMake(15,
                                                                         self._viewBlackBG.frame.origin.y+self._viewBlackBG.frame.size.height+15,
                                                                         viewOverallBG.frame.size.width-15*2,
                                                                         52)];
    viewShareReasonBG.backgroundColor = RGBA(254, 254, 255, 1);
    viewShareReasonBG.layer.borderWidth = 0.5;
    viewShareReasonBG.layer.borderColor = [RGBA(0, 0, 0, 0.1) CGColor];
    [viewOverallBG addSubview:viewShareReasonBG];
    
    //日期
    UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, viewShareReasonBG.frame.size.width/2, 12)];
    labelDate.backgroundColor = [UIColor clearColor];
    [labelDate setFont:MKFONT(12)];
    [labelDate setTextColor:RGBA(123, 122, 152, 1)];
    [labelDate setTextAlignment:NSTextAlignmentLeft];
    [labelDate setText:[Tool returnTime:self._cinemaShareInfoModel.currentTime format:@"yyyy年MM月dd日"]];
    [viewShareReasonBG addSubview:labelDate];
    
    //星期
    UILabel *labelWeek = [[UILabel alloc] initWithFrame:CGRectMake(labelDate.frame.origin.x,
                                                                   labelDate.frame.origin.y+labelDate.frame.size.height+7,
                                                                   labelDate.frame.size.width,
                                                                   12)];
    labelWeek.backgroundColor = [UIColor clearColor];
    [labelWeek setFont:MKFONT(12)];
    [labelWeek setTextColor:RGBA(123, 122, 152, 1)];
    [labelWeek setTextAlignment:NSTextAlignmentLeft];
    [labelWeek setText:[Tool returnWeekFullName:self._cinemaShareInfoModel.currentTime]];
    [viewShareReasonBG addSubview:labelWeek];
    
    //节假日
    UILabel *labelFestival = [[UILabel alloc] initWithFrame:CGRectMake(viewShareReasonBG.frame.size.width/2, (viewShareReasonBG.frame.size.height-17)/2, viewShareReasonBG.frame.size.width/2-15, 17)];
    labelFestival.backgroundColor = [UIColor clearColor];
    [labelFestival setFont:MKFONT(17)];
    [labelFestival setTextColor:RGBA(51, 51, 51, 1)];
    [labelFestival setTextAlignment:NSTextAlignmentRight];
    [labelFestival setText:self._cinemaShareInfoModel.holiday];
    [viewShareReasonBG addSubview:labelFestival];
    
    /*====================二维码背景区域====================*/
    //二维码背景
    UIView *viewQRCodeBG = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    viewShareReasonBG.frame.origin.y+viewShareReasonBG.frame.size.height+13.5,
                                                                    viewOverallBG.frame.size.width,
                                                                    100/2)];
    viewQRCodeBG.backgroundColor = [UIColor clearColor];
    [viewOverallBG addSubview:viewQRCodeBG];
    
    //二维码Logo
    UIImageView *imageQRCode = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 100/2, 100/2)];
    imageQRCode.backgroundColor = [UIColor clearColor];
    [viewQRCodeBG addSubview:imageQRCode];
    
    if (![Config getLoginState])
    {
        imageQRCode.image = [DrawShareImage encodeQRImageWithContent:[NSString stringWithFormat:@"http://m.movikr.com/?cinemaId=%@&source=app&",[Config getCinemaId]] size:CGSizeMake(200/2, 200/2)];
    }
    else
    {
        imageQRCode.image = [DrawShareImage encodeQRImageWithContent:[NSString stringWithFormat:@"http://m.movikr.com/?cinemaId=%@&source=app&userid=%@",
                                                                    [Config getCinemaId],[Config getUserId]] size:CGSizeMake(200/2, 200/2)];
    }
 
    //二维码说明
    UILabel *labelQRCodeDescribe = [[UILabel alloc] initWithFrame:CGRectMake(imageQRCode.frame.origin.x+imageQRCode.frame.size.width+8,
                                                                             7.5,
                                                                             viewQRCodeBG.frame.size.width-15*2-imageQRCode.frame.size.width-10,
                                                                             15)];
    labelQRCodeDescribe.backgroundColor = [UIColor clearColor];
    [labelQRCodeDescribe setFont:MKFONT(15)];
    [labelQRCodeDescribe setTextColor:RGBA(51, 51, 51, 1)];
    [labelQRCodeDescribe setTextAlignment:NSTextAlignmentLeft];
    [labelQRCodeDescribe setText:@"获取影院新鲜资讯"];
    [viewQRCodeBG addSubview:labelQRCodeDescribe];
    
    //二维码提示
    UILabel *labelQRCodeHint = [[UILabel alloc] initWithFrame:CGRectMake(labelQRCodeDescribe.frame.origin.x,
                                                                         labelQRCodeDescribe.frame.origin.y+labelQRCodeDescribe.frame.size.height+9,
                                                                         labelQRCodeDescribe.frame.size.width*0.58,
                                                                         12)];
    labelQRCodeHint.backgroundColor = [UIColor clearColor];
    [labelQRCodeHint setFont:MKFONT(12)];
    [labelQRCodeHint setTextColor:RGBA(123, 122, 152, 1)];
    [labelQRCodeHint setTextAlignment:NSTextAlignmentLeft];
    [labelQRCodeHint setText:@"扫码识别二维码"];
    [viewQRCodeBG addSubview:labelQRCodeHint];
    
    //影院签名
    UILabel *labelCinemaSignature = [[UILabel alloc] initWithFrame:CGRectMake(labelQRCodeHint.frame.origin.x+labelQRCodeHint.frame.size.width-0.5,
                                                                              labelQRCodeHint.frame.origin.y,
                                                                              labelQRCodeDescribe.frame.size.width*0.42,
                                                                              12)];
    labelCinemaSignature.backgroundColor = [UIColor clearColor];
    [labelCinemaSignature setFont:MKFONT(12)];
    [labelCinemaSignature setTextColor:RGBA(180, 180, 180, 1)];
    [labelCinemaSignature setTextAlignment:NSTextAlignmentRight];
    [labelCinemaSignature setText:@"超级电影院"];
    [viewQRCodeBG addSubview:labelCinemaSignature];
    
    viewOverallBG.frame = CGRectMake(viewOverallBG.frame.origin.x, viewOverallBG.frame.origin.y, viewOverallBG.frame.size.width, viewQRCodeBG.frame.origin.y+viewQRCodeBG.frame.size.height+20);
    
    return viewOverallBG;
}

//隐藏_更换图片按钮
-(void)hideShareViewSubview:(UIView *)shareView
{
    [shareView viewWithTag:BUTTON_TAG].hidden = YES;
}

//显示_更换图片按钮
-(void)showShareViewSubview:(UIView *)shareView
{
    [shareView viewWithTag:BUTTON_TAG].hidden = NO;
}

//离开时需要清理掉View
-(void)cancelView
{

}

#pragma mark 改变图片
-(void)onPackUpChangePoster:(UITapGestureRecognizer *)sender
{
    NSLog(@"点击了海报");
//    if ([self.delegate respondsToSelector:@selector(pushToChangeCinemaImageViewController:viewName:)])
//    {
//        [self.delegate pushToChangeCinemaImageViewController:self._cinemaShareInfoModel.images viewName:@"cinemaShareView"];
//    }
    
    ChangeCinemaImageViewController *changeCinemaImageViewController = [[ChangeCinemaImageViewController alloc] init];
    changeCinemaImageViewController._movidId = [NSNumber numberWithInt:665];
    changeCinemaImageViewController._isPosters = YES;
    changeCinemaImageViewController._arrImages = self._cinemaShareInfoModel.images;
    changeCinemaImageViewController._strViewName = @"cinemaShareView";
    changeCinemaImageViewController.delegate = self;
    [_nav pushViewController:changeCinemaImageViewController animated:YES];
}

-(void)ChangeCinemaImageDelegate:(UIImage *)imageSelectedCinema
{
    self._imagePoster.image = imageSelectedCinema;
    
    //重置海报控件的宽高
    self._imagePoster.frame = CGRectMake(0, 0, self._viewBlackBG.frame.size.width,
                                         self._viewBlackBG.frame.size.height);
}

//-(void)loadCinemaImage:(NSNotification *)notification
//{
//    NSMutableDictionary *dic = notification.object;
//    UIImage *returnImage = [dic objectForKey:@"returnImageCinema"];
//    self._imagePoster.image = returnImage;
//    
//    //重置海报控件的宽高
//    self._imagePoster.frame = CGRectMake(0, 0, self._viewBlackBG.frame.size.width,
//                                    self._viewBlackBG.frame.size.height);
//}

//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_POSTERSHAREIMAGE];
//}

@end
