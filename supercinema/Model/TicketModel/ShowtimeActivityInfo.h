//
//  ShowtimeActivityInfo.h
//  movikr
//
//  Created by Mapollo25 on 15/8/6.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowtimeActivityInfo : NSObject

///活动编号
@property (nonatomic) NSInteger activityId;
///是否喜欢
@property (nonatomic) BOOL currUserIsLike;
///用户头像
@property (nonatomic,copy) NSString *userLogo;
///活动标题
@property (nonatomic,copy) NSString *title;
///活动图片
@property (nonatomic,copy) NSString *activityImgUrl;
///活动描述
@property (nonatomic,copy) NSString *activityDesc;
///喜欢数
@property (nonatomic) NSInteger likeCount;

@end
