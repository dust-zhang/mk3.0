//
//  Config.m
//  movikr
//
//  Created by Mapollo27 on 15/5/29.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "MkConfig.h"

@implementation Config
@protocol NSDictionary;

//是否第一次启动APP
+(void)saveIsFirstStartUp:(NSString *)isStartUp
{
    NSUserDefaults *startUpStatus = [NSUserDefaults standardUserDefaults];
    [startUpStatus setValue:isStartUp forKey:@"firstStartUp"];
    [startUpStatus synchronize];
}

+(BOOL)isFirstStartUp
{
    NSUserDefaults * startUpStatus = [NSUserDefaults standardUserDefaults];
    if ([[startUpStatus objectForKey:@"firstStartUp"] isEqual:@"YES" ])
    {
        return TRUE;
    }
    return FALSE;
}

+(void)saveLoginState:(NSString *)state
{
    NSUserDefaults *startUpStatus = [NSUserDefaults standardUserDefaults];
    [startUpStatus setValue:state forKey:@"loginstatus"];
    [startUpStatus synchronize];
}

+(BOOL)getLoginState
{
    NSUserDefaults * startUpStatus = [NSUserDefaults standardUserDefaults];
    if ( ([[startUpStatus objectForKey:@"loginstatus"] isEqual:@"YES" ] ) && ([[self getUserType] intValue]!= 1) )
    {
        return TRUE;
    }
    return FALSE;
}

/**
 *  保存用户名，无返回值
 *
 *  @param name 要保存的用户名
 */
+(void) saveUserName:(NSString *)name
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:name forKey:@"username"];
    [user synchronize];
}

/**
 *  读取用户名
 *
 *  @return 返回nsstring类型用户名
 */
+(NSString *) getUserName
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"username"];
}

/**
 *  保存用户昵称，无返回值
 *
 *  @param name 要保存的昵称
 */
+(void) saveUserNickName:(NSString *)name
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:name forKey:@"usernickname"];
    [user synchronize];
}

/**
 *  读取用户昵称
 *
 *  @return 返回nsstring类型用户昵称
 */
+(NSString *) getUserNickName
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"usernickname"];
}

/**
 *  保存登录缓存安全码
 *
 *  @param c 登录缓存安全码
 */
+(void) saveCredential:(NSString *)credential
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:credential forKey:@"userCredential"];
}

/**
 *  读取登录缓存安全码
 *
 *  @return 登录缓存安全码
 */
+(NSString *) getCredential
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"userCredential"];
}

/**
 *  保存账户类型
 *
 *  @param c 账户类型
 */
+(void) saveUserType:(NSString *)passportType
{
    NSUserDefaults *userType = [NSUserDefaults standardUserDefaults];
    [userType setValue:passportType forKey:@"passportType"];
}

/**
 *  读取账户类型
 *
 *  @return 账户类型
 */
+(NSString *) getUserType
{
    NSUserDefaults *userType = [NSUserDefaults standardUserDefaults];
    return [userType objectForKey:@"passportType"];
}


/**
 *  删除用户对象
 */
+(void)deleteUserLoactionData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"loginstatus"];
    [user removeObjectForKey:@"userId"];
    
}

/**
 *  得到浏览过的晨钟暮鼓ID
 */
+(NSString*)getSeenRecommendIds{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"seenRecommendIds"];
}

/**
 *  设置浏览过的暮鼓晨钟ID
 */
+(void)setSeenRecommendIds:(NSString*)seenRecommendIds{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setValue:seenRecommendIds forKey:@"seenRecommendIds"];
}

/**
 *  得到浏览过的文章ID
 */
+(NSString*)getSeenArticleIds{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"seenArticleIds"];
}

/**
 *  设置浏览过的文章ID
 */
+(void)setSeenArticleIds:(NSString *)seenArticleIds{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setValue:seenArticleIds forKey:@"seenArticleIds"];
}
/**
 *  保存用户默认影院ID
 */
+(void)saveCinemaId:(NSString *)cinemaId
{
    if (cinemaId != nil)
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:cinemaId forKey:@"userCinemaId"];
        [user synchronize];
    }
}

/**
 *  获取用户默认影院ID
 */
+(NSString *)getCinemaId
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if([[user objectForKey:@"userCinemaId"] intValue] == 0)
    {
          return @"";
    }
    else
    {
          return [user objectForKey:@"userCinemaId"];
    }
    return @"";
}

// 保存用户默认影院
+(void)saveCinemaName:(NSString *)cinemaName
{
    if (cinemaName != nil)
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:[NSString stringWithFormat:@"%@",cinemaName] forKey:@"userCinemaName"];
        [user synchronize];
    }
}

//获取用户默认影院
+(NSString *)getCinemaName
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"userCinemaName"];
}

