//
//  ShareCinemaViewController.m
//  supercinema
//
//  Created by Mapollo28 on 2017/2/13.
//
//

#import "ShareCinemaViewController.h"
#import "MKEnum.h"

@interface ShareCinemaViewController ()

@end

@implementation ShareCinemaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initCtrl];
}

-(void)initCtrl
{
    self.view.backgroundColor = [UIColor blackColor];
    _webView = [[UIWebView alloc ] initWithFrame:CGRectMake(0, self._viewTop.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-self._viewTop.frame.size.height)];
    _webView.delegate = self;
    _webView.layer.masksToBounds = YES;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[Config getConfigInfo:@"userHomeShareUrl"]] ]];
    
    shareView=[ShareView getShareInstance];
    shareView.shareContentType=WeiChatShareContentTypeNews;
    shareView.shareDelegate=self;
    shareView.shareObjectType=ShareContentTypeOfTopicImage;
    
    _tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self._labelTitle.frame = CGRectMake(41, 30, SCREEN_WIDTH-82, 17);
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [_closeButton setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    _closeButton.titleLabel.font = MKFONT(15);
    _closeButton.frame = CGRectMake(41, 23, 75/2, 30);
    _closeButton.hidden = YES;
    [_closeButton addTarget:self action:@selector(onButtonClose) forControlEvents:UIControlEventTouchUpInside];
    [self._viewTop addSubview:_closeButton];
    
    _isShowClose = NO;
}

-(void)onButtonClose
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onButtonBack
{
    if (_isShowClose)
    {
        _closeButton.hidden = NO;
    }
    if ([_webView canGoBack])
    {
        [_webView goBack];
    }
    else
    {
        [self onButtonClose];
    }
}

#pragma mark - webview
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self._labelTitle setText:[webView stringByEvaluatingJavaScriptFromString: @"document.title"]];
    //加载本地js
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"JSBridge" ofType:@"js"];
    NSString *javascript = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString: javascript];
    
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.mainDocumentURL;
    NSString *scheme = request.URL.scheme;
    NSString *host = [url host];
    NSString *query = [url query];
    
    if ([scheme isEqualToString: @"jsbridge"])
    {
        if([host isEqualToString:@"clientShare"])
        {
            [self receiveChest:query];
        }
        return YES;
    }
    else
    {
        switch (navigationType)
        {
            case UIWebViewNavigationTypeLinkClicked:
                _isShowClose = YES;
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

- (void)receiveChest:(NSString *)query
{
    NSDictionary *_dic = [Tool dictionaryWithJsonString:[query URLDecodedString]];
    
    if ([[_dic objectForKey:@"url"] length] == 0)
    {
        shareView.shareUrl = [NSString stringWithFormat:@"%@",[Config getConfigInfo:@"userHomeShareUrl"]];
    }
    else
    {
        //获取字典中的url
        shareView.shareUrl=[_dic objectForKey:@"url"];
    }
    if ([[_dic objectForKey:@"title"] length]== 0)
    {
        shareView.shareTitle = self._labelTitle.text;
    }
    else
    {
        shareView.shareTitle = [_dic objectForKey:@"title"];
    }
    if ([[_dic objectForKey:@"desc"] length]>0)
    {
        shareView.shareDescription = [_dic objectForKey:@"desc"];
    }
    
    shareView.shareImgUrl = [_dic objectForKey:@"img"];
    shareView.imageType = @"game";
    
    int shareType = [[_dic objectForKey:@"clientType"] intValue];
    switch (shareType)
    {
        case weixinShare:
        {
            [shareView touchUpShareToWeiChat:_tempButton];
        }
            break;
        case weixinFriendsShare:
        {
            [shareView touchUpShareToFriend:_tempButton];
        }
            break;
        case weiboShare:
        {
            [shareView touchUpShareToWeibo:_tempButton];
        }
            break;
        case qqShare:
        {
            [shareView touchUpShareToQQ:_tempButton];
        }
            break;
        case qqZoneShare:
        {
            [shareView touchUpShareToQQZone:_tempButton];
        }
            break;
        case copyLink:
        {
            [shareView touchUpCopy:_tempButton];
        }
            break;
        default:
            break;
    }
}

-(void)touchUpCloseShare
{

}

-(void)thirdLoginSucceed:(NSString*)token unionId:(NSString*)unionId loginType:(NSInteger)loginType authorizeStatus:(NSInteger)authorizeStatus
{

}

-(void)thirdLoginFailed
{
    
}

- (void)dealloc
{
    _webView.delegate = nil;
    [_webView stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
