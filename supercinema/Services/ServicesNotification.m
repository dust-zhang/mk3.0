//
//  ServicesNotification.m
//  movikr
//
//  Created by Mapollo27 on 16/4/1.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import "ServicesNotification.h"
#import "sqlDatabase.h"

@protocol NSDictionary;
@implementation ServicesNotification

//获取系统内部通知
+ (void)getMessageNotfication:(NSString *)cinemaId
                        trueFalse:(void (^)(NSNumber *trueFalse))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"cinemaId":[Tool urlIsNull:cinemaId ] ,@"lastPullTime":[self getCinemaTime:cinemaId ] };
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [MKNetWorkRequest POST:URL_MESSAGENOTICE parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSLog(@"%@",[responseObject JSONString]);
            
            NSError* err = nil;
            NotifictionModel *nModel = [[NotifictionModel alloc] initWithString:[responseObject JSONString] error:&err];
           
            //如果服务器时间大于数据库存储时间，则把每天显示一次的数据showHide 修改成0
            CinemaPullModel *pullModel = [[CinemaPullModel alloc ] init];
            pullModel = [sqlDatabase selectCinemaTime:cinemaId];
            if (![[Tool returnTime:nModel.currentTime format:@"yyyy-MM-dd"] isEqualToString:[Tool returnTime:pullModel.pullTime format:@"yyyy-MM-dd"]])
            {
                [sqlDatabase updateNotice:@2 cinemaId:cinemaId];
            }
            
            //保存每次拉取服务时间
            [weakSelf updateCinemaPullTime:nModel.currentTime cinemaId:cinemaId];
            
            if(err == nil)
            {
                NSMutableArray *arrNotifty = [self traverseNotice:nModel cinemaId:cinemaId];
                //将数据插入到数据库,因为存在主键第一次插入成功则不能再次插入
                if([arrNotifty count] > 0 && arrNotifty != nil)
                {
                    //删除已经下线的通知
                    [weakSelf deleteInvalidNotice:arrNotifty cinemaId:cinemaId];
                    //保存已经审核的通知

                    if([sqlDatabase insertNoticeData:arrNotifty cinemaId:cinemaId])
                    {
                        if(success)
                            success(@1);
                    }
                    else
                    {
                        if(failure)
                            failure([NSError errorWithDomain:@"写入数据失败" code:0 userInfo:nil]);
                    }
                }
                else
                {
                    if(failure)
                        failure([NSError errorWithDomain:[responseObject objectForKey:@"respMsg" ] code:[[responseObject objectForKey:@"respStatus" ] intValue] userInfo:nil]);
                }
            }
            else
            {
                failure(err);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@",[error localizedDescription]);
             if(failure)
                 failure(error);
         }];
    }
}

//从拉取的通知中删除无效通知，然后在插入数据库
+(void)deleteNoavailNotice:(NSMutableArray *)arr
{
    NotifyListModel *notifyModel = [[NotifyListModel alloc] init];
    for (int i = 0 ; i <[arr count] ; i++)
    {
        notifyModel = [arr objectAtIndex:i];
        if ([notifyModel.status intValue] != 1)
        {
            [arr removeObjectAtIndex:i];
            i--;
        }
    }
}

+(void) deleteInvalidNotice:(NSMutableArray *)arrNotcie  cinemaId:(NSString *)_cinemaId
{
    NotifyListModel *notifyModel = [[NotifyListModel alloc] init];
    for(int i = 0 ; i < [arrNotcie count]; i++)
    {
        notifyModel =arrNotcie[i];
        if ([notifyModel.status intValue] != 1)
        {
            [sqlDatabase deleteNotice:[NSString stringWithFormat:@"delete from table_notice where notifyId='%@' and cinemaid='%@'",notifyModel.notifyId,_cinemaId ]];
        }
    }
}

