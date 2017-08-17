//
//  ActivityAwardModel.h
//  movikr
//
//  Created by Mapollo27 on 16/4/12.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface activityModel : JSONModel
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

@interface grantListModel : JSONModel
@property (nonatomic,strong) NSString<Optional>    *unitName;
@property (nonatomic,strong) NSNumber<Optional>    *grantCount;
@property (nonatomic,strong) NSString<Optional>    *name;
@property (nonatomic,strong) NSNumber<Optional>    *grantType;
@property (nonatomic,strong) NSNumber<Optional>    *grantId;
@end

@protocol grantListModel;
@interface activityGrantListModel : JSONModel
@property (nonatomic,strong) activityModel<Optional>                *activity;
@property (nonatomic,strong) NSArray<Optional,grantListModel>       *grantList;
@end

@protocol activityGrantListModel;
@interface ActivityAwardModel : JSONModel
@property (nonatomic,strong) NSArray<Optional,activityGrantListModel>       *activityGrantList;
@property (nonatomic,strong) NSNumber<Optional>    *grantSuccess;       //如果为true则停止轮询此接口
@property (nonatomic,strong) NSNumber<Optional>    *hasActivityGrant;   //如果为true，并且接口没有数据则轮询此接口
@property (nonatomic,strong) NSNumber<Optional>    *shareRedpackFee;    //大于0，则说明有红包可以分享
@end

@interface ActivityRootModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* currentTime;
@property(nonatomic,strong) NSNumber<Optional>* joinStatus;
@property(nonatomic,strong) NSNumber<Optional>* validUseCount;
@property(nonatomic,strong) NSArray<Optional,activityGrantListModel>* activityGrantList;
@end
