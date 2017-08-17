//
//  BuildOrderViewController.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/10.
//
//

#import "BuildOrderViewController.h"

@interface BuildOrderViewController ()

@end

@implementation BuildOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(248, 248, 252, 1);
    self._labelTitle.text = self._orderModel.strCinema;
    
    //初始化一些全局数据
    arrayRedPacketModel = [[NSMutableArray alloc]init];
    _arrUsedCardState = [[NSMutableArray alloc]init];
    _arrUsedCardName = [[NSMutableArray alloc]init];
    _arrUsedCardTicketName = [[NSMutableArray alloc]init];
    _arrUsedCardSaleName = [[NSMutableArray alloc]init];
    _lastArrUsedCardState = [[NSMutableArray alloc]init];
    _lastArrRedPacketModel = [[NSMutableArray alloc]init];
    lastCurrentPriceModel = [[MemberPriceModel alloc]init];
    _lastArrRedPackIds = [[NSMutableArray alloc]init];
    
    memberCardItemId = self._orderModel.strCardId;
    _cikaId = memberCardItemId;
    _taopiaoId = [NSNumber numberWithInteger:0];
    ticketNum = self._orderModel.arrSeats.count;
    
    //红包使用限制数组，0使用过不限制红包  1使用过票/小卖数限制红包  2使用过订单红包  4没有使用过
    _arrayPacketLimit = [[NSMutableArray alloc]initWithObjects:@4,@4,@4, nil];
    _arrayUsedCardIndex = [[NSMutableArray alloc]init];
    _arrRedPackIds = [[NSMutableArray alloc]init];
    isCanUseTicketPack = YES;
    isCanUseSalePack = YES;
    isHaveUseOrderPack = NO;
    isHaveUseCountPack = NO;
    isHaveUseNotLimitPack = NO;
    curCardNum = 0;
    
    _lockSeatTimeCount = 0;
    
    [self initControl];
    [self initOrderGoodsView];
    [self initFooter];
    [self loadMemberInfo];
}

-(void)popToSeat:(NSError *)error
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHSEATS object:nil];
    if (self.isFromSale)
    {
        [self backViewControllor:error index:3];
    }
    else
    {
        [self backViewControllor:error index:2];
    }
    if(error.code == -101)
    {
        LoginViewController *loginControlller = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginControlller animated:YES];
    }
}

#pragma mark - 加载可用卡列表和红包列表
-(void)loadMemberInfo
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    //获取可用的卡列表:次卡、套票、任看卡
    [ServicesRedPacket getOrderCanUseCinemaCardList:[NSNumber numberWithInteger:self._orderModel.showtimeId] ticketCount:[NSNumber numberWithInteger:self._orderModel.arrSeats.count] cardId:_cikaId array:^(NSMutableArray *array) {
        arrCanUseCard = array;
        
        [weakSelf setOrderCardList];
        
        if ([currentPriceModel.cardType integerValue] == 1)
        {
            //次卡
            for (CardStateModel* cModel in _arrUsedCardState)
            {
                if (cModel.cardId == [currentPriceModel.cinemaCardId integerValue])
                {
                    [_arrUsedCardName addObject:cModel];
                    break;
                }
            }
            //            [weakSelf refreshCardName];
        }
        [weakSelf loadRedPData];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        [weakSelf popToSeat:error];
    }];
}

-(void)loadRedPData
{
    __weak typeof(self) weakSelf = self;
    //获取红包列表
    [ServicesRedPacket getRedPacketList:[NSNumber numberWithInteger:weakSelf._orderModel.showtimeId] cinemaId:[weakSelf._orderModel.strCinemaId stringValue] cardItemId:[NSNumber numberWithInt:0] goodsIdAndCountList:weakSelf._arrayGoods ticketCount:[NSNumber numberWithInteger:self._orderModel.arrSeats.count] array:^(NSMutableArray *array) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        //遍历红包列表拆出红包model
        [weakSelf setRedPacketModelArray:array];
        _packetArr = [NSArray arrayWithArray:array];
        [weakSelf changeOrderPrice];
        [weakSelf refreshRealPayPrice];
        [weakSelf refreshLabelRealPrice];
        [weakSelf initDiscountTable];
        if (arrCanUseCard.count == 0 && _packetArr.count == 0)
        {
            //无可用优惠
            [_orderGoodsView refreshData:discountNone];
        }
        [_myTable reloadData];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        [weakSelf popToSeat:error];
    }];
    
}

