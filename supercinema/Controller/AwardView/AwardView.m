//
//  AwardView.m
//  supercinema
//
//  Created by dust on 16/11/17.
//
//

#import "AwardView.h"


@implementation AwardView

-(instancetype)initWithFrame:(CGRect)frame arr:(NSArray *)arrModel shareRedpackFee:(NSNumber *)shareRedpackFee
{
    self=[super initWithFrame:frame];
    if(self)
    {
        /** 测试 **/
//        shareRedpackFee = [NSNumber numberWithInt:1000];
        /** 结束 **/
        
        [self setBackgroundColor:RGBA(0, 0, 0, 0.5)];
        _isClickBlank = NO;
        
        _modelActivityGrantList =arrModel[0];
        _arrActivityGrantList = arrModel;
        _shareRedpackFee = shareRedpackFee;
        /*
         *  活动类型
         *  0 只有奖励
         *  1 既有奖励也有红包
         *  2 只有红包
         */
        int isShowAwardViewType = 0;
        if (arrModel != nil && [shareRedpackFee intValue] > 0)
        {
            //既有奖励也有红包
            isShowAwardViewType = 1;
        }
        else if (arrModel == nil && [shareRedpackFee intValue] > 0)
        {
            //只有红包
            isShowAwardViewType = 2;
        }
        else
        {
            //只有奖励
            isShowAwardViewType = 0;
        }
        
        [self initController:isShowAwardViewType];
    }
    return self;
}

-(void)initController:(int)activityType
{
    if (activityType == 0 || activityType == 1)
    {
        //只有（奖励）或者（有奖励+红包）
        [self onlyAwardOrAllAwardAndRedPacket:activityType];
    }
    else
    {
        //只有红包
        [self onlyRedPacket];
    }
    //分享到...
    [self drawShareGoToView];
}

