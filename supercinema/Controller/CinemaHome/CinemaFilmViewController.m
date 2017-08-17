//
//  CinemaFilmViewController.m
//  supercinema
//
//  Created by mapollo91 on 29/7/16.
//
//

#import "CinemaFilmViewController.h"

@interface CinemaFilmViewController ()

@end

@implementation CinemaFilmViewController

#define     LOGOSCALE       526/372


-(void) viewDidAppear:(BOOL)animated
{
    if( [Config getEveryPull] )
    {
        [self._locationManager requestLocationWithReGeocode:YES completionBlock:self._completionBlock];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if( [Config getEveryPull] )
    {
        [self location];
        [self configLocationManager];
    }
    
    [Tool showTabBar];
    //电池条变为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //如果是第一次使用引导用户去选择影院
    if ( ![Config isFirstStartUp] )
    {
        [Tool hideTabBar];
        CinemaSearchViewController *cinemaSearchController = [[CinemaSearchViewController alloc ] init];
        [self .navigationController pushViewController:cinemaSearchController animated:NO];
    }
    //不管登录还是未登录 本地和服务器都不存在影院id
    if ( [[Config getCinemaId] length] == 0 )
    {
        [Tool hideTabBar];
        CinemaSearchViewController *cinemaSearchController = [[CinemaSearchViewController alloc ] init];
        [self .navigationController pushViewController:cinemaSearchController animated:NO];
    }
}

#pragma mark 保存定位信息
-(void)saveLoacationPostion:(NSString *)longitude latitude:(NSString *)latitude citycode:(NSString *)citycode
{
    NSDictionary *dic = @{@"longitude":longitude,
                          @"latitude":latitude,
                          @"citycode":citycode};
    
    if ([[Tool urlIsNull:longitude] length] > 0 &&
        [[Tool urlIsNull:latitude] length] > 0 &&
        [[Tool urlIsNull:citycode] length] > 0)
    {
        [Config saveLocationInfo:dic];
    }
}
#pragma mark 配置定位信息
-(void)location
{
    __block CinemaFilmViewController  *weakSelf = self;
    self._completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            //如果为定位失败的error，则不进行后续操作
            if (error.code == AMapLocationErrorLocateFailed)
            {
               
            }
        }
        //得到定位信息
        if (location)
        {
            [Config saveEveryPull:@"NO"];
            [weakSelf saveLoacationPostion:[NSString stringWithFormat:@"%f",location.coordinate.longitude]
                                latitude:[NSString stringWithFormat:@"%f",location.coordinate.latitude]
                                citycode:[NSString stringWithFormat:@"%@",regeocode.citycode]];
            
        }
    };
}
- (void)configLocationManager
{
    self._locationManager = [[AMapLocationManager alloc] init];
    [self._locationManager setDelegate:self];
    //设置期望定位精度
    [self._locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //设置不允许系统暂停定位
    [self._locationManager setPausesLocationUpdatesAutomatically:NO];
    //设置允许在后台定位
    [self._locationManager setAllowsBackgroundLocationUpdates:NO];
    //设置定位超时时间
    [self._locationManager setLocationTimeout:6];
    //设置逆地理超时时间
    [self._locationManager setReGeocodeTimeout:3];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBA(246, 246, 251,1);
    _isScrollTop = NO;
    self.cellDic = [[NSMutableDictionary alloc]init];
    
    [self initLoadBool];
    
    //初始化headView
    [self initHeadView];
    [self initHeadData];
    //初始化标题按钮
    [self initTitleBtn];
    
//    [self loadSystemNotice];
    
    //打开app加载通知
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(loadSystemNoticeForOpenApp)
                                                name:NOTIFITION_LOADSYSTEMNOTICE
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(refreshData)
                                                name:NOTIFITION_REFRESHCINEMAHOME
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(removeData)
                                                name:NOTIFITION_REMOVEHOMEDATA
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(tabIndex:)
                                                name:NOTIFITION_HOMETOTAB
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(refreshFrameUp)
                                                name:NOTIFITION_REFRESHHOMEUP
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(refreshFrameDown)
                                                name:NOTIFITION_REFRESHHOMEDOWN
                                              object:nil];
    //影院首页通知
    [[NSNotificationCenter defaultCenter ] addObserver:self
                                              selector:@selector(loadSystemNoticeForCinemaHome)
                                                  name:NOTIFITION_SHOWCINEMAVIEWMSG
                                                object:nil];
    //显示唤起app通知
    [[NSNotificationCenter defaultCenter ] addObserver:self
                                              selector:@selector(showWakeupAppNotice)
                                                  name:NOTIFITION_SHOWWAKEUPAPPNOTICE
                                                object:nil];
    //APNS通知
    [[NSNotificationCenter defaultCenter ] addObserver:self
                                              selector:@selector(getApnsNotify:)
                                                  name:NOTIFITION_APNSNOTIFICATION
                                                object:nil];
    //更改页签加载bool值
    [[NSNotificationCenter defaultCenter ] addObserver:self
                                              selector:@selector(initLoadBool)
                                                  name:NOTIFITION_REFRESHHOMELOADBOOL
                                                object:nil];
}

-(void)initLoadBool
{
    _isHaveLoadData[0] = NO;
    _isHaveLoadData[1] = NO;
    _isHaveLoadData[2] = NO;
    _isHaveLoadData[3] = NO;
}

-(void)getApnsNotify:(NSNotification*)noti
{
    NSDictionary* dictCategory = [noti userInfo];
    NSNumber* notifyId = [dictCategory objectForKey:@"nid"];
    NSString* jumpUrl = [dictCategory objectForKey:@"ju"];
    NSNumber* jumpType = [dictCategory objectForKey:@"jt"];
    __weak typeof(self) weakSelf = self;
    
    if (![notifyId isEqualToNumber:[Config getAPNSId]])
    {
        if (notifyId)
        {
            //系统推送，统计打开量一次
            [ServicesNotification addNoticeCount:@"notify_click" countObjectId:notifyId result:^(RequestResult *result)
             {
                 NSLog(@"notify_click＋1");
             } failure:^(NSError *error) {
                 NSLog(@"notify_click failed");
             }];
            
            //系统推送，统计送达量一次
            [ServicesNotification addNoticeCount:@"notify_display" countObjectId:notifyId result:^(RequestResult *result)
             {
                 NSLog(@"notify_display＋1");
             } failure:^(NSError *error) {
                 NSLog(@"notify_display failed");
             }];
            
            [ServiceActivity getActivityDetail:notifyId model:^(NotifyListModel *model)
             {
                [MkPullMessage showPushMessage:weakSelf.navigationController triggerType:[model.notifyType intValue] apnsModel:model typeTime:@""];
             } failure:^(NSError *error) {
                 [Tool showWarningTip:error.domain time:2.0f];
             }];
        }
        else
        {
            [MkPullMessage apnsShowNotice:jumpUrl type:jumpType apnsModel:nil nav:self.navigationController];
        }
    }
    
    [Config saveAPNSId:notifyId];
}

