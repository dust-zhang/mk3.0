//
//  SaleOrderViewController.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/16.
//
//

#import "SaleOrderViewController.h"

@interface SaleOrderViewController ()

@end

@implementation SaleOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(246, 246, 251,1);
    self._labelTitle.text = [Config getCinemaName];
    
    //初始化一些全局数据
    arrayRedPacketModel = [[NSMutableArray alloc]init];
    _lastArrRedPacketModel = [[NSMutableArray alloc]init];
    _lastArrRedPackIds = [[NSMutableArray alloc]init];
    
    //红包使用限制数组，0使用过不限制红包  1使用过票/小卖数限制红包  2使用过订单红包  4没有使用过
    _arrayPacketLimit = [[NSMutableArray alloc]initWithObjects:@4,@4,@4, nil];
    _arrRedPackIds = [[NSMutableArray alloc]init];
    
    _lockSeatTimeCount = 0;
    
    [self initControl];
    [self initOrderGoodsView];
    [self initFooter];
    [self loadRedPacketInfo];
}

-(void)initControl
{
    UILabel* labelRuleDescribe = [[UILabel alloc] initWithFrame:CGRectMake(0, self._viewTop.frame.size.height+20, SCREEN_WIDTH, 12)];
    [labelRuleDescribe setBackgroundColor:[UIColor clearColor]];
    [labelRuleDescribe setFont:MKFONT(12)];
    [labelRuleDescribe setTextColor:RGBA(123, 122, 152, 0.6)];
    [labelRuleDescribe setTextAlignment:NSTextAlignmentCenter];
    [labelRuleDescribe setText:@"请认真核对订单，一旦售出不支持退款"];
    [self.view addSubview:labelRuleDescribe];
}

-(void)initFooter
{
    _viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-92, SCREEN_WIDTH, 92)];
    _viewFooter.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewFooter];
    
    CGSize sizeLabelReal = [Tool boundingRectWithSize:@"实付金额：" textFont:MKFONT(12) textSize:CGSizeMake(MAXFLOAT, 12)];
    UILabel* labelReal = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, sizeLabelReal.width, 12)];
    labelReal.text = @"实付金额：";
    labelReal.font = MKFONT(12);
    labelReal.textColor = RGBA(123, 122, 152, 1);
    [_viewFooter addSubview:labelReal];
    
    //支付提示
    _labelTip = [[UILabel alloc]initWithFrame:CGRectMake(15, labelReal.frame.origin.y+labelReal.frame.size.height+6, 300, 10)];
    _labelTip.text = @"为保证支付安全，每笔订单最低支付0.01元";
    _labelTip.font = MKFONT(10);
    _labelTip.textColor = [UIColor redColor];
    _labelTip.hidden = YES;
    [_viewFooter addSubview:_labelTip];
    
    //实付金额
    _labelRealPrice = [[UILabel alloc]initWithFrame:CGRectMake(labelReal.frame.origin.x+labelReal.frame.size.width, 10, 100, 17)];
    _labelRealPrice.textColor = RGBA(249, 81, 81, 1);
    _labelRealPrice.text = [NSString stringWithFormat:@"¥ %@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:self.totalPrice]]];
    _labelRealPrice.font = MKFONT(17);
    [_viewFooter addSubview:_labelRealPrice];
    
    //上箭头图
    _imageArrowUp = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-9, 10+15/2, 9, 5)];
    [_imageArrowUp setImage:[UIImage imageNamed:@"btn_upArrow.png"]];
    [_viewFooter addSubview:_imageArrowUp];
    
    //查看明细按钮
    UIButton* btnLookDetail = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-75, 11, 75, 20)];
    [btnLookDetail setBackgroundColor:[UIColor clearColor]];
    [btnLookDetail setTitle:@"查看明细" forState:UIControlStateNormal];
    [btnLookDetail setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];//按钮文字颜色
    [btnLookDetail .titleLabel setFont:MKFONT(12)];//按钮字体大小
    btnLookDetail.tag = 300;
    [btnLookDetail addTarget:self action:@selector(onButtonLookDetail:) forControlEvents:UIControlEventTouchUpInside];
    [_viewFooter addSubview:btnLookDetail];
    
    _btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnConfirm.frame = CGRectMake(15, _viewFooter.frame.size.height-10-40, SCREEN_WIDTH-30, 40);
    _btnConfirm.backgroundColor = [UIColor blackColor];
    [_btnConfirm setTitle:@"确认订单" forState:UIControlStateNormal];
    _btnConfirm.titleLabel.font = MKFONT(15);
    _btnConfirm.layer.masksToBounds = YES;
    _btnConfirm.layer.cornerRadius = 20;
    [_btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnConfirm addTarget:self action:@selector(onButtonCreateOrder:) forControlEvents:UIControlEventTouchUpInside];
    [_viewFooter addSubview:_btnConfirm];
    
    _footerAlpha = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _footerAlpha.backgroundColor = [UIColor blackColor];
    _footerAlpha.alpha = 0;
    [self.view addSubview:_footerAlpha];
    
    UITapGestureRecognizer* footerGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeDetail)];
    [_footerAlpha addGestureRecognizer:footerGes];
    
    [self addDikouView];
    _viewline.hidden = YES;
    _labelHejiPrice.hidden = YES;
    _labelHeji.hidden = YES;
    _labelDikouPrice.hidden = YES;
    _labelDikou.hidden = YES;
    
    //蒙层
    _imgShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - _viewFooter.frame.size.height-6, SCREEN_WIDTH, 6)];
    _imgShadow.image = [UIImage imageNamed:@"img_public_shadow.png"];
    _imgShadow.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_imgShadow];
}

