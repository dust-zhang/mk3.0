//
//  ServicesOrder.h
//  movikr
//
//  Created by Mapollo27 on 15/9/15.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"
#import "NewsOrderListModel.h"
#import "GoodsListModel.h"
#import "SnackModel.h"
#import "SnackDetailModel.h"
#import "MyOrderModel.h"
#import "CouponInfoModel.h"
#import "ShareRedPackModel.h"

@interface ServicesOrder : NSObject

/*创建订单
    showTimeId: 场次ID
    seatid:”1111,2222,4444” //座位ID 使用”,”来连接
    cinemaCardId:1      //会员卡ID
    taopiaoItemId”:1//套票的id
    “ useTaopiaoTicketCount”:2//使用套票的作为数目
    “ cikaOrCardItemId”:12 //使用次卡或者会员卡的id
    “ clientCalculationTotalPrice”:33//客户端计算的应该支付的总价

*/
+ (void)createOrder:(NSInteger )showTimeId seatIds:(NSArray *) seatId
       cinemaCardId:(NSNumber *)cinemaCardId cinemaCardItemId:(NSNumber*)cinemaCardItemId
           goodsArr:(NSArray *)goodsArr redPacketArr:(NSArray *)RedPacketArr
      taopiaoItemId:(NSNumber *)taopiaoItemId useTaopiaoTicketCount:(NSNumber *)useTaopiaoTicketCount
   cikaOrCardItemId:(NSNumber *)cikaOrCardItemId clientCalculationTotalPrice:(NSNumber *)clientCalculationTotalPrice mobileNo:(NSNumber*)_mobileNo  model:(void (^)(CreateOrderModel *model))success failure:(void (^)(NSError *error))failure;

//获取订单详情
+ (void)getOrderDetail:(NSString* ) orderId
              model:(void (^)(OrderInfoModel *model))success failure:(void (^)(NSError *error))failure;

//取消订单
+ (void)orderCancel:(NSString *) orderId
              model:(void (^)(CancelOrderModel *model))success failure:(void (^)(NSError *error))failure;

//删除订单
+ (void)orderDelete:(NSString *) orderId type:(int)type
              model:(void (^)(DeleteSubOrderModel *model))success failure:(void (^)(NSError *error))failure;

////删除优惠券
//+ (void)couponDelete:(int) couponId type:(int)couponType
//              model:(void (^)(DeleteSubOrderModel *model))success failure:(void (^)(NSError *error))failure;

//获取有效订单
+ (void)getValidOrderList:(NSString *) pageIndex 
               model:(void (^)(OrderValidListModel *model))success failure:(void (^)(NSError *error))failure;

//获取往期订单
+ (void)getPastOrderList:(NSString *) pageIndex
                   model:(void (^)(OrderPastListModel *model))success failure:(void (^)(NSError *error))failure;

//获取订单新接口
+ (void)getOrderList_News:(NSNumber *)type nextPage:(NSString *)nextPageNo includeGift:(NSNumber *)includeGift
                    model:(void (^)(NewsOrderListModel *model))success failure:(void (^)(NSError *error))failure;
//获取优惠券
+ (void)getCouponInfoNew:(NSNumber *)couponId couponType:(NSNumber *)couponType
                   model:(void (^)(CouponInfoModel *model))success failure:(void (^)(NSError *error))failure;
//使用优惠券
+ (void)userCoupon:(NSNumber *) couponId couponType:(NSNumber *) couponType
             model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;

+ (void)userCouponNew:(NSNumber *) couponId couponType:(NSNumber *)couponType userCode:(NSString *) userCode
             model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;
//获取通票详情
+ (void)getTongPiaoDetail:(NSNumber *) tongPiaoId
                 model:(void (^)(TongPiaoInfoModel *model))success failure:(void (^)(NSError *error))failure;
//获取我的订单
+(void) getMyAllOrder:(int)pageIndex
                model:(void (^)(MyOrderModel *model))success failure:(void (^)(NSError *error))failure;
//未支付
+(void) getMyUnPaidOrder:(int)pageIndex
                model:(void (^)(MyOrderModel *model))success failure:(void (^)(NSError *error))failure;
//未使用
+(void) getMyUnUserdOrder:(int)pageIndex
                model:(void (^)(MyOrderModel *model))success failure:(void (^)(NSError *error))failure;
//退款
+(void) getMyRefundedOrder:(int)pageIndex
                model:(void (^)(MyOrderModel *model))success failure:(void (^)(NSError *error))failure;
//删除我的订单
+ (void)deleteMyOrder:(NSArray *) orderId
                model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;
//订单红包分享
+ (void)getOrderShareInfo:(NSNumber *) orderId
                    model:(void (^)(ShareRedPackModel *model))success failure:(void (^)(NSError *error))failure;










@end
