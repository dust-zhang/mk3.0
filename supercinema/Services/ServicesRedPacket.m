
//
//  ServicesRedPacket.m
//  movikr
//
//  Created by Mapollo27 on 16/4/7.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import "ServicesRedPacket.h"

@protocol NSDictionary;
@implementation ServicesRedPacket

+ (void)getRedPacketDetail:(NSNumber* )redPacketId
               model:(void (^)(RedPacketModel * model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"redPacketId":[Tool urlIsNull:[redPacketId stringValue]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETREDPACKETDETAIL parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue]  == 1)
             {
                    RedPacketModel *redPacketModel =[[RedPacketModel alloc] initWithDictionary:[responseObject objectForKey:@"redPacket"] error:nil];
                    if(success)
                        success(redPacketModel);
             }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failure)
                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
        }];
    }
}

+ (void)getRedPacketList:(NSNumber* )showtimeId cinemaId:(NSString *)cinemaId cardItemId:(NSNumber *)cardItemId
     goodsIdAndCountList:(NSArray *)arr ticketCount:(NSNumber *)ticketCount
                   array:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"showtimeId":[Tool urlIsNull:[showtimeId stringValue]],
                           @"cinemaId":[Tool urlIsNull:cinemaId],
                           @"cardItemId":[Tool urlIsNull:[cardItemId stringValue]],
                           @"ticketCount":[Tool urlIsNull:[ticketCount stringValue]]
                           };
    if (arr.count > 0)
    {
        body = @{@"showtimeId":[Tool urlIsNull:[showtimeId stringValue]],
                 @"cinemaId":[Tool urlIsNull:cinemaId],
                 @"cardItemId":[Tool urlIsNull:[cardItemId stringValue]],
                 @"goodsIdAndCountList":arr,
                 @"ticketCount":[Tool urlIsNull:[ticketCount  stringValue]]
                 };
    }
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETREDPACKETLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
             NSLog(@"%@",[responseObject JSONString]);
            
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 NSMutableArray *arrayList= [[NSMutableArray alloc] init];
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSArray<NSDictionary> *arrDic = [responseObject objectForKey:@"redPacketList"];
                     if(arrDic!=nil && [arrDic count]>0)
                     {
                         for (NSDictionary *dic in arrDic)
                         {
                             NSError* err = nil;
                             RedPacketListModel *redPacket = [[RedPacketListModel alloc] initWithString:[dic JSONString] error:&err];
                             if(err!=nil)
                             {
                                 NSLog(@"%@",err );
                             }
                             [arrayList addObject:redPacket];
                         }
                     }
                 }
                 if(success)
                     success(arrayList);
             }
             else
             {
                   failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue]  userInfo:nil]);
             }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failure)
                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
        }];
    }
}

+ (void)getOrderCanUseCinemaCardList:(NSNumber* )showtimeId ticketCount:(NSNumber *)ticketCount cardId:(NSNumber*)cardId
                               array:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"showtimeId":[Tool urlIsNull:[showtimeId stringValue]]
                           ,@"ticketCount":[Tool urlIsNull:[ticketCount stringValue]],
                           @"cardId":[Tool urlIsNull:[cardId stringValue]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETCANUSERCINEMACARDLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue]== 1)
             {
                 NSMutableArray *arrayList= [[NSMutableArray alloc] init];
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSArray<NSDictionary> *arrDic = [responseObject objectForKey:@"cinemaCardItemList"];
                     if(arrDic!=nil && [arrDic count]>0)
                     {
                         for (NSDictionary *dic in arrDic)
                         {
                             NSError* err = nil;
                             cinemaCardItemListModel *cardList = [[cinemaCardItemListModel alloc] initWithString:[dic JSONString] error:&err];
                             if(err!=nil)
                             {
                                 NSLog(@"%@",err );
                             }
                             [arrayList addObject:cardList];
                         }
                     }
                 }
                 if(success)
                     success(arrayList);
             }
             else
             {
                 if (failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
             }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failure)
                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
        }];
    }
}



+ (void)getRedPacketUseCinemaList:(NSNumber* )redPacketId
                               model:(void (^)(RedPacketCinemaListModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"redPacketId":[Tool urlIsNull:[redPacketId stringValue]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {

        [MKNetWorkRequest POST:URL_GETREDUSECINEMALIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue]== 1)
             {
                 RedPacketCinemaListModel *model = [[RedPacketCinemaListModel alloc] initWithDictionary:responseObject error:nil];
                 if(success)
                     success(model);
             }
             else
             {
                 if (failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
//    NSError* err = nil;
//    RedPacketCinemaListModel* model= [[RedPacketCinemaListModel alloc] initWithDictionary: [Tool dictionaryWithJsonString:[Tool readLocationJsonFile:@"textfile"] ] error:&err];
//    if(success)
//        success(model);
}

@end
