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
    [MobClick event:mainViewbtn73];
    
    arrCacheData = [[NSMutableArray alloc]init];
    tempArrCachePacket = [[NSMutableArray alloc]init];
    arrayPacket = [[NSMutableArray alloc]init];
    _arrayMemberCard = [[NSMutableArray alloc ] initWithCapacity:0];
    _lockSeatTimeCount = 0;
    _confirmOrderBGHigh = 0;
    _fWholeHeight = 0;
    //红包使用限制数组，0票红包，4卖品红包，3会员卡红包，初始化都是NoUsedType
    _arrayPacketLimit = [[NSMutableArray alloc]initWithObjects:@4,@4,@4, nil];
    _arrayUsedCardIndex = [[NSMutableArray alloc]init];
    _arrRedPackIds = [[NSMutableArray alloc]init];
    isCanUseCardPack = YES;
    isHaveUseOrderPack = NO;
    isHaveUseNotLimitPack = NO;
    
    [self reloadMemberInfo];
}

#pragma mark - 加载红包列表
-(void)reloadMemberInfo
{
    __weak typeof(self) weakSelf = self;
    
    _memberDetailModel = self._memberCardDetailModel;
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:[UIApplication sharedApplication].keyWindow withTitle:@"加载中..." withBlur:NO allowTap:NO];
    //获取红包列表
    [ServicesRedPacket getRedPacketList:@0 cinemaId:[self._cinema.cinemaId stringValue] cardItemId:self._memberCardDetailModel.cinemaCardItemId goodsIdAndCountList:weakSelf._arrayGoods ticketCount:[NSNumber numberWithInt:0] array:^(NSMutableArray *array) {
        //从购买会员卡跳转过来
        [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
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
            //初始化
            RedPacketListModel * tmpRedPacket = array[i];
            RedPacketCellVO *cellModel = [weakSelf createCellVO:tmpRedPacket];
            //将初始化数据放入VO缓存数据中
            [arrCacheData addObject:cellModel];
            
            RedPacketCellVO *cellModel1 = [weakSelf createCellVO:tmpRedPacket];
            [tempArrCachePacket addObject:cellModel1];
        }
        
        //加载成功 渲染UI
        [weakSelf initCtrl];
        [weakSelf getMyInfo];
        
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
        [weakSelf backViewControllor:error index:2];
    }];
}

-(void)getMyInfo
{
     __weak typeof(self) weakSelf = self;
    [ServicesUser getMyInfo:[Config getUserId] model:^(UserModel *userModel) {
        weakSelf.strTel = userModel.mobileno;
        [weakSelf refreshTel];
    } failure:^(NSError *error) {
        
    }];
}

-(void)refreshTel
{
    _textFieldPhone.text = self.strTel;
    //获取最新下订单保存的手机号
    NSString* strPhone = [Config getUserOrderPhone:[Config getUserId]];
    if (strPhone.length>0)
    {
        _textFieldPhone.text = strPhone;
    }
    if (_textFieldPhone.text.length<=0)
    {
        _labelPhonePrompt.hidden = NO;
    }
    else
    {
        _labelPhonePrompt.hidden = YES;
    }
}

-(void)initCtrl
{
    NSLog(@"%@",[self._cardListModel toJSONString]);
    NSLog(@"%@",[self._memberCardDetailModel toJSONString]);
    
    //顶部View
    [self._labelTitle setText:self._cinema.cinemaName];
    
    [self.view setBackgroundColor:RGBA(246, 246, 251, 1)];
    
    //整体ScrollView
    _scrollViewWholeBG = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-115)];
    [_scrollViewWholeBG setBackgroundColor:[UIColor clearColor]];
    _scrollViewWholeBG.delegate = self;
    [self.view addSubview:_scrollViewWholeBG];
    
    
    //整体View背景
    _viewWholeBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-115)];
    [_viewWholeBG setBackgroundColor:[UIColor clearColor]];
    [_scrollViewWholeBG addSubview:_viewWholeBG];
    
    UILabel *labelRuleDescribe = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 12)];
    [labelRuleDescribe setBackgroundColor:[UIColor clearColor]];
    [labelRuleDescribe setFont:MKFONT(12)];
    [labelRuleDescribe setTextColor:RGBA(123, 122, 152, 0.6)];
    [labelRuleDescribe setTextAlignment:NSTextAlignmentCenter];
    [labelRuleDescribe setText:@"请认真核对订单，一旦售出不支持退款"];
    [_viewWholeBG addSubview:labelRuleDescribe];
    
    /****************卡基本信息****************/
    UIView *viewCardBG = [[UIView alloc] initWithFrame:CGRectMake(15, labelRuleDescribe.frame.origin.y+labelRuleDescribe.frame.size.height+10, SCREEN_WIDTH-15*2, 149.5)];
    [viewCardBG setBackgroundColor:RGBA(255, 255, 255, 1)];
    viewCardBG.layer.borderWidth = 0.5;//边框宽度
    viewCardBG.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];//边框颜色
    viewCardBG.layer.cornerRadius = 2.f;//圆角
    [_viewWholeBG addSubview:viewCardBG];
    
