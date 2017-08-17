//
//  TicketGoodsDetailViewController.m
//  supercinema
//
//  Created by dust on 16/11/24.
//
//

#import "TicketGoodsDetailViewController.h"

#define   posx          15

@interface TicketGoodsDetailViewController ()

@end

@implementation TicketGoodsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self._labelTitle.text = @"订单详情";
    self._arrayMap = [[NSMutableArray alloc] init];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self._viewTop.frame.origin.y+self._viewTop.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-self._viewTop.frame.size.height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [_scrollView setBackgroundColor:RGBA(246, 246, 251,1)];
    [_scrollView setUserInteractionEnabled:YES];
    [self.view addSubview:_scrollView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self loadOrderDetail];
}


- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat curkeyBoardHeight = [[info objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[info objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[info objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat keyBoardHeight;
    /*! 第三方键盘回调三次问题，监听仅执行最后一次 */
    if(begin.size.height > 0 && (begin.origin.y - end.origin.y > 0))
    {
        keyBoardHeight = curkeyBoardHeight;
        [[ExAlertView sharedAlertView] showAlertViewWithAlertContentViewKeyboardHeight:keyBoardHeight];
    }
}

- (void)keyboardWasHidden:(NSNotification *)notification
{
    [[ExAlertView sharedAlertView] dismissAlertView];
}

#pragma mark 加载订单详情数据
-(void) loadOrderDetail
{
    __weak typeof(self) WeakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:YES];
    [ServicesOrder getOrderDetail:self._orderDetialModel.orderId model:^(OrderInfoModel *model)
    {
        [FVCustomAlertView hideAlertFromView:WeakSelf.view fading:YES];
        if ([model.payStatus intValue] == 0 )
        {
            model.shareRedpackFee=@0;
        }

        _orderDetail = model;
        [WeakSelf showOrderUI];
        
    } failure:^(NSError *error) {
        [Tool showWarningTip:error.domain time:1];
    }];
}

#pragma mark -----创建发红包UI------
-(void) createShareRedPacket
{
    _btnShareRedPaket = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 89/2)];
    [_btnShareRedPaket setBackgroundColor:[UIColor whiteColor]];
    [_btnShareRedPaket.layer setBorderColor:RGBA(0, 0, 0, 0.05).CGColor];
    [_btnShareRedPaket.layer setBorderWidth:0.5];
    [_btnShareRedPaket addTarget:self action:@selector(onButtonShare) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_btnShareRedPaket];

    UIButton* btnRedPacketImage = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2- (38/2+7+70/2)/2, 33/2, 38/2, 25/2)];
    [btnRedPacketImage setImage:[UIImage imageNamed:@"btn_shareRedPacket.png"] forState:UIControlStateNormal];
    [btnRedPacketImage addTarget:self action:@selector(onButtonShare) forControlEvents:UIControlEventTouchUpInside];
    [_btnShareRedPaket addSubview:btnRedPacketImage];
    
    UIButton *btnRedPacketText =  [[UIButton alloc] initWithFrame:CGRectMake(btnRedPacketImage.frame.origin.x+btnRedPacketImage.frame.size.width+7, btnRedPacketImage.frame.origin.y, 124/2, 12)];
    [btnRedPacketText setTitle:@"发红包" forState:UIControlStateNormal];
    [btnRedPacketText setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnRedPacketText.titleLabel setFont:MKFONT(12)];
    [btnRedPacketText setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
    [btnRedPacketText setUserInteractionEnabled:YES];
    [btnRedPacketText addTarget:self action:@selector(onButtonShare) forControlEvents:UIControlEventTouchUpInside];
    [_btnShareRedPaket addSubview:btnRedPacketText];
    
}

#pragma mark 判断显示不同UI
-(void) showOrderUI
{
    int redPacketY = 0;
    //卡
    if(self._orderDetialModel.cardOrder != nil && self._orderDetialModel.ticketOrder== nil && [self._orderDetialModel.goodsOrderList count] == 0)
    {
        [_scrollView setContentSize:CGSizeMake(0, SCREEN_HEIGHT)];
        
        if ([_orderDetail.shareRedpackFee intValue] > 0)
        {
            redPacketY = 110/2;
            [self createShareRedPacket];
        }
        //会员卡
        [self initMemberCardController:redPacketY];
        //优惠信息
        [self initFavorableSumController:_viewGoods];
        //影院地址和电话
        [self initCinemaAndTelController];
        [self setMemberCardInfo];
    }
    //票
    if(self._orderDetialModel.cardOrder == nil && self._orderDetialModel.ticketOrder != nil && [self._orderDetialModel.goodsOrderList count] == 0)
    {
        [_scrollView setContentSize:CGSizeMake(0, SCREEN_HEIGHT)];
        if ([_orderDetail.shareRedpackFee intValue] > 0)
        {
            redPacketY = 110/2;
            [self createShareRedPacket];
        }
        //票
        [self initTicketsController:redPacketY];
        //优惠信息
        [self initFavorableSumController:_viewTicketStatusBg];
        //影院地址和电话
        [self initCinemaAndTelController];
    }
    //小卖
    if(self._orderDetialModel.cardOrder == nil && self._orderDetialModel.ticketOrder== nil && [self._orderDetialModel.goodsOrderList count] > 0)
    {
        int scrollViewHeight = 0;
        for(int i = 0; i < [_orderDetail.goodsOrderList count]; i++)
        {
            GoodsListCardPackModel *goodsModel = _orderDetail.goodsOrderList[i];
            if ([goodsModel.subOrderShowStatus intValue] == 2 || [goodsModel.subOrderShowStatus intValue] == 5 )
            {
                scrollViewHeight = scrollViewHeight+240;
            }
            else
            {
                scrollViewHeight = scrollViewHeight+210;
            }
        }
        [_scrollView setContentSize:CGSizeMake(0, 400+ scrollViewHeight)];
        if ([_orderDetail.shareRedpackFee intValue] > 0)
        {
            redPacketY = 110/2;
            [self createShareRedPacket];
        }
        //小卖
        [self initGoodsController:NO Y:redPacketY];
        //优惠信息
        [self initFavorableSumController:_viewGoods];
        //影院地址和电话
        [self initCinemaAndTelController];
        
    }
    //票和小卖
    if(self._orderDetialModel.cardOrder == nil && self._orderDetialModel.ticketOrder != nil && [self._orderDetialModel.goodsOrderList count] > 0)
    {
        int scrollViewHeight = 0;
        for(int i = 0; i < [_orderDetail.goodsOrderList count]; i++)
        {
            GoodsListCardPackModel *goodsModel = _orderDetail.goodsOrderList[i];
            if ([goodsModel.subOrderShowStatus intValue] == 2 || [goodsModel.subOrderShowStatus intValue] == 5 )
            {
                scrollViewHeight = scrollViewHeight+240;
            }
            else
            {
                scrollViewHeight = scrollViewHeight+210;
            }
        }
        [_scrollView setContentSize:CGSizeMake(0, 400+ scrollViewHeight+220)];
        if ([_orderDetail.shareRedpackFee intValue] >0)
        {
            redPacketY = 110/2;
            [self createShareRedPacket];
        }
        //票
        [self initTicketsController:redPacketY];
        //小卖
        [self initGoodsController:NO Y:0];
        //优惠信息
        [self initFavorableSumController:_viewGoods];
        //影院地址和电话
        [self initCinemaAndTelController];
        //刷新票和小卖
//        [self refreshTicketAndGoods];
    }
}