-(void)refreshFooterFrame:(BOOL)isHideTip
{
    if (isHideTip)
    {
        //不是1分支付
        _viewFooter.frame = CGRectMake(0, SCREEN_HEIGHT-92, SCREEN_WIDTH, 92);
        _imgShadow.frame = CGRectMake(0, SCREEN_HEIGHT - _viewFooter.frame.size.height-6, SCREEN_WIDTH, 6);
        _labelTip.frame = CGRectZero;
        _viewline.frame = CGRectMake(0, 41, SCREEN_WIDTH, 1);
        _labelHeji.frame = CGRectMake(15, 42+30, 100, 12);
        _labelDikou.frame = CGRectMake(15, _labelHeji.frame.origin.y+_labelHeji.frame.size.height+15, 100, 12);
        _labelHejiPrice.frame = CGRectMake(SCREEN_WIDTH-15-150, _labelHeji.frame.origin.y-3, 150, 15);
        _labelDikouPrice.frame = CGRectMake(SCREEN_WIDTH-15-150, _labelDikou.frame.origin.y-3, 150, 15);
        _btnConfirm.frame = CGRectMake(15, _viewFooter.frame.size.height-10-40, SCREEN_WIDTH-30, 40);
    }
    else
    {
        _labelDikouPrice.text = [NSString stringWithFormat:@"-¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceDikou-1]]];
        
        _viewFooter.frame = CGRectMake(0, SCREEN_HEIGHT-_viewFooter.frame.size.height-16, SCREEN_WIDTH, _viewFooter.frame.size.height+16);
        _imgShadow.frame = CGRectMake(0, SCREEN_HEIGHT - _viewFooter.frame.size.height-6, SCREEN_WIDTH, 6);
        _labelTip.frame = CGRectMake(15, 33, 300, 10);
        _viewline.frame = CGRectMake(0, _viewline.frame.origin.y+16, SCREEN_WIDTH, 1);
        _labelHeji.frame = CGRectMake(_labelHeji.frame.origin.x, _labelHeji.frame.origin.y+16, _labelHeji.frame.size.width, _labelHeji.frame.size.height);
        _labelDikou.frame = CGRectMake(_labelDikou.frame.origin.x, _labelDikou.frame.origin.y+16, _labelDikou.frame.size.width, _labelDikou.frame.size.height);
        _labelHejiPrice.frame = CGRectMake(_labelHejiPrice.frame.origin.x, _labelHejiPrice.frame.origin.y+16, _labelHejiPrice.frame.size.width, _labelHejiPrice.frame.size.height);
        _labelDikouPrice.frame = CGRectMake(_labelDikouPrice.frame.origin.x, _labelDikouPrice.frame.origin.y+16, _labelDikouPrice.frame.size.width, _labelDikouPrice.frame.size.height);
        _btnConfirm.frame = CGRectMake(15, _viewFooter.frame.size.height-10-40, SCREEN_WIDTH-30, 40);
    }
}

-(void)initOrderGoodsView
{
    _orderSaleView = [[OrderSaleView alloc]initWithFrame:CGRectMake(0, self._viewTop.frame.origin.y+self._viewTop.frame.size.height+42, SCREEN_WIDTH, SCREEN_HEIGHT-self._viewTop.frame.origin.y-self._viewTop.frame.size.height-42) arrSale:self._arrGoods price:self.totalPrice];
    _orderSaleView.backgroundColor = [UIColor clearColor];
    _orderSaleView.showDelegate = self;
    [self.view addSubview:_orderSaleView];
}

-(void)loadRedPacketInfo
{
    //获取红包列表
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    [ServicesRedPacket getRedPacketList:@0 cinemaId:[Config getCinemaId] cardItemId:[NSNumber numberWithInt:self.cardId] goodsIdAndCountList:self._arrayGoods ticketCount:@0 array:^(NSMutableArray *array) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        //遍历红包列表拆出红包model
        [weakSelf setRedPacketModelArray:array];
        _packetArr = [NSArray arrayWithArray:array];
        [weakSelf changeOrderPrice];
        [weakSelf refreshRealPayPrice];
        [weakSelf refreshLabelRealPrice];
        [weakSelf initDiscountTable];
        if (_packetArr.count == 0)
        {
            //无可用优惠
            [_orderSaleView refreshDiscount:typeNone];
        }
        [_myTable reloadData];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        //            [weakSelf backViewControllor:error index:3];
    }];
}

