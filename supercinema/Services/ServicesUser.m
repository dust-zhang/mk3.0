//
//  ServiceUser.m
//  movikr
//
//  Created by Mapollo27 on 15/8/31.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "ServicesUser.h"
#import "UserModel.h"

@implementation ServicesUser
@protocol NSDictionary;

+ (void)keepLogin:(NSString *)_longitude latitude:(NSString *)_latitude lastVisitCinemaId:(NSString *)_lastVisitCinemaId
            model:(void (^)(RequestResult *headModel))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"longitude":[Tool urlIsNull:_longitude],
                          @"latitude":[Tool urlIsNull:_latitude],
                          @"lastVisitCinemaId":[Tool urlIsNull:_lastVisitCinemaId]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_ACCOUNTKEEPALIVE parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSLog(@"%@",[responseObject JSONString]);
            RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
            {
                NSError* err = nil;
                if(err!=nil)
                {
                    NSLog(@"%@",err );
                }
                if(success)
                    success(result);
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

+ (void)requestLogin:(NSString *)mobile
                code:(void (^)( NSString *nonce ))success failure:(void (^)(NSError *error))failure
{
    ///传入的参数
    NSDictionary *body = @{@"mobileno":[Tool urlIsNull:mobile]};
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_REQUESTLOGIN parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSLog(@"%@",[responseObject JSONString]);
            RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
            {
                if(success)
                    success( [responseObject objectForKey:@"nonce"] );
            }
            else
            {
                if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failure)
                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
        }];
    }
}

+ (void)login:(NSString*)_mobile pwd:(NSString *)_pwd longitude:(NSString *)_longitude latitude:(NSString *)_latitude
                code:(void (^)( RequestResult *model ))success failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *loginBody = @{@"mobileno":[Tool urlIsNull:_mobile],
                                @"passwd":[Tool urlIsNull:_pwd],
                                @"deviceToken":[Tool urlIsNull:[Config getDeviceToken]],
                                @"getuiClientId":[Tool urlIsNull:[Config getGeTuiId]],
                                @"latitude":[Tool urlIsNull:_latitude],
                                @"longitude":[Tool urlIsNull:_longitude],
                                @"lastVisitCinemaId":[Tool urlIsNull:[NSString stringWithFormat:@"%@",[Config getCinemaId]] ]
                                };
   
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_LOGIN parameters:loginBody success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult  *result= [[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if(success)
                     success( result );
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue] userInfo:nil]);
             }
    
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }

}
+ (void)getMyInfo:(NSString *)userId
            model:(void (^)( UserModel *userModel ))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"userId":[Tool urlIsNull:userId]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        if( [Config getLoginState] )
        {
            [MKNetWorkRequest POST:URL_GETUSERINFO parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
             {
                 NSLog(@"%@",[responseObject JSONString]);
                 
                 RequestResult* result = [[RequestResult alloc] initWithDictionary:responseObject error:nil];
                 if ([result.respStatus intValue] == 1)
                 {
                     UserModel* userModel = [[UserModel alloc] initWithDictionary:responseObject error:nil];
                     if(success)
                         success(userModel);
                 }
                 else
                 {
                     if(failure)
                         failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue ] userInfo:nil]);
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 if(failure)
                     failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
             }];
        }
    }
}

