//
//  CardOrderViewController.m
//  supercinema
//
//  Created by mapollo91 on 10/11/16.
//
//

#import "CardOrderViewController.h"

@interface CardOrderViewController ()

@end

@implementation CardOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrCacheData = [[NSMutableArray alloc]init];
    
    arrayPacket = [[NSMutableArray alloc]init];
    
    _arrayMemberCard = [[NSMutableArray alloc ] initWithCapacity:0];
    _lockSeatTimeCount = 0;
    
    //红包使用限制数组，0票红包，4卖品红包，3会员卡红包，初始化都是NoUsedType
    _arrayPacketLimit = [[NSMutableArray alloc]initWithObjects:@4,@4,@4, nil];
    _arrayUsedCardIndex = [[NSMutableArray alloc]init];
    _arrRedPackIds = [[NSMutableArray alloc]init];
    isCanUseCardPack = YES;
    isHaveUseOrderPack = NO;
    isHaveUseNotLimitPack = NO;
    
    [self initCtrl];
    [self initControllerData];
}

-(void)initCtrl
{
    [self.view setBackgroundColor:RGBA(246, 246, 251, 1)];
    
    //整体背景
    _viewWholeBG = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 291.5)];
    [_viewWholeBG setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_viewWholeBG];
    
    UILabel *labelRuleDescribe = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 12)];
    [labelRuleDescribe setBackgroundColor:[UIColor clearColor]];
    [labelRuleDescribe setFont:MKFONT(12)];
    [labelRuleDescribe setTextColor:RGBA(123, 122, 152, 0.6)];
    [labelRuleDescribe setTextAlignment:NSTextAlignmentCenter];
    [labelRuleDescribe setText:@"请认真核对订单，一旦售出不支持退款"];
    [_viewWholeBG addSubview:labelRuleDescribe];
    
/****************卡基本信息****************/
    UIView *viewCardBG = [[UIView alloc] initWithFrame:CGRectMake(15, labelRuleDescribe.frame.origin.y+labelRuleDescribe.frame.size.height+10, SCREEN_WIDTH-15*2, 147.5)];
    [viewCardBG setBackgroundColor:RGBA(255, 255, 255, 1)];
    viewCardBG.layer.borderWidth = 0.5;//边框宽度
    viewCardBG.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];//边框颜色
    viewCardBG.layer.cornerRadius = 2.f;//圆角
    [_viewWholeBG addSubview:viewCardBG];

    //卡Logo
    _imageCardIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 45, 35)];
    [_imageCardIcon setBackgroundColor:[UIColor redColor]];
    [viewCardBG addSubview:_imageCardIcon];
    
    //卡名称
    _labelCardName = [[UILabel alloc] initWithFrame:CGRectMake(_imageCardIcon.frame.origin.x+_imageCardIcon.frame.size.width+15, _imageCardIcon.frame.origin.y, viewCardBG.frame.size.width-_imageCardIcon.frame.size.width-15*2, 15)];
    [_labelCardName setBackgroundColor:[UIColor clearColor]];
    [_labelCardName setFont:MKFONT(15)];
    [_labelCardName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelCardName setTextAlignment:NSTextAlignmentLeft];
    [viewCardBG addSubview:_labelCardName];
    
    //影院名称
    _labelCinemaName = [[UILabel alloc] initWithFrame:CGRectMake(_labelCardName.frame.origin.x, _labelCardName.frame.origin.y+_labelCardName.frame.size.height+10, _labelCardName.frame.size.width, 12)];
    [_labelCinemaName setBackgroundColor:[UIColor clearColor]];
    [_labelCinemaName setFont:MKFONT(12)];
    [_labelCinemaName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelCinemaName setTextAlignment:NSTextAlignmentLeft];
    [viewCardBG addSubview:_labelCinemaName];
    
    //有效期
    _labelDate = [[UILabel alloc] initWithFrame:CGRectMake(_labelCinemaName.frame.origin.x, _labelCinemaName.frame.origin.y+_labelCinemaName.frame.size.height+15, _labelCinemaName.frame.size.width, 10)];
    [_labelDate setBackgroundColor:[UIColor clearColor]];
    [_labelDate setFont:MKFONT(10)];
    [_labelDate setTextColor:RGBA(123, 122, 152, 1)];
    [_labelDate setTextAlignment:NSTextAlignmentLeft];
    [viewCardBG addSubview:_labelDate];

    //分割线（虚线）
    UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(_imageCardIcon.frame.origin.x, _labelDate.frame.origin.y+_labelDate.frame.size.height+10, viewCardBG.frame.size.width-15*2, 0.5)];
    [imageLine setBackgroundColor:[UIColor clearColor]];
    [imageLine setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
    [viewCardBG addSubview:imageLine];

    //小计：金额
    _labelSubtotal = [[UILabel alloc] initWithFrame:CGRectMake(imageLine.frame.origin.x, imageLine.frame.origin.y+imageLine.frame.size.height+15, imageLine.frame.size.width, 15)];
    [_labelSubtotal setBackgroundColor:[UIColor clearColor]];
    [_labelSubtotal setTextAlignment:NSTextAlignmentRight];
    [viewCardBG addSubview:_labelSubtotal];
    
/****************权益优惠****************/
    UIView *viewRightsBG = [[UIView alloc] initWithFrame:CGRectMake(15, viewCardBG.frame.origin.y+viewCardBG.frame.size.height+10, SCREEN_WIDTH-15*2, 44)];
    [viewRightsBG setBackgroundColor:RGBA(255, 255, 255, 1)];
    viewRightsBG.layer.borderWidth = 0.5;
    viewRightsBG.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];
    viewRightsBG.layer.cornerRadius = 2.f;
    [_viewWholeBG addSubview:viewRightsBG];
    
    UILabel *labelRight = [[UILabel alloc] initWithFrame:CGRectMake(15, 14.5, 90, 15)];
    [labelRight setBackgroundColor:[UIColor clearColor]];
    [labelRight setFont:MKFONT(15)];
    [labelRight setTextColor:RGBA(51, 51, 51, 1)];
    [labelRight setTextAlignment:NSTextAlignmentLeft];
    [labelRight setText:@"权益优惠"];
    [viewRightsBG addSubview:labelRight];
    
    //权益优惠 标识
    _labelRightType = [[UILabel alloc] initWithFrame:CGRectMake(viewRightsBG.frame.size.width-15-7.5-5.5-200, 16, 200, 12)];
    [_labelRightType setBackgroundColor:[UIColor clearColor]];
    [_labelRightType setFont:MKFONT(12)];
    [_labelRightType setTextColor:RGBA(249, 81, 81, 1)];
    [_labelRightType setTextAlignment:NSTextAlignmentRight];
    [viewRightsBG addSubview:_labelRightType];
    
    UIImageView *imageArrowLeft = [[UIImageView alloc] initWithFrame:CGRectMake(_labelRightType.frame.origin.x+_labelRightType.frame.size.width+5.5, 15.5, 7.5, 13)];
    [imageArrowLeft setImage:[UIImage imageNamed:@"btn_rightArrow.png"]];
    [viewRightsBG addSubview:imageArrowLeft];
    
    //权益按钮
    _btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewRightsBG.frame.size.width, viewRightsBG.frame.size.height)];
    [_btnRight setBackgroundColor:[UIColor clearColor]];
    [_btnRight addTarget:self action:@selector(onBtnRightDetails) forControlEvents:UIControlEventTouchUpInside];
    [_btnRight setUserInteractionEnabled:YES];//按钮可点击
    [viewRightsBG addSubview:_btnRight];