//遍历红包列表拆出红包model
-(void)setRedPacketModelArray:(NSMutableArray*)array
{
    isHaveNotCommonSale = NO;
    
    for (RedPacketListModel *redPacket in array)
    {
        RedPacketCellModel* cellModel = [[RedPacketCellModel alloc]init];
        cellModel.useState = NO;
        cellModel.currentCount = 0;
        cellModel.useMaxCount = [redPacket.useMaxCount integerValue];
        cellModel.isCanTouchPlus = YES;
        cellModel.isCanTouchMinus = NO;
        cellModel.redPacketType = [redPacket.redPacketType integerValue];
        cellModel.useLimit = [redPacket.useLimit integerValue];
        cellModel.isViewAlphaHidden = YES;
        cellModel.leftCount = [redPacket.totalCount integerValue];
        cellModel.common = [redPacket.common boolValue];
        cellModel.usedTicketCount = 0;
        cellModel.usedSaleCount = 0;
        [arrayRedPacketModel addObject:cellModel];
    }
}

-(void)changeOrderPrice
{
    _labelHejiPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_totalPrice]]];
}

#pragma mark - 算价
-(void)refreshDikouPrice
{
    if (_priceDikou == 0)
    {
        _labelDikouPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceDikou]]];
    }
    else
    {
        _labelDikouPrice.text = [NSString stringWithFormat:@"-¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceDikou]]];
    }
    float priceSum = _totalPrice-_priceDikou;
    if (_totalPrice == _priceDikou)
    {
        _labelTip.hidden = NO;
        priceSum = 1;
    }
    else
    {
        _labelTip.hidden = YES;
    }
    _priceRealPay = priceSum;
}

-(void)refreshRealPayPrice
{
    _priceRealPay = _totalPrice - _priceDikou;
    [_btnDiscount setTitle:[NSString stringWithFormat:@"实付金额：¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceRealPay]]] forState:UIControlStateNormal];
}

-(void)refreshLabelRealPrice
{
    /******************
     刷新价格UI
     ******************/
    [_labelRealPrice setText:[NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceRealPay]]]];
}

-(void)initDiscountTable
{
    CGFloat heightView = SCREEN_WIDTH > 320 ? 836/2 : 715/2;
    if (_packetArr.count<3)
    {
        heightView = _packetArr.count * 115 + 30 + 45 + 50;
    }
    
    //蒙层
    _viewAlpha = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _viewAlpha.backgroundColor = RGBA(0, 0, 0, 1);
    _viewAlpha.alpha = 0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDiscountTable)];
    [_viewAlpha addGestureRecognizer:tapGesture];
    [self.view addSubview:_viewAlpha];
    
    _viewDiscount = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, heightView)];
    _viewDiscount.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewDiscount];
    
    //权益优惠
    UILabel* labelDiscount = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 15)];
    labelDiscount.text = @"权益优惠";
    labelDiscount.font = MKFONT(15);
    labelDiscount.textColor = RGBA(51, 51, 51, 1);
    labelDiscount.textAlignment = NSTextAlignmentCenter;
    [_viewDiscount addSubview:labelDiscount];
    
    //line
    UIView* lineDiscount = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5)];
    lineDiscount.backgroundColor = RGBA(0, 0, 0, 0.05);
    [_viewDiscount addSubview:lineDiscount];
    
    //确认按钮
    _btnDiscount = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDiscount.frame = CGRectMake(15, heightView-10-40, SCREEN_WIDTH-30, 40);
    _btnDiscount.backgroundColor = [UIColor blackColor];
    [_btnDiscount setTitle:[NSString stringWithFormat:@"实付金额：¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceRealPay]]]  forState:UIControlStateNormal];
    _btnDiscount.titleLabel.font = MKFONT(15);
    _btnDiscount.layer.masksToBounds = YES;
    _btnDiscount.layer.cornerRadius = 20;
    [_btnDiscount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnDiscount addTarget:self action:@selector(hideDiscountView) forControlEvents:UIControlEventTouchUpInside];
    [_viewDiscount addSubview:_btnDiscount];
    
    _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, heightView -45 - 50)];
    _myTable.dataSource = self;
    _myTable.delegate = self;
    [_myTable setBackgroundColor:[UIColor clearColor]];
    _myTable.separatorColor = [UIColor clearColor];
    [_viewDiscount addSubview:_myTable];
    
    //蒙层
    UIImageView* imgShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, _myTable.frame.origin.y + _myTable.frame.size.height-6, SCREEN_WIDTH, 6)];
    imgShadow.image = [UIImage imageNamed:@"img_shadow.png"];
    imgShadow.backgroundColor = [UIColor clearColor];
    [_viewDiscount addSubview:imgShadow];
}

