//
//  PosterShareView.m
//  supercinema
//
//  Created by mapollo91 on 25/3/17.
//
//

#import "PosterShareView.h"

#define BUTTON_TAG 2046             //更改图片按钮
#define SHAREREASOBG_TAG 2049        //分享文字
#define SHAREREASONICON_WIDTH 17        //分享标签图标_宽度



@interface PosterShareView ()
@end

@implementation PosterShareView

-(id)initWithParentView:(UIView *)parentView navigation:(UINavigationController *)navigation
{
    self = [super init];
    _nav = navigation;
    self.parentView = parentView;
    [Config saveSelectImageUrl:nil key:@"movieShareBigUrl"];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPosterImage:) name:NOTIFITION_POSTERSHAREIMAGE object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPosterTextSign:) name:NOTIFITION_POSTERSHARETEXTSIGN object:nil];
    
    return self;
}

-(void)showView
{
    self._shareCardView = [[ShareCardView alloc] initWithFrame:CGRectMake(0, 0, self.parentView.frame.size.width, self.parentView.frame.size.height)];
    self._shareCardView.delegate = self;
    [self._shareCardView drawView];
    [self.parentView addSubview:self._shareCardView];
    
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
    self._viewOverallBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-35*2, (SCREEN_WIDTH-35*2)/0.7)];
    self._viewOverallBG.backgroundColor = [UIColor whiteColor];
    
    //黑色背景
    self.self._viewBlackBG = [[UIView alloc] initWithFrame:CGRectMake(15, 15, self._viewOverallBG.frame.size.width-15*2, (self._viewOverallBG.frame.size.width-15*2)*0.7)];
    self._viewBlackBG.backgroundColor = [UIColor blackColor];
    [self._viewOverallBG addSubview:self._viewBlackBG];
    
    //海报信息
    //图片海报
    self._imagePoster = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self._viewBlackBG.frame.size.width, self._viewBlackBG.frame.size.height)];
    self._imagePoster.backgroundColor = [UIColor clearColor];
    self._imagePoster.userInteractionEnabled = YES;//图片可以响应点击事件
    [self._viewBlackBG addSubview:self._imagePoster];
    
    UIImage *defaultImg = [UIImage imageNamed:@"img_ticketMoviePosterShare_default.png"];
    //海报
    if([self._movieModel.haibaoUrl length] > 0)
    {
        __weak typeof(self) weakSelf = self;
        [self._imagePoster sd_setImageWithURL:[NSURL URLWithString:[Tool urlIsNull:self._movieModel.haibaoUrl]] placeholderImage:defaultImg completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            CGRect targetRect = [ImageOperation imageViewSize:image.size cutImageSize:self._viewBlackBG.frame.size];
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
    UIView  *viewPosterCover = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, self._imagePoster.frame.size.width, self._imagePoster.frame.size.height)];
    viewPosterCover.backgroundColor = RGBA(0, 0, 0, 0.6);
    [self._viewBlackBG addSubview:viewPosterCover];
    
    //改变图片按钮
    UIButton *btnChangePoster = [[UIButton alloc] initWithFrame:CGRectMake(self._imagePoster.frame.size.width-10-40, 7, 40, 40)];
    btnChangePoster.backgroundColor = [UIColor clearColor];
    btnChangePoster.layer.masksToBounds = YES;
    [btnChangePoster.layer setCornerRadius:20.f];  //设置圆角
    btnChangePoster.tag = BUTTON_TAG;
    [btnChangePoster setBackgroundImage:[UIImage imageNamed:@"btn_changeImage.png"] forState:UIControlStateNormal];
    [self._viewBlackBG addSubview:btnChangePoster];
    
    //图片标题
    self._labelPosterTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, btnChangePoster.frame.origin.y+btnChangePoster.frame.size.height+50, self._viewBlackBG.frame.size.width, 15)];
    self._labelPosterTitle.backgroundColor = [UIColor clearColor];
    [self._labelPosterTitle setFont:MKFONT(15)];
    [self._labelPosterTitle setTextColor:[UIColor whiteColor]];
    [self._labelPosterTitle setTextAlignment:NSTextAlignmentCenter];
    self._labelPosterTitle.numberOfLines = 0;
    self._labelPosterTitle.lineBreakMode = NSLineBreakByCharWrapping;
    [self._labelPosterTitle setText:self._movieModel.movieTitle];//（能折行处理）
    [self._labelPosterTitle sizeToFit];
    [self._viewBlackBG addSubview:self._labelPosterTitle];
    if (IPhone5)
    {
        self._labelPosterTitle.frame = CGRectMake(0, btnChangePoster.frame.origin.y+btnChangePoster.frame.size.height+33, self._viewBlackBG.frame.size.width, self._labelPosterTitle.frame.size.height);
    }
    else
    {
        self._labelPosterTitle.frame = CGRectMake(0, btnChangePoster.frame.origin.y+btnChangePoster.frame.size.height+50, self._viewBlackBG.frame.size.width, self._labelPosterTitle.frame.size.height);
    }
    
    //用户头像
    self._imageUserIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self._viewOverallBG.frame.size.width-35)/2, self._viewBlackBG.frame.origin.y+self._viewBlackBG.frame.size.height-35/2, 35, 35)];
    self._imageUserIcon.backgroundColor = [UIColor clearColor];
    [self._imageUserIcon.layer setCornerRadius:35/2];//设置圆角
    self._imageUserIcon.layer.masksToBounds = YES;
    [self._viewOverallBG addSubview:self._imageUserIcon];
    
    
    //用户名称
    self._labelUserName = [[UILabel alloc] initWithFrame:CGRectMake(0, self._imageUserIcon.frame.origin.y+self._imageUserIcon.frame.size.height+7, self._viewOverallBG.frame.size.width, 14)];
    self._labelUserName.backgroundColor = [UIColor clearColor];
    [self._labelUserName setFont:MKFONT(12)];
    [self._labelUserName setTextColor:RGBA(51, 51, 51, 1)];
    [self._labelUserName setTextAlignment:NSTextAlignmentCenter];
    [self._viewOverallBG addSubview:self._labelUserName];
    
    //设置用户信息
    [self initUserInfo];
    
    //推荐理由
    //分享理由背景
    self._viewShareReasonBG = [[UIView alloc] initWithFrame:CGRectMake(15, self._labelUserName.frame.origin.y+self._labelUserName.frame.size.height+10, self._viewOverallBG.frame.size.width-15*2, 70)];
    self._viewShareReasonBG.backgroundColor = RGBA(246, 246, 251, 1);
    self._viewShareReasonBG.tag = SHAREREASOBG_TAG;
    [self._viewOverallBG addSubview:self._viewShareReasonBG];
    
    //添加点击事件
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeShareReason)];
    [click setNumberOfTapsRequired:1];//点击一次
    click.cancelsTouchesInView = NO;//设置可点击
    [self._viewShareReasonBG addGestureRecognizer:click];
    
    //分享理由标签
    self._labelShareReaso = [[UILabel alloc] initWithFrame:CGRectMake(10*2+19, 20, self._viewShareReasonBG.frame.size.width-10*3-SHAREREASONICON_WIDTH, 12)];
    self._labelShareReaso.backgroundColor = [UIColor clearColor];
    [self._labelShareReaso setFont:MKFONT(12)];
    [self._labelShareReaso setTextColor:RGBA(123, 122, 152, 1)];
    [self._labelShareReaso setTextAlignment:NSTextAlignmentCenter];
    self._labelShareReaso.numberOfLines = 0;
    self._labelShareReaso.lineBreakMode = NSLineBreakByCharWrapping;
    [self._viewShareReasonBG addSubview:self._labelShareReaso];
    
    //分享理由图片Logo
    self._imageShareReasonIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, self._labelShareReaso.frame.origin.y, SHAREREASONICON_WIDTH, 18)];
    self._imageShareReasonIcon.backgroundColor = [UIColor clearColor];
    [self._imageShareReasonIcon setImage:[UIImage imageNamed:@"image_comments.png"]];
    [self._viewShareReasonBG addSubview:self._imageShareReasonIcon];
    
    //分享理由标签
    if([self._movieModel.shortDescription length] > 0)
    {
        [self drawShareReaso:self._movieModel.shortDescription iconLabelWidth:SHAREREASONICON_WIDTH];
    }
    else
    {
        [self drawShareReaso:@"写下你的精彩推荐语吧！" iconLabelWidth:SHAREREASONICON_WIDTH];
    }
    
    //二维码背景区域
    UIView *viewQRCodeBG = [[UIView alloc] initWithFrame:CGRectMake(0, self._viewShareReasonBG.frame.origin.y+self._viewShareReasonBG.frame.size.height+87/2, self._viewOverallBG.frame.size.width, 107/2)];
    viewQRCodeBG.backgroundColor = [UIColor clearColor];
    [self._viewOverallBG addSubview:viewQRCodeBG];
    
    //二维码Logo
    UIImageView *imageQRCode = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 97/2, 97/2)];
    imageQRCode.backgroundColor = [UIColor clearColor];
    [viewQRCodeBG addSubview:imageQRCode];
    
    if (![Config getLoginState])
    {
        imageQRCode.image = [DrawShareImage encodeQRImageWithContent:[NSString stringWithFormat:@"https://m.movikr.com/?source=app&#movieinfo/%@",self._movieModel.movieId] size:CGSizeMake(200/2, 200/2)];
    }
    else
    {
        imageQRCode.image = [DrawShareImage encodeQRImageWithContent:[NSString stringWithFormat:@"https://m.movikr.com/?source=app&userid=%@#movieinfo/%@",[Config getUserId],self._movieModel.movieId] size:CGSizeMake(200/2, 200/2)];
    }

    
    //二维码说明
    UILabel *labelQRCodeDescribe = [[UILabel alloc] initWithFrame:CGRectMake(imageQRCode.frame.origin.x+imageQRCode.frame.size.width+10, 7.5, viewQRCodeBG.frame.size.width-15*2-imageQRCode.frame.size.width-10, 15)];
    labelQRCodeDescribe.backgroundColor = [UIColor clearColor];
    [labelQRCodeDescribe setFont:MKFONT(15)];
    [labelQRCodeDescribe setTextColor:RGBA(51, 51, 51, 1)];
    [labelQRCodeDescribe setTextAlignment:NSTextAlignmentLeft];
    [labelQRCodeDescribe setText:@"发现本片精彩内容"];
    [viewQRCodeBG addSubview:labelQRCodeDescribe];
    
    //二维码提示
    UILabel *labelQRCodeHint = [[UILabel alloc] initWithFrame:CGRectMake(labelQRCodeDescribe.frame.origin.x, labelQRCodeDescribe.frame.origin.y+labelQRCodeDescribe.frame.size.height+10, labelQRCodeDescribe.frame.size.width*0.58, 12)];
    labelQRCodeHint.backgroundColor = [UIColor clearColor];
    [labelQRCodeHint setFont:MKFONT(12)];
    [labelQRCodeHint setTextColor:RGBA(123, 122, 152, 1)];
    [labelQRCodeHint setTextAlignment:NSTextAlignmentLeft];
    [labelQRCodeHint setText:@"长按识别二维码"];
    [viewQRCodeBG addSubview:labelQRCodeHint];
    
    //影院签名
    UILabel *labelCinemaSignature = [[UILabel alloc] initWithFrame:CGRectMake(labelQRCodeHint.frame.origin.x+labelQRCodeHint.frame.size.width, labelQRCodeHint.frame.origin.y, labelQRCodeDescribe.frame.size.width*0.42, 12)];
    labelCinemaSignature.backgroundColor = [UIColor clearColor];
    [labelCinemaSignature setFont:MKFONT(12)];
    [labelCinemaSignature setTextColor:RGBA(123, 122, 152, 1)];
    [labelCinemaSignature setTextAlignment:NSTextAlignmentRight];
    [labelCinemaSignature setText:@"超级电影院"];
    [viewQRCodeBG addSubview:labelCinemaSignature];
    
    self._viewOverallBG.frame = CGRectMake(self._viewOverallBG.frame.origin.x, self._viewOverallBG.frame.origin.y, self._viewOverallBG.frame.size.width, viewQRCodeBG.frame.origin.y+viewQRCodeBG.frame.size.height+15);
    
    return self._viewOverallBG;
}