//    //卡Logo
//    _imageCardLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35, 27, 27)];
//    [_imageCardLogo setBackgroundColor:[UIColor clearColor]];
//    /**
//     *  卡类型   普通:-1
//     *          常规:0
//     *          次卡:1
//     *          套票:2
//     *          任看:3
//     *          通票:4
//     */
//    if (
//        [self._cardListModel.cardType intValue] == -1 ||
//        [self._cardListModel.cardType intValue]== 0   ||
//        [self._cardListModel.cardType intValue]== 1   )
//    {
//        //卡类型Logo
//        [_imageCardLogo setImage:[UIImage imageNamed:@"image_membershipCard.png"]];
//    }
//    else
//    {
//        //票类型Logo
//        [_imageCardLogo setImage:[UIImage imageNamed:@"image_ticketType.png"]];
//    }
//    [viewCardBG addSubview:_imageCardLogo];
    
    //卡名称
    _labelCardName = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, viewCardBG.frame.size.width-15*2, 15)];
    [_labelCardName setBackgroundColor:[UIColor clearColor]];
    [_labelCardName setFont:MKFONT(15)];
    [_labelCardName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelCardName setTextAlignment:NSTextAlignmentLeft];
    [_labelCardName setText:self._memberCardDetailModel.cardName];
    [viewCardBG addSubview:_labelCardName];

    //卡描述
    _labelCardDescribe = [[UILabel alloc] initWithFrame:CGRectMake(_labelCardName.frame.origin.x, _labelCardName.frame.origin.y+_labelCardName.frame.size.height+10, _labelCardName.frame.size.width, 12)];
    [_labelCardDescribe setBackgroundColor:[UIColor clearColor]];
    [_labelCardDescribe setFont:MKFONT(12)];
    [_labelCardDescribe setTextColor:RGBA(51, 51, 51, 1)];
    _labelCardDescribe.numberOfLines = 0;
    _labelCardDescribe.lineBreakMode = NSLineBreakByCharWrapping;
    [_labelCardDescribe setText:self._memberCardDetailModel.memo];//原先显示的是影院地址：self._cinemaName
    [Tool setLabelSpacing: _labelCardDescribe spacing:2 alignment:NSTextAlignmentLeft];
    _labelCardDescribe.frame = CGRectMake(_labelCardName.frame.origin.x, _labelCardName.frame.origin.y+_labelCardName.frame.size.height+10, _labelCardName.frame.size.width, _labelCardDescribe.frame.size.height);
    [viewCardBG addSubview:_labelCardDescribe];
    
    //有效期
    _labelDate = [[UILabel alloc] initWithFrame:CGRectMake(_labelCardDescribe.frame.origin.x, _labelCardDescribe.frame.origin.y+_labelCardDescribe.frame.size.height+15, _labelCardDescribe.frame.size.width, 10)];
    [_labelDate setBackgroundColor:[UIColor clearColor]];
    [_labelDate setFont:MKFONT(10)];
    [_labelDate setTextColor:RGBA(123, 122, 152, 1)];
    [_labelDate setTextAlignment:NSTextAlignmentLeft];
    [_labelDate setText:[NSString stringWithFormat:@"有效期：%@天",self._memberCardDetailModel.validDayCount]];
    [viewCardBG addSubview:_labelDate];
    
    //分割线（虚线）
    UIImageView *imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(_labelCardName.frame.origin.x, _labelDate.frame.origin.y+_labelDate.frame.size.height+15, viewCardBG.frame.size.width-15*2, 0.5)];
    [imageLine setBackgroundColor:[UIColor clearColor]];
    [imageLine setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
    [viewCardBG addSubview:imageLine];
    
    //小计：金额(改变颜色)
    _labelSubtotal = [[UILabel alloc] initWithFrame:CGRectMake(imageLine.frame.origin.x, imageLine.frame.origin.y+imageLine.frame.size.height+10, imageLine.frame.size.width, 16)];
    [_labelSubtotal setBackgroundColor:[UIColor clearColor]];
    [_labelSubtotal setTextAlignment:NSTextAlignmentRight];
    
    NSString *str = [NSString stringWithFormat:@"小计：￥%@",[Tool PreserveTowDecimals:self._memberCardDetailModel.price]];
    NSUInteger joinCount =[[NSString stringWithFormat:@"%@", [Tool PreserveTowDecimals:self._memberCardDetailModel.price]] length];
    //算出range的位置
    NSRange oneRange =NSMakeRange(0,3);
    NSRange twoRange =NSMakeRange(3,joinCount+1);
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
    //设置字号 & 颜色
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(12) range:oneRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(16) range:twoRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(123, 122, 152, 1) range:oneRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(249, 81, 81, 1) range:twoRange];
    [_labelSubtotal setAttributedText:strAtt];
    [viewCardBG addSubview:_labelSubtotal];
    
    //重新计算卡基本信息背景高度
    viewCardBG.frame = CGRectMake(15, labelRuleDescribe.frame.origin.y+labelRuleDescribe.frame.size.height+10, SCREEN_WIDTH-15*2, _labelSubtotal.frame.origin.y+_labelSubtotal.frame.size.height+10);
    
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
    [_labelRightType setTextAlignment:NSTextAlignmentRight];
    [viewRightsBG addSubview:_labelRightType];
    
    UIImageView *imageArrowLeft = [[UIImageView alloc] initWithFrame:CGRectMake(_labelRightType.frame.origin.x+_labelRightType.frame.size.width+5.5, 17.5, 5.5, 9)];
    [viewRightsBG addSubview:imageArrowLeft];
    
    //权益按钮
    _btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewRightsBG.frame.size.width, viewRightsBG.frame.size.height)];
    [_btnRight setBackgroundColor:[UIColor clearColor]];
    [viewRightsBG addSubview:_btnRight];
    
    //判断红包列表数组是否存在
    NSLog(@"%@",_packetArr);
    if (ARRAY_IS_EMPTY(_packetArr))
    {
        //无可用优惠，并且不能点击
        [_labelRightType setText:@"无可用优惠"];
        [imageArrowLeft setImage:[UIImage imageNamed:@"image_rightArrow_notRight.png"]];
        [_labelRightType setTextColor:RGBA(51, 51, 51, 0.3)];
        
    }
    else
    {
        //有可用优惠，并且能点击
        [_labelRightType setText:@"有可用优惠"];
        [imageArrowLeft setImage:[UIImage imageNamed:@"image_rightArrow_right.png"]];
        [_labelRightType setTextColor:RGBA(249, 81, 81, 1)];
        
        [_btnRight addTarget:self action:@selector(onButtonRightDetails) forControlEvents:UIControlEventTouchUpInside];
    }
    
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
    [labelPhone setText:@"   手机号"];
    [viewPhoneBG addSubview:labelPhone];
    //星号
    UIImageView *imageStar = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, 7, 15)];
    [imageStar setImage:[UIImage imageNamed:@"image_phoneStar.png"]];
    [labelPhone addSubview:imageStar];
    
    //手机号码默认文本
    _labelPhonePrompt = [[UILabel alloc] initWithFrame:CGRectMake(labelPhone.frame.origin.x+labelPhone.frame.size.width+10, 14.5+1, viewPhoneBG.frame.size.width-15*2-62-10, 12)];
    [_labelPhonePrompt setBackgroundColor:[UIColor clearColor]];
    [_labelPhonePrompt setFont:MKFONT(12)];
    [_labelPhonePrompt setTextColor:RGBA(214, 214, 227, 1)];
    [_labelPhonePrompt setTextAlignment:NSTextAlignmentLeft];
    [_labelPhonePrompt setText:@"请输入手机号码，用于生成订单。"];
    [viewPhoneBG addSubview:_labelPhonePrompt];
    
    //手机号码输入框
    _textFieldPhone= [[UITextField alloc]initWithFrame:CGRectMake(labelPhone.frame.origin.x+labelPhone.frame.size.width+10, 14.5, viewPhoneBG.frame.size.width-15*2-62-10-15, 14)];
    [_textFieldPhone setBackgroundColor:[UIColor clearColor]];
    [_textFieldPhone setTextColor:RGBA(51, 51, 51, 1)];
    _textFieldPhone.delegate = self;
    [_textFieldPhone setValue:RGBA(180, 180, 180, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [_textFieldPhone setFont:MKFONT(14) ];
//    [_textFieldPhone setText:[Config getUserName]];
    _textFieldPhone.contentVerticalAlignment = 0;
    _textFieldPhone.tag = 0;
    _textFieldPhone.borderStyle = UITextBorderStyleNone;
    _textFieldPhone.keyboardType = UIKeyboardTypeNumberPad;
    _textFieldPhone.returnKeyType = UIReturnKeyDefault;
    [_textFieldPhone addTarget:self action:@selector(textFiledDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_textFieldPhone addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    [viewPhoneBG addSubview:_textFieldPhone];
    
    //手机号码清空按钮
    _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(_textFieldPhone.frame.origin.x+_textFieldPhone.frame.size.width, 14.5, 15, 15)];
    _btnCancel.backgroundColor = [UIColor clearColor];
    _btnCancel.hidden = YES;
    [_btnCancel setBackgroundImage:[UIImage imageNamed:@"image_CinemaClear.png"] forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(onButtonCancel) forControlEvents:UIControlEventTouchUpInside];
    [viewPhoneBG addSubview:_btnCancel];
 
    //整体内容控件的高度
    _fWholeHeight = 20+labelRuleDescribe.frame.size.height+10+viewCardBG.frame.size.height+10+viewRightsBG.frame.size.height+10+viewPhoneBG.frame.size.height;
    
    //重新计算
//    if (IPhone5)
//    {
//        _viewWholeBG.frame = CGRectMake(0, 0, SCREEN_WIDTH, _fWholeHeight+80);
//    }
//    else
//    {
//        _viewWholeBG.frame = CGRectMake(0, 0, SCREEN_WIDTH, _fWholeHeight+200);
//    }
    
     _viewWholeBG.frame = CGRectMake(0, 0, SCREEN_WIDTH, _fWholeHeight+20);
    
    [_scrollViewWholeBG setContentSize:CGSizeMake(SCREEN_WIDTH, _viewWholeBG.frame.size.height)];
 
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [_viewWholeBG addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture1.numberOfTapsRequired = 1;
    [_scrollViewWholeBG addGestureRecognizer:gesture1];
    
    /****************下方订单框****************/
    [self initFooter];

    //会员卡合计价
    if ([_memberDetailModel.discountPrice integerValue]==0)
    {
        _priceCardZongji = (float)[_memberDetailModel.price integerValue];
    }
    else
    {
        _priceCardZongji = (float)[_memberDetailModel.discountPrice integerValue];
    }
    
    priceDetail = [[RedPacketPriceVO alloc] init];
    priceDetail.dicountPrice = 0;
    priceDetail.sumPrice = _priceCardZongji;
    priceDetail.realPrice = _priceCardZongji;
    priceDetail.isShowLableTip = YES;
    
    tempPriceDetail = [[RedPacketPriceVO alloc] init];
    tempPriceDetail.dicountPrice = 0;
    tempPriceDetail.sumPrice = _priceCardZongji;
    tempPriceDetail.realPrice = _priceCardZongji;
    tempPriceDetail.isShowLableTip = YES;
    
    [self refreshDikouPrice:priceDetail];
}

-(void)initFooter
{
    _viewConfirmOrderBG = [[UIView alloc] initWithFrame:CGRectZero];
    [_viewConfirmOrderBG setBackgroundColor:RGBA(255, 255, 255, 1)];
    _viewConfirmOrderBG.layer.shadowColor = [RGBA(0, 0, 0, 0.06) CGColor];
    [self.view addSubview:_viewConfirmOrderBG];
    
    //实付金额：金额
    CGSize sizelabelActualMoneyTag = [Tool boundingRectWithSize:@"实付金额：" textFont:MKFONT(12) textSize:CGSizeMake(MAXFLOAT, 12)];
    UILabel *labelActualMoneyTag =  [[UILabel alloc]initWithFrame:CGRectMake(15, 18, sizelabelActualMoneyTag.width, 12)];
    labelActualMoneyTag.text = @"实付金额：";
    labelActualMoneyTag.font = MKFONT(12);
    labelActualMoneyTag.textColor = RGBA(123, 122, 152, 1);
    [_viewConfirmOrderBG addSubview:labelActualMoneyTag];
    
    _labelActualMoney = [[UILabel alloc] initWithFrame:CGRectMake(labelActualMoneyTag.frame.origin.x+labelActualMoneyTag.frame.size.width, 15, SCREEN_WIDTH/2, 17)];
    [_labelActualMoney setBackgroundColor:[UIColor clearColor]];
    [_labelActualMoney setFont:MKFONT(17)];
    [_labelActualMoney setTextColor: RGBA(249, 81, 81, 1)];
    [_labelActualMoney setTextAlignment:NSTextAlignmentLeft];
    [_labelActualMoney setText:[NSString stringWithFormat:@"￥%@",[Tool PreserveTowDecimals:self._memberCardDetailModel.price]]];
    [_viewConfirmOrderBG addSubview:_labelActualMoney];
    
    //上箭头图
    _imageArrowUp = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-9, 19, 9, 5)];
    [_imageArrowUp setImage:[UIImage imageNamed:@"btn_upArrow.png"]];
    [_viewConfirmOrderBG addSubview:_imageArrowUp];
    
    //查看明细按钮
    _btnLookDetail = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-75, 18, 75, 12)];
    [_btnLookDetail setBackgroundColor:[UIColor clearColor]];
    [_btnLookDetail setTitle:@"查看明细" forState:UIControlStateNormal];
    [_btnLookDetail setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];//按钮文字颜色
    [_btnLookDetail .titleLabel setFont:MKFONT(12)];//按钮字体大小
    _btnLookDetail.tag = 300;
    [_btnLookDetail addTarget:self action:@selector(onButtonLookDetail:) forControlEvents:UIControlEventTouchUpInside];
    [_viewConfirmOrderBG addSubview:_btnLookDetail];
    
    //支付提示
    _labelTip = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelTip.text = @"为保证支付安全，每笔订单最低支付0.01元";
    _labelTip.font = MKFONT(10);
    _labelTip.textColor = [UIColor redColor];
    _labelTip.hidden = YES;
    [_viewConfirmOrderBG addSubview:_labelTip];

    //分割线
    _labelLine = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelLine setBackgroundColor:RGBA(0, 0, 0, 0.05)];
    _labelLine.hidden = YES;
    [_viewConfirmOrderBG addSubview:_labelLine];
    
    //支付提示Frame
    if ([self._memberCardDetailModel.price intValue] <= 1)
    {
        _confirmOrderBGHigh = 115;
        _labelTip.frame = CGRectMake(15, _labelActualMoney.frame.origin.y+_labelActualMoney.frame.size.height+10, 300, 10);
        _labelLine.frame = CGRectMake(0, _labelTip.frame.origin.y+_labelTip.frame.size.height+15, SCREEN_WIDTH, 0.5);
    }
    else
    {
        _confirmOrderBGHigh = 95;
        _labelLine.frame = CGRectMake(0, _labelActualMoney.frame.origin.y+_labelActualMoney.frame.size.height+15, SCREEN_WIDTH, 0.5);
    }
    
    _viewConfirmOrderBG.frame = CGRectMake(0, SCREEN_HEIGHT-5-_confirmOrderBGHigh, SCREEN_WIDTH, 5+_confirmOrderBGHigh);
    
    //合计金额
    _labelLookDetailInOrder = [[UILabel alloc] initWithFrame:CGRectMake(15, _labelLine.frame.origin.y+_labelLine.frame.size.height+30, SCREEN_WIDTH/2-15, 12)];
    [_labelLookDetailInOrder setBackgroundColor:[UIColor clearColor]];
    [_labelLookDetailInOrder setFont:MKFONT(12)];
    [_labelLookDetailInOrder setTextColor:RGBA(133, 133, 160, 1)];
    [_labelLookDetailInOrder setTextAlignment:NSTextAlignmentLeft];
    [_labelLookDetailInOrder setText:@"合计金额："];
    _labelLookDetailInOrder.hidden = YES;
    [_viewConfirmOrderBG addSubview:_labelLookDetailInOrder];
    
    _labelLookDetailInOrderTotalPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, _labelLine.frame.origin.y+_labelLine.frame.size.height+30, SCREEN_WIDTH/2-15, 15)];
    [_labelLookDetailInOrderTotalPrice setBackgroundColor:[UIColor clearColor]];
    [_labelLookDetailInOrderTotalPrice setFont:MKFONT(15)];
    [_labelLookDetailInOrderTotalPrice setTextColor:RGBA(51, 51, 51, 1)];
    [_labelLookDetailInOrderTotalPrice setTextAlignment:NSTextAlignmentRight];
    [_labelLookDetailInOrderTotalPrice setText:[NSString stringWithFormat:@"￥%@",[Tool PreserveTowDecimals:self._memberCardDetailModel.price]]];
    _labelLookDetailInOrderTotalPrice.hidden = YES;
    [_viewConfirmOrderBG addSubview:_labelLookDetailInOrderTotalPrice];
    
    //抵扣金额
    _labelLookDetailDeduction = [[UILabel alloc] initWithFrame:CGRectMake(15, _labelLookDetailInOrder.frame.origin.y+_labelLookDetailInOrder.frame.size.height+15, SCREEN_WIDTH/2-15, 12)];
    [_labelLookDetailDeduction setBackgroundColor:[UIColor clearColor]];
    [_labelLookDetailDeduction setFont:MKFONT(12)];
    [_labelLookDetailDeduction setTextColor:RGBA(133, 133, 160, 1)];
    [_labelLookDetailDeduction setTextAlignment:NSTextAlignmentLeft];
    [_labelLookDetailDeduction setText:@"抵扣金额："];
    _labelLookDetailDeduction.hidden = YES;
    [_viewConfirmOrderBG addSubview:_labelLookDetailDeduction];
    
    _labelLookDetailDeductionPrice = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, _labelLookDetailInOrderTotalPrice.frame.origin.y+_labelLookDetailInOrderTotalPrice.frame.size.height+15, SCREEN_WIDTH/2-15, 15)];
    [_labelLookDetailDeductionPrice setBackgroundColor:[UIColor clearColor]];
    [_labelLookDetailDeductionPrice setFont:MKFONT(15)];
    [_labelLookDetailDeductionPrice setTextColor:RGBA(51, 51, 51, 1)];
    [_labelLookDetailDeductionPrice setTextAlignment:NSTextAlignmentRight];
    if (priceDetail.dicountPrice == 0)
    {
        //抵扣金额等于零
        [_labelLookDetailDeductionPrice setText:[NSString stringWithFormat:@"￥%ld",(long)priceDetail.dicountPrice]];
    }
    else
    {
        //抵扣金额不等于零
        [_labelLookDetailDeductionPrice setText:[NSString stringWithFormat:@"-￥%ld",(long)priceDetail.dicountPrice]];
    }
    _labelLookDetailDeductionPrice.hidden = YES;
    [_viewConfirmOrderBG addSubview:_labelLookDetailDeductionPrice];
    
    //确认订单
    _btnConfirmOrder = [[UIButton alloc] initWithFrame:CGRectMake(15, _viewConfirmOrderBG.frame.size.height-10-40, SCREEN_WIDTH-15*2, 40)];
    [_btnConfirmOrder setBackgroundColor:RGBA(0, 0, 0, 1)];
    [_btnConfirmOrder setTitle:@"确认订单" forState:UIControlStateNormal];
    [_btnConfirmOrder setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    [_btnConfirmOrder.titleLabel setFont:MKFONT(15)];//按钮字体大小
    [_btnConfirmOrder.layer setCornerRadius:20.f];//按钮设置圆角
    [_btnConfirmOrder addTarget:self action:@selector(onButtonConfirmOrderAndPay) forControlEvents:UIControlEventTouchUpInside];
    [_viewConfirmOrderBG addSubview:_btnConfirmOrder];
    
    _footerAlpha = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _footerAlpha.backgroundColor = [UIColor blackColor];
    _footerAlpha.alpha = 0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewBG)];
    [_footerAlpha addGestureRecognizer:tapGesture];
    [self.view addSubview:_footerAlpha];
    
    //蒙层
    _imgShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - _viewConfirmOrderBG.frame.size.height-6, SCREEN_WIDTH, 6)];
    _imgShadow.image = [UIImage imageNamed:@"img_public_shadow.png"];
    _imgShadow.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imgShadow];
    
}