/**
 *  保存用户ID
 */
+(void)saveUserId:(NSString *)userId
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:userId forKey:@"userId"];
}

/**
 *  获取用户ID
 */
+(NSString*)getUserId
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"userId"];
}

+(NSString *)getDeviceToken{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"deviceToken"];
}

+(void)setDeviceToken:(NSString *)deviceToken{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setValue:deviceToken forKey:@"deviceToken"];
    [settings synchronize];
}
//获取个推id
+(NSString *)getGeTuiId
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"getuiid"];
}

+(void)setGeTuiId:(NSString *)gtid
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setValue:gtid forKey:@"getuiid"];
    [settings synchronize];
}

//是否存在未上传文章
+(void) saveUpLoadFlag:(NSString *)flag
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:flag forKey:@"uploadflag"];
    [user synchronize];
}
+(NSString *) getUpLoadFlag
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"uploadflag"];
}

+(void)saveVersion:(NSString *) ver
{
    NSUserDefaults *PullTime = [NSUserDefaults standardUserDefaults];
    [PullTime setValue:ver forKey:@"versionNO"];
    [PullTime synchronize];
    
}
+(NSString*)getVersion
{
    NSUserDefaults *PullTime = [NSUserDefaults standardUserDefaults];
    return [PullTime objectForKey:@"versionNO"];
}

+(void)saveSystemDate:(NSString *) date type:(NSString*)typeTime
{
    NSUserDefaults *systemtime = [NSUserDefaults standardUserDefaults];
    [systemtime setValue:date forKey:typeTime];
    [systemtime synchronize];
    
}
+(NSString*)getSystemDate:(NSString*)typeTime
{
    NSUserDefaults *systemtime = [NSUserDefaults standardUserDefaults];
    return [systemtime objectForKey:typeTime];
}
+(void)saveAPNSId:(NSNumber *) apnsId
{
    NSUserDefaults *systemtime = [NSUserDefaults standardUserDefaults];
    [systemtime setValue:apnsId forKey:@"apnsId"];
    [systemtime synchronize];
}
+(NSNumber*)getAPNSId
{
    NSUserDefaults *systemtime = [NSUserDefaults standardUserDefaults];
    if (![systemtime objectForKey:@"apnsId"])
    {
        return @0;
    }
    return [systemtime objectForKey:@"apnsId"];
}

//+(void)saveServicesTime:(NSNumber *) systemTime
//{
//    NSUserDefaults *systemtime = [NSUserDefaults standardUserDefaults];
//    [systemtime setValue:systemTime forKey:@"systemTime"];
//    [systemtime synchronize];
//    
//}
//
//+(NSNumber*)getServicesTime
//{
//    NSUserDefaults *systemtime = [NSUserDefaults standardUserDefaults];
//    return [systemtime objectForKey:@"systemTime"];
//}

+(void)saveSearchHistory:(NSMutableArray*)arr
{
    NSUserDefaults *history = [NSUserDefaults standardUserDefaults];
    [history setValue:arr forKey:@"searchHistory"];
    [history synchronize];
}
+(NSMutableArray *)getSearchHistory
{
    NSUserDefaults *systemtime = [NSUserDefaults standardUserDefaults];
    return [systemtime objectForKey:@"searchHistory"];
}

+(void)saveSearchCity:(NSMutableArray*)arr
{
    NSUserDefaults *history = [NSUserDefaults standardUserDefaults];
    [history setValue:arr forKey:@"searchCity"];
    [history synchronize];
}

+(NSMutableArray *)getSearchCity
{
    NSUserDefaults *systemtime = [NSUserDefaults standardUserDefaults];
    return [systemtime objectForKey:@"searchCity"];
}


+(void)saveConfigInfo:(id)configInfo
{
    NSUserDefaults *udConfigInfo = [NSUserDefaults standardUserDefaults];
    [udConfigInfo setValue:configInfo forKey:@"configInfo"];
    [udConfigInfo synchronize];
}

+(NSString *)getConfigInfo:(NSString *)value
{
    NSUserDefaults *systemtime = [NSUserDefaults standardUserDefaults];
    NSArray<NSDictionary> *arrDic = [[systemtime objectForKey:@"configInfo"] objectForKey:@"configList"];
     if(arrDic!=nil && [arrDic count]>0)
     {
         for (NSDictionary *dic in arrDic)
         {
             NSError* err = nil;
             SystemConfigModel *sysConfig = [[SystemConfigModel alloc] initWithString:[dic JSONString] error:&err];
             if([value isEqualToString:sysConfig.key ])
                 return sysConfig.value;
         }
     }
    return @"";
}

