//
//  AppDelegate.m
//  supercinema
//
//  Created by dust on 16/7/28.
//
//

#import "AppDelegate.h"
#import "CinemaFilmViewController.h"
#import "UserCenterViewController.h"
#import "GameViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [Config saveEveryPull:@"YES"];
    // 通过个推平台分配的 appId、 appKey 、appSecret 启动 SDK,注: 该方法需要在主线程中调用
//    if ([URL_NEWADDRESS isEqualToString:@"http://acs.movikr.com:10080/api2"])
//    {
//        [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
//    }
//    else
//    {
//        //测试环境
//        [GeTuiSdk startSdkWithAppId:kGtAppIdtest appKey:kGtAppKeytest appSecret:kGtAppSecrettest delegate:self];
//    }
    [self umengTrack];
    //高德地图
    [AMapServices sharedServices].apiKey = GaoDeMapkey;
    // 注册 APNS
    [self registerUserNotification];
    [self clearBadge];
    //创建tabbar
    [self initTabbar];
    //加载开机动画
    [self loadStarAnimation];
    //集成第三方登录
    [self initShareSdkKey];
    //检查版本更新
    [self checkVersion];
    //监测锁屏解锁
//    [self monitorLock];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabIndex:) name:NOTIFITION_HOMETABBAR object:nil];
    
    return YES;
}

//-(void) monitorLock
//{
//    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, screenLockStateChanged, NotificationLock, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
//    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, screenLockStateChanged, NotificationChange, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
//}

//static void screenLockStateChanged(CFNotificationCenterRef center,void* observer,CFStringRef name,const void* object,CFDictionaryRef userInfo)
//{
//    NSString* lockstate = (__bridge NSString*)name;
//    if (![lockstate isEqualToString:(__bridge  NSString*)NotificationLock])
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_RELOADCOUNTTIME object:nil];
//    }
//}

- (void)umengTrack
{
    UMConfigInstance.appKey = YOUMENGAPIKEY;
    //配置以上参数后调用此方法初始化SDK！
    [MobClick startWithConfigure:UMConfigInstance];
}

-(void) checkVersion
{
    [ServicesSystem getVersionInfo:^(NSDictionary *versionModel)
     {
         if( [[versionModel objectForKey:@"needUpdate" ] intValue] == 1)
         {
             [self openVersionUpdate:versionModel];
         }
         
         //如果保存的版本信息不是2.6.2版本  只执行一次
         NSLog(@"%@",[Config getVersion]);
         if (![ [Config getVersion] isEqualToString:[Tool getAppVersion] ])
         {
             if(![sqlDatabase dropTable:@"table_notice"])
             {
                 NSLog(@"删除table_notice失败");
             }
         }
         [Config saveVersion:[Tool getAppVersion]];
         
     } failure:^(NSError *error) {
     }];
}

-(void)openVersionUpdate:(NSDictionary*)version
{
    UpdateView *updateView = [[UpdateView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) dic:version showHideBackBtn:YES];
    [self.window addSubview:updateView];
}

-(void) loadStarAnimation
{
    _startAnimationView = [[BootAnimationView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.window.screen.bounds.size.height)];
    [self.window addSubview:_startAnimationView];
    [self.window bringSubviewToFront:_startAnimationView];
}

-(void)tabIndex:(NSNotification*)noti
{
    NSDictionary* dict = [noti userInfo];
    int btnTag = [[dict objectForKey:@"tag"] intValue];
    UIButton* buttonTitle = (UIButton*)[self._tabBarView viewWithTag:(btnTag+1000)];
    [self clickBtnTabBar:buttonTitle];
}

