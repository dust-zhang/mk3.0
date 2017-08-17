//
//  ShareCinemaViewController.h
//  supercinema
//
//  Created by Mapollo28 on 2017/2/13.
//
//

#import "HideTabBarViewController.h"
#import "ShareView.h"

@interface ShareCinemaViewController : HideTabBarViewController<UIWebViewDelegate,ShareDelegate>
{
    UIWebView       *_webView;
    ShareView       *shareView;
    UIButton        *_tempButton;
    UIButton        *_closeButton;
    BOOL            _isShowClose;
}
@end