#pragma mark 拉取打开app通知
-(void) loadSystemNoticeForOpenApp
{
    if( [[Config getCinemaId] length] > 0 )
    {
        //创建通知表
        [sqlDatabase createTable:table_notice];
        //创建拉去时间表
        [sqlDatabase createTable:table_pull];
        
        //读取数据插入数据库
        __weak typeof(self) weakSelf = self;
        [ServicesNotification getMessageNotfication:[Config getCinemaId] trueFalse:^(NSNumber *trueFalse)
         {
             [weakSelf performSelector:@selector(showMainViewNotice) withObject:nil afterDelay:0.1];
             [weakSelf performSelector:@selector(showOpenCinemaNotice) withObject:nil afterDelay:0.5];
         } failure:^(NSError *error) {
             [weakSelf performSelector:@selector(showMainViewNotice) withObject:nil afterDelay:0.1];
             [weakSelf performSelector:@selector(showOpenCinemaNotice) withObject:nil afterDelay:0.5];
             if(error.code == -101)
             {
                 [Config deleteUserLoactionData];
//                 [Tool showWarningTip:error.domain time:1];
             }
             NSLog(@"%@",error.domain);
         }];
    }
}

#pragma mark 拉取打开影院首页通知
-(void) loadSystemNoticeForCinemaHome
{
    if( [[Config getCinemaId] length] > 0 )
    {
        //创建通知表
        [sqlDatabase createTable:table_notice];
        //创建拉去时间表
        [sqlDatabase createTable:table_pull];
        
        //读取数据插入数据库
        __weak typeof(self) weakSelf = self;
        [ServicesNotification getMessageNotfication:[Config getCinemaId] trueFalse:^(NSNumber *trueFalse)
         {
             [weakSelf performSelector:@selector(showOpenCinemaNotice) withObject:nil afterDelay:0.5];
             NSLog(@"write success");
         } failure:^(NSError *error) {
             [weakSelf performSelector:@selector(showOpenCinemaNotice) withObject:nil afterDelay:0.5];
             if(error.code == -101)
             {
                 [Config deleteUserLoactionData];
//                 [Tool showWarningTip:error.domain time:1];
             }
             NSLog(@"%@",error.domain);
         }];
    }
}
#pragma mark 显示打开app通知
-(void) showMainViewNotice
{
    if( [Config getLoginState] )
    {
        [MkPullMessage showPushMessage:self.navigationController triggerType:OPEN_APP apnsModel:nil typeTime:@"mainPageTime"];
    }
}
#pragma mark 显示影院首页
-(void) showOpenCinemaNotice
{
    if( [Config getLoginState] )
    {
        [MkPullMessage showPushMessage:self.navigationController triggerType:OPEN_CINEMA_HOMEPAGE apnsModel:nil typeTime:@"cinemaDetailTime"];
    }
}

#pragma mark  唤起app显示通知
-(void)showWakeupAppNotice
{
    //拉取消息通知
    if( [Config getLoginState] )
    {
        [MkPullMessage showPushMessage:self.navigationController triggerType:WAKEUP_APP apnsModel:nil typeTime:@"wakeupApp"];
    }
}


-(void)removeData
{
    _arrCommingMovieData = nil;
    _arrMovieData = nil;
    [_collectionView reloadData];
    
    [_viewTitleBack2 removeAllObjectsCardTable];
    [_viewTitleBack3 removeAllData];
    [_viewTitleBack4 removeAllObjectsActivity];
}

-(void)refreshData
{
    [self initHeadData];
    [self initMovieData];
}

#pragma mark 渲染head UI
-(void)initHeadView
{
    //头部大图
    _headBigImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 143+60)];
    [_headBigImage setImage:[UIImage imageNamed:@"img_home_big.png"]];
    [self.view addSubview:_headBigImage];
    
    //头部小图
    _headSmallImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 143)];
    _headSmallImage.image = [UIImage imageNamed:@"img_home_small.png"];
    [self.view addSubview:_headSmallImage];
    
    _originFrontImage = _headSmallImage.image;
    NSLog(@"%f\n%f",_originFrontImage.size.width,_originFrontImage.size.height);
    //顶部半透明view
    _headAlphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 143)];
    _headAlphaView.backgroundColor = [UIColor blackColor];
    _headAlphaView.alpha = 0.5;
    [self.view addSubview:_headAlphaView];
    
    //二维码按钮
    _btnScan = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnScan.frame = CGRectMake(0, 25, 98/2, 60/2);
    [_btnScan setBackgroundImage:[UIImage imageNamed:@"btn_scan.png"] forState:UIControlStateNormal];
    [_btnScan addTarget:self action:@selector(onButtonScan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnScan];
    
    //搜索按钮
    _btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSearch.frame = CGRectMake(SCREEN_WIDTH-30-33/2, 25, 96/2, 60/2);
    [_btnSearch setBackgroundImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateNormal];
    [_btnSearch addTarget:self action:@selector(onButtonSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnSearch];
    
    //影院名称
    _btnCinema = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCinema.frame = CGRectMake(15, 85, SCREEN_WIDTH-15, 17);
    _btnCinema.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnCinema.titleLabel.font = MKFONT(17);
    [_btnCinema addTarget:self action:@selector(onButtonCinemaDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCinema];
    
    _imgArrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15-15/2, _btnCinema.frame.origin.y+2, 15/2, 26/2)];
    _imgArrow.image = [UIImage imageNamed:@"image_arrow.png"];
    [self.view addSubview:_imgArrow];
    
    //影院特色
    _viewCinemaFeature = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _btnCinema.frame.origin.y+17+10, SCREEN_WIDTH, 15)];
    _viewCinemaFeature.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_viewCinemaFeature];
}

#pragma mark 扫二维码
-(void)onButtonScan
{
    [MobClick event:mainViewbtn1];
    _clickType = @"QR";
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        _alterViewQR = [[UIAlertView alloc]
                           initWithTitle:@"提示"
                           message:@"请在[设置-隐私-相机]中打开相机服务"
                           delegate:self
                           cancelButtonTitle:@"设置"
                           otherButtonTitles:@"取消", nil];
        [_alterViewQR show];
    }
    else
    {
        QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
        reader.delegate = self;
        [self.navigationController pushViewController:reader animated:YES];
    }
}