-(void) initTabbar
{
    NSArray *tabImageLight = [NSArray arrayWithObjects:@"tab_mainIcon_b.png",@"tab_gameIcon_d.png",@"tab_meIcon_d.png", nil];
    NSArray *tabLabelName = [NSArray arrayWithObjects:@"首页",@"福利社",@"我的", nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self._tabBarView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-tabbarHeight, SCREEN_WIDTH,tabbarHeight)];
    //影院
    CinemaFilmViewController *cinemaFilmController = [[CinemaFilmViewController alloc] init];
    _navCinemaController = [[UINavigationController alloc] initWithRootViewController:cinemaFilmController];
    [_navCinemaController setNavigationBarHidden:YES];
    //消遣
    GameViewController *GameController = [[GameViewController alloc] init];
    _navGameController = [[UINavigationController alloc] initWithRootViewController:GameController];
    [_navGameController setNavigationBarHidden:YES];
    //个人中心
    UserCenterViewController *userCenterController = [[UserCenterViewController alloc] init];
    _navUserCenterController = [[UINavigationController alloc] initWithRootViewController:userCenterController];
    [_navUserCenterController setNavigationBarHidden:YES];
    
    [self.window setRootViewController:_navCinemaController];
    [self.window makeKeyAndVisible];
    
    [Config saveTabbarStatus:@"1"];
    
    for (int i = 0; i < [tabImageLight count]; i++)
    {
        //点击的按钮
        _btnTabBar[i] = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTabBar[i].frame = CGRectMake((SCREEN_WIDTH/[tabImageLight count])*i, 0, SCREEN_WIDTH /[tabImageLight count], tabbarHeight);
        [_btnTabBar[i] setBackgroundColor:RGBA(0, 0, 0, 0.9)];
        _btnTabBar[i].tag=1000+i;
        [_btnTabBar[i] addTarget:self action:@selector(clickBtnTabBar:) forControlEvents:UIControlEventTouchUpInside];
        [self._tabBarView addSubview:_btnTabBar[i]];
        
        //按钮上的图片
        _imageTabBar[i] = [[UIImageView alloc] initWithFrame:CGRectMake((_btnTabBar[i].frame.size.width-21)/2, 3.3, 21, 21)];
        _imageTabBar[i].backgroundColor = [UIColor clearColor];
        [_imageTabBar[i] setImage:[UIImage imageNamed:tabImageLight[i] ]];
        [_btnTabBar[i] addSubview:_imageTabBar[i]];
        
        NSLog(@"%f",(SCREEN_WIDTH/3)*i);
        //按钮上的文字
        _labelTabBar[i] = [[UILabel alloc] initWithFrame:CGRectMake( (SCREEN_WIDTH/3)*i, 3.3*2+21, SCREEN_WIDTH/3, 14)];
        _labelTabBar[i].backgroundColor = [UIColor clearColor];
        [_labelTabBar[i] setFont:MKFONT(14)];
        if (i == 0)
        {
            [_labelTabBar[i] setTextColor:RGBA(255, 255, 255, 1)];
        }
        else
        {
            [_labelTabBar[i] setTextColor:RGBA(255, 255, 255, 0.4)];
        }
        [_labelTabBar[i] setTextAlignment:NSTextAlignmentCenter];//文字居中对齐
        [_labelTabBar[i] setText:tabLabelName[i]];
        [self._tabBarView addSubview:_labelTabBar[i]];
    }
    [self.window addSubview:self._tabBarView];
    [self.window bringSubviewToFront:self._tabBarView];
}

-(void)switchTab:(int)index{
    UIButton *button = _btnTabBar[index];
    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)clickBtnTabBar:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 1000:
        {
            [_imageTabBar[0] setImage:[UIImage imageNamed:@"tab_mainIcon_b.png" ]];
            [_imageTabBar[1] setImage:[UIImage imageNamed:@"tab_gameIcon_d.png" ]];
            [_imageTabBar[2] setImage:[UIImage imageNamed:@"tab_meIcon_d.png" ]];
            
            [_labelTabBar[0] setTextColor:RGBA(255, 255, 255, 1)];
            [_labelTabBar[1] setTextColor:RGBA(255, 255, 255, 0.4)];
            [_labelTabBar[2] setTextColor:RGBA(255, 255, 255, 0.4)];
            
            [self.window setRootViewController:_navCinemaController];
            [Config saveTabbarStatus:@"1"];
        }
            break;
        case 1001:
        {
            [_imageTabBar[0] setImage:[UIImage imageNamed:@"tab_mainIcon_d.png" ]];
            [_imageTabBar[1] setImage:[UIImage imageNamed:@"tab_gameIcon_b.png" ]];
            [_imageTabBar[2] setImage:[UIImage imageNamed:@"tab_meIcon_d.png" ]];
            
            [_labelTabBar[0] setTextColor:RGBA(255, 255, 255, 0.4)];
            [_labelTabBar[1] setTextColor:RGBA(255, 255, 255, 1)];
            [_labelTabBar[2] setTextColor:RGBA(255, 255, 255, 0.4)];
            
            [self.window setRootViewController:_navGameController];
            [Config saveTabbarStatus:@"2"];
            [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_GAMESTATUS object:nil];
            [self reloadGameData];
        }
            break;
        case 1002:
        {
            [_imageTabBar[0] setImage:[UIImage imageNamed:@"tab_mainIcon_d.png" ]];
            [_imageTabBar[1] setImage:[UIImage imageNamed:@"tab_gameIcon_d.png" ]];
            [_imageTabBar[2] setImage:[UIImage imageNamed:@"tab_meIcon_b.png" ]];
            
            [_labelTabBar[0] setTextColor:RGBA(255, 255, 255, 0.4)];
            [_labelTabBar[1] setTextColor:RGBA(255, 255, 255, 0.4)];
            [_labelTabBar[2] setTextColor:RGBA(255, 255, 255, 1)];
            
            [self.window setRootViewController:_navUserCenterController];
            [Config saveTabbarStatus:@"3"];
        }
            break;
        default:
            break;
    }
    [self.window bringSubviewToFront:self._tabBarView];
}

