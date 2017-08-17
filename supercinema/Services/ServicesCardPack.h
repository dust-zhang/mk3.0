//
//  ServicesCardPack.h
//  supercinema
//
//  Created by dust on 16/11/28.
//
//

#import <Foundation/Foundation.h>
#import "CardPackModel.h"
#import "CouponInfoModel.h"

@interface ServicesCardPack : NSObject

//获取所有有效卡
+ (void)getCardPakeForAllValidCard:(void (^)(CardPackAllValidModel *model))success failure:(void (^)(NSError *error))failure;

//获取所有过期卡
+ (void)getCardPakeForAllPastDueCard:(void (^)(CardPackAllPastDueModel *model))success failure:(void (^)(NSError *error))failure;

//删除卡包数据
+ (void)deleteCardPackCardItem:(NSArray *)_cardItemIds
                         model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;

//删除优惠信息
+ (void)deleteCoupon:(NSArray *)_couponIds
               model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;

//获取优惠券列表
+ (void)getUserCouponList:(NSNumber *)isPast
                    model:(void (^)(CouponModel *model))success failure:(void (^)(NSError *error))failure;

//获取会员权益和优惠券数量
+ (void)getMemberAndCouponSum:(void (^)(CardAndCouponCountModel *model))success failure:(void (^)(NSError *error))failure;
@end
