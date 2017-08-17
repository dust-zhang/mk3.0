//
//  GameViewController.m
//  supercinema
//
//  Created by dust on 2017/2/8.
//
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:RGBA(12, 28, 52, 1)];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self killTimer];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _countTime = 0 ;
    isLoadUserData = FALSE;
    _requestResult = [[RequestResult alloc ] init];
    [self getSystemConfig];
    [self initCtrl];
    
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(onButtonReLoadWebview) name:NOTIFITION_REFRESHGAME object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(getGameIsPlaying) name:NOTIFITION_GAMESTATUS object:nil];
    
    _gameProgressTime = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(showAlter:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_gameProgressTime forMode:NSRunLoopCommonModes];

    [self h5GetRequestHeader];
}

#pragma mark 获取系统配置
-(void)getSystemConfig
{
    [ServicesSystem  getSystemConfig:[Config getDeviceToken] clientId:[Config getGeTuiId] model:^(RequestResult *model)
    {
     } failure:^(NSError *error) {
         
     }];
}

-(void)initCtrl
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    config.mediaPlaybackRequiresUserAction = false;
    [config setMediaPlaybackRequiresUserAction:NO];
    
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
    [_wkWebView setBackgroundColor:RGBA(12, 28, 52, 1)];
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate=self;
    [self.view addSubview:_wkWebView];
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[Config getConfigInfo:@"pastimeGameUrl"]]]];
    
    [self initLoadFaildButton];
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        [_wkWebView setHidden:YES];
        [self showLoadFaildButton];
    }
    else
    {
        [_wkWebView setHidden:NO];
    }

}

-(void) showLoadFaildButton
{
    _imageFailure.hidden = NO;
    _labelFailure.hidden = NO;
    _btnReLoad.hidden = NO;
}

-(void) hideLoadFaildButton
{
    _imageFailure.hidden = YES;
    _labelFailure.hidden = YES;
    _btnReLoad.hidden = YES;
}

-(void) initLoadFaildButton
{
    //加载失败
    _imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, SCREEN_HEIGHT/2-100, 60, 60)];
    _imageFailure.image = [UIImage imageNamed:@"image_NoDataOrder.png"];
    _imageFailure.hidden = YES;
    [self.view addSubview:_imageFailure];
    
    _labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageFailure.frame.origin.y+_imageFailure.frame.size.height+15, SCREEN_WIDTH, 14)];
    _labelFailure.text = @"哎呀，加载失败~";
    _labelFailure.textColor = RGBA(123, 122, 152, 1);
    _labelFailure.font = MKFONT(14);
    _labelFailure.textAlignment = NSTextAlignmentCenter;
    _labelFailure.hidden = YES;
    [self.view addSubview:_labelFailure];
    
    _btnReLoad = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnReLoad.frame = CGRectMake((SCREEN_WIDTH-146/2)/2, _labelFailure.frame.origin.y+_labelFailure.frame.size.height+30, 146/2, 24);
    [_btnReLoad setTitle:@"重新加载" forState:UIControlStateNormal];
    [_btnReLoad setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnReLoad.titleLabel.font = MKFONT(14);
    _btnReLoad.backgroundColor = RGBA(117, 112, 255, 1);
    _btnReLoad.layer.masksToBounds = YES;
    _btnReLoad.layer.cornerRadius = _btnReLoad.frame.size.height/2;
    [_btnReLoad addTarget:self action:@selector(onButtonReLoadWebview) forControlEvents:UIControlEventTouchUpInside];
    _btnReLoad.hidden = YES;
    [self.view addSubview:_btnReLoad];
}


-(void) onButtonReLoadWebview
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        [self showLoadFaildButton];
    }
    else
    {
        [_wkWebView setHidden:NO];
        [self hideLoadFaildButton];
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[Config getConfigInfo:@"pastimeGameUrl"]]]];
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailLoadWithError:(nonnull NSError *)error
{
    [self hideLoadFaildButton];
}