//上传头像
+(void)upLoadUserHeadImage:(NSString *)url
                     model:(void (^)(RequestResult *model ))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *b = @{@"portraitUrl":[Tool urlIsNull:url] };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_UPDATEUSERHEAD parameters:b success:^(NSURLSessionDataTask *task, id responseObject)
        {
            RequestResult* result = [[RequestResult alloc] initWithDictionary:responseObject error:nil];
            if ([result.respStatus intValue] == 1)
            {
                if(success)
                    success(result);
            }
            else
            {
                if(failure)
                    failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue ] userInfo:nil]);
            }
            
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}
+ (void)checkThirdLoginData:(NSString*)accessToken unionId:(NSString*)unionId loginType:(NSInteger)loginType authorizeStatus:(NSInteger)authorizeStatus
                  longitude:(NSString *)_longitude latitude:(NSString *)_latitude
                      model:(void (^)(RequestResult *headModel))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body= @{@"loginType":[NSNumber numberWithInteger:loginType],
                          @"authorizeStatus":[NSNumber numberWithInteger:authorizeStatus],
                          @"accessToken":[Tool urlIsNull:accessToken],
                          @"unionId":[Tool urlIsNull:unionId],
                          @"latitude":[Tool urlIsNull:_latitude],
                          @"longitude":[Tool urlIsNull:_longitude],
                          @"lastVisitCinemaId":[Tool urlIsNull:[NSString stringWithFormat:@"%@",[Config getCinemaId]]]
                                                };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         [MKNetWorkRequest POST:URL_CHECKTHIRDLOGIN parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
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
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue ] userInfo:nil]);
             }
         }  failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

////发送短信的原因（REG:注册，RESETPASSWD:重置密码，CHANGEMOBILENO：修改手机号
+ (void)sendSms:(NSString *)mobile reason:(NSString *)reason longitude:(NSString *)_longitude latitude:(NSString *)_latitude smsType:(NSNumber*)_smsType
          model:(void (^)( SendSmsModel *sendSmsModel))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{
                           @"mobile_no":[Tool urlIsNull:mobile],
                           @"reason":[Tool urlIsNull:reason],
                           @"latitude":[Tool urlIsNull:_latitude],
                           @"longitude":[Tool urlIsNull:_longitude],
                           @"lastVisitCinemaId":[Tool urlIsNull:[NSString stringWithFormat:@"%@",[Config getCinemaId]] ],
                           @"smsType":_smsType
                           };
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         [MKNetWorkRequest POST:URL_ACCOUNTSENDSMS parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 SendSmsModel *result =[[SendSmsModel alloc] initWithDictionary:responseObject error:nil];
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue ] userInfo:nil]);
             }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)userRegister:(NSString *)mobileno smsCode:(NSString *)smsCode passwd:(NSString *)passwd longitude:(NSString *)_longitude latitude:(NSString *)_latitude
               model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    ///传入的参数
    NSDictionary *body = @{
                           @"mobileno":[Tool urlIsNull:mobileno],
                           @"passwd":[Tool xor:passwd key:smsCode],
                           @"smsCode":[Tool urlIsNull:smsCode],
                           @"latitude":[Tool urlIsNull:_latitude],
                           @"longitude":[Tool urlIsNull:_longitude],
                           @"lastVisitCinemaId":[Tool urlIsNull:[NSString stringWithFormat:@"%@",[Config getCinemaId]] ]
                           };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         [MKNetWorkRequest POST:URL_ACCOUNTREGISTER parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue ] userInfo:nil]);
             }
         }failure:^(NSURLSessionDataTask *task, NSError *error){
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

//+(void)getDefaultHeadImgList:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure
//{
//    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
//    {
//        if(failure)
//           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
//    }
//    else
//    {
//        [MKNetWorkRequest POST:URL_GETDEFAULTHEADIMGLIST parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
//        {
////             NSLog(@"%@",[responseObject  JSONString]);
//             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
//             if ([result.respStatus intValue] == 1)
//             {
//                 NSMutableArray *arrayList= [[NSMutableArray alloc] init];
//                 if([responseObject isKindOfClass:[NSDictionary class]])
//                 {
//                     NSArray<NSDictionary> *arrDic = [responseObject objectForKey:@"headImgList"];
//                     if(arrDic!=nil && [arrDic count]>0)
//                     {
//                         for (NSDictionary *dic in arrDic)
//                         {
//                             NSError* err = nil;
//                             HeadImgListModel *imageList = [[HeadImgListModel alloc] initWithString:[dic JSONString] error:&err];
//                             if(err!=nil)
//                             {
//                                 NSLog(@"%@",err );
//                             }
//                             [arrayList addObject:imageList];
//                         }
//                     }
//                 }
//                 if(success)
//                     success(arrayList);
//             }
//             else
//             {
//                 if(failure)
//                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue]  userInfo:nil]);
//             }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            if(failure)
//                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
//        }];
//    }
//}

+ (void)loginLogout:(NSString* )deviceToken clientId:(NSString *)getuiClientId
              model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"deviceToken":[Tool urlIsNull:deviceToken],
                           @"getuiClientId":[Tool urlIsNull:getuiClientId]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         [MKNetWorkRequest POST:URL_LOGINLOGOUT parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue]  == 1)
             {
                 if(success)
                     success(result);
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

+(void)updateUserInfo:(NSString *)_nickName gender:(NSNumber *)_gender birthday:(NSString *)_birthday signature:(NSString *)_signature headUrl:(NSString*)headUrl
                model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary   *body;
    if ([_gender intValue] == 0 )
    {
        body = @{@"name":@"",
                 @"nickName":[Tool urlIsNull:_nickName],
                 @"birthday":[Tool urlIsNull:_birthday],
                 @"signature":[Tool urlIsNull:_signature],
                 @"userHomeHeadImageUrl":[Tool urlIsNull:headUrl]};
    }
    body = @{@"name":@"",
            @"nickName":[Tool urlIsNull:_nickName],
            @"gender":[Tool urlIsNull:[_gender stringValue]],
            @"birthday":[Tool urlIsNull:_birthday],
            @"signature":[Tool urlIsNull:_signature],
            @"userHomeHeadImageUrl":[Tool urlIsNull:headUrl]};

    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_USERINFOSET parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
            RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
            if ([result.respStatus intValue]  == 1)
            {
                 if(success)
                     success(result);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue]  userInfo:nil]);
             }
             
        }failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failure)
                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
        }];
    }

}

