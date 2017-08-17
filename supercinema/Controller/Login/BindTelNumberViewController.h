//
//  BindTelNumberViewController.h
//  supercinema
//
//  Created by dust on 16/12/20.
//
//

#import <UIKit/UIKit.h>
#import "ExUITextView.h"
#import "BFPaperButton.h"
#import "JKCountDownButton.h"


@interface BindTelNumberViewController : HideTabBarViewController <UITextFieldDelegate, ExUITextViewDelegate>
{
    //确认按钮
    UIButton            *_btnChangeMobileConfirm;
    ExUITextView        *_textPhoneNO;
    ExUITextView        *_textCheckCode;
    ExUITextView        *_textUserPwd;
    NSTimer             *_alertCloseTimer;
    UIButton            *_checkCodeImgBtn;
    NSString            *_getImgKey;
    JKCountDownButton   *_btnGetCheckCode;
    UILabel             *_labelDivisionLine;
    JKCountDownButton   *_btnVoiceCode;
    BOOL                isPwdShow;
}


@end