#pragma mark    处理分享
-(void) initShareSdkKey
{
    //微信支付
    [WXApi registerApp:backWeChatPayAppId withDescription:@"movikr"];
    //新浪微博注册
    [WeiboSDK enableDebugMode:NO];
    [WeiboSDK registerApp:regitserWeiBoAppId];
    //QQ注册
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:regitserTencentAppId andDelegate:(id)[ShareView getShareInstance]];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if([url.scheme isEqualToString:backWeChatPayAppId])
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if([url.scheme isEqualToString:backWeiBoAppId])
    {
        return [WeiboSDK handleOpenURL:url delegate:(id)[ShareView getShareInstance]];
    }
    else if([url.scheme isEqualToString:backQQAppId])
    {
        if ([TencentOAuth CanHandleOpenURL:url])
        {
            return [TencentOAuth HandleOpenURL:url];
        }
        else
        {
            return [QQApiInterface handleOpenURL:url delegate:(id)[ShareView getShareInstance]];
        }
    }
    else if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
         {
             NSLog(@"result = %@",resultDic);
             //支付成功（同理可以根据状态码判断其他的状态）
             if([resultDic[@"resultStatus"] floatValue] == 9000)
             {
                 //返回状态
                 [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_ALIPAYSUCCESS object:nil];
             }
         }];
    }
    else if ([url.host isEqualToString:@"platformapi"])
    {
        //支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic)
         {
             NSLog(@"result = %@",resultDic);
         }];
    }
    
    return YES;
}

//#pragma mark 微信支付返回结果
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]])
    {
        switch (resp.errCode)
        {
            case WXSuccess:
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_WEIXINPAYSUCCESS object:nil];
                break;
            default:
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    else
    {
        [[ShareView getShareInstance] onResponse:resp];
    }
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if([url.scheme isEqualToString:backWeiBoAppId])
    {
        return [WeiboSDK handleOpenURL:url delegate:(id)[ShareView getShareInstance]];
    }
    else if([url.scheme isEqualToString:backQQAppId])
    {
        if ([TencentOAuth CanHandleOpenURL:url])
        {
            return [TencentOAuth HandleOpenURL:url];
        }
        else
        {
            return [QQApiInterface handleOpenURL:url delegate:(id)[ShareView getShareInstance]];
        }
    }
    return YES;
}

#pragma mark - 用户通知(推送) _自定义方法
/** 注册用户通知 */
- (void)registerUserNotification
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

-(void)postAPNSNotify
{
    [self stopTimer];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_APNSNOTIFICATION object:nil userInfo:self.apnsDict];
}

