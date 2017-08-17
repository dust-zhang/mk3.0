//
//  ChooseSeatViewController.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/8.
//
//

#import "ChooseSeatViewController.h"

static const NSUInteger kDrawSeatsView = 100;

@interface ChooseSeatViewController ()

@end

@implementation ChooseSeatViewController

#define seatsCanChooselimitCount    4

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_loginState == LoginStateNot && [Config getLoginState])
    {
        _loginState = LoginStateYes;
//        //从登录页登录成功跳转回来改价格
//        [self performSelector:@selector(loginSuccess) withObject:nil afterDelay:1.0];
    }
}

-(void)loginSuccess
{
    __weak ChooseSeatViewController *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesShowTime getMovieShowTimeDetail:[self.showTimesModel.showtimeId integerValue] model:^(ShowTimeDetailModel *model) {
        [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
        STModel = model;
        modelShowTime = model.showtime;
        [weakself getSeatPrice];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:mainViewbtn26];
    self._labelTitle.frame = CGRectMake(80, 30, SCREEN_WIDTH-160, 17);
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(248, 248, 252, 1);
    _loginState = [Config getLoginState] ? LoginStateNormal : LoginStateNot;
    self._labelLine.hidden = YES;
    arrSeats = [[NSMutableArray alloc]init];
    self.selectedSeats = [[NSMutableArray alloc]init];
    [self initShowTimeView];
    [self initNavigation];
    [self initHeader];
    [self initFooter];
    [self loadSeatData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshSeat) name:NOTIFITION_REFRESHSEATS object:nil];
}

-(void)refreshSeat
{
    [arrSeats removeAllObjects];
    [self.selectedSeats removeAllObjects];
    [self refreshSelectedSeatName];
    [self loadSeatData];
}

-(void) loadSeatData
{
    __weak ChooseSeatViewController *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载座位信息" withBlur:NO allowTap:NO];
    [ServicesShowTime getMovieShowTimeDetail:[self.showTimesModel.showtimeId integerValue] model:^(ShowTimeDetailModel *model)
     {
         [FVCustomAlertView hideAlertFromView:weakself.view fading:NO];
//         if (model.orderId.length > 0)
//         {
//             [self loadOrderDetail:model.orderId];
//         }
         modelCinema = model.cinema;
         modelHall = model.hall;
         modelMovieDetail = model.movie;
         modelShowTime = model.showtime;
       
         if (modelShowTime.activity.activityContent.length>0)
         {
             //有活动内容
             _imageScreenExplain.hidden = NO;
             _labelScreenExplain.text = modelShowTime.activity.activityContent;
             [_labelScreenExplain sizeToFit];
             _labelScreenExplain.frame = CGRectMake(0, (33/2-10)/2, _labelScreenExplain.frame.size.width, 10);
             screenCenter.frame = CGRectMake(screenCenter.frame.origin.x, 0, _labelScreenExplain.frame.size.width, 33/2);
             screenRight.frame = CGRectMake(screenCenter.frame.origin.x+screenCenter.frame.size.width, 0, 14/2, 33/2);
         }
         else
         {
             _imageScreenExplain.hidden = YES;
         }
         
         arrRowNameList = model.rowList;
         STModel = model;
         for (SeatModel *seatModel in model.seats)
         {
             SeatInfo *seatInfo = [[SeatInfo alloc]init];
             seatInfo.seatId = [seatModel.seatId integerValue];
             seatInfo.name = seatModel.seatName;
             seatInfo.areaId = seatModel.areaId;
             seatInfo.status = [seatModel.status intValue];
             seatInfo.type = [seatModel.seatType intValue];
             seatInfo.x = [seatModel.x integerValue];
             seatInfo.y = [seatModel.y integerValue];
             seatInfo.seatNumber = [seatModel.seatNumber integerValue];
             for (AreaModel* area in model.areaList)
             {
                 if ([seatInfo.areaId isEqualToString:area.areaId])
                 {
                     seatInfo.areaName = area.areaName;
                 }
             }
             [arrSeats addObject:seatInfo];
         }
         if (_labelDate.text.length>0)
         {
             [weakself refreshData];
         }
         [weakself drawSeats:arrSeats];
         [weakself hideFailureView];
         
         if ([model.full boolValue])
         {
             //没有剩余座位
             UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"座位已经坐满了～去看看其他场次吧～" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
             [alert show];
         }
         else
         {
             if (weakself.isFirstLoad)
             {
                 if (modelShowTime.showtimeTip.length>0)
                 {
                     [weakself showToastTip];
                 }
             }
         }
         if (weakself.isFirstLoad)
         {
             weakself.isFirstLoad = NO;
         }
         
         [weakself getSeatPrice];
     } failure:^(NSError *error){
         [Tool showWarningTip:error.domain time:1.0];
         if (nil != _seatsView)
         {
             [_seatsView removeFromSuperview];
         }
         [weakself initFailureView];
     }];
}

