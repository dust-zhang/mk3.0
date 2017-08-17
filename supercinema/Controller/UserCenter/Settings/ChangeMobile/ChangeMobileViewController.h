//
//  ChangeMobileViewController.h
//  supercinema
//
//  Created by mapollo91 on 8/10/16.
//
//

#import <UIKit/UIKit.h>
#import "ExUITextView.h"
#import "BFPaperButton.h"
#import "JKCountDownButton.h"

@interface ChangeMobileViewController : HideTabBarViewController <UITextFieldDelegate, ExUITextViewDelegate>
{
    //确认按钮
    UIButton            *_btnChangeMobileConfirm;
    ExUITextView        *_textPhoneNO;
    ExUITextView        *_textCheckCode;
    ExUITextView        *_textUserPwd;
    NSTimer             *_alertCloseTimer;
    UIButton            *_checkCodeImgBtn;
    NSString            *_getImgKey;
    JKCountDownButton   *_btnCheckCode;
    UILabel             *_labelDivisionLine;
    JKCountDownButton   *_btnVoiceCode;
    BOOL                isPwdShow;
}

@end