#pragma mark 扫描结果
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    if (result)
    {
        if ([Tool isQRCodeCorrect:result])
        {
            _arrQrResult =  [Tool analysisQR:result];
            [self QrResultOpenView ];
        }
        else
        {
            if([result length] > 4)
            {
                if([[result substringToIndex:4] isEqualToString:@"http"])
                {
                    NotifyH5ViewController* h5ViewController = [[NotifyH5ViewController alloc]init];
                    h5ViewController._shareUrl = result;
                    [self.navigationController pushViewController:h5ViewController animated:YES];
                }
                else
                {
                    [Tool showWarningTip:@"二维码识别错误" time:2];
                }
            }
            else
            {
                [Tool showWarningTip:@"二维码识别错误" time:2];
            }
        }
    }
}

/*
 首页	home	movikr://home/19283 (19283为影院id,可为空)
 指定影片购票页	st	"movikr://st/123（123为影片id）
 movikr://st/123/19283（123为影片id，19283为影院id，可为空）"
 小卖部	goods	movikr://goods/19283 (19283为影院id,可为空)
 凑热闹	act	movikr://act/19283 (19283为影院id,可为空)
 捡便宜	vip	movikr://vip/19283 (19283为影院id,可为空)
 我的卡包	icard	movikr://icard
 我的订单	iorder	movikr://iorder
 他人动态页	u	movikr://u/123   (123为该用户id)
 */
#pragma mark 从扫描的结果判断跳转UI
-(void) QrResultOpenView
{
     if ( [_arrQrResult count] == 1 )
     {
         if ([_arrQrResult[0] isEqualToString:@"home"])
         {
             UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(100)];
             [self onButtonTitle:buttonTitle];
             
         }
         if ([_arrQrResult[0] isEqualToString:@"goods"])
         {
            NSLog(@"打开小卖");
             UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(2+100)];
             [self onButtonTitle:buttonTitle];

         }
         if ([_arrQrResult[0] isEqualToString:@"act"])
         {
             NSLog(@"打开凑热闹");
             UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(3+100)];
             [self onButtonTitle:buttonTitle];
         }
         if ([_arrQrResult[0] isEqualToString:@"vip"])
         {
            NSLog(@"捡便宜");
             UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(101)];
             [self onButtonTitle:buttonTitle];
         }
         if ([_arrQrResult[0] isEqualToString:@"iorder"])
         {
             if ( ![Config getLoginState ] )
             {
                 NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                 [self showLoginController:param controllerName:@"MyOrderViewController"];
             }
             else
             {
                 MyOrderViewController *myOrderController = [[MyOrderViewController alloc ] init];
                 [self.navigationController pushViewController:myOrderController animated:YES];
             }
         }
         if ([_arrQrResult[0] isEqualToString:@"icard"])
         {
             if ( ![Config getLoginState ] )
             {
                 NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                 [self showLoginController:param controllerName:@"MyCardViewController"];
             }
             else
             {
                 MyCardViewController *myCardViewController = [[MyCardViewController alloc ] init];
                 [self.navigationController pushViewController:myCardViewController animated:YES];
             }
             
         }
     }
    if ( [_arrQrResult count] == 2 )
    {
        //影院首页
        if ([_arrQrResult[0] isEqualToString:@"home"])
        {
            NSLog(@"%@",[Config getCinemaId]);
            //扫描的影院不是当前影院则切换
            if (![_arrQrResult[1] isEqualToString:[Config getCinemaId] ])
            {
                [self changeCinema:_arrQrResult[1] ];
                UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(100)];
                [self onButtonTitle:buttonTitle];
            }
            else
            {
                UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(100)];
                [self onButtonTitle:buttonTitle];
            }
        }
        //指定影片购票页
        if ([_arrQrResult[0] isEqualToString:@"st"])
        {
            [self pushToShowTimeView:_arrQrResult[1]];
        }
        //小卖
        if ([_arrQrResult[0] isEqualToString:@"goods"])
        {
            //存在影院id
            if([_arrQrResult count] >1)
            {
                if (![_arrQrResult[1] isEqualToString:[Config getCinemaId] ])
                {
                    [self changeCinema:_arrQrResult[1] ];
                }
                else
                {
                    UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(2+100)];
                    [self onButtonTitle:buttonTitle];
                }
            }
            else
            {
                UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(2+100)];
                [self onButtonTitle:buttonTitle];
            }
        }
        if ([_arrQrResult[0] isEqualToString:@"act"])
        {
            //存在影院id
            if([_arrQrResult count] >1)
            {
                if (![_arrQrResult[1] isEqualToString:[Config getCinemaId] ])
                {
                    [self changeCinema:_arrQrResult[1] ];
                }
                else
                {
                    NSLog(@"打开凑热闹");
                    UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(3+100)];
                    [self onButtonTitle:buttonTitle];
                }
            }
            else
            {
                NSLog(@"打开凑热闹");
                UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(3+100)];
                [self onButtonTitle:buttonTitle];
            }
        }
        if ([_arrQrResult[0] isEqualToString:@"vip"])
        {
            //存在影院id
            if([_arrQrResult count] >1)
            {
                if (![_arrQrResult[1] isEqualToString:[Config getCinemaId] ])
                {
                    [self changeCinema:_arrQrResult[1] ];
                }
                else
                {
                     NSLog(@"捡便宜");
                    UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(101)];
                    [self onButtonTitle:buttonTitle];
                }
            }
            else
            {
                NSLog(@"捡便宜");
                UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(101)];
                [self onButtonTitle:buttonTitle];
            }
        }
        if ([_arrQrResult[0] isEqualToString:@"u"])
        {
            //存在影院id
            if([_arrQrResult count] >1)
            {
                NSLog(@"u%@",_arrQrResult[1]);
            }
        }
    }
    if ( [_arrQrResult count] == 3 )
    {
         //指定影片购票页
        if ([_arrQrResult[0] isEqualToString:@"st"])
        {
            //扫描的影院不是当前影院则切换
            if (![_arrQrResult[2] isEqualToString:[Config getCinemaId] ])
            {
                [self changeCinema:_arrQrResult[2] ];
            }
            else
            {
                //是当前影院直接切换
                [self pushToShowTimeView:_arrQrResult[1]];
            }
        }
    }
}