//获取座位最低价格
-(void)getSeatPrice
{
    PriceListModel* priceModel = modelShowTime.priceList;
    if ([priceModel.isLowestPrice boolValue])
    {
        //基础会员价是最低价
        self.cardId = 0;
        self.ticketPrice = [priceModel.priceBasic integerValue] + [priceModel.priceService integerValue];
        self.servicePrice = [priceModel.priceService integerValue];
    }
    else
    {
        for (MemberPriceModel* memberModel in priceModel.memberPriceList)
        {
            if ([memberModel.isLowestPrice boolValue])
            {
                //最低的会员价
                self.cardId = [memberModel.cinemaCardId integerValue];
                self.ticketPrice = [memberModel.memberPrice integerValue] + [memberModel.servicePrice integerValue];
                self.servicePrice = [memberModel.servicePrice integerValue];
                return;
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshData
{
    NSString* theWeekday = [Tool getShowTimeDate:self.showTimesModel.startPlayTime endTime:STModel.currentTime]; //[Tool returnWeek:self.showTimesModel.startPlayTime];
    NSString* theDate = [Tool returnTime:self.showTimesModel.startPlayTime format:@"MM月dd日 HH:mm"];
    _labelDate.text = [NSString stringWithFormat:@"%@ %@",theWeekday,theDate];
    _labelScreenName.text = modelHall.hallName;
}

-(void)initShowTimeView
{
    _showView = [[ChooseSeatShowView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-290, SCREEN_WIDTH, 290) movieId:self.movieId];
    _showView.backgroundColor = [UIColor whiteColor];
    _showView.dateSelectedIndex = self.dateIndex;
    _showView.showViewDelegate = self;
}

-(void)reloadSeat:(ShowTimesModel *)model
{
    self.showTimesModel = model;
    
    [[ExAlertView sharedAlertView] dismissAlertView];
    [arrSeats removeAllObjects];
    [self.selectedSeats removeAllObjects];
    [self refreshSelectedSeatName];
    [self loadSeatData];
}

-(void)showToastTip
{
    if (!_viewTip)
    {
        //蒙层
        _viewAlpha = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _viewAlpha.backgroundColor = RGBA(0, 0, 0, 1);
        _viewAlpha.alpha = 0;
        [self.view addSubview:_viewAlpha];
        
        _viewTip = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, (SCREEN_HEIGHT-180)/2, 250, 180)];
        _viewTip.backgroundColor = [UIColor whiteColor];
        _viewTip.layer.masksToBounds = YES;
        _viewTip.layer.cornerRadius = 5;
        _viewTip.alpha = 0;
        [self.view addSubview:_viewTip];
        
        UILabel* labelTip = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 250, 15)];
        labelTip.text = @"温馨提示";
        labelTip.textAlignment = NSTextAlignmentCenter;
        labelTip.textColor = RGBA(253, 122, 34, 1);
        labelTip.font = MKFONT(15);
        [_viewTip addSubview:labelTip];
        
        _labelTipDesc = [[UILabel alloc]initWithFrame:CGRectMake(30, labelTip.frame.origin.y+labelTip.frame.size.height+20, _viewTip.frame.size.width-60, 0)];
        _labelTipDesc.numberOfLines = 0;
        _labelTipDesc.backgroundColor = [UIColor clearColor];
        _labelTipDesc.lineBreakMode = NSLineBreakByCharWrapping;
        _labelTipDesc.attributedText = [self cutTipString:modelShowTime.showtimeTip];
        [_labelTipDesc sizeToFit];
        [_viewTip addSubview:_labelTipDesc];
        
        UIButton* buttonTip = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonTip.backgroundColor = RGBA(117, 112, 255, 1);
        [buttonTip setTitle:@"朕知道了" forState:UIControlStateNormal];
        [buttonTip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonTip.titleLabel.textAlignment = NSTextAlignmentCenter;
        buttonTip.titleLabel.font = MKFONT(15);
        [buttonTip addTarget:self action:@selector(onButtonTip) forControlEvents:UIControlEventTouchUpInside];
        buttonTip.frame = CGRectMake(25, 180-15-40, 200, 40);
        buttonTip.layer.masksToBounds = YES;
        buttonTip.layer.cornerRadius = 20;
        [_viewTip addSubview:buttonTip];
        
        [self.view bringSubviewToFront:_viewAlpha];
        [self.view bringSubviewToFront:_viewTip];
    }
    else
    {
        _labelTipDesc.attributedText = [self cutTipString:modelShowTime.showtimeTip];
        [_labelTipDesc sizeToFit];
        [self.view bringSubviewToFront:_viewAlpha];
        [self.view bringSubviewToFront:_viewTip];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _viewAlpha.alpha = 0.5;
        _viewTip.alpha = 1;
    }];
}

