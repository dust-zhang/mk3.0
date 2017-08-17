//
//  AppDelegate.h
//  supercinema
//
//  Created by dust on 16/7/28.
//
//

#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "BootAnimationView.h"
#import "UpdateView.h"
#import <notify.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate,GeTuiSdkDelegate,WXApiDelegate,UNUserNotificationCenterDelegate>
{
    UINavigationController  *_navCinemaController;
    UINavigationController  *_navGameController;
    UINavigationController  *_navUserCenterController;
    TencentOAuth            *_tencentOAuth;
    //TabBar的切换按钮
    UIButton                *_btnTabBar[3];
    UIImageView             *_imageTabBar[3];
    UILabel                 *_labelTabBar[3];
    
    BootAnimationView       *_startAnimationView;
    
    NSTimer                 *_timer;
    int                     _countTime;
}

@property (strong, nonatomic) UIWindow          *window;
@property (strong, nonatomic) UIView            *_tabBarView;
//@property (strong, nonatomic) UIImageView       *_imageSmallPer;
@property (strong, nonatomic) NSDictionary      *apnsDict;
// 用来判断是否是通过点击通知栏开启（唤醒）APP
@property (nonatomic) BOOL isLaunchedByNotification;

-(void)switchTab:(int)index;

@end