#pragma mark 切换影院记录
-(void) addCinemaBrowsingHistory:(NSString *)cinemaId
{
    if ([cinemaId length] > 0 )
    {
        [ServicesCinema addCinemaBrowseRecord:@"" longitude:@"" lastVisitCinemaId:cinemaId model:^(RequestResult *model) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}


-(void)showLoginController:(NSMutableDictionary *)param controllerName:(NSString *)name
{
    LoginViewController *loginControlller = [[LoginViewController alloc ] init];
    loginControlller.param = param;
    loginControlller._strTopViewName = name;
    [self.navigationController pushViewController:loginControlller animated:YES];
}

-(void) changeCinema:(NSString *)cinemaId
{
    [self addCinemaBrowsingHistory:cinemaId];
    
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesCinema getCinemaDetail:cinemaId cinemaModel:^(CinemaModel *model)
    {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        _clickType = @"CHANGECINEMA";
        _alterView = [[UIAlertView alloc ] initWithTitle:nil message:[NSString stringWithFormat:@"是否要切换影院『%@』",model.cinemaName] delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        [_alterView show];
        
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
    }];
   
}
#pragma mark 根据扫描结果跳转到排期
-(void)pushToShowTimeView:(NSString *)movieId
{
    __weak typeof(self) weakSelf =self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMovie getMovieDetail:movieId cinemaId:@"" model:^(MovieModel *movieDetail)
    {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        MovieModel *movieModel = [MovieModel new];
        movieModel.movieId = [NSNumber numberWithInt:[movieId intValue]];
        movieModel.movieTitle =movieDetail.movieTitle;
        [weakSelf buyTicket:movieModel];
        
    } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        [Tool showWarningTip:@"影片不存在" time:1];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([_clickType isEqualToString:@"QR"])
    {
        if (SYSTEMVERSION >=8)
        {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                //如果点击打开的话，需要记录当前的状态，从设置回到应用的时候会用到
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            //只有影院id
            if ( [_arrQrResult count] == 2 )
            {
                [Config saveCinemaId:_arrQrResult[1] ];
                [self refreshData];
                
                if ([_arrQrResult[0] isEqualToString:@"goods"])
                {
                    NSLog(@"打开小卖");
                    UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(102)];
                    [self onButtonTitle:buttonTitle];
                }
                if ([_arrQrResult[0] isEqualToString:@"act"])
                {
                    NSLog(@"打开凑热闹");
                    UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(103)];
                    [self onButtonTitle:buttonTitle];
                }
                if ([_arrQrResult[0] isEqualToString:@"vip"])
                {
                    NSLog(@"捡便宜");
                    UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(101)];
                    [self onButtonTitle:buttonTitle];
                }
            }
            //影院id和影片id<先切换影院，然后跳转到排期>
            if ( [_arrQrResult count] == 3 )
            {
                if ([_arrQrResult[0] isEqualToString:@"st"])
                {
                    [Config saveCinemaId:_arrQrResult[2] ];
                    [self refreshData];
                    [self pushToShowTimeView:_arrQrResult[1]];
                }
            }
        }
    }
}

- (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark 二维码窗口返回
- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 搜索
-(void)onButtonSearch
{
    [MobClick event:mainViewbtn6];
    GlobalSearchViewController *globalSearchController= [[GlobalSearchViewController alloc ] init];
    [self.navigationController pushViewController:globalSearchController animated:YES];
}

#pragma mark 影院按钮
-(void)onButtonCinemaDetail
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesCinema getCinemaDetail:[Config getCinemaId] cinemaModel:^(CinemaModel *model)
     {
         [Tool hideTabBar];
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         
         CinameDetailViewController *CinameDetailController = [[CinameDetailViewController alloc ] init];
         CinameDetailController._cinemaModel = model;
         [self.navigationController pushViewController:CinameDetailController animated:YES];
         
         
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
         [Tool showWarningTip:@"哎呀~出错了~" time:2];
     }];
    
    
}