-(NSMutableAttributedString *)cutTipString:(NSString *)strOriginal
{
    NSArray *array;
    if ([strOriginal length] > 0)
    {
        array = [strOriginal componentsSeparatedByString:@"$"];
    }
    NSString* str = [strOriginal stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSRange oneRange =NSMakeRange(0,[array[0] length]);
    NSRange twoRange =NSMakeRange([array[0] length],[array[1] length]);
    NSRange thirdRange =NSMakeRange([array[1] length]+[array[0] length],[array[2] length]);
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(123, 122, 152, 1) range:oneRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(253, 122, 34, 1) range:twoRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(123, 122, 152, 1) range:thirdRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(14) range:oneRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(14) range:twoRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(14) range:thirdRange];
    return strAtt;
}

-(void)onButtonTip
{
    [UIView animateWithDuration:0.3 animations:^{
        _viewAlpha.alpha = 0;
        _viewTip.alpha = 0;
    }];
}



-(void)initNavigation
{
    self._viewTop.frame = CGRectMake(0, 0, SCREEN_WIDTH,65+12+15+SCREEN_WIDTH/10-20);
    
    //更换场次button
    UIButton* btnChangeTime = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize sizeChangeTime = [Tool boundingRectWithSize:@"更换场次" textFont:MKFONT(13) textSize:CGSizeMake(MAXFLOAT, 13)];
    btnChangeTime.frame = CGRectMake(SCREEN_WIDTH-15-sizeChangeTime.width, self._btnBack.frame.origin.y+(self._btnBack.frame.size.height-30)/2, sizeChangeTime.width, 30);
    [btnChangeTime setTitle:@"更换场次" forState:UIControlStateNormal];
    btnChangeTime.titleLabel.font = MKFONT(13);
    [btnChangeTime setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    btnChangeTime.backgroundColor = [UIColor clearColor];
    [btnChangeTime addTarget:self action:@selector(onButtonChangeTime) forControlEvents:UIControlEventTouchUpInside];
    [self._viewTop addSubview:btnChangeTime];
    
    self._labelTitle.text = self.dataModel.movie.movieTitle;
}

-(void)onButtonChangeTime
{
    [MobClick event:mainViewbtn28];
    [[ExAlertView sharedAlertView] showAlertViewWithAlertContentView:_showView];
    [_showView loadShowtimeData];
}

-(void)initHeader
{
    //日期
    _labelDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 12)];
    [_labelDate setBackgroundColor:[UIColor clearColor]];
    [_labelDate setTextColor:RGBA(117, 112, 255,1)];
    [_labelDate setTextAlignment:NSTextAlignmentCenter];
    [_labelDate setFont:MKFONT(12)];
    NSString* theWeekday = [Tool returnWeek:self.showTimesModel.startPlayTime];
    NSString* theDate = [Tool returnTime:self.showTimesModel.startPlayTime format:@"MM月dd日 HH:mm"];
    _labelDate.text = [NSString stringWithFormat:@"%@ %@",theWeekday,theDate];
    [self.view addSubview:_labelDate];
    
    //荧幕
    UIImageView* imageScreen = [[UIImageView alloc]initWithFrame:CGRectMake(0, _labelDate.frame.origin.y+_labelDate.frame.size.height+15, SCREEN_WIDTH, SCREEN_WIDTH/10)];
    imageScreen.image = [UIImage imageNamed:@"img_screen.png"];
    imageScreen.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageScreen];
    
    //厅名
    _labelScreenName = [[UILabel alloc] initWithFrame:CGRectMake(0, imageScreen.frame.origin.y+10, SCREEN_WIDTH, 9)];
    [_labelScreenName setBackgroundColor:[UIColor clearColor]];
    [_labelScreenName setTextColor:RGBA(0, 0, 0,1)];
    [_labelScreenName setTextAlignment:NSTextAlignmentCenter];
    [_labelScreenName setFont:MKFONT(9)];
    [self.view addSubview:_labelScreenName];
    
    //场次说明img
    _imageScreenExplain = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageScreen.frame.origin.y+imageScreen.frame.size.height, SCREEN_WIDTH, 41/2)];
    _imageScreenExplain.hidden = YES;
    [self.view addSubview:_imageScreenExplain];
    
    UIImageView* screenSmallPerson = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 63/2, 41/2)];
    screenSmallPerson.image = [UIImage imageNamed:@"img_showExplain_person.png"];
    [_imageScreenExplain addSubview:screenSmallPerson];
    
    UIImageView* screenLeft = [[UIImageView alloc]initWithFrame:CGRectMake(screenSmallPerson.frame.size.width, 0, 14/2, 33/2)];
    screenLeft.image = [UIImage imageNamed:@"img_showExplain_left.png"];
    [_imageScreenExplain addSubview:screenLeft];
    
    screenCenter = [[UIImageView alloc]initWithFrame:CGRectMake(screenLeft.frame.origin.x+screenLeft.frame.size.width, 0, 50, 33/2)];
    screenCenter.image = [UIImage imageNamed:@"img_showExplain_center.png"];
    [_imageScreenExplain addSubview:screenCenter];
    
    //场次说明label
    _labelScreenExplain = [[UILabel alloc] initWithFrame:CGRectMake(0, (33/2-10)/2, screenCenter.frame.size.width, 10)];
    [_labelScreenExplain setBackgroundColor:[UIColor clearColor]];
    [_labelScreenExplain setTextColor:RGBA(111, 91, 91,1)];
    _labelScreenExplain.text = @"1212131323231";
    [_labelScreenExplain setTextAlignment:NSTextAlignmentCenter];
    [_labelScreenExplain setFont:MKFONT(10)];
    [screenCenter addSubview:_labelScreenExplain];
    
    screenRight = [[UIImageView alloc]initWithFrame:CGRectZero];
    screenRight.image = [UIImage imageNamed:@"img_showExplain_right.png"];
    [_imageScreenExplain addSubview:screenRight];
    
    _viewSeat = [[UIView alloc]initWithFrame:CGRectMake(0, _imageScreenExplain.frame.origin.y+_imageScreenExplain.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-_imageScreenExplain.frame.origin.y-_imageScreenExplain.frame.size.height-270/2)];
    _viewSeat.backgroundColor = RGBA(248, 248, 252, 1);
    [self.view addSubview:_viewSeat];
}