-(void)dismissDiscountTable
{
    //获取保存的红包model数组
    [arrayRedPacketModel removeAllObjects];
    for (RedPacketCellModel* cModel in _lastArrRedPacketModel)
    {
        RedPacketCellModel* model = [[RedPacketCellModel alloc]init];
        model.btnState = cModel.btnState;
        model.useState = cModel.useState;
        model.count = cModel.count;
        model.currentCount = cModel.currentCount;
        model.useMaxCount = cModel.useMaxCount;
        model.isCanTouchPlus = cModel.isCanTouchPlus;
        model.isCanTouchMinus = cModel.isCanTouchMinus;
        model.worth = cModel.worth;
        model.redPacketType = cModel.redPacketType;
        model.useLimit = cModel.useLimit;
        model.isViewAlphaHidden = cModel.isViewAlphaHidden;
        model.leftCount = cModel.leftCount;
        model.common = cModel.common;
        model.usedTicketCount = cModel.usedTicketCount;
        model.usedSaleCount = cModel.usedSaleCount;
        [arrayRedPacketModel addObject:model];
    }
    //获取保存的红包id数组
    [_arrRedPackIds removeAllObjects];
    for (NSNumber* num in _lastArrRedPackIds)
    {
        NSNumber* number = [NSNumber numberWithInt:[num intValue]];
        [_arrRedPackIds addObject:number];
    }
    
    //获取保存的使用不通用红包bool值
    isHaveNotCommonSale = lastIsHaveNotCommonSale;
    
    //获取保存的红包的各种抵扣金额
    _priceDikou= _lastPriceDikou;
    _priceRealDikou = _lastPriceRealDikou;
    _notAppointTotalPrice = _lastNotAppointTotalPrice;
    
    _viewAlpha.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _viewDiscount.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _viewDiscount.frame.size.height);
        if (_viewRule)
        {
            _viewRule.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _viewDiscount.frame.size.height);
        }
    } completion:^(BOOL finished) {
        [self.view sendSubviewToBack:_viewDiscount];
        //刷新优惠table
        [_myTable reloadData];
        //重算价格，刷新价格UI
        [self changeOrderPrice];
        [self refreshDikouPrice];
        [_btnDiscount setTitle:[NSString stringWithFormat:@"实付金额：¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceRealPay]]] forState:UIControlStateNormal];
        [self refreshLabelRealPrice];
    }];
}

-(void)showDiscountView
{
    //保存红包model数组
    [_lastArrRedPacketModel removeAllObjects];
    for (RedPacketCellModel* cModel in arrayRedPacketModel)
    {
        RedPacketCellModel* model = [[RedPacketCellModel alloc]init];
        model.btnState = cModel.btnState;
        model.useState = cModel.useState;
        model.count = cModel.count;
        model.currentCount = cModel.currentCount;
        model.useMaxCount = cModel.useMaxCount;
        model.isCanTouchPlus = cModel.isCanTouchPlus;
        model.isCanTouchMinus = cModel.isCanTouchMinus;
        model.worth = cModel.worth;
        model.redPacketType = cModel.redPacketType;
        model.useLimit = cModel.useLimit;
        model.isViewAlphaHidden = cModel.isViewAlphaHidden;
        model.leftCount = cModel.leftCount;
        model.common = cModel.common;
        model.usedTicketCount = cModel.usedTicketCount;
        model.usedSaleCount = cModel.usedSaleCount;
        [_lastArrRedPacketModel addObject:model];
    }
    //保存红包id数组
    [_lastArrRedPackIds removeAllObjects];
    for (NSNumber* num in _arrRedPackIds)
    {
        NSNumber* number = [NSNumber numberWithInt:[num intValue]];
        [_lastArrRedPackIds addObject:number];
    }
    //保存使用不通用红包bool值
    lastIsHaveNotCommonSale = isHaveNotCommonSale;
    //保存红包的各种抵扣金额
    _lastPriceDikou = _priceDikou;
    _lastPriceRealDikou = _priceRealDikou;
    _lastNotAppointTotalPrice = _notAppointTotalPrice;
    
    _viewAlpha.alpha = 0.5;
    [UIView animateWithDuration:0.3 animations:^{
        _viewDiscount.frame = CGRectMake(0, SCREEN_HEIGHT-_viewDiscount.frame.size.height, SCREEN_WIDTH, _viewDiscount.frame.size.height);
        [self.view bringSubviewToFront:_viewDiscount];
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)hideDiscountView
{
    [MobClick event:mainViewbtn99];
    [self refreshFooterFrame:_labelTip.hidden];
    
    [self refreshLabelRealPrice];
    if (_priceDikou>0)
    {
        //已使用优惠
        [_orderSaleView refreshDiscount:typeSelected];
    }
    if (_priceDikou == 0)
    {
        //有可用优惠
        [_orderSaleView refreshDiscount:typeHave];
    }
    _viewAlpha.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _viewDiscount.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _viewDiscount.frame.size.height);
        if (_viewRule)
        {
            _viewRule.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _viewDiscount.frame.size.height);
        }
    } completion:^(BOOL finished) {
        [self.view sendSubviewToBack:_viewDiscount];
    }];
}