#pragma mark 只有（奖励）或者（有奖励+红包）
-(void)onlyAwardOrAllAwardAndRedPacket:(int)activityType
{
    //整体背景
    UIView *viewbg = [[UIView alloc ] initWithFrame:CGRectMake(35, 220/2, SCREEN_WIDTH-70, SCREEN_HEIGHT-110-274/2)];
    [viewbg setBackgroundColor:[ UIColor whiteColor]];
    [viewbg.layer setMasksToBounds:YES];
    [viewbg.layer setCornerRadius:10];
    [self addSubview:viewbg];
    
    //添加点击事件（点击空白收起分享）
    UITapGestureRecognizer *clickBlank = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPackUpShare:)];
    [clickBlank setNumberOfTapsRequired:1];//点击一次
    clickBlank.delegate = self;
    clickBlank.cancelsTouchesInView = NO;//设置可点击
    [viewbg addGestureRecognizer:clickBlank];
    
    //取消按钮
    UIButton *btnClose = [[UIButton alloc ] initWithFrame:CGRectMake(viewbg.frame.size.width-33, 0, 33, 33)];//CGRectMake(viewbg.frame.origin.x+viewbg.frame.size.width-20, viewbg.frame.origin.y-10, 30, 30)
    [btnClose setImage:[UIImage imageNamed:@"btn_notifictionClose.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(onButtonClose) forControlEvents:UIControlEventTouchUpInside];
    [viewbg addSubview:btnClose];
    
    //奖励标题
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, viewbg.frame.size.width, 18)];
    [labelTitle setTextColor:RGBA(0, 0, 0,1)];
    [labelTitle setFont:MKFONT(18) ];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
    [labelTitle setText:@"获得奖励"];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [viewbg addSubview:labelTitle];
    
    //滑动范围
    UIScrollView *scrollViewAward = [[UIScrollView alloc]initWithFrame:CGRectMake(0, labelTitle.frame.origin.y+labelTitle.frame.size.height+13.5, viewbg.frame.size.width, viewbg.frame.size.height-45-18-33/2-40-15)];
    [scrollViewAward setBackgroundColor:[UIColor clearColor]];
    
    /*********** 显示默认图 - start ***********/
    UIImageView *imageAward= [[UIImageView alloc ] initWithFrame:CGRectMake(15, 0, scrollViewAward.frame.size.width-30, (scrollViewAward.frame.size.width-30)/2)];
    [scrollViewAward addSubview:imageAward];
    
    CGFloat heightScrollView;
    if (activityType == 0)
    {
        //只有奖励
        [imageAward setImage:[UIImage imageNamed:@"image_Award.png"]];
        heightScrollView = imageAward.frame.size.height+19;//15
    }
    else
    {
        //既有奖励也有红包
        [imageAward setImage:[UIImage imageNamed:@"image_AwardRedPacket_small.png"]];
        
        float fSumY;
        if (IPhone5)
        {
            fSumY = 46;
        }
        else if ( IPhone6)
        {
            fSumY = 52;
        }
        else
        {
            fSumY = 60;
        }
        //红包金额
        UILabel *labelRedPacketSum = [[UILabel alloc] initWithFrame:CGRectMake(0, fSumY, imageAward.frame.size.width, 24)];
        labelRedPacketSum.backgroundColor = [UIColor clearColor];
        [labelRedPacketSum setTextColor:RGBA(222, 46, 12, 1)];
        [labelRedPacketSum setFont:MKFONT(24) ];
        [labelRedPacketSum setText:[NSString stringWithFormat:@"￥%@",[Tool PreserveTowDecimals:_shareRedpackFee]]];
        [labelRedPacketSum setTextAlignment:NSTextAlignmentCenter];
        [imageAward addSubview:labelRedPacketSum];
        
        //红包说明
        UILabel *labelRedPacketExplain = [[UILabel alloc] initWithFrame:CGRectMake(0, imageAward.frame.size.height-11-13, imageAward.frame.size.width, 13)];
        labelRedPacketExplain.backgroundColor = [UIColor clearColor];
        [labelRedPacketExplain setTextColor:RGBA(255, 224, 0, 1)];
        [labelRedPacketExplain setFont:MKFONT(13) ];
        [labelRedPacketExplain setText:@"呼朋唤友 瓜分红包"];
        [labelRedPacketExplain setTextAlignment:NSTextAlignmentCenter];
        [imageAward addSubview:labelRedPacketExplain];
        
        UILabel *labelExplain = [[UILabel alloc] initWithFrame:CGRectMake((scrollViewAward.frame.size.width-46)/2, imageAward.frame.size.height+19, 46, 15)];
        labelExplain.backgroundColor = [UIColor clearColor];
        [labelExplain setTextColor:RGBA(249, 81, 81, 1)];
        [labelExplain setFont:MKFONT(15) ];
        [labelExplain setText:@"已获得"];
        [labelExplain setTextAlignment:NSTextAlignmentCenter];
        [scrollViewAward addSubview:labelExplain];

        //分割线
        UIView *viewLineLeft = [[UIView alloc] initWithFrame:CGRectMake(15, labelExplain.frame.origin.y+7, (imageAward.frame.size.width-labelExplain.frame.size.width-17)/2, 0.5)];
        viewLineLeft.backgroundColor = RGBA(0, 0, 0, 0.05);
        [scrollViewAward addSubview:viewLineLeft];
        
        UIView *viewLineRight = [[UIView alloc] initWithFrame:CGRectMake(scrollViewAward.frame.size.width-15-viewLineLeft.frame.size.width, viewLineLeft.frame.origin.y, viewLineLeft.frame.size.width, viewLineLeft.frame.size.height)];
        viewLineRight.backgroundColor = RGBA(0, 0, 0, 0.05);
        [scrollViewAward addSubview:viewLineRight];
        
        heightScrollView = imageAward.frame.size.height+19+15+13;
    }
    