#pragma mark 票信息
-(void) initTicketsController:(int) startPosY
{
    //票白色背景
    _viewTicketStatusBg = [[UIView alloc ] initWithFrame:CGRectMake(posx, startPosY+10, SCREEN_WIDTH-30, 396/2)];
    [_viewTicketStatusBg setBackgroundColor:[UIColor whiteColor]];
    [_viewTicketStatusBg.layer setBorderColor:RGBA(0, 0, 0, 0.05).CGColor];
    [_viewTicketStatusBg.layer setBorderWidth:0.5];
    [_viewTicketStatusBg.layer setMasksToBounds:YES ];
    [_viewTicketStatusBg.layer setCornerRadius:2];
    [_scrollView addSubview:_viewTicketStatusBg];

    //票状态
    _labelTicketStatus = [[UILabel alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 85/2)];
    [_labelTicketStatus setBackgroundColor:[UIColor clearColor]];
    [_labelTicketStatus setTextColor:RGBA(0, 0, 0, 1)];
    [_labelTicketStatus setFont:MKFONT(14)];
    [_labelTicketStatus setTextAlignment:NSTextAlignmentCenter];
    [_viewTicketStatusBg addSubview:_labelTicketStatus];
    
    //提示取票
    _labelGetTicketTip= [[UILabel alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 10)];
    [_labelGetTicketTip setBackgroundColor:[UIColor clearColor]];
    [_labelGetTicketTip setTextColor:RGBA(123, 122, 152, 1)];
    [_labelGetTicketTip setFont:MKFONT(10)];
    [_labelGetTicketTip setTextAlignment:NSTextAlignmentCenter];
    [_viewTicketStatusBg addSubview:_labelGetTicketTip];
    [_labelGetTicketTip setHidden:YES];
    
    _imageLine =[[UIImageView alloc ] initWithFrame:CGRectMake(0, _labelTicketStatus.frame.origin.y+_labelTicketStatus.frame.size.height, SCREEN_WIDTH-30, 5)];
    [_imageLine setImage:[UIImage imageNamed:@"image_holeLine.png"]];
    [_viewTicketStatusBg addSubview:_imageLine];
    
    _imageViewTicket = [[UIImageView alloc ] initWithFrame:CGRectMake(posx+15, _imageLine.frame.origin.y+_imageLine.frame.size.height+25, 135/2, 90)];
    [_imageViewTicket setBackgroundColor:[UIColor redColor]];
    [_viewTicketStatusBg addSubview:_imageViewTicket];
 
    _labelFilmName = [[UILabel alloc ] initWithFrame:CGRectMake(_imageViewTicket.frame.origin.x+_imageViewTicket.frame.size.width+15, _imageViewTicket.frame.origin.y, SCREEN_WIDTH/2, 16)];
    [_labelFilmName setBackgroundColor:[UIColor clearColor]];
    [_labelFilmName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelFilmName setFont:MKFONT(16)];
    [_labelFilmName setTextAlignment:NSTextAlignmentLeft];
    [_viewTicketStatusBg addSubview:_labelFilmName];
    
    _labelVer = [[UILabel alloc ] initWithFrame:CGRectMake(_labelFilmName.frame.origin.x, _labelFilmName.frame.origin.y+_labelFilmName.frame.size.height+7, SCREEN_WIDTH/2, 9)];
    [_labelVer setBackgroundColor:[UIColor clearColor]];
    [_labelVer setTextColor:RGBA(51, 51, 51, 1)];
    [_labelVer setFont:MKFONT(9)];
    [_labelVer setTextAlignment:NSTextAlignmentLeft];
    [_viewTicketStatusBg addSubview:_labelVer];
    
    _labelTime = [[UILabel alloc ] initWithFrame:CGRectMake(_labelFilmName.frame.origin.x, _labelVer.frame.origin.y+_labelVer.frame.size.height+7, SCREEN_WIDTH/2, 12)];
    [_labelTime setBackgroundColor:[UIColor clearColor]];
    [_labelTime setTextColor:RGBA(51, 51, 51, 1)];
    [_labelTime setFont:MKFONT(12)];
    [_labelTime setTextAlignment:NSTextAlignmentLeft];
    [_viewTicketStatusBg addSubview:_labelTime];
    
    _labelSeat = [[UILabel alloc ] initWithFrame:CGRectMake(_labelFilmName.frame.origin.x, _labelTime.frame.origin.y+_labelTime.frame.size.height+7, SCREEN_WIDTH/2, 12)];
    [_labelSeat setBackgroundColor:[UIColor clearColor]];
    [_labelSeat setTextColor:RGBA(51, 51, 51, 1)];
    [_labelSeat setFont:MKFONT(12)];
    [_labelSeat setTextAlignment:NSTextAlignmentLeft];
    [_viewTicketStatusBg addSubview:_labelSeat];

    _labePrice = [[UILabel alloc ] initWithFrame:CGRectMake(_labelFilmName.frame.origin.x, _labelSeat.frame.origin.y+_labelSeat.frame.size.height+7, SCREEN_WIDTH/2, 12)];
    [_labePrice setBackgroundColor:[UIColor clearColor]];
    [_labePrice setTextColor:RGBA(51, 51, 51, 1)];
    [_labePrice setFont:MKFONT(12)];
    [_labePrice setTextAlignment:NSTextAlignmentLeft];
    [_viewTicketStatusBg addSubview:_labePrice];
   
    [self setTicketInfo:startPosY];
}

/*
 if ([status intValue] == 1 )
 {
 return @"待支付";
 }
 if ([status intValue] == 2 )
 {
 return @"待使用";
 }
 if ([status intValue] == 3 )
 {
 return @"退款中";
 }
 if ([status intValue] == 4 )
 {
 return @"已退款";
 }
 if ([status intValue] == 5 )
 {
 return @"已完成";
 }
 if ([status intValue] == 6 )
 {
 return @"出票中";
 }

 */