//重新组合通知
+(NSMutableArray *) traverseNotice:(NotifictionModel* ) nModel cinemaId:(NSString *)_cinemaId
{
    NSMutableArray *arr = [[NSMutableArray alloc ] initWithCapacity:0];
    [arr removeAllObjects];
    NotifyListModel *notifyModel = [[NotifyListModel alloc] init];
    ConditionListModel *conditionModel = [[ConditionListModel alloc] init];
    
    for (int i = 0; i < [nModel.notifyList count] ; i++)
    {
        notifyModel =[nModel.notifyList objectAtIndex:i];
        
        for (int j = 0; j < [nModel.conditionList count] ; j++)
        {
            conditionModel = [nModel.conditionList objectAtIndex:j];
            //如果id相同
            if ( [notifyModel.notifyId intValue] == [conditionModel.notifyId intValue] )
            {
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                NSString *notfId =[[numberFormatter stringFromNumber:notifyModel.notifyId  ] stringByAppendingString:_cinemaId];
                notifyModel.notifyId = [NSNumber numberWithInt:[notfId intValue] ];
                notifyModel.cinemaId = [NSNumber numberWithInt:[_cinemaId intValue]];
                notifyModel.actionType = conditionModel.actionType;
                notifyModel.conditionId = conditionModel.conditionId;
                notifyModel.frequencyType = conditionModel.frequencyType;
                notifyModel.currentTime = nModel.currentTime;
                [arr addObject:notifyModel];
                break;
            }
        }
    }
    return arr;
}

+(BOOL) updateCinemaPullTime:(NSNumber *)time  cinemaId:(NSString *)_cinemaId
{
    if ( ![sqlDatabase updateTablePull:[NSString stringWithFormat:@"update table_pull set pulldatetime = %@ where cinemaid=%@ ",time,_cinemaId ]  ])
    {
        return FALSE;
    }
    return TRUE;
}

//读取当前影院本地存储的上次拉取时间
+(NSNumber *) getCinemaTime:(NSString *)_cinemaId
{
    CinemaPullModel * cinemaPullModel= nil;
    cinemaPullModel =[sqlDatabase selectCinemaTime:_cinemaId];
    NSLog(@"%@",cinemaPullModel.pullTime);
    
    //本地未能读取到当前影院上次拉取时间
    if (cinemaPullModel == nil)
    {
        //数据库不存在，则插入数据库
        if(![sqlDatabase insertPullTime:[Tool returnTimestamp:[Tool getSystemDate:@"YYYY-MM-dd HH:mm:ss"] ]cinemaId:_cinemaId ])
        {
            return @0;
        }
        return @0;
    }
    else
    {
        return [NSNumber numberWithInteger:[cinemaPullModel.pullTime integerValue]];
    }
    return @0;

}

+(void)addNoticeCount:(NSString *)sourceType countObjectId:(NSNumber*)countObjectId
               result:(void (^)(RequestResult *result))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body;
    body = @{@"sourceType":[Tool urlIsNull:sourceType],
             @"countObjectId":[Tool urlIsNull:[countObjectId stringValue]] };
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         [MKNetWorkRequest POST:URL_NOTICECOUNT parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue]  == 1)
             {
                 if(success)
                    success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@",[error localizedDescription]);
             if(failure)
                 failure(error);
         }];
    }

}

+(void)getNotifityList:(NSNumber *)pageIndex
               result:(void (^)(SystemNoticeModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"pageIndex":[Tool urlIsNull:[pageIndex stringValue]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETNOTICTIONLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
             NSLog(@"%@",[responseObject JSONString]);
             
             SystemNoticeModel *model =[[SystemNoticeModel alloc] initWithDictionary:responseObject error:nil];
             if ([model.respStatus intValue]  == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@",[error localizedDescription]);
             if(failure)
                 failure(error);
         }];
    }
    
}


+(void)setNoticeRead:(NSArray *)arrNoticeId
                result:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"societNotifyIdList":arrNoticeId};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_SETNOTIFYREAD parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *model =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([model.respStatus intValue]  == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@",[error localizedDescription]);
             if(failure)
                 failure(error);
         }];
    }
    
}


+(void)deleteNotice:(NSArray *)arrNoticeId
              result:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"societNotifyIdList":arrNoticeId};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_DELETENOTIFYLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *model =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([model.respStatus intValue]  == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@",[error localizedDescription]);
             if(failure)
                 failure(error);
         }];
    }
    
}











@end
