//
//  ChangePwdViewController.h
//  supercinema
//
//  Created by mapollo91 on 30/9/16.
//
//

#import <UIKit/UIKit.h>
#import "ExUITextView.h"
#import "BFPaperButton.h"

@interface ChangePwdViewController : HideTabBarViewController <UITextFieldDelegate, ExUITextViewDelegate>
{
    //确认按钮
    UIButton        *_btnChangePwdConfirm;
    //原密码
    ExUITextView    *_textOldPwd;
    //新密码
    ExUITextView    *_textNewPwd;
//    NSTimer         *_alertCloseTimer;
}

@end
