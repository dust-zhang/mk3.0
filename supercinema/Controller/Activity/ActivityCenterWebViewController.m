//
//  ActivityCenterWebViewController.m
//  movikr
//
//  Created by Mapollo28 on 16/4/13.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import "ActivityCenterWebViewController.h"
#import "NSStringURLEncoding.h"

@interface ActivityCenterWebViewController ()

@end

@implementation ActivityCenterWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCtrl];
    [Tool hideTabBar];
}


-(void)initCtrl
{
    //背景
    self.view.backgroundColor = [UIColor blackColor];
    
    //标题
    _labelTitle = [[UILabel alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH/2-90, 40, 180, 16)];
    [_labelTitle setBackgroundColor:[UIColor clearColor]];
    [_labelTitle setTextAlignment:NSTextAlignmentCenter];//居中
    [_labelTitle setFont:MKFONT(16)];
    [_labelTitle setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:_labelTitle];
    
    //返回按钮(左上角)
    _btnReturn = [[UIButton alloc] initWithFrame:CGRectMake(5,36, 52, 23)];
    [_btnReturn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnReturn.titleLabel.font = MKFONT(14);
    [_btnReturn setImage:[UIImage imageNamed:@"button_returnClearLong.png"] forState:UIControlStateNormal];
    [_btnReturn addTarget:self action:@selector(onButtonReturn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnReturn];
    
    UILabel *_labelReturn = [[UILabel alloc]initWithFrame:CGRectMake(_btnReturn.frame.origin.x+15, _btnReturn.frame.origin.y+4, 31, 14)];
    [_labelReturn setBackgroundColor:[UIColor clearColor]];
    [_labelReturn setTextAlignment:NSTextAlignmentRight];//右对齐
    [_labelReturn setFont:MKFONT(14)];
    [_labelReturn setTextColor:[UIColor whiteColor]];
    [_labelReturn setText:@"返回"];
    [self.view addSubview:_labelReturn];
    
    //分享按钮
    _btnShare =[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30-21,_btnReturn.frame.origin.y-15,53,53)];
    [_btnShare setImage:[UIImage imageNamed:@"button_white_share.png"] forState:UIControlStateNormal];
    [_btnShare setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [_btnShare addTarget:self action:@selector(touchUpShareRecommendImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnShare];
    
    [self loadWebView];
}

-(void)loadWebView
{
    //webView的位置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    config.mediaPlaybackRequiresUserAction = false;
    [config setMediaPlaybackRequiresUserAction:NO];
    
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, SCREEN_HEIGHT-75) configuration:config];
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate=self;
    [self.view addSubview:_wkWebView];
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:self._url]];

}

//返回
-(void)onButtonReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}

//分享
-(void)touchUpShareRecommendImage
{
    if(!shareView)
    {
        shareView=[ShareView getShareInstance];
        shareView.backgroundColor = [UIColor clearColor];
        shareView.hidden=YES;
        shareView.alpha = 0;
        shareView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }

    shareView.shareContentType=WeiChatShareContentTypeNews;
    shareView.shareDelegate=self;
    shareView.shareObjectType=ShareContentTypeOfTopicImage;
    
    if ([[_dicShare objectForKey:@"url"] length] == 0 || [_dicShare isEqual:nil])
    {
        shareView.shareUrl = [NSString stringWithFormat:@"%@",self._url];
    }
    else
    {
        //获取字典中的url
        shareView.shareUrl=[_dicShare objectForKey:@"url"];
    }
    if ([[_dicShare objectForKey:@"title"] length]== 0 || [_dicShare isEqual:nil])
    {
        shareView.shareTitle = _labelTitle.text;
    }
    else
    {
        shareView.shareTitle = [_dicShare objectForKey:@"title"];
    }
    shareView.shareDescription = [_dicShare objectForKey:@"desc"];
    if([shareView.shareDescription length] == 0)
    {
        shareView.shareDescription = _labelTitle.text;
    }
    shareView.shareImgUrl = [_dicShare objectForKey:@"img"];
    shareView.imageType = @"game";
    
    [self.view addSubview:shareView];

    [UIView animateWithDuration:0.2
                     animations:^{
                         shareView.transform = CGAffineTransformMakeScale(1, 1);
                         shareView.hidden=NO;
                         shareView.alpha=1;
                     }completion:^(BOOL finish){
                         
                     }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
//    NSLog(@"%@",webView.title);
    [_labelTitle setText:webView.title];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
{
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
//    NSLog(@"%@",webView.title);
    [_labelTitle setText:webView.title];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:YES];
    //加载本地js
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"JSBridge" ofType:@"js"];
    NSString *javascript = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    [_wkWebView evaluateJavaScript:javascript completionHandler:^(id _Nullable response, NSError * _Nullable error)
     {
         NSLog(@"%@ %@",response,error);
         
     } ];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = navigationAction.request.URL.scheme;
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
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)touchUpCloseShare
{
    [shareView removeFromSuperview];
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
    NSLog(@"%@",_dicShare);
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
}

@end