// 是否允许加载网页 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = navigationAction.request.URL.scheme;
    NSString *host = [url host];
    NSString *query = [url query];

    if ([scheme isEqualToString: @"jsbridge"])
    {
        if([host isEqualToString:@"getUserGameData"])
        {
            [self getUserGameData:query];
        }
        if([host isEqualToString:@"startPlayGame"])
        {
            [self startPlayGame:query];
        }
        if([host isEqualToString:@"finishPlayGame"])
        {
            [self finishPlayGame:query];
        }
        if([host isEqualToString:@"cancelRound"])
        {
            [self cancelRound:query];
        }
        if([host isEqualToString:@"receiveChest"])
        {
            [self receiveChest:query];
        }
        if([host isEqualToString:@"showTabBar"])
        {
            [self showTabBar:query];
        }
        if([host isEqualToString:@"hideTabBar"])
        {
            [self hideTabBar:query];
        }
        if([host isEqualToString:@"toLoginView"])
        {
            [self toLoginView];
        }
        if([host isEqualToString:@"h5GetRequestHeader"])
        {
            [self h5GetRequestHeader];
        }
        if([host isEqualToString:@"isPause"])
        {
            [self isPause];
        }
        if([host isEqualToString:@"isPlaying"])
        {
            [self isPlaying];
        }
        if([host isEqualToString:@"getGroupGoodsList"])
        {
            [self getGroupGoodsList:query];
        }
        if([host isEqualToString:@"buyGoods"])
        {
            [self buyGoods:query];
        }
    }
   decisionHandler(WKNavigationActionPolicyAllow);
}

-(void) showTabBar:(NSString *)query
{
//    NSLog(@"%@",[query URLDecodedString]);
    [Tool showTabBar];
}
-(void) hideTabBar:(NSString *)query
{
//    NSLog(@"%@",[query URLDecodedString]);
    if ([[Config getTabbarStatus] isEqualToString:@"2"])
    {
        [Tool hideTabBar];
    }
}

- (void)getUserGameData:(NSString *)query
{
    isLoadUserData = TRUE;
    _dic = [Tool dictionaryWithJsonString:[query URLDecodedString]];
    __weak typeof(self) weakSelf = self;
    [ServicesGame getUserGameData:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"gameId"] ] result:^(NSString *responseObject)
    {
        NSMutableString *resultStr = [NSMutableString stringWithString:responseObject];
        NSString *character = nil;
        for (int i = 0; i < resultStr.length; i ++)
        {
            character = [resultStr substringWithRange:NSMakeRange(i, 1)];
            if ([character isEqualToString:@"\\"])
                [resultStr deleteCharactersInRange:NSMakeRange(i, 1)];
        }
        
        [weakSelf callBack:_dic result:resultStr type:@"getUserGameData"];
        [self killTimer];
        
    } failure:^(NSError *error) {
        _requestResult.respStatus = [NSNumber numberWithInteger:error.code] ;
        _requestResult.respMsg = error.domain;
        [weakSelf callBack:_dic result:[_requestResult toJSONString] type:@"getUserGameData"];
    }];
}


- (void)startPlayGame:(NSString *)query
{
    _dic = [Tool dictionaryWithJsonString:[query URLDecodedString]];
    __weak typeof(self) weakSelf = self;
    [ServicesGame startPlayGame:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"gameId"] ]
                 playInCinemaId:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"playInCinemaId"] ] result:^(NSString *responseObject)
    {
        [weakSelf callBack:_dic result:responseObject type:@"startPlayGame"];

    } failure:^(NSError *error) {
        _requestResult.respStatus = [NSNumber numberWithInteger:error.code] ;
        _requestResult.respMsg = error.domain;
        [weakSelf callBack:_dic result:[_requestResult toJSONString] type:@"startPlayGame"];
    }];
}

- (void)finishPlayGame:(NSString *)query
{
    _dic = [Tool dictionaryWithJsonString:[query URLDecodedString]];
    __weak typeof(self) weakSelf = self;
    
    [ServicesGame finishPlayGame:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"roundId"] ]
                       goldCount:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"goldCount"] ]
                     isFirstPlay:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"isFirstPlay"] ]
        strokesIndexAndCountList:[_dic objectForKey:@"strokesIndexAndCountList"]  result:^(NSString *responseObject)
    {
        [weakSelf callBack:_dic result:responseObject type:@"finishPlayGame"];
                         
    } failure:^(NSError *error) {
        _requestResult.respStatus = [NSNumber numberWithInteger:error.code] ;
        _requestResult.respMsg = error.domain;
        [weakSelf callBack:_dic result:[_requestResult toJSONString] type:@"finishPlayGame"];
    }];
}