-(void)onButtonCancel
{
    _textFieldPhone.text = @"";
    _btnCancel.hidden = YES;
    _labelPhonePrompt.hidden = NO;
}

#pragma mark - 权益详情
-(void)onButtonRightDetails
{
    [MobClick event:mainViewbtn74];
    CGFloat heightView = SCREEN_WIDTH > 320 ? 836/2 : 715/2;
    if (arrayPacket.count < 3)
    {
        heightView = (arrayPacket.count) * 110 + 45 + 65;
    }

    //弹起的View
    UIView *contentSetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, heightView)];
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
    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, labelName.frame.origin.y+labelName.frame.size.height+15, SCREEN_WIDTH, 0.5)];
    [labelLine setBackgroundColor:RGBA(0, 0, 0, 0.05)];
    [contentSetView addSubview:labelLine];
    
    //iphone5 最大高715  iphone6最大值836
    _tabRight = [[UITableView alloc] initWithFrame:CGRectMake(0, labelLine.frame.origin.y+labelLine.frame.size.height, SCREEN_WIDTH, heightView-40-10*2-15-15*2-1)];
    _tabRight.delegate = self;
    _tabRight.dataSource = self;
    [_tabRight setBackgroundColor:RGBA(255, 255, 255, 1)];
    _tabRight.backgroundColor = [UIColor clearColor];
    //分割条颜色
    [_tabRight setSeparatorColor:[UIColor clearColor]];
    [contentSetView addSubview:_tabRight];
    
    //实付按钮
    _btnRealPricePay = [[UIButton alloc] initWithFrame:CGRectMake(15, heightView-10-40, SCREEN_WIDTH-15*2, 40)];
    [_btnRealPricePay setBackgroundColor:RGBA(0, 0, 0, 1)];
    [_btnRealPricePay setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    [_btnRealPricePay .titleLabel setFont:MKFONT(15)];//按钮字体大小
    [_btnRealPricePay.layer setCornerRadius:20.f];//按钮设置圆角
    [_btnRealPricePay setTitle:[NSString stringWithFormat:@"实付金额：￥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:priceDetail.realPrice]]] forState:UIControlStateNormal];
    [_btnRealPricePay addTarget:self action:@selector(onButtonRealPricePay) forControlEvents:UIControlEventTouchUpInside];
    [contentSetView addSubview:_btnRealPricePay];
    
    ExAlertView *myAlertView = [ExAlertView sharedAlertView];
    myAlertView.delegate = self;
    [[ExAlertView sharedAlertView] showAlertViewWithAlertContentView:contentSetView];
    
    //蒙层
    UIImageView* imgShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, _tabRight.frame.origin.y + _tabRight.frame.size.height-6, SCREEN_WIDTH, 6)];
    imgShadow.image = [UIImage imageNamed:@"img_shadow.png"];
    imgShadow.backgroundColor = [UIColor clearColor];
    [contentSetView addSubview:imgShadow];
}

