//
//  ServicesShowTime.h
//  movikr
//
//  Created by Mapollo27 on 15/9/15.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShowTimeModel.h"
#import "ShowTimeDetailModel.h"

@interface ServicesShowTime : NSObject

//获取指定影院的电影排期
+ (void)getCinemaMovieShowTime:(NSNumber *)movieId cinemaId:(NSString *)cinemaId
                model:(void (^)(ShowTimeModel *model))success failure:(void (^)(NSError *error))failure;

//电影排期详情
+ (void)getMovieShowTimeDetail:(NSInteger )showTimeId
                         model:(void (^)(ShowTimeDetailModel *model))success failure:(void (^)(NSError *error))failure;

@end