-(void) setTicketInfo:(int) startPosY
{
    //显示取票提示
    if ([_orderDetail.onlineTickets.subOrderShowStatus intValue] == 2 ||
        [_orderDetail.onlineTickets.subOrderShowStatus intValue] == 5 )
    {
        [_labelGetTicketTip setHidden:NO];
    }
    
    
    if ([_orderDetail.onlineTickets.subOrderShowStatus intValue] == 1 ||
        [_orderDetail.onlineTickets.subOrderShowStatus intValue] == 3 ||
        [_orderDetail.onlineTickets.subOrderShowStatus intValue] == 4 ||
        [_orderDetail.onlineTickets.subOrderShowStatus intValue] == 6)
    {
        [_labelTicketStatus setText:[Tool returnPayRefundStatus:_orderDetail.onlineTickets.subOrderShowStatus]];
    }
    else
    {
        _viewTicketStatusBg.frame = CGRectMake(posx, 10+startPosY, SCREEN_WIDTH-30, 436/2+25);
        [_labelTicketStatus setTextColor:RGBA(117, 112, 255, 1)];
        
        NSString *strTicketNO=@"" ;
        for (int i=0; i < [[Tool cutOrderAndTicket:_orderDetail.onlineTickets.ticketKey] count]; i++)
        {
            if ([[Tool cutOrderAndTicket:_orderDetail.onlineTickets.ticketKey] count] == 1)
            {
                strTicketNO = [NSString stringWithFormat:@"%@",[Tool cutOrderAndTicket:_orderDetail.onlineTickets.ticketKey][i]];
                _labelTicketStatus.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 67);
                _labelGetTicketTip.frame = CGRectMake(0, _labelTicketStatus.frame.origin.y+_labelTicketStatus.frame.size.height-10, SCREEN_WIDTH-30, 10);
                
                [_labelTicketStatus setText:strTicketNO];
                _imageLine.frame = CGRectMake(0, _labelGetTicketTip.frame.origin.y+_labelGetTicketTip.frame.size.height+15, SCREEN_WIDTH-30, 5);
            }
            else
            {
                strTicketNO = [NSString stringWithFormat:@"%@%@\n",strTicketNO,[Tool cutOrderAndTicket:_orderDetail.onlineTickets.ticketKey][i]];
                _labelTicketStatus.frame = CGRectMake(0, 8, SCREEN_WIDTH-30, 67-20);
                _labelGetTicketTip.frame = CGRectMake(0, _labelTicketStatus.frame.origin.y+_labelTicketStatus.frame.size.height+10, SCREEN_WIDTH-30, 10);
                
                [_labelTicketStatus setNumberOfLines:0];
                [_labelTicketStatus setLineBreakMode:NSLineBreakByWordWrapping];
                [_labelTicketStatus setText:strTicketNO];
                [Tool setLabelSpacing:_labelTicketStatus spacing:5 alignment:NSTextAlignmentCenter];
                _imageLine.frame = CGRectMake(0, _labelGetTicketTip.frame.origin.y+_labelGetTicketTip.frame.size.height+15, SCREEN_WIDTH-30, 5);
            }
        }
       
    }
    [_labelGetTicketTip setText:_orderDetail.onlineTickets.exchangeInfo];
    [_imageViewTicket sd_setImageWithURL:[NSURL URLWithString:_orderDetail.onlineTickets.movie.movieLogoUrl] placeholderImage:[UIImage imageNamed:@"img_homelogo_default.png"] ];
    [_labelVer setText:[NSString stringWithFormat:@"%@ %@",_orderDetail.onlineTickets.showtime.language,_orderDetail.onlineTickets.showtime.versionDesc] ];
    [_labelFilmName setText:_orderDetail.onlineTickets.movie.movieTitle];
    [_labelTime setText:[NSString stringWithFormat:@"%@ %@ %@ (%@)",
                         [Tool returnTime:_orderDetail.onlineTickets.showtime.startPlayTime format:@"MM月dd日"],
                         [Tool returnWeek:_orderDetail.onlineTickets.showtime.startPlayTime],
                         [Tool returnTime:_orderDetail.onlineTickets.showtime.startPlayTime format:@"HH:mm"],
                         _orderDetail.onlineTickets.hall.hallName]];
    
    //组合座位信息
    NSString *strSeat=@"" ;
    for (int i=0; i < [_orderDetail.onlineTickets.seateNames count]; i++)
    {
        strSeat = [NSString stringWithFormat:@"%@%@ ",strSeat,_orderDetail.onlineTickets.seateNames[i]];
    }
    [_labelSeat setText:strSeat];
    
    
    NSString *strPrice ;
    if( [[Tool PreserveTowDecimals:_orderDetail.onlineTickets.serviceFee] integerValue] <= 0 )
    {
        strPrice = [NSString stringWithFormat:@"￥%@(%ld张) ",
                     [Tool PreserveTowDecimals:_orderDetail.onlineTickets.totalPrice],
                     (unsigned long)[_orderDetail.onlineTickets.seateNames count] ];
        [_labePrice setText:strPrice];
    }
    else
    {
        strPrice= [NSString stringWithFormat:@"￥%@(%ld张) 含服务费%@/张",
           [Tool PreserveTowDecimals:_orderDetail.onlineTickets.totalPrice],
           (unsigned long)[_orderDetail.onlineTickets.seateNames count] ,
           [Tool PreserveTowDecimals:_orderDetail.onlineTickets.serviceFee]  ];
        
        [_labePrice setText:strPrice];
        NSUInteger joinCount =[[NSString stringWithFormat:@"￥%@(%ld张)",
                                [Tool PreserveTowDecimals:_orderDetail.totalPrice],
                                (unsigned long)[_orderDetail.onlineTickets.seateNames count] ] length];
        NSRange oneRange =NSMakeRange(0,joinCount);
        NSRange twoRange =NSMakeRange(joinCount,[strPrice length]-joinCount );
        NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:strPrice];
        [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:oneRange];
        [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(123, 122, 152, 1) range:twoRange];
        [strAtt addAttribute:NSFontAttributeName value:MKFONT(12) range:oneRange];
        [strAtt addAttribute:NSFontAttributeName value:MKFONT(10) range:twoRange];
        _labePrice.attributedText = strAtt;
    }
    
    _imageViewTicket.frame = CGRectMake(posx, _imageLine.frame.origin.y+_imageLine.frame.size.height+25, 135/2, 90);
    _labelFilmName.frame = CGRectMake(_imageViewTicket.frame.origin.x+_imageViewTicket.frame.size.width+15, _imageViewTicket.frame.origin.y, SCREEN_WIDTH/2, 16);
    _labelVer.frame = CGRectMake(_labelFilmName.frame.origin.x, _labelFilmName.frame.origin.y+_labelFilmName.frame.size.height+7, SCREEN_WIDTH/2, 9);
    _labelTime.frame = CGRectMake(_labelFilmName.frame.origin.x, _labelVer.frame.origin.y+_labelVer.frame.size.height+7, SCREEN_WIDTH/2, 12);
    _labelSeat.frame = CGRectMake(_labelFilmName.frame.origin.x, _labelTime.frame.origin.y+_labelTime.frame.size.height+7, SCREEN_WIDTH/2, 12);
    _labePrice.frame = CGRectMake(_labelFilmName.frame.origin.x, _labelSeat.frame.origin.y+_labelSeat.frame.size.height+7, SCREEN_WIDTH/2, 12);
}
#pragma mark 小卖信息
/*
 if ([status intValue] == 1 )
 {
 return @"待支付";
 }
 if ([status intValue] == 2 )
 {
 return @"待使用";
 }
 if ([status intValue] == 3 )
 {
 return @"退款中";
 }
 if ([status intValue] == 4 )
 {
 return @"已退款";
 }
 if ([status intValue] == 5 )
 {
 return @"已完成";
 }
 if ([status intValue] == 6 )
 {
 return @"出票中";
 }
 */