-(void)initFailureView
{
    if (!imageFailure)
    {
        imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-146/2)/2, 50, 146/2, 134/2)];
        imageFailure.image = [UIImage imageNamed:@"image_NoDataOrder.png"];
        [_viewSeat addSubview:imageFailure];
        
        labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, imageFailure.frame.origin.y+imageFailure.frame.size.height+15, SCREEN_WIDTH, 14)];
        labelFailure.text = @"座位加载失败";
        labelFailure.textColor = RGBA(123, 122, 152, 1);
        labelFailure.font = MKFONT(14);
        labelFailure.textAlignment = NSTextAlignmentCenter;
        [_viewSeat addSubview:labelFailure];
        
        btnTryAgain = [UIButton buttonWithType:UIButtonTypeCustom];
        btnTryAgain.frame = CGRectMake((SCREEN_WIDTH-146/2)/2, labelFailure.frame.origin.y+labelFailure.frame.size.height+30, 146/2, 24);
        [btnTryAgain setTitle:@"重新加载" forState:UIControlStateNormal];
        [btnTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnTryAgain.titleLabel.font = MKFONT(14);
        btnTryAgain.backgroundColor = RGBA(117, 112, 255, 1);
        btnTryAgain.layer.masksToBounds = YES;
        btnTryAgain.layer.cornerRadius = btnTryAgain.frame.size.height/2;
        [btnTryAgain addTarget:self action:@selector(onButtonTryAgain) forControlEvents:UIControlEventTouchUpInside];
        [_viewSeat addSubview:btnTryAgain];
    }
    else
    {
        imageFailure.hidden = NO;
        labelFailure.hidden = NO;
        btnTryAgain.hidden = NO;
    }
}

-(void)hideFailureView
{
    if (imageFailure)
    {
        imageFailure.hidden = YES;
        labelFailure.hidden = YES;
        btnTryAgain.hidden = YES;
    }
}

-(void)onButtonTryAgain
{
    [self loadSeatData];
}

