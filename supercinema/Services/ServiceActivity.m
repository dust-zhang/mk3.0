//
//  ServiceActivity.m
//  movikr
//
//  Created by Mapollo27 on 16/4/7.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import "ServiceActivity.h"

@protocol NSDictionary;
@implementation ServiceActivity

+ (void)getActivityListByCinemaId:(NSString* )cinemaId
                  array:(void (^)(ActivityListModel *model))success failure:(void (^)(NSError *error))failure
{
     NSDictionary *body = @{@"cinemaId":[Tool urlIsNull:cinemaId] };
    if ([cinemaId length] > 0 )
    {
        if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
        {
            if(failure)
               failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
        }
        else
        {
            [MKNetWorkRequest POST:URL_GETACTIVITYLISTFORCINEMA parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
             {
                 NSLog(@"%@",[responseObject JSONString]);
                 RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
                 if ([result.respStatus intValue] == 1)
                 {
                     if([responseObject isKindOfClass:[NSDictionary class]])
                     {
                         NSError* err = nil;
                         ActivityListModel *actModel = [[ActivityListModel alloc] initWithString:[responseObject JSONString] error:&err];
                         if(err!=nil)
                         {
                             NSLog(@"%@",err );
                             failure(err);
                         }
                         if(success)
                             success(actModel);
                     }
                 }
                 else
                 {
                     if(failure)
                         failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 if(failure)
                     failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
             }];
        }
    }
}

+ (void)getActivityDetail:(NSNumber* )notifyId
                    model:(void (^)(NotifyListModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"notifyId":[Tool urlIsNull:[notifyId stringValue]]};
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         [MKNetWorkRequest POST:URL_NOTICEDETAIL parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSError* err = nil;
                     NotifyListModel *noticeModel = [[NotifyListModel alloc] initWithString:[[responseObject objectForKey:@"notify"]JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                         failure(err);
                     }
                     if(success)
                         success(noticeModel);
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


//+ (void)getJoinInfoListByActivityIds:(NSString* )cinemaId activityArr:(NSArray *)arr
//                            array:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure
//{
//    NSDictionary *body = @{@"cinemaId":[Tool urlIsNull:cinemaId],@"activityIds":arr};
//    NSLog(@"%@",[body JSONString]);
//    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
//    {
//        if(failure)
//           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
//    }
//    else
//    {
//         [MKNetWorkRequest POST:URL_GETUSERINACTIVITY parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
//         {
//             NSLog(@"%@",[responseObject JSONString]);
//             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
//             if ([result.respStatus intValue] == 1)
//             {
//                 NSMutableArray *arrayList= [[NSMutableArray alloc] init];
//                 if([responseObject isKindOfClass:[NSDictionary class]])
//                 {
//                     NSArray<NSDictionary> *arrDic = [responseObject objectForKey:@"activityList"];
//                     if(arrDic!=nil && [arrDic count]>0)
//                     {
//                         for (NSDictionary *dic in arrDic)
//                         {
//                             NSError* err = nil;
//                             UserJoinActivityModel *userActModel = [[UserJoinActivityModel alloc] initWithString:[dic JSONString] error:&err];
//                             if(err!=nil)
//                             {
//                                 NSLog(@"%@",err );
//                                 failure(err);
//                             }
//                             [arrayList addObject:userActModel];
//                         }
//                     }
//                 }
//                 if(success)
//                     success(arrayList);
//             }
//             else
//             {
//                 if(failure)
//                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
//             }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            if(failure)
//                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
//        }];
//    }
//}

+ (void)joinActivity:(NSString* )cinemaId activityId:(NSNumber *)aId
                               model:(void (^)(RequestResult * model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"cinemaId":[Tool urlIsNull:cinemaId],
                           @"activityId":[Tool urlIsNull:[aId stringValue]]};
    
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         [MKNetWorkRequest POST:URL_JOINACTIVITY parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue]  == 1)
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
            if(failure)
                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
        }];
    }
}


+ (void)receiveActivity:(NSString* )cinemaId activityId:(NSNumber *)aId
                model:(void (^)(ActivityRootModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"cinemaId":[Tool urlIsNull:cinemaId],
                           @"activityId":[Tool urlIsNull:[aId stringValue]] };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         [MKNetWorkRequest POST:URL_RECEVICEACTIVITY parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 NSError* err = nil;
                 ActivityRootModel *activityModel =[[ActivityRootModel alloc] initWithDictionary:responseObject error:nil];
                 if(err!=nil)
                 {
                     NSLog(@"%@",err );
                 }
                 if(success)
                     success(activityModel);
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

+ (void)getAwardList:(NSString* )orderId
                  model:(void (^)(ActivityAwardModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"orderId":[Tool urlIsNull:orderId]};

    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETAWARDLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSLog(@"%@",[responseObject JSONString]);
            RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
            if ([result.respStatus intValue] == 1)
            {
                NSError* err = nil;
                ActivityAwardModel *awardModel = [[ActivityAwardModel alloc] initWithString:[responseObject JSONString] error:&err];
                if(err!=nil)
                {
                    NSLog(@"%@",err );
                }
                if(success)
                    success(awardModel);
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


@end