-(void)initGoodsController:(BOOL)_onlyGoods Y:(int) startPosY
{
    //如果不存在票订单 Y = 0
    int _viewGoodsPosY = startPosY+_viewTicketStatusBg.frame.origin.y+_viewTicketStatusBg.frame.size.height+10;
    if (_onlyGoods)
    {
        _viewGoodsPosY = 0;
    }
    
    //遍历小卖订单数量
    for (int i = 0; i < [_orderDetail.goodsOrderList count]; i++)
    {
        GoodsListCardPackModel *goodsModel = _orderDetail.goodsOrderList[i];
        
         _viewGoods= [[UIView alloc ] initWithFrame:CGRectZero ];//CGRectMake(posx, _viewGoodsPosY +(i*(392/2)) , SCREEN_WIDTH-30, 372/2 )
        [_viewGoods setBackgroundColor:[UIColor whiteColor]];
        [_viewGoods.layer setBorderColor:RGBA(0, 0, 0, 0.05).CGColor];
        [_viewGoods.layer setBorderWidth:0.5];
        [_viewGoods.layer setMasksToBounds:YES ];
        [_viewGoods.layer setCornerRadius:2];
        [_scrollView addSubview:_viewGoods];

        //提示信息
        _labelTip= [[UILabel alloc ] initWithFrame:CGRectMake(posx,0, SCREEN_WIDTH-60, 43)];
        [_labelTip setBackgroundColor:[UIColor clearColor]];
        [_labelTip setTextColor:RGBA(51, 51, 51, 1)];
        [_labelTip setFont:MKFONT(15)];
        [_labelTip setTextAlignment:NSTextAlignmentCenter];
        [_viewGoods addSubview:_labelTip];
        
        //领取日期
        _labelGetDate= [[UILabel alloc ] initWithFrame:CGRectZero];
        [_labelGetDate setBackgroundColor:[UIColor clearColor]];
        [_labelGetDate setTextColor:RGBA(123, 122, 152, 1)];
        [_labelGetDate setFont:MKFONT(11)];
        [_labelGetDate setTextAlignment:NSTextAlignmentCenter];
        [_viewGoods addSubview:_labelGetDate];

        //1:待支付 3:退款中 4:已退款 6:出票中
        if ([goodsModel.subOrderShowStatus intValue] == 1 ||
            [goodsModel.subOrderShowStatus intValue] == 3 ||
            [goodsModel.subOrderShowStatus intValue] == 4 ||
            [goodsModel.subOrderShowStatus intValue] == 6)
        {
            _viewGoods.frame = CGRectMake(posx, _viewGoodsPosY +(i*(392/2)) , SCREEN_WIDTH-30, 372/2 );
            [_labelTip setText:[Tool returnPayRefundStatus:goodsModel.subOrderShowStatus]];
            _imageViewCutLine  = [[UIImageView alloc ] initWithFrame:CGRectMake(posx,_labelTip.frame.origin.y+_labelTip.frame.size.height, SCREEN_WIDTH-60, 0.5)];
        }
        if([goodsModel.subOrderShowStatus intValue] == 2 ||
           ( [goodsModel.subOrderShowStatus intValue] == 5 && [goodsModel.useStatus intValue] == 0 ))
        {//2:待使用  5:已完成
            _viewGoods.frame = CGRectMake(posx, _viewGoodsPosY +(i*(480/2) ) , SCREEN_WIDTH-30, 460/2 );
            
            _btnGet = [[UIButton alloc ] initWithFrame:CGRectMake(posx, 15, SCREEN_WIDTH-60, 40)];
            [_btnGet setBackgroundColor:[UIColor blackColor] ];
            [_btnGet setTitle:@"立即领取" forState:UIControlStateNormal];
            [_btnGet.titleLabel setFont:MKFONT(15)];
            [_btnGet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_btnGet.layer setCornerRadius:20];
            [_btnGet.layer setMasksToBounds:YES];
            _btnGet.tag = i;
            [_btnGet addTarget:self action:@selector(onButtonGetGoods:) forControlEvents:UIControlEventTouchUpInside];
            [_viewGoods addSubview:_btnGet];
            
            _labelTip.frame =  CGRectMake(posx,_btnGet.frame.origin.y+_btnGet.frame.size.height+10, SCREEN_WIDTH-60, 11);
            [_labelTip setFont:MKFONT(11)];
            [_labelTip setTextColor:RGBA(123, 122, 152, 1)];
            [_labelTip setText:[NSString stringWithFormat:@"%@",goodsModel.exchangeDesc]];
            
            _imageViewCutLine  = [[UIImageView alloc ] initWithFrame:CGRectMake(posx,_labelTip.frame.origin.y+_labelTip.frame.size.height+15, SCREEN_WIDTH-60, 0.5)];
            
        }//0为未兑换,1为已兑换,2为已过期
        if([goodsModel.subOrderShowStatus intValue] == 5 && [goodsModel.useStatus intValue] == 1 )
        {
           _viewGoods.frame = CGRectMake(posx, _viewGoodsPosY +(i*(480/2) ) , SCREEN_WIDTH-30, 420/2 );
            [_labelTip setText:@"已领取"];
            //领取时间
            _labelGetDate.frame = CGRectMake(0,_labelTip.frame.origin.y+_labelTip.frame.size.height-5 , SCREEN_WIDTH-30, 11);
            _labelGetDate.text = [NSString stringWithFormat:@"%@",[Tool returnTime:goodsModel.exchangeTime format:@"yyyy年MM月dd日 HH:mm"]];
            
            _imageViewCutLine  = [[UIImageView alloc ] initWithFrame:CGRectMake(posx,_labelGetDate.frame.origin.y+_labelGetDate.frame.size.height+15, SCREEN_WIDTH-60, 0.5)];
        }
        if([goodsModel.subOrderShowStatus intValue] == 5 && [goodsModel.useStatus intValue] == 2 )
        {
            _viewGoods.frame = CGRectMake(posx, _viewGoodsPosY +(i*(480/2) ) , SCREEN_WIDTH-30, 380/2 );
            _labelTip.frame = CGRectMake(0,15, SCREEN_WIDTH-30, 12);
            [_labelTip setText:@"已完成"];
            
            _imageViewCutLine  = [[UIImageView alloc ] initWithFrame:CGRectMake(posx,_labelTip.frame.origin.y+_labelTip.frame.size.height+15, SCREEN_WIDTH-60, 0.5)];
        }
        
        [_imageViewCutLine setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
        [_viewGoods addSubview:_imageViewCutLine];
        
        _imageViewGoods = [[UIImageView alloc ] initWithFrame:CGRectMake(posx,_imageViewCutLine.frame.origin.y+_imageViewCutLine.frame.size.height+15 , 90, 75)];
        [_viewGoods addSubview:_imageViewGoods];
        [_imageViewGoods sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsLogoUrl] placeholderImage:[UIImage imageNamed:@"image_saleList_default.png"]];
        //小卖名称
        _labelGoodsName = [[UILabel alloc ] initWithFrame:CGRectMake( _imageViewGoods.frame.origin.x+ _imageViewGoods.frame.size.width+15,  _imageViewGoods.frame.origin.y, SCREEN_WIDTH/2, 16)];
        [_labelGoodsName setBackgroundColor:[UIColor clearColor]];
        [_labelGoodsName setText:goodsModel.goodsName];
        [_labelGoodsName setTextColor:RGBA(51, 51, 51, 1)];
        [_labelGoodsName setFont:MKFONT(15)];
        [_labelGoodsName setTextAlignment:NSTextAlignmentLeft];
        [_viewGoods addSubview:_labelGoodsName];
//        小卖描述
        _labelGoodsDesc = [[UILabel alloc ] initWithFrame:CGRectMake(_labelGoodsName.frame.origin.x, _labelGoodsName.frame.origin.y+_labelGoodsName.frame.size.height+9.5, SCREEN_WIDTH/2, 9)];
        [_labelGoodsDesc setBackgroundColor:[UIColor clearColor]];
        [_labelGoodsDesc setText:goodsModel.goodsDesc];
        [_labelGoodsDesc setTextColor:RGBA(51, 51, 51, 1)];
        [_labelGoodsDesc setFont:MKFONT(12)];
        [_labelGoodsDesc setTextAlignment:NSTextAlignmentLeft];
        [_viewGoods addSubview:_labelGoodsDesc];
//        小卖价格
        _labelGoodsPrice = [[UILabel alloc ] initWithFrame:CGRectMake(_labelGoodsName.frame.origin.x, _labelGoodsDesc.frame.origin.y+_labelGoodsDesc.frame.size.height+57/2, SCREEN_WIDTH/2, 12)];
        [_labelGoodsPrice setBackgroundColor:[UIColor clearColor]];
        [_labelGoodsPrice setText:[NSString stringWithFormat:@"￥%@(%@%@)",[Tool PreserveTowDecimals:goodsModel.totalPrice],goodsModel.sellCount,goodsModel.unit ] ];
        [_labelGoodsPrice setTextColor:RGBA(51, 51, 51, 1)];
        [_labelGoodsPrice setFont:MKFONT(12)];
        [_labelGoodsPrice setTextAlignment:NSTextAlignmentLeft];
        [_viewGoods addSubview:_labelGoodsPrice];
        
        _imageViewCutLine1 = [[UIImageView alloc ] initWithFrame:CGRectMake(posx,_labelGoodsPrice.frame.origin.y+_labelGoodsPrice.frame.size.height+15, SCREEN_WIDTH-60, 0.5)];
        [_imageViewCutLine1 setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
        [_viewGoods addSubview:_imageViewCutLine1];
//        小卖有效期
        _labelValidityDate= [[UILabel alloc ] initWithFrame:CGRectMake(posx, _imageViewCutLine1.frame.origin.y+_imageViewCutLine1.frame.size.height+12, SCREEN_WIDTH/2, 10)];
        [_labelValidityDate setBackgroundColor:[UIColor clearColor]];
        [_labelValidityDate setText:[NSString stringWithFormat:@"有效期至：%@",[Tool returnTime:goodsModel.validEndTime format:@"yyyy年MM月dd日"]]];
        [_labelValidityDate setTextColor:RGBA(123, 122, 152, 1)];
        [_labelValidityDate setFont:MKFONT(10)];
        [_labelValidityDate setTextAlignment:NSTextAlignmentLeft];
        [_viewGoods addSubview:_labelValidityDate];
    }
}

#pragma mark 会员卡
-(void)initMemberCardController:(int) startPosY
{
    _viewGoods= [[UIView alloc ] initWithFrame:CGRectMake(posx, startPosY+10 , SCREEN_WIDTH-30, 275/2)];
    [_viewGoods setBackgroundColor:[UIColor whiteColor]];
    [_viewGoods.layer setBorderColor:RGBA(0, 0, 0, 0.05).CGColor];
    [_viewGoods.layer setBorderWidth:0.5];
    [_viewGoods.layer setMasksToBounds:YES ];
    [_viewGoods.layer setCornerRadius:2];
    [_scrollView addSubview:_viewGoods];
    
    _imageViewCard= [[UIImageView alloc ] initWithFrame:CGRectMake(posx, 35, 54/2, 54/2)];
    [_imageViewCard setImage:[UIImage imageNamed:@"image_ticketType.png"] ];
    [_viewGoods addSubview:_imageViewCard];
    
    _labelCardName = [[UILabel alloc ] initWithFrame:CGRectMake(_imageViewCard.frame.origin.x+_imageViewCard.frame.size.width+15,30, SCREEN_WIDTH/2, 15)];
    [_labelCardName setBackgroundColor:[UIColor clearColor]];
//    [_labelCardName setText:@"会员卡"];
    [_labelCardName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelCardName setFont:MKBOLDFONT(15)];
    [_labelCardName setTextAlignment:NSTextAlignmentLeft];
    [_viewGoods addSubview:_labelCardName];
    
    _labelCardCinemaName= [[UILabel alloc ] initWithFrame:CGRectMake(_labelCardName.frame.origin.x, _labelCardName.frame.origin.y+_labelCardName.frame.size.height+10, SCREEN_WIDTH/2, 12)];
    [_labelCardCinemaName setBackgroundColor:[UIColor clearColor]];
//    [_labelCardCinemaName setText:@"超级电影院"];
    [_labelCardCinemaName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelCardCinemaName setFont:MKFONT(12)];
    [_labelCardCinemaName setTextAlignment:NSTextAlignmentLeft];
    [_viewGoods addSubview:_labelCardCinemaName];
    
    _labelCardValidityTime= [[UILabel alloc ] initWithFrame:CGRectMake(_labelCardName.frame.origin.x, _labelCardCinemaName.frame.origin.y+_labelCardCinemaName.frame.size.height+15, SCREEN_WIDTH/2, 10)];
    [_labelCardValidityTime setBackgroundColor:[UIColor clearColor]];
//    [_labelCardValidityTime setText:@"有效期：2月"];
    [_labelCardValidityTime setTextColor:RGBA(123, 122, 152, 1)];
    [_labelCardValidityTime setFont:MKFONT(10)];
    [_labelCardValidityTime setTextAlignment:NSTextAlignmentLeft];
    [_viewGoods addSubview:_labelCardValidityTime];
    
    _imageViewCutLine = [[UIImageView alloc ] initWithFrame:CGRectMake(posx,_labelCardValidityTime.frame.origin.y+_labelCardValidityTime.frame.size.height+10, SCREEN_WIDTH-60, 0.5)];
   [_imageViewCutLine setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
    [_viewGoods addSubview:_imageViewCutLine];
    
    _labelCardValidityDate= [[UILabel alloc ] initWithFrame:CGRectMake(posx, _imageViewCutLine.frame.origin.y+_imageViewCutLine.frame.size.height+10, SCREEN_WIDTH/2, 15)];
    [_labelCardValidityDate setBackgroundColor:[UIColor clearColor]];
//    [_labelCardValidityDate setText:@"有效期至：1011年2月"];
    [_labelCardValidityDate setTextColor:RGBA(123, 122, 152, 1)];
    [_labelCardValidityDate setFont:MKFONT(10)];
    [_labelCardValidityDate setTextAlignment:NSTextAlignmentLeft];
    [_viewGoods addSubview:_labelCardValidityDate];
    
    _labelCardSum= [[UILabel alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, _imageViewCutLine.frame.origin.y+_imageViewCutLine.frame.size.height+10, SCREEN_WIDTH/2, 15)];
    [_labelCardSum setBackgroundColor:[UIColor clearColor]];
//    [_labelCardSum setText:@"￥66"];
//    [_labelCardSum setTextColor:RGBA(255, 0, 0, 1)];
    [_labelCardSum setFont:MKFONT(15)];
    [_labelCardSum setTextAlignment:NSTextAlignmentRight];
    [_viewGoods addSubview:_labelCardSum];
}

#pragma mark 设置会员卡信息
-(void)setMemberCardInfo
{
    [_labelCardName setText:_orderDetail.cardOrder.cardName];
    [_labelCardCinemaName setText:_orderDetail.cinema.cinemaName];
    [_labelCardValidityTime setText:[NSString stringWithFormat:@"有效期：%@天",_orderDetail.cardOrder.activeTime] ];
    [_labelCardValidityDate setText:[NSString stringWithFormat:@"有效期至：%@",[Tool returnTime:_orderDetail.cardOrder.validEndTime format:@"yyyy年MM月dd日"]] ];
    
    NSString *str = [NSString stringWithFormat:@"小计：￥%@",[Tool PreserveTowDecimals:_orderDetail.cardOrder.totalPrice] ];
    NSUInteger joinCount =[[NSString stringWithFormat:@"%@", [Tool PreserveTowDecimals:_orderDetail.cardOrder.totalPrice] ] length];
    NSRange oneRange =NSMakeRange(0,3);
    NSRange twoRange =NSMakeRange(3,joinCount+1);
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(123, 122, 152, 1) range:oneRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:twoRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(10) range:oneRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(14) range:twoRange];
    _labelCardSum.attributedText = strAtt;
    
}


#pragma mark 优惠后支付信息
-(void)initFavorableSumController:(UIView*) viewTop
{
    _viewSumBg= [[UIView alloc ] initWithFrame:CGRectMake(posx, viewTop.frame.origin.y+viewTop.frame.size.height+10, SCREEN_WIDTH-30, 224/2)];
    [_viewSumBg setBackgroundColor:[UIColor whiteColor]];
    [_viewSumBg.layer setBorderColor:RGBA(0, 0, 0, 0.05).CGColor];
    [_viewSumBg.layer setBorderWidth:0.5];
    [_viewSumBg.layer setMasksToBounds:YES ];
    [_viewSumBg.layer setCornerRadius:2];
    [_scrollView addSubview:_viewSumBg];
    
    _labelSum = [[UILabel alloc ] initWithFrame:CGRectMake(posx, 15, SCREEN_WIDTH/2, 12)];
    [_labelSum setBackgroundColor:[UIColor clearColor]];
    [_labelSum setText:@"实付金额："];
    [_labelSum setTextColor:RGBA(123, 122, 152, 1)];
    [_labelSum setFont:MKFONT(12)];
    [_labelSum setTextAlignment:NSTextAlignmentLeft];
    [_viewSumBg addSubview:_labelSum];
    
    //实付金额
    _labelSumMoeny = [[UILabel alloc ] initWithFrame:CGRectMake(posx,_labelSum.frame.origin.y, SCREEN_WIDTH-60, 17)];
    [_labelSumMoeny setBackgroundColor:[UIColor clearColor]];
    [_labelSumMoeny setText:[NSString stringWithFormat:@"￥%@",[Tool PreserveTowDecimals:_orderDetail.totalPrice]]];
    [_labelSumMoeny setTextColor:[UIColor redColor]];
    [_labelSumMoeny setFont:MKFONT(17)];
    [_labelSumMoeny setTextAlignment:NSTextAlignmentRight];
    [_viewSumBg addSubview:_labelSumMoeny];
    
    _imageViewCutLine = [[UIImageView alloc ] initWithFrame:CGRectMake(0,_labelSum.frame.origin.y+_labelSum.frame.size.height+16, _viewSumBg.frame.size.width, 0.5)];
//    [_imageViewCutLine setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
    [_imageViewCutLine setBackgroundColor:RGBA(242, 242, 242, 1)];
    [_viewSumBg addSubview:_imageViewCutLine];
    
    _labelOtherFavorable = [[UILabel alloc ] initWithFrame:CGRectMake(posx, _labelSum.frame.origin.y+_labelSum.frame.size.height+30, SCREEN_WIDTH/2, 134/2)];
    [_labelOtherFavorable setBackgroundColor:[UIColor clearColor]];
    [_labelOtherFavorable setTextColor:RGBA(123, 122, 152, 1)];
    [_labelOtherFavorable setFont:MKFONT(12)];
    [_labelOtherFavorable setTextAlignment:NSTextAlignmentLeft];
    [_labelOtherFavorable setText:@"合计金额：\n抵扣金额："];
    [_labelOtherFavorable setLineBreakMode:NSLineBreakByWordWrapping];
    [_labelOtherFavorable setNumberOfLines:0];
    [_viewSumBg addSubview:_labelOtherFavorable];
    [Tool setLabelSpacing:_labelOtherFavorable spacing:15 alignment:NSTextAlignmentLeft];
    
    _labelOtherFavorablemoney = [[UILabel alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, _labelSum.frame.origin.y+_labelSum.frame.size.height+15, SCREEN_WIDTH/2, 134/2)];
    [_labelOtherFavorablemoney setBackgroundColor:[UIColor clearColor]];
    [_labelOtherFavorablemoney setTextColor:RGBA(51, 51, 51, 1)];
    [_labelOtherFavorablemoney setFont:MKFONT(15)];
    [_labelOtherFavorablemoney setTextAlignment:NSTextAlignmentRight];
    [_labelOtherFavorablemoney setNumberOfLines:0];
    [_labelOtherFavorablemoney setLineBreakMode:NSLineBreakByWordWrapping];
    //抵扣大于0
    if([_orderDetail.discountPrice intValue] > 0 )
    {
        [_labelOtherFavorablemoney setText:[NSString stringWithFormat:@"￥%@\n-￥%@",
                                            [Tool PreserveTowDecimals:_orderDetail.notDiscountTotalPrice],
                                            [Tool PreserveTowDecimals:_orderDetail.discountPrice]] ];
    }
    else
    {
        [_labelOtherFavorablemoney setText:[NSString stringWithFormat:@"￥%@\n￥%@",
                                            [Tool PreserveTowDecimals:_orderDetail.notDiscountTotalPrice],
                                            [Tool PreserveTowDecimals:_orderDetail.discountPrice]] ];
    }
    [Tool setLabelSpacing:_labelOtherFavorablemoney spacing:15 alignment:NSTextAlignmentRight];
    
    [_viewSumBg addSubview:_labelOtherFavorablemoney];
   
}


#pragma mark 影院信息和工作时间电话
-(void)initCinemaAndTelController
{
    _viewCinemaAddrsssBg= [[UIView alloc ] initWithFrame:CGRectMake(posx, _viewSumBg.frame.origin.y+_viewSumBg.frame.size.height+10, SCREEN_WIDTH-30, 260/2)];
    [_viewCinemaAddrsssBg setBackgroundColor:[UIColor whiteColor]];
    [_viewCinemaAddrsssBg.layer setBorderColor:RGBA(0, 0, 0, 0.05).CGColor];
    [_viewCinemaAddrsssBg.layer setBorderWidth:0.5];
    [_viewCinemaAddrsssBg.layer setMasksToBounds:YES ];
    [_viewCinemaAddrsssBg.layer setCornerRadius:2];
    [_scrollView addSubview:_viewCinemaAddrsssBg];
    
    _labelCinemaName = [[UILabel alloc ] initWithFrame:CGRectMake(posx, 15, SCREEN_WIDTH-165, 15)];
    [_labelCinemaName setBackgroundColor:[UIColor clearColor]];
    [_labelCinemaName setText:_orderDetail.cinema.cinemaName];
    [_labelCinemaName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelCinemaName setFont:MKFONT(15)];
    [_labelCinemaName setTextAlignment:NSTextAlignmentLeft];
    [_labelCinemaName setNumberOfLines:0];
    [_labelCinemaName setLineBreakMode:NSLineBreakByCharWrapping];
    [_labelCinemaName sizeToFit];
    [_viewCinemaAddrsssBg addSubview:_labelCinemaName];
  
    //影院地址
    _labelCinemaAddress = [[UILabel alloc ] initWithFrame:CGRectMake(posx,_labelCinemaName.frame.origin.y+_labelCinemaName.frame.size.height+10, SCREEN_WIDTH-165, 12)];
    [_labelCinemaAddress setBackgroundColor:[UIColor clearColor]];
    [_labelCinemaAddress setText:_orderDetail.cinema.cinemaAddress];
    [_labelCinemaAddress setTextColor:RGBA(123, 122, 152, 1)];
    [_labelCinemaAddress setFont:MKFONT(12)];
    [_labelCinemaAddress setTextAlignment:NSTextAlignmentLeft];
    [_labelCinemaAddress setNumberOfLines:0];
    [_labelCinemaAddress setLineBreakMode:NSLineBreakByCharWrapping];
    [_labelCinemaAddress sizeToFit];
    [_viewCinemaAddrsssBg addSubview:_labelCinemaAddress];
    
    _imageViewCutLine = [[UIImageView alloc ] initWithFrame:CGRectMake(posx,_labelCinemaAddress.frame.origin.y+_labelCinemaAddress.frame.size.height+15, SCREEN_WIDTH-60, 0.5)];
    [_imageViewCutLine setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
    [_viewCinemaAddrsssBg addSubview:_imageViewCutLine];
    
    _labelTel = [[UILabel alloc ] initWithFrame:CGRectMake(posx,_imageViewCutLine.frame.origin.y+_imageViewCutLine.frame.size.height+15, SCREEN_WIDTH/1.7, 15)];
    [_labelTel setBackgroundColor:[UIColor clearColor]];
    [_labelTel setText:[Config getConfigInfo:@"movikrPhoneNumber"] ];
    [_labelTel setTextColor:RGBA(51, 51, 51, 1)];
    [_labelTel setFont:MKFONT(15)];
    [_labelTel setTextAlignment:NSTextAlignmentLeft];
    [_viewCinemaAddrsssBg addSubview:_labelTel];
    
    _labelWorkTime = [[UILabel alloc ] initWithFrame:CGRectMake(posx,_labelTel.frame.origin.y+_labelTel.frame.size.height+10, SCREEN_WIDTH-60, 12)];
    [_labelWorkTime setBackgroundColor:[UIColor clearColor]];
    [_labelWorkTime setText: [NSString stringWithFormat:@"客服工作时间 %@",[Config getConfigInfo:@"movikrPhoneNumberDesc"] ] ];
    [_labelWorkTime setTextColor:RGBA(123, 122, 152, 1)];
    [_labelWorkTime setFont:MKFONT(12)];
    [_labelWorkTime setTextAlignment:NSTextAlignmentLeft];
    [_viewCinemaAddrsssBg addSubview:_labelWorkTime];
    
    UIImageView *imageViewTel = [[UIImageView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-63-50/2, _imageViewCutLine.frame.origin.y +46/2, 50/2, 50/2)];
    [imageViewTel setImage:[UIImage imageNamed:@"btn_orderTel.png"]];
    [_viewCinemaAddrsssBg addSubview:imageViewTel];
    imageViewTel.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onButtonTel)];
    [imageViewTel addGestureRecognizer:tapTel];
    
   CGFloat cinemaNameHeight= [Tool CalcString:_orderDetail.cinema.cinemaName fontSize:MKFONT(15) andWidth:SCREEN_WIDTH-165].height;
   CGFloat cinemaAddressHeight=  [Tool CalcString:_orderDetail.cinema.cinemaAddress fontSize:MKFONT(12) andWidth:SCREEN_WIDTH-165].height;
    
    _viewCinemaAddrsssBg.frame =  CGRectMake(posx, _viewSumBg.frame.origin.y+_viewSumBg.frame.size.height+10, SCREEN_WIDTH-30, 260/2+cinemaNameHeight+cinemaAddressHeight-20);
    
//    NSLog(@"%f,%f",_viewCinemaAddrsssBg.frame.origin.y,_imageViewCutLine.frame.origin.y);
    
    UIImageView *imageViewLocation = [[UIImageView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-63-50/2,_imageViewCutLine.frame.origin.y/2-(50/4), 50/2, 50/2)];
    [imageViewLocation setImage:[UIImage imageNamed:@"btn_orderLocation.png"]];
    [_viewCinemaAddrsssBg addSubview:imageViewLocation];
    imageViewLocation.userInteractionEnabled=YES;
    UITapGestureRecognizer *tabMap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onButtonMap)];
    [imageViewLocation addGestureRecognizer:tabMap];

}
#pragma mark 拨打电话
-(void)onButtonTel
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"4000681681"]];
    if ( !_phoneCallWebView )
    {
        _phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

#pragma mark 领取小卖
-(void)onButtonGetGoods:(UIButton *)btn
{
    _nGoodsIndex = btn.tag;
    _goodsModel = _orderDetail.goodsOrderList[_nGoodsIndex];

    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"是否核销？" message:@"" sureBtn:@"确认" cancleBtn:@"取消"];
    alertView.resultIndex = ^(NSInteger index)
    {
        NSLog(@"%ld",(long)index);
        if (index == 2)
        {
            //兑换方式 1:需要核销，0:不需要核销
            if([_goodsModel.exchangeType intValue] == 1)
            {
                [self makeContentView:_goodsModel.exchangeDesc];
                [_textField becomeFirstResponder];
            }
            else
            {
                GoodsListCardPackModel *goodsModel = [[GoodsListCardPackModel alloc ] init];
                if (_nGoodsIndex <[_orderDetail.goodsOrderList count] )
                {
                    goodsModel = _orderDetail.goodsOrderList[_nGoodsIndex];
                }
                [self exchangeGoods:goodsModel.goodsOrderId exCode:@""];
            }
        }
    };
    [alertView showMKPAlertView];
}

