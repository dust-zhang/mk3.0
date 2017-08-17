//
//  ServicesPay.m
//  movikr
//
//  Created by Mapollo27 on 15/9/15.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "ServicesPay.h"

@protocol NSDictionary;
@implementation ServicesPay

+ (void)getPayWayList:(NSString *) orderId
                model:(void (^)(PayModelList *payModelList))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"orderId":[Tool urlIsNull:orderId]};

    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETPAYWAYLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSLog(@"%@",[responseObject JSONString]);
            RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
            if ([result.respStatus intValue] == 1)
            {
                
                if([responseObject isKindOfClass:[NSDictionary class]])
                {
                    NSError* err = nil;
                    PayModelList *payModelList = [[PayModelList alloc] initWithString:[responseObject JSONString] error:&err];
                    if(err!=nil)
                    {
                        NSLog(@"%@",err );
                        failure(err);
                    }
                    if(success)
                        success(payModelList);
                }
            }
            else
            {
                if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failure)
                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
        }];
    }
}

+ (void)payReturn:(NSString *)requestTime
          orderId:(NSString *)orderId model:(void (^)(PayReturnModel *))success failure:(void (^)(NSError *))failure
{
    NSDictionary *body = @{@"requestTime":[Tool urlIsNull:requestTime],
                           @"payOrderId":[Tool urlIsNull:orderId]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_PAYRETURN parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
            RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue]  == 1 || [result.respStatus intValue]  == -119)
            {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSError* err = nil;
                     PayReturnModel *payReturnModel = [[PayReturnModel alloc] initWithString:[responseObject JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                         failure(err);
                     }
                     if(success)
                         success(payReturnModel);
                 }
             }
            else
            {
                if(failure)
                    failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
            }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];

    }
}

+ (void)orderCycle:(NSString *) orderId
             model:(void (^)(OrderWhileModel *model))success failure:(void (^)(NSError *error))failure
{
     NSDictionary *body =@{@"orderId":[Tool urlIsNull:orderId]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         [MKNetWorkRequest POST:URL_ORDERCYCLE parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",responseObject);
             
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
              if ([result.respStatus intValue] == 1)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSError* err = nil;
                     OrderWhileModel *orderWhileModel = [[OrderWhileModel alloc] initWithString:[responseObject JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                         failure(err);
                     }
                     if(success)
                         success(orderWhileModel);
                 }
             }
             else
             {
                 if(failure)
                      failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+(void) getPayDetail:(NSString *)orderId payType:(NSInteger)type
                  model:(void (^)(ThirdPayModel * thirdPayModel))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"orderId":[Tool urlIsNull:orderId],
                          @"payTypeId":[NSString stringWithFormat:@"%ld",(long)type]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         [MKNetWorkRequest POST:URL_THIRDPAY parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
              if ([result.respStatus intValue] == 1)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSError* err = nil;
                      ThirdPayModel *thirdPayModel = [[ThirdPayModel alloc] initWithString:[responseObject JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                         failure(err);
                     }
                     if(success)
                         success(thirdPayModel);
                 }
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
                     NSLog(@"%@",result.respMsg);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}


+(void) buyMemberCard:(NSString *)cinemaId cinemaCardId:(NSNumber*)cinemaCardId redPacket:(NSArray *)redPacket mobileNo:(NSString *)mobileNo
                model:(void (^)(MemberCardModel *memberCardModel))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"cinemaId":[Tool urlIsNull:cinemaId],
                          @"cinemaCardItemId":[Tool urlIsNull:[cinemaCardId stringValue]],
                          @"supplierId":@1,
                          @"mobileNo":mobileNo };
    
    if (redPacket.count > 0)
    {
        body = @{@"cinemaId":[Tool urlIsNull:cinemaId],
                 @"cinemaCardItemId":[Tool urlIsNull:[cinemaCardId  stringValue]],
                 @"supplierId":@1,
                 @"redPacketIds":redPacket,
                 @"mobileNo":mobileNo};
    }
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_BUYMEMBERCARD parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
              if ([result.respStatus intValue] == 1)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSError* err = nil;
                     MemberCardModel *memberCard = [[MemberCardModel alloc] initWithString:[responseObject JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                         failure(err);
                     }
                     if(success)
                         success(memberCard);
                 }
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue ] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}
@end