//设置用户信息
-(void)initUserInfo
{
    if([Config getLoginState])
    {
        //登录
        //海报
        NSString* userHead = [Config getUserHeadImage];
        UserModel* userModel = [[UserModel alloc]init];
        userModel.portrait_url = userHead;
        [Tool downloadImage:[userModel portrait_url] button:nil imageView:self._imageUserIcon defaultImage:@"image_defaultHead1.png"];
        
        //用户昵称
        if ([Config getUserNickName])
        {
            [self._labelUserName setText:[Config getUserNickName]];
        }
        else
        {
            [self._labelUserName setText:@"龙套甲"];
        }
    }
    else
    {
        //未登录
        [self._imageUserIcon setImage:[UIImage imageNamed:@"image_unLoginHead.png"]];
        [self._labelUserName setText:@"龙套甲"];
    }
}

-(void)drawShareReaso:(NSString *)shareReasoText iconLabelWidth:(float)iconLabelWidth
{
    self._labelShareReaso.text = shareReasoText;
    self._labelShareReaso.frame = CGRectMake(10*2+19, 20, self._viewShareReasonBG.frame.size.width-10*3-iconLabelWidth, 12);
    [self._labelShareReaso sizeToFit];
    //重新计算分享理由的布局
    //总体的宽
    CGFloat fReasonBGWidth = self._viewShareReasonBG.frame.size.width;   //分享内容背景的宽度
    CGFloat fReasonBGHeight = self._viewShareReasonBG.frame.size.height; //分享内容背景的高度
    CGFloat fShareReasoMIXWidth = fReasonBGWidth-10*3-iconLabelWidth;           //分享内容最大宽
    CGFloat fSingleRowsHeight = 12;                                 //单行行高
    if (self._labelShareReaso.frame.size.width >= fShareReasoMIXWidth)
    {
        self._labelShareReaso.frame = CGRectMake(fReasonBGWidth-fShareReasoMIXWidth-10, 20,fShareReasoMIXWidth, self._labelShareReaso.frame.size.height);
    }
    else
    {
        CGFloat fShareReasoMIXHeight;
        if (self._labelShareReaso.frame.size.height > fSingleRowsHeight)
        {
            fShareReasoMIXHeight = self._labelShareReaso.frame.size.height;
        }
        else
        {
            fShareReasoMIXHeight = fSingleRowsHeight;
        }
        self._labelShareReaso.frame = CGRectMake((fReasonBGWidth-self._labelShareReaso.frame.size.width)/2+iconLabelWidth, (fReasonBGHeight-fShareReasoMIXHeight)/2,self._labelShareReaso.frame.size.width, fShareReasoMIXHeight);
    }
    //分享理由图片Logo
    self._imageShareReasonIcon.frame = CGRectMake(self._labelShareReaso.frame.origin.x-10-iconLabelWidth, self._labelShareReaso.frame.origin.y-3, iconLabelWidth, 18);
}