+(void)updatePwdRequire:(void (^)(NSDictionary *dic))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
     else
     {
         [MKNetWorkRequest POST:URL_REQUIREPWD parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
          {
              RequestResult* head= [[RequestResult alloc] initWithDictionary:responseObject error:nil];
              if ([head.respStatus intValue] == 1)
              {
                  if(success)
                      success(responseObject);
              }
              else
              {
                  if(failure)
                      failure([NSError errorWithDomain:head.respMsg code:[head.respStatus integerValue]  userInfo:nil]);
              }
              
              
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              if(failure)
                  failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
          }];
     }
}

+(void)updatePwd:(NSString *)nonce oldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd
                model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
     NSDictionary *b = @{@"oldPassword":[Tool xor:oldPwd key:nonce],@"newPassword":[Tool xor:newPwd key:nonce]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_USERCHANGEPWD parameters:b success:^(NSURLSessionDataTask *task, id responseObject)
        {
            RequestResult* head= [[RequestResult alloc] initWithDictionary:responseObject error:nil];
            if ([head.respStatus intValue] == 1)
            {
                if(success)
                    success(head);
            }
            else
            {
                if(failure)
                    failure([NSError errorWithDomain:head.respMsg code:[head.respStatus integerValue]  userInfo:nil]);
            }
        }failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failure)
                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
        }];
    }
    
}

