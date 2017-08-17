//
//  NotifictionModel.h
//  movikr
//
//  Created by Mapollo27 on 16/4/1.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConditionListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *validStartTime;
@property (nonatomic,strong) NSNumber <Optional> *validEndTime;
@property (nonatomic,strong) NSNumber <Optional> *actionType;
@property (nonatomic,strong) NSNumber <Optional> *conditionId;
@property (nonatomic,strong) NSNumber <Optional> *notifyId;
@property (nonatomic,strong) NSNumber <Optional> *frequencyType;
@end


@interface NotifyListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *notifyId;
@property (nonatomic,strong) NSNumber <Optional> *cinemaId;
@property (nonatomic,strong) NSNumber <Optional> *validStartTime;
@property (nonatomic,strong) NSNumber <Optional> *validEndTime;
@property (nonatomic,strong) NSNumber <Optional> *activityEndTime;//活动截止时间
@property (nonatomic,strong) NSNumber <Optional> *lastUpdateTime;//最新的活动
@property (nonatomic,strong) NSString <Optional> *title;
//0:活动通知，1:广播公告，2:消息中心，3:启动页广告，4:H5通知
@property (nonatomic,strong) NSNumber <Optional> *notifyType;
//跳转类型 1:无，2:h5页面，3:app内界面
@property (nonatomic,strong) NSNumber <Optional> *jumpType;
//可能是url，还有可能是数字"活动中心：1","卡包页：2","钻石-vip特权页：3", "成长任务页：4","首页：5"
@property (nonatomic,strong) NSString <Optional> *jumpUrl;
@property (nonatomic,strong) NSString <Optional> *movieId;
@property (nonatomic,strong) NSString <Optional> *notifyContent;
@property (nonatomic,strong) NSString <Optional> *notifyImageUrl;
//图片素材类型：0是其它，1是图片，2是页面
@property (nonatomic,strong) NSNumber <Optional> *imageJumpUrlType;
//状态：1.已审核 2.未审核 3.下线
@property (nonatomic,strong) NSNumber <Optional> *status;
//触发的类型 （查看逻辑说明部分）打开 唤起app==
@property (nonatomic,strong) NSNumber <Optional> *actionType;
@property (nonatomic,strong) NSNumber <Optional> *conditionId;
@property (nonatomic,strong) NSNumber <Optional> *frequencyType;
//后添加字段，记录显示状态
@property (nonatomic,strong) NSNumber <Optional> *showHide;
@property (nonatomic,strong) NSNumber <Optional> *currentTime;//系统时间
@end

@protocol ConditionListModel;
@protocol NotifyListModel;
@interface NotifictionModel : JSONModel
@property (nonatomic,strong) NSArray <Optional,ConditionListModel> *conditionList;
@property (nonatomic,strong) NSArray <Optional,NotifyListModel> *notifyList;
@property (nonatomic,strong) NSNumber <Optional> *seq;
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSNumber <Optional> *currentTime;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@end


@interface CinemaPullModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *cinemaId;
@property (nonatomic,strong) NSNumber <Optional> *pullTime;
@end