#pragma mark - 使用红包
-(void)isUsePacket:(BOOL)isPlus packetModel:(RedPacketListModel*)model cellModel:(RedPacketCellModel*)cellModel
{
    //红包类型  0:票红包，4：小卖红包
    NSInteger curPacketType = [model.redPacketType integerValue];
    
    if (isPlus)
    {
        NSNumber *currPacketId = [model.combineRedPackIdList objectAtIndex:cellModel.currentCount];
        [_arrRedPackIds addObject:currPacketId];
        cellModel.useState = YES;
        cellModel.currentCount += 1;
        cellModel.leftCount = [model.totalCount integerValue] - cellModel.currentCount;
        
        //增加红包
        if (curPacketType == 4)
        {
            if (!cellModel.common)
            {
                //有不通用红包
                isHaveNotCommonSale = YES;
            }
            [self plusSalePacket:cellModel packetModel:model];
        }
    }
    else
    {
        NSNumber *currPacketId = [model.combineRedPackIdList objectAtIndex:(cellModel.currentCount-1)];
        for (int i=0; i<_arrRedPackIds.count; i++)
        {
            if ([_arrRedPackIds[i] isEqual:currPacketId])
            {
                [_arrRedPackIds removeObjectAtIndex:i];
            }
        }
        cellModel.currentCount -= 1;
        cellModel.leftCount += 1;
        if (cellModel.currentCount == 0)
        {
            cellModel.useState = NO;
        }
        
        //减红包
        if (curPacketType == 4)
        {
            if (!cellModel.common && cellModel.currentCount == 0)
            {
                //没有不通用红包
                isHaveNotCommonSale = NO;
            }
            //小卖红包
            [self minusSalePacket:cellModel packetModel:model];
        }
    }
    [self refreshDikouPrice];
    [_btnDiscount setTitle:[NSString stringWithFormat:@"实付金额：¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceRealPay]]] forState:UIControlStateNormal];
    [_myTable reloadData];
}

-(void)plusSalePacket:(RedPacketCellModel*)cellModel packetModel:(RedPacketListModel *)model
{
    //使用限制  0:不限制，1:票/小卖数，2:主订单
    NSInteger useLimit = [model.useLimit integerValue];
    
    //小卖红包
    if (useLimit == 1)
    {
        //小卖数量红包
        //小卖使用个数＋1
        cellModel.usedSaleCount += 1;
        _notAppointTotalPrice = 0;
    }
    else
    {
        //小卖订单红包
        //算出非指定小卖总价
        [self calNotAppointPrice:model];
    }
    cellModel.isViewAlphaHidden = YES;
    _priceDikou += [model.worth floatValue];
    _priceRealDikou = _priceDikou;
    if (_priceDikou >= _totalPrice-_notAppointTotalPrice)
    {
        //当小卖红包抵扣金额 >= 小卖总价-非指定小卖总价，抵扣金额 ＝ 小卖总价-非指定小卖总价
        _priceDikou = _totalPrice-_notAppointTotalPrice;
        for (RedPacketCellModel* cModel in arrayRedPacketModel)
        {
            if (cModel.redPacketType == 4)
            {
                if (!cModel.useState)
                {
                    //未勾选的所有小卖红包置灰
                    cModel.isViewAlphaHidden = NO;
                }
                else
                {
                    //已勾选的所有小卖红包＋置灰，－亮
                    cModel.isCanTouchMinus = YES;
                    cModel.isCanTouchPlus = NO;
                }
            }
        }
    }
    else
    {
        //当小卖红包抵扣金额 < 小卖价格-非指定小卖总价
        if (useLimit == 2)
        {
            //小卖订单红包
            //该订单红包－亮，＋置灰
            cellModel.isCanTouchPlus = NO;
            cellModel.isCanTouchMinus = YES;
        }
        else if (useLimit == 1)
        {
            //小卖数量红包
            //当已用小卖红包个数 = 小卖总个数，该票红包＋置灰，－亮
            if (cellModel.usedSaleCount == self.smallSaleCount)
            {
                cellModel.isCanTouchPlus = NO;
                cellModel.isCanTouchMinus = YES;
            }
            else
            {
                cellModel.isCanTouchMinus = YES;
                cellModel.isCanTouchPlus = YES;
            }
            if (cellModel.currentCount == cellModel.useMaxCount)
            {
                cellModel.isCanTouchMinus = YES;
                cellModel.isCanTouchPlus = NO;
            }
        }
        //如果该小卖红包是不通用的，则其他所有未勾选的不通用小卖红包置灰
        if (!cellModel.common)
        {
            for (RedPacketCellModel* cModel in arrayRedPacketModel)
            {
                if (!cModel.common && !cModel.useState && cModel.redPacketType == 4)
                {
                    cModel.isViewAlphaHidden = NO;
                }
            }
        }
    }
}

-(void)minusSalePacket:(RedPacketCellModel*)cellModel packetModel:(RedPacketListModel *)model
{
    //使用限制  0:不限制，1:票/小卖数，2:主订单
    NSInteger useLimit = [model.useLimit integerValue];
    
    if (useLimit == 1)
    {
        //小卖数量红包
        //小卖使用个数－1
        cellModel.usedSaleCount -= 1;
    }
    _priceRealDikou -= [model.worth floatValue];
    if (_priceRealDikou >= _totalPrice-_notAppointTotalPrice)
    {
        //小卖实际抵扣价>=小卖总价-非指定小卖总价
        _priceDikou = _totalPrice-_notAppointTotalPrice;
        //所有已勾选的小卖红包＋置灰
        for (RedPacketCellModel* cModel in arrayRedPacketModel)
        {
            if (cModel.redPacketType == 4 && cModel.useState)
            {
                cModel.isCanTouchPlus = NO;
            }
        }
        if (cellModel.currentCount == 0)
        {
            //当前使用个数＝0，则该红包置灰
            cellModel.isViewAlphaHidden = NO;
            cellModel.isCanTouchMinus = NO;
            cellModel.isCanTouchPlus = YES;
        }
    }
    else
    {
        _priceDikou = _priceRealDikou;
        if (useLimit == 2)
        {
            //小卖订单红包
            //该红包－置灰，＋亮
            cellModel.isCanTouchPlus = YES;
            cellModel.isCanTouchMinus = NO;
            
            if (!cellModel.common)
            {
                //该红包是不通用订单票红包，则所有不通用小卖红包亮
                for (RedPacketCellModel* cModel in arrayRedPacketModel)
                {
                    if (!cModel.common && cModel.redPacketType == 4)
                    {
                        cModel.isViewAlphaHidden = YES;
                    }
                }
            }
        }
        else if (useLimit == 1)
        {
            //小卖数量红包
            if (cellModel.currentCount == 0)
            {
                //当前使用数量＝0，－置灰，＋亮
                cellModel.isCanTouchPlus = YES;
                cellModel.isCanTouchMinus = NO;
                
                if (!cellModel.common)
                {
                    //该红包是不通用订单票红包，则所有不通用票红包亮
                    for (RedPacketCellModel* cModel in arrayRedPacketModel)
                    {
                        if (!cModel.common && cModel.redPacketType == 4)
                        {
                            cModel.isViewAlphaHidden = YES;
                        }
                    }
                }
            }
            else
            {
                //－亮，＋亮
                cellModel.isCanTouchPlus = YES;
                cellModel.isCanTouchMinus = YES;
            }
        }
        
        for (RedPacketCellModel* cModel in arrayRedPacketModel)
        {
            if (cellModel.common)
            {
                //是通用小卖红包，所有小卖红包亮
                if (cModel.redPacketType == 4)
                {
                    cModel.isViewAlphaHidden = YES;
                }
                if (cModel.currentCount == 0)
                {
                    cModel.isCanTouchMinus = NO;
                    cModel.isCanTouchPlus = YES;
                }
                else if (cModel.currentCount == cModel.useMaxCount)
                {
                    cModel.isCanTouchMinus = YES;
                    cModel.isCanTouchPlus = NO;
                }
                else
                {
                    cModel.isCanTouchPlus = YES;
                    cModel.isCanTouchMinus = YES;
                }
            }
            else
            {
                //是不通用小卖红包，所有通用小卖红包亮
                if (cModel.redPacketType == 4 && cModel.common)
                {
                    cModel.isViewAlphaHidden = YES;
                }
            }
        }
        if (isHaveNotCommonSale)
        {
            //如果有不通用红包，所有通用的小卖红包亮
            for (RedPacketCellModel* cModel in arrayRedPacketModel)
            {
                if (cModel.redPacketType == 4 && cModel.common)
                {
                    cModel.isViewAlphaHidden = YES;
                }
                if (cModel.redPacketType == 4 && !cModel.common && !cModel.useState)
                {
                    cModel.isViewAlphaHidden = NO;
                }
            }
        }
    }
}

#pragma mark - 计算非指定小卖总价
-(float)calNotAppointPrice:(RedPacketListModel *)model
{
    _notAppointTotalPrice = 0;
    NSArray* limitIdArray = model.goodsIds;
    if (limitIdArray.count>0)
    {
        //指定小卖红包，把非指定的小卖排除掉
        for (SnackListModel* snackModel in self._arrGoods)
        {
            if (![self selectNotAppointId:snackModel.goodsId array:limitIdArray])
            {
                //算出非指定小卖的价格
                float notAppointPrice = ([snackModel.priceData.priceBasic floatValue] + [snackModel.priceData.priceService floatValue]) * [snackModel.count intValue];
                _notAppointTotalPrice += notAppointPrice;
            }
        }
    }
    else
    {
        _notAppointTotalPrice = 0;
    }
    return _notAppointTotalPrice;
}

-(BOOL)selectNotAppointId:(NSNumber*)goodsId array:(NSArray*)limitArray
{
    for (NSNumber* saleId in limitArray)
    {
        if ([saleId intValue] == [goodsId intValue])
        {
            return YES;
        }
    }
    return NO;
}

-(void)closeDetail
{
    UIButton* btn = (UIButton*)[self.view viewWithTag:301];
    [self onButtonLookDetail:btn];
}

#pragma mark - 查看明细
-(void)onButtonLookDetail:(UIButton*)btn
{
    [MobClick event:mainViewbtn101];
    if (btn.tag == 300)
    {
        //展开footer
        btn.tag = 301;
        [_imageArrowUp setImage:[UIImage imageNamed:@"btn_downArrow.png"]];
        _footerAlpha.alpha = 0.5;
        [self.view bringSubviewToFront:_footerAlpha];
        [UIView animateWithDuration:0.3 animations:^{
            _viewline.hidden = NO;
            _viewFooter.frame = CGRectMake(0, SCREEN_HEIGHT-(_viewFooter.frame.size.height+99), SCREEN_WIDTH, _viewFooter.frame.size.height+99);
            _imgShadow.frame = CGRectMake(0, SCREEN_HEIGHT - _viewFooter.frame.size.height-6, SCREEN_WIDTH, 6);
            _btnConfirm.frame = CGRectMake(15, _viewFooter.frame.size.height-10-40, SCREEN_WIDTH-30, 40);
            [self.view bringSubviewToFront:_viewFooter];
        } completion:^(BOOL finished) {
            _labelHejiPrice.hidden = NO;
            _labelHeji.hidden = NO;
            _labelDikouPrice.hidden = NO;
            _labelDikou.hidden = NO;
        }];
    }
    else
    {
        //缩起footer
        btn.tag = 300;
        [_imageArrowUp setImage:[UIImage imageNamed:@"btn_upArrow.png"]];
        _footerAlpha.alpha = 0;
        _viewline.hidden = YES;
        _labelHejiPrice.hidden = YES;
        _labelHeji.hidden = YES;
        _labelDikouPrice.hidden = YES;
        _labelDikou.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            _viewFooter.frame = CGRectMake(0, SCREEN_HEIGHT-_viewFooter.frame.size.height+99, SCREEN_WIDTH, _viewFooter.frame.size.height-99);
            _imgShadow.frame = CGRectMake(0, SCREEN_HEIGHT - _viewFooter.frame.size.height-6, SCREEN_WIDTH, 6);
            _btnConfirm.frame = CGRectMake(15, _viewFooter.frame.size.height-10-40, SCREEN_WIDTH-30, 40);
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)addDikouView
{
    if (!_viewline)
    {
        _viewline = [[UIView alloc]initWithFrame:CGRectMake(0, 41.5, SCREEN_WIDTH, 0.5)];
        _viewline.backgroundColor = RGBA(0, 0, 0, 0.05);
        [_viewFooter addSubview:_viewline];
    }
    if (!_labelHeji)
    {
        _labelHeji = [[UILabel alloc]initWithFrame:CGRectMake(15, 42+30, 100, 12)];
        _labelHeji.text = @"合计金额：";
        _labelHeji.textColor = RGBA(133, 133, 160, 1);
        _labelHeji.font = MKFONT(12);
        [_viewFooter addSubview:_labelHeji];
    }
    if (!_labelDikou)
    {
        _labelDikou = [[UILabel alloc]initWithFrame:CGRectMake(15, _labelHeji.frame.origin.y+_labelHeji.frame.size.height+15, 100, 12)];
        _labelDikou.text = @"抵扣金额：";
        _labelDikou.textColor = RGBA(133, 133, 160, 1);
        _labelDikou.font = MKFONT(12);
        [_viewFooter addSubview:_labelDikou];
    }
    if (!_labelHejiPrice)
    {
        _labelHejiPrice = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-150, _labelHeji.frame.origin.y-3, 150, 15)];
//        _labelHejiPrice.text = [NSString stringWithFormat:@"¥ %@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:self.totalPrice]]];
        _labelHejiPrice.textColor = RGBA(51, 51, 51, 1);
        _labelHejiPrice.textAlignment = NSTextAlignmentRight;
        _labelHejiPrice.font = MKFONT(12);
        [_viewFooter addSubview:_labelHejiPrice];
    }
    if (!_labelDikouPrice)
    {
        _labelDikouPrice = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-150, _labelDikou.frame.origin.y-3, 150, 15)];
        _labelDikouPrice.text = @"¥ 0";
        _labelDikouPrice.textColor = RGBA(51, 51, 51, 1);
        _labelDikouPrice.font = MKFONT(12);
        _labelDikouPrice.textAlignment = NSTextAlignmentRight;
        [_viewFooter addSubview:_labelDikouPrice];
    }
}