/****************手机号****************/
    UIView *viewPhoneBG = [[UIView alloc] initWithFrame:CGRectMake(15, viewRightsBG.frame.origin.y+viewRightsBG.frame.size.height+10, SCREEN_WIDTH-15*2, 44)];
    [viewPhoneBG setBackgroundColor:RGBA(255, 255, 255, 1)];
    viewPhoneBG.layer.borderWidth = 0.5;
    viewPhoneBG.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];
    viewPhoneBG.layer.cornerRadius = 2.f;
    [_viewWholeBG addSubview:viewPhoneBG];
    
    //手机号
    UILabel *labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(15, 14.5, 62, 15)];
    [labelPhone setBackgroundColor:[UIColor clearColor]];
    [labelPhone setFont:MKFONT(15)];
    [labelPhone setTextColor:RGBA(51, 51, 51, 1)];
    [labelPhone setTextAlignment:NSTextAlignmentLeft];
    [labelPhone setText:@"手机号码"];
    [viewPhoneBG addSubview:labelPhone];
    
    //手机号输入
    _textFieldPhone= [[ExUITextView alloc]initWithFrame:CGRectMake(labelPhone.frame.origin.x+labelPhone.frame.size.width+10, 14.5, viewPhoneBG.frame.size.width-15*2-62-10, 15)];
    [_textFieldPhone.myTextField setBackgroundColor:[UIColor clearColor]];
    [_textFieldPhone.myTextField setTextColor:RGBA(51, 51, 51, 1)];
