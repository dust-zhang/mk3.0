//
//  SystemNoticeModel.h
//  supercinema
//
//  Created by dust on 16/12/6.
//
//

#import <JSONModel/JSONModel.h>

@protocol SysNotifyListModel;
@interface SystemNoticeModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *seq;
@property (nonatomic,strong) NSNumber <Optional> *pageIndex;
@property (nonatomic,strong) NSNumber <Optional> *pageTotal;
@property (nonatomic,strong) NSNumber <Optional> *unReadCount;
@property (nonatomic,strong) NSNumber <Optional> *currentTime;
@property (nonatomic,strong) NSArray <Optional,SysNotifyListModel> *notifyList;
@end


@interface SysNotifyListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *id;
@property (nonatomic,strong) NSString <Optional> *contentId;    //通知相关内容的ID
@property (nonatomic,strong) NSString <Optional> *content;      //内容
@property (nonatomic,strong) NSNumber <Optional> *intType;      //1:回复短评,2:赞短评,3:关注了你,4:回复了你的动态,5:赞了动态
@property (nonatomic,strong) NSString <Optional> *strType;      //type的字符描述
@property (nonatomic,strong) NSNumber <Optional> *rpUserId;     //发送通知的用户ID
@property (nonatomic,strong) NSString <Optional> *rpUserNickName;//发送通知的用户昵称
@property (nonatomic,strong) NSString <Optional> *rpUserPortrait;//发送通知的用户头像
@property (nonatomic,strong) NSNumber <Optional> *createTime;
@property (nonatomic,strong) NSNumber <Optional> *status;           //通知状态 0:未读,1:已读,2:删除
@property (nonatomic,strong) NSNumber <Optional> *intTargetType;    //1:想看电影 2:写了短评 3:更新了签名 4:关注了用户 5:参加了活动 6:领取了活动物品   如果返回是0则没有通知相关内容，大于0则有
@property (nonatomic,strong) NSString <Optional> *strTargetType;    //targetType的描述
@property (nonatomic,strong) NSString <Optional> *targetDesc;       //通知相关内容的描述
@property (nonatomic,strong) NSString <Optional> *targetTitle;      //通知相关内容的标题
@property (nonatomic,strong) NSString <Optional> *targetImg;        //通知相关内容的icon
@end

