//
//  ServicesNotification.h
//  movikr
//
//  Created by Mapollo27 on 16/4/1.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDBHelper.h"
#import "NotifictionModel.h"
#import "SystemNoticeModel.h"

@interface ServicesNotification : NSObject

//获取广播消息
+ (void)getMessageNotfication:(NSString *)cinemaId 
                    trueFalse:(void (^)(NSNumber *trueFalse))success failure:(void (^)(NSError *error))failure;

+(NSMutableArray *) traverseNotice:(NotifictionModel* ) nModel cinemaId:(NSString *)_cinemaId;
//删除无效的通知
+(void) deleteInvalidNotice:(NSMutableArray *)arrNotcie cinemaId:(NSString *)_cinemaId;

//添加通知统计
////sourceType :notify_display(通知显示)，notify_click(通知点击)
+(void)addNoticeCount:(NSString *)sourceType countObjectId:(NSNumber *)countObjectId
               result:(void (^)(RequestResult *result))success failure:(void (^)(NSError *error))failure;

//获取通知列表
+(void)getNotifityList:(NSNumber *)pageIndex
                result:(void (^)(SystemNoticeModel *model))success failure:(void (^)(NSError *error))failure;

//批量设置社交通知为已读
+(void)setNoticeRead:(NSArray *)arrNoticeId
              result:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;

//批量删除社交通知
+(void)deleteNotice:(NSArray *)arrNoticeId
             result:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;

@end