- (void)drawSeats:(NSArray*)arraySeat
{
    NSArray *seatsArray = [arraySeat copy];
    _seatsView = (MTSeatsView *)[self.view viewWithTag:kDrawSeatsView];
    if (nil != _seatsView)
    {
        [_seatsView removeFromSuperview];
    }
    ChooseSeatManager *seatManager = [[ChooseSeatManager alloc] init];
    NSUInteger limitCount = seatsCanChooselimitCount;
    [seatManager initSeatsWithSeatsData:seatsArray limitCount:limitCount];
    if (self.selectedSeats.count>0) {
        seatManager.selectedSeats = [[NSMutableArray alloc]initWithArray:self.selectedSeats];
    }
    //self.blankSeatsView.clipsToBounds = YES;
    CGRect seatsViewRect = _viewSeat.frame;
    _seatsView = [[MTSeatsView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, seatsViewRect.origin.y, seatsViewRect.size.width, seatsViewRect.size.height) seatManager:seatManager specialModel:STModel.specialSeatImage];
    [_seatsView setBackgroundColor:[UIColor clearColor]];
    if (self.selectedSeats.count>0) {
        _seatsView.beforeBtns = [[NSMutableArray alloc]initWithArray:self.selectedSeats];
    }
    _seatsView.rowNameList = [arrRowNameList copy];
    _seatsView.delegate = self;
    _seatsView.tag = kDrawSeatsView;
    [self.view addSubview:_seatsView];
    [_seatsView drawSeat:NO];
//    [UIView animateWithDuration:0.5 animations:^{
        _seatsView.frame = seatsViewRect;
//    } completion:^(BOOL finished) {
         [_seatsView setSeatZoom:0.8 seatX:0 seatY:0 isFirst:YES];
//    }];
    //[self.blankSeatsView addSubview:_seatsView];
    
    UIImageView* viewShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, _seatsView.frame.origin.y+_seatsView.frame.size.height-6, SCREEN_WIDTH, 6)];
    viewShadow.image = [UIImage imageNamed:@"img_public_shadow.png"];
    [self.view addSubview:viewShadow];
}