//遍历红包列表拆出红包model
-(void)setRedPacketModelArray:(NSMutableArray*)array
{
    isHaveNotCommonTicket = NO;
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

//过滤出可用卡列表
-(void)setOrderCardList
{
    //遍历可用卡列表，将所有可用卡状态、价格model化
    for (cinemaCardItemListModel* cinemaItemModel in arrCanUseCard)
    {
        CardStateModel* stateModel = [[CardStateModel alloc]init];
        stateModel.cardType = [cinemaItemModel.cardType integerValue];
        stateModel.cardItemName = cinemaItemModel.cardItemName;
        stateModel.cardId = [cinemaItemModel.cardId integerValue];
        stateModel.id = [cinemaItemModel.id integerValue];
        if ([cinemaItemModel.cardType integerValue] == 1)
        {
            stateModel.canUseCount = 1;
        }
        stateModel.isShowViewAlpha = NO;
        
        if ([cinemaItemModel.cardType integerValue] == 1)
        {
            //次卡的消耗次数为1
            stateModel.canUseCount = 1;
            stateModel.usedLeftCount = [cinemaItemModel.leftUseCount intValue] - stateModel.canUseCount;
        }
        else if ([cinemaItemModel.cardType integerValue] == 4)
        {
            //通票的消耗次数=消耗张数/部长
            stateModel.canUseCount = [cinemaItemModel.canUseMaxCount intValue] / [cinemaItemModel.cardExchangeStep intValue];
            stateModel.cardExchangeStep = cinemaItemModel.cardExchangeStep;
            stateModel.usedLeftCount = [cinemaItemModel.leftUseCount intValue] - [cinemaItemModel.canUseMaxCount intValue];
        }
        else
        {
            //套票、任看卡的消耗次数
            stateModel.canUseCount = [cinemaItemModel.canUseMaxCount intValue];
            stateModel.usedLeftCount = [cinemaItemModel.leftUseCount intValue] - stateModel.canUseCount;
        }
        //遍历出该卡的票价model
        for (MemberPriceModel* m_Model in self.priceListModel.memberPriceList)
        {
            if (stateModel.cardId == [m_Model.cinemaCardId integerValue])
            {
                stateModel.ticketPriceModel = m_Model;
                
                if (memberCardItemId == cinemaItemModel.cardId)
                {
                    //如果排期页推荐卡在可用卡列表里(即推荐卡是次卡)，该次卡默认勾选
                    stateModel.chooseState = YES;
                    //当前价格model为该次卡model
                    currentPriceModel = m_Model;
                }
                else
                {
                    stateModel.chooseState = NO;
                }
            }
            
        }
        [_arrUsedCardState addObject:stateModel];
    }
    
    for (CardStateModel* cModel in _arrUsedCardState)
    {
        if ([memberCardItemId integerValue] == cModel.cardId)
        {
            [self refreshAlphaState:YES cardModel:cModel];
            break;
        }
    }
    
    //选出次卡之外最优惠价格集合
    if ([memberCardItemId integerValue] == 0)
    {
        //基础会员价model
        MemberPriceModel* basic_M_Model = [[MemberPriceModel alloc]init];
        basic_M_Model.servicePrice = self.priceListModel.priceService;
        basic_M_Model.cinemaCardId = @0;
        basic_M_Model.id = @0;
        basic_M_Model.memberPrice = self.priceListModel.priceBasic;
        exceptModel = basic_M_Model;
        //当前价格model为基础会员价model
        currentPriceModel = exceptModel;
    }
    else
    {
        for (MemberPriceModel* m_Model in self.priceListModel.memberPriceList)
        {
            if ([m_Model.cinemaCardId intValue] == [memberCardItemId intValue])
            {
                if ([m_Model.cardType integerValue] != 1)
                {
                    //如果排期页推荐卡不是次卡
                    exceptModel = m_Model;
                    //当前价格model为该会员价model
                    currentPriceModel = exceptModel;
                }
                else
                {
                    //如果排期页推荐卡是次卡
                    [self getExceptPrice];
                }
            }
        }
    }
}

//获取次卡之外最优惠价格集合
-(void)getExceptPrice
{
    //基础会员价model
    MemberPriceModel* basic_M_Model = [[MemberPriceModel alloc]init];
    basic_M_Model.servicePrice = self.priceListModel.priceService;
    basic_M_Model.cinemaCardId = @0;
    basic_M_Model.id = @0;
    basic_M_Model.memberPrice = self.priceListModel.priceBasic;
    
    MemberPriceModel* origin_M_Model ;
    for (MemberPriceModel* m_Model in self.priceListModel.memberPriceList)
    {
        if ([m_Model.cardType integerValue] != 1)
        {
            //不是次卡
            if (origin_M_Model)
            {
                NSInteger oldSalePrice = [origin_M_Model.memberPrice integerValue] + [origin_M_Model.servicePrice integerValue];
                NSInteger newSalePrice = [m_Model.memberPrice integerValue] + [m_Model.servicePrice integerValue];
                if(newSalePrice<oldSalePrice)
                {
                    origin_M_Model=m_Model;
                }
            }
            else
            {
                origin_M_Model = m_Model;
            }
        }
    }
    if (origin_M_Model)
    {
        //选出了次卡外的最优会员卡
        NSInteger originSalePrice = [origin_M_Model.memberPrice integerValue] + [origin_M_Model.servicePrice integerValue];
        NSInteger basicSalePrice = [basic_M_Model.memberPrice integerValue] + [basic_M_Model.servicePrice integerValue];
        if (originSalePrice <= basicSalePrice)
        {
            //最优会员价 <= 基础会员价
            exceptModel = origin_M_Model;
        }
        else
        {
            //最优会员价 > 基础会员价
            exceptModel = basic_M_Model;
        }
    }
    else
    {
        exceptModel = basic_M_Model;
    }
}

//刷新卡cell蒙层显示的状态
-(void)refreshAlphaState:(BOOL)isUse cardModel:(CardStateModel *)cardModel
{
    if (isUse)
    {
        if (cardModel.cardType == 2 || cardModel.cardType == 3)
        {
            //任看卡、套票
            for (CardStateModel* model in _arrUsedCardState)
            {
                if (model.id != cardModel.id && model.cardType != 1)
                {
                    //勾选了一个任看卡或套票，则其余的任看卡和套票全置灰
                    model.isShowViewAlpha = YES;
                }
            }
        }
        else if (cardModel.cardType == 1)
        {
            //次卡
            for (CardStateModel* model in _arrUsedCardState)
            {
                if ((model.id != cardModel.id && model.cardType == 1) || model.cardType == 4)
                {
                    //勾选了一个次卡，则其余的次卡全置灰，通票也置灰
                    model.isShowViewAlpha = YES;
                }
            }
        }
        else if (cardModel.cardType == 4)
        {
            //通票
            for (CardStateModel* model in _arrUsedCardState)
            {
                if (model.id != cardModel.id)
                {
                    //勾选了一个通票，则其他所有卡置灰，包括次卡
                    model.isShowViewAlpha = YES;
                }
            }
        }
    }
    else
    {
        if (cardModel.cardType == 2 || cardModel.cardType == 3)
        {
            //任看卡、套票
            for (CardStateModel* model in _arrUsedCardState)
            {
                if (model.cardType != 1)
                {
                    //取消勾选一个任看卡或套票，所有的任看卡或套票都不置灰
                    model.isShowViewAlpha = NO;
                }
            }
            BOOL isHaveCikaSelect = NO;
            for (CardStateModel* model in _arrUsedCardState)
            {
                if (model.cardType == 1)
                {
                    if (model.chooseState)
                    {
                        //该次卡是勾选状态
                        isHaveCikaSelect = YES;
                        break;
                    }
                }
            }
            for (CardStateModel* model in _arrUsedCardState)
            {
                if (model.cardType == 4)
                {
                    //取消勾选一个任看卡或套票，如果有次卡是勾选状态，所有的通票置灰
                    if (isHaveCikaSelect)
                    {
                        //有次卡勾选
                        model.isShowViewAlpha = YES;
                    }
                    else
                    {
                        model.isShowViewAlpha = NO;
                    }
                }
            }
        }
        else if (cardModel.cardType == 1)
        {
            BOOL isHaveTaopiaoSelect = NO;
            for (CardStateModel* model in _arrUsedCardState)
            {
                if (model.cardType == 2 || model.cardType == 3)
                {
                    if (model.chooseState)
                    {
                        //该次卡是勾选状态
                        isHaveTaopiaoSelect = YES;
                        break;
                    }
                }
            }
            
            //次卡
            for (CardStateModel* model in _arrUsedCardState)
            {
                if (model.cardType == 1)
                {
                    //取消勾选一个次卡，所有的次卡都不置灰
                    model.isShowViewAlpha = NO;
                }
                if (model.cardType == 4)
                {
                    //取消勾选一个次卡
                    if (isHaveTaopiaoSelect)
                    {
                        //如果有任看或套票是勾选状态，则所有通票置灰
                        model.isShowViewAlpha = YES;
                    }
                    else
                    {
                        model.isShowViewAlpha = NO;
                    }
                }
            }
        }
        else if (cardModel.cardType == 4)
        {
            //通票
            for (CardStateModel* model in _arrUsedCardState)
            {
                //取消勾选一个通票，所有的卡都不置灰
                model.isShowViewAlpha = NO;
            }
        }
    }
}

-(void)initDiscountTable
{
    CGFloat heightView = SCREEN_WIDTH > 320 ? 836/2 : 715/2;
    if ((arrCanUseCard.count+_packetArr.count)<3)
    {
        heightView = (arrCanUseCard.count+_packetArr.count) * 110 + 45 + 65;
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
    [_btnDiscount setTitle:[NSString stringWithFormat:@"实付金额：¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceZongji]]]  forState:UIControlStateNormal];
    _btnDiscount.titleLabel.font = MKFONT(15);
    _btnDiscount.layer.masksToBounds = YES;
    _btnDiscount.layer.cornerRadius = 20;
    [_btnDiscount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnDiscount addTarget:self action:@selector(hideDiscountView) forControlEvents:UIControlEventTouchUpInside];
    [_viewDiscount addSubview:_btnDiscount];
    
    _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 45+15, SCREEN_WIDTH, heightView -45-15 - _btnDiscount.frame.size.height - 25)];
    _myTable.dataSource = self;
    _myTable.delegate = self;
    [_myTable setBackgroundColor:[UIColor clearColor]];
    _myTable.separatorColor = [UIColor clearColor];
    [_viewDiscount addSubview:_myTable];
}

-(void)showDiscountView
{
    //保存可用卡列表状态数组
    [_lastArrUsedCardState removeAllObjects];
    for (CardStateModel* cModel in _arrUsedCardState)
    {
        CardStateModel* model = [[CardStateModel alloc]init];
        model.cardType = cModel.cardType;
        model.cardItemName = cModel.cardItemName;
        model.cardId = cModel.cardId;
        model.id = cModel.id;
        model.chooseState = cModel.chooseState;
        model.isShowViewAlpha = cModel.isShowViewAlpha;
        model.ticketPriceModel = cModel.ticketPriceModel;
        model.usedLeftCount = cModel.usedLeftCount;
        model.cardExchangeStep = cModel.cardExchangeStep;
        model.canUseCount = cModel.canUseCount;
        [_lastArrUsedCardState addObject:model];
    }
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
    //保存当前卡model
    lastCurrentPriceModel.cinemaCardName = currentPriceModel.cinemaCardName;
    lastCurrentPriceModel.memberPrice = currentPriceModel.memberPrice;
    lastCurrentPriceModel.cinemaCardId = currentPriceModel.cinemaCardId;
    lastCurrentPriceModel.cardType = currentPriceModel.cardType;
    lastCurrentPriceModel.id = currentPriceModel.id;
    lastCurrentPriceModel.servicePrice = currentPriceModel.servicePrice;
    //保存taopiaoid
    _lastTaopiaoId = [NSNumber numberWithInteger:[_taopiaoId integerValue]];
    //保存当前使用套票个数
    lastCurrentUseCardNum = currentUseCardNum;
    lastCurCardNum = curCardNum;
    //保存红包id数组
    [_lastArrRedPackIds removeAllObjects];
    for (NSNumber* num in _arrRedPackIds)
    {
        NSNumber* number = [NSNumber numberWithInt:[num intValue]];
        [_lastArrRedPackIds addObject:number];
    }
    //保存使用不通用红包bool值
    lastIsHaveNotCommonSale = isHaveNotCommonSale;
    lastIsHaveNotCommonTicket = isHaveNotCommonTicket;
    //保存红包的各种抵扣金额
    _lastPriceSaleDikou = _priceSaleDikou;
    _lastPriceSaleZongji = _priceSaleZongji;
    _lastPriceTicketDikou = _priceTicketDikou;
    _lastPriceTicketZongji = _priceTicketZongji;
    _lastPriceRealSaleDikou = _priceRealSaleDikou;
    _lastPriceRealTicketDikou = _priceRealTicketDikou;
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
    [MobClick event:mainViewbtn42];
    [self refreshFooterFrame:_labelTip.hidden];
    
    [self refreshLabelRealPrice];
    BOOL isUseCard = NO;;
    for (CardStateModel* stateModel in _arrUsedCardState)
    {
        if (stateModel.chooseState == YES)
        {
            isUseCard = YES;
            break;
        }
    }
    if (_priceDikou>0 || isUseCard)
    {
        //已使用优惠
        [_orderGoodsView refreshData:discountSelected];
    }
    if (_priceDikou == 0 && !isUseCard)
    {
        //有可用优惠
        [_orderGoodsView refreshData:discountHave];
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

-(void)dismissDiscountTable
{
    //获取保存的可用卡列表状态数组
    [_arrUsedCardState removeAllObjects];
    for (CardStateModel* cModel in _lastArrUsedCardState)
    {
        CardStateModel* model = [[CardStateModel alloc]init];
        model.cardType = cModel.cardType;
        model.cardItemName = cModel.cardItemName;
        model.cardId = cModel.cardId;
        model.id = cModel.id;
        model.chooseState = cModel.chooseState;
        model.isShowViewAlpha = cModel.isShowViewAlpha;
        model.ticketPriceModel = cModel.ticketPriceModel;
        model.usedLeftCount = cModel.usedLeftCount;
        model.cardExchangeStep = cModel.cardExchangeStep;
        model.canUseCount = cModel.canUseCount;
        [_arrUsedCardState addObject:model];
    }
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
    //获取保存的当前卡model
    currentPriceModel.cinemaCardName = lastCurrentPriceModel.cinemaCardName;
    currentPriceModel.memberPrice = lastCurrentPriceModel.memberPrice;
    currentPriceModel.cinemaCardId = lastCurrentPriceModel.cinemaCardId;
    currentPriceModel.cardType = lastCurrentPriceModel.cardType;
    currentPriceModel.id = lastCurrentPriceModel.id;
    currentPriceModel.servicePrice = lastCurrentPriceModel.servicePrice;
    
    //获取保存的taopiaoid
    _taopiaoId = [NSNumber numberWithInteger:[_lastTaopiaoId integerValue]];
    //获取保存的当前使用套票个数
    currentUseCardNum= lastCurrentUseCardNum;
    curCardNum= lastCurCardNum;
    
    //获取保存的红包id数组
    [_arrRedPackIds removeAllObjects];
    for (NSNumber* num in _lastArrRedPackIds)
    {
        NSNumber* number = [NSNumber numberWithInt:[num intValue]];
        [_arrRedPackIds addObject:number];
    }
    
    //获取保存的使用不通用红包bool值
    isHaveNotCommonSale = lastIsHaveNotCommonSale;
    isHaveNotCommonTicket= lastIsHaveNotCommonTicket;
    
    //获取保存的红包的各种抵扣金额
    _priceSaleDikou= _lastPriceSaleDikou;
    _priceSaleZongji= _lastPriceSaleZongji;
    _priceTicketDikou= _lastPriceTicketDikou;
    _priceTicketZongji= _lastPriceTicketZongji;
    _priceRealSaleDikou= _lastPriceRealSaleDikou;
    _priceRealTicketDikou= _lastPriceRealTicketDikou;
    _notAppointTotalPrice=_lastPriceTicketZongji;
    
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

-(void)initOrderGoodsView
{
    _orderGoodsView = [[OrderGoodsView alloc]initWithFrame:CGRectMake(0, self._viewTop.frame.size.height+20+12+10, SCREEN_WIDTH, SCREEN_HEIGHT-(self._viewTop.frame.size.height+20+12+10)) arrSale:self._arrGoods orderModel:self._orderModel discountType:discountHave price:self.smallSalePrice];
    _orderGoodsView.backgroundColor = [UIColor clearColor];
    _orderGoodsView.showDelegate = self;
    [self.view addSubview:_orderGoodsView];
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
        float ticketPrice =currentUseCardNum * ([currentPriceModel.servicePrice floatValue] + [currentPriceModel.memberPrice floatValue]);
        _labelDikouPrice.text = [NSString stringWithFormat:@"-¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceDikou+ticketPrice-1]]];
        
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


-(void)closeDetail
{
    UIButton* btn = (UIButton*)[self.view viewWithTag:301];
    [self onButtonLookDetail:btn];
}

#pragma mark - 查看明细
-(void)onButtonLookDetail:(UIButton*)btn
{
    [MobClick event:mainViewbtn44];
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
        _viewline = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
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
        _labelHejiPrice.textColor = RGBA(51, 51, 51, 1);
        _labelHejiPrice.textAlignment = NSTextAlignmentRight;
        _labelHejiPrice.font = MKFONT(12);
        [_viewFooter addSubview:_labelHejiPrice];
    }
    if (!_labelDikouPrice)
    {
        _labelDikouPrice = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-150, _labelDikou.frame.origin.y-3, 150, 15)];
        _labelDikouPrice.text = @"¥0";
        _labelDikouPrice.textColor = RGBA(51, 51, 51, 1);
        _labelDikouPrice.font = MKFONT(12);
        _labelDikouPrice.textAlignment = NSTextAlignmentRight;
        [_viewFooter addSubview:_labelDikouPrice];
    }
}

#pragma mark - 使用卡
-(void)isUseCard:(BOOL)isUse cardModel:(CardStateModel *)cardModel
{
    if (_arrRedPackIds.count>0)
    {
        [Tool showWarningTip:@"权益优惠已变更，请重新选择红包" time:1.0];
    }
    
    //刷新卡cell蒙层显示的状态
    [self refreshAlphaState:isUse cardModel:cardModel];
    
    //刷新_arrUsedCardName
    [self refreshArrUsedCardName:isUse model:cardModel];
    
    if (cardModel.cardType == 1)
    {
        //次卡改价
        [self refreshCikaPrice:isUse cardModel:cardModel];
    }
    else
    {
        //套票、任看卡抵价
        [self refreshOtherCardPrice:isUse cardModel:cardModel];
    }
    [self changeOrderPrice];
    //
    //取消红包
    [self cancelRedPack];
    //
    [self refreshRealPayPrice];
    
    //    labelTip.hidden = YES;
    
    [_myTable reloadData];
}

//刷新_arrUsedCardName
-(void)refreshArrUsedCardName:(BOOL)isUse model:(CardStateModel*)cardModel
{
    if (isUse)
    {
        [_arrUsedCardName addObject:cardModel];
    }
    else
    {
        for (int i = 0; i<_arrUsedCardName.count; i++)
        {
            if (_arrUsedCardName[i] == cardModel)
            {
                [_arrUsedCardName removeObjectAtIndex:i];
            }
        }
    }
    
    //    [self refreshCardName];
}

//-(void)refreshCardName
//{
//    [_arrUsedCardTicketName removeAllObjects];
//    [_arrUsedCardSaleName removeAllObjects];
//
//    for (CardStateModel* cardModel in _arrUsedCardName)
//    {
//        //遍历出票的卡名称集合
//        if (cardModel.cardType == 1)
//        {
//            for (MemberPriceModel* m_Model in self.priceListModel.memberPriceList)
//            {
//                if ([cardModel.cardItemName isEqualToString:m_Model.cinemaCardName])
//                {
//                    [_arrUsedCardTicketName addObject:cardModel.cardItemName];
//                }
//            }
//        }
//        else
//        {
//            [_arrUsedCardTicketName addObject:cardModel.cardItemName];
//        }
//
//        //遍历出小卖的卡名称集合
//        if (cardModel.cardType == 1)
//        {
//            for (int i=0; i<self.arrGoodsList.count; i++)
//            {
//                GoodsListModel* goodsModel = self.arrGoodsList[i];
//                //算出价格
//                NSArray* arrMemberPrice = goodsModel.priceData.memberPriceList;
//                for (memberPriceListModel* memberModel in arrMemberPrice)
//                {
//                    if ([cardModel.cardItemName isEqualToString:memberModel.cinemaCardName])
//                    {
//                        [_arrUsedCardSaleName addObject:@[cardModel.cardItemName]];
//                    }
//                }
//            }
//        }
//    }
//}

//次卡改价
-(void)refreshCikaPrice:(BOOL)isUse cardModel:(CardStateModel *)cardModel
{
    if (isUse)
    {
        for (MemberPriceModel* m_Model in self.priceListModel.memberPriceList)
        {
            if (cardModel.cardId == [m_Model.cinemaCardId integerValue])
            {
                //当前价格model为当前勾选次卡的model
                currentPriceModel = m_Model;
            }
        }
    }
    else
    {
        //取消勾选次卡，当前价格model为次卡之外的最优卡model
        currentPriceModel = exceptModel;
    }
}

//套票、任看卡抵价
-(void)refreshOtherCardPrice:(BOOL)isUse cardModel:(CardStateModel *)cardModel
{
    if (isUse)
    {
        _taopiaoId = [NSNumber numberWithInteger:cardModel.id];
        currentUseCardNum = cardModel.canUseCount;
    }
    else
    {
        _taopiaoId = [NSNumber numberWithInteger:0];
        currentUseCardNum = 0;
    }
    if (cardModel.cardType == 4)
    {
        //通票
        curCardNum = cardModel.canUseCount * [cardModel.cardExchangeStep intValue];
    }
    else
    {
        curCardNum = currentUseCardNum;
    }
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
        if (curPacketType == 0)
        {
            if (!cellModel.common)
            {
                //有不通用红包
                isHaveNotCommonTicket = YES;
            }
            [self plusTicketPacket:cellModel packetModel:model];
        }
        else if (curPacketType == 4)
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
        if (curPacketType == 0)
        {
            if (!cellModel.common && cellModel.currentCount == 0)
            {
                //没有不通用红包
                isHaveNotCommonTicket = NO;
            }
            //票红包
            [self minusTicketPacket:cellModel packetModel:model];
        }
        else if (curPacketType == 4)
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

-(void)plusTicketPacket:(RedPacketCellModel*)cellModel packetModel:(RedPacketListModel *)model
{
    //使用限制  1:票/小卖数，2:主订单
    NSInteger useLimit = [model.useLimit integerValue];
    
    if (useLimit == 1)
    {
        //票数量红包
        //票使用个数＋1
        cellModel.usedTicketCount += 1;
    }
    
    cellModel.isViewAlphaHidden = YES;
    
    float ticketPrice = [currentPriceModel.servicePrice floatValue] + [currentPriceModel.memberPrice floatValue];
    if ([model.worth floatValue] > ticketPrice && useLimit == 1)
    {
        //当前票数量红包抵扣金额 > 单张票价
        _priceTicketDikou += ticketPrice;
    }
    else if (useLimit == 2 && [model.worth floatValue] > (ticketNum-currentUseCardNum) * ticketPrice)
    {
        //票订单红包，抵扣金额>票实付金额
        _priceTicketDikou += (ticketNum-currentUseCardNum) * ticketPrice;
    }
    else
    {
        _priceTicketDikou += [model.worth floatValue];
    }
    _priceRealTicketDikou = _priceTicketDikou;
    if (_priceTicketDikou >= _priceTicketZongji)
    {
        //当票红包抵扣金额 >= 票价格，抵扣金额 ＝ 票价格
        _priceTicketDikou = _priceTicketZongji;
        for (RedPacketCellModel* cModel in arrayRedPacketModel)
        {
            if (cModel.redPacketType == 0)
            {
                if (!cModel.useState)
                {
                    //未勾选的所有票红包置灰
                    cModel.isViewAlphaHidden = NO;
                }
                else
                {
                    //已勾选的所有票红包＋置灰，－亮
                    cModel.isCanTouchMinus = YES;
                    cModel.isCanTouchPlus = NO;
                }
            }
        }
    }
    else
    {
        //当票红包抵扣金额 < 票价格
        if (useLimit == 2)
        {
            //票订单红包
            //该订单红包－亮，＋置灰
            cellModel.isCanTouchPlus = NO;
            cellModel.isCanTouchMinus = YES;
        }
        else if (useLimit == 1)
        {
            //票数量红包
            
            //当已用票红包个数 = 票张数-套票任看卡使用张数，该票红包＋置灰，－亮
            if (cellModel.usedTicketCount == ticketNum - currentUseCardNum)
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
        
        //如果该票红包是不通用的，则其他所有未勾选的不通用票红包置灰
        if (!cellModel.common)
        {
            for (RedPacketCellModel* cModel in arrayRedPacketModel)
            {
                if (!cModel.common && !cModel.useState && cModel.redPacketType == 0)
                {
                    cModel.isViewAlphaHidden = NO;
                }
            }
        }
    }
}

-(void)minusTicketPacket:(RedPacketCellModel*)cellModel packetModel:(RedPacketListModel *)model
{
    //使用限制  0:不限制，1:票/小卖数，2:主订单
    NSInteger useLimit = [model.useLimit integerValue];
    
    if (useLimit == 1)
    {
        //票数量红包
        //票使用个数－1
        cellModel.usedTicketCount -= 1;
    }
    float ticketPrice = [currentPriceModel.servicePrice floatValue] + [currentPriceModel.memberPrice floatValue];
    if ([model.worth floatValue] > ticketPrice && useLimit == 1)
    {
        //当前票数量红包抵扣金额 > 单张票价
        _priceRealTicketDikou -= ticketPrice;
    }
    else if (useLimit == 2 && [model.worth floatValue] > (ticketNum-currentUseCardNum) * ticketPrice)
    {
        //票订单红包，抵扣金额>票实付金额
        _priceRealTicketDikou -= (ticketNum-currentUseCardNum) * ticketPrice;
    }
    else
    {
        _priceRealTicketDikou -= [model.worth floatValue];
    }
    
    if (_priceRealTicketDikou >= _priceTicketZongji)
    {
        //票实际抵扣价>=票总价
        _priceTicketDikou = _priceTicketZongji;
        //所有已勾选的票红包＋置灰
        for (RedPacketCellModel* cModel in arrayRedPacketModel)
        {
            if (cModel.redPacketType == 0 && cModel.useState)
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
        //票实际抵扣价<票总价
        _priceTicketDikou = _priceRealTicketDikou;
        if (useLimit == 2)
        {
            //票订单红包
            //该红包－置灰，＋亮
            cellModel.isCanTouchPlus = YES;
            cellModel.isCanTouchMinus = NO;
            
            if (!cellModel.common)
            {
                //该红包是不通用订单票红包，则所有不通用票红包亮
                for (RedPacketCellModel* cModel in arrayRedPacketModel)
                {
                    if (!cModel.common && cModel.redPacketType == 0)
                    {
                        cModel.isViewAlphaHidden = YES;
                    }
                }
            }
        }
        else if (useLimit == 1)
        {
            //票数量红包
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
                        if (!cModel.common && cModel.redPacketType == 0)
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
                //是通用票红包，所有票红包亮
                if (cModel.redPacketType == 0)
                {
                    cModel.isViewAlphaHidden = YES;
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
            }
            else
            {
                //是不通用票红包，所有通用票红包亮
                if (cModel.redPacketType == 0 && cModel.common)
                {
                    cModel.isViewAlphaHidden = YES;
                }
            }
        }
        if (isHaveNotCommonTicket)
        {
            //如果有不通用红包，所有通用的票红包亮
            for (RedPacketCellModel* cModel in arrayRedPacketModel)
            {
                if (cModel.redPacketType == 0 && cModel.common)
                {
                    cModel.isViewAlphaHidden = YES;
                }
                if (cModel.redPacketType == 0 && !cModel.common && !cModel.useState)
                {
                    cModel.isViewAlphaHidden = NO;
                }
            }
        }
    }
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
    
    _priceSaleDikou += [model.worth floatValue];
    _priceRealSaleDikou = _priceSaleDikou;
    if (_priceSaleDikou >= _priceSaleZongji-_notAppointTotalPrice)
    {
        //当小卖红包抵扣金额 >= 小卖总价-非指定小卖总价，抵扣金额 ＝ 小卖总价-非指定小卖总价
        _priceSaleDikou = _priceSaleZongji-_notAppointTotalPrice;
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
        //当小卖红包抵扣金额 < 小卖价格
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
    _priceRealSaleDikou -= [model.worth floatValue];
    if (_priceRealSaleDikou >= _priceSaleZongji-_notAppointTotalPrice)
    {
        //小卖实际抵扣价>=小卖总价-非指定小卖总价
        _priceSaleDikou = _priceSaleZongji;
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
        _priceSaleDikou = _priceRealSaleDikou;
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
        for (SmallSaleModel* saleModel in self._arrGoods)
        {
            if (![self selectNotAppointId:saleModel._goodsId array:limitIdArray])
            {
                //算出非指定小卖的价格
                float notAppointPrice = saleModel._price * saleModel._count;
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

-(BOOL)selectNotAppointId:(int)goodsId array:(NSArray*)limitArray
{
    for (NSNumber* saleId in limitArray)
    {
        if ([saleId intValue] == goodsId)
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 算价
-(void)refreshDikouPrice
{
    _priceDikou = _priceTicketDikou + _priceSaleDikou;
    float ticketPrice =currentUseCardNum * ([currentPriceModel.servicePrice floatValue] + [currentPriceModel.memberPrice floatValue]);
    if (_priceDikou == 0 && ticketPrice==0)
    {
        _labelDikouPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceDikou+ticketPrice]]];
    }
    else
    {
        _labelDikouPrice.text = [NSString stringWithFormat:@"-¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceDikou+ticketPrice]]];
    }
    float priceSum = _priceZongji-_priceDikou-ticketPrice;
    if (_priceDikou > 0)
    {
        if (_priceZongji == _priceDikou+ticketPrice)
        {
            _labelTip.hidden = NO;
            priceSum = 1;
        }
        else
        {
            _labelTip.hidden = YES;
        }
    }
    else
    {
        _labelTip.hidden = YES;
    }
    _priceRealPay = priceSum;
}

-(void)changeOrderPrice
{
    saleTotalPrice = 0;   //小卖总价归零重算
    /***********************
     算出票价
     **********************/
    NSInteger currentSeatCount = ticketNum;
    //当前服务费
    float currentServicePrice = [currentPriceModel.servicePrice floatValue];
    //当前票单价
    float currentMemberPrice = [currentPriceModel.memberPrice floatValue];
    //当前票价
    float currentTicketPrice = (currentServicePrice + currentMemberPrice)*currentSeatCount;
    self._orderModel.strServicePrice = [NSString stringWithFormat:@"%.1f",currentServicePrice];
    self._orderModel.strFilmPrice = [NSString stringWithFormat:@"%.1f",currentTicketPrice];
    
    /***********************
     算出卖品价
     **********************/
    for (int i=0; i<self.arrGoodsList.count; i++)
    {
        GoodsListModel* goodsModel = self.arrGoodsList[i];
        SmallSaleModel* saleModel = self._arrGoods[i];
        //算出价格
        NSArray* arrMemberPrice = goodsModel.priceData.memberPriceList;
        int salePrice = 0;
        for (memberPriceListModel* memberModel in arrMemberPrice)
        {
            if ([currentPriceModel.cinemaCardId intValue] == [memberModel.cinemaCardId intValue])
            {
                //当前身份的小卖单价
                salePrice = [memberModel.memberPrice intValue] + [memberModel.servicePrice intValue];
            }
        }
        if (salePrice == 0)
        {
            salePrice = [goodsModel.priceData.priceBasic intValue] + [goodsModel.priceData.priceService intValue];
        }
        saleModel._price = salePrice;
        saleTotalPrice += salePrice * saleModel._count;
    }
    
    _priceTicketZongji = currentTicketPrice;
    _priceSaleZongji = saleTotalPrice;
    _priceZongji = currentTicketPrice + saleTotalPrice;
    _labelHejiPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceZongji]]];
}

//重置红包状态
-(void)cancelRedPack
{
    [arrayRedPacketModel removeAllObjects];
    [self setRedPacketModelArray:(NSMutableArray*)_packetArr];
    _priceTicketDikou = 0;
    _priceSaleDikou = 0;
    _priceDikou = 0;
    float ticketPrice =currentUseCardNum * ([currentPriceModel.servicePrice floatValue] + [currentPriceModel.memberPrice floatValue]);
    if (ticketPrice == 0)
    {
        _labelDikouPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceDikou+ticketPrice]]];
    }
    else
    {
        _labelDikouPrice.text = [NSString stringWithFormat:@"-¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceDikou+ticketPrice]]];
    }
    [_arrRedPackIds removeAllObjects];
    
    //勾选任选卡套票把票价全抵完，所有票红包置灰
    for (RedPacketCellModel* cModel in arrayRedPacketModel)
    {
        if (cModel.redPacketType == 0)
        {
            if (_priceTicketZongji - ticketPrice == 0)
            {
                cModel.isViewAlphaHidden = NO;
            }
            else
            {
                cModel.isViewAlphaHidden = YES;
            }
        }
    }
}

-(void)refreshRealPayPrice
{
    float ticketPrice = [currentPriceModel.servicePrice floatValue] + [currentPriceModel.memberPrice floatValue];
    _priceRealPay = _priceZongji - _priceDikou - currentUseCardNum * ticketPrice;
    [_btnDiscount setTitle:[NSString stringWithFormat:@"实付金额：¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceRealPay]]] forState:UIControlStateNormal];
}

-(void)refreshLabelRealPrice
{
    /******************
     刷新价格UI
     ******************/
    [_labelRealPrice setText:[NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:_priceRealPay]]]];
}

#pragma mark - tableView protocol
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //可用卡个数＋红包个数
    return arrCanUseCard.count + _packetArr.count;
}

//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < arrCanUseCard.count)
    {
        cinemaCardItemListModel* model = arrCanUseCard[indexPath.row];
        if ([model.cardType integerValue] == 4)
        {
            //通票
            return 110;
        }
        else if ([model.cardType integerValue] == 2)
        {
            //套票
            return  100;
        }
        else
        {
            //任看卡、次卡
            return 88;
        }
    }
    else
    {
        CellIndex index = 1;
        if (_packetArr.count == arrCanUseCard.count+1)
        {
            //唯一一个红包cell
            index = 3;
        }
        else
        {
            if (indexPath.row == arrCanUseCard.count)
            {
                //第一个红包cell
                index = 0;
            }
            else if (indexPath.row == arrCanUseCard.count+_packetArr.count-1)
            {
                //最后一个红包cell
                index = 2;
            }
        }
        CGFloat originY = 15;
        if (index == 0 || index == 3)
        {
            //第一个红包
            originY = 30;
        }
        return originY+100;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier1= [NSString stringWithFormat:@"OrderDiscountCardTableViewCell%ld",(long)indexPath.row];
    NSString *identifier2 = [NSString stringWithFormat:@"OrderDiscountTableViewCell%ld",(long)indexPath.row];
    if (indexPath.row < arrCanUseCard.count)
    {
        //卡cell
        OrderDiscountCardTableViewCell *cell = (OrderDiscountCardTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell==nil)
        {
            cell = [[OrderDiscountCardTableViewCell alloc] initWithReuseIdentifier:identifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cellDelegate = self;
            cell.backgroundColor = [UIColor clearColor];
        }
        CellIndex index = 1;
        if (arrCanUseCard.count == 1)
        {
            //唯一一个卡cell
            index = 3;
        }
        else
        {
            if (indexPath.row == 0)
            {
                //第一个卡cell
                index = 0;
            }
            else if (indexPath.row == arrCanUseCard.count-1)
            {
                //最后一个卡cell
                index = 2;
            }
        }
        //卡cell
        [cell setCardData:arrCanUseCard[indexPath.row] cardStateModel:_arrUsedCardState[indexPath.row] cellIndex:index];
        [cell layoutCard:index];
        return cell;
    }
    else
    {
        //红包cell
        OrderDiscountTableViewCell *cell = (OrderDiscountTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell==nil)
        {
            cell = [[OrderDiscountTableViewCell alloc] initWithReuseIdentifier:identifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cellDelegate = self;
            cell.backgroundColor = [UIColor clearColor];
        }
        CellIndex index = 1;
        if (_packetArr.count == arrCanUseCard.count+1)
        {
            //唯一一个红包cell
            index = 3;
        }
        else
        {
            if (indexPath.row == arrCanUseCard.count)
            {
                //第一个红包cell
                index = 0;
            }
            else if (indexPath.row == arrCanUseCard.count+_packetArr.count-1)
            {
                //最后一个红包cell
                index = 2;
            }
        }
        //红包cell
        [cell setPacketData:_packetArr[indexPath.row-arrCanUseCard.count] cellModel:arrayRedPacketModel[indexPath.row-arrCanUseCard.count] cellIndex:index];
        [cell layoutPacket:index];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark 创建订单成功后去轮询订单 GetOrderStatus 接口
-(void)onButtonCreateOrder:(UIButton*)sender
{
    [MobClick event:mainViewbtn45];
    [sender setEnabled:NO];
    if (_priceRealPay == 0)
    {
        //实付0元
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"支付金额：0元" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"支付", nil];
        alert.tag = 10;
        alert.delegate = self;
        [alert show];
    }
    else
    {
        [self createOrder];
    }
}

//创建订单
-(void) createOrder
{
    //校验手机号
    if (_orderGoodsView.strTel.length != 11 || ![Tool validateTel:_orderGoodsView.strTel])
    {
        [Tool showWarningTip:@"您输入的手机号不对哦~"  time:1];
        _btnConfirm.enabled = YES;
        [_orderGoodsView showKeyBoard];
        return;
    }
    //买票
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"正在锁座，请稍候" withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    //创建订单
    _cikaId = currentPriceModel.id;
    
    [ServicesOrder createOrder:self._orderModel.showtimeId seatIds:self._orderModel.arrSeatIds
                  cinemaCardId:memberCardItemId cinemaCardItemId:@0 goodsArr:self._arrayGoods
                  redPacketArr:_arrRedPackIds taopiaoItemId:_taopiaoId useTaopiaoTicketCount:[NSNumber numberWithInt:curCardNum]
              cikaOrCardItemId:_cikaId clientCalculationTotalPrice:[NSNumber numberWithFloat:_priceRealPay] mobileNo:[NSNumber numberWithLongLong:[_orderGoodsView.strTel longLongValue]]
                         model:^(CreateOrderModel *model)
     {
         _orderId =model.orderId;
         [weakSelf CreateOrderIsSuccess];
         
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         if (error.code == -600)
         {
             //创建小卖订单失败，还有其他商品可以选择
             UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"当前卖品购买失败，是否购买其他卖品" delegate:weakSelf cancelButtonTitle:@"重选卖品" otherButtonTitles:@"支付影票", nil];
             alert.tag = 0;
             [alert show];
         }
         else if (error.code == -601)
         {
             //创建小卖订单失败，没有其他商品可以选择
             UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"当前卖品购买失败，取消或继续支付影票" delegate:weakSelf cancelButtonTitle:@"取消订单" otherButtonTitles:@"支付影票", nil];
             alert.tag = 1;
             [alert show];
         }
         else if (error.code == -130)
         {
             //手机号不正确
             [Tool showWarningTip:error.domain time:2.0];
             _btnConfirm.enabled = YES;
         }
         else
         {
             [weakSelf popToSeat:error];
         }
     }];
}

#pragma mark alertviewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSLog(@"支付影票");
        if (alertView.tag == 10)
        {
            //实付0元
            [self createOrder];
        }
        else
        {
            __weak typeof(self) weakSelf = self;
            [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"正在锁座，请稍候" withBlur:NO allowTap:NO];
            [ServicesOrder createOrder:self._orderModel.showtimeId seatIds:self._orderModel.arrSeatIds cinemaCardId:memberCardItemId cinemaCardItemId:@0 goodsArr:nil redPacketArr:_arrRedPackIds taopiaoItemId:_taopiaoId useTaopiaoTicketCount:[NSNumber numberWithInt:curCardNum] cikaOrCardItemId:_cikaId clientCalculationTotalPrice:[NSNumber numberWithFloat:_priceRealPay] mobileNo:[NSNumber numberWithInteger:[_orderGoodsView.strTel integerValue]] model:^(CreateOrderModel *model)
             {
                 saleTotalPrice = 0;
                 _orderId =model.orderId;
                 [weakSelf CreateOrderIsSuccess];
             } failure:^(NSError *error) {
                 [weakSelf popToSeat:error];
             }];
        }
    }
    else if (buttonIndex == 0)
    {
        if (alertView.tag == 0)
        {
            NSLog(@"重选卖品");
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHSMALLSALE object:nil];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -2)] animated:YES];
        }
        else if (alertView.tag == 3)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if (alertView.tag == 10)
        {
            _btnConfirm.enabled = YES;
        }
        else
        {
            NSLog(@"取消订单");
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHSEATS object:nil];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
        }
    }
}