- (void)cancelRound:(NSString *)query
{
    _dic = [Tool dictionaryWithJsonString:[query URLDecodedString]];
     __weak typeof(self) weakSelf = self;
    [ServicesGame cancelRound:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"roundId"] ] result:^(NSString *responseObject)
    {
        [weakSelf callBack:_dic result:responseObject type:@"cancelRound"];
        
    } failure:^(NSError *error) {
        _requestResult.respStatus = [NSNumber numberWithInteger:error.code] ;
        _requestResult.respMsg = error.domain;
        [weakSelf callBack:_dic result:[_requestResult toJSONString] type:@"cancelRound"];
    }];
}

- (void)receiveChest:(NSString *)query
{
    _dic = [Tool dictionaryWithJsonString:[query URLDecodedString]];
    __weak typeof(self) weakSelf = self;
    [ServicesGame receiveChest:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"chestId"] ] result:^(NSString *responseObject)
    {
        [weakSelf callBack:_dic result:responseObject type:@"receiveChest"];
        
    } failure:^(NSError *error) {
        _requestResult.respStatus = [NSNumber numberWithInteger:error.code] ;
        _requestResult.respMsg = error.domain;
        [weakSelf callBack:_dic result:[_requestResult toJSONString] type:@"receiveChest"];
    }];
}
//获取可出售商品列表
-(void) getGroupGoodsList:(NSString *)query
{
    _dic = [Tool dictionaryWithJsonString:[query URLDecodedString]];
    __weak typeof(self) weakSelf = self;
    [ServicesGame getGroupGoodsList:^(NSString *responseObject)
    {
        [weakSelf callBack:_dic result:responseObject type:@"getGroupGoodsList"];
        
    } failure:^(NSError *error) {
        _requestResult.respStatus = [NSNumber numberWithInteger:error.code] ;
        _requestResult.respMsg = error.domain;
        [weakSelf callBack:_dic result:[_requestResult toJSONString] type:@"getGroupGoodsList"];
    }];
}

//购买商品
-(void) buyGoods:(NSString *)query
{
    _dic = [Tool dictionaryWithJsonString:[query URLDecodedString]];
    __weak typeof(self) weakSelf = self;
    [ServicesGame buyGoods:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"goodsId"] ] result:^(NSString *responseObject)
    {
        [weakSelf callBack:_dic result:responseObject type:@"buyGoods"];
        
    } failure:^(NSError *error) {
        _requestResult.respStatus = [NSNumber numberWithInteger:error.code] ;
        _requestResult.respMsg = error.domain;
        [weakSelf callBack:_dic result:[_requestResult toJSONString] type:@"buyGoods"];
    }];
}

-(void)toLoginView
{
    LoginViewController *loginControlller = [[LoginViewController alloc] init];
    loginControlller._strTopViewName = @"GameViewController";
    [self.navigationController pushViewController:loginControlller animated:YES];
}

-(void)h5GetRequestHeader
{
    NSString* header = [[MKPackJson getRequestHeader] JSONString];
    NSLog(@"header: %@",header);
}

-(void) callBack:(NSDictionary *)dic result:(NSString *)str type:(NSString *)strFunName
{
    [_wkWebView evaluateJavaScript:[NSString stringWithFormat:@"%@(\"%@\")",[dic objectForKey:@"callback"],[str URLEncodedString] ] completionHandler:^(id _Nullable response, NSError * _Nullable error)
    {
        NSLog(@"%@ %@",response,error);
    }];
}

-(void)getGameIsPlaying
{
    [_wkWebView evaluateJavaScript:@"getGameIsPlaying()" completionHandler:^(id _Nullable response, NSError * _Nullable error)
     {
         NSLog(@"%@ %@",response,error);
     }];
}

-(void)isPlaying
{
    [self hideTabBar:@""];
}
-(void)isPause
{
    [self showTabBar:@""];
}


//@"网络异常点击重新加载"
- (void)showAlter:(NSTimer* )timer
{
    _countTime ++;
    if (!isLoadUserData)
    {
        if (_countTime >= 60 )
        {
            //判断是否已经加载完成
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络连接异常，请确认“重新连接”" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新连接", nil];
            [alert show];
            [self killTimer];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        _countTime = 0;
        [self onButtonReLoadWebview];
        _gameProgressTime = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(showAlter:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_gameProgressTime forMode:NSRunLoopCommonModes];
    }
    else
    {
        [_wkWebView setHidden:YES];
        [self showLoadFaildButton];
        [self killTimer];
    }
}

-(void) killTimer
{
    if(_gameProgressTime)
    {
        [_gameProgressTime invalidate];
        _gameProgressTime = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
