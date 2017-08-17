//
//  ServicesSearch.h
//  supercinema
//
//  Created by dust on 16/11/25.
//
//

#import <Foundation/Foundation.h>
#import "HotMovieListModel.h"
#import "UserModel.h"
#import "SearchModel.h"

@interface ServicesSearch : NSObject
//搜索影院
+(void)searchCinema:(NSString *)_searchKey pageIndex:(int )_pageIndex cityId:(NSString *)_cityId latitude:(NSString *)_latitude longitude:(NSString *)_longitude
              model:(void (^)(CinemaListModel *model))success failure:(void (^)(NSError *error))failure;

//搜索电影
+(void)searchMovie:(NSString *)_searchKey pageIndex:(int)_pageIndex lastVisitCinemaId:(NSString *)_cinemaId
             model:(void (^)(SearchMovieListModel *model))success failure:(void (^)(NSError *error))failure;

//查找用户
+(void)searchUser:(NSString *)_searchKey pageIndex:(int )_pageIndex
            model:(void (^)(SearchUserListModel *model))success failure:(void (^)(NSError *error))failure;

//查找所有信息
+(void)searchAllInfo:(NSString *)_searchKey cityId:(NSString *)_cityId latitude:(NSString *)_latitude
              longitude:(NSString *)_longitude lastVisitCinemaId:(NSString *)_lastVisitCinemaId
            model:(void (^)(SearchModel *model))success failure:(void (^)(NSError *error))failure;

//读取本地文件里的城市数据
+(void)readCityList:(void (^)(CityModel *model))success failure:(void (^)(NSError *error))failure;

//获取热门城市
+(void)getHotCity:(void (^)(HotCityListModel *model))success failure:(void (^)(NSError *error))failure;

@end
