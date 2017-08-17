//
//  ServicesGoods.m
//  supercinema
//
//  Created by dust on 16/12/13.
//
//

#import "ServicesGoods.h"

@protocol NSDictionary;
@implementation ServicesGoods

+ (void)getSnackList:(NSString *) cinemaId
               model:(void (^)(SnackModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"cinemaId":[Tool urlIsNull:cinemaId] };
    if([cinemaId length]> 0)
    {
        if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
        {
            if(failure)
               failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
        }
        else
        {
            [MKNetWorkRequest POST:URL_GETSNACKLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
             {
                 NSLog(@"%@",[responseObject JSONString]);
                 SnackModel *result =[[SnackModel alloc] initWithDictionary:responseObject error:nil];
                 if ([result.respStatus integerValue]  == 1)
                 {
                     if(success)
                         success(result);
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
    else
    {
        if(failure)
            failure([NSError errorWithDomain:@"没有影院id" code:-10000 userInfo:nil]);
    }
}

+ (void)getSnackDetail:(NSString *)cinemaId goodsId:(NSNumber *) _snackId
                 model:(void (^)(SnackDetailModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"cinemaId":[Tool urlIsNull:cinemaId],
                          @"goodsId":[Tool urlIsNull:[_snackId stringValue]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETSNACKDETAIL parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             SnackDetailModel *result =[[SnackDetailModel alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus integerValue]  == 1)
             {
                 if(success)
                     success(result);
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

+ (void)createSnack:(NSString *)cinemaId cinemaCardId:(NSNumber *)_cinemaCardId
goodsIdAndCountList:(NSArray *) _goodsIdAndCountList mobileNo:(NSNumber*)_mobileNo redPacketIds:(NSArray*)_packetIds
              model:(void (^)(CreateSnackModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"cinemaId":[Tool urlIsNull:cinemaId],
                          @"cinemaCardId":[Tool urlIsNull:[_cinemaCardId stringValue]],
                          @"goodsIdAndCountList":_goodsIdAndCountList,
                          @"mobileNo":[Tool urlIsNull:[_mobileNo stringValue]]};
    if (_packetIds.count > 0)
    {
        body =@{@"cinemaId":[Tool urlIsNull:cinemaId],
                @"cinemaCardId":[Tool urlIsNull:[_cinemaCardId stringValue]],
                @"goodsIdAndCountList":_goodsIdAndCountList,
                @"redPacketIds":_packetIds,
                @"mobileNo":[Tool urlIsNull:[_mobileNo stringValue]]};
    }
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETCREATESNACK parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             CreateSnackModel *result =[[CreateSnackModel alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus integerValue]  == 1)
             {
                 if(success)
                     success(result);
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

//获取小卖列表
+ (void)getGoodsList:(NSString *) cinemaId cardId:(NSInteger) cardId showTimeId:(NSInteger ) showTimeId
               array:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure
{
    cardId = cardId ? cardId : 0;
    NSDictionary * body =@{@"cinemaId":[Tool urlIsNull:cinemaId],
                           @"cinemaCardId":[NSNumber numberWithInteger:cardId ],
                           @"showtimeId":[NSNumber numberWithInteger:showTimeId ]  };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETGOODLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus integerValue]  == 1)
             {
                 NSMutableArray *arrayList= [[NSMutableArray alloc] init];
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSArray<NSDictionary> *arrDic = [responseObject objectForKey:@"goodsList"];
                     if(arrDic!=nil && [arrDic count]>0)
                     {
                         for (NSDictionary *dic in arrDic)
                         {
                             NSError* err = nil;
                             GoodsListModel *listModel = [[GoodsListModel alloc] initWithString:[dic JSONString] error:&err];
                             if(err!=nil)
                             {
                                 NSLog(@"%@",err );
                             }
                             [arrayList addObject:listModel];
                         }
                     }
                 }
                 if(success)
                     success(arrayList);
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

//获取小卖库存
+ (void)getGoodsListRemainCount:(NSString *)cinemaId goodsIdAndCountList:(NSArray *) _goodsIdAndCountList
                          model:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure
{
    NSDictionary * body =@{@"cinemaId":[Tool urlIsNull:cinemaId],
                           @"goodsIdAndCountList":_goodsIdAndCountList
                           };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETGOODSLISTREMAINCOUNT parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus integerValue]  == 1)
             {
                 NSMutableArray *arrayList= [[NSMutableArray alloc] init];
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSArray<NSDictionary> *arrDic = [responseObject objectForKey:@"goodsCountCheckResult"];
                     if(arrDic!=nil && [arrDic count]>0)
                     {
                         for (NSDictionary *dic in arrDic)
                         {
                             NSError* err = nil;
                             SnackRemainCountModel *listModel = [[SnackRemainCountModel alloc] initWithString:[dic JSONString] error:&err];
                             if(err!=nil)
                             {
                                 NSLog(@"%@",err );
                             }
                             [arrayList addObject:listModel];
                         }
                     }
                 }
                 if(success)
                     success(arrayList);
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

+ (void)getGoodsDetail:(NSString *) subGoodsOrderId
                 model:(void (^)(GoodsListDetailModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"subGoodsOrderId":[Tool urlIsNull:subGoodsOrderId]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETGOODDETAIL parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus integerValue]  == 1)
             {
                 NSError* err = nil;
                 GoodsListDetailModel *GoodsList = [[GoodsListDetailModel alloc] initWithString:[[responseObject objectForKey:@"goodsOrder"]JSONString] error:&err];
                 if(err!=nil)
                 {
                     NSLog(@"%@",err );
                     failure(err);
                 }
                 if(success)
                     success(GoodsList);
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

+ (void)exchangeGoods:(NSString *) subGoodsOrderId code:(NSString *) code
                model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"subGoodsOrderId":[Tool urlIsNull:subGoodsOrderId],
                          @"userCode":[Tool urlIsNull:code]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETEXCHANGEGOODS parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus integerValue]  == 1)
             {
                 if(success)
                     success(result);
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
