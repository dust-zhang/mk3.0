//
//  RequestResult
//  movikr
//
//  Created by Mapollo27 on 16/4/7.
//  Copyright © 2016年 movikr. All rights reserved.
//



@interface LoginResultModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* userId;
@property(nonatomic,strong) NSString<Optional>* credential;
@property(nonatomic,strong) NSNumber<Optional>* passportType;   //账户类型 1:静默用户 2:注册用户 3:第三方用户
@property(nonatomic,strong) NSNumber<Optional>* cinemaId;       //最近访问的影院ID，>0才认为有效
@property(nonatomic,strong) NSNumber<Optional>* cinemaCityId;   //影院所属的城市ID，>0才认为有效
@end


@interface RequestResult : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* currentTime;
@property(nonatomic,strong) NSNumber<Optional>* mobileNo;
@property(nonatomic,strong) LoginResultModel<Optional>* loginResult;
@property(nonatomic,strong) NSNumber<Optional>* joinStatus;     //报名参加状态
@property(nonatomic,strong) NSNumber<Optional>* validUseCount;  //有效的使用次数
@end



@interface PwdRequireModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq; //登录缓存安全码
@property(nonatomic,strong) NSString<Optional>* nonce;
@end