-(void)initFooter
{
    UIView* _footerView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-270/2, SCREEN_WIDTH, 270/2)];
    [_footerView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_footerView];
    
    NSArray* arrExplain = @[@"已选",@"可选",@"不可选",@"情侣座"];
    NSArray* arrImgExplain = @[@"buttonSeat01.png",@"buttonSeat02.png",@"buttonSeat03.png",@"buttonSeat04.png"];
    UIView* viewChooseExplain=[[UIView alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, 16)];
    viewChooseExplain.backgroundColor = [UIColor clearColor];
    [_footerView addSubview:viewChooseExplain];
    
    CGFloat widthExplain[4];
    CGFloat widthTotalExplain = 0;
    for (int i=0; i<4; i++)
    {
        CGSize sizeLabelExplain = [Tool boundingRectWithSize:arrExplain[i] textFont:MKFONT(13) textSize:CGSizeMake(MAXFLOAT, 13)];
        widthExplain[i] = sizeLabelExplain.width;
        widthTotalExplain += sizeLabelExplain.width;
    }
    CGFloat spaceExplain = (SCREEN_WIDTH-15*2-10*4-16*3-32-widthTotalExplain)/3;
    
    for (int i=0; i<4; i++)
    {
        UIImageView* imgExplain = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgExplain.backgroundColor = [UIColor clearColor];
//        [imgExplain setImage:[UIImage imageNamed:arrImgExplain[i]]];
        if (i == 0)
        {
            imgExplain.frame = CGRectMake(0,0,16,16);
            [Tool downloadImage:[STModel.specialSeatImage.commonSelectSeatImageList objectAtIndex:0] button:nil imageView:imgExplain defaultImage:arrImgExplain[i]];
//            [imgExplain sd_setImageWithURL:[NSURL URLWithString:[STModel.specialSeatImage.commonSelectSeatImageList objectAtIndex:0]] placeholderImage:[UIImage imageNamed:arrImgExplain[i]]];
        }
        if (i == 1)
        {
            imgExplain.frame = CGRectMake(16+10+spaceExplain+widthExplain[0],0,16,16);
            [Tool downloadImage:STModel.specialSeatImage.commonSaleSeatImage button:nil imageView:imgExplain defaultImage:arrImgExplain[i]];
//            [imgExplain sd_setImageWithURL:[NSURL URLWithString:STModel.specialSeatImage.commonSaleSeatImage] placeholderImage:[UIImage imageNamed:arrImgExplain[i]]];
        }
        if (i == 2)
        {
            imgExplain.frame = CGRectMake((16+10+spaceExplain)*2+widthExplain[0]+widthExplain[1],0,16,16);
            [Tool downloadImage:STModel.specialSeatImage.commonSoldSeatImage button:nil imageView:imgExplain defaultImage:arrImgExplain[i]];
//            [imgExplain sd_setImageWithURL:[NSURL URLWithString:STModel.specialSeatImage.commonSoldSeatImage] placeholderImage:[UIImage imageNamed:arrImgExplain[i]]];
        }
        if (i == 3)
        {
            [Tool downloadImage:STModel.specialSeatImage.loveSaleSeatImage button:nil imageView:imgExplain defaultImage:arrImgExplain[i]];
//            [imgExplain sd_setImageWithURL:[NSURL URLWithString:STModel.specialSeatImage.loveSaleSeatImage] placeholderImage:[UIImage imageNamed:arrImgExplain[i]]];
            imgExplain.frame = CGRectMake((16+10+spaceExplain)*3+widthExplain[0]+widthExplain[1]+widthExplain[2],0,32,16);
        }
        
        UILabel* labelExplain = [[UILabel alloc]initWithFrame:CGRectMake(imgExplain.frame.origin.x+imgExplain.frame.size.width+10, 3, widthExplain[i], 13)];
        labelExplain.text = arrExplain[i];
        labelExplain.textColor = RGBA(123, 122, 152, 1);
        labelExplain.textAlignment = NSTextAlignmentLeft;
        labelExplain.font = MKFONT(13);
        labelExplain.backgroundColor = [UIColor clearColor];
        [viewChooseExplain addSubview:labelExplain];
        [viewChooseExplain addSubview:imgExplain];
    }
    
    _selectedSeatsView=[[UIView alloc]initWithFrame:CGRectMake(0, viewChooseExplain.frame.origin.y+viewChooseExplain.frame.size.height+15, SCREEN_WIDTH, 24)];
    [_footerView addSubview:_selectedSeatsView];
    
    _btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnConfirm.frame = CGRectMake(15, _footerView.frame.size.height-40-10, SCREEN_WIDTH-30, 40);
    [_btnConfirm setTitle:@"选好了" forState:UIControlStateNormal];
    _btnConfirm.titleLabel.font = MKFONT(15);
    [_btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnConfirm.layer.masksToBounds = YES;
    _btnConfirm.layer.cornerRadius = _btnConfirm.frame.size.height/2;
    _btnConfirm.backgroundColor = RGBA(180, 180, 180, 1);
    _btnConfirm.enabled = NO;
    [_btnConfirm addTarget:self action:@selector(onButtonConfirm) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_btnConfirm];
}

#pragma mark MTSeatsViewProtocol methods
- (BOOL) seatsView:(MTSeatsView *)seatsView seatClickedx:(NSInteger) x y:(NSInteger)y
{
    [MobClick event:mainViewbtn27];
    if( ![Config getLoginState])
    {
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginViewController animated:YES];
        return NO;
    }

    //选中座位后放大该区域  
    [seatsView setSeatZoom:1 seatX:(x+1) seatY:(y+1) isFirst:NO];
    
    //如果选座为空,lastAreaName为nil
    if (self.selectedSeats.count == 0)
    {
        seatsView.seatManager.lastAreaName = nil;
    }
    //判断当前是
    ChooseSeatResultEnum result = [seatsView.seatManager chooseSeat:x y:y];
    if (ChooseSeatResult_OK == result) {
        self.selectedSeats = [NSMutableArray arrayWithArray:[seatsView.seatManager getAllSelectedSeats]];
        [self refreshSelectedSeatName];
         [seatsView drawSeat:YES];
        //用户选择某个座位时候，要请求服务器，去获取要刷新得座位信息
        //如果是反选，则不去请求
        if(!ARRAY_IS_EMPTY(self.selectedSeats)){
            NSPredicate *predicateXY = [NSPredicate predicateWithFormat:@"x == %d AND y == %d", x ,y];
            NSArray *filteredSeatInfoArray = [self.selectedSeats filteredArrayUsingPredicate:predicateXY];
            if(!ARRAY_IS_EMPTY(filteredSeatInfoArray)){
                
                //                if(!self.isFirstQuestPartRefreshSeat){//第一次发请求时候，将nextBtn设置为不可用，第一次请求完成后，再设置为可用
                //                    self.isFirstQuestPartRefreshSeat = YES;
                //                    self.nextBtn.enabled = NO;
                //                }
                //[self getPartRowSeatsData];
            }
        }else
        {
            seatsView.seatManager.lastAreaName = nil;
        }
        return YES;
    }
    else {
        [Tool showWarningTip:[seatsView.seatManager chooseSeatResultFromEnum:result]  time:1.5f];
        return NO;
    }
}