#pragma mark 订单创建成功后验证是否锁座成功
-(void)CreateOrderIsSuccess
{
    self._orderTimer = [NSTimer scheduledTimerWithTimeInterval:2
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
             //锁座成功跳转到支付页
             if ([model.orderStatus intValue] == 10 )
             {
                 //                 NSLog(@"--@@@@#####-%@",NSStringFromClass([self.navigationController.topViewController class]));
                 if(![NSStringFromClass([self.navigationController.topViewController class] ) isEqualToString:@"PayViewController"])
                 {
                     [WeakSelf getPayWay:model];
                 }
             }
             if ([model.orderStatus intValue] == 20 || _lockSeatTimeCount>= ORDERRUNMAXTIME)
             {
                 [FVCustomAlertView hideAlertFromView:WeakSelf.view fading:YES];
                 _lockSeatTimeCount = 0;
                 [WeakSelf stopTimer];
                 [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHSEATS object:nil];
                 [Tool showWarningTip:@"锁座失败" time:2];
                 [WeakSelf pop];
             }
             if ([model.orderStatus intValue] == 30 )//成功
             {
                 [FVCustomAlertView hideAlertFromView:WeakSelf.view fading:YES];
                 [WeakSelf stopTimer];
                 BuyTicketSuccessViewController *buyTicketSuccessVC = [[BuyTicketSuccessViewController alloc ] init];
                 buyTicketSuccessVC._orderId =_orderId;
                 //                 buyTicketSuccessVC._strPayWay = self._payType;
                 [WeakSelf.navigationController pushViewController:buyTicketSuccessVC animated:YES];
                 [Tool showSuccessTip:@"出票成功！" time:1.0];
             }
             if ([model.orderStatus intValue] == 40 )//失败
             {
                 [WeakSelf showOrderFaildView:model];
                 [WeakSelf stopTimer];
                 [FVCustomAlertView hideAlertFromView:WeakSelf.view fading:YES];
             }
             
         } failure:^(NSError *error) {
             [WeakSelf stopTimer];
             [Tool showWarningTip:@"网络中断！"  time:1];
         }];
    }
}