#pragma mark 头部数据
-(void)initHeadData
{
    //头部背景图
    
    [ServicesCinema getCinemaDetail:[Config getCinemaId] cinemaModel:^(CinemaModel *model)
    {
        [Tool downloadImage:[Config getConfigInfo:@"backgroundConfigOfCinemaHomeHeaderBg"] button:nil imageView:_headBigImage defaultImage:@"img_home_big.png"];
        [Tool downloadImage:[Config getConfigInfo:@"backgroundConfigOfCinemaHomeHeaderFg"] button:nil imageView:_headSmallImage defaultImage:@"img_home_small.png"];
//        [_headBigImage sd_setImageWithURL:[NSURL URLWithString:[Config getConfigInfo:@"backgroundConfigOfCinemaHomeHeaderBg"]] placeholderImage:[UIImage imageNamed:@"img_home_big.png"]];
//        [_headSmallImage sd_setImageWithURL:[NSURL URLWithString:[Config getConfigInfo:@"backgroundConfigOfCinemaHomeHeaderFg"]] placeholderImage:[UIImage imageNamed:@"img_home_small.png"]];
        
        NSString* strCinema = model.cinemaName;
        if (strCinema.length>16)
        {
            strCinema = [[strCinema substringWithRange:NSMakeRange(0, 15)] stringByAppendingString:@"..."];
        }
        [_btnCinema setTitle:strCinema forState:UIControlStateNormal];
        
        NSArray* arrFeature = model.featureList;
        
        for (UIView* vV in _viewCinemaFeature.subviews)
        {
            [vV removeFromSuperview];
        }
        CGFloat orginX = 15;
        NSMutableArray* muArrFeature = [[NSMutableArray alloc]init];
        for (FeatureListModel* fModel in arrFeature)
        {
            if ([fModel.importantValue intValue] == 1)
            {
                [muArrFeature addObject:fModel];
            }
        }
        
        for (int i = 0 ; i<muArrFeature.count; i++)
        {
            NSString* strFeature = [muArrFeature[i] featureCode];
            UILabel* labelFeature = [[UILabel alloc]initWithFrame:CGRectMake(orginX+5*i, 0, [Tool calStrWidth:strFeature height:15] + 5,15)];
            labelFeature.text = strFeature;
            labelFeature.textAlignment = NSTextAlignmentCenter;
            labelFeature.font = MKFONT(12);
            labelFeature.textColor = RGBA(255, 255, 255, 0.5);
            labelFeature.backgroundColor = RGBA(0, 0, 0, 0.2);
            labelFeature.layer.masksToBounds = YES;
            labelFeature.layer.cornerRadius = 1.0;
            [_viewCinemaFeature addSubview:labelFeature];
            
            orginX += [Tool calStrWidth:strFeature height:15] + 5;
            if (i == muArrFeature.count-1)
            {
                _viewCinemaFeature.contentSize = CGSizeMake(orginX+25, 0);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark 初始化栏目按钮
-(void)initTitleBtn
{
    _viewTitleBtn = [[UIView alloc]initWithFrame:CGRectMake(0,_headBigImage.frame.origin.y + _headBigImage.frame.size.height, SCREEN_WIDTH, 45)];
    _viewTitleBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewTitleBtn];
    
    UIView* viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5)];
    viewLine.backgroundColor = RGBA(0, 0, 0, 0.05);
    [_viewTitleBtn addSubview:viewLine];
    
    viewBackFrame = CGRectMake(0, _viewTitleBtn.frame.origin.y+_viewTitleBtn.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-_viewTitleBtn.frame.origin.y-_viewTitleBtn.frame.size.height);
    _defaultHeight = viewBackFrame.size.height;
    _viewTitleBack1 = [[UIView alloc]initWithFrame:viewBackFrame];
    _viewTitleBack1.backgroundColor = [UIColor clearColor];
    _viewTitleBack1.hidden = NO;
    [self initMovieList];
    [self initMovieData];
    [self.view addSubview:_viewTitleBack1];
    
    _viewTitleBack2 = [[MembershipCardView alloc]initWithFrame:viewBackFrame navigation:self.navigationController];
    _viewTitleBack2.backgroundColor = [UIColor clearColor];
    _viewTitleBack2.hidden = YES;
    [self.view addSubview:_viewTitleBack2];
    
    _viewTitleBack3 = [[SaleListView alloc]initWithFrame:viewBackFrame navigation:self.navigationController];
    _viewTitleBack3.backgroundColor = [UIColor clearColor];
    _viewTitleBack3.hidden = YES;
//    _viewTitleBack3.btnPay.hidden = YES;
    [self.view addSubview:_viewTitleBack3];
    
    _viewTitleBack4 = [[ActivityView alloc]initWithFrame:CGRectMake(0, _viewTitleBtn.frame.origin.y+_viewTitleBtn.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-(_viewTitleBtn.frame.size.height+64+15) ) navigation:self.navigationController];
    _viewTitleBack4.backgroundColor = RGBA(246, 246, 251, 1);
    _viewTitleBack4.hidden = YES;
    _viewTitleBack4.activityViewDelegate = self;
    [self.view addSubview:_viewTitleBack4];
    
    NSArray* arrStrTitle = @[@"看电影",@"捡便宜",@"小卖部",@"凑热闹"];
    CGSize sizePoint = CGSizeMake(9/2, 9/2);
    CGSize sizeTitle = [Tool boundingRectWithSize:@"看电影" textFont:MKFONT(15) textSize:CGSizeMake(MAXFLOAT, 15)];
    CGFloat space = ((SCREEN_WIDTH-40)-4*(5+sizeTitle.width+sizePoint.width))/3;
    lastBtnTag = 100;
    for (int i = 0; i<arrStrTitle.count; i++)
    {
        //小黑点
        UIImageView* imagePoint = [[UIImageView alloc]initWithFrame:CGRectMake(20+(sizeTitle.width+space+sizePoint.width+5)*i, (45-sizePoint.height)/2, sizePoint.width, sizePoint.height)];
        [imagePoint setImage:[UIImage imageNamed:@"img_blackPoint.png"]];
        imagePoint.tag = 200+i;
        [_viewTitleBtn addSubview:imagePoint];
        
        UIButton* btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        btnTitle.frame = CGRectMake(20+(5+sizePoint.width)*(i+1)+(sizeTitle.width+space)*i, 0, sizeTitle.width, 45);
        [btnTitle setTitle:arrStrTitle[i] forState:UIControlStateNormal];
        btnTitle.titleLabel.font = MKFONT(15);
        btnTitle.tag = 100+i;
        [btnTitle addTarget:self action:@selector(onButtonTitle:) forControlEvents:UIControlEventTouchUpInside];
        [_viewTitleBtn addSubview:btnTitle];
        
        if (i == 0)
        {
            btnTitle.selected = YES;
            [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else
        {
            [btnTitle setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        imagePoint.hidden = !btnTitle.selected;
    }
}

-(void)viewAnimation:(UIView*)view
{
//    view.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, SCREEN_HEIGHT-_viewTitleBtn.frame.origin.y-_viewTitleBtn.frame.size.height-10-50);
//    [UIView animateWithDuration:1 animations:^{
//        view.frame = viewBackFrame;
//    } completion:^(BOOL finished) {
//        
//    }];
}

//跳转到看电影
-(void)ActivityJumpLookMovie:(UIButton *)btnTage
{
    [self onButtonTitle:btnTage];
}

#pragma mark 栏目btn事件
-(void)onButtonTitle:(UIButton*)btn
{
    for (int i = 0; i<4; i++)
    {
        UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(i+100)];
        UIImageView* imgPoint = (UIImageView*)[self.view viewWithTag:(i+200)];
        if (buttonTitle.tag == btn.tag)
        {
            [buttonTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else
        {
            [buttonTitle setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        if (imgPoint.tag == (btn.tag+100))
        {
            imgPoint.hidden = NO;
        }
        else
        {
            imgPoint.hidden = YES;
        }
    }
    
    switch (btn.tag)
    {
        case 100:
            [MobClick event:mainViewbtn22];
            //看电影
            _viewTitleBack1.hidden = NO;
            _viewTitleBack2.hidden = YES;
            _viewTitleBack3.hidden = YES;
//            _viewTitleBack3.btnPay.hidden = YES;
            _viewTitleBack4.hidden = YES;
//            _labelFooter.hidden = NO;
//            if (isAnimate)
//            {
//                [self viewAnimation:_viewTitleBack1];
//            }
            if (lastBtnTag != 100 && !_isHaveLoadData[0])
            {
                _isHaveLoadData[0] = YES;
                [self initMovieData];
            }
            break;
        case 101:
            //捡便宜
            [MobClick event:mainViewbtn60];
            _viewTitleBack1.hidden = YES;
            _viewTitleBack2.hidden = NO;
            _viewTitleBack3.hidden = YES;
//            _viewTitleBack3.btnPay.hidden = YES;
            _viewTitleBack4.hidden = YES;
//            _labelFooter.hidden = YES;
//            if (isAnimate)
//            {
//                [self viewAnimation:_viewTitleBack2];
//            }
            if (lastBtnTag != 101 && !_isHaveLoadData[1])
            {
                _isHaveLoadData[1] = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHCARD object:nil];
            }
            break;
        case 102:
            //小卖部
            [MobClick event:mainViewbtn92];
            _viewTitleBack1.hidden = YES;
            _viewTitleBack2.hidden = YES;
            _viewTitleBack3.hidden = NO;
//            if (_viewTitleBack3.arrSnack.count>0)
//            {
//                _viewTitleBack3.btnPay.hidden = NO;
//            }
//            else
//            {
//                _viewTitleBack3.btnPay.hidden = YES;
//            }
            _viewTitleBack4.hidden = YES;
//            _labelFooter.hidden = YES;
//            if (isAnimate)
//            {
//                [self viewAnimation:_viewTitleBack3];
//            }
            if (lastBtnTag != 102 && !_isHaveLoadData[2])
            {
                _isHaveLoadData[2] = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHGOODS object:nil];
            }
            break;
        case 103:
            //凑热闹
            [MobClick event:mainViewbtn114];
            _viewTitleBack1.hidden = YES;
            _viewTitleBack2.hidden = YES;
            _viewTitleBack3.hidden = YES;
//            _viewTitleBack3.btnPay.hidden = YES;
            _viewTitleBack4.hidden = NO;
//            _labelFooter.hidden = YES;
//            [self refreshViewBackFrame:123];
//            [self refreshFrameUp];
//            if (isAnimate)
//            {
//                [self viewAnimation:_viewTitleBack4];
//            }
            if (lastBtnTag != 103 && !_isHaveLoadData[3])
            {
                _isHaveLoadData[3] = YES;
               [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHACTIVITY object:nil];
            }
            break;
        default:
            break;
    }
    if (btn.tag != 103)
    {
        [_viewTitleBack4 removeAllObjectsActivity];
    }
    lastBtnTag = btn.tag;
}

#pragma mark 渲染影片列表UI
-(void)initMovieList
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];//
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,_viewTitleBack1.frame.size.height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_viewTitleBack1 addSubview:_collectionView];
    // 注册类，是用纯代码生成的collectiviewcell类才行
    //[_collectionView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"MovieCollectionViewCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [_collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    [_collectionView.header setTitle:@"" forState:MJRefreshHeaderStateRefreshing];
}

-(void)loadMoreData
{
    
}

-(void)refreshNewData
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    [ServicesMovie getHotMoviesByCinemaId:[Config getCinemaId] model:^(MovieListModel *model)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         _arrMovieData = model.hotMovieList;
         _arrCommingMovieData = model.comingSoonMovieList;
         [weakSelf collectionViewReloadData];
         [_collectionView.header endRefreshing];
     } failure:^(NSError *error) {
         if (error.code == noNetWorkCode)
         {
             [Tool showWarningTip:error.domain time:1.0];
         }
         else
         {
             [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         }
         [_collectionView.header endRefreshing];
         [weakSelf loadFailed];
     }];
}

-(void)initMovieData
{
    if (!_isHaveLoadData[0])
    {
        _isHaveLoadData[0] = YES;
    }
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMovie getHotMoviesByCinemaId:[Config getCinemaId] model:^(MovieListModel *model)
    {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         _arrMovieData = model.hotMovieList;
        _arrCommingMovieData = model.comingSoonMovieList;
        [weakSelf collectionViewReloadData];
//        _labelFooter.hidden = NO;
     } failure:^(NSError *error) {
         if ([[Config getCinemaId] length] == 0)
         {
             return ;
         }
         if (error.code == noNetWorkCode)
         {
             [Tool showWarningTip:error.domain time:1.0];
         }
         else
         {
             [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         }
         [weakSelf loadFailed];
//         _labelFooter.hidden = YES;
     }];
}

-(void)collectionViewReloadData
{
    if (_viewLoadFailed)
    {
        _viewLoadFailed.hidden = YES;
    }
    _collectionView.header.hidden = NO;
    [_collectionView reloadData];
}

-(void)tabIndex:(NSNotification*)noti
{
    NSDictionary* dict = [noti userInfo];
    int btnTag = [[dict objectForKey:@"tag"] intValue];
    if (btnTag == 3)
    {
        //凑热闹
        [_viewTitleBack4 setActivityId:[dict objectForKey:@"actId"]];
        lastBtnTag = 100;
    }
    UIButton* buttonTitle = (UIButton*)[self.view viewWithTag:(btnTag+100)];
    [self onButtonTitle:buttonTitle];
}

#pragma mark 加载失败 显示UI
-(void) loadFailed
{
    //加载失败
    _arrCommingMovieData = nil;
    _arrMovieData = nil;
    [_collectionView reloadData];
    _collectionView.header.hidden = YES;
    
    if (!_viewLoadFailed)
    {
        _viewLoadFailed = [[LoadFailedView alloc]initWithFrame:CGRectMake(0, 103, SCREEN_WIDTH, HEIGHT_FAILEDVIEW)];
        WeakSelf(ws);
        [_viewLoadFailed setRefreshData:^{
            [ws initMovieData];
        }];
        [_viewTitleBack1 addSubview:_viewLoadFailed];
    }
    else
    {
        _viewLoadFailed.hidden = NO;
    }
}

#pragma mark 打开会员中心
-(void)onButtonVipCenter
{

}

#pragma mark 打开小卖部
-(void)onButtonSale
{

}

#pragma mark 打开活动
-(void)onButtonActivity
{
    
}

#pragma mark scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>0)
    {
        if (_lastScrollContentOffset < scrollView.contentOffset.y)
        {
//                            NSLog(@"up:------%f\n%f",_lastScrollContentOffset,scrollView.contentOffset.y);
            //scroll向上滚动
            if (!_isScrollTop)
            {
                if (scrollView.contentOffset.y >= 30)
                {
                    if (!_isScrollTop)
                    {
                        NSLog(@"up:------%f\n%f",_lastScrollContentOffset,scrollView.contentOffset.y);
                        [self refreshFrameUp];
                    }
                }
                else if(scrollView.contentOffset.y < 30)
                {
                    _lastScrollContentOffset = scrollView.contentOffset.y;
                }
                else
                {
                    _lastScrollContentOffset = 30;
                }
            }
        }
        else if (_lastScrollContentOffset > scrollView.contentOffset.y)
        {
            //scroll向下滚动
//                            NSLog(@"down:------%f\n%f",_lastScrollContentOffset,scrollView.contentOffset.y);
            if (_isScrollTop)
            {
                NSLog(@"down:------%f\n%f",_lastScrollContentOffset,scrollView.contentOffset.y);
                //滑到顶
                [self refreshFrameDown];
            }
            _lastScrollContentOffset = scrollView.contentOffset.y;
        }
    }
    else if (scrollView.contentOffset.y<0)
    {
        if (_isScrollTop)
        {
            NSLog(@"down111:------%f\n%f",_lastScrollContentOffset,scrollView.contentOffset.y);
            //滑到顶
            [self refreshFrameDown];
        }
        _lastScrollContentOffset = scrollView.contentOffset.y;
    }
}

-(void)refreshFrameUp
{
    //_labelFooter.hidden = YES;
    CGRect rectTitle = CGRectMake(0, 80, SCREEN_WIDTH, 45);
    _viewCinemaFeature.hidden = YES;
    _imgArrow.hidden = YES;
    _btnCinema.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [UIView animateWithDuration:0.5 animations:^{
        _viewTitleBtn.frame = rectTitle;
        _headBigImage.frame = CGRectMake(0, 80-_headBigImage.frame.size.height, SCREEN_WIDTH, _headBigImage.frame.size.height);
        _headSmallImage.frame = CGRectMake(0, 80-_headSmallImage.frame.size.height, SCREEN_WIDTH, _headSmallImage.frame.size.height);
        _headAlphaView.alpha = 0.7;
        _headAlphaView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
        _btnCinema.frame = CGRectMake(60, (80-17)/2, SCREEN_WIDTH-120, 17);
        _btnScan.frame = CGRectMake(0, 25, 98/2, 60/2);
        _btnSearch.frame = CGRectMake(SCREEN_WIDTH-30-33/2, 25, 96/2, 60/2);
    } completion:^(BOOL finished) {
//        _headBigImage.hidden = YES;
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self refreshTableFrame:rectTitle];
        
    } completion:^(BOOL finished) {
        //_labelFooter.hidden = NO;
    }];
    
    _isScrollTop = YES;
    _viewTitleBack2._isScrollTop = YES;
    _viewTitleBack3._isScrollTop = YES;
    _viewTitleBack4._isScrollTop = YES;
    
    _collectionView.header.hidden = YES;
}

-(void)refreshFrameDown
{
    //_labelFooter.hidden = YES;
    CGRect rectTitle = CGRectMake(0,203, SCREEN_WIDTH, 45);

    _btnCinema.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [UIView animateWithDuration:0.5 animations:^{
        _viewTitleBtn.frame = rectTitle;
//        _headBigImage.hidden = NO;
//        _headSmallImage.hidden = NO;
        _imgArrow.hidden = NO;
        _headSmallImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, 143);
        NSLog(@"%f",_headBigImage.frame.size.height);
        _headBigImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, _headBigImage.frame.size.height);
        _headAlphaView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 143);
        _headAlphaView.alpha = 0.5;
        _btnCinema.frame = CGRectMake(15, 85, SCREEN_WIDTH-15, 17);
        _btnScan.frame = CGRectMake(0, 25, 98/2, 60/2);
        _btnSearch.frame = CGRectMake(SCREEN_WIDTH-30-33/2, 25, 96/2, 60/2);
        
    } completion:^(BOOL finished) {
        _viewCinemaFeature.hidden = NO;
        //_labelFooter.hidden = NO;
        _collectionView.header.hidden = NO;
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self refreshTableFrame:rectTitle];
        
    } completion:^(BOOL finished) {
        //_labelFooter.hidden = NO;
    }];

    
    _isScrollTop = NO;
    _viewTitleBack2._isScrollTop = NO;
    _viewTitleBack3._isScrollTop = NO;
    _viewTitleBack4._isScrollTop = NO;
}