-(void)onButtonRealPricePay
{
    [MobClick event:mainViewbtn77];
    if (_arrRedPackIds.count > 0)
    {
        [_labelRightType setText:@"已使用优惠"];
        [_labelRightType setTextColor:RGBA(249, 81, 81, 1)];
    }
    else
    {
        [_labelRightType setText:@"有可用优惠"];
        [_labelRightType setTextColor:RGBA(249, 81, 81, 1)];
    }
    
    [[ExAlertView sharedAlertView] dismissAlertView];
}

-(void)dismissExAlertView:(ExAlertView *)view isTouchBlank:(BOOL)flag
{
    if(flag)
    {
        //如果点击空白 数据还原成上一次数据
        arrCacheData = [[NSMutableArray alloc] init];
        for(RedPacketCellVO *vo in tempArrCachePacket)
        {
            RedPacketCellVO *newVo = [self copyCellVO:vo];
            [arrCacheData addObject:newVo];
        }
        priceDetail = [[RedPacketPriceVO alloc] init];
        priceDetail.dicountPrice = tempPriceDetail.dicountPrice;
        priceDetail.sumPrice = tempPriceDetail.sumPrice;
        priceDetail.realPrice = tempPriceDetail.realPrice;
        priceDetail.isShowLableTip = tempPriceDetail.isShowLableTip;
    }
    else
    {
        //如果点击确定 修改历史位当前数据
        tempArrCachePacket = [[NSMutableArray alloc] init];
        for(RedPacketCellVO *vo in arrCacheData)
        {
            RedPacketCellVO *newVo = [self copyCellVO:vo];
            [tempArrCachePacket addObject:newVo];
        }
        tempPriceDetail = [[RedPacketPriceVO alloc] init];
        tempPriceDetail.dicountPrice = priceDetail.dicountPrice;
        tempPriceDetail.sumPrice = priceDetail.sumPrice;
        tempPriceDetail.realPrice = priceDetail.realPrice;
        tempPriceDetail.isShowLableTip = priceDetail.isShowLableTip;
    }
    [self refreshDikouPrice:priceDetail];
}

