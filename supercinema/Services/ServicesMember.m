//
//  ServicesMember.m
//  movikr
//
//  Created by Mapollo27 on 15/9/15.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "ServicesMember.h"

@protocol NSDictionary;
@implementation ServicesMember

+ (void)getCinemaUserCardList:(NSString*)cinemaId
                model:(void (^)(MemberModel *memberModel))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"cinemaId":[Tool urlIsNull:cinemaId]};
    if([cinemaId length]> 0)
    {
        if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
        {
            if(failure)
               failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
        }
        else
        {
            [MKNetWorkRequest POST:URL_MEMBERINFO parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
             {
                 NSLog(@"%@",[responseObject JSONString]);
                 
                 RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
                 if ([result.respStatus intValue] == 1)
                 {
                     if([responseObject isKindOfClass:[NSDictionary class]])
                     {
                         NSError* err = nil;
                         MemberModel *memberModel = [[MemberModel alloc] initWithString:[responseObject JSONString] error:&err];
                         if(err!=nil)
                         {
                             NSLog(@"%@",err );
                             failure(err);
                         }
                         if(success)
                             success(memberModel);
                     }
                 }
                 else
                 {
                     if(failure)
                         failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue]  userInfo:nil]);
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 if(failure)
                     failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
             }];
        }
    }
    else
    {
        if(failure)
            failure([NSError errorWithDomain:@"没有影院id" code:-10000 userInfo:nil]);
    }
}

+ (void)getMemberCardFavorableInfo:(NSString*)cinemaId cardItemIds:(NSArray *)cardItemIds
                        array:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body= @{@"cinemaId":[Tool urlIsNull:cinemaId],
                          @"cardItemIds":cardItemIds};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETVIPCARDREDPACKETINFO parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 NSMutableArray *arrayList= [[NSMutableArray alloc] init];
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSArray<NSDictionary> *arrDic = [responseObject objectForKey:@"useStatusList"];
                     if(arrDic!=nil && [arrDic count]>0)
                     {
                         for (NSDictionary *dic in arrDic)
                         {
                             NSError* err = nil;
                            MemberCardFavorableInfoModel *favorableInfoModel = [[MemberCardFavorableInfoModel alloc] initWithString:[dic JSONString] error:&err];
                             if(err!=nil)
                             {
                                 NSLog(@"%@",err );
                             }
                             [arrayList addObject:favorableInfoModel];
                         }
                         if(success)
                             success(arrayList);
                     }
                 }
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:[NSString stringWithFormat:@"%@",result.respMsg]  code:[result.respStatus intValue]  userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
        
    }
}






@end
