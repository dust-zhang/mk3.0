//
//  ServicesMovie.h
//  supercinema
//
//  Created by dust on 16/11/25.
//
//

#import <Foundation/Foundation.h>
#import "HotMovieListModel.h"
#import "MovieReviewModel.h"
#import "MyMovieListModel.h"

@interface ServicesMovie : NSObject
//获取影院正在热映电影
+ (void)getHotMoviesByCinemaId :(NSString *)_cinemaId
                          model:(void(^)( MovieListModel*model ) )success failure:(void (^)(NSError *error))failure;

//获取影片详情
+ (void)getMovieDetail :(NSString*)_movieId cinemaId:(NSString*)_cinemaId
                  model:(void (^)(MovieModel *movieDetail))success failure:(void (^)(NSError *error))failure;

//想看影片
+ (void)followMovie:(NSString*)_movieId
                  model:(void (^)(RequestResult *movieDetail))success failure:(void (^)(NSError *error))failure;

//取消想看影片
+ (void)cancelFollowMovie :(NSString*)_movieId
               model:(void (^)(RequestResult *movieDetail))success failure:(void (^)(NSError *error))failure;

//获取想看影片列表
+ (void)getFollowMovieList:(NSString *)_cinemaId homeUserId:(NSString *)_homeUserId pageIndex:(NSNumber *)_pageIndex
                     model:(void (^)(FollowMovieListModel *movieDetail))success failure:(void (^)(NSError *error))failure;

//发表短评、回复短评、回复评论
//parentId: 如果是发表评论，则传短评的ID，如果是回复评论，则传评论ID
//score:    2:烂，4:呃…，6:还行，8:推荐，10:超赞
+ (void)addMovieReview:(NSString *)_movieId content:(NSString *)_content parentId:(NSNumber *)_parentId
                 score:(NSNumber *)_score replyUserId:(NSNumber*)_replyUserId tagIds:(NSArray *)arrTagIds
                 model:(void (^)(RequestResult *movieDetail))success failure:(void (^)(NSError *error))failure;

//短评、评论点赞
+ (void)likeMovieReviewOrComment:(NSString*)_reviewIdOrCommentId
               model:(void (^)(RequestResult *movieDetail))success failure:(void (^)(NSError *error))failure;

//取消短评、评论点赞
+ (void)cancelLikeMovieReviewOrComment:(NSString*)_reviewIdOrCommentId
                                 model:(void (^)(RequestResult *movieDetail))success failure:(void (^)(NSError *error))failure;

//删除短评/评论
+ (void)deleteMovieReviewOrComment:(NSNumber*)_reviewIdOrCommentId
                                 model:(void (^)(RequestResult *movieDetail))success failure:(void (^)(NSError *error))failure;

//获取电影的短评摘要
+ (void)getMovieReviewSummary:(NSString*)_movieId
                        model:(void (^)(MovieReviewSummaryModel *movieDetail))success failure:(void (^)(NSError *error))failure;

//举报短评或者评论
+ (void)reportMovieOrComment:(NSNumber*)_reviewIdOrCommentId reason:(NSString *)_reason
                       model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;

//获取短评列表
+ (void)getMovieReviewList:(NSNumber *)_movieId pageIndex:(NSNumber *)_pageIndex
                     model:(void (^)(MovieReviewModel *movieDetail))success failure:(void (^)(NSError *error))failure;

//获取单个短评的详情
+ (void)getMovieReviewDetail:(NSString*)_movieReviewId
                       model:(void (^)(MovieReviewDetailModel *model))success failure:(void (^)(NSError *error))failure;

//获取我的影片评论列表
+ (void)getMyMovieList:(NSNumber *)_pageIndex homeUserId:(NSString *)_homeUserId lastVisitCinemaId:(NSString *)_lastVisitCinemaId
                 model:(void (^)(MyMovieListModel *model))success failure:(void (^)(NSError *error))failure;

//获取短评的评论列表
+ (void)getMovieCommentList:(NSNumber *)_pageIndex movieReviewId:(NSNumber *)_movieReviewId
                      model:(void (^)(MovieReviewModel1 *model))success failure:(void (^)(NSError *error))failure;
//获取影片标签
+ (void)getMovieTags:(NSNumber *)_movieId
             arrTags:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;
//获取消费提醒
+ (void)getConsumeTips:(NSString *)cinemaId
               arrTips:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;
@end