- (void)changeButtonImgForScaleView:(BOOL)isMax
{
//    self.btnZoom.selected = !isMax;
}

-(void)animateZoomTipViewToHide{
    //    if(!self.zoomTipView.isHidden){
    //        [UIView
    //         animateWithDuration:0.2
    //         animations:^{
    //             [self.zoomTipView setAlpha:0.0];
    //         }
    //         completion:^(BOOL finished) {
    //             self.zoomTipView.hidden = YES;
    //         }];
    //    }
}

//刷新用户选中的座位信息
-(void)refreshSelectedSeatName{
    for (UIView *view in self.selectedSeatsView.subviews)
    {
        [view removeFromSuperview];
    }
    CGFloat seatHorizentalMargin=30;
    if(SCREEN_WIDTH<=320)
    {
        seatHorizentalMargin=20;
    }
    
    if (_selectedSeats.count == 0) {
        //viewChooseExplain.hidden = NO;
        //viewGoldSeats.hidden = NO;
    }
    
    CGFloat widthSeletedSeat = (SCREEN_WIDTH-30-10*3) /4;
    for (int i=0; i<[_selectedSeats count]; i++)
    {
        SeatInfo *seat = [_selectedSeats objectAtIndex:i];
        
        UILabel *lblSeletedSeat=[[UILabel alloc]init];
        [lblSeletedSeat setTextColor:RGBA(85, 85, 85, 1)];
        if (seat.areaName.length>0)
        {
            [lblSeletedSeat setText:[seat.name stringByReplacingOccurrencesOfString:seat.areaName withString:@""]];
        }
        else
        {
            [lblSeletedSeat setText:seat.name];
        }
        lblSeletedSeat.frame = CGRectMake(15+(widthSeletedSeat+10)*i, 0, widthSeletedSeat, 24);
        [lblSeletedSeat setTextAlignment:NSTextAlignmentCenter];
        [lblSeletedSeat setFont:MKFONT(12) ];
        lblSeletedSeat.layer.masksToBounds = YES;
        lblSeletedSeat.layer.borderWidth = 0.5;
        lblSeletedSeat.layer.borderColor = [RGBA(0, 0, 0, 0.2) CGColor];
        lblSeletedSeat.layer.cornerRadius = lblSeletedSeat.frame.size.height/2;
        [self.selectedSeatsView addSubview:lblSeletedSeat];
    }
//    //取整后显示，为了整数票价45，显示为45而不是45.0
//    NSString *num = [Tool PreserveTowDecimals:[NSNumber numberWithFloat:allPrice]];
//    
//    if ([self.strPriceName isEqualToString:@"非会员"]) {
//        _lblPriceValue.text = [NSString stringWithFormat:@"¥ %@元",num];
//    }else
//    {
//        _lblPriceValue.text = [NSString stringWithFormat:@"%@价：￥%@",self.strPriceName,num];
//    }
    
    if (_selectedSeats.count>0)
    {
        _btnConfirm.backgroundColor = RGBA(0, 0, 0, 1);
        _btnConfirm.enabled = YES;
    }
    else
    {
        _btnConfirm.backgroundColor = RGBA(180, 180, 180, 1);
        _btnConfirm.enabled = NO;
    }
}