//    [_textFieldPhone.myTextField setPlaceholder:@" 请输入手机号码，用于生成订单（必填）"];
    _textFieldPhone.tfDelegate = self;
    [_textFieldPhone.myTextField setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_textFieldPhone.myTextField setFont:MKFONT(15) ];
    [_textFieldPhone.myTextField setText:[Config getUserName] ];
    if (_textFieldPhone.myTextField.text.length>0)
    {
        _textFieldPhone.btnDelete.hidden = NO;
    }
    _textFieldPhone.myTextField.contentVerticalAlignment = 0;
    _textFieldPhone.myTextField.delegate=self;
    _textFieldPhone.tag = 0;
    _textFieldPhone.myTextField.borderStyle = UITextBorderStyleNone;
    _textFieldPhone.myTextField.keyboardType = UIKeyboardTypeNumberPad;
    _textFieldPhone.myTextField.returnKeyType = UIReturnKeyDefault;
    [_textFieldPhone.myTextField addTarget:self action:@selector(textFiledDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textFieldPhone.myTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [viewPhoneBG addSubview:_textFieldPhone];
    
    //文字提示
//    UILabel *labelPhonePrompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _textFieldPhone.frame.size.width, 12)];
//    [labelPhonePrompt setBackgroundColor:[UIColor clearColor]];
//    [labelPhonePrompt setFont:MKFONT(12)];
//    [labelPhonePrompt setTextColor:RGBA(180, 180, 180, 1)];
//    [labelPhonePrompt setTextAlignment:NSTextAlignmentLeft];
//    [labelPhonePrompt setText:@" 请输入手机号码，用于生成订单（必填）"];
//    [_textFieldPhone addSubview:labelPhonePrompt];
    
/****************确认订单****************/
    _viewConfirmOrderBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-190/2, SCREEN_WIDTH, 190/2)];
    [_viewConfirmOrderBG setBackgroundColor:RGBA(255, 255, 255, 1)];
    _viewConfirmOrderBG.layer.shadowColor = [RGBA(0, 0, 0, 0.06) CGColor];
    [self.view addSubview:_viewConfirmOrderBG];

    //实付金额：金额
    CGSize sizelabelActualMoneyTag = [Tool boundingRectWithSize:@"实付金额：" textFont:MKFONT(12) textSize:CGSizeMake(MAXFLOAT, 12)];
    UILabel *labelActualMoneyTag =  [[UILabel alloc]initWithFrame:CGRectMake(15, 15, sizelabelActualMoneyTag.width, 12)];
    labelActualMoneyTag.text = @"实付金额：";
    labelActualMoneyTag.font = MKFONT(12);
    labelActualMoneyTag.textColor = RGBA(123, 122, 152, 1);
    [_viewConfirmOrderBG addSubview:labelActualMoneyTag];
    
    _labelActualMoney = [[UILabel alloc] initWithFrame:CGRectMake(labelActualMoneyTag.frame.origin.x+labelActualMoneyTag.frame.size.width, 12, SCREEN_WIDTH/2, 17)];
    [_labelActualMoney setBackgroundColor:[UIColor clearColor]];
    [_labelActualMoney setFont:MKFONT(17)];
    [_labelActualMoney setTextColor: RGBA(249, 81, 81, 1)];
    [_labelActualMoney setTextAlignment:NSTextAlignmentLeft];
    [_viewConfirmOrderBG addSubview:_labelActualMoney];
    
    //上箭头图
    _imageArrowUp = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-9, 15, 9, 5)];
    [_imageArrowUp setImage:[UIImage imageNamed:@"btn_upArrow.png"]];
    [_viewConfirmOrderBG addSubview:_imageArrowUp];
    
    //查看明细按钮
    _btnLookDetail = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-75, 10, 75, 20)];
    [_btnLookDetail setBackgroundColor:[UIColor clearColor]];
    [_btnLookDetail setTitle:@"查看明细" forState:UIControlStateNormal];
    [_btnLookDetail setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];//按钮文字颜色
    [_btnLookDetail .titleLabel setFont:MKFONT(12)];//按钮字体大小
    _btnLookDetail.tag = 300;
    [_btnLookDetail addTarget:self action:@selector(onBtnLookDetail:) forControlEvents:UIControlEventTouchUpInside];
    [_viewConfirmOrderBG addSubview:_btnLookDetail];
    
    
    _viewBlackBG = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-383/2)];
    _viewBlackBG.backgroundColor = RGBA(0, 0, 0, 1);
    _viewBlackBG.alpha = 0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewBG)];
    [_viewBlackBG addGestureRecognizer:tapGesture];
    [self.view addSubview:_viewBlackBG];
    
    
    _labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, labelActualMoneyTag.frame.origin.y+labelActualMoneyTag.frame.size.height+15, SCREEN_WIDTH, 1)];
    [_labelLine setBackgroundColor:RGBA(242, 242, 242, 1)];
    _labelLine.hidden = YES;
    [_viewConfirmOrderBG addSubview:_labelLine];
    
    //订单总价
    _labelLookDetailInOrder = [[UILabel alloc] initWithFrame:CGRectMake(15, _labelLine.frame.origin.y+_labelLine.frame.size.height+30, SCREEN_WIDTH/2-15, 12)];
    [_labelLookDetailInOrder setBackgroundColor:[UIColor clearColor]];
    [_labelLookDetailInOrder setFont:MKFONT(12)];
    [_labelLookDetailInOrder setTextColor:RGBA(133, 133, 160, 1)];
    [_labelLookDetailInOrder setTextAlignment:NSTextAlignmentLeft];
    [_labelLookDetailInOrder setText:@"订单总价："];
    _labelLookDetailInOrder.hidden = YES;
    [_viewConfirmOrderBG addSubview:_labelLookDetailInOrder];
    
    _labelLookDetailInOrderTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, _labelLine.frame.origin.y+_labelLine.frame.size.height+30, SCREEN_WIDTH/2-15, 15)];
    [_labelLookDetailInOrderTotalPrice setBackgroundColor:[UIColor clearColor]];
    [_labelLookDetailInOrderTotalPrice setFont:MKFONT(15)];
    [_labelLookDetailInOrderTotalPrice setTextColor:RGBA(51, 51, 51, 1)];
    [_labelLookDetailInOrderTotalPrice setTextAlignment:NSTextAlignmentRight];
    [_labelLookDetailInOrderTotalPrice setText:@"￥60"];
    _labelLookDetailInOrderTotalPrice.hidden = YES;
    [_viewConfirmOrderBG addSubview:_labelLookDetailInOrderTotalPrice];
    
    //优惠券
    _labelLookDetailInCoupon = [[UILabel alloc] initWithFrame:CGRectMake(15, _labelLookDetailInOrder.frame.origin.y+_labelLookDetailInOrder.frame.size.height+15, SCREEN_WIDTH/2-15, 12)];
    [_labelLookDetailInCoupon setBackgroundColor:[UIColor clearColor]];
    [_labelLookDetailInCoupon setFont:MKFONT(12)];
    [_labelLookDetailInCoupon setTextColor:RGBA(133, 133, 160, 1)];
    [_labelLookDetailInCoupon setTextAlignment:NSTextAlignmentLeft];
    [_labelLookDetailInCoupon setText:@"优惠券："];
    _labelLookDetailInCoupon.hidden = YES;
    [_viewConfirmOrderBG addSubview:_labelLookDetailInCoupon];
    
    _labelLookDetailInCouponPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, _labelLookDetailInOrderTotalPrice.frame.origin.y+_labelLookDetailInOrderTotalPrice.frame.size.height+15, SCREEN_WIDTH/2-15, 15)];
    [_labelLookDetailInCouponPrice setBackgroundColor:[UIColor clearColor]];
    [_labelLookDetailInCouponPrice setFont:MKFONT(15)];
    [_labelLookDetailInCouponPrice setTextColor:RGBA(51, 51, 51, 1)];
    [_labelLookDetailInCouponPrice setTextAlignment:NSTextAlignmentRight];
    _labelLookDetailInCouponPrice.hidden = YES;
    [_viewConfirmOrderBG addSubview:_labelLookDetailInCouponPrice];
    
    //确认订单
    _btnConfirmOrder = [[UIButton alloc] initWithFrame:CGRectMake(15, _viewConfirmOrderBG.frame.size.height-10-40, SCREEN_WIDTH-15*2, 40)];
    [_btnConfirmOrder setBackgroundColor:RGBA(0, 0, 0, 1)];
    [_btnConfirmOrder setTitle:@"确认订单" forState:UIControlStateNormal];
    [_btnConfirmOrder setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    [_btnConfirmOrder.titleLabel setFont:MKFONT(15)];//按钮字体大小
    [_btnConfirmOrder.layer setCornerRadius:20.f];//按钮设置圆角
    [_btnConfirmOrder addTarget:self action:@selector(onBtnConfirmOrderAndPay) forControlEvents:UIControlEventTouchUpInside];
    [_viewConfirmOrderBG addSubview:_btnConfirmOrder];
    
}

