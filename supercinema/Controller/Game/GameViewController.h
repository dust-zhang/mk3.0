//
//  GameViewController.h
//  supercinema
//
//  Created by dust on 2017/2/8.
//
//

#import <UIKit/UIKit.h>
#import "ServicesGame.h"

@interface GameViewController : UIViewController<WKNavigationDelegate,WKUIDelegate>
{
    WKWebView       *_wkWebView;
    NSDictionary    *_dic;
    UIButton        *_btnReLoad;
    UIImageView     *_imageFailure;
    UILabel         *_labelFailure;
    RequestResult   *_requestResult;
    NSTimer         *_gameProgressTime;
    NSInteger       _countTime;
    
    BOOL            isLoadUserData;
}
@end
