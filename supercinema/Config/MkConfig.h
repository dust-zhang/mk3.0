//
//  Config.h
//  movikr
//
//  Created by Mapollo27 on 15/5/29.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

//保存登录状态
+(void)saveLoginState:(NSString *)state;
+(BOOL)getLoginState;
//保存用户名
+(void) saveUserName:(NSString *)name;
//读取用户名
+(NSString *) getUserName;
+(void) saveUserNickName:(NSString *)name;
+(NSString *) getUserNickName;
//删除已登录的用户名，密码
+(void)deleteUserLoactionData;
//保存登录缓存安全码
+(void) saveCredential:(NSString *)credential;
//读取登录缓存安全码
+(NSString *) getCredential;
+(void) saveUserType:(NSString *)passportType;
// 读取账户类型
+(NSString *) getUserType;
///得到浏览过的晨钟暮鼓ID
+(NSString*) getSeenRecommendIds;
///设置浏览过的晨钟暮鼓的ID
+(void) setSeenRecommendIds:(NSString*)seenRecommendIds;
///得到浏览过的文章ID
+(NSString*) getSeenArticleIds;
///设置浏览过的文章ID
+(void) setSeenArticleIds:(NSString*)seenArticleIds;
//保存用户默认影院ID
+(void)saveCinemaId:(NSString *)cinemaId;
//获取用户默认影院ID
+(NSString *)getCinemaId;
// 保存用户默认影院
+(void)saveCinemaName:(NSString *)cinemaName;
//获取用户默认影院
+(NSString *)getCinemaName;
//保存用户ID
+(void)saveUserId:(NSString *)userId;
//获取用户ID
+(NSString*)getUserId;
+(void)setDeviceToken:(NSString*)deviceToken;
+(NSString*)getDeviceToken;
//是否存在未上传文章
+(void) saveUpLoadFlag:(NSString *)flag;
+(NSString *) getUpLoadFlag;
//个推id
+(NSString *)getGeTuiId;
+(void)setGeTuiId:(NSString *)gtid;
//第一次启动APP
+(void)saveIsFirstStartUp:(NSString *)isStartUp;
+(BOOL)isFirstStartUp;
//保存每次拉取服务时间
+(void)saveVersion:(NSString *) ver;
+(NSString*)getVersion;
//保存系统时间
+(void)saveSystemDate:(NSString *) date type:(NSString*)typeTime;
+(NSString*)getSystemDate:(NSString*)typeTime;
//保存apnsId
+(void)saveAPNSId:(NSNumber *) apnsId;
+(NSNumber*)getAPNSId;
//保存搜索历史记录
+(void)saveSearchHistory:(NSMutableArray*)arr;
+(NSMutableArray *)getSearchHistory;
//保存搜索城市记录
+(void)saveSearchCity:(NSMutableArray*)arr;
+(NSMutableArray *)getSearchCity;
//保存配置信息
+(void)saveConfigInfo:(id)configInfo;
+(NSString *)getConfigInfo:(NSString *)value;
//保存每次打开标示
+(void)saveEveryPull:(NSString *) flag;
+(BOOL)getEveryPull;
//保存支付方式
+(void)savePayWay:(NSString *) payWay;
+(NSString *)getPayWay;
//保存tabbar切换状态
+(void)saveTabbarStatus:(NSString *) status;
+(NSString *)getTabbarStatus;
//保存用户头像
+(void)saveUserHeadImage:(NSString *) url;
+(NSString *)getUserHeadImage;
//保存设备标示
+(void)saveDeviceId:(NSString *) devId;
+(NSString *)getDeviceId;
//保存用户订单成功手机号
+(void)saveUserOrderPhone:(NSString *)userId phoneText:(NSString *)phoneText;
//读取用户订单成功手机号
+(NSString *)getUserOrderPhone:(NSString *)userId;
//保存锁屏或者点击home键时间
+(void)saveClickHomeLockScreenSystemTime:(NSNumber *) time;
+(NSNumber *)getClickHomeLockScreenSystemTime;
//保存分享影院选择的图片
+(void)saveSelectImageUrl:(NSString *) url key:(NSString *)shareTypeUrl;
+(NSString *)getSelectImageUrl:(NSString *)shareTypeUrl;
//保存定位信息
+(void)saveLocationInfo:(NSDictionary *) dic;
+(NSDictionary *)getLocationInfo;



@end