-(void)clearBadge
{
    //获取应用程序消息通知标记数（即小红圈中的数字）
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge>0)
    {
        //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

#pragma mark - 用户通知(推送)回调 _IOS 8.0以上使用
/** 已登记用户通知 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // 注册远程通知（推送）
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [GeTuiSdk registerDeviceToken:myToken];
    [Config setDeviceToken:myToken];
    //    if (![Config isFirstStartUp])
    //    {
    [ServicesSystem  getSystemConfig:[Config getDeviceToken] clientId:[Config getGeTuiId] model:^(RequestResult *model)
     {
         
     } failure:^(NSError *error) {
         
     }];
    //    }
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", myToken);
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [GeTuiSdk registerDeviceToken:@""];
    NSLog(@"\n>>>[DeviceToken Error]:%@\n\n", error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理 - iOS 10以下版本收到推送

/** APP已经接收到“远程”通知(推送) - (App运行在后台)  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        return;
    }
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    [self apnsHandleUserInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - iOS 10中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {

}

//  iOS 10: 点击通知进入App时触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    [self apnsHandleUserInfo:response.notification.request.content.userInfo];
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}
#endif


-(void)apnsHandleUserInfo:(NSDictionary*)userInfo
{
    [self clearBadge];
    if (userInfo)
    {
        NSError* error;
        NSDictionary* notifyDict = [userInfo objectForKey:@"aps"];
        NSString* category = [notifyDict objectForKey:@"category"];
        if (category.length>0)
        {
            NSDictionary* dictCategory = [NSJSONSerialization JSONObjectWithData:[category dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
            NSString* content = [dictCategory objectForKey:@"content"];
            if (content.length>0)
            {
                self.apnsDict = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(checkIsShowHome:)
                                                        userInfo:nil
                                                         repeats:YES];
                _countTime = 0;
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                         beforeDate:[NSDate dateWithTimeIntervalSinceNow:15]];
                //                [self performSelector:@selector(postAPNSNotify) withObject:nil afterDelay:3];
            }
        }
    }
}

-(void)checkIsShowHome:(NSTimer*) timer
{
    _countTime += 2;
    if (_countTime >= 15)
    {
        [self stopTimer];
    }
    else
    {
        //1首页 2福利社 3个人中心
        NSInteger btnTag = [[Config getTabbarStatus] integerValue];
        if (btnTag == 1)
        {
            //首页
            NSString* strHome = NSStringFromClass([_navCinemaController.topViewController class]);
            if (![strHome isEqualToString:@"CinemaFilmViewController"])
            {
                [_navCinemaController popToRootViewControllerAnimated:YES];
            }
        }
        else if (btnTag == 2)
        {
            //福利社
            NSString* strHome = NSStringFromClass([_navGameController.topViewController class]);
            if (![strHome isEqualToString:@"GameViewController"])
            {
                [_navGameController popToRootViewControllerAnimated:YES];
            }
        }
        else if (btnTag == 3)
        {
            //个人中心
            NSString* strHome = NSStringFromClass([_navUserCenterController.topViewController class]);
            if (![strHome isEqualToString:@"UserCenterViewController"])
            {
                [_navUserCenterController popToRootViewControllerAnimated:YES];
            }
        }
        [self postAPNSNotify];
    }
}

-(void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - GeTuiSdkDelegate
/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    [Config setGeTuiId:clientId];
    //首次启动APP设置
    if (![Config isFirstStartUp])
    {
        [Config saveIsFirstStartUp:@"NO"];
        [ServicesSystem firstStartApp:clientId mdoel:^(RequestResult *model)
         {
             
         } failure:^(NSError *error) {
             NSLog(@"firstStartApp Error: %@", error);
         }];
        
        [ServicesSystem  getSystemConfig:[Config getDeviceToken] clientId:[Config getGeTuiId] model:^(RequestResult *model)
         {
             
         } failure:^(NSError *error) {
             
         }];
    }
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%@",[Tool getSystemTime]);
    //保存当前系统时间
    [Config saveClickHomeLockScreenSystemTime:[Tool getSystemTime]];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_CLOSEBROADVIEW object:nil];
}
#pragma mark 唤起app
-(void)applicationWillEnterForeground:(UIApplication *)application
{
    [self reloadGameData];
    //拉取本地通知
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_SHOWWAKEUPAPPNOTICE object:nil];
    //暂停播放视频
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_PAUSEPLAYVIDEO object:nil];
    //从后台唤起app跳到登陆页,显示隐藏第三方登陆图标
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_BACKGROUNDTOLOGIN object:nil];
    //继续播放视频
    if(SYSTEMVERSION <8.5)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_CONTINUEPLAY object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_RELOADCOUNTTIME object:nil];
    
    [self clearBadge];
}

-(void) reloadGameData
{
    NSLog(@"%@   %@",[Tool getSystemTime],[Config getClickHomeLockScreenSystemTime]);
    if ([[Config getClickHomeLockScreenSystemTime] intValue] == 0)
    {
        return;
    }
    NSInteger timeLength = ([[Tool getSystemTime] integerValue] -  [[Config getClickHomeLockScreenSystemTime] integerValue])/1000;
    //判断程序上次退到后台时间到打开时间间隔(30分钟)
    if(timeLength >= 15*60)
    {
        [Config saveClickHomeLockScreenSystemTime:@0];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_REFRESHGAME object:nil];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_HOMETABBAR];
}

@end
