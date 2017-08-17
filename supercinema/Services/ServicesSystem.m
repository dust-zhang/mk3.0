//
//  ServiceSystem
//  movikr
//
//  Created by Mapollo27 on 15/8/27.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "ServicesSystem.h"

@implementation ServicesSystem
@protocol NSDictionary;

+ (void)getVersionInfo:(void (^)(NSDictionary *versionModel))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_VERSIONUPDATE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSLog(@"%@",[responseObject JSONString]);
            RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
            if ([result.respStatus intValue] == 1)
            {
                if(success)
                    success(responseObject);
            }
            else
            {
                if(failure)
                    failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
            }
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@",[error localizedDescription]);
             if(failure)
                 failure(error);
         }];
    }
}


+ (void)getProtocolContent:(void (^)(NSString *protocolContent))success failure:(void (^)(NSError *error))failure
{
   
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_USERLICENSE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success([responseObject objectForKey:@"licenseContent"]);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
             }

         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@",[error localizedDescription]);
             if(failure)
                 failure(error);
         }];
    }
}

+ (void)getSystemConfig:(NSString* )deviceToken clientId:(NSString *)getuiClientId
                  model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
     NSDictionary *body = @{@"deviceToken":[Tool urlIsNull:deviceToken] ,
                            @"getuiClientId":[Tool urlIsNull:getuiClientId]};
    
     if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
     {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
     }
     else
     {
        [MKNetWorkRequest POST:URL_SYSTEMCONFIG parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             //保存配置信息
             [Config saveConfigInfo:responseObject];
             
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@",[error localizedDescription]);
             if(failure)
                 failure(error);
         }];
    }
}

           
+ (void)firstStartApp:(NSString *)getuiClientId
                mdoel:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"getuiClientId":[Tool urlIsNull:getuiClientId]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_FIRSTSTARTAPP parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 NSError* err = nil;
                 if(err!=nil)
                 {
                     NSLog(@"%@",err );
                 }
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@",[error localizedDescription]);
             if(failure)
                 failure(error);
         }];
    }
}

+ (void)addScanLog:(NSString *)address latitude:(NSString *)_latitude longitude:(NSString *)_longitude scanContent:(NSString *)_scanContent
                mdoel:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"address":[Tool urlIsNull:address],
                           @"latitude":[Tool urlIsNull:_latitude],
                           @"longitude":[Tool urlIsNull:_longitude],
                           @"scanContent":[Tool urlIsNull:_scanContent]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_ADDSCANLOG parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             if(success)
                 success(responseObject);
            
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@",[error localizedDescription]);
             if(failure)
                 failure(error);
         }];
    }
}


@end
