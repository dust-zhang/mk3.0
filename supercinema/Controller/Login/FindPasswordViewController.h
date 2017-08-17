//
//  FindPasswordViewController.h
//  movikr
//
//  Created by zeyuan on 15/6/2.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExUITextView.h"
#import "BFPaperButton.h"
#import "JKCountDownButton.h"
#import "UserModel.h"
#import <CoreLocation/CoreLocation.h>


@interface FindPasswordViewController : HideTabBarViewController <CLLocationManagerDelegate,UITextFieldDelegate, ExUITextViewDelegate>
{
    ExUITextView    *_textUserName;
    ExUITextView    *_textUserPwd;
    ExUITextView    *_textCheckCode;
    UIButton        *_checkCodeImgBtn;
    NSTimer         *_alertCloseTimer;
    NSString        *_getImgKey;
    //显示密码
    BOOL            isPwdShow;
    NSString        *_longitude;
    NSString        *_latitude;
    BFPaperButton   *_btnLogin;
    JKCountDownButton *_btnVoiceCode;
    UILabel           *_labelDivisionLine;
    JKCountDownButton *_btnCheckCode;
    
    BOOL            isFirst;
}

@property (nonatomic,strong) NSString                   *_userName;
//是否登录过
@property (nonatomic,assign) BOOL                       isRoot;
@property (nonatomic,retain) CLLocationManager          *_locationMgr;
@property (nonatomic,assign) CLLocationCoordinate2D     _localCoordinate;

@end
