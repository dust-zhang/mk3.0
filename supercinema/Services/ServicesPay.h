//
//  ServicesPay.h
//  movikr
//
//  Created by Mapollo27 on 15/9/15.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayModel.h"
#import "OrderModel.h"
#import "MemberModel.h"

@interface ServicesPay : NSObject

//获取支付列表
+ (void)getPayWayList:(NSString *) orderId
                model:(void (^)(PayModelList *payModelList))success failure:(void (^)(NSError *error))failure;
/*支付回调
 requestTime:超过20秒去请求(秒数)
 payOrderId：主订单id
*/
+ (void)payReturn:(NSString *) requestTime orderId:(NSString *) orderId
            model:(void (^)(PayReturnModel *model))success failure:(void (^)(NSError *error))failure;

//支付轮询
+ (void)orderCycle:(NSString *) orderId
             model:(void (^)(OrderWhileModel *model))success failure:(void (^)(NSError *error))failure;

//获取支付数据,得到后去支付
+(void) getPayDetail:(NSString *)orderId payType:(NSInteger)type
               model:(void (^)(ThirdPayModel *thirdPayModel))success failure:(void (^)(NSError *error))failure;

//购买会员卡
+(void) buyMemberCard:(NSString *)cinemaId cinemaCardId:(NSNumber*)cinemaCardId redPacket:(NSArray *)redPacket  mobileNo:(NSString *)mobileNo
                model:(void (^)(MemberCardModel *memberCardModel))success failure:(void (^)(NSError *error))failure;


@end
