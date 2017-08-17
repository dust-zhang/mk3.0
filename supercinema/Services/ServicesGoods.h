//
//  ServicesGoods.h
//  supercinema
//
//  Created by dust on 16/12/13.
//
//

#import <JSONModel/JSONModel.h>

@interface ServicesGoods : NSObject

+ (void)getSnackList:(NSString *) cinemaId
               model:(void (^)(SnackModel *model))success failure:(void (^)(NSError *error))failure;
//获取小卖详情
+ (void)getSnackDetail:(NSString *)cinemaId goodsId:(NSNumber *) _snackId
                 model:(void (^)(SnackDetailModel *model))success failure:(void (^)(NSError *error))failure;
//创建小卖
+ (void)createSnack:(NSString *)cinemaId cinemaCardId:(NSNumber *)_cinemaCardId
goodsIdAndCountList:(NSArray *) _goodsIdAndCountList mobileNo:(NSNumber*)_mobileNo redPacketIds:(NSArray*)_packetIds
              model:(void (^)(CreateSnackModel *model))success failure:(void (^)(NSError *error))failure;
//获取小卖列表
+ (void)getGoodsList:(NSString *) cinemaId cardId:(NSInteger) cardId showTimeId:(NSInteger ) showTimeId
               array:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;
//获取小卖库存
+ (void)getGoodsListRemainCount:(NSString *)cinemaId goodsIdAndCountList:(NSArray *) _goodsIdAndCountList
                          model:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;
//获取小卖详情
+ (void)getGoodsDetail:(NSString *) subGoodsOrderId
                 model:(void (^)(GoodsListDetailModel *model))success failure:(void (^)(NSError *error))failure;
//兑换小卖
+ (void)exchangeGoods:(NSString *) subGoodsOrderId code:(NSString *) code
                model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;


@end
