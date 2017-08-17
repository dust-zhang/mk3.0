//
//  MovieReviewModel
//  supercinema
//
//  Created by dust on 16/12/8.
//
//

#import <JSONModel/JSONModel.h>

@protocol MovieReviewListModel;
@interface MovieReviewModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* pageIndex;
@property(nonatomic,strong) NSNumber<Optional>* pageTotal;
@property(nonatomic,strong) NSNumber<Optional>* totalCount;
@property(nonatomic,strong) NSNumber<Optional>* currentTime;
@property(nonatomic,strong) NSArray<Optional,MovieReviewListModel>* reviewList;
@end

@interface MovieReviewUserModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* id;
@property(nonatomic,strong) NSString<Optional>* nickname;   //昵称
@property(nonatomic,strong) NSString<Optional>* portraitUrl;
@end


@protocol MovieReviewCommentListModel;
@interface MovieReviewListModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* id;     //短评ID
@property(nonatomic,strong) NSNumber<Optional>* score;  //评分
@property(nonatomic,strong) NSString<Optional>* content;    //内容
@property(nonatomic,strong) NSNumber<Optional>* publishTime;    //发布时间
@property(nonatomic,strong) NSNumber<Optional>* laudCount;  //点赞数
@property(nonatomic,strong) NSNumber<Optional>* commentCount;   //评论数
@property(nonatomic,strong) NSNumber<Optional>* laudStatus; //当前用户点赞状态 1:赞 0:没有赞
@property(nonatomic,strong) NSNumber<Optional>* userDeleteStatus;   //用户可以删除的状态  1:可以删除 0:不可以删除
@property(nonatomic,strong) MovieReviewUserModel<Optional>* publishUser;    //发布者信息
@property(nonatomic,strong) MovieReviewUserModel<Optional>* replyUser;    //发布者信息
@property(nonatomic,strong) NSArray<Optional,MovieReviewCommentListModel>* commentList; //评论列表
@end

@protocol MovieReviewCommentListModel;
@interface MovieReviewModel1 : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* pageIndex;
@property(nonatomic,strong) NSNumber<Optional>* pageTotal;
@property(nonatomic,strong) NSNumber<Optional>* totalCount;
@property(nonatomic,strong) NSNumber<Optional>* currentTime;
@property(nonatomic,strong) MovieReviewListModel<Optional>* review;
@property(nonatomic,strong) NSArray<Optional,MovieReviewCommentListModel>* commentList;
@end


@interface MovieReviewCommentListModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* id;         //评论ID
@property(nonatomic,strong) MovieReviewUserModel<Optional>* publishUser;    //发布者
@property(nonatomic,strong) MovieReviewUserModel<Optional>* replyUser;  //回复的用户
@property(nonatomic,strong) NSString<Optional>* content;    //短评的内容
@property(nonatomic,strong) NSNumber<Optional>* publishTime;    //发布时间
@property(nonatomic,strong) NSNumber<Optional>* laudCount;      //点赞数
@property(nonatomic,strong) NSNumber<Optional>* commentCount;   //评论数
@property(nonatomic,strong) NSNumber<Optional>* laudStatus;     //当前用户点赞状态 1:赞 0:没有赞
@property(nonatomic,strong) NSNumber<Optional>* userDeleteStatus;   //用户可以删除的状态  1:可以删除 0:不可以删除
@end



//影片评论摘要
@interface MovieReview1Model : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* id;     //短评ID
@property(nonatomic,strong) NSNumber<Optional>* score;
@property(nonatomic,strong) NSString<Optional>* content;    //短评内容
@property(nonatomic,strong) NSNumber<Optional>* publishTime;
@end

@protocol FollowUserListModel;
@interface MovieReviewSummaryModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* followCount; //想看人数
@property(nonatomic,strong) NSNumber<Optional>* commentCount;   //短评数目
@property(nonatomic,strong) NSString<Optional>* rating;     //评分
@property(nonatomic,strong) NSNumber<Optional>* followMovieStatus;  //当前用户的想看状态 1:想看 0:不想看
@property(nonatomic,strong) MovieReview1Model<Optional>* movieReview;
@property(nonatomic,strong) NSNumber<Optional>* movieIsRelease;     //短评是否已经上映
@property(nonatomic,strong) NSArray<Optional,FollowUserListModel>* followUserList;  //参加活动的用户列表
@property(nonatomic,strong) NSNumber<Optional>* currentTime;
@end

//影片评论详情
@interface FollowUserListModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* id;
@property(nonatomic,strong) NSString<Optional>* nickname;
@property(nonatomic,strong) NSString<Optional>* portraitUrl;    //为空则说明头像不存在
@end

//影片评论详情
@interface MovieRDetailModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* movieId;
@property(nonatomic,strong) NSString<Optional>* movieTitle;
@property(nonatomic,strong) NSString<Optional>* rate;
@property(nonatomic,strong) NSArray<Optional>* originCountryList;
@property(nonatomic,strong) NSString<Optional>* releaseDate;
@end

@interface MovieReviewDetailModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) MovieReviewListModel<Optional>* movieReview;
@property(nonatomic,strong) MovieRDetailModel<Optional>* movie;
@property(nonatomic,strong) NSNumber<Optional>* followPersonRelation; //1:已关注,2:未关注，3:相互关注
@property(nonatomic,strong) NSNumber<Optional>* followButtonStatus; //0不能 1能
@end