+(void)updatePhoneNoRequire:(void (^)(PwdRequireModel *head))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_PWDREQUIREDCODE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             PwdRequireModel* head= [[PwdRequireModel alloc] initWithDictionary:responseObject error:nil];
             if([head.respStatus intValue] == 1)
             {
                 if(success)
                     success(head);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus integerValue]  userInfo:nil]);
             }
             
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+(void)updatePhoneNo:(NSString *)_nonce newPhoneNo:(NSString *)_newPhoneNo pwd:(NSString *)pwd sms:(NSString *)_sms
           model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
   NSDictionary *b = @{@"newMobileNumber":[Tool urlIsNull:_newPhoneNo],
                       @"password":[Tool xor:pwd key:_nonce],
                       @"smsCode":[Tool urlIsNull:_sms]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_CHANGEMOBILENUMBER parameters:b success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSLog(@"%@",[responseObject JSONString]);
            
            RequestResult * head = [[RequestResult alloc] initWithDictionary:responseObject error:nil];
            if( [head.respStatus intValue] == 1)
            {
                if(success)
                    success(head);
            }
            else
            {
                if(failure)
                    failure([NSError errorWithDomain:head.respMsg code:[head.respStatus integerValue]  userInfo:nil]);
            }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+(void)reSetPwd:(NSString *)_mobile newPwd:(NSString *)_newPwd smsCode:(NSString *)_smsCode 
               model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         NSDictionary *b = @{@"mobileno":[Tool urlIsNull:_mobile],
                             @"password":[Tool xor:_newPwd key:_smsCode],
                             @"smsCode":[Tool urlIsNull:_smsCode]};
        
         [MKNetWorkRequest POST:URL_RESETPASSWORD parameters:b success:^(NSURLSessionDataTask *task, id responseObject)
         {
            RequestResult * head = [[RequestResult alloc] initWithDictionary:responseObject error:nil];
            if([head.respStatus intValue] == 1)
            {
                if(success)
                    success(head);
            }
            else
            {
                if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus integerValue]  userInfo:nil]);
            }
             
        }failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failure)
                failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
        }];

     }
}

+(void)bindPhoneNo:(NSString *)mobileNumber pasword:(NSString *)_pasword smsCode:(NSString *)_smsCode
           latitude:(NSString *)_latitude longitude:(NSString *)_longitude lastVisitCinemaId:(NSString *)_lastVisitCinemaId
               model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *b = @{@"mobileNumber":[Tool urlIsNull:mobileNumber],
                        @"pasword":[Tool xor:_pasword key:_smsCode],
                        @"smsCode":[Tool urlIsNull:_smsCode],
                        @"latitude":[Tool urlIsNull:_latitude],
                        @"longitude":[Tool urlIsNull:_longitude],
                        @"lastVisitCinemaId":[Tool urlIsNull:_lastVisitCinemaId]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_THIRDUSERBINGDMOBILE parameters:b success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult * head = [[RequestResult alloc] initWithDictionary:responseObject error:nil];
             
             if( [head.respStatus intValue] == 1)
             {
                 if(success)
                     success(head);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus integerValue]  userInfo:nil]);
             }
             
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+(void)getUserCenterUnReadDataCount:(NSNumber*)homeUserId
                              model:(void (^)(UserUnReadDataModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary * body = @{@"homeUserId":[Tool urlIsNull:[homeUserId stringValue]] };
                             
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETUSERCENTERUNREADCOUNT parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             UserUnReadDataModel * head = [[UserUnReadDataModel alloc] initWithDictionary:responseObject error:nil];
             
             if( [head.respStatus intValue] == 1)
             {
                 if(success)
                     success(head);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus integerValue]  userInfo:nil]);
             }
             
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)attentionUser:(NSString *)followUserId
                  model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"followUserId":[Tool urlIsNull:followUserId] };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_ATTENTIONUSER parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult* head = [[RequestResult alloc] initWithDictionary:responseObject  error:nil];
             if ([head.respStatus intValue] == 1)
             {
                 if(success)
                     success(head);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)cancelAttentionUser:(NSString *)followUserId
                      model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure;
{
    NSDictionary* body = @{@"followUserId":[Tool urlIsNull:followUserId] };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_CANCELATTENTIONUSER parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult* head = [[RequestResult alloc] initWithDictionary:responseObject  error:nil];
             if ([head.respStatus intValue] == 1)
             {
                 if(success)
                     success(head);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }

}