#pragma mark - 查看明细
-(void)onButtonLookDetail:(UIButton *)btn
{
    [MobClick event:mainViewbtn79];
    if (btn.tag == 300)
    {
        //展开
        btn.tag = 301;
        [_imageArrowUp setImage:[UIImage imageNamed:@"btn_downArrow.png"]];
        
        [self.view bringSubviewToFront:_footerAlpha];
        _labelLine.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            _viewConfirmOrderBG.frame = CGRectMake(0, SCREEN_HEIGHT-5-_confirmOrderBGHigh*2, SCREEN_WIDTH, 5+_confirmOrderBGHigh*2);
            _btnConfirmOrder.frame = CGRectMake(15, _viewConfirmOrderBG.frame.size.height-10-40, SCREEN_WIDTH-15*2, 40);
            _imgShadow.frame = CGRectMake(0, SCREEN_HEIGHT - _viewConfirmOrderBG.frame.size.height-6, SCREEN_WIDTH, 6);
            [self.view bringSubviewToFront:_viewConfirmOrderBG];
            _footerAlpha.alpha = 0.5;
            
        } completion:^(BOOL finished) {
            _labelLookDetailInOrder.hidden = NO;
            _labelLookDetailInOrderTotalPrice.hidden = NO;
            _labelLookDetailDeduction.hidden = NO;
            _labelLookDetailDeductionPrice.hidden = NO;
        }];
    }
    else
    {
        //缩起
        btn.tag = 300;
        [_imageArrowUp setImage:[UIImage imageNamed:@"btn_upArrow.png"]];
        _labelLine.hidden = YES;
        _labelLookDetailInOrder.hidden = YES;
        _labelLookDetailInOrderTotalPrice.hidden = YES;
        _labelLookDetailDeduction.hidden = YES;
        _labelLookDetailDeductionPrice.hidden = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            _viewConfirmOrderBG.frame = CGRectMake(0, SCREEN_HEIGHT-5-_confirmOrderBGHigh, SCREEN_WIDTH, 5+_confirmOrderBGHigh);
            _btnConfirmOrder.frame = CGRectMake(15, _viewConfirmOrderBG.frame.size.height-10-40, SCREEN_WIDTH-15*2, 40);
            _imgShadow.frame = CGRectMake(0, SCREEN_HEIGHT - _viewConfirmOrderBG.frame.size.height-6, SCREEN_WIDTH, 6);
            _footerAlpha.alpha = 0;
            
        } completion:^(BOOL finished) {
        }];
    }
}

