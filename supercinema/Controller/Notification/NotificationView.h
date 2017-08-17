//
//  NotificationView.h
//  supercinema
//
//  Created by dust on 16/12/3.
//
//

#import <UIKit/UIKit.h>
#import "NotifyH5ViewController.h"

@interface NotificationView : UIView<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    UIImageView         *_imageViewActivity;
    UILabel             *_labelTitle;
    UILabel             *_labelEndTime;
    UITextView          *_textViewContent;
    NotifyListModel     *_notifyModel;
}
@property (nonatomic,strong) UIWebView                  *_webView;
@property (nonatomic,strong) UINavigationController     *navigationController;

-(instancetype)initWithFrame:(CGRect)frame navigation:(UINavigationController *) nav model:(NotifyListModel *)notifyModel isActive:(BOOL)active;

@end