//    scrollViewAward.backgroundColor = [UIColor redColor];
//    viewbg.backgroundColor = [UIColor blueColor];
    
    /*********** 显示默认图 - end ***********/
    
    /*********** 内容主体 - start ***********/
    CGFloat heightCell = 22;
    
    for (int i = 0; i<[_arrActivityGrantList count]; i++)
    {
        activityGrantListModel *model = _arrActivityGrantList[i];
        NSInteger cellCount = model.grantList.count;
        
        if (i == 0)
        {
            CGFloat heightLabel = imageAward.frame.origin.y+imageAward.frame.size.height+15;
            if (activityType != 0)
            {
                heightLabel = imageAward.frame.size.height+19+15-2;
            }
            
            if ([_arrActivityGrantList count] == 1)
            {
                //如果奖励列表只有一个（隐藏线）
                awardDetailView[i] = [[AwardDetailView alloc] initWithFrame:CGRectMake(0, heightLabel, scrollViewAward.frame.size.width,45+12+(cellCount-1)*heightCell+15) orderModel:model hiddenLine:YES];
            }
            else
            {
                //如果奖励列表有很多个（显示线）
                awardDetailView[i] = [[AwardDetailView alloc] initWithFrame:CGRectMake(0, heightLabel, scrollViewAward.frame.size.width,45+12+(cellCount-1)*heightCell+15) orderModel:model hiddenLine:NO];
            }
        }
        else
        {
            awardDetailView[i] = [[AwardDetailView alloc] initWithFrame:CGRectMake(0, awardDetailView[i-1].frame.origin.y+awardDetailView[i-1].frame.size.height, scrollViewAward.frame.size.width,45+12+(cellCount-1)*heightCell+15) orderModel:model hiddenLine:NO];
            if (i == _arrActivityGrantList.count-1)
            {
                //如果是最后一行（隐藏线）
                awardDetailView[i] = [[AwardDetailView alloc] initWithFrame:CGRectMake(0, awardDetailView[i-1].frame.origin.y+awardDetailView[i-1].frame.size.height, scrollViewAward.frame.size.width,45+12+(cellCount-1)*heightCell+15) orderModel:model hiddenLine:YES];
            }
        }
        
        [scrollViewAward addSubview:awardDetailView[i]];
        
        heightScrollView += awardDetailView[i].frame.size.height;
    }
    //计算高度
    scrollViewAward.contentSize = CGSizeMake(scrollViewAward.frame.size.width, heightScrollView);
    [viewbg addSubview:scrollViewAward];
    /*********** 内容主体 - end ***********/
    
    //按钮（知道了 or 分享领红包）
    UIButton *btnKnow = [[UIButton alloc ] initWithFrame:CGRectMake( (viewbg.frame.size.width-(320/2) )/2, viewbg.frame.size.height-40-33/2, 320/2, 40)];
    [btnKnow setBackgroundColor:RGBA(117, 112, 255, 1)];
    [btnKnow.layer setMasksToBounds:YES];
    [btnKnow.layer setCornerRadius:20];
    [btnKnow.titleLabel setFont:MKFONT(15)];
    [btnKnow addTarget:self action:@selector(onButtonUnderstand:) forControlEvents:UIControlEventTouchUpInside];
    [viewbg addSubview:btnKnow];
    
    if (activityType == 0)
    {
        //只有奖励
        btnKnow.tag = 10;
        [btnKnow setTitle:@"知道了" forState:UIControlStateNormal];
    }
    else
    {
        //既有奖励也有红包
        btnKnow.tag = 11;
        [btnKnow setTitle:@"分享领红包" forState:UIControlStateNormal];
    }
}

#pragma mark 只有（红包）
-(void)onlyRedPacket
{
    //整体背景
    UIView *viewbg = [[UIView alloc ] initWithFrame:CGRectMake(25, 300/2, SCREEN_WIDTH-50, 115+(SCREEN_WIDTH-50)*(192.5/325))];//SCREEN_HEIGHT-110-274/2
    [viewbg setBackgroundColor:[ UIColor clearColor]];
    [viewbg.layer setMasksToBounds:YES];
    [self addSubview:viewbg];
    
    //添加点击事件（点击空白收起分享）
    UITapGestureRecognizer *clickBlank = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPackUpShare:)];
    [clickBlank setNumberOfTapsRequired:1];//点击一次
    clickBlank.delegate = self;
    clickBlank.cancelsTouchesInView = NO;//设置可点击
    [viewbg addGestureRecognizer:clickBlank];
    
    //取消按钮
    UIButton *btnClose = [[UIButton alloc ] initWithFrame:CGRectMake(viewbg.frame.size.width-60, 0, 30, 30)];
    [btnClose setImage:[UIImage imageNamed:@"btn_AwardClose_clear.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(onButtonClose) forControlEvents:UIControlEventTouchUpInside];
    [viewbg addSubview:btnClose];
    [self bringSubviewToFront:btnClose];
    
    UIImageView *imageAward= [[UIImageView alloc ] initWithFrame:CGRectMake(0, btnClose.frame.size.height+15, viewbg.frame.size.width, viewbg.frame.size.width*(192.5/325))];
    [imageAward setImage:[UIImage imageNamed:@"image_AwardRedPacket_big.png"]];
    [viewbg addSubview:imageAward];
    
    //红包金额
    float fRedPacketSumY;
    if (IPhone5)
    {
        fRedPacketSumY = 53;
    }
    else if (IPhone6)
    {
        fRedPacketSumY = 66;
    }
    else
    {
        fRedPacketSumY = 73;
    }
    UILabel *labelRedPacketSum = [[UILabel alloc] initWithFrame:CGRectMake(0, fRedPacketSumY, imageAward.frame.size.width, 35)];
    labelRedPacketSum.backgroundColor = [UIColor clearColor];
    [labelRedPacketSum setTextColor:RGBA(222, 46, 12, 1)];
    [labelRedPacketSum setFont:MKFONT(35) ];
    [labelRedPacketSum setText:[NSString stringWithFormat:@"￥%@",[Tool PreserveTowDecimals:_shareRedpackFee]]];
    [labelRedPacketSum setTextAlignment:NSTextAlignmentCenter];
    [imageAward addSubview:labelRedPacketSum];
    
    //红包说明
    UILabel *labelRedPacketExplain = [[UILabel alloc] initWithFrame:CGRectMake(0, imageAward.frame.size.height-11-19.5, imageAward.frame.size.width, 19.5)];
    labelRedPacketExplain.backgroundColor = [UIColor clearColor];
    [labelRedPacketExplain setTextColor:RGBA(255, 224, 0, 1)];
    [labelRedPacketExplain setFont:MKFONT(19.5) ];
    [labelRedPacketExplain setText:@"呼朋唤友 瓜分红包"];
    [labelRedPacketExplain setTextAlignment:NSTextAlignmentCenter];
    [imageAward addSubview:labelRedPacketExplain];

    //按钮 - 分享领红包
    UIButton *btnKnow = [[UIButton alloc ] initWithFrame:CGRectMake( (viewbg.frame.size.width-(320/2) )/2, viewbg.frame.size.height-40, 320/2, 40)];
    [btnKnow setBackgroundColor:RGBA(243, 54, 20, 1)];
    [btnKnow.layer setMasksToBounds:YES];
    [btnKnow.layer setCornerRadius:20];
    [btnKnow.titleLabel setFont:MKFONT(15)];
    btnKnow.tag = 30;
    [btnKnow setTitle:@"分享领红包" forState:UIControlStateNormal];
    [btnKnow addTarget:self action:@selector(onButtonUnderstand:) forControlEvents:UIControlEventTouchUpInside];
    [viewbg addSubview:btnKnow];
}

#pragma mark 分享到View
-(void)drawShareGoToView
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
}