-(void)initControllerData
{
    //顶部View
    [self._labelTitle setText:self._memberModel.cinema.cinemaName];
    
/****************卡基本信息****************/
    //卡Logo
    [_imageCardIcon setImage:[UIImage imageNamed:@"image_defaultIcon2.png"]];
    //卡名称
    [_labelCardName setText:self._memberCardDetialModel.cardName];
    //影院名称
    [_labelCinemaName setText:self._memberModel.cinema.cinemaName];
    //有效期
    [_labelDate setText:[NSString stringWithFormat:@"有效期：%@",self._memberCardDetialModel.validDayCountDesc]];
    
    //小计：金额 (改变颜色)
    NSString *str = [NSString stringWithFormat:@"小计：￥%@",[Tool PreserveTowDecimals:self._memberCardDetialModel.price]];
    NSUInteger joinCount =[[NSString stringWithFormat:@"%@", [Tool PreserveTowDecimals:self._memberCardDetialModel.price]] length];
    //算出range的位置
    NSRange oneRange =NSMakeRange(0,3);
    NSRange twoRange =NSMakeRange(3,joinCount+1);
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
    //设置字号 & 颜色
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(11) range:oneRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(15) range:twoRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(123, 122, 152, 1) range:oneRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(246, 81, 81, 1) range:twoRange];
    [_labelSubtotal setAttributedText:strAtt];

/****************权益优惠****************/
    //权益标识
    [_labelRightType setText:@"有可用优惠"];
    
/****************确认订单****************/
    //实付金额：金额
    [_labelActualMoney setText:@"￥60"];

    //订单总价
    [_labelLookDetailInOrderTotalPrice setText:[NSString stringWithFormat:@"￥%@",[Tool PreserveTowDecimals:self._memberCardDetialModel.price]]];
    
    //优惠券
    [_labelLookDetailInCouponPrice setText:@"￥-10"];

}

//弹起权益详情
-(void)onBtnRightDetails
{
    //请求数据
    [self reloadMemberInfo];
}

-(void)reloadMemberInfo
{
    __weak typeof(self) weakSelf = self;
    
    _memberDetailModel = self._memberCardDetialModel;
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    //获取红包列表
    [ServicesRedPacket getRedPacketList:[NSNumber numberWithInt:0] cinemaId:[NSNumber numberWithInt:[[Config getCinemaId] intValue]] cardItemId:self._memberCardDetialModel.cinemaCardItemId goodsIdAndCountList:self._arrayGoods ticketCount:[NSNumber numberWithInt:0] array:^(NSMutableArray *array) {
        //从购买会员卡跳转过来
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        for (int i = 0; i<array.count; i++)
        {
            RedPacketListModel* packModel = array[i];
            if ([packModel.redPacketType intValue] != 3)
            {
                [array removeObjectAtIndex:i];
            }
        }
        _packetArr = [NSArray arrayWithArray:array];
        for (int i = 0; i<array.count; i++)
        {
            [arrayPacket addObject:array[i]];
        }
        
        [weakSelf initRightDetails];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        [weakSelf backViewControllor:error index:2];
    }];
}