#pragma mark 获取支付方式
-(void)getPayWay:(OrderWhileModel *)model
{
    __weak typeof(self) WeakSelf = self;
    //从支付方式接口读取是否还需要支付字段
    [ServicesPay getPayWayList:_orderId model:^(PayModelList *payModelList)
     {
         //需要支付,如果不需要支付则继续轮询
         if(![payModelList.notNeedPay boolValue])
         {
             [WeakSelf stopTimer];
             [WeakSelf jumpPayWaySelectView:model];
         }
     } failure:^(NSError *error) {
         [Tool showWarningTip:error.domain time:2];
     }];
}
//返回
-(void)onButtonBack
{
    for (int i=0; i<self.arrGoodsList.count; i++)
    {
        GoodsListModel* goodsModel = self.arrGoodsList[i];
        SmallSaleModel* saleModel = self._arrGoods[i];
        //算出价格
        NSArray* arrMemberPrice = goodsModel.priceData.memberPriceList;
        int salePrice = 0;
        for (memberPriceListModel* memberModel in arrMemberPrice)
        {
            if ([self._orderModel.strCardId integerValue] == [memberModel.cinemaCardId intValue])
            {
                salePrice = [memberModel.memberPrice intValue] + [memberModel.servicePrice intValue];
            }
        }
        if (salePrice == 0)
        {
            salePrice = [goodsModel.priceData.priceBasic intValue] + [goodsModel.priceData.priceService intValue] ;//saleModel._price;
        }
        saleModel._price = salePrice;
    }
    //    self._orderModel.strServicePrice = [NSString stringWithFormat:@"%.1f",defaultServicePrice];
    //    self._orderModel.strTotalPrice = [NSString stringWithFormat:@"%.1f",defaultTotalPrice];
    //    self._orderModel.strFilmPrice = [NSString stringWithFormat:@"%.1f",defaultTotalPrice];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 跳转到支付方式选择页
-(void)jumpPayWaySelectView:(OrderWhileModel *)model
{
    [Config saveUserOrderPhone:[Config getUserId] phoneText:_orderGoodsView.strTel];
    
    PayViewController *payView = [[PayViewController alloc ] init];
    payView.isHaveSaleVC = self.isFromSale;
    payView._orderId = model.orderId;
    self._orderModel.strAllPrice = [NSString stringWithFormat:@"%.1f",_priceRealPay];
    payView._orderModel = self._orderModel;
    [self.navigationController pushViewController:payView animated:YES];
}

#pragma mark 失败view
-(void) showOrderFaildView:(OrderWhileModel *)model
{
    if(!_payFaildView)
    {
        _payFaildView = [[PayFaildVIew alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) orderModel:model];
        _payFaildView.hidden=YES;
        _payFaildView.alpha=0;
        _payFaildView.payFaildViewDelegate = self;
        _payFaildView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        [self.view addSubview:_payFaildView];
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         _payFaildView.transform = CGAffineTransformMakeScale(1, 1);
                         _payFaildView.hidden=NO;
                         _payFaildView.alpha=1;
                     }completion:^(BOOL finish){
                         
                     }];
}

