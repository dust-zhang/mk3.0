//
//  UserCenterViewController.h
//  supercinema
//
//  Created by mapollo91 on 29/7/16.
//
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "MyAttentionViewController.h"
#import "ExchangeVoucherViewController.h"
#import "MyFansViewController.h"
#import "WantLookViewController.h"
#import "ModifySignViewController.h"
#import "NotifiViewController.h"
#import "MyDynamicViewController.h"
#import "MovieReviewViewController.h"
#import "ShareCinemaViewController.h"

@interface UserCenterViewController : ShowTabBarViewController <UIScrollViewDelegate>
{
    //顶部背景
    UIView          *_topView;
    UIImageView     *_imageTopBG;
    //蒙层
    UIView          *_viewHazy;
    //整体
    UIScrollView    *_scrollViewUserSet;
    //签名View
    UIView          *_userSignature;
    //曲线背景
    UIImageView     *_imageCurveBG;
    UIButton        *_imageUserIcon;    //用户头像
    UIButton        *_btnLogin;         //登录按钮
    UILabel         *_labelUserName;    //用户昵称
    UIImageView     *_imageSex;         //性别
    UITextView      *_textViewUserSignature;    //签名文本输入框
    UILabel         *_labelUserSignature;       //正文提示文字
    //关注；粉丝；想看；看过
    UIView          *_viewUserBtnsBG;
    //功能背景
    UIView          *_viewFunctionBG;
    UILabel         *_labelUnPayOrder;
    UILabel         *_labelNotice;
    UILabel         *_labelMyShare;
    UILabel         *_labelNumber[4];
    UserUnReadDataModel *_userUnReadDataModel;
    UserModel       *_userModel;
    UIView          *_viewBigHead;

    UIImageView     *_imageViewBigHead;
    CGRect          _oldFrame;    //保存图片原来的大小
    CGRect          _largeFrame;  //确定图片放大最大的程度
    
}


@end
