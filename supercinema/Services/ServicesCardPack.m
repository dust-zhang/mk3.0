//
//  ServicesCardPack.m
//  supercinema
//
//  Created by dust on 16/11/28.
//
//

#import "ServicesCardPack.h"

@implementation ServicesCardPack

+ (void)getCardPakeForAllValidCard:(void (^)(CardPackAllValidModel *model))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETUSERALLVALIDCARD parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             CardPackAllValidModel *model =[[CardPackAllValidModel alloc] initWithDictionary:responseObject  error:nil];
             if ([model.respStatus intValue] == 1)
             {
                    if(success)
                        success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus intValue]  userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
        
    }
}

+ (void)getCardPakeForAllPastDueCard:(void (^)(CardPackAllPastDueModel *model))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETUSERALLEXPIREDCARD parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             CardPackAllPastDueModel *result =[[CardPackAllPastDueModel alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
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


+ (void)deleteCardPackCardItem:(NSArray *)_cardItemIds
                         model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"cardItemIds":_cardItemIds};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_DELETEUSERCARD parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
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

+ (void)getUserCouponList:(NSNumber *)isPast
                    model:(void (^)(CouponModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"isPast":[Tool urlIsNull:[isPast stringValue] ]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETCOUPONLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             CouponModel *couponModel =[[CouponModel alloc] initWithDictionary:responseObject error:nil];
             if ([couponModel.respStatus intValue] == 1)
             {
                 if(success)
                     success(couponModel);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:couponModel.respMsg code:[couponModel.respStatus intValue]  userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
        
    }
}

+ (void)getMemberAndCouponSum:(void (^)(CardAndCouponCountModel *model))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETCARDANDCOUPONCOUNT parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             CardAndCouponCountModel *cardAndCouponCountModel =[[CardAndCouponCountModel alloc] initWithDictionary:responseObject error:nil];
             if ([cardAndCouponCountModel.respStatus intValue] == 1)
             {
                 if(success)
                     success(cardAndCouponCountModel);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:cardAndCouponCountModel.respMsg code:[cardAndCouponCountModel.respStatus intValue]  userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
        
    }
}

+ (void)deleteCoupon:(NSArray *)_couponIds
               model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"couponIdAndTypeList":_couponIds};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_DELETECOUPON parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *model =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([model.respStatus intValue] == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus intValue]  userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
        
    }
}


@end
