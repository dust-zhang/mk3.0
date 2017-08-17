//
//  LoginView.h
//  movikr
//
//  Created by zeyuan on 15/5/10.
//  Copyright (c) 2015年 zeyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareView.h"
#import "ExUITextView.h"
#import "ContractView.h"
#import "RegisterViewController.h"
#import "BFPaperButton.h"
#import "FindPasswordViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController : HideTabBarViewController <UITextFieldDelegate, ExUITextViewDelegate,ShareDelegate,CLLocationManagerDelegate, RegisterViewDelegate>
{
    ExUITextView        *_textUserName;
    ExUITextView        *_textUserPwd;
    //注册按钮
    UIButton            *_btnRegister;
    UIButton            *_btnWeixinLogin;
    UIButton            *_btnWeiboLogin;
    UIButton            *_btnQQLogin;
    //显示密码
    BOOL                isPwdShow;
    //合同的View
    ContractView        *_contractView;
    NSString            *_longitude;
    NSString            *_latitude;
    BFPaperButton       *_btnLogin;
}

@property (nonatomic,retain) CLLocationManager          *_locationMgr;
@property (nonatomic,assign) CLLocationCoordinate2D     _localCoordinate;
@property (nonatomic,strong) NSString                   *_strTopViewName;
@property (nonatomic,strong) NSMutableDictionary        *param;
@property (nonatomic, copy) void(^refreshSalePriceBlock)(void);
@end
