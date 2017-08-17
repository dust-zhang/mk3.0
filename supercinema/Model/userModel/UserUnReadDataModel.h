//
//  UserUnReadDataModel.h
//  supercinema
//
//  Created by dust on 16/12/5.
//
//

#import <UIKit/UIKit.h>

@interface UserUnReadDataModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *seq;
@property (nonatomic,strong) NSNumber <Optional> *followUserCount;
@property (nonatomic,strong) NSNumber <Optional> *fansCount;
@property (nonatomic,strong) NSNumber <Optional> *wantSeeMovieCount;
@property (nonatomic,strong) NSNumber <Optional> *reviewCount;          //短评数
@property (nonatomic,strong) NSNumber <Optional> *unpaidOrderCount;
@property (nonatomic,strong) NSNumber <Optional> *unreadNoticeCount;    //未读通知数
//登陆用户和主页用户的关系
@property (nonatomic,strong) NSNumber <Optional> *followPersonRelation; //0:在当前用户自己主页里面,1:已关注,2:未关注，3:相互关注
@property (nonatomic,strong) NSNumber <Optional> *isFollowMe;           //1:已关注 0:未关注


@end
