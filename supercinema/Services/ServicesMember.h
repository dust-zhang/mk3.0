//
//  ServicesMember.h
//  movikr
//
//  Created by Mapollo27 on 15/9/15.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberModel.h"

@interface ServicesMember : NSObject

//获取影院和用户已经购买的会员卡
+ (void)getCinemaUserCardList:(NSString*)cinemaId
                model:(void (^)(MemberModel *memberModel))success failure:(void (^)(NSError *error))failure;
//获取会员卡优惠信息
+ (void)getMemberCardFavorableInfo:(NSString*)cinemaId cardItemIds:(NSArray *)cardItemIds
                             array:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;
@end
