//
//  UserDynamicModel.h
//  supercinema
//
//  Created by dust on 16/12/8.
//
//

#import <JSONModel/JSONModel.h>

@protocol FeedListModel;
@interface UserDynamicModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* pageIndex;
@property(nonatomic,strong) NSNumber<Optional>* pageTotal;
@property(nonatomic,strong) NSNumber<Optional>* totalCount;
@property(nonatomic,strong) NSArray<Optional,FeedListModel>* feedList;
@property(nonatomic,strong) NSNumber<Optional>* currentTime;
@end

@interface FeedUserModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* id;
@property(nonatomic,strong) NSString<Optional>* nickname;   //昵称
@property(nonatomic,strong) NSString<Optional>* portraitUrl;
@end


@protocol CommentListModel;
@interface FeedListModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* id;
@property(nonatomic,strong) NSNumber<Optional>* intType;  //动态类型 1:想看电影,2:写了短评,3:更新了签名,4:关注了用户,5:参加了活动,6:领取了活动物品
@property(nonatomic,strong) NSString<Optional>* strType;    //动态类型的描述
@property(nonatomic,strong) NSNumber<Optional>* contentId;
/*根据intType的类型
*关注了 用户 存用户id
* 参加了 活动 存活动id
* 更新了 签名 存用户id
* 想看 电影 存电影id
* 写了 短评 存短评id
 */
@property(nonatomic,strong) NSString<Optional>* targetDesc;
@property(nonatomic,strong) NSString<Optional>* targetTitle;
@property(nonatomic,strong) NSString<Optional>* targetImgUrl;
@property(nonatomic,strong) NSNumber<Optional>* pushishTime;
@property(nonatomic,strong) NSNumber<Optional>* publishUserId;
@property(nonatomic,strong) NSString<Optional>* feedContent;    //内容
@property(nonatomic,strong) NSNumber<Optional>* laudCount;  //点赞数
@property(nonatomic,strong) NSNumber<Optional>* commentCount;   //评论数
@property(nonatomic,strong) NSNumber<Optional>* canDelete;  //是否可以删除 1:可以 0不可以
@property(nonatomic,strong) NSNumber<Optional>* canLaud;    //是否可以点赞(不可以点赞则说明已经赞过了) 1:可以,0:不可以
@property(nonatomic,strong) NSNumber<Optional>* status;     //状态 0:未删除 1:已经删除
@property(nonatomic,strong) FeedUserModel<Optional>* user;  //动态所属的用户信息
@property(nonatomic,strong) NSArray<Optional,CommentListModel>* commentList;     //评论列表
@property(nonatomic,strong) NSNumber<Optional>* cinemaId;
@end


@interface CommentListModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* id; //评论ID
@property(nonatomic,strong) FeedUserModel<Optional>* commentUser;   //发布评论的用户
@property(nonatomic,strong) FeedUserModel<Optional>* replyUser; //被回复的用户，可能为空
@property(nonatomic,strong) NSString<Optional>* content;    //评论内容
@property(nonatomic,strong) NSNumber<Optional>* canDelete;  //当前用户是否可以删除
@property(nonatomic,strong) NSNumber<Optional>* createTime;
@end

@protocol CommentListModel;
@interface UserDynamicDetailModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* pageIndex;
@property(nonatomic,strong) NSNumber<Optional>* pageTotal;
@property(nonatomic,strong) NSNumber<Optional>* totalCount;
@property(nonatomic,strong) NSArray<Optional,CommentListModel>* commentList;
@property(nonatomic,strong) NSNumber<Optional>* currentTime;
@end

