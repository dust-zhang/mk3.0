//
//  ServicesGame.h
//  supercinema
//
//  Created by dust on 2017/2/9.
//
//

#import <Foundation/Foundation.h>


@interface ServicesGame : NSObject

+ (void)getUserGameData:(NSString *) gameId
                 result:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)startPlayGame:(NSString *) gameId playInCinemaId:(NSString *) cinemaId
               result:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure;
/*
 "roundId": 1147,  //回合ID
 "goldCount": 100, //金币数
 "isFirstPlay": true, //是否为首玩
 //大招索引和活动数量
 "strokesIndexAndCountList": [
 "12-5" //index-count
 ]
 */
+ (void)finishPlayGame:(NSString *) roundId goldCount:(NSString *) goldCount isFirstPlay:(NSString *) isFirstPlay strokesIndexAndCountList:(NSArray *)strokesIndexAndCountList
                  result:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)cancelRound:(NSString *) roundId
              result:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)receiveChest:(NSString *) chestId
              result:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure;
//获取商城可售列表
+ (void)getGroupGoodsList:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure;
//购买商城商品
+ (void)buyGoods:(NSString *) goodsId
              result:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure;





@end