#pragma mark - 领取小卖
-(void)makeContentView:(NSString*)exchangeDesc
{
    //弹起的View
    UIView *contentSetView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height -213-128, self.view.frame.size.width, 128)];
    contentSetView.backgroundColor = RGBA(255, 255, 255, 1);
    
    _textField = [[UITextField alloc ] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _textField.delegate = self;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [_textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.backgroundColor = [UIColor redColor];
    [contentSetView addSubview:_textField];
    
    //四个输入框线
    UILabel *_labelTopLine= [[UILabel alloc ] initWithFrame:CGRectMake((SCREEN_WIDTH-40*4)/2, 30, 40*4, 1)];
    [_labelTopLine setBackgroundColor:RGBA(204, 204, 204, 1)];
    [contentSetView addSubview:_labelTopLine];
    
    UILabel *_labelDownLine= [[UILabel alloc ] initWithFrame:CGRectMake((SCREEN_WIDTH-40*4)/2, 70, 40*4, 1)];
    [_labelDownLine setBackgroundColor:RGBA(204, 204, 204, 1)];
    [contentSetView addSubview:_labelDownLine];
    
    NSMutableArray *_arrayVerticalLine = [[NSMutableArray alloc ] initWithCapacity:0];
    for(int i = 0 ;i < 5 ;i++)
    {
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-40*4)/2 +40*i,30,1, 40)];
        lineImageView.backgroundColor = RGBA(204, 204, 204, 1);
        [contentSetView addSubview:lineImageView];
        [_arrayVerticalLine addObject:lineImageView];
    }
    
    //输入框
    for (int i = 0; i < 5-1; i++)
    {
        _textFieldCode[i] = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-40*4)/2 +40*i,30,40, 40)];
        [_textFieldCode[i] setTextAlignment:NSTextAlignmentCenter];
        [_textFieldCode[i] setFont:MKFONT(20)];
        [_textFieldCode[i] setBackgroundColor:[UIColor clearColor]];
        [contentSetView addSubview:_textFieldCode[i]];
    }
    
    //核销描述
    UILabel *labelDescribe = [[UILabel alloc] initWithFrame:CGRectMake(0, _labelDownLine.frame.origin.y+_labelDownLine.frame.size.height+15, SCREEN_WIDTH, 14)];
    [labelDescribe setBackgroundColor:[UIColor clearColor]];
    [labelDescribe setFont:MKFONT(14)];
    [labelDescribe setTextColor:RGBA(204, 204, 204, 1)];
    [labelDescribe setTextAlignment:NSTextAlignmentCenter];
    [labelDescribe setText:exchangeDesc];
    [contentSetView addSubview:labelDescribe];
    
    [[ExAlertView sharedAlertView] setShowContentView:contentSetView];
}