#pragma mark UIScrollDelegate


#pragma mark 关闭按钮
-(void)onButtonClose
{
    [MobClick event:mainViewbtn57];
//    [self removeFromSuperview];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5
                     animations:^{
                         _viewShareToBG.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _fViewShareToBGHeight);
                         _imageShadow.frame = CGRectMake(0, SCREEN_HEIGHT-6, SCREEN_WIDTH, 6);
                         
                     }completion:^(BOOL finish){
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              weakSelf.transform = CGAffineTransformMakeScale(1.3, 1.3);
                                              weakSelf.alpha=0;
                                              
                                          }completion:^(BOOL finish){
//                                              [weakSelf removeFromSuperview];
                                          }];
                     }];
}

#pragma mark 知道了按钮
-(void)onButtonUnderstand:(UIButton *)sender
{
    if (sender.tag == 10)
    {
        //知道了
        [MobClick event:mainViewbtn56];
        [self removeFromSuperview];
    }
    else
    {
        //分享领取红包
        NSLog(@"点我点我点我----分享红包");
        //弹起
        [self bounceViews];
    }
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
    }
    else
    {
        //收起
        [self onButtonRedPacketCancel];
    }
}

#pragma mark 分享按钮
-(void)onButtonShareRedPacket:(UIButton*)sender
{
    WeakSelf(ws);
    [ServicesOrder getOrderShareInfo:self._orderId model:^(ShareRedPackModel *model)
    {
        [ws shareRedPackData:sender model:model];
        
    } failure:^(NSError *error) {
        [Tool showWarningTip:error.domain time:1];
    }];
    
}

//获取订单红包的分享信息
-(void)shareRedPackData:(UIButton*)sender model:(ShareRedPackModel *)model
{
    NSLog(@"点击了分享类型按钮");
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
    BaseShare *baseShare = [ThirdShareFactory getShareInstance:type];
    if(baseShare == nil)
    {
        [Tool showWarningTip:@"分享类型不存在" time:2];
        return;
    }
    
    shareInfoModel *shareModel = [[shareInfoModel alloc ] init];
    shareModel._title = model.shareData.title;
    shareModel._content = model.shareData.content;
    shareModel._url = model.shareData.url;
    shareModel._shareLogoUrl = model.shareData.shareLogoUrl;
    [baseShare shareContent:shareModel];
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
    [UIView animateWithDuration:0.3
                     animations:^{
                         _viewShareToBG.frame  = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _fViewShareToBGHeight);
                         _imageShadow.frame = CGRectMake(0, SCREEN_HEIGHT-6, SCREEN_WIDTH, 6);
                         
                     }completion:^(BOOL finish){
                     }];
}

@end