-(void)refreshTableFrame:(CGRect)rect
{
    viewBackFrame = CGRectMake(0, rect.origin.y+rect.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-rect.origin.y-rect.size.height);
    
    _viewTitleBack1.frame = viewBackFrame;
    _collectionView.frame = CGRectMake(0, 0, _collectionView.frame.size.width, viewBackFrame.size.height);
    
    _viewTitleBack2.frame = viewBackFrame;
    _viewTitleBack2.tabViewMembershipCard.frame = CGRectMake(0, 0, _viewTitleBack2.tabViewMembershipCard.frame.size.width, viewBackFrame.size.height);
    
    _viewTitleBack3.frame = viewBackFrame;
    _viewTitleBack3.myTable.frame = CGRectMake(_viewTitleBack3.myTable.frame.origin.x, _viewTitleBack3.myTable.frame.origin.y, _viewTitleBack3.myTable.frame.size.width, viewBackFrame.size.height);
    _viewTitleBack3.btnPay.frame = CGRectMake(15, _viewTitleBack3.frame.size.height-27-48-tabbarHeight, 48, 48);
    
    _viewTitleBack4.frame = viewBackFrame;
    _viewTitleBack4.tableViewActive.frame = CGRectMake(_viewTitleBack4.tableViewActive.frame.origin.x, _viewTitleBack4.tableViewActive.frame.origin.y, _viewTitleBack4.tableViewActive.frame.size.width, viewBackFrame.size.height);

    if (_collectionView.contentOffset.y >= 30)
    {
        _lastScrollContentOffset = 30;
    }
    else
    {
        _lastScrollContentOffset = _collectionView.contentOffset.y;
    }
    if (_viewTitleBack2.tabViewMembershipCard.contentOffset.y >= 30)
    {
        _viewTitleBack2._lastScrollContentOffset = 30;
    }
    else
    {
        _viewTitleBack2._lastScrollContentOffset = _viewTitleBack2.tabViewMembershipCard.contentOffset.y;
    }
    if (_viewTitleBack3.myTable.contentOffset.y >= 30)
    {
        _viewTitleBack3._lastScrollContentOffset = 30;
    }
    else
    {
        _viewTitleBack3._lastScrollContentOffset = _viewTitleBack2.tabViewMembershipCard.contentOffset.y;
    }
    
}

