//
//  ServicesMovie.m
//  supercinema
//
//  Created by dust on 16/11/25.
//
//

#import "ServicesMovie.h"

@protocol NSDictionary;
@implementation ServicesMovie


+ (void)getHotMoviesByCinemaId :(NSString *)_cinemaId
                          model:(void(^)( MovieListModel*model ) )success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"cinemaId":[Tool urlIsNull:_cinemaId]};
    if([_cinemaId length]> 0)
    {
        if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
        {
            if(failure)
               failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
        }
        else
        {
            [MKNetWorkRequest POST:URL_HOTMOVIES parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
             {
                 NSLog(@"%@",[responseObject JSONString]);
                 RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
                 if ([result.respStatus integerValue]  == 1)
                 {
                     if([responseObject isKindOfClass:[NSDictionary class]])
                     {
                         NSError* err = nil;
                         MovieListModel *movieList = [[MovieListModel alloc] initWithString:[responseObject JSONString] error:&err];
                         if(err!=nil)
                         {
                             NSLog(@"%@",err );
                         }
                         if(success)
                             success(movieList);
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
    else
    {
        if(failure)
            failure([NSError errorWithDomain:@"没有影院id" code:-10000 userInfo:nil]);
    }
}


+ (void)getMovieDetail :(NSString*)_movieId cinemaId:(NSString*)_cinemaId
                  model:(void (^)(MovieModel *movieDetail))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"movieId":[Tool urlIsNull:_movieId], @"cinemaId":[Tool urlIsNull:_cinemaId]};
//    NSLog(@"%@",[body JSONString]);
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_MOVIEGET parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSError* err = nil;
                     MovieModel *movieList = [[MovieModel alloc] initWithString:[[responseObject objectForKey:@"movie"] JSONString] error:&err];
                     if(err!=nil)
                     {
                         NSLog(@"%@",err );
                     }
                     if(success)
                         success(movieList);
                 }
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

//想看影片
+ (void)followMovie:(NSString*)_movieId
              model:(void (^)(RequestResult *movieDetail))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"movieId":[Tool urlIsNull:_movieId]};
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_FOLLOWMOVIW parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

//取消想看影片
+ (void)cancelFollowMovie:(NSString*)_movieId
                    model:(void (^)(RequestResult *movieDetail))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"movieId":[Tool urlIsNull:_movieId] };
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_CANCELFOLLOWMOVIW parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}


+ (void)getFollowMovieList:(NSString *)_cinemaId homeUserId:(NSString *)_homeUserId pageIndex:(NSNumber *)_pageIndex
                     model:(void (^)(FollowMovieListModel *movieDetail))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = nil;
    if(_homeUserId == nil)
    {
        body = @{@"cinemaId":[Tool urlIsNull:_cinemaId],
                  @"pageIndex":[Tool urlIsNull:[_pageIndex stringValue]]};

    }
    else
    {
        body = @{@"cinemaId":[Tool urlIsNull:_cinemaId],
                 @"homeUserId":[Tool urlIsNull:_homeUserId],
                 @"pageIndex":[Tool urlIsNull:[_pageIndex stringValue]]};
    }
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETGETFOLLOWMOVIELIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             FollowMovieListModel *model =[[FollowMovieListModel alloc] initWithDictionary:responseObject error:nil];
             if ([model.respStatus intValue] == 1)
             {
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:model.respMsg code:[model.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)addMovieReview:(NSString *)_movieId content:(NSString *)_content parentId:(NSNumber *)_parentId
                 score:(NSNumber *)_score replyUserId:(NSNumber*)_replyUserId tagIds:(NSArray *)arrTagIds
                 model:(void (^)(RequestResult *movieDetail))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body;
    if ([arrTagIds count] > 0 )
    {
        body = @{@"movieId":[Tool urlIsNull:_movieId],
                 @"content":[Tool urlIsNull:_content],
                 @"parentId":[Tool urlIsNull:[_parentId stringValue]],
                 @"score":[Tool urlIsNull:[_score stringValue]],
                 @"replyUserId": [Tool urlIsNull:[_replyUserId stringValue]],
                 @"tagIds":arrTagIds
                 };
    }
    else
    {
        body = @{@"movieId":[Tool urlIsNull:_movieId],
                 @"content":[Tool urlIsNull:_content],
                 @"parentId":[Tool urlIsNull:[_parentId stringValue]],
                 @"score":[Tool urlIsNull:[_score stringValue]],
                 @"replyUserId": [Tool urlIsNull:[_replyUserId stringValue]]
                 };
    }
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:@"哎呀~出错了~" code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_ADDMOVIEREVIEW parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}