-(void)textChange:(UITextField *)textField
{
//    NSLog(@"%@   %ld",textField.text,textField.text.length);
    if ([_textField.text length] >= 4)
    {
        GoodsListCardPackModel *goodsModel = [[GoodsListCardPackModel alloc ] init];
        if (_nGoodsIndex <[_orderDetail.goodsOrderList count] )
        {
            goodsModel = _orderDetail.goodsOrderList[_nGoodsIndex];
            [self exchangeGoods:goodsModel.goodsOrderId exCode:textField.text];
        }
    }
}

#pragma mark 兑换小卖
-(void) exchangeGoods:(NSString*) goodsId exCode:(NSString *)code
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"正在核销" withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    [ServicesGoods exchangeGoods:goodsId code:code model:^(RequestResult *model)
     {
         [[ExAlertView sharedAlertView]dismissAlertView];
         [_textField resignFirstResponder];
         
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         //领取成功刷新UI
         [weakSelf refreshTicketAndGoods];
         [Tool showSuccessTip:@"核销成功" time:1];
         
     } failure:^(NSError *error) {
         
         [[ExAlertView sharedAlertView]dismissAlertView];
         [_textField resignFirstResponder];
         [weakSelf resetCodeText];
         [Tool showWarningTip:error.domain time:1];
     }];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    }
    else if(string.length == 0)
    {
        [self setDeleteCodeText:textField.text.length text:string];
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= 4)
    {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }
    else
    {
        [self setSetCodeText:textField.text.length text:string];
        return YES;
    }
}