//隐藏_更换图片按钮
-(void)hideShareViewSubview:(UIView *)shareView
{
    [shareView viewWithTag:BUTTON_TAG].hidden = YES;
    self._imageShareReasonIcon.hidden = YES;
    
    if ([self._labelShareReaso.text isEqualToString:@"写下你的精彩推荐语吧！"])
    {
        //隐藏推荐内容背景
        [shareView viewWithTag:SHAREREASOBG_TAG].hidden = YES;
    }
    else
    {
        self._imageShareReasonIcon.hidden = YES;
        [self drawShareReaso:self._labelShareReaso.text iconLabelWidth:0];
    }
}

//显示_更换图片按钮
-(void)showShareViewSubview:(UIView *)shareView
{
    [shareView viewWithTag:BUTTON_TAG].hidden = NO;
    [shareView viewWithTag:SHAREREASOBG_TAG].hidden = NO;
    self._imageShareReasonIcon.hidden = NO;
    
    [self drawShareReaso:self._labelShareReaso.text iconLabelWidth:SHAREREASONICON_WIDTH];
}

//离开时需要清理掉View
-(void)cancelView
{
    
}

#pragma mark 改变图片
-(void)onPackUpChangePoster:(UITapGestureRecognizer *)sender
{
    NSLog(@"点击了海报");
    
//    if ([self.delegate respondsToSelector:@selector(pushToChangeShareImageViewController)])
//    {
//        [self.delegate pushToChangeShareImageViewController];
//    }
    
//    MovieModel* mModel = _arrModel[self.currentIndex];
    ChangeShareImageViewController *changeShareImageViewController = [[ChangeShareImageViewController alloc] init];
    changeShareImageViewController._movidId = self._movieModel.movieId;
    changeShareImageViewController._isPosters = self._movieModel.haibaoUrl.length > 0;
    changeShareImageViewController.delegate = self;
    [_nav pushViewController:changeShareImageViewController animated:YES];
}