#pragma mark - UICollectionViewDataSource
// 指定Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_arrCommingMovieData.count>0 && _arrMovieData.count>0)
    {
        return 2;
    }
    else if (_arrCommingMovieData.count==0 && _arrMovieData.count==0)
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

// 指定section中的collectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_arrMovieData.count>0)
    {
        if (section == 0)
        {
            if (_arrMovieData.count%2 == 0)
            {
                //双数电影
                return _arrMovieData.count;
            }
            else
            {
                return _arrMovieData.count+1;
            }
        }
        else
        {
            if (_arrCommingMovieData.count%2 == 0)
            {
                //双数电影
                return _arrCommingMovieData.count;
            }
            else
            {
                return _arrCommingMovieData.count+1;
            }
        }
    }
    else
    {
        if (_arrCommingMovieData.count%2 == 0)
        {
            //双数电影
            return _arrCommingMovieData.count;
        }
        else
        {
            return _arrCommingMovieData.count+1;
        }
    }
}

// 配置section中的collectionViewCell的显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    if (identifier == nil)
    {
        identifier = [NSString stringWithFormat:@"MovieCollectionViewCell%@",[NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [_collectionView registerClass:[MovieCollectionViewCell class]  forCellWithReuseIdentifier:identifier];
    }
    
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    cell.cellDelegate = self;
    cell.backgroundColor = [UIColor whiteColor];
    BOOL isLeft = NO;
    if (indexPath.row%2 == 0)
    {
        isLeft = YES;
    }
    if (_arrMovieData.count>0)
    {
        if (indexPath.section == 0)
        {
            if (_arrMovieData.count%2 != 0 && indexPath.row == _arrMovieData.count)
            {
                [cell setData:nil isNoMore:YES];
            }
            else
            {
                cell.isHotMovie = YES;
                [cell setData:_arrMovieData[indexPath.row] isNoMore:NO];
                [cell layoutFrame:isLeft];
            }
        }
        else
        {
            if (_arrCommingMovieData.count%2 != 0 && indexPath.row == _arrCommingMovieData.count)
            {
                [cell setData:nil isNoMore:YES];
            }
            else
            {
                cell.isHotMovie = NO;
                [cell setData:_arrCommingMovieData[indexPath.row] isNoMore:NO];
                [cell layoutFrame:isLeft];
            }
        }
    }
    else
    {
        if (_arrCommingMovieData.count%2 != 0 && indexPath.row == _arrCommingMovieData.count)
        {
            [cell setData:nil isNoMore:YES];
        }
        else
        {
            cell.isHotMovie = NO;
            [cell setData:_arrCommingMovieData[indexPath.row] isNoMore:NO];
            [cell layoutFrame:isLeft];
        }
    }
    
    return cell;
}

-(void)buyTicket:(MovieModel *)model
{
    [MobClick event:mainViewbtn23];
    ShowTimeViewController* showTimeVC = [[ShowTimeViewController alloc]init];
    showTimeVC.hotMovieModel = model;
    [self.navigationController pushViewController:showTimeVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat logoWidth = SCREEN_WIDTH/2;
    CGFloat logoHeight = logoWidth * LOGOSCALE;
    return CGSizeMake(SCREEN_WIDTH/2, logoHeight);
}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%ld",(long)indexPath.row);
    if (_arrMovieData.count>0)
    {
        if (indexPath.section == 0)
        {
            if (_arrMovieData.count%2 != 0 && indexPath.row == _arrMovieData.count)
            {
                return;
            }
        }
        else
        {
            if (_arrCommingMovieData.count%2 != 0 && indexPath.row == _arrCommingMovieData.count)
            {
                return;
            }
        }
    }
    else
    {
        if (_arrCommingMovieData.count%2 != 0 && indexPath.row == _arrCommingMovieData.count)
        {
            return;
        }
    }
    
    [MobClick event:mainViewbtn117];
    
    MoviePosterViewController* poster = [[MoviePosterViewController alloc]init];
    poster.arrMovieData = _arrMovieData;
    poster.arrCommingMovieData = _arrCommingMovieData;
  
    if (_arrMovieData.count == 0)
    {
        //没有正在上映电影
        poster.currentIndex = indexPath.row;
    }
    else
    {
        if (indexPath.section == 0)
        {
            poster.currentIndex = indexPath.row;
        }
        else
        {
            poster.currentIndex = indexPath.row+_arrMovieData.count;
        }
    }
    
    [self.navigationController pushViewController:poster animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return CGSizeMake(320, 49);
    }else{
        return CGSizeMake(320, 39);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (_arrMovieData.count>0 && _arrCommingMovieData.count>0)
    {
        if (section == 0)
        {
            return CGSizeZero;
        }
        else
        {
            return CGSizeMake(SCREEN_WIDTH, 100);
        }
    }
    else if (_arrMovieData.count>0 || _arrCommingMovieData.count>0)
    {
        return CGSizeMake(SCREEN_WIDTH, 100);
    }
    else
    {
        return CGSizeZero;
    }
}

#pragma mark 头部显示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                                UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        for (UIView* vV in headerView.subviews)
        {
            [vV removeFromSuperview];
        }
        UIView* headerBackView = [[UIView alloc]initWithFrame:CGRectZero];
        [headerBackView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel* headerTitle = [[UILabel alloc]initWithFrame:CGRectZero];
        headerTitle.textColor = RGBA(123, 122, 152, 1);
        headerTitle.font = MKFONT(12);
        
        UIImageView* headerImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        if (indexPath.section == 0)
        {
            NSString *title = @"正在热映";
            headerBackView.frame = CGRectMake(0, 10, SCREEN_WIDTH, 39);
            headerTitle.frame = CGRectMake(15, 27, [Tool boundingRectWithSize:title textFont:MKFONT(12) textSize:CGSizeMake(MAXFLOAT, 12)].width, 12);
            headerImage.frame = CGRectMake(headerTitle.frame.origin.x+headerTitle.frame.size.width+5, 26.5, 11, 13);
            headerImage.image = [UIImage imageNamed:@"img_playing.png"];
            if (_arrMovieData.count == 0)
            {
                title = @"即将上映";
                headerImage.frame = CGRectMake(headerTitle.frame.origin.x+headerTitle.frame.size.width+5, 26.5, 10, 13);
                headerImage.image = [UIImage imageNamed:@"img_willplay.png"];
            }
            headerTitle.text = title;
            
        }
        else
        {
            NSString *title = @"即将上映";
            headerBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 39);
            headerTitle.frame = CGRectMake(15, 17, [Tool boundingRectWithSize:title textFont:MKFONT(12) textSize:CGSizeMake(MAXFLOAT, 12)].width, 12);
            headerImage.frame = CGRectMake(headerTitle.frame.origin.x+headerTitle.frame.size.width+5, 16.5, 10, 13);
            
            headerTitle.text = title;
            headerImage.image = [UIImage imageNamed:@"img_willplay.png"];
        }
        
        [headerView addSubview:headerBackView];
        [headerView addSubview:headerTitle];
        [headerView addSubview:headerImage];
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        UILabel* footerTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 12)];
        footerTitle.text = @"呃～没有更多了";
        [footerTitle setFont:MKFONT(12)];
        footerTitle.textAlignment = NSTextAlignmentCenter;
        [footerTitle setTextColor:RGBA(180, 180, 180, 1)];
        [footerview addSubview:footerTitle];
        reusableview = footerview;
    }
    return reusableview;
}

