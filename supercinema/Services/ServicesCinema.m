//
//  ServicesCinema.m
//  movikr
//
//  Created by Mapollo27 on 15/9/1.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "ServicesCinema.h"

@protocol NSDictionary;
@implementation ServicesCinema


+ (void)getCinemaListForId:(NSDictionary*)body
                     array:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETCINEMALIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             //         NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 NSMutableArray *cinemaArray= [[NSMutableArray alloc] init];
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSArray<NSDictionary> *arrDic = [responseObject objectForKey:@"cinemas"];
                     if(arrDic!=nil && [arrDic count]>0)
                     {
                         for (NSDictionary *dic in arrDic)
                         {
                             NSError* err = nil;
                             CinemaModel *cinemaModel = [[CinemaModel alloc] initWithString:[dic JSONString] error:&err];
                             if(err!=nil)
                             {
                                 NSLog(@"%@",err );
                             }
                             [cinemaArray addObject:cinemaModel];
                         }
                     }
                 }
                 if(success)
                     success(cinemaArray);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue]  userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}


//+ (void) setDefaultCinema:(NSString*)cinemaId
//                    model:(void(^)( RequestResult*model ) )success  failure:(void (^)(NSError *error))failure
//{
//    NSDictionary* body = @{@"cinemaId":[Tool urlIsNull:cinemaId]};
//    
//    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
//    {
//        if(failure)
//           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
//    }
//    else
//    {
//        [MKNetWorkRequest POST:URL_SETDEFAULTCINEMA parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
//         {
//             NSLog(@"%@",[responseObject JSONString]);
//             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
//             if ([result.respStatus intValue] == 1)
//             {
//                 if(success)
//                     success(result);
//             }
//             else
//             {
//                 if(failure)
//                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue]  userInfo:nil]);
//             }
//         } failure:^(NSURLSessionDataTask *task, NSError *error) {
//             if(failure)
//                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
//         }];
//    }
//}


//+ (void)synchroCinemaData:(NSDictionary*)body
//                    model:(void(^)( RequestResult*model ) )success  failure:(void (^)(NSError *error))failure
//{
//    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
//    {
//        if(failure)
//           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
//    }
//    else
//    {
//        [MKNetWorkRequest POST:URL_SYNHRONIZECINEMADATA parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
//         {
//             NSLog(@"%@",[responseObject JSONString]);
//             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
//             if ([result.respStatus intValue] == 1)
//             {
//                 if(success)
//                     success(result);
//             }
//             else
//             {
//                 if(failure)
//                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue]  userInfo:nil]);
//             }
//         } failure:^(NSURLSessionDataTask *task, NSError *error) {
//             if(failure)
//                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
//         }];
//    }
//}

+ (void)getOftenRecommendCinema:(NSString *)cityid latitude:(NSString *)_latitude longitude:(NSString *)_longitude locationCityId:(NSString *)_locationCityId
                          model:(void(^)( OftenRecommendCinemaModel*model ) )success  failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"cityId":[Tool urlIsNull:cityid],
                           @"locationCityId":[Tool urlIsNull:_locationCityId],
                           @"latitude":[Tool urlIsNull:_latitude],
                           @"longitude":[Tool urlIsNull:_longitude]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETOFTENANDRECOMMENDCINEMA parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus integerValue]  == 1)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSError* err = nil;
                     OftenRecommendCinemaModel *cinemaModel = [[OftenRecommendCinemaModel alloc] initWithString:[responseObject JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                     }
                     if(success)
                         success(cinemaModel);
                 }
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus integerValue]  userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}


+ (void)addCinemaBrowseRecord:(NSString *)_latitude longitude:(NSString *)_longitude lastVisitCinemaId:(NSString *)_lastVisitCinemaId
                          model:(void(^)( RequestResult*model ) )success  failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"latitude":[Tool urlIsNull:_latitude],
                           @"longitude":[Tool urlIsNull:_longitude],
                           @"lastVisitCinemaId":[Tool urlIsNull:[NSString stringWithFormat:@"%@",_lastVisitCinemaId]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_ADDBROWSECINEMARECORD parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus integerValue]  == 1)
             {
                     if(success)
                         success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus integerValue]  userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
    
}

