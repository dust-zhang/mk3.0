//
//  ActivityCenterWebViewController.h
//  movikr
//
//  Created by Mapollo28 on 16/4/13.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface ActivityCenterWebViewController : UIViewController<WKNavigationDelegate,WKUIDelegate,ShareDelegate>
{
    UIView          *_backGroundView;
    WKWebView       *_wkWebView;
    
    UILabel         *_labelTitle;   //标题
    UIButton        *_btnReturn;    //返回按钮
    UIButton        *_btnShare;     //分享按钮
    
    NSInteger       currRecommendId;//推荐的ID号
    ShareView       *shareView;
    NSDictionary    *_dicShare;
    
}

@property (nonatomic,strong) NSURL          *_url;
@property (strong,nonatomic) NSString       *_isFromView;
@property (nonatomic,strong) NSString       *_viewName;
@end
