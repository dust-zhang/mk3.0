//
//  ShareReasonViewController.h
//  supercinema
//
//  Created by mapollo91 on 23/3/17.
//
//

#import <UIKit/UIKit.h>

@protocol ShareReasonTextDelegate <NSObject>
-(void)ShareReasonTextDelegate:(NSString *)shareReasoText;
@end
@interface ShareReasonViewController : UIViewController <UITextViewDelegate>
{
    UILabel         *_labelShowContent; //显示内容
    UILabel         *_labelTextCount;   //文字个数
    UIButton        *_btnEnsure;        //确认按钮
    UITextView      *_textViewSign;     //输入的内容
}
@property (nonatomic, weak) id <ShareReasonTextDelegate> delegate;
@property (nonatomic,strong) NSString *_strSign;
@end