+ (void)getAttentionUserList:(NSString *)homeUserId pageIndex:(int)pageIndex
                       model:(void (^)(AttentionUserModel *userList))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"homeUserId":[Tool urlIsNull:homeUserId ],
                           @"pageIndex": [Tool urlIsNull:[[NSNumber numberWithInt:pageIndex] stringValue]] };
  
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETATTENTONUSERLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult* head = [[RequestResult alloc] initWithDictionary:responseObject  error:nil];
             if ([head.respStatus intValue] == 1)
             {
                 AttentionUserModel *userlistModel = [[AttentionUserModel alloc] initWithDictionary:responseObject error:nil];
                 if(success)
                     success(userlistModel);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)getFansUserList:(NSString *)homeUserId pageIndex:(int)pageIndex
                       model:(void (^)(MyFansModel *fansModel))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"homeUserId":[Tool urlIsNull:homeUserId] ,
                           @"pageIndex": [Tool urlIsNull:[[NSNumber numberWithInt:pageIndex] stringValue] ] };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETFANSLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult* head = [[RequestResult alloc] initWithDictionary:responseObject  error:nil];
             if ([head.respStatus intValue] == 1)
             {
                 NSError* err = nil;
                 MyFansModel *model = [[MyFansModel alloc] initWithDictionary:responseObject error:&err];
                 if(err!=nil)
                 {
                     NSLog(@"%@",err );
                 }
                 if(success)
                     success(model);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)getUserDynamicList:(NSString *)_userId pageIndex:(NSString *)_pageIndex
                     model:(void (^)(UserDynamicModel *userList))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"homeUserId":[Tool urlIsNull:_userId],
                           @"pageIndex":[NSNumber numberWithInteger:[_pageIndex integerValue]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETUSERFEEDLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult* head = [[RequestResult alloc] initWithDictionary:responseObject  error:nil];
             if ([head.respStatus intValue] == 1)
             {
                 NSError* err = nil;
                 UserDynamicModel *dynamicModel = [[UserDynamicModel alloc] initWithDictionary:responseObject error:&err];
                 if(err!=nil)
                 {
                     NSLog(@"%@",err );
                 }
                 if(success)
                     success(dynamicModel);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)getUserDynamicDetail:(NSNumber *)_feedId
                     model:(void (^)(FeedListModel *feedModel))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"feedId":[Tool urlIsNull:[_feedId stringValue]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETFEEDDETAIL parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult* head = [[RequestResult alloc] initWithDictionary:responseObject  error:nil];
             if ([head.respStatus intValue] == 1)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSDictionary* dict = [responseObject objectForKey:@"feed"];
                     if (dict != nil)
                     {
                         NSError* err = nil;
                         FeedListModel* fModel = [[FeedListModel alloc]initWithString:[dict JSONString] error:&err];
                         if(success)
                             success(fModel);
                     }
                     else
                     {
                         if(failure)
                             failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
                     }
                 }
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
             }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)deleteUserDynamic:(NSNumber *)_feedId
                    model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"feedId":[Tool urlIsNull:[_feedId stringValue]] };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_DELETEFEED parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult* head = [[RequestResult alloc] initWithDictionary:responseObject  error:nil];
             if ([head.respStatus intValue] == 1)
             {
                 if(success)
                     success(head);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)praiseUserDynamic:(NSNumber *)_feedId
                    model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"feedId":[Tool urlIsNull:[_feedId stringValue]] };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_LAUNFEED parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult* head = [[RequestResult alloc] initWithDictionary:responseObject  error:nil];
             if ([head.respStatus intValue] == 1)
             {
                 if(success)
                     success(head);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)cancelPraiseUserDynamic:(NSNumber *)_feedId
                    model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"feedId":[Tool urlIsNull:[_feedId stringValue]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_CANCELLAUDFEED parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult* head = [[RequestResult alloc] initWithDictionary:responseObject  error:nil];
             if ([head.respStatus intValue] == 1)
             {
                 if(success)
                     success(head);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)checkFeedCanJump:(NSNumber *)_objectType objectId:(NSNumber*)_objectId dataType:(NSNumber*)_dataType
                   model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"objectType":_objectType,
                           @"objectId":_objectId,
                           @"dataType":_dataType
                           };
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_CHECKFEEDCANJUMP parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult* head = [[RequestResult alloc] initWithDictionary:responseObject  error:nil];
             if ([head.respStatus intValue] == 1)
             {
                 if(success)
                     success(head);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)addUserComment:(NSNumber *)_feedId commentContent:(NSString *)_commentContent commentId:(NSNumber *)_commentId
                 model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body;
    if (_commentId != [NSNumber numberWithInt:0])
    {
        body = @{@"feedId":[Tool urlIsNull:[_feedId stringValue]],
                 @"commentContent":[Tool urlIsNull:_commentContent],
                 @"commentId":[Tool urlIsNull:[_commentId stringValue]]
                };
    }
    else
    {
        body = @{@"feedId":[Tool urlIsNull:[_feedId stringValue]],
                 @"commentContent":[Tool urlIsNull:_commentContent]
                };
    }
    
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_FEEDADDCOMMENT parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult* head = [[RequestResult alloc] initWithDictionary:responseObject  error:nil];
             if ([head.respStatus intValue] == 1)
             {
                 if(success)
                     success(head);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)deleteUserComment:(NSNumber *)_commentId
                 model:(void (^)(RequestResult *userList))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"commentId":[Tool urlIsNull:[_commentId stringValue]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_DELETEFEEDCOMMENT parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             RequestResult* head = [[RequestResult alloc] initWithDictionary:responseObject  error:nil];
             if ([head.respStatus intValue] == 1)
             {
                 if(success)
                     success(head);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)getUserCommentList:(NSNumber *)_feedId pageIndex:(NSNumber *)_pageIndex
                       arr:(void (^)(UserDynamicDetailModel *model))success failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"feedId":[Tool urlIsNull:[_feedId stringValue]],
                           @"pageIndex":[Tool urlIsNull:[_pageIndex stringValue]]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GETUSERFEEDCOMMENTLIST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 NSError* err = nil;
                 UserDynamicDetailModel *dynamicModel = [[UserDynamicDetailModel alloc] initWithDictionary:responseObject error:&err];
                 if(err!=nil)
                 {
                     NSLog(@"%@",err );
                 }
                 if(success)
                     success(dynamicModel);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue ] userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
        
    }
}



+(void)getDefaultHeadImgList:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure
{
    [MKNetWorkRequest POST:URL_GETDEFAULTHEADIMGLIST parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"%@",[responseObject  JSONString]);
         RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
         if ([result.respStatus  intValue]== 1)
         {
             NSMutableArray *arrayList= [[NSMutableArray alloc] init];
             if([responseObject isKindOfClass:[NSDictionary class]])
             {
                 NSArray<NSDictionary> *arrDic = [responseObject objectForKey:@"headImgList"];
                 if(arrDic!=nil && [arrDic count]>0)
                 {
                     for (NSDictionary *dic in arrDic)
                     {
                         NSError* err = nil;
                         HeadImgListModel *imageList = [[HeadImgListModel alloc] initWithString:[dic JSONString] error:&err];
                         if(err!=nil)
                         {
                             NSLog(@"%@",err );
                         }
                         [arrayList addObject:imageList];
                     }
                 }
             }
             if(success)
                 success(arrayList);
         }
         else
         {
             if(failure)
                 failure([NSError errorWithDomain:result.respMsg code:[result.respStatus  intValue ] userInfo:nil]);
         }
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         if(failure)
             failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
     }];
    
}

@end
