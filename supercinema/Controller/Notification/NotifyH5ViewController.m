//
//  NotifyH5ViewController.m
//  supercinema
//
//  Created by Mapollo28 on 2016/12/22.
//
//

#import "NotifyH5ViewController.h"

@interface NotifyH5ViewController ()

@end

@implementation NotifyH5ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initControl];
}

-(void)initControl
{
    UIButton* btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(SCREEN_WIDTH-15-30, self._btnBack.frame.origin.y+(self._btnBack.frame.size.height-30)/2, 45, 30);
    [btnRight setBackgroundImage:[UIImage imageNamed:@"btn_moreBlack.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(onButtonRight) forControlEvents:UIControlEventTouchUpInside];
    [self._viewTop addSubview:btnRight];
    [self initWebView];
    [self loadWebView];
}

-(void)initWebView
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    config.mediaPlaybackRequiresUserAction = false;
    [config setMediaPlaybackRequiresUserAction:NO];
    
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self._viewTop.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-self._viewTop.frame.size.height) configuration:config];
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate=self;
    [self.view addSubview:_wkWebView];

}

-(void)loadWebView
{
    if ([self._shareUrl length] >0)
    {
         [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self._shareUrl]]];
    }
    else
    {
          [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self._notifyModel.jumpUrl]]];
    }
   
}

-(void) onButtonBack
{
    [MobClick event:activityViewbtn5];
    if( ![sqlDatabase updateNotice:self._notifyModel.notifyId  status:self._notifyModel.frequencyType ])
    {
        NSLog(@"修改数据库失败！");
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onButtonRight
{
    NSMutableArray* arrDelete = [[NSMutableArray alloc] init];
    [arrDelete addObject:@{ @"name" : @"分享" }];
    [arrDelete addObject:@{ @"name" : @"刷新" }];
    [arrDelete addObject:@{ @"name" : @"复制链接" }];
    FDActionSheet* sheetDelete = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:arrDelete];
    for (int i = 0; i < arrDelete.count; i++)
    {
        [sheetDelete setButtonTitleColor:RGBA(51, 51, 51,1) bgColor:[UIColor whiteColor] fontSize:15 atIndex:i];
    }
    sheetDelete.delegate = self;
    [sheetDelete show];
}

- (void)actionSheet:(FDActionSheet*)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //分享
        [self touchUpShareRecommendImage];
    }
    else if (buttonIndex == 1)
    {
        //刷新
        [self loadWebView];
    }
    else if (buttonIndex == 2)
    {
        if ([[_dicShare objectForKey:@"url"] length] > 0 && ![_dicShare isEqual:nil])
        {
            self._shareUrl = [_dicShare objectForKey:@"url"];
        }
        if ([self._shareUrl length] == 0)
        {
            [Tool showWarningTip:@"复制失败" time:2.0];
        }
        else
        {
            [Tool showSuccessTip:@"复制成功" time:2.0];
            UIPasteboard *pastboard=[UIPasteboard generalPasteboard];
            pastboard.string=self._shareUrl;
        }
    }
}

//分享
-(void)touchUpShareRecommendImage
{
    [MobClick event:activityViewbtn6];
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
        shareView.shareUrl = self._shareUrl;
    }
    else
    {
        //获取字典中的url
        shareView.shareUrl=[_dicShare objectForKey:@"url"];
    }
    
    if ([[_dicShare objectForKey:@"title"] length]== 0 || [_dicShare isEqual:nil])
    {
        shareView.shareTitle = self._labelTitle.text;
    }
    else
    {
        shareView.shareTitle = [_dicShare objectForKey:@"title"];
    }
    shareView.shareDescription = [_dicShare objectForKey:@"desc"];
    if([shareView.shareDescription length] == 0)
    {
        shareView.shareDescription = self._labelTitle.text;
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

#pragma mark - webview
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
    NSLog(@"%@",webView.title);
    [self._labelTitle setText:webView.title];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
{
    [FVCustomAlertView hideAlertFromView:self.view fading:YES];
    NSLog(@"%@",webView.title);
    [self._labelTitle setText:webView.title];
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
/*
 首页                   home
 指定影片购票页         st
 小卖部                 goods
 凑热闹                 act
 捡便宜                 vip
 我的卡包               icard
 我的订单               iorder
 他人动态页              u
 */
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
    else
    {
        if([scheme isEqualToString:@"movikr"])
        {
            //首页
            if([host isEqualToString:@"home"])
            {
                //修改此通知是否再次显示状态1：以后不再显示
                if( ![sqlDatabase updateNotice:self._notifyModel.notifyId  status:self._notifyModel.frequencyType ])
                {
                    NSLog(@"修改数据库失败！");
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            if([host isEqualToString:@"st"])
            {
                MovieModel *movieModel = [[MovieModel alloc] init];
                movieModel.movieId = [NSNumber numberWithInt:[self._notifyModel.movieId intValue]];
                ShowTimeViewController* showTimeVC = [[ShowTimeViewController alloc]init];
                showTimeVC.hotMovieModel = movieModel;
                [self.navigationController pushViewController:showTimeVC animated:YES];
            }
            if([host isEqualToString:@"goods"])
            {
                if( ![sqlDatabase updateNotice:self._notifyModel.notifyId  status:self._notifyModel.frequencyType ])
                {
                    NSLog(@"修改数据库失败！");
                }
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                NSDictionary* dictTab = @{@"tag":@0};
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
                NSDictionary* dictHome = @{@"tag":@2};
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
                
            }
            if([host isEqualToString:@"act"])
            {
                if( ![sqlDatabase updateNotice:self._notifyModel.notifyId  status:self._notifyModel.frequencyType ])
                {
                    NSLog(@"修改数据库失败！");
                }
                
                NSDictionary* dictTab = @{@"tag":@0};
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
                NSDictionary* dictHome = @{@"tag":@3};
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            if([host isEqualToString:@"vip"])
            {
                if( ![sqlDatabase updateNotice:self._notifyModel.notifyId  status:self._notifyModel.frequencyType ])
                {
                    NSLog(@"修改数据库失败！");
                }
                
                NSDictionary* dictTab = @{@"tag":@0};
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
                NSDictionary* dictHome = @{@"tag":@1};
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            if([host isEqualToString:@"icard"])
            {
                MyCardViewController *myCardController = [[MyCardViewController alloc ] init];
                [self.navigationController pushViewController:myCardController animated:YES];
            }
            if([host isEqualToString:@"iorder"])
            {
                MyOrderViewController *myOrderController = [[MyOrderViewController alloc ] init];
                [self.navigationController pushViewController:myOrderController animated:YES];
            }
            if([host isEqualToString:@"u"])
            {
                
            }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
