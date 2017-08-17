//
//  ExchangeVoucherVC.m
//  movikr
//
//  Created by mapollo91 on 20/10/16.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import "ExchangeVoucherViewController.h"

@interface ExchangeVoucherViewController ()

@end

@implementation ExchangeVoucherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self._labelTitle.text = @"激活码";
    [self initCtrl];
}

-(void)initCtrl
{
    //webView的位置
    _webView = [[UIWebView alloc ] initWithFrame:CGRectMake(0, self._viewTop.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-self._viewTop.frame.size.height)];
    _webView.delegate = self;
    _webView.layer.masksToBounds = YES;
    _webView.scalesPageToFit = YES;
    [_webView loadRequest:[NSURLRequest requestWithURL:self._url]];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_webView];
}

#pragma mark - webview
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
    [_labelTitle setText:[webView stringByEvaluatingJavaScriptFromString: @"document.title"]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:YES];
    //加载本地js
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"JSBridge" ofType:@"js"];
    NSString *javascript = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString: javascript];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.mainDocumentURL;
    NSString *scheme = request.URL.scheme;
    //NSString *absoluteString = [url absoluteString];
    NSString *host = [url host];
    NSString *query = [url query];
    NSArray *methods = [NSArray arrayWithObjects:@"weixinShare", nil];
    
    if ([scheme isEqualToString: @"jsbridge"])
    {
        NSInteger index = [methods  indexOfObject: host];
        switch (index)
        {
            case 0:
                [self weixinShare:query];
                break;
            default:
                break;
        }
        return NO;
    }
    else
    {
        switch (navigationType)
        {
            case UIWebViewNavigationTypeLinkClicked:
                NSLog(@"clicked");
                break;
            case UIWebViewNavigationTypeFormSubmitted:
                NSLog(@"submitted");
            default:
                break;
        }
        return YES;
    }
}

-(void)touchUpCloseShare
{
    [shareView removeFromSuperview];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_SHOWRECOMMENDBUTTON object:self];
    [UIView animateWithDuration:0.3
                     animations:^{
                         shareView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                         shareView.alpha=0;
                     }completion:^(BOOL finish){
                         shareView.hidden=YES;
                     }];
    
}

- (void)weixinShare:(NSString *)query
{
    _dicShare = [Tool dictionaryWithJsonString:[query URLDecodedString]];
    //输出需要分享的信息
//    NSLog(@"%@",_dicShare);
}

- (NSMutableDictionary *)parseQuery:(NSString *)query
{
    NSString *temp = [query stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSArray *queryArray = [temp componentsSeparatedByString:@"&"];
    NSInteger count = [queryArray count];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSInteger i = 0 ; i < count; i++)
    {
        NSString *temp = [queryArray objectAtIndex:i];
        NSArray *tempArray = [temp componentsSeparatedByString:@"="];
        [dict setObject: tempArray[1] forKey: tempArray[0]];
    }
    return dict;
}

-(void)thirdLoginSucceed:(NSString*)token unionId:(NSString*)unionId loginType:(NSInteger)loginType authorizeStatus:(NSInteger)authorizeStatus;
{
    
}

-(void)thirdLoginFailed
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
