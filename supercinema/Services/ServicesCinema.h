//
//  ServicesCinema.h
//  movikr
//
//  Created by Mapollo27 on 15/9/1.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "HotMovieListModel.h"
#import "CinemaModel.h"

@interface ServicesCinema : NSObject

//获取电影院详情
+ (void) getCinemaDetail:(NSString *)cinemaId
             cinemaModel:(void(^)( CinemaModel *model) )success failure:(void (^)(NSError *error))failure;

//获取常去+推荐影院
+ (void)getOftenRecommendCinema:(NSString *)cityid latitude:(NSString *)_latitude longitude:(NSString *)_longitude locationCityId:(NSString *)_locationCityId
                          model:(void(^)( OftenRecommendCinemaModel*model ) )success  failure:(void (^)(NSError *error))failure;

//添加影院访问记录
+ (void)addCinemaBrowseRecord:(NSString *)_latitude longitude:(NSString *)_longitude lastVisitCinemaId:(NSString *)_lastVisitCinemaId
                        model:(void(^)( RequestResult*model ) )success  failure:(void (^)(NSError *error))failure;

//获取影院分享数据
+ (void) getCinemaShareInfo:(NSString *)cinemaId
                      model:(void(^)( CinemaShareInfoModel*model ) )success failure:(void (^)(NSError *error))failure;

//获取影院图片数据
+ (void) getCinemaImageList:(NSString *)cinemaId
                      model:(void(^)( CinemaImageListModel*model ) )success failure:(void (^)(NSError *error))failure;

//获取影院视频数据
+ (void) getCinemaMovieList:(NSString *)cinemaId
                      model:(void(^)( CinemaMovieListModel*model ) )success failure:(void (^)(NSError *error))failure;

@end
