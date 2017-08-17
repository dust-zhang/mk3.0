//
//  ExchangeVoucherVC.h
//  movikr
//
//  Created by mapollo91 on 20/10/16.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "NSStringURLEncoding.h"
#import "ShareView.h"

@interface ExchangeVoucherViewController : HideTabBarViewController<UIWebViewDelegate,ShareDelegate>
{
    UIWebView       *_webView;
    UILabel         *_labelTitle;  //标题
    UIButton        *_btnShare;    //分享按钮
    NSInteger       currRecommendId;//推荐的ID号
    ShareView       *shareView;
    NSDictionary    *_dicShare;
}

@property (nonatomic,strong) NSURL          *_url;

@end
