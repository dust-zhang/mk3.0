//
//  ServiceActivity.h
//  movikr
//
//  Created by Mapollo27 on 16/4/7.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityViewModel.h"
#import "ActivityAwardModel.h"

@interface ServiceActivity : NSObject

//获取指定影院下的活动列表
+ (void)getActivityListByCinemaId:(NSString* )cinemaId
                            array:(void (^)(ActivityListModel *model))success failure:(void (^)(NSError *error))failure;
//获取活动详情
+ (void)getActivityDetail:(NSNumber* )notifyId
                            model:(void (^)(NotifyListModel *model))success failure:(void (^)(NSError *error))failure;
//获取获取用户在活动的参加情况
//+ (void)getJoinInfoListByActivityIds:(NSString* )cinemaId activityArr:(NSArray *)arr
//                               array:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;
//立即参加活动
+ (void)joinActivity:(NSString* )cinemaId activityId:(NSNumber *)aId
               model:(void (^)(RequestResult * model))success failure:(void (^)(NSError *error))failure;
//立即领取
+ (void)receiveActivity:(NSString* )cinemaId activityId:(NSNumber *)aId
                  model:(void (^)(ActivityRootModel *model))success failure:(void (^)(NSError *error))failure;
//购卡购票成功，获取奖品（活动领取奖品）
+ (void)getAwardList:(NSString* )orderId
               model:(void (^)(ActivityAwardModel *model))success failure:(void (^)(NSError *error))failure;

@end