#pragma mark 修改推荐语
-(void)changeShareReason
{
//    if ([self.delegate respondsToSelector:@selector(pushToShareReasonViewController:)])
//    {
//        [self.delegate pushToShareReasonViewController:self._labelShareReaso.text];
//    }
    ShareReasonViewController *shareReasonViewController = [[ShareReasonViewController alloc] init];
    shareReasonViewController._strSign = self._labelShareReaso.text;
    shareReasonViewController.delegate = self;
    [_nav pushViewController:shareReasonViewController animated:YES];
}

//-(void)loadPosterImage:(NSNotification *)notification
//{
//    NSMutableDictionary *dic = notification.object;
//    UIImage *returnImage = [dic objectForKey:@"returnImg"];
//    self._imagePoster.image = returnImage;
//    
//    //重置海报控件的宽高
//    self._imagePoster.frame = CGRectMake(0, 0, self._viewBlackBG.frame.size.width,
//                                    self._viewBlackBG.frame.size.height);
//}
//
//-(void)loadPosterTextSign:(NSNotification *)notification
//{
//    NSMutableDictionary *dic = notification.object;
//    NSString *strTextSign = [dic objectForKey:@"textViewSign"];
//    self._labelShareReaso.text = strTextSign;
//    //推荐理由文字布局
//    [self drawShareReaso:self._labelShareReaso.text iconLabelWidth:SHAREREASONICON_WIDTH];
//}

#pragma mark 更改图片
-(void)ChangeShareImageDelegate:(UIImage *)imageShareImage
{
    self._imagePoster.image = imageShareImage;
    
    //重置海报控件的宽高
    self._imagePoster.frame = CGRectMake(0, 0, self._viewBlackBG.frame.size.width,
                                         self._viewBlackBG.frame.size.height);
}

#pragma mark 修改推荐语
-(void)ShareReasonTextDelegate:(NSString *)shareReasoText
{
    self._labelShareReaso.text = shareReasoText;
    //推荐理由文字布局
    [self drawShareReaso:self._labelShareReaso.text iconLabelWidth:SHAREREASONICON_WIDTH];
}

//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_POSTERSHAREIMAGE];
//    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_POSTERSHARETEXTSIGN];
//}

@end
