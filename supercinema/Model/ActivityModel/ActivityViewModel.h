//
//  ActivityViewModel.h
//
//  Created by Mapollo28 on 16/1/22.
//  Copyright © 2016年 Mapollo28. All rights reserved.
//

#import <Foundation/Foundation.h>

//活动内容
@protocol ActivityUserListModel;
@interface ActivityModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>    *endValidTime;
@property (nonatomic,strong) NSNumber<Optional>    *activityCategory;
@property (nonatomic,strong) NSString<Optional>    *activityImageUrl;
@property (nonatomic,strong) NSString<Optional>    *activityDescription;
@property (nonatomic,strong) NSNumber<Optional>    *joinCount;
@property (nonatomic,strong) NSNumber<Optional>    *activityId;
@property (nonatomic,strong) NSNumber<Optional>    *joinType;
@property (nonatomic,strong) NSString<Optional>    *activityTitle;
@property (nonatomic,strong) NSString<Optional>    *buttonLink;
@property (nonatomic,strong) NSString<Optional>    *detailUrl;
@property (nonatomic,strong) NSNumber<Optional>    *receiveCount;
@property (nonatomic,strong) NSNumber<Optional>    *startValidTime;
@property (nonatomic,strong) NSNumber<Optional>    *joinStatus;
@property (nonatomic,strong) NSNumber<Optional>    *validUseCount;          //有效的使用次数（立即领取、抽奖形式的活动，在判断joinStatus的前提下，还需要判断有效次数>0）
@property (nonatomic,strong) NSNumber<Optional>    *listShowStatus;         //列表的显示状态 1:即将开始 2:去参加 3:已参加 4:已结束
@property (nonatomic,strong) NSNumber<Optional>    *activityValidType;      //0:往期活动 1:有效活动
@property (nonatomic,strong) NSString<Optional>    *activityDaysDesc;       //结束时间的显示规则("结束时间:2017年01月11日")
@property (nonatomic,strong) NSArray<ActivityUserListModel,Optional>    *userList;  //参加活动的用户列表
@end

@interface ActivityUserListModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>    *id;
@property (nonatomic,strong) NSString<Optional>    *nickname;
@property (nonatomic,strong) NSString<Optional>    *portraitUrl;            //为空则说明头像不存在
@end

//用户参与model
@interface UserJoinActivityModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>    *joinType;
@property (nonatomic,strong) NSNumber<Optional>    *activityId;
@property (nonatomic,strong) NSNumber<Optional>    *receiveCount;
@property (nonatomic,strong) NSNumber<Optional>    *joinCount;
@property (nonatomic,strong) NSNumber<Optional>    *activityCategory;
@property (nonatomic,strong) NSNumber<Optional>    *joinStatus;
@property (nonatomic,strong) NSNumber<Optional>    *validUseCount;
@property (nonatomic,strong) NSNumber<Optional>    *startValidTime;
@property (nonatomic,strong) NSNumber<Optional>    *endValidTime;
@end

@protocol ActivityModel;
@interface ActivityListModel : JSONModel
@property (nonatomic,strong) NSString<Optional>    *seq;
@property (nonatomic,strong) NSNumber<Optional>    *respStatus;
@property (nonatomic,strong) NSNumber<Optional>    *currentTime;
@property (nonatomic,strong) NSString<Optional>    *respMsg;
@property (nonatomic,strong) NSArray<ActivityModel,Optional>    *activityList;
@end

@interface ActivityReceviceModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>    *joinType;
@property (nonatomic,strong) NSNumber<Optional>    *activityId;
@property (nonatomic,strong) NSNumber<Optional>    *receiveCount;
@property (nonatomic,strong) NSNumber<Optional>    *joinCount;
@property (nonatomic,strong) NSNumber<Optional>    *activityCategory;
@property (nonatomic,strong) NSNumber<Optional>    *canJoin;
@property (nonatomic,strong) NSString<Optional>    *activityTitle;
@property (nonatomic,strong) NSNumber<Optional>    *startValidTime;
@property (nonatomic,strong) NSNumber<Optional>    *endValidTime;
@end

@interface GrantListModel : JSONModel
@property (nonatomic,strong) NSString<Optional>    *unitName;
@property (nonatomic,strong) NSNumber<Optional>    *grantCount;
@property (nonatomic,strong) NSString<Optional>    *name;
@property (nonatomic,strong) NSNumber<Optional>    *grantType;
@property (nonatomic,strong) NSNumber<Optional>    *grantId;
@end

//立即领取model
@protocol ActivityReceviceModel;
@protocol GrantListModel;
@interface ReceiveActivityModel : JSONModel
@property (nonatomic,strong) ActivityReceviceModel<Optional>     *activity;
@property (nonatomic,strong) NSArray<GrantListModel,Optional>    *grantList;
@end