#pragma mark - tableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //红包个数
    return _packetArr.count;
}

//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_packetArr.count == 1)
    {
        //唯一一个红包cell
        return 115+30;
    }
    else
    {
        if (indexPath.row == 0 || indexPath.row == _packetArr.count-1)
        {
            //第一个红包cell
            return 115+15;
        }
        else
        {
            //最后一个红包cell
            return 115;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier= [NSString stringWithFormat:@"SaleDiscountTableViewCell%ld",(long)indexPath.row];
    SaleDiscountTableViewCell *cell = (SaleDiscountTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[SaleDiscountTableViewCell alloc] initWithReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellDelegate = self;
        cell.backgroundColor = [UIColor clearColor];
    }
    SaleCellIndex index = 1;
    if (_packetArr.count == 1)
    {
        //唯一一个红包cell
        index = 3;
    }
    else
    {
        if (indexPath.row == 0)
        {
            //第一个红包cell
            index = 0;
        }
        else if (indexPath.row == _packetArr.count-1)
        {
            //最后一个红包cell
            index = 2;
        }
    }
    //红包cell
    [cell setPacketData:_packetArr[indexPath.row] cellModel:arrayRedPacketModel[indexPath.row] cellIndex:index];
    [cell layoutPacket:index];
    
    return cell;
}

#pragma mark 创建订单成功后去轮询订单 GetOrderStatus 接口
-(void)onButtonCreateOrder:(UIButton*)sender
{
    [MobClick event:mainViewbtn102];
    [self createOrder];
}

-(void)createOrder
{
    //校验手机号
    if (_orderSaleView.strTel.length != 11 || ![Tool validateTel:_orderSaleView.strTel])
    {
        [Tool showWarningTip:@"您输入的手机号不对哦~"  time:1];
        [_orderSaleView showKeyBoard];
        return;
    }
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    
    [ServicesGoods createSnack:[Config getCinemaId] cinemaCardId:[NSNumber numberWithInt:self.cardId] goodsIdAndCountList:self._arrayGoods mobileNo:[NSNumber numberWithLongLong:[_orderSaleView.strTel longLongValue]] redPacketIds:_arrRedPackIds model:^(CreateSnackModel *model)
     {
         _orderId =model.orderId;
         [weakSelf createOrderIsSuccess];
     } failure:^(NSError *error) {
         [Tool showWarningTip:error.domain time:2.0];
         if (!(error.code == -1001 || error.code == 20000))
         {
             [weakSelf performSelector:@selector(refreshSaleList) withObject:nil afterDelay:2.0];
         }
     }];
}

-(void)refreshSaleList
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHGOODS object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createOrderIsSuccess
{
    _orderTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(runOrderStatus:)
                                                      userInfo:nil
                                                       repeats:YES];
    [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes
                             beforeDate:[NSDate dateWithTimeIntervalSinceNow:ORDERRUNMAXTIME]];
}

