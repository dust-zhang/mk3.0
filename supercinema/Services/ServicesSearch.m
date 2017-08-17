//
//  ServicesSearch.m
//  supercinema
//
//  Created by dust on 16/11/25.
//
//

#import "ServicesSearch.h"

@implementation ServicesSearch

+(void)searchCinema:(NSString *)_searchKey pageIndex:(int )_pageIndex cityId:(NSString *)_cityId latitude:(NSString *)_latitude longitude:(NSString *)_longitude
              model:(void (^)(CinemaListModel *model))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        NSDictionary *b = @{@"searchKey":[Tool urlIsNull:_searchKey],
                            @"pageIndex":[NSNumber numberWithInt:_pageIndex],
                            @"cityId":[Tool urlIsNull:_cityId],
                            @"latitude":[Tool urlIsNull:_latitude],
                            @"longitude":[Tool urlIsNull:_longitude]};
        
        
        [MKNetWorkRequest POST:URL_SEARCHCINEMA parameters:b success:^(NSURLSessionDataTask *task, id responseObject)
         {
             CinemaListModel* model= [[CinemaListModel alloc] initWithDictionary:responseObject error:nil];
             
             if([model.respStatus intValue] == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                    failure([NSError errorWithDomain:model.respMsg code:[model.respStatus intValue ] userInfo:nil]);
             }
             
         }failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
        
    }
}


+(void)searchMovie:(NSString *)_searchKey pageIndex:(int)_pageIndex lastVisitCinemaId:(NSString *)_cinemaId
             model:(void (^)(SearchMovieListModel *model))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        NSDictionary *b = @{@"searchKey":[Tool urlIsNull:_searchKey],
                            @"pageIndex":[Tool urlIsNull:[[NSNumber numberWithInt:_pageIndex] stringValue]],
                            @"lastVisitCinemaId":[Tool urlIsNull:_cinemaId]};
        
        [MKNetWorkRequest POST:URL_SEARCHMOVIES parameters:b success:^(NSURLSessionDataTask *task, id responseObject)
         {
             SearchMovieListModel* model= [[SearchMovieListModel alloc] initWithDictionary:responseObject error:nil];
             
             if([model.respStatus intValue] == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus intValue ] userInfo:nil]);
             }
             
         }failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
        
    }
}



+(void)searchUser:(NSString *)_searchKey pageIndex:(int )_pageIndex
            model:(void (^)(SearchUserListModel *model))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        NSDictionary *b = @{@"searchKey":[Tool urlIsNull:_searchKey],
                            @"pageIndex":[Tool urlIsNull:[[NSNumber numberWithInt:_pageIndex] stringValue]]};
        
        [MKNetWorkRequest POST:URL_SEARCHUSER parameters:b success:^(NSURLSessionDataTask *task, id responseObject)
         {
             SearchUserListModel* model= [[SearchUserListModel alloc] initWithDictionary:responseObject error:nil];
             
             if([model.respStatus intValue] == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus intValue ] userInfo:nil]);
             }
             
         }failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

//查找所有信息
+(void)searchAllInfo:(NSString *)_searchKey cityId:(NSString *)_cityId latitude:(NSString *)_latitude
           longitude:(NSString *)_longitude lastVisitCinemaId:(NSString *)_lastVisitCinemaId
               model:(void (^)(SearchModel *model))success failure:(void (^)(NSError *error))failure
{
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSString *str = _searchKey;
//    NSData *data = [str dataUsingEncoding:enc];
//    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
//    
    NSDictionary *b = @{@"searchKey":[Tool urlIsNull:_searchKey],
                        @"cityId":[Tool urlIsNull:_cityId],
                        @"latitude":[Tool urlIsNull:_latitude],
                        @"longitude":[Tool urlIsNull:_longitude],
                        @"lastVisitCinemaId":[Tool urlIsNull:_lastVisitCinemaId ]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {        
        [MKNetWorkRequest POST:URL_SEARCHALLDATA parameters:b success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSLog(@"%@",[responseObject JSONString]);
            
             SearchModel* model= [[SearchModel alloc] initWithDictionary:responseObject error:nil];
             
             if([model.respStatus intValue] == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus intValue ] userInfo:nil]);
             }
         }failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+(void)readCityList:(void (^)(CityModel *model))success failure:(void (^)(NSError *error))failure
{
    CityModel* model= [[CityModel alloc] initWithDictionary: [Tool dictionaryWithJsonString:[Tool readLocationJsonFile:@"cityjson"] ] error:nil];
    if(success)
        success(model);
}


+(void)getHotCity:(void (^)(HotCityListModel *model))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETHOTCITY parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             HotCityListModel* model= [[HotCityListModel alloc] initWithDictionary:responseObject error:nil];
             
             if([model.respStatus intValue] == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus intValue ] userInfo:nil]);
             }
         }failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}





@end
