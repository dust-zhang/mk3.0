//
//  ServicesShowTime.m
//  movikr
//
//  Created by Mapollo27 on 15/9/15.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "ServicesShowTime.h"

#define CustomErrorDomain @"com.xiaodao.test"
typedef enum
{
    XDefultFailed = -1000
}CustomErrorFailed;

@implementation ServicesShowTime

+ (void)getCinemaMovieShowTime:(NSNumber *)movieId cinemaId:(NSString *)cinemaId
                model:(void (^)(ShowTimeModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"movieId":[Tool urlIsNull:[movieId stringValue]],
                           @"cinemaId":[Tool urlIsNull:cinemaId],
                           @"deviceWidth":[[NSNumber alloc]initWithInteger:[Tool getLoadImageDeviceWidth]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_SHOWTIME parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSLog(@"%@",[responseObject JSONString]);
            RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
            if ([result.respStatus integerValue]  == 1)
            {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSError* err = nil;
                     ShowTimeModel *showTimeModel = [[ShowTimeModel alloc] initWithString:[responseObject JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                     }
                     if(success)
                         success(showTimeModel);
                 }
            }
            else
            {
                if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus integerValue]  userInfo:nil]);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failure)
                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
        }];
    }
}

+ (void)getMovieShowTimeDetail:(NSInteger )showTimeId
                         model:(void (^)(ShowTimeDetailModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"showtimeId":[NSNumber numberWithInteger:showTimeId],
                           @"deviceWidth":[[NSNumber alloc]initWithInteger:[Tool getLoadImageDeviceWidth]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_SHOWTIMEDETAIL parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSLog(@"%@",[responseObject JSONString]);
            RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
            if ([result.respStatus integerValue]  == 1)
            {
                if([responseObject isKindOfClass:[NSDictionary class]])
                {
                    NSError* err = nil;
                    ShowTimeDetailModel *showTimeDetailModel = [[ShowTimeDetailModel alloc] initWithString:[responseObject JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                     }
                     if(success)
                         success(showTimeDetailModel);
                 }
             }
            else
            {
                if(failure)
                    failure([NSError errorWithDomain:result.respMsg code:[result.respStatus integerValue]  userInfo:nil]);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failure)
                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
        }];
    }
}

@end
