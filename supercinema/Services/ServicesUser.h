//
//  ServiceUser.h
//  movikr
//
//  Created by Mapollo27 on 15/8/31.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "UserUnReadDataModel.h"
#import "UserDynamicModel.h"

@interface ServicesUser : NSObject

//保持登陆
+ (void)keepLogin:(NSString *)_longitude latitude:(NSString *)_latitude lastVisitCinemaId:(NSString *)lastVisitCinemaId
            model:(void (^)(RequestResult *headModel))success failure:(void (^)(NSError *error))failure;
//请求登陆
+ (void)requestLogin:(NSString *)mobile
                code:(void (^)( NSString *nonce ))success failure:(void (^)(NSError *error))failure;

//登录
+ (void)login:(NSString*)_mobile pwd:(NSString *)_pwd longitude:(NSString *)_longitude latitude:(NSString *)_latitude
         code:(void (^)( RequestResult *model ))success failure:(void (^)(NSError *error))failure;

//登陆退出
+ (void)loginLogout:(NSString* )deviceToken clientId:(NSString *)getuiClientId
              model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;

//获取个人信息
+ (void)getMyInfo:(NSString *)userId
            model:(void (^)( UserModel *userModel ))success failure:(void (^)(NSError *error))failure;

//上传头像
+(void)upLoadUserHeadImage:(NSString *)url
                     model:(void (^)(RequestResult *model ))model failure:(void (^)(NSError *error))failure;

//检查第三方登录
+ (void)checkThirdLoginData:(NSString*)accessToken unionId:(NSString*)unionId loginType:(NSInteger)loginType authorizeStatus:(NSInteger)authorizeStatus
                  longitude:(NSString *)_longitude latitude:(NSString *)_latitude
                      model:(void (^)(RequestResult *headModel))success failure:(void (^)(NSError *error))failure;

//短信验证
+ (void)sendSms:(NSString *)mobile reason:(NSString *)reason longitude:(NSString *)_longitude latitude:(NSString *)_latitude smsType:(NSNumber*)_smsType
          model:(void (^)( SendSmsModel *sendSmsModel))success failure:(void (^)(NSError *error))failure;

//注册
+ (void)userRegister:(NSString *)mobileno smsCode:(NSString *)smsCode passwd:(NSString *)passwd longitude:(NSString *)_longitude latitude:(NSString *)_latitude
               model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;

//获取默认头像列表
//+(void)getDefaultHeadImgList:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

//更新用户信息
+(void)updateUserInfo:(NSString *)_nickName gender:(NSNumber *)_gender birthday:(NSString *)_birthday signature:(NSString *)_signature headUrl:(NSString*)headUrl
                model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;

//修改密码（先请求验证码）
+(void)updatePwdRequire:(void (^)(NSDictionary *model))success failure:(void (^)(NSError *error))failure;
+(void)updatePwd:(NSString *)nonce oldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd
           model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;

//修改手机号（先请求验证码）
+(void)updatePhoneNoRequire:(void (^)(PwdRequireModel *head))success failure:(void (^)(NSError *error))failure;
+(void)updatePhoneNo:(NSString *)_nonce newPhoneNo:(NSString *)_newPhoneNo pwd:(NSString *)pwd sms:(NSString *)_sms
               model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;

//重置密码
+(void)reSetPwd:(NSString *)_mobile newPwd:(NSString *)_newPwd smsCode:(NSString *)_smsCode 
          model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;

//绑定手机号
+(void)bindPhoneNo:(NSString *)mobileNumber pasword:(NSString *)_pasword smsCode:(NSString *)_smsCode
          latitude:(NSString *)_latitude longitude:(NSString *)_longitude lastVisitCinemaId:(NSString *)_lastVisitCinemaId
             model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;

//获取个人中心未读数据
+(void)getUserCenterUnReadDataCount:(NSNumber*)homeUserId
                              model:(void (^)(UserUnReadDataModel *model))success failure:(void (^)(NSError *error))failure;

//关注用户
+ (void)attentionUser:(NSString *)followUserId
                model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure;

//取消关注用户
+ (void)cancelAttentionUser:(NSString *)followUserId
                model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure;

//获取用户的关注列表
+ (void)getAttentionUserList:(NSString *)homeUserId pageIndex:(int)pageIndex
                      model:(void (^)(AttentionUserModel *userList))success failure:(void (^)(NSError *error))failure;

//获取粉丝列表
+ (void)getFansUserList:(NSString *)homeUserId pageIndex:(int)pageIndex
                  model:(void (^)(MyFansModel *fansModel))success failure:(void (^)(NSError *error))failure;
//获取个人动态列表
+ (void)getUserDynamicList:(NSString *)_userId pageIndex:(NSString *)_pageIndex
                     model:(void (^)(UserDynamicModel *userList))success failure:(void (^)(NSError *error))failure;

//获取个人动态详情
+ (void)getUserDynamicDetail:(NSNumber *)_feedId
                       model:(void (^)(FeedListModel *feedModel))success failure:(void (^)(NSError *error))failure;

//删除个人动态
+ (void)deleteUserDynamic:(NSNumber *)_feedId
                       model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure;

//赞个人动态
+ (void)praiseUserDynamic:(NSNumber *)_feedId
                    model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure;

//取消赞个人动态
+ (void)cancelPraiseUserDynamic:(NSNumber *)_feedId
                          model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure;

//检查个人动态能否跳转
+ (void)checkFeedCanJump:(NSNumber *)_objectType objectId:(NSNumber*)_objectId dataType:(NSNumber*)_dataType
                          model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure;

//添加评论
+ (void)addUserComment:(NSNumber *)_feedId commentContent:(NSString *)_commentContent commentId:(NSNumber *)_commentId
                          model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure;

//删除评论
+ (void)deleteUserComment:(NSNumber *)_commentId
                    model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure;

//获取个人动态的评论列表
+ (void)getUserCommentList:(NSNumber *)_feedId pageIndex:(NSNumber *)_pageIndex
                    arr:(void (^)(UserDynamicDetailModel *model))success failure:(void (^)(NSError *error))failure;
//获取默认头像
+(void)getDefaultHeadImgList:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;











@end