//-(UILabel *)footerLabel
//{
//    if (_footerTitle == nil)
//    {
//        _footerTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 12)];
//        _footerTitle.text = @"呃～没有更多了";
//        [_footerTitle setFont:MKFONT(12)];
//        _footerTitle.textAlignment = NSTextAlignmentCenter;
//        [_footerTitle setTextColor:RGBA(180, 180, 180, 1)];
//    }
//    return _footerTitle;
//}

//-(UIView *)headerBackView
//{
//    if (_headerBackView == nil)
//    {
//        _headerBackView = [[UIView alloc]initWithFrame:CGRectZero];
//        [_headerBackView setBackgroundColor:[UIColor whiteColor]];
//    }
//    return _headerBackView;
//}
//
//- (UILabel *)headerLabel
//{
//    if (_headerTitle == nil)
//    {
//        CGSize sizeHeaderLabel = [Tool boundingRectWithSize:@"正在热映" textFont:MKFONT(12) textSize:CGSizeMake(MAXFLOAT, 12)];
//        _headerTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, sizeHeaderLabel.width, 12)];
//        _headerTitle.textColor = RGBA(123, 122, 152, 1);
//        _headerTitle.font = MKFONT(12);
//    }
//    return _headerTitle;
//}
//
//- (UIImageView *)headerImage
//{
//    if (_headerImage == nil)
//    {
//        _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(_headerTitle.frame.origin.x+_headerTitle.frame.size.width+5, 16.5, 9, 13)];
//    }
//    return _headerImage;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 打开影院详情view
-(void)showCinemaDetailView
{
    [Tool hideTabBar];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_REFRESHCINEMAHOME];
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_REMOVEHOMEDATA];
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_HOMETOTAB];
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_REFRESHHOMEUP];
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_REFRESHHOMEDOWN];
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_SHOWCINEMAVIEWMSG];
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_SHOWWAKEUPAPPNOTICE];
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_APNSNOTIFICATION];
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_LOADSYSTEMNOTICE];
    
}

@end
