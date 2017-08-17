//
//  ModifySignViewController.h
//  supercinema
//
//  Created by dust on 16/11/29.
//
//

#import <UIKit/UIKit.h>

@interface ModifySignViewController : UIViewController<UITextViewDelegate>
{
    UILabel         *_labelShowContent;
    UILabel         *_labelTextCount;
    UIButton        *_btnEnsure;
    UITextView      *_textViewSign;
}

@property (nonatomic,strong) NSString *_strSign;
@end
