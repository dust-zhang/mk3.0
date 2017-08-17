//
//  ShareRedPacketView.m
//  supercinema
//
//  Created by mapollo91 on 16/5/17.
//
//

#import "ShareRedPacketView.h"
#import "ThirdShareFactory.h"

@implementation ShareRedPacketView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
        
        [self setBackgroundColor:RGBA(0, 0, 0, 0.5)];
        _isClickBlank = NO;
    }
    return self;
}

-(void)drawView
{
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
    
    _viewShareToBG.userInteractionEnabled = YES;
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
    //    scrollViewShareTo.pagingEnabled = YES;
    [scrollViewShareTo setShowsHorizontalScrollIndicator:NO];//隐藏滚动条
    [_viewShareToBG addSubview:scrollViewShareTo];
    
    //分享按钮间隙
    float fBtnMargin;
    fBtnMargin = (scrollViewShareTo.frame.size.width-fShareTypeMargin*2-fButtonTypeSize*4)/3;
    
    //分享按钮
    NSArray *arrShareImage = @[@"button_shareSolid_weichat.png",@"button_shareSolid_weichat_friend.png",@"button_shareSolid_qq_friend.png",@"button_shareSolid_qzone.png"];
    for (int i=0; i<4; i++)
    {
        UIButton *btnShareType = [[UIButton alloc] initWithFrame:CGRectMake(fShareTypeMargin+i*(fButtonTypeSize+fBtnMargin), fLabelShareToMargin, fButtonTypeSize, fButtonTypeSize)];
        btnShareType.backgroundColor=[UIColor clearColor];
        [btnShareType setImage:[UIImage imageNamed:arrShareImage[i]] forState:UIControlStateNormal];
        [btnShareType.imageView setContentMode:UIViewContentModeScaleAspectFit];
        btnShareType.tag = i;
        [btnShareType addTarget:self action:@selector(onButtonShareRedPacket:) forControlEvents:UIControlEventTouchUpInside];
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
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel .titleLabel setFont:MKFONT(15)];
    [btnCancel setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(onButtonRedPacketCancel) forControlEvents:UIControlEventTouchUpInside];
    [_viewShareToBG addSubview:btnCancel];
    
    //添加点击事件（点击空白收起分享）
    UIView *viewTop = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-_fViewShareToBGHeight)];
    [viewTop setBackgroundColor:[UIColor clearColor]];
    [self addSubview:viewTop];
    
    UITapGestureRecognizer *clickBlank = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPackUpShare:)];
    [clickBlank setNumberOfTapsRequired:1];//点击一次
    clickBlank.delegate = self;
    clickBlank.cancelsTouchesInView = NO;//设置可点击
    [viewTop addGestureRecognizer:clickBlank];
}

-(void)onPackUpShare:(UITapGestureRecognizer *)sender
{
    //收起分享到
    if (!_isClickBlank)
    {
        //收起
        [self onButtonRedPacketCancel];
    }
}

#pragma mark 分享按钮
-(void)onButtonShareRedPacket:(UIButton*)sender
{
    [self shareRedPackData:sender];
}

//获取订单红包的分享信息
-(void)shareRedPackData:(UIButton*)sender
{
//    NSLog(@"点击了分享类型按钮");
    NSInteger senderType = 0;
    switch (sender.tag)
    {
        case 0:
            senderType = 0;
            break;
        case 1:
            senderType = 1;
            break;
        case 2:
            senderType = 3;
            break;
        case 3:
            senderType = 4;
            break;
        default:
            break;
    }
    shareType type = [ThirdShareFactory getShareType:senderType];
    if( ![ThirdShareFactory checkIsInstallApp:type])
    {
        return;
    }
    BaseShare *baseShare = [ThirdShareFactory getShareInstance:type];
    if(baseShare == nil)
    {
        [Tool showWarningTip:@"分享类型不存在" time:2];
        return;
    }
    
    [ServicesOrder getOrderShareInfo:self._orderId model:^(ShareRedPackModel *model)
     {
         shareInfoModel *shareModel = [[shareInfoModel alloc ] init];
         shareModel._title = model.shareData.title;
         shareModel._content = model.shareData.content;
         shareModel._url = model.shareData.url;
         shareModel._shareLogoUrl = model.shareData.shareLogoUrl;
         [baseShare shareContent:shareModel];
     } failure:^(NSError *error) {
         [Tool showWarningTip:error.domain time:1];
     }];
    
  }

#pragma mark 弹起
-(void)bounceViews
{
    _isClickBlank = NO;
    [UIView animateWithDuration:0.3
                  animations:^{
                      _viewShareToBG.frame = CGRectMake(0, SCREEN_HEIGHT-_fViewShareToBGHeight, SCREEN_WIDTH, _fViewShareToBGHeight);
                      _imageShadow.frame = CGRectMake(0, SCREEN_HEIGHT-_fViewShareToBGHeight-6, SCREEN_WIDTH, 6);
                    
                  }completion:^(BOOL finish){
                  }];
}

#pragma mark 取消按钮
-(void)onButtonRedPacketCancel
{
    NSLog(@"点击了取消");
    _isClickBlank = YES;
    //收起分享
    WeakSelf(ws);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1, 1);
                         self.alpha=0;
                         
                         _viewShareToBG.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _fViewShareToBGHeight);
                         _imageShadow.frame = CGRectMake(0, SCREEN_HEIGHT-6, SCREEN_WIDTH, 6);
                     }completion:^(BOOL finish){
                         [ws removeFromSuperview];
                     }];
}




@end