+ (void)getMovieReviewList:(NSNumber *)_movieId pageIndex:(NSNumber *)_pageIndex
                     model:(void (^)(MovieReviewModel *movieDetail))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"movieId":[Tool urlIsNull:[_movieId stringValue]],
                           @"pageIndex":[Tool urlIsNull:[_pageIndex stringValue]]};
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETMOVIEREVIEWLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             MovieReviewModel *result =[[MovieReviewModel alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)likeMovieReviewOrComment:(NSString*)_reviewIdOrCommentId
                           model:(void (^)(RequestResult *movieDetail))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"reviewIdOrCommentId":[Tool urlIsNull:_reviewIdOrCommentId] };
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_LIKEMOVIECOMMENT parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}
+ (void)cancelLikeMovieReviewOrComment:(NSString*)_reviewIdOrCommentId
                                 model:(void (^)(RequestResult *movieDetail))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"reviewIdOrCommentId":[Tool urlIsNull:_reviewIdOrCommentId] };
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_UNLIKEMOVIECOMMENT parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)deleteMovieReviewOrComment:(NSNumber*)_reviewIdOrCommentId
                             model:(void (^)(RequestResult *movieDetail))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"reviewIdOrCommentId":[Tool urlIsNull:[_reviewIdOrCommentId stringValue]] };
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_DELMOIVECOMMENT parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}


+ (void)getMovieReviewSummary:(NSString*)_movieId
                        model:(void (^)(MovieReviewSummaryModel *movieDetail))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"movieId":[Tool urlIsNull:_movieId] };
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETMOVIEREVIEWSUMMARY parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             MovieReviewSummaryModel *result =[[MovieReviewSummaryModel alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)reportMovieOrComment:(NSNumber*)_reviewIdOrCommentId reason:(NSString *)_reason
                        model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"reviewIdOrCommentId":[Tool urlIsNull:[_reviewIdOrCommentId stringValue]],
                           @"reason":[Tool urlIsNull:_reason] };
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_REPORTMOVIEORCOMMENT parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)getMovieReviewDetail:(NSString*)_movieReviewId
                       model:(void (^)(MovieReviewDetailModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"movieReviewId":[Tool urlIsNull:_movieReviewId ]};
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETMOVIEREVIEWDETAIL parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             MovieReviewDetailModel *result =[[MovieReviewDetailModel alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)getMyMovieList:(NSNumber *)_pageIndex homeUserId:(NSString *)_homeUserId lastVisitCinemaId:(NSString *)_lastVisitCinemaId
                       model:(void (^)(MyMovieListModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"pageIndex":[Tool urlIsNull:[_pageIndex stringValue]],
                           @"homeUserId":[Tool urlIsNull:_homeUserId],
                           @"lastVisitCinemaId":[Tool urlIsNull:_lastVisitCinemaId]
                           };
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETUSERMOVIEREVIEWLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             MyMovieListModel *result =[[MyMovieListModel alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)getMovieCommentList:(NSNumber *)_pageIndex movieReviewId:(NSNumber *)_movieReviewId
                 model:(void (^)(MovieReviewModel1 *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"pageIndex":[Tool urlIsNull:[_pageIndex stringValue]],
                           @"movieReviewId":[Tool urlIsNull:[_movieReviewId stringValue]]};
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETMOVIECOMMENTLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             MovieReviewModel1 *result =[[MovieReviewModel1 alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)getMovieTags:(NSNumber *)_movieId
                      arrTags:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"movieId":[Tool urlIsNull:[_movieId stringValue]] };
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETMOVIETAGS parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 NSMutableArray *tagArray= [[NSMutableArray alloc] init];
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSArray<NSDictionary> *arrDic = [responseObject objectForKey:@"tagList"];
                     if(arrDic!=nil && [arrDic count]>0)
                     {
                         for (NSDictionary *dic in arrDic)
                         {
                             NSError* err = nil;
                             TagModel *tagModel = [[TagModel alloc] initWithString:[dic JSONString] error:&err];
                             if(err!=nil)
                             {
                                 NSLog(@"%@",err );
                             }
                             [tagArray addObject:tagModel];
                         }
                     }
                 }
                 if(success)
                     success(tagArray);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)getConsumeTips:(NSString *)cinemaId
             arrTips:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"cinemaId":[Tool urlIsNull:cinemaId] };
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETCONSUMETIPS parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 0)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSArray<NSDictionary> *arrDic = [responseObject objectForKey:@"tips"];
                     if(success)
                         success(arrDic);
                 }
                 
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}


@end
