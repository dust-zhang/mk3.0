//
//  Macroh
//  movikr
//
//  Created by Mapollo27 on 15/5/29.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#define IPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(320, 640), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size)) : NO)
#define IPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
#define IPhone7 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1440,2560), [[UIScreen mainScreen] currentMode].size)) : NO)
#define IPhone7plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) : NO)

#define     SYSTEMVERSION          [[[UIDevice currentDevice] systemVersion] floatValue]
//获取屏幕宽度
#define     SCREEN_WIDTH           [[UIScreen mainScreen] bounds].size.width
//获取屏幕高度
#define     SCREEN_HEIGHT          [[UIScreen mainScreen] bounds].size.height
//加载失败view高度
#define     HEIGHT_FAILEDVIEW       145
//数组是否为空
#define     ARRAY_IS_EMPTY(array)  ((!array ||[array count] == 0)? 1: 0)
#define     WeakSelf(weakSelf)      __weak __typeof(&*self)weakSelf = self;

//分享相关
#define kRedirectURI                                    @"https://api.weibo.com/oauth2/default.html"
#define regitserTencentAppId                            @"1105320255"
#define regitserWeiBoAppId                              @"2064903752"
//back app
#define backQQAppId                                     @"tencent1105320255"// 1104738515
#define backWeiBoAppId                                  @"wb2064903752"
#define backWeChatAppId                                 @"wxd447d04ec517900e"
#define backWeChatPayAppId                              @"wxd4c28df834d37a82"
#define weChatAppSecret                                 @"699d987aff0b1bcd4188f07458e6c5e7"
/// 个推开发者网站中申请 App 时注册的 AppId、AppKey、AppSecret
#define kGtAppId                                        @"YO1xZmjLhFA0zTqyJhQnt"
#define kGtAppKey                                       @"UUavhQisix9JAhwZj39x59"
#define kGtAppSecret                                    @"JCLENT1AY79qgZKrZj1zu1"
//测试推送使用
#define kGtAppIdtest                                    @"U4CDlKD2FGAjDWkRFis5E"
#define kGtAppKeytest                                   @"Ho75lgasJ56LxfpV4F9Ia2"
#define kGtAppSecrettest                                @"U1AuQDl6A18p17zwoV35UA"
//听云key
#define TINGYUNAPIKEY                                   @"5532054cea6d48759861fa7e4694038d"
//友盟key
#define YOUMENGAPIKEY                                   @"5593474a67e58e43d9006c95"
//支付宝
#define RbackParameter                                  @"zhifubao.movikr"
//apple pay
#define MerchantId                                      @"merchant.com.movikrapplepay"
//高德地图
#define GaoDeMapkey                                     @"d8ecd100797dff28af894a51d4d08de7"
//微博账号
#define ShareToWeiboOfAccount                           @"(来自@超级电影院官微)"
//图片分享到微信时候的默认文件名
#define shareImageToWeixinDefaultImageTitle             @"超级电影院"
//请求错误时候的提示语
#define requestErrorTip                                 @"世界上最遥远的距离就是没网"
#define NoMoreData                                      @""
//系统推送通知
#define     NOTIFITION_APNSNOTIFICATION                 @"notifition_nsNotification"
#define     NOTIFITION_REFRESHHOMELOADBOOL              @"notifition_refreshHomeLoadBool"
//首页切换tab
#define     NOTIFITION_HOMETABBAR                       @"notifition_homeTabBar"
//刷新影院首页
#define     NOTIFITION_REFRESHCINEMAHOME                @"notifition_refreshCinemaHome"
//清掉首页数据
#define     NOTIFITION_REMOVEHOMEDATA                   @"notifition_removeHomeData"
//跳到影院首页 切换到对应的tab
#define     NOTIFITION_HOMETOTAB                        @"notifition_homeToTab"
//首页刷新导航frame up
#define     NOTIFITION_REFRESHHOMEUP                    @"notifition_refreshHomeUp"
//首页刷新导航frame down
#define     NOTIFITION_REFRESHHOMEDOWN                  @"notifition_refreshHomeDown"
//取消订单成功
#define     NOTIFITION_CANCELORDERSUCCESS               @"notifition_cancelOrderSuccess"
//取消订单失败
#define     NOTIFITION_CANCELORDERFAILED                @"notifition_cancelOrderFailed"
//继续支付
#define     NOTIFITION_CONTINUEPAY                      @"notifition_continuePay"
//微信支付成功
#define     NOTIFITION_WEIXINPAYSUCCESS                 @"notifition_weixinpaysuccess"
//支付宝支付成功
#define     NOTIFITION_ALIPAYSUCCESS                    @"notifition_alipaysuccess"
//刷新小卖页
#define     NOTIFITION_REFRESHSMALLSALE                 @"notifition_refreshSmallSale"
//刷新座位图
#define     NOTIFITION_REFRESHSEATS                     @"notifition_refreshSeats"
//刷新动态页
#define     NOTIFITION_REFRESHDYNLIST                   @"notifition_refreshDynList"
//微信支付成功
#define     NOTIFITION_WEIXINPAYSUCCESS                 @"notifition_weixinpaysuccess"
//刷新凑热闹
#define     NOTIFITION_REFRESHACTIVITY                  @"notifition_refreshActity"
//刷新捡便宜
#define     NOTIFITION_REFRESHCARD                      @"notifition_refreshCard"
//刷新小卖部
#define     NOTIFITION_REFRESHGOODS                     @"notifition_refreshGoods"
//刷新关注用户
#define     NOTIFITION_FOLLOWUSER                       @"notifition_followUser"
//刷新取消关注用户
#define     NOTIFITION_CANCELFOLLOWUSER                 @"notifition_cancelFollowUser"
//刷新想看状态
#define     NOTIFITION_FOLLOWSTATUS                     @"notifition_followstatus"
//刷新个人中心社交通知数量
#define     NOTIFITION_USERCENTERSOCIALCOUNT            @"notifition_userCenterSocialCount"
//刷新个人中心
#define     NOTIFITION_USERCENTER                       @"notifition_userCenter"
//刷新订单
#define     NOTIFITION_REFRESHORDER                     @"notifition_refreshOrder"
//显示影院首页内部通知
#define     NOTIFITION_SHOWCINEMAVIEWMSG                @"notifition_showCinemaViewMessage"
//唤起app通知
#define     NOTIFITION_SHOWWAKEUPAPPNOTICE              @"notifition_showWakeupAppNotcie"
//从后台唤起app跳到登陆页
#define     NOTIFITION_BACKGROUNDTOLOGIN                @"notifition_backgroundToLogin"
//
#define     NOTIFITION_SHOWOTHERVIEW                    @"notifition_showOtherView"
//继续播放视频
#define     NOTIFITION_CONTINUEPLAY                     @"notifition_ContinuePlay"
//唤起app继续倒计时
#define     NOTIFITION_RELOADCOUNTTIME                  @"notifition_ReloadCountTime"
#define     NOTIFITION_REFRESHGAME                      @"notifition_Refreshgame"
#define     NOTIFITION_GAMESTATUS                       @"notifition_gamestatus"
//关闭广播公告view
#define     NOTIFITION_CLOSEBROADVIEW                   @"notifition_CloseBroadView"
#define     NOTIFITION_LOADSYSTEMNOTICE                 @"notifition_Loadsysytemnotice"

#define noNetWorkCode                                   20000
//订单轮询最长时间
#define ORDERRUNMAXTIME                        60
//订单轮询多少时间后，还未成功，则去查询支付状态
#define ORDERRUNTIMELENG                       2
//颜色转换
#define RGBA(r,g,b,a)       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//字体
#define MKFONT(size)        [UIFont systemFontOfSize:size]
#define MKBOLDFONT(size)    [UIFont boldSystemFontOfSize:size]
#define tabbarHeight        45