//点击背景收起
- (void)dismissViewBG
{
    _btnLookDetail.tag = 300;
    [_imageArrowUp setImage:[UIImage imageNamed:@"btn_upArrow.png"]];
    _labelLine.hidden = YES;
    _labelLookDetailInOrder.hidden = YES;
    _labelLookDetailInOrderTotalPrice.hidden = YES;
    _labelLookDetailDeduction.hidden = YES;
    _labelLookDetailDeductionPrice.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        _viewConfirmOrderBG.frame = CGRectMake(0, SCREEN_HEIGHT-5-_confirmOrderBGHigh, SCREEN_WIDTH, 5+_confirmOrderBGHigh);
        _btnConfirmOrder.frame = CGRectMake(15, _viewConfirmOrderBG.frame.size.height-10-40, SCREEN_WIDTH-15*2, 40);
        _imgShadow.frame = CGRectMake(0, SCREEN_HEIGHT - _viewConfirmOrderBG.frame.size.height-6, SCREEN_WIDTH, 6);
        _footerAlpha.alpha = 0;
        
    } completion:^(BOOL finished) {
    }];
}

-(void)isTipShow:(RedPacketPriceVO *)countPrice
{
    if (countPrice.realPrice <= 1)
    {
        //实付金额 <= 0 （显示安全提示）
        _labelTip.hidden = NO;
        _confirmOrderBGHigh = 115;
        _labelTip.frame = CGRectMake(15, _labelActualMoney.frame.origin.y+_labelActualMoney.frame.size.height+10, 300, 10);
        _labelLine.frame = CGRectMake(0, _labelTip.frame.origin.y+_labelTip.frame.size.height+15, SCREEN_WIDTH, 0.5);
    }
    else
    {
        _labelTip.hidden = YES;
        _confirmOrderBGHigh = 95;
        _labelLine.frame = CGRectMake(0, _labelActualMoney.frame.origin.y+_labelActualMoney.frame.size.height+15, SCREEN_WIDTH, 0.5);
    }
    //合计金额
    _labelLookDetailInOrder.frame = CGRectMake(15, _labelLine.frame.origin.y+_labelLine.frame.size.height+30, SCREEN_WIDTH/2-15, 12);
    _labelLookDetailInOrderTotalPrice.frame = CGRectMake(SCREEN_WIDTH/2, _labelLine.frame.origin.y+_labelLine.frame.size.height+30, SCREEN_WIDTH/2-15, 15);
    //抵扣金额
    _labelLookDetailDeduction.frame = CGRectMake(15, _labelLookDetailInOrder.frame.origin.y+_labelLookDetailInOrder.frame.size.height+15, SCREEN_WIDTH/2-15, 12);
    _labelLookDetailDeductionPrice.frame = CGRectMake(SCREEN_WIDTH/2, _labelLookDetailInOrderTotalPrice.frame.origin.y+_labelLookDetailInOrderTotalPrice.frame.size.height+15, SCREEN_WIDTH/2-15, 15);
    
    _viewConfirmOrderBG.frame = CGRectMake(0, SCREEN_HEIGHT-5-_confirmOrderBGHigh, SCREEN_WIDTH, 5+_confirmOrderBGHigh);
    
    //确认订单
    _btnConfirmOrder.frame = CGRectMake(15, _viewConfirmOrderBG.frame.size.height-10-40, SCREEN_WIDTH-15*2, 40);
    _imgShadow.frame = CGRectMake(0, SCREEN_HEIGHT - _viewConfirmOrderBG.frame.size.height-6, SCREEN_WIDTH, 6);
}

#pragma mark - 确认订单
-(void)onButtonConfirmOrderAndPay
{
    [MobClick event:mainViewbtn80];
    //判断手机号
    if (_textFieldPhone.text.length != 11 || ![Tool validateTel:_textFieldPhone.text])
    {
        [Tool showWarningTip:@"您输入的手机号不对哦~"  time:0.5];
        [self showKeyBoard];
    }
    else
    {
        //手机号正确进行买卡
        [self buyMemberCard];
    }
}

-(void)buyMemberCard
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    //购买会员卡
    [ServicesPay buyMemberCard:[_memberDetailModel.cinemaId stringValue] cinemaCardId:_memberDetailModel.id redPacket:_arrRedPackIds mobileNo:_textFieldPhone.text model:^(MemberCardModel *modelMemberCardModel)
     {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
         BuildOrderModel *_cardOrderModel = [[BuildOrderModel alloc ] init];
         float fPriceSum = _priceCardZongji - _priceDikou;
         if (fPriceSum == 0)
         {
             fPriceSum = 1;
             _cardOrderModel.strAllPrice = [NSString stringWithFormat:@"%.1f",fPriceSum];
         }
         else
         {
             _cardOrderModel.strAllPrice = [NSString stringWithFormat:@"%ld",(long)priceDetail.realPrice];
         }
         
         [Config saveUserOrderPhone:[Config getUserId] phoneText:_textFieldPhone.text];
         
          PayViewController *payView = [[PayViewController alloc ] init];
          payView._orderId = modelMemberCardModel.orderId;
          payView._orderModel =_cardOrderModel;
          payView._viewName = @"UserVIPView";
          payView._Delegate = weakSelf;
          [weakSelf.navigationController pushViewController:payView animated:YES];
     } failure:^(NSError *error) {
         [Tool showWarningTip:error.domain time:2];
//         [weakSelf.navigationController popViewControllerAnimated:YES];
     }];
}

#pragma mark - ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //监听向下滑动
    if (_scrollViewWholeBG.contentOffset.y < 0)
    {
        [self HideKeyboard];
    }
}