- (void)setSetCodeText:(NSInteger)count text:(NSString *)textNum
{
    textNum = @"●";
    [_textFieldCode[count] setText:textNum ];
}

- (void)setDeleteCodeText:(NSInteger)count text:(NSString *)textNum
{
    [_textFieldCode[count-1] setText:textNum];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}

#pragma mark 清空核销码
-(void) resetCodeText
{
    _textField.text = @"";
    for (int i = 0; i < 4; i++)
    {
        _textFieldCode[i].text = @"";
    }
}

#pragma mark 刷新小卖和票
-(void)refreshTicketAndGoods
{
    [_btnGet setBackgroundColor:[UIColor clearColor] ];
    [_btnGet setTitle:@"已领取" forState:UIControlStateNormal];
    [_btnGet setTitleColor:RGBA(51, 51, 51, 0.5) forState:UIControlStateNormal];
    [_btnGet setEnabled:NO];
    _labelGetDate.text = [NSString stringWithFormat:@"%@",[Tool getSystemDate:@"yyyy年MM月dd日 HH:mm" ]];
}

#pragma mark 判断是否安装地图，目前只判断百度、高德地图
- (void)isInstallMap
{
    [self._arrayMap removeAllObjects];
    NSDictionary *dic = @{@"name":@"使用系统自带地图导航",
                          @"url":@""};
    [self._arrayMap addObject:dic];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
    {
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=我的位置&destination=latlng:%f,%f|name:%@&mode=driving&src=超影科技|超级电影院",
                               _orderDetail.cinema.dlatitude.floatValue,
                               _orderDetail.cinema.dlongitude.floatValue,
                               _orderDetail.cinema.address];
        
        NSDictionary *dic = @{@"name": @"使用百度地图导航",
                              @"url": urlString};
        [self._arrayMap addObject:dic];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        //高德规划路线,传终点坐标
        NSString *urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=超级电影院&sid=BGVIS1&slat=&slon=&sname=&did=BGVIS2&dlat=%f&dlon=%f&dname=%@B&dev=0&m=0&t=0",
                               _orderDetail.cinema.latitude.floatValue,
                               _orderDetail.cinema.longitude.floatValue,
                               _orderDetail.cinema.address];
        
        NSDictionary *dic = @{@"name": @"使用高德地图导航",
                              @"url": urlString};
        [self._arrayMap addObject:dic];
    }
}

#pragma mark 跳转到地图
-(void)onButtonMap
{
    [self isInstallMap];
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:self._arrayMap];
    [sheet show];
}
#pragma mark FDActionSheet Delegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    float lat = _orderDetail.cinema.latitude.floatValue;
    float lon = _orderDetail.cinema.longitude.floatValue;
    
    if(buttonIndex == 0)
    {
        CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake(lat, lon);
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil]];
        toLocation.name = _orderDetail.cinema.address;
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }
    else
    {
        NSDictionary *obj = self._arrayMap[buttonIndex];
        NSString *urlStr = [obj objectForKey:@"url"];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *mapUrl = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication]openURL:mapUrl];
    }
    
}

#pragma mark 发红包
- (void)onButtonShare
{
    if (_shareRedPacketView)
    {
        [_shareRedPacketView removeFromSuperview];
        _shareRedPacketView = nil;
    }
   
    _shareRedPacketView = [[ShareRedPacketView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _shareRedPacketView.delegate = self;
    NSInteger num = [self._orderDetialModel.orderId integerValue];
    _shareRedPacketView._orderId = @(num);
    [_shareRedPacketView drawView];
    [_shareRedPacketView bounceViews];
    [self.view addSubview:_shareRedPacketView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
}

@end