#pragma mark 轮询订单状态
-(void)runOrderStatus:(NSTimer*) timer
{
    _lockSeatTimeCount++;
    __weak typeof(self) WeakSelf = self;
    if ([_orderId length] > 0)
    {
        [ServicesPay orderCycle:_orderId model:^(OrderWhileModel *model)
         {
             //锁小卖成功跳转到支付页
             if ([model.orderStatus intValue] == 10 )
             {
//                 NSLog(@"--@@@@#####-%@",NSStringFromClass([self.navigationController.topViewController class]));
                 [WeakSelf stopTimer];
                 if(![NSStringFromClass([self.navigationController.topViewController class] ) isEqualToString:@"PayViewController"])
                 {
                     [WeakSelf jumpPayWaySelectView:model];
                 }
             }
             //如果一直锁坐失败
             if(_lockSeatTimeCount>= ORDERRUNMAXTIME)
             {
                 //轮询超时60秒还没有成功，弹框提醒
                 [FVCustomAlertView hideAlertFromView:WeakSelf.view fading:YES];
                 [WeakSelf stopTimer];
                 UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"提示" message:@"当前网络环境不佳，您可稍后在卡包中查看购票结果。如有疑问，请致电\n4000-681-681" delegate:self cancelButtonTitle:@"返回影院首页" otherButtonTitles:nil, nil];
                 alertView.tag =  3;
                 alertView.delegate = WeakSelf;
                 [alertView show];
             }
             if ([model.orderStatus intValue] == 20)
             {
                 [FVCustomAlertView hideAlertFromView:WeakSelf.view fading:YES];
                 _lockSeatTimeCount = 0;
                 [WeakSelf stopTimer];
             }
             if ([model.orderStatus intValue] == 40 )//失败
             {
                 [WeakSelf stopTimer];
                 [FVCustomAlertView hideAlertFromView:WeakSelf.view fading:YES];
             }
             
         } failure:^(NSError *error) {
             [WeakSelf stopTimer];
             [Tool showWarningTip:@"网络中断！"  time:1];
         }];
    }
}