-(void)initRightDetails
{
    NSLog(@"权益详情");
    //弹起的View
    UIView *contentSetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 715/2)];
    contentSetView.backgroundColor = RGBA(255, 255, 255, 1);
    
    //顶部标题
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 15)];
    [labelName setBackgroundColor:[UIColor clearColor]];
    [labelName setFont:MKFONT(15)];
    [labelName setTextColor:RGBA(51, 51, 51, 1)];
    [labelName setTextAlignment:NSTextAlignmentCenter];
    [labelName setText:@"权益优惠"];
    [contentSetView addSubview:labelName];
    
    //顶部分割线
    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, labelName.frame.origin.y+labelName.frame.size.height+15, SCREEN_WIDTH, 1)];
    [labelLine setBackgroundColor:RGBA(229, 229, 229, 1)];
    [contentSetView addSubview:labelLine];
    
    //iphone5 最大高715  iphone6最大值836
    _tabRight = [[UITableView alloc] initWithFrame:CGRectMake(0, labelLine.frame.origin.y+labelLine.frame.size.height, SCREEN_WIDTH, 715/2-40-10*2-15-15*2-1)];
    _tabRight.delegate = self;
    _tabRight.dataSource = self;
    [_tabRight setBackgroundColor:RGBA(255, 255, 255, 1)];
    _tabRight.backgroundColor = [UIColor clearColor];
    //分割条颜色
    [_tabRight setSeparatorColor:[UIColor clearColor]];
    [contentSetView addSubview:_tabRight];
    
    //支付按钮
    UIButton *btnRealPricePay = [[UIButton alloc] initWithFrame:CGRectMake(15, _tabRight.frame.origin.y+_tabRight.frame.size.height+10, SCREEN_WIDTH-15*2, 40)];
    [btnRealPricePay setBackgroundColor:RGBA(0, 0, 0, 1)];
    [btnRealPricePay setTitle:@"实付金额：￥50" forState:UIControlStateNormal];
    [btnRealPricePay setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    [btnRealPricePay .titleLabel setFont:MKFONT(15)];//按钮字体大小
    [btnRealPricePay.layer setCornerRadius:20.f];//按钮设置圆角
    [btnRealPricePay addTarget:self action:@selector(onBtnRealPricePay) forControlEvents:UIControlEventTouchUpInside];
    [contentSetView addSubview:btnRealPricePay];
    
    [[ExAlertView sharedAlertView] showAlertViewWithAlertContentView:contentSetView];
}