#pragma mark - 选好了
-(void)onButtonConfirm
{
    [MobClick event:mainViewbtn31];
//    if (_selectedSeats.count == 0)
//    {
//        [Tool showWarningTip:@"请选定座位."  time:1.0f];
//        return;
//    }
    if (!buildOrderModel)
    {
        buildOrderModel = [[BuildOrderModel alloc]init];
    }
    buildOrderModel.strCinema = modelCinema.cinemaName;
    buildOrderModel.strCinemaId = modelCinema.cinemaId;
    buildOrderModel.strImgFilm = modelMovieDetail.movieLogoUrl;
    buildOrderModel.strFilmName = modelMovieDetail.movieTitle;
    buildOrderModel.strFilmLanguage = modelShowTime.language;
    buildOrderModel.version = modelShowTime.version;
    //    buildOrderModel.strDate = lblShowtimeDay.text;
    buildOrderModel.strTime = self.showTimesModel.startPlayTime;
    buildOrderModel.strHall = modelHall.hallName;
    buildOrderModel.strPlayType = modelHall.hallSizeDesc;
    buildOrderModel.showtimeId = [self.showTimesModel.showtimeId integerValue];
    NSMutableArray* arraySeats = [[NSMutableArray alloc]init];
    NSMutableArray* arraySeatIds = [[NSMutableArray alloc]init];
    buildOrderModel.arrSeatIds = arraySeatIds;
    buildOrderModel.currentDate = STModel.currentTime;
    
    for (SeatInfo* info in _selectedSeats)
    {
        [arraySeats addObject:info.name];
        [arraySeatIds addObject:[NSString stringWithFormat:@"%ld",(long)info.seatId]];
    }
    buildOrderModel.arrSeats = [arraySeats copy];
    
    if (_loginState == LoginStateYes)
    {
        __weak ChooseSeatViewController *weakself = self;
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
        [ServicesShowTime getMovieShowTimeDetail:[self.showTimesModel.showtimeId integerValue] model:^(ShowTimeDetailModel *model) {
            [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
            STModel = model;
            modelShowTime = model.showtime;
            [weakself getSeatPrice];
            allPrice = weakself.ticketPrice * [_selectedSeats count];
            buildOrderModel.strTotalPrice = [NSString stringWithFormat:@"%.1f",allPrice];
            buildOrderModel.strServicePrice = [NSString stringWithFormat:@"%ld",(long)weakself.servicePrice];
            buildOrderModel.strCardId = [NSNumber numberWithInteger:weakself.cardId];
            [weakself loadSaleData];
        } failure:^(NSError *error) {
            [Tool showWarningTip:@"网络异常，票价获取失败" time:2.0];
        }];
    }
    else
    {
        allPrice = self.ticketPrice * [_selectedSeats count];
        buildOrderModel.strTotalPrice = [NSString stringWithFormat:@"%.1f",allPrice];
        buildOrderModel.strServicePrice = [NSString stringWithFormat:@"%ld",(long)self.servicePrice];
        buildOrderModel.strCardId = [NSNumber numberWithInteger:self.cardId];
        [self loadSaleData];
    }
}

-(void)loadSaleData
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesGoods getGoodsList:[Config getCinemaId] cardId:self.cardId showTimeId:[self.showTimesModel.showtimeId integerValue] array:^(NSArray *array)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         if (array.count>0)
         {
             //有小卖，跳转到小卖页
             SmallSaleViewController *smallVC = [[SmallSaleViewController alloc]init];
             smallVC._orderModel = buildOrderModel;
             smallVC.priceListModel = STModel.showtime.priceList;
             smallVC._arrList = array;
             smallVC._showTimeId = [weakSelf.showTimesModel.showtimeId integerValue];
             [weakSelf changeLoginState];
             [weakSelf.navigationController pushViewController:smallVC animated:YES];
         }
         else
         {
             //没有小卖，跳转到订单确认页
             BuildOrderViewController *buildVC = [[BuildOrderViewController alloc]init];
             buildVC._orderModel = buildOrderModel;
             buildVC.priceListModel = STModel.showtime.priceList;
             buildVC.isFromSale = NO;
             //             buildVC.isHaveSale = NO;
             [weakSelf changeLoginState];
             [weakSelf.navigationController pushViewController:buildVC animated:YES];
         }
     } failure:^(NSError *error){
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         if(error.code == -101)
         {
             LoginViewController *loginControlller = [[LoginViewController alloc] init];
             [self.navigationController pushViewController:loginControlller animated:YES];
             return;
         }
         //没有小卖，跳转到订单确认页
         BuildOrderViewController *buildVC = [[BuildOrderViewController alloc]init];
         buildVC._orderModel = buildOrderModel;
         buildVC.priceListModel = STModel.showtime.priceList;
         buildVC.isFromSale = NO;
         //         buildVC.isHaveSale = NO;
         [weakSelf changeLoginState];
         [weakSelf.navigationController pushViewController:buildVC animated:YES];
     }];
}

-(void)changeLoginState
{
    //在选座页登录后跳到下一页面，更改登录状态
    if (_loginState == LoginStateYes)
    {
        _loginState = LoginStateSpecial;
    }
}

-(void)onButtonBack
{
    if (self.loginBackBlock && (_loginState == LoginStateYes || _loginState == LoginStateSpecial))
    {
        //登录后返回排期列表刷新价格
        self.loginBackBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_REFRESHSEATS];
}

@end