#pragma mark alertviewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 1)
//    {
//        NSLog(@"支付影票");
//        if (alertView.tag == 10)
//        {
//            //实付0元
//            [self createOrder];
//        }
//        else
//        {
//            __weak typeof(self) weakSelf = self;
//            [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"正在锁座，请稍候" withBlur:NO allowTap:NO];
//            [ServicesOrder createOrder:self._orderModel.showtimeId seatIds:self._orderModel.arrSeatIds cinemaCardId:memberCardItemId cinemaCardItemId:@0 goodsArr:nil redPacketArr:_arrRedPackIds taopiaoItemId:_taopiaoId useTaopiaoTicketCount:[NSNumber numberWithInt:curCardNum] cikaOrCardItemId:_cikaId clientCalculationTotalPrice:[NSNumber numberWithFloat:_priceRealPay] model:^(CreateOrderModel *model)
//             {
//                 saleTotalPrice = 0;
//                 _orderId =model.orderId;
//                 [weakSelf CreateOrderIsSuccess];
//             } failure:^(NSError *error) {
//                 [self backViewControllor:error  index:3];
//             }];
//        }
//    }
//    else
    if (buttonIndex == 0)
    {
//        if (alertView.tag == 0)
//        {
//            NSLog(@"重选卖品");
//            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHSMALLSALE object:nil];
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -2)] animated:YES];
//        }
//        else if (alertView.tag == 3)
//        {
            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//        else if (alertView.tag == 10)
//        {
//            _btnConfirm.enabled = YES;
//        }
//        else
//        {
//            NSLog(@"取消订单");
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
//        }
    }
}

-(void) stopTimer
{
    if(_orderTimer)
    {
        [_orderTimer invalidate];
        _orderTimer = nil;
    }
}

#pragma mark 跳转到支付方式选择页
-(void)jumpPayWaySelectView:(OrderWhileModel *)model
{
    [Config saveUserOrderPhone:[Config getUserId] phoneText:_orderSaleView.strTel];
    
    PayViewController *payView = [[PayViewController alloc ] init];
    payView._orderId = model.orderId;
    payView._priceSale = _priceRealPay;
    payView._viewName = @"SaleOrderView";
    [self.navigationController pushViewController:payView animated:YES];
}

-(void)onButtonBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
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
