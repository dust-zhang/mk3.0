//
//  ServicesOrder.m
//  movikr
//
//  Created by Mapollo27 on 15/9/15.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "ServicesOrder.h"

@protocol NSDictionary;
@implementation ServicesOrder

+ (void)createOrder:(NSInteger )showTimeId seatIds:(NSArray *) seatId
       cinemaCardId:(NSNumber *)cinemaCardId cinemaCardItemId:(NSNumber*)cinemaCardItemId
           goodsArr:(NSArray *)goodsArr redPacketArr:(NSArray *)RedPacketArr
      taopiaoItemId:(NSNumber *)taopiaoItemId useTaopiaoTicketCount:(NSNumber *)useTaopiaoTicketCount
   cikaOrCardItemId:(NSNumber *)cikaOrCardItemId clientCalculationTotalPrice:(NSNumber *)clientCalculationTotalPrice mobileNo:(NSNumber*)_mobileNo  model:(void (^)(CreateOrderModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"showtimeId":[NSNumber numberWithInteger:showTimeId],
                           @"seatIds":[Tool returnStringPlus:seatId],
                           @"supplierId":@"1",
                           @"cinemaCardId":[Tool urlIsNull:[cinemaCardId stringValue]],
                           @"cinemaCardItemId":[Tool urlIsNull:[cinemaCardItemId stringValue]],
                           @"taopiaoItemId":[Tool urlIsNull:[taopiaoItemId stringValue]],                                  //套票的id
                           @"useTaopiaoTicketCount":[Tool urlIsNull:[useTaopiaoTicketCount stringValue]],                  //使用套票的作为数目
                           @"cikaOrCardItemId":[Tool urlIsNull:[cikaOrCardItemId stringValue]],                            //使用次卡或者会员卡的id
                           @"clientCalculationTotalPrice":[Tool urlIsNull:[clientCalculationTotalPrice stringValue]],       //客户端计算的应该支付的总价
                           @"useMobileNumber":[Tool urlIsNull:[_mobileNo stringValue]]
                           };
    
    if (goodsArr.count > 0 && RedPacketArr.count >0)
    {
        body = @{@"showtimeId":[NSNumber numberWithInteger:showTimeId],
                 @"seatIds":[Tool returnStringPlus:seatId],
                 @"supplierId":@"1",
                 @"cinemaCardId":[Tool urlIsNull:[cinemaCardId stringValue]],
                 @"cinemaCardItemId":[Tool urlIsNull:[cinemaCardItemId stringValue]],
                 @"goodsIdAndCountList":goodsArr,
                 @"redPacketIds":RedPacketArr,
                 @"taopiaoItemId":[Tool urlIsNull:[taopiaoItemId stringValue]],                                  //套票的id
                 @"useTaopiaoTicketCount":[Tool urlIsNull:[useTaopiaoTicketCount stringValue]],                  //使用套票的作为数目
                 @"cikaOrCardItemId":[Tool urlIsNull:[cikaOrCardItemId stringValue]],                            //使用次卡或者会员卡的id
                 @"clientCalculationTotalPrice":[Tool urlIsNull:[clientCalculationTotalPrice stringValue] ],       //客户端计算的应该支付的总价
                @"useMobileNumber":[Tool urlIsNull:[_mobileNo stringValue]]
                 };
    }
    if (goodsArr.count > 0 && RedPacketArr.count <= 0)
    {
        body = @{@"showtimeId":[NSNumber numberWithInteger:showTimeId],
                 @"seatIds":[Tool returnStringPlus:seatId],
                 @"supplierId":@"1",
                  @"cinemaCardId":[Tool urlIsNull:[cinemaCardId stringValue]],
                 @"cinemaCardItemId":cinemaCardItemId,
                 @"goodsIdAndCountList":goodsArr,
                 @"taopiaoItemId":[Tool urlIsNull:[taopiaoItemId stringValue]],                                  //套票的id
                 @"useTaopiaoTicketCount":[Tool urlIsNull:[useTaopiaoTicketCount stringValue]],                  //使用套票的作为数目
                 @"cikaOrCardItemId":[Tool urlIsNull:[cikaOrCardItemId stringValue]],                            //使用次卡或者会员卡的id
                 @"clientCalculationTotalPrice":[Tool urlIsNull:[clientCalculationTotalPrice stringValue] ],       //客户端计算的应该支付的总价
                 @"useMobileNumber":[Tool urlIsNull:[_mobileNo stringValue]]                 };
    }
    if (goodsArr.count <= 0 && RedPacketArr.count >0)
    {
        body = @{@"showtimeId":[NSNumber numberWithInteger:showTimeId],
                 @"seatIds":[Tool returnStringPlus:seatId],
                 @"supplierId":@"1",
                 @"cinemaCardId":[Tool urlIsNull:[cinemaCardId stringValue]],
                 @"cinemaCardItemId":cinemaCardItemId,
                 @"redPacketIds":RedPacketArr,
                 @"taopiaoItemId":[Tool urlIsNull:[taopiaoItemId stringValue]],                                  //套票的id
                 @"useTaopiaoTicketCount":[Tool urlIsNull:[useTaopiaoTicketCount stringValue]],                  //使用套票的作为数目
                 @"cikaOrCardItemId":[Tool urlIsNull:[cikaOrCardItemId stringValue]],                            //使用次卡或者会员卡的id
                 @"clientCalculationTotalPrice":[Tool urlIsNull:[clientCalculationTotalPrice stringValue] ],       //客户端计算的应该支付的总价
                 @"useMobileNumber":[Tool urlIsNull:[_mobileNo stringValue]]
                 };
    }
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_CREATEORDER parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSLog(@"%@",[responseObject JSONString]);
            
            RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
            if ([result.respStatus integerValue]  == 1)
            {
                if([responseObject isKindOfClass:[NSDictionary class]])
                {
                    NSError* err = nil;
                    CreateOrderModel *createOrderModel = [[CreateOrderModel alloc] initWithString:[responseObject JSONString] error:&err];
                    if(err!=nil)
                    {
                        NSLog(@"%@",err );
                        failure(err);
                    }
                    if(success)
                        success(createOrderModel);
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

+ (void)getOrderDetail:(NSString* ) orderId
              model:(void (^)(OrderInfoModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"orderId":[Tool urlIsNull:orderId],
                           @"deviceWith":[NSNumber numberWithInteger:SCREEN_WIDTH]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETORDERINFO parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSLog(@"%@",[responseObject JSONString]);
            RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus integerValue]  == 1)
            {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSError* err = nil;
                     OrderInfoModel *orderInfoModel = [[OrderInfoModel alloc] initWithString:[responseObject JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                         failure(err);
                     }
                     if(success)
                         success(orderInfoModel);
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

+ (void)getValidOrderList:(NSString *) pageIndex
               model:(void (^)(OrderValidListModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"nextSeq":[Tool urlIsNull:pageIndex],
                          @"orderType":@"1"};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETORDERLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
              if ([result.respStatus integerValue]  == 1)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSError* err = nil;
                     OrderValidListModel *orderListModel = [[OrderValidListModel alloc] initWithString:[responseObject JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                         failure(err);
                     }
                     if(success)
                         success(orderListModel);
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

+ (void)getPastOrderList:(NSString *) pageIndex
                   model:(void (^)(OrderPastListModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"nextSeq":[Tool urlIsNull:pageIndex],
                          @"orderType":@"2"};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETORDERLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
              if ([result.respStatus integerValue]  == 1)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSError* err = nil;
                     OrderPastListModel *orderListModel = [[OrderPastListModel alloc] initWithString:[responseObject JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                         failure(err);
                     }
                     if(success)
                         success(orderListModel);
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

+ (void)orderCancel:(NSString *) orderId
              model:(void (^)(CancelOrderModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"orderId":[Tool urlIsNull:orderId] };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_CANCELORDER parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
              if ([result.respStatus integerValue]  == 1)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSError* err = nil;
                     CancelOrderModel *cancelOrderModel = [[CancelOrderModel alloc] initWithString:[responseObject JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                         failure(err);
                     }
                     if(success)
                         success(cancelOrderModel);
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

+ (void)orderDelete:(NSString *) orderId type:(int)type
              model:(void (^)(DeleteSubOrderModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"subOrderId":[Tool urlIsNull: orderId],
                          @"subOrderType":[NSNumber numberWithInt:type]};
   
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         [MKNetWorkRequest POST:URL_DELETEORDER parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
              if (result.respStatus  == 0)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSError* err = nil;
                     DeleteSubOrderModel *deleteSubOrderModel = [[DeleteSubOrderModel alloc] initWithString:[responseObject JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                         failure(err);
                     }
                     if(success)
                         success(deleteSubOrderModel);
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

////删除优惠券
//+ (void)couponDelete:(int) couponId type:(int)couponType
//               model:(void (^)(DeleteSubOrderModel *model))success failure:(void (^)(NSError *error))failure
//{
//    NSDictionary *body =@{@"couponId":[NSNumber numberWithInt:couponId],@"couponType":[NSNumber numberWithInt:couponType]};
//    
//    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
//    {
//        if(failure)
//           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
//    }
//    else
//    {
//        [MKNetWorkRequest POST:URL_DELETECOUPON parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
//        {
//             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
//             if ([result.respStatus integerValue]  == 1)
//             {
//                 if([responseObject isKindOfClass:[NSDictionary class]])
//                 {
//                     //                 NSDictionary *arrDic = [responseObject objectForKey:@"b"];
//                     NSError* err = nil;
//                     DeleteSubOrderModel *deleteSubOrderModel = [[DeleteSubOrderModel alloc] initWithString:[responseObject JSONString] error:&err];
//                     if(err!=nil)
//                     {
//                         NSLog(@"%@",err );
//                         failure(err);
//                     }
//                     if(success)
//                         success(deleteSubOrderModel);
//                 }
//             }
//             else
//             {
//                 if(failure)
//                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus integerValue]  userInfo:nil]);
//             }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            if(failure)
//                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
//        }];
//    }
//}

//获取优惠券信息
+ (void)getCouponInfoNew:(NSNumber *)couponId couponType:(NSNumber *)couponType
                model:(void (^)(CouponInfoModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"couponId":[Tool urlIsNull:[couponId stringValue]],
                          @"couponType":[Tool urlIsNull:[couponType stringValue]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         [MKNetWorkRequest POST:URL_GETCOUPONINFONEW parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus integerValue]  == 1)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSDictionary *arrDic = [responseObject objectForKey:@"couponInfo"];
                     NSError* err = nil;
                     CouponInfoModel *couponInfoModel = [[CouponInfoModel alloc] initWithString:[arrDic JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                         failure(err);
                     }
                     if(success)
                         success(couponInfoModel);
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

    }}


//获取订单新接口
+ (void)getOrderList_News:(NSNumber *)type nextPage:(NSString *)nextPageNo includeGift:(NSNumber *)includeGift
                model:(void (^)(NewsOrderListModel *model))success failure:(void (^)(NSError *error))failure
{
    //1:有效,2:往期
    if (nextPageNo.length==0) {
        nextPageNo = @"";
    }
     NSDictionary *body =@{@"orderType":[Tool urlIsNull:[type stringValue] ],
                           @"nextSeq":[Tool urlIsNull:nextPageNo ],
                           @"includeGift":[Tool urlIsNull:[includeGift stringValue] ],
                           @"includeGoods":[Tool urlIsNull:[includeGift stringValue] ]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        //发送请求
        [MKNetWorkRequest POST:URL_CARDPAGELIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus integerValue]  == 1)
             {
                 NSError* err = nil;
                 NewsOrderListModel *orderModel = [[NewsOrderListModel alloc] initWithString:[responseObject JSONString] error:&err];
                 if(err!=nil)
                 {
                     NSLog(@"%@",err );
                     failure(err);
                 }
                 if(success)
                     success(orderModel);
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

+ (void)userCoupon:(NSNumber *) couponId couponType:(NSNumber *) couponType
              model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"couponId":[Tool urlIsNull:[couponId stringValue]],
                          @"couponType":[Tool urlIsNull:[couponType stringValue]]};
   
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_USECOUPONNEW parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
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

+ (void)userCouponNew:(NSNumber *) couponId couponType:(NSNumber *)couponType userCode:(NSString *) userCode
             model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    if ([userCode length] == 0)
    {
        userCode = @"";
    }
    
    NSDictionary *body =@{@"couponId":[Tool urlIsNull:[couponId stringValue]],
                         @"couponType":[Tool urlIsNull:[couponType stringValue]],
                         @"userCode":userCode};
   
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_USECOUPONNEW parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
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

+ (void)getTongPiaoDetail:(NSNumber *) tongPiaoId
                    model:(void (^)(TongPiaoInfoModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"id":[Tool urlIsNull:[tongPiaoId stringValue]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETTONGPIAODETAIL parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus integerValue]  == 1)
             {
                 NSError* err = nil;
                 TongPiaoInfoModel *tongpiaoDetail = [[TongPiaoInfoModel alloc] initWithString:[[responseObject objectForKey:@"tongpiaoInfo"]JSONString] error:&err];
                 if(err!=nil)
                 {
                     NSLog(@"%@",err );
                     failure(err);
                 }
                 if(success)
                     success(tongpiaoDetail);
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
+(void) getMyAllOrder:(int)pageIndex
                model:(void (^)(MyOrderModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"pageIndex":[NSNumber numberWithInt:pageIndex]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETMYALLORDER parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);

             MyOrderModel *model =[[MyOrderModel alloc] initWithDictionary:responseObject error:nil];
             if ([model.respStatus integerValue]  == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus integerValue]  userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}


+(void) getMyUnPaidOrder:(int)pageIndex
                model:(void (^)(MyOrderModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"pageIndex":[NSNumber numberWithInt:pageIndex]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETMYUNPAIDORDER parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             MyOrderModel *model =[[MyOrderModel alloc] initWithDictionary:responseObject error:nil];
             if ([model.respStatus integerValue]  == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus integerValue]  userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+(void) getMyUnUserdOrder:(int)pageIndex
                model:(void (^)(MyOrderModel *model))success failure:(void (^)(NSError *error))failure
{
     NSDictionary *body = @{@"pageIndex":[NSNumber numberWithInt:pageIndex]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETUNUSEDORDER parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             MyOrderModel *model =[[MyOrderModel alloc] initWithDictionary:responseObject error:nil];
             if ([model.respStatus integerValue]  == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus integerValue]  userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+(void) getMyRefundedOrder:(int)pageIndex
                model:(void (^)(MyOrderModel *model))success failure:(void (^)(NSError *error))failure
{
     NSDictionary *body = @{@"pageIndex":[NSNumber numberWithInt:pageIndex]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETREFUNDEDORDER parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             MyOrderModel *model =[[MyOrderModel alloc] initWithDictionary:responseObject error:nil];
             if ([model.respStatus integerValue]  == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus integerValue]  userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)deleteMyOrder:(NSArray *) orderId
                model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"orderIds":orderId};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_DELETEMYORDER parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus  intValue]== 1)
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

+ (void)getOrderShareInfo:(NSNumber *) orderId
                model:(void (^)(ShareRedPackModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"orderId":orderId};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETORDERREDPACKSHAREINFO parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             ShareRedPackModel *result =[[ShareRedPackModel alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus  intValue]== 1)
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