//查看明细
-(void)onBtnLookDetail:(UIButton *)btn
{
    NSLog(@"查看详情");
    if (btn.tag == 300)
    {
        //展开
        btn.tag = 301;
        [_imageArrowUp setImage:[UIImage imageNamed:@"btn_downArrow.png"]];
        [UIView animateWithDuration:0.3 animations:^{
            _viewConfirmOrderBG.frame = CGRectMake(0, SCREEN_HEIGHT-383/2, SCREEN_WIDTH, 383/2);
            _btnConfirmOrder.frame = CGRectMake(15, _viewConfirmOrderBG.frame.size.height-10-40, SCREEN_WIDTH-15*2, 40);
            _labelLine.hidden = NO;
            _labelLookDetailInOrder.hidden = NO;
            _labelLookDetailInOrderTotalPrice.hidden = NO;
            _labelLookDetailInCoupon.hidden = NO;
            _labelLookDetailInCouponPrice.hidden = NO;
            _viewBlackBG.alpha = 0.5;
    
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        //缩起
        btn.tag = 300;
        [_imageArrowUp setImage:[UIImage imageNamed:@"btn_upArrow.png"]];
        [UIView animateWithDuration:0.3 animations:^{
            _viewConfirmOrderBG.frame = CGRectMake(0, SCREEN_HEIGHT-190/2, SCREEN_WIDTH, 190/2);
            _btnConfirmOrder.frame = CGRectMake(15, _viewConfirmOrderBG.frame.size.height-10-40, SCREEN_WIDTH-15*2, 40);
            _labelLine.hidden = YES;
            _labelLookDetailInOrder.hidden = YES;
            _labelLookDetailInOrderTotalPrice.hidden = YES;
            _labelLookDetailInCoupon.hidden = YES;
            _labelLookDetailInCouponPrice.hidden = YES;
            _viewBlackBG.alpha = 0;
            
        } completion:^(BOOL finished) {
        }];
    }
}

//点击背景收起
- (void)dismissViewBG
{
    _btnLookDetail.tag = 300;
    [_imageArrowUp setImage:[UIImage imageNamed:@"btn_upArrow.png"]];
    [UIView animateWithDuration:0.3 animations:^{
        _viewConfirmOrderBG.frame = CGRectMake(0, SCREEN_HEIGHT-190/2, SCREEN_WIDTH, 190/2);
        _btnConfirmOrder.frame = CGRectMake(15, _viewConfirmOrderBG.frame.size.height-10-40, SCREEN_WIDTH-15*2, 40);
        _labelLine.hidden = YES;
        _labelLookDetailInOrder.hidden = YES;
        _labelLookDetailInOrderTotalPrice.hidden = YES;
        _labelLookDetailInCoupon.hidden = YES;
        _labelLookDetailInCouponPrice.hidden = YES;
        _viewBlackBG.alpha = 0;
        
    } completion:^(BOOL finished) {
    }];
}

//确认订单
-(void)onBtnConfirmOrderAndPay
{
    NSLog(@"确认订单");
    [self buyMemberCard];
    
}

-(void) buyMemberCard
{
//    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    //购买会员卡
    [ServicesPay buyMemberCard:_memberDetailModel.cinemaId cinemaCardId:_memberDetailModel.id redPacket:_arrRedPackIds model:^(MemberCardModel *memberCardModel)
     {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
         BuildOrderModel *_cardOrderModel = [[BuildOrderModel alloc ] init];
         float priceSum = _priceCardZongji - _priceDikou;
         if (priceSum == 0)
         {
             priceSum = 1;
             _cardOrderModel.strAllPrice = [NSString stringWithFormat:@"%.1f",priceSum];
         }
         else
         {
             _cardOrderModel.strAllPrice = [NSString stringWithFormat:@"%ld",priceDetail.realPrice];
         }
         
//         PayViewController *payView = [[PayViewController alloc ] init];
//         payView._orderId = memberCardModel.orderId;
//         payView._orderModel   =_cardOrderModel;
//         payView._viewName = @"UserVIPView";
//         payView._Delegate = weakSelf;
//         [weakSelf.navigationController pushViewController:payView animated:YES];
     } failure:^(NSError *error) {
         [ErrorCodeTip showErrorCodeTip:error.code tipString:error.domain time:2];
//         [weakSelf.navigationController popViewControllerAnimated:YES];
     }];
}

//实付按钮
-(void)onBtnRealPricePay
{
    NSLog(@"实付按钮");
    
    //使用权益优惠后改变文案以及颜色
    [_labelRightType setText:@"已使用权益优惠"];
    [_labelRightType setTextColor:RGBA(51, 51, 51, 0.3)];
    
    [[ExAlertView sharedAlertView] dismissAlertView];
}

-(void)textFiledDidBegin:(UITextField*)textField
{
    if (textField == _textFieldPhone.myTextField && _textFieldPhone.myTextField.text.length>0)
    {
        _textFieldPhone.btnDelete.hidden = NO;
    }
    else
    {
        _textFieldPhone.btnDelete.hidden = YES;
    }
}

-(void)textFiledValueChange:(UITextField*)textField
{
    
    if (textField == _textFieldPhone.myTextField && _textFieldPhone.myTextField.text.length>0)
    {
        if ([_textFieldPhone.myTextField.text length] == 11)
        {
//            [MobClick event:loginEvent1];
        }
        
        _textFieldPhone.btnDelete.hidden = NO;
    }
    else
    {
        _textFieldPhone.btnDelete.hidden = YES;
    }
    
    NSString *lang = [[textField textInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])
    {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (position)
        {
            return;
        }
    }
    int maxLength = 0;
    if (textField == _textFieldPhone.myTextField && textField.text.length > 11)
    {
        maxLength = 11;
        [Tool showWarningTip:@"手机号不能超过11位"  time:0.5];
    }
    if (maxLength != 0)
    {
        textField.text = [textField.text substringToIndex:maxLength];
    }
}

//点击屏幕离开事件
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self HideKeyboard];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self HideKeyboard];
    return YES;
}

//隐藏系统键盘
-(void) HideKeyboard
{
    [_textFieldPhone.myTextField resignFirstResponder];
}

-(void)showHide:(UIView*)view
{
    ExUITextView* exTextView = (ExUITextView*)view;
    exTextView.myTextField.text = nil;
    exTextView.btnDelete.hidden = YES;
}

#pragma mark - TabelViewDelegate
//Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取单元格高度
    CardOrderRightsTableViewCell *cell = (CardOrderRightsTableViewCell*)[self tableView:_tabRight cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}

//Cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayPacket.count;
}

//Cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CardOrderRightsTableViewCell";
    CardOrderRightsTableViewCell *cell;
    
    if (cell == nil)
    {
        cell = [[CardOrderRightsTableViewCell alloc] initWithReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.orderCellDelegate = self;
    
    //红包cell
    RedPacketCellVO* cellModel;
    
    
    if (indexPath.row < arrCacheData.count)
    {
        cellModel = arrCacheData[indexPath.row];
    }
    else
    {
        RedPacketListModel * tmpRedPacket = arrayPacket[indexPath.row];
        
        cellModel = [[RedPacketCellVO alloc]init];
        
        cellModel.redPacketName = tmpRedPacket.redPacketName;
        cellModel.redPacketDetails = [Tool getRedPacketDetail:tmpRedPacket.redPacketType useLimit:tmpRedPacket.useLimit common:[tmpRedPacket.common boolValue]];
        
        cellModel.validEndTime = [NSString stringWithFormat:@"有效期至%@",[Tool returnTime:tmpRedPacket.validEndTime format:@"yyyy年MM月dd日"]];
        cellModel.isViewAlphaHidden = YES;//默认全部显示
        cellModel.currentCount = 0;
        cellModel.worth = tmpRedPacket.worth;
        cellModel.isSelected = NO;//默认未选择
        cellModel.useMaxCount = tmpRedPacket.useMaxCount;//可用红包数目
        cellModel.isPlusMinus = ([tmpRedPacket.totalCount intValue] >1 && [tmpRedPacket.useMaxCount intValue] >0);
        cellModel.useLimit = tmpRedPacket.useLimit;
        cellModel.isCanTouchPlus = YES;
        cellModel.isCanTouchMinus = NO;
        cellModel.redPacketLeftCount = [tmpRedPacket.totalCount intValue];//合并之后的红包剩余数量
        cellModel.currentRedPacketIDs = tmpRedPacket.combineRedPackIdList;//当前红包ID
        cellModel.isCurrency = [tmpRedPacket.common boolValue]; //为true则是通用红包，否则就是不通用红包
        
        [arrCacheData addObject:cellModel];
    }

     //转入红包数据
    [cell setPacketData:cellModel];
    cell.orderCellDelegate = self;
    
    [cell layoutPacket:indexPath.row];
    
    

    return cell;
}

//点击加减的Delegate
-(BOOL)changeredPacketValue:(RedPacketCellVO *)redPacketCellModel isMinu:(BOOL)isMinu
{
    if(isMinu){
        //减少红包ID
        NSNumber *currPacketId = [redPacketCellModel.currentRedPacketIDs objectAtIndex:(redPacketCellModel.currentCount-1)];
        for (int i=0; i<_arrRedPackIds.count; i++)
        {
            if ([_arrRedPackIds[i] isEqual:currPacketId])
            {
                [_arrRedPackIds removeObjectAtIndex:i];
            }
        }
        
        if (redPacketCellModel.currentCount == 0)
        {
            return NO;
        }
        redPacketCellModel.currentCount -= 1;
        if (redPacketCellModel.currentCount == 0)
        {
            redPacketCellModel.isSelected = NO;
        }else{
            redPacketCellModel.isSelected = YES;
        }
        
        
        redPacketCellModel.redPacketLeftCount ++;
        
        
    }else{
        //增加红包ID
        NSNumber *currPacketId = [redPacketCellModel.currentRedPacketIDs objectAtIndex:redPacketCellModel.currentCount];
        [_arrRedPackIds addObject:currPacketId];
        
        if (redPacketCellModel.currentCount == [redPacketCellModel.useMaxCount integerValue])
        {
            return NO;
        }
        redPacketCellModel.currentCount += 1;
        redPacketCellModel.isSelected = YES;
        
        redPacketCellModel.redPacketLeftCount --;
    }
    
    [self filterCachedDatas:redPacketCellModel isCancel:isMinu];
    
    return YES;
}

/**
 * 设置vo 加减按钮状态
 */
-(void)setRespackCellVOPlusMinusStatus:(RedPacketCellVO *)vo{
    
    if (vo.currentCount == 0){
        vo.isCanTouchMinus = NO;
        vo.isCanTouchPlus = YES;
    }else if(vo.currentCount == [vo.useMaxCount integerValue]){
        vo.isCanTouchMinus = YES;
        vo.isCanTouchPlus = NO;
    }else{
        //订单红包只能选择一个
        vo.isCanTouchPlus = NO; //不能在点击加按钮
        vo.isCanTouchMinus = YES;//可以点击减按钮
    }
}

/**
 * 获取参与计算数据
 */
-(NSMutableArray *)getCountResultDatas:(BOOL)isCancel CurrentPacketVO:(RedPacketCellVO *)redPacketCellModel{
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSInteger comparePrice;
    if(isCancel){
        comparePrice = (priceDetail.dicountPrice - [redPacketCellModel.worth intValue]);
    }else{
        comparePrice = (priceDetail.dicountPrice + [redPacketCellModel.worth intValue]);
    }
    
    //比较价格 (当抵扣金额 >= 合计金额的时候，则除选择过的红包以外的所有红包都置灰)
    if (comparePrice >= priceDetail.sumPrice)
    {
        //修改VO
        for(int i = 0 ; i < arrCacheData.count; i++)
        {
            RedPacketCellVO *vo = arrCacheData[i];
            if(vo.isSelected){
                vo.isViewAlphaHidden = YES; //显示
                [self setRespackCellVOPlusMinusStatus:vo];
                [result addObject:vo];
            }else{
                vo.isViewAlphaHidden = NO;//没有选择的都不能再选
                [self setRespackCellVOPlusMinusStatus:vo];
            }
            
        }
    }
    else
    {
        //当抵扣金额 < 合计金额的时候
        //修改VO
        for(int i = 0 ; i < arrCacheData.count; i++)
        {
            RedPacketCellVO *vo = arrCacheData[i];
            if(vo.isSelected){
                [self setRespackCellVOPlusMinusStatus:vo];
                [result addObject:vo];
            }else{
                [self setRespackCellVOPlusMinusStatus:vo];
            }
        }
    }
    
    return result;
}

/**
 * 获取可用红包
 */
-(void)filterCachedDatas:(RedPacketCellVO *)redPacketCellModel isCancel:(BOOL)opt
{
    NSMutableArray *result;
    
    //判断是否为取消操作 若为取消操作(勾选取消/减少) 取消所有置灰
    //取消点击
    if(opt)
    {
        //[初始化数据 显隐]
        if (redPacketCellModel.isCurrency)
        {
            //点击取消 通用红包
            int surplusCount = 0;
            //统计当前选中状态非通用红包数量
            for(int i = 0 ; i < arrCacheData.count; i++)
            {
                RedPacketCellVO *vo = arrCacheData[i];
                if (vo.isSelected && !vo.isCurrency) {
                    surplusCount ++ ;
                }
            }
            //根据选中状态非通用红包数量 修改显示状态
            for(int i = 0 ; i < arrCacheData.count; i++)
            {
                RedPacketCellVO *vo = arrCacheData[i];
                
                if(surplusCount > 0){
                    //存在选中状态非通用红包
                    if (!vo.isSelected && !vo.isCurrency) {
                        //未选中 非通用红包
                        vo.isViewAlphaHidden = NO; //不显示
                    }
                    if (!vo.isSelected && vo.isCurrency) {
                        //未选中 通用红包
                        vo.isViewAlphaHidden = YES; //显示
                    }
                }else{
                    //不存在选中状态非通用红包
                    vo.isViewAlphaHidden = YES; //显示
                }
            }
        }
        else
        {
            //修改VO 做是否是通用红包 显隐设置 由于只能存在一个不通用红包
            //当取消不通用红包时 【初始化】全部显示
            for(int i = 0 ; i < arrCacheData.count; i++)
            {
                RedPacketCellVO *vo = arrCacheData[i];
                vo.isViewAlphaHidden = YES; //显示
            }
        }
    }
    else
    {
        //[初始化数据 显隐]
        if (redPacketCellModel.isCurrency)
        {
            //通用红包 （点击通用红包，其他所有类型红包都可点击）
        }
        else
        {
            //不通用红包 （点击后其他不通用红包不可点击，通用红包可点击）
            //修改vo 做是否是通用红包 显隐设置
            for(int i = 0 ; i < arrCacheData.count; i++)
            {
                RedPacketCellVO *vo = arrCacheData[i];
                if (vo.isCurrency == YES)
                {
                    vo.isViewAlphaHidden = YES; //显示
                }else{
                    vo.isViewAlphaHidden = NO;//不显示
                }
                redPacketCellModel.isViewAlphaHidden = YES;//自己显示
            }
        }
    }
    
    result = [self getCountResultDatas:opt CurrentPacketVO:redPacketCellModel];
    
    //跑价
    RedPacketPriceVO *price = [self countPrice:result];
    //渲染UI
    [self refreshDikouPrice:price];
}

/**
 * 算价
 */
-(RedPacketPriceVO *)countPrice:(NSMutableArray *)datas
{
    //初始化
    if(datas.count == 0)
    {
        priceDetail.dicountPrice = 0;//抵扣金额是0
        priceDetail.sumPrice = _priceCardZongji;//合计
        priceDetail.realPrice = _priceCardZongji;//实付
    }
    else
    {
        //修改VO
        NSInteger dicountPrice = 0;
        for (RedPacketCellModel *object in datas)
        {
            //抵扣的钱
            dicountPrice += (object.currentCount * [object.worth integerValue]);
        }
        //如果抵扣金额 >= 总计金额
        if(dicountPrice >= _priceCardZongji)
        {
            priceDetail.dicountPrice = dicountPrice;
            priceDetail.sumPrice = _priceCardZongji;
            priceDetail.realPrice = 1;
            priceDetail.isShowLableTip = NO;
        }
        else
        {
            //如果抵扣金额 < 总计金额
            priceDetail.dicountPrice = dicountPrice;
            priceDetail.sumPrice = _priceCardZongji;
            priceDetail.realPrice = _priceCardZongji - dicountPrice;
        }
    }
    return priceDetail;
}

/**
 * 刷新ui
 */
-(void)refreshDikouPrice:(RedPacketPriceVO *)countPrice
{
    NSInteger discountPrice = countPrice.dicountPrice;
    NSInteger realPrice = countPrice.realPrice;
    
    if (discountPrice == 0)
    {
        _labelLookDetailInCouponPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:discountPrice]]];
    }
    else
    {
        //如果抵扣的金额大于合计的价格，则抵扣显示合计的价格（抵扣价格用“-”显示）
        if (discountPrice >= countPrice.sumPrice)
        {
            _labelLookDetailInCouponPrice.text = [NSString stringWithFormat:@"¥-%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:countPrice.sumPrice]]];
        }
        else
        {
            //如果抵扣的金额小于合计的价格，则显示抵扣的价格（抵扣价格用“-”显示）
            _labelLookDetailInCouponPrice.text = [NSString stringWithFormat:@"¥-%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:discountPrice]]];
        }
    }
    
    [_labelActualMoney setText:[NSString stringWithFormat:@"¥%@元",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:realPrice]]]];
    [_labelLookDetailInOrderTotalPrice setText:[NSString stringWithFormat:@"¥%@元",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:realPrice]]]];
    
    [_tabRight reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
