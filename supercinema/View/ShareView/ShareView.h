//
//  ShareViewController.h
//  movikr
//
//  Created by Mapollo25 on 15/6/1.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "XHRealTimeBlur.h"
typedef enum{
    WeiChatShareContentTypeNews,
    WeiChatShareContentTypeImage
}WeiChatShareContentType;

typedef enum{
    ShareContentTypeOfArticle,
    ShareContentTypeOfActivity,
    ShareContentTypeOfTopicImage
}ShareContentType;

@interface ShareView : UIView
{
    TencentOAuth* _tencentOAuth;
    CGRect        _btnFrame[7];
    UIButton*     _buttonWeiChat;
    UIButton*     _buttonWeiChatFriend;
    UIButton*     _buttonWeiBo;
    UIButton*     _buttonQQ;
    UIButton*     _buttonQQZone;
    UIButton*     _buttonCopy;
    NSInteger     _tagBtnWeiChatFriend;
    NSInteger     _tagBtnWeiBo;
    NSInteger     _tagBtnQQZone;
    NSTimer*      _timer;
    
    WBBaseResponse* _wbRespond;
}

+(ShareView*)getShareInstance;
@property (nonatomic) NSInteger shareObjectId;
@property (nonatomic) ShareContentType shareObjectType;
@property (nonatomic,weak) id<ShareDelegate> shareDelegate;
@property (nonatomic,copy) NSString *shareUrl;
@property (nonatomic,copy) NSString *shareTitle;
@property (nonatomic,copy) NSString *imageTitle;
@property (nonatomic,copy) NSString *shareDescription;
@property (nonatomic,copy) NSString *shareImgUrl;
@property (nonatomic) WeiChatShareContentType shareContentType;
@property (nonatomic,strong) UIImage *shareImage;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) UIImage *thumbImage;
@property (nonatomic,strong) NSString *imageType;

+(void)weiboThirdLogin;
+(void)QQLogin;
+(void)weixinLogin;
-(void)onResponse:(NSObject*)response;

-(void)touchUpShareToWeiChat:(UIButton *)sender;
-(void)touchUpShareToFriend:(UIButton *)sender;
-(void)touchUpShareToWeibo:(UIButton*)sender;
-(void)touchUpShareToQQ:(UIButton *)sender;
-(void)touchUpShareToQQZone:(UIButton *)sender;
-(void)touchUpCopy:(UIButton *)sender;
@end