#pragma mark - TextFiledDelegate
-(void)textFiledDidBegin:(UITextField*)textField
{
    [MobClick event:mainViewbtn78];
    [_btnRight setUserInteractionEnabled:NO];//按钮不可点击
    
    if (_textFieldPhone.text.length>0)
    {
        //里面有内容的时候 显示取消按钮
        _btnCancel.hidden = NO;
        _labelPhonePrompt.hidden = YES;
    }
    else
    {
        _btnCancel.hidden = YES;
        _labelPhonePrompt.hidden = NO;
    }

    [self.view sendSubviewToBack:_viewWholeBG];
    
    float fBounceHeight = 0;
    
//    if (_fWholeHeight > _scrollViewWholeBG.frame.size.height)
//    {
//        fBounceHeight = -100;
//    }
//    else
//    {
//        fBounceHeight = -60;
//    }

    if (_fWholeHeight > _scrollViewWholeBG.frame.size.height*0.8)
    {
        if (IPhone5)
        {
            fBounceHeight = -200;
        }
        else
        {
            fBounceHeight = -130;
        }
    }
    else
    {
        if (IPhone5)
        {
            fBounceHeight = -100;
        }
        else
        {
            fBounceHeight = -60;
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
//        _viewWholeBG.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-115);
        _viewWholeBG.frame = CGRectMake(0, fBounceHeight, SCREEN_WIDTH, _viewWholeBG.frame.size.height);
        
    } completion:^(BOOL finished) {
    }];
}

-(void)textFiledValueChange:(UITextField*)textField
{
    [_btnRight setUserInteractionEnabled:NO];//按钮不可点击
    NSString *strLang = [[textField textInputMode] primaryLanguage];
    if ([strLang isEqualToString:@"zh-Hans"])
    {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (position)
        {
            return;
        }
    }
    
    int maxLength = 0;
    if (textField.text.length > 11)
    {
        maxLength = 11;
        [Tool showWarningTip:@"手机号不能超过11位"  time:0.5];
    }
    if (maxLength != 0)
    {
        textField.text = [textField.text substringToIndex:maxLength];
    }
    
    if (_textFieldPhone.text.length > 0)
    {
        _btnCancel.hidden = NO;
        _labelPhonePrompt.hidden = YES;
    }
    if (_textFieldPhone.text.length == 0)
    {
        _btnCancel.hidden = YES;
        _labelPhonePrompt.hidden = NO;
    }
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self HideKeyboard];
}

//点击屏幕离开事件
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self HideKeyboard];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self HideKeyboard];
    return YES;
}

//显示系统键盘
-(void)showKeyBoard
{
    [_textFieldPhone becomeFirstResponder];
}

//隐藏系统键盘
-(void)HideKeyboard
{
    [_btnRight setUserInteractionEnabled:YES];//按钮可点击
    
    [UIView animateWithDuration:0.3 animations:^{
//        _viewWholeBG.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-115);
        _viewWholeBG.frame = CGRectMake(0, 0, SCREEN_WIDTH, _viewWholeBG.frame.size.height);
        
    } completion:^(BOOL finished) {
    }];
    
    [_textFieldPhone resignFirstResponder];
}

#pragma mark - TabelViewDelegate
//Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    36+14+15+12+10+11+30+0.5
    return 128.5;
    
//    //获取单元格高度
//    CardOrderRightsTableViewCell *cell = (CardOrderRightsTableViewCell*)[self tableView:_tabRight cellForRowAtIndexPath:indexPath];
//    return cell.contentView.frame.size.height;
}

//Cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayPacket.count;
}

//Cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"CardOrderRightsTableViewCell%ld",(long)indexPath.row];
    CardOrderRightsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[CardOrderRightsTableViewCell alloc] initWithReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.orderCellDelegate = self;
    if (indexPath.row < arrayPacket.count)
    {
        //红包cell
        NSInteger leftCount = _packetArr.count - arrayPacket.count;
        RedPacketCellVO* cellModel;
        
        cellModel = arrCacheData[indexPath.row];
        
        //转入红包数据
        [cell setPacketData:cellModel];
        
        cell.orderCellDelegate = self;
        
        BOOL isShowMore = NO;
        if (arrayPacket.count == 2 && indexPath.row == 1 && leftCount>0)
        {
            isShowMore = YES;
        }
        [cell layoutPacket:indexPath.row isShowMore:isShowMore];
    }
    return cell;
}

-(RedPacketCellVO *)createCellVO:(RedPacketListModel *) tmpRedPacket
{
    RedPacketCellVO *cellModel = [[RedPacketCellVO alloc]init];
    
    //红包名称
    cellModel.redPacketName = tmpRedPacket.redPacketName;
    //红包描述
    cellModel.redPacketDetails = [Tool getRedPacketDetail:tmpRedPacket.redPacketType useLimit:tmpRedPacket.useLimit]; //common:[tmpRedPacket.common boolValue]];
    //有效期
    cellModel.validEndTime = [NSString stringWithFormat:@"有效期至%@",
                              [Tool returnTime:tmpRedPacket.validEndTime format:@"yyyy年MM月dd日"]];
    //默认全部显示
    cellModel.isViewAlphaHidden = YES;
    //默认未选择红包数量
    cellModel.currentCount = 0;
    //红包价值（抵扣的单价）
    cellModel.worth = tmpRedPacket.worth;
    //默认未选择
    cellModel.isSelected = NO;
    //可用红包数目
    cellModel.useMaxCount = tmpRedPacket.useMaxCount;
    //红包合并之后的数目>1并且可用数目>0
    cellModel.isPlusMinus = ([tmpRedPacket.totalCount intValue] >1 &&
                             [tmpRedPacket.useMaxCount intValue] >0);
    //限制类型（0：不限制 1：票/小卖 2：订单）
    cellModel.useLimit = tmpRedPacket.useLimit;
    //可以加
    cellModel.isCanTouchPlus = YES;
    //不可以减
    cellModel.isCanTouchMinus = NO;
    //合并之后的红包剩余数量
    cellModel.redPacketLeftCount = [tmpRedPacket.totalCount intValue];
    //当前红包ID
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(NSNumber *id in tmpRedPacket.combineRedPackIdList)
    {
        [arr addObject:id];
    }
    cellModel.currentRedPacketIDs = [arr copy];
    //为true则是通用红包，否则就是不通用红包
    cellModel.isCurrency = [tmpRedPacket.common boolValue];
    
    return cellModel;
}

