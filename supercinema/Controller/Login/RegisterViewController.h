//
//  RegisterView.h
//  movikr
//
//  Created by zeyuan on 15/5/12.
//  Copyright (c) 2015年 zeyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractView.h"
#import "ExUITextView.h"
#import "ShareView.h"
#import "BFPaperButton.h"
#import "JKCountDownButton.h"
#import "LoginViewController.h"
#import <CoreLocation/CoreLocation.h>

@protocol RegisterViewDelegate <NSObject>
-(void)userNameText:(NSString *)userNameText;

@end

@interface RegisterViewController : HideTabBarViewController <CLLocationManagerDelegate,UITextFieldDelegate, ExUITextViewDelegate,ShareDelegate>
{
    ExUITextView    *_textUserName;
    ExUITextView    *_textUserPwd;
    ExUITextView    *_textCheckCode;
    
    NSTimer         *_alertCloseTimer;
    BOOL            _agreement;
    
    NSString        *_getImgKey;
    BOOL            isUserExist;

    UIButton        *_btnWeixinLogin;
    UIButton        *_btnWeiboLogin;
    UIButton        *_btnQQLogin;
    
    ContractView    *_contractView;
    //显示密码
    BOOL            isPwdShow;
    NSString        *_longitude;
    NSString        *_latitude;
    
    JKCountDownButton *_btnVoiceCode;
    UILabel           *_labelDivisionLine;
    JKCountDownButton *_btnCheckCode;
    
    BFPaperButton   *_btnRegister;
}

@property (nonatomic,strong) UINavigationController     *navigation;
@property (nonatomic,retain) CLLocationManager          *_locationMgr;
@property (nonatomic,assign) CLLocationCoordinate2D     _localCoordinate;
@property (nonatomic,strong) NSString                   *_strTopViewName;
@property (nonatomic, weak) id<RegisterViewDelegate>    registerViewDelegate;

@end
