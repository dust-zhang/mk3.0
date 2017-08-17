//
//  ChangeNicknameViewController.h
//  supercinema
//
//  Created by mapollo91 on 29/9/16.
//
//

#import <UIKit/UIKit.h>
#import "ExUITextView.h"
#import "UserModel.h"

//定义协议
@protocol ChangeNicknameDelegate <NSObject>
-(void)changeNickname:(NSString *)newNickName;
@end

@interface ChangeNicknameViewController : HideTabBarViewController <UITextFieldDelegate, ExUITextViewDelegate>
{
    //输入框的View背景
    UIView              *_textViewBG;
    ExUITextView        *_textFieldChangeNickname;
    //确认按钮
    UIButton            *_btnChangeNicknameConfirm;
    UILabel             *_labelWordNum;
}

@property(nonatomic,assign) id<ChangeNicknameDelegate>  delegate;
@property(nonatomic,strong) UserModel                   *_userModel;

@end