-(void)payFailedToCard
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
}

-(void)pop
{
    //pop到选座页
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
}

-(void) stopTimer
{
    if(self._orderTimer)
    {
        [self._orderTimer invalidate];
        self._orderTimer = nil;
    }
}

#pragma mark 通票详情
-(void)showTongPiaoDetail:(NSNumber *)tongpiaoId
{
    __weak BuildOrderViewController *weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesOrder getTongPiaoDetail:tongpiaoId model:^(TongPiaoInfoModel *model)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         [weakSelf initUseRuleView:model];
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
     }];
}

-(void)initUseRuleView:(TongPiaoInfoModel*)tpModel
{
    if (_viewRule)
    {
        _viewRule = nil;
        [_viewRule removeFromSuperview];
    }
    _viewRule = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, _viewDiscount.frame.origin.y, SCREEN_WIDTH, _viewDiscount.frame.size.height)];
    _viewRule.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewRule];
    
    UILabel* labelRule = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    labelRule.text = @"使用规则";
    labelRule.textColor = RGBA(51, 51, 51, 1);
    labelRule.font = MKFONT(15);
    labelRule.textAlignment = NSTextAlignmentCenter;
    [_viewRule addSubview:labelRule];
    
    UIView* viewRuleLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5)];
    viewRuleLine.backgroundColor = RGBA(0, 0, 0, 0.05);
    [_viewRule addSubview:viewRuleLine];
    
    UILabel* labelRuleDetail = [[UILabel alloc]initWithFrame:CGRectMake(15, labelRule.frame.origin.y+labelRule.frame.size.height+30, SCREEN_WIDTH-30, _viewRule.frame.size.height - (labelRule.frame.origin.y+labelRule.frame.size.height+30))];
    labelRuleDetail.text = tpModel.useRulesDesc;
    labelRuleDetail.textColor = RGBA(102, 102, 102, 1);
    labelRuleDetail.font = MKFONT(14);
    labelRuleDetail.lineBreakMode = NSLineBreakByCharWrapping;
    labelRuleDetail.numberOfLines = 0;
    [Tool setLabelSpacing:labelRuleDetail spacing:5 alignment:NSTextAlignmentLeft];
    [_viewRule addSubview:labelRuleDetail];
    
    UIButton* btnRuleBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 15/2, 42, 30)];
    [btnRuleBack setImage:[UIImage imageNamed:@"btn_backBlack.png"] forState:UIControlStateNormal];
    [btnRuleBack addTarget:self action:@selector(onButtonRuleBack) forControlEvents:UIControlEventTouchUpInside];
    [_viewRule addSubview:btnRuleBack];
    
    [UIView animateWithDuration:0.3 animations:^{
        _viewRule.frame = CGRectMake(0, _viewDiscount.frame.origin.y, SCREEN_WIDTH, _viewDiscount.frame.size.height);
        _viewDiscount.frame = CGRectMake(-SCREEN_WIDTH, _viewDiscount.frame.origin.y, SCREEN_WIDTH, _viewDiscount.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)onButtonRuleBack
{
    [UIView animateWithDuration:0.3 animations:^{
        _viewRule.frame = CGRectMake(SCREEN_WIDTH, _viewDiscount.frame.origin.y, SCREEN_WIDTH, _viewDiscount.frame.size.height);
        _viewDiscount.frame = CGRectMake(0, _viewDiscount.frame.origin.y, SCREEN_WIDTH, _viewDiscount.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
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
