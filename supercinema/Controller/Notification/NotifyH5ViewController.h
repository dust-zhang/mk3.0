//
//  NotifyH5ViewController.h
//  supercinema
//
//  Created by Mapollo28 on 2016/12/22.
//
//

#import "HideTabBarViewController.h"
#import "ShareView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "FDActionSheet.h"

@interface NotifyH5ViewController : HideTabBarViewController<WKNavigationDelegate,WKUIDelegate,ShareDelegate,FDActionSheetDelegate>
{
    WKWebView       *_wkWebView;
    
    ShareView       *shareView;
    NSDictionary    *_dicShare;
}
@property(nonatomic,strong)  NotifyListModel  *_notifyModel;
@property (strong,nonatomic) NSString         *_shareUrl;
@end
