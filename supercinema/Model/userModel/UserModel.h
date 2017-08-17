//
//  UserModel.h
//  movikr
//
//  Created by zeyuan on 15/6/26.
//  Copyright (c) 2015年 movikr. All rights reserved.
//


@protocol SettingListModel;
@interface UserModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>*  id;           
@property(nonatomic,strong) NSString<Optional>*  name;
@property(nonatomic,strong) NSNumber<Optional>*  gender;   //0：不确定，1:男，2女
@property(nonatomic,strong) NSString<Optional>*  nickname;     
@property(nonatomic,strong) NSString<Optional>*  mobileno;
@property(nonatomic,strong) NSString<Optional>*  birthday;     
@property(nonatomic,strong) NSString<Optional>*  signature;
@property(nonatomic,strong) NSString<Optional>*  portrait_url;
@property(nonatomic,strong) NSString<Optional>*  portraitUrlOfBig;
@property(nonatomic,strong) NSArray<Optional,SettingListModel>*  settingList;
@end

@interface SettingListModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>*  id;
@property(nonatomic,strong) NSString<Optional>*  settingValue;
@property(nonatomic,strong) NSString<Optional>*  settingType;
@end

@interface BrowseUserModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *id;
@property (nonatomic,strong) NSString <Optional> *portraitUrl;
@property (nonatomic,strong) NSString <Optional> *nickname;
@property (nonatomic,strong) NSString <Optional> *user_type;
@property (nonatomic,strong) NSString <Optional> *org_desc;
@end

//搜索用户列表
@protocol FollowPersonListModel;
@interface SearchUserListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *seq;
@property (nonatomic,strong) NSNumber <Optional> *pageIndex;
@property (nonatomic,strong) NSNumber <Optional> *pageTotal;
@property (nonatomic,strong) NSNumber <Optional> *pageSize;
@property (nonatomic,strong) NSArray <Optional,FollowPersonListModel> *userList;
@end

@protocol BrowseUserModel;
@protocol UserModel;
@interface UserListModel : JSONModel
@property (nonatomic,strong) NSArray <Optional,BrowseUserModel> *viewer_list;
@property (nonatomic,strong) NSNumber <Optional> *page_no;
@property (nonatomic,strong) NSNumber <Optional> *id;
@property (nonatomic,strong) NSNumber <Optional> *total_count;
@property (nonatomic,strong) NSNumber <Optional> *total_page;
@property (nonatomic,strong) NSArray<Optional,UserModel> *user_list;
@end


@interface SendSmsModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* debugStatus;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSNumber<Optional>* userIsExist;
@end


//我关注的用户
@protocol FollowPersonListModel;
@interface AttentionUserModel : JSONModel
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSNumber<Optional>* pageTotal;
@property(nonatomic,strong) NSNumber<Optional>* pageIndex;
@property(nonatomic,strong) NSArray<Optional,FollowPersonListModel>* followPersonList;
@property(nonatomic,strong) NSNumber<Optional>* totoalCount;
@end

@interface FollowPersonListModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* id;
@property(nonatomic,strong) NSNumber<Optional>* userId;
@property(nonatomic,strong) NSString<Optional>* nickname;
@property(nonatomic,strong) NSString<Optional>* portraitUrl;
@property(nonatomic,strong) NSNumber<Optional>* relationEnum; //1:已关注 2:未关注 3:相互关注 4:不能关注
@property(nonatomic,strong) NSNumber<Optional>* isFollowMe;   //当前查看的人 0:未关注我 1:已关注我

@end

//我的粉丝
@protocol FollowPersonListModel;
@interface MyFansModel : JSONModel
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSNumber<Optional>* pageTotal;
@property(nonatomic,strong) NSNumber<Optional>* pageIndex;
@property(nonatomic,strong) NSArray<Optional,FollowPersonListModel>* fansList;
@property(nonatomic,strong) NSNumber<Optional>* totoalCount;
@end

@interface HeadImgListModel : JSONModel
@property(nonatomic,strong) NSString<Optional>* headImgUrl;
@property(nonatomic,assign) NSInteger gender;
@end