+(void)saveEveryPull:(NSString *) flag
{
    NSUserDefaults *systemtime = [NSUserDefaults standardUserDefaults];
    [systemtime setValue:flag forKey:@"EveryPull"];
    [systemtime synchronize];
}
+(BOOL)getEveryPull
{
    NSUserDefaults *comment = [NSUserDefaults standardUserDefaults];
    if ([[comment objectForKey:@"EveryPull"] isEqualToString:@"YES"])
        return TRUE;
    else
        return FALSE;
}

+(void)savePayWay:(NSString *) payWay
{
    NSUserDefaults *snPayWay = [NSUserDefaults standardUserDefaults];
    [snPayWay setValue:payWay forKey:@"PayWay"];
    [snPayWay synchronize];
}
+(NSString *)getPayWay
{
    NSUserDefaults *snPayWay = [NSUserDefaults standardUserDefaults];
    return [snPayWay objectForKey:@"PayWay"];
}

+(void)saveTabbarStatus:(NSString *) status
{
    NSUserDefaults *snPayWay = [NSUserDefaults standardUserDefaults];
    [snPayWay setValue:status forKey:@"TabbarStatus"];
    [snPayWay synchronize];
}

+(NSString *)getTabbarStatus
{
    NSUserDefaults *snPayWay = [NSUserDefaults standardUserDefaults];
    return [snPayWay objectForKey:@"TabbarStatus"];
}

+(void)saveUserHeadImage:(NSString *) url
{
    NSUserDefaults *snPayWay = [NSUserDefaults standardUserDefaults];
    [snPayWay setValue:url forKey:@"headImageUrl"];
    [snPayWay synchronize];
}

+(NSString *)getUserHeadImage
{
    NSUserDefaults *snPayWay = [NSUserDefaults standardUserDefaults];
    return [snPayWay objectForKey:@"headImageUrl"];
}

+(void)saveDeviceId:(NSString *) devId
{
    NSUserDefaults *snPayWay = [NSUserDefaults standardUserDefaults];
    [snPayWay setValue:devId forKey:@"DeviceId"];
    [snPayWay synchronize];
}
+(NSString *)getDeviceId
{
    NSUserDefaults *snPayWay = [NSUserDefaults standardUserDefaults];
    return [snPayWay objectForKey:@"DeviceId"];
}

+(void)saveUserOrderPhone:(NSString *)userId phoneText:(NSString *)phoneText
{
    NSUserDefaults *orderPhoneText = [NSUserDefaults standardUserDefaults];
    NSString* strTel = phoneText;
    if (phoneText.length==0)
    {
        strTel = @"";
    }
    [orderPhoneText setValue:strTel forKey:userId];
    [orderPhoneText synchronize];
}

+(NSString *)getUserOrderPhone:(NSString *)userId
{
    NSUserDefaults *orderPhoneText = [NSUserDefaults standardUserDefaults];
    if (userId.length > 0)
    {
       return  [orderPhoneText objectForKey:userId];
    }
    return @"";
}

+(void)saveClickHomeLockScreenSystemTime:(NSNumber *) time
{
    NSUserDefaults *userDefaultsTime = [NSUserDefaults standardUserDefaults];
    [userDefaultsTime setValue:time forKey:@"ClickHomeLockScreenSystemTime"];
    [userDefaultsTime synchronize];
}

+(NSNumber *)getClickHomeLockScreenSystemTime
{
    NSUserDefaults *userDefaultsTime = [NSUserDefaults standardUserDefaults];
    if ( [ [NSString stringWithFormat:@"%@",[userDefaultsTime objectForKey:@"ClickHomeLockScreenSystemTime"]] isEqualToString:@"(null)"])
    {
        return @0;
    }
    else
    {
        return [userDefaultsTime objectForKey:@"ClickHomeLockScreenSystemTime"];
    }
    return @0;
}


+(void)saveSelectImageUrl:(NSString *) url key:(NSString *)shareTypeUrl
{
    NSUserDefaults *userDefaultsSelectImageUrl = [NSUserDefaults standardUserDefaults];
    [userDefaultsSelectImageUrl setValue:url forKey:shareTypeUrl];
    [userDefaultsSelectImageUrl synchronize];
}

+(NSString *)getSelectImageUrl:(NSString *)shareTypeUrl
{
    NSUserDefaults *userDefaultsSelectImageUrl = [NSUserDefaults standardUserDefaults];
    return [userDefaultsSelectImageUrl objectForKey:shareTypeUrl];
}

+(void)saveLocationInfo:(NSDictionary *) dic
{
    NSUserDefaults *snPayWay = [NSUserDefaults standardUserDefaults];
    [snPayWay setValue:dic forKey:@"locationPostion"];
    [snPayWay synchronize];
}
+(NSDictionary *)getLocationInfo
{
    NSUserDefaults *snPayWay = [NSUserDefaults standardUserDefaults];
    return [snPayWay objectForKey:@"locationPostion"];
}

@end