-(RedPacketCellVO *)copyCellVO:(RedPacketCellVO *)tmpRedPacket
{
    RedPacketCellVO *cellModel = [[RedPacketCellVO alloc]init];
    
    //红包名称
    cellModel.redPacketName = tmpRedPacket.redPacketName;
    //红包描述
    cellModel.redPacketDetails = tmpRedPacket.redPacketDetails;
    //有效期
    cellModel.validEndTime = tmpRedPacket.validEndTime;
    //全部显示状态
    cellModel.isViewAlphaHidden = tmpRedPacket.isViewAlphaHidden;
    //选择红包数量
    cellModel.currentCount = tmpRedPacket.currentCount;
    //红包价值（抵扣的单价）
    cellModel.worth = tmpRedPacket.worth;
    //选择状态
    cellModel.isSelected = tmpRedPacket.isSelected;
    //可用红包数目
    cellModel.useMaxCount = tmpRedPacket.useMaxCount;
    //红包合并之后的数目>1并且可用数目>0
    cellModel.isPlusMinus = tmpRedPacket.isPlusMinus;
    //限制类型（0：不限制 1：票/小卖 2：订单）
    cellModel.useLimit = tmpRedPacket.useLimit;
    //加减状态
    cellModel.isCanTouchPlus = tmpRedPacket.isCanTouchPlus;
    cellModel.isCanTouchMinus = tmpRedPacket.isCanTouchMinus;
    //合并之后的红包剩余数量
    cellModel.redPacketLeftCount = tmpRedPacket.redPacketLeftCount;
    //当前红包ID
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(NSNumber *id in tmpRedPacket.currentRedPacketIDs)
    {
        [arr addObject:id];
    }
    cellModel.currentRedPacketIDs = [arr copy];
    //为true则是通用红包，否则就是不通用红包
    cellModel.isCurrency = tmpRedPacket.isCurrency;
    
    return cellModel;
}

#pragma mark - 点击加减的Delegate
-(BOOL)changeredPacketValue:(RedPacketCellVO *)redPacketCellModel isMinu:(BOOL)isMinu
{
    if(isMinu)
    {
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
        }
        else
        {
            redPacketCellModel.isSelected = YES;
        }
        redPacketCellModel.redPacketLeftCount ++;
    }
    else
    {
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

#pragma mark - 设置vo 加减按钮状态
-(void)setRespackCellVOPlusMinusStatus:(RedPacketCellVO *)vo
{
    if (vo.currentCount == 0){
        vo.isCanTouchMinus = NO;
        vo.isCanTouchPlus = YES;
    }
    else if(vo.currentCount == [vo.useMaxCount integerValue])
    {
        vo.isCanTouchMinus = YES;
        vo.isCanTouchPlus = NO;
    }
    else
    {
        //订单红包只能选择一个
        vo.isCanTouchPlus = NO; //不能在点击加按钮
        vo.isCanTouchMinus = YES;//可以点击减按钮
    }
}

#pragma mark - 获取参与计算数据
-(NSMutableArray *)getCountResultDatas:(BOOL)isCancel CurrentPacketVO:(RedPacketCellVO *)redPacketCellModel
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSInteger comparePrice;
    if(isCancel)
    {
        comparePrice = (priceDetail.dicountPrice - [redPacketCellModel.worth intValue]);
    }
    else
    {
        comparePrice = (priceDetail.dicountPrice + [redPacketCellModel.worth intValue]);
    }
    
    //比较价格 (当抵扣金额 >= 合计金额的时候，则除选择过的红包以外的所有红包都置灰)
    if (comparePrice >= priceDetail.sumPrice)
    {
        //修改VO
        for(int i = 0 ; i < arrCacheData.count; i++)
        {
            RedPacketCellVO *vo = arrCacheData[i];
            if(vo.isSelected)
            {
                vo.isViewAlphaHidden = YES; //显示
                [self setRespackCellVOPlusMinusStatus:vo];
                [result addObject:vo];
            }
            else
            {
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

#pragma mark - 获取可用红包
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
                if (vo.isSelected && !vo.isCurrency)
                {
                    surplusCount ++ ;
                }
            }
            //根据选中状态非通用红包数量 修改显示状态
            for(int i = 0 ; i < arrCacheData.count; i++)
            {
                RedPacketCellVO *vo = arrCacheData[i];
                
                if(surplusCount > 0)
                {
                    //存在选中状态非通用红包
                    if (!vo.isSelected && !vo.isCurrency)
                    {
                        //未选中 非通用红包
                        vo.isViewAlphaHidden = NO; //不显示
                    }
                    if (!vo.isSelected && vo.isCurrency)
                    {
                        //未选中 通用红包
                        vo.isViewAlphaHidden = YES; //显示
                    }
                }
                else
                {
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
                }
                else
                {
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

#pragma mark - 算价
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

#pragma mark - 刷新UI
-(void)refreshDikouPrice:(RedPacketPriceVO *)countPrice
{
    //总价
    NSInteger sumPrice = countPrice.sumPrice;
    //折扣
    NSInteger discountPrice = countPrice.dicountPrice;
    //实付
    NSInteger realPrice = countPrice.realPrice;
    
    //真实抵扣价
    NSInteger tempDiscountPrice = 0;
    
    if (discountPrice == 0)
    {
        tempDiscountPrice = discountPrice;
    }
    else
    {
        //如果抵扣的金额大于合计的价格，则抵扣显示合计的价格（抵扣价格用“-”显示）
        if (discountPrice >= countPrice.sumPrice)
        {
            //如果抵扣金额大于总额 最少支付1分钱 抵扣=总额-1分钱
            tempDiscountPrice = countPrice.sumPrice - 1;
        }
        else
        {
            //如果抵扣的金额小于合计的价格，则显示抵扣的价格（抵扣价格用“-”显示）
            tempDiscountPrice = discountPrice;
        }
    }
    
    //labelTip.hidden = countPrice.isShowLableTip;
    
    //确认订单 - 实付金额
    _labelActualMoney.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:realPrice]]];
    
    //确认订单 - 订单价
    _labelLookDetailInOrderTotalPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:sumPrice]]];
    
    //确认订单 - 优惠券
    if (tempDiscountPrice == 0)
    {
        //抵扣金额等于0
        _labelLookDetailDeductionPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:tempDiscountPrice]]];
    }
    else
    {
        //抵扣金额不等于0
        _labelLookDetailDeductionPrice.text = [NSString stringWithFormat:@"-¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:tempDiscountPrice]]];
    }
    
    //权益详情 - 实付金额
    [_btnRealPricePay setTitle:[NSString stringWithFormat:@"实付金额：¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:realPrice]]] forState:UIControlStateNormal] ;
    
    //判断是否显示0.01元安全提示
    [self isTipShow:countPrice];
    
    [_tabRight reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getMemberCard
{
    
}


@end