+ (void) getCinemaDetail:(NSString *)cinemaId
             cinemaModel:(void(^)( CinemaModel*model ) )success failure:(void (^)(NSError *error))failure
{
    if ([cinemaId length] > 0)
    {
        NSDictionary *body = @{@"cinemaId":[Tool urlIsNull:cinemaId]};
        
        if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
        {
            if(failure)
               failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
        }
        else
        {
            [MKNetWorkRequest POST:URL_GETCINEMADETAIL parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
             {
                 NSLog(@"%@",[responseObject JSONString]);
                 RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
                 if ([result.respStatus intValue]  == 1)
                 {
                     if([responseObject isKindOfClass:[NSDictionary class]])
                     {
                         NSError* err = nil;
                         CinemaModel *cinemaModel = [[CinemaModel alloc] initWithString:[[responseObject objectForKey:@"cinema"] JSONString] error:&err];
                         if(err!=nil)
                         {
                             NSLog(@"%@",err );
                         }
                         if(success)
                             success(cinemaModel);
                     }
                 }
                 else
                 {
                     if(failure)
                         failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue]  userInfo:nil]);
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 if(failure)
                     failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
             }];
        }
    }
}

+ (void) getCinemaShareInfo:(NSString *)cinemaId
             model:(void(^)( CinemaShareInfoModel*model ) )success failure:(void (^)(NSError *error))failure
{
    if ([cinemaId length] > 0)
    {
        NSDictionary *body = @{@"cinemaId":[Tool urlIsNull:cinemaId]};
        
        if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
        {
            if(failure)
                failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
        }
        else
        {
            [MKNetWorkRequest POST:URL_CINEMASHAREINFO parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
            {
                 NSLog(@"%@",[responseObject JSONString]);
                 RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
                 if ([result.respStatus intValue]  == 1)
                 {
                     if([responseObject isKindOfClass:[NSDictionary class]])
                     {
                         NSError* err = nil;
                         CinemaShareInfoModel *cinemaShareModel = [[CinemaShareInfoModel alloc] initWithDictionary:responseObject error:&err];
                         if(err!=nil)
                         {
                             NSLog(@"%@",err );
                         }
                         if(success)
                             success(cinemaShareModel);
                     }
                 }
                 else
                 {
                     if(failure)
                         failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue]  userInfo:nil]);
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 if(failure)
                     failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
             }];
        }
    }
}

+ (void) getCinemaImageList:(NSString *)cinemaId
                      model:(void(^)( CinemaImageListModel*model ) )success failure:(void (^)(NSError *error))failure
{
    if ([cinemaId length] > 0)
    {
        NSDictionary *body = @{@"cinemaId":[Tool urlIsNull:cinemaId]};
        
        if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
        {
            if(failure)
                failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
        }
        else
        {
            [MKNetWorkRequest POST:URL_GETCINEMAIMAGE parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
             {
                 NSLog(@"%@",[responseObject JSONString]);
                 RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
                 if ([result.respStatus intValue]  == 1)
                 {
                     if([responseObject isKindOfClass:[NSDictionary class]])
                     {
                         NSError* err = nil;
                         CinemaImageListModel *model = [[CinemaImageListModel alloc] initWithDictionary:responseObject error:&err];
                         if(err!=nil)
                         {
                             NSLog(@"%@",err );
                         }
                         if(success)
                             success(model);
                     }
                 }
                 else
                 {
                     if(failure)
                         failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue]  userInfo:nil]);
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 if(failure)
                     failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
             }];
        }
    }
}

+ (void) getCinemaMovieList:(NSString *)cinemaId
                      model:(void(^)( CinemaMovieListModel*model ) )success failure:(void (^)(NSError *error))failure
{
    if ([cinemaId length] > 0)
    {
        NSDictionary *body = @{@"cinemaId":[Tool urlIsNull:cinemaId]};
        
        if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
        {
            if(failure)
                failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
        }
        else
        {
            [MKNetWorkRequest POST:URL_GETCINEMAVIDEO parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
             {
                 NSLog(@"%@",[responseObject JSONString]);
                 RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
                 if ([result.respStatus intValue]  == 1)
                 {
                     if([responseObject isKindOfClass:[NSDictionary class]])
                     {
                         NSError* err = nil;
                         CinemaMovieListModel *model = [[CinemaMovieListModel alloc] initWithDictionary:responseObject error:&err];
                         if(err!=nil)
                         {
                             NSLog(@"%@",err );
                         }
                         if(success)
                             success(model);
                     }
                 }
                 else
                 {
                     if(failure)
                         failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue]  userInfo:nil]);
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 if(failure)
                     failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
             }];
        }
    }
}

@end


