//
//  ServicesRedPacket.h
//  movikr
//
//  Created by Mapollo27 on 16/4/7.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedPacketModel.h"

@interface ServicesRedPacket : NSObject

//获取红包详情
+ (void)getRedPacketDetail:(NSNumber* )redPacketId
                     model:(void (^)(RedPacketModel * model))success failure:(void (^)(NSError *error))failure;

//获取红包列表
+ (void)getRedPacketList:(NSNumber* )showtimeId cinemaId:(NSString *)cinemaId cardItemId:(NSNumber *)cardItemId
     goodsIdAndCountList:(NSArray *)goodsIdAndCountList ticketCount:(NSNumber *)ticketCount
                   array:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure;

//获取可用卡列表
+ (void)getOrderCanUseCinemaCardList:(NSNumber* )showtimeId ticketCount:(NSNumber *)ticketCount cardId:(NSNumber*)cardId
                               array:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure;

//获取红包的使用列表
+ (void)getRedPacketUseCinemaList:(NSNumber* )redPacketId
                            model:(void (^)(RedPacketCinemaListModel *model))success failure:(void (^)(NSError *error))failure;

@end
