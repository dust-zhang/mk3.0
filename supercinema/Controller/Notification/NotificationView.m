//
//  NotificationView.m
//  supercinema
//
//  Created by dust on 16/12/3.
//
//

#import "NotificationView.h"

@implementation NotificationView

-(instancetype)initWithFrame:(CGRect)frame navigation:(UINavigationController *) nav model:(NotifyListModel *)notifyModel isActive:(BOOL)active
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:RGBA(0, 0, 0, 0.5)];
        _notifyModel = notifyModel;
        self.navigationController = nav;
        if (active)
        {
            //跳转类型jumpType 1:无，2:h5页面，3:app内界面
//            if ([notifyModel.jumpType intValue] == 1)
//            {
//                [self initContorlller:notifyModel];
//            }
//            if ([notifyModel.jumpType intValue] == 2)
//            {
//                [self initWebWiew:notifyModel];
//            }
//            if ([notifyModel.jumpType intValue] == 3)
//            {
                [self initContorlller:notifyModel];
//            }
        }
        else
        {
            [self initWebWiew:notifyModel];
        }
        //通知统计(通知显示)
        [ServicesNotification addNoticeCount:@"notify_display" countObjectId:[Tool getNotifyId:notifyModel.notifyId cinemaId:notifyModel.cinemaId] result:^(RequestResult *result)
         {
             NSLog(@"notify_display＋1");
         } failure:^(NSError *error) {
             NSLog(@"notify_display failed");
         }];
        
    }
    return self;
}

-(void)initWebWiew:(NotifyListModel *)notifyModel
{
    CGRect rect;
    if (IPhone5 || IPhone4)
    {
        rect = CGRectMake( (SCREEN_WIDTH/2)-(520/4), (SCREEN_HEIGHT/2)-(((840*520)/610)/4), 520/2, ((840*520)/610)/2);
    }
    else if (IPhone6 || IPhone7)
    {
        rect = CGRectMake( (SCREEN_WIDTH/2)-(610/4), (SCREEN_HEIGHT/2)-(840/4), 610/2, 840/2);
    }
    else
    {
        rect = CGRectMake( (SCREEN_WIDTH/2)-(1012/6), (SCREEN_HEIGHT/2)-(((840*1012)/610)/6), 1012/3, ((840*1012)/610)/3);
    }
    
    
    UIView  *viewBackground = [[UIView alloc ] initWithFrame:rect];
    [viewBackground setBackgroundColor:[UIColor blackColor] ];
    [viewBackground.layer setMasksToBounds:YES];
    [viewBackground.layer setCornerRadius:10];
    [self addSubview:viewBackground];
    
    if( [Tool urlIsImage:notifyModel.notifyImageUrl] )
    {
        _imageViewActivity = [[UIImageView alloc ] initWithFrame:CGRectMake(0, -0.1, viewBackground.frame.size.width, viewBackground.frame.size.height)];
        [_imageViewActivity sd_setImageWithURL:[NSURL URLWithString:notifyModel.notifyImageUrl] placeholderImage:nil];
        [_imageViewActivity setContentMode: UIViewContentModeScaleAspectFit];
        [_imageViewActivity setUserInteractionEnabled:YES];
        [viewBackground addSubview:_imageViewActivity];
        
        if([notifyModel.imageJumpUrlType intValue] != 2)
        {
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            singleTap.delegate = self;
            singleTap.cancelsTouchesInView = NO;
            [singleTap setNumberOfTapsRequired:1];//点击一次
            [_imageViewActivity addGestureRecognizer:singleTap];
        }
    }
    else
    {
        
        self._webView = [[UIWebView alloc ] initWithFrame:CGRectMake(0, 0, viewBackground.frame.size.width, viewBackground.frame.size.height)];
        self._webView.delegate = self;
        [self._webView setUserInteractionEnabled:YES];
        [self._webView setBackgroundColor:[UIColor whiteColor] ];
        [self._webView scalesPageToFit];
        self._webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self._webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [viewBackground addSubview:self._webView];
        [self._webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:notifyModel.notifyImageUrl] ]];
    }
    
    UIButton *btnClose = [[UIButton alloc ] initWithFrame:CGRectMake(viewBackground.frame.size.width - 33,0, 33, 33)];
    [btnClose setImage:[UIImage imageNamed:@"btn_notifictionClose.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(onButtonClose) forControlEvents:UIControlEventTouchUpInside];
    [viewBackground addSubview:btnClose];
}

#pragma mark - webview
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [FVCustomAlertView hideAlertFromView:self fading:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [FVCustomAlertView hideAlertFromView:self fading:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self withTitle:@"加载中..." withBlur:NO allowTap:YES];
  
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [MobClick event:activityViewbtn3];
    [self onButtonOpenDetail];
}


-(void)initContorlller:(NotifyListModel *)notifyModel
{
    CGRect rect;
    NSInteger imageHeight = 0;
    if (IPhone5 || IPhone4)
    {
        rect = CGRectMake( (SCREEN_WIDTH/2)-(520/4), (SCREEN_HEIGHT/2)-(((840*520)/610)/4), 520/2, ((840*520)/610)/2);
        imageHeight =((366*520)/610)/2;
    }
    else if (IPhone6 || IPhone7)
    {
        rect = CGRectMake( (SCREEN_WIDTH/2)-(610/4), (SCREEN_HEIGHT/2)-(840/4), 610/2, 840/2);
        imageHeight =((366*610)/610)/2;
    }
    else
    {
        rect = CGRectMake( (SCREEN_WIDTH/2)-(1012/6), (SCREEN_HEIGHT/2)-(((840*1012)/610)/6), 1012/3, ((840*1012)/610)/3);
        imageHeight =((366*1012)/610)/2;
    }
    
    UIView  *viewBackground = [[UIView alloc ] initWithFrame:rect];
    [viewBackground setBackgroundColor:[UIColor whiteColor] ];
    [viewBackground.layer setMasksToBounds:YES];
    [viewBackground.layer setCornerRadius:10];
    [self addSubview:viewBackground];
    
    _imageViewActivity = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, viewBackground.frame.size.width, imageHeight)];
    [_imageViewActivity setBackgroundColor:[UIColor grayColor]];
    [_imageViewActivity sd_setImageWithURL:[NSURL URLWithString:notifyModel.notifyImageUrl] placeholderImage:nil];
//    [_imageViewActivity setContentMode:UIViewContentModeScaleAspectFill];
    [viewBackground addSubview:_imageViewActivity];
    
    _labelTitle = [[UILabel alloc ] initWithFrame:CGRectMake(0, _imageViewActivity.frame.origin.y+_imageViewActivity.frame.size.height+20, viewBackground.frame.size.width, 15)];
    [_labelTitle setFont:MKBOLDFONT(15)];
    [_labelTitle setTextAlignment:NSTextAlignmentCenter];
    [_labelTitle setText:notifyModel.title];
    [viewBackground addSubview:_labelTitle];
    
    _labelEndTime = [[UILabel alloc ] initWithFrame:CGRectMake(0, _labelTitle.frame.origin.y+_labelTitle.frame.size.height+7, viewBackground.frame.size.width, 12)];
    [_labelEndTime setFont:MKFONT(12)];
    [_labelEndTime setTextAlignment:NSTextAlignmentCenter];
    int time = [Tool calcSysTimeLength:notifyModel.activityEndTime SysTime:notifyModel.currentTime]/24/60/60;
    [_labelEndTime setText:[NSString stringWithFormat:@"%d天后结束", time]];
    [_labelEndTime setTextColor:RGBA(123, 122, 152, 1)];
    [viewBackground addSubview:_labelEndTime];
    
    UIButton *btnLookDetail = [[UIButton alloc ] initWithFrame:CGRectMake(viewBackground.frame.size.width/2 - 80,viewBackground.frame.size.height-76/2-20, 160, 40)];
    [btnLookDetail setBackgroundColor:RGBA(113, 111, 250, 1)];
    [btnLookDetail setTitle:@"查看详情" forState:UIControlStateNormal];
    [btnLookDetail.titleLabel setFont:MKFONT(15)];
    [btnLookDetail.layer setMasksToBounds:YES];
    [btnLookDetail.layer setCornerRadius:20];
    [btnLookDetail addTarget:self action:@selector(onButtonOpenDetail) forControlEvents:UIControlEventTouchUpInside];
    [viewBackground addSubview:btnLookDetail];
    
    _textViewContent = [[UITextView alloc ] initWithFrame:CGRectMake(10, _labelEndTime.frame.origin.y+_labelEndTime.frame.size.height+10, viewBackground.frame.size.width-20, viewBackground.frame.size.height-_labelEndTime.frame.origin.y-_labelEndTime.frame.size.height-20-10-btnLookDetail.frame.size.height-20 )];
    [_textViewContent setFont:MKFONT(12)];
    [_textViewContent setTextAlignment:NSTextAlignmentLeft];
    [_textViewContent setText:notifyModel.notifyContent];
    [_textViewContent setTextColor:RGBA(51, 51, 51, 1)];
    [_textViewContent setEditable:NO];
    [viewBackground addSubview:_textViewContent];
   
    
    UIButton *btnClose = [[UIButton alloc ] initWithFrame:CGRectMake(viewBackground.frame.size.width - 33,0, 33, 33)];
    [btnClose setImage:[UIImage imageNamed:@"btn_notifictionClose.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(onButtonClose) forControlEvents:UIControlEventTouchUpInside];
    [viewBackground addSubview:btnClose];
    
}


#pragma mark 关闭view
-(void) onButtonClose
{
    [MobClick event:activityViewbtn2];
    if (_notifyModel)
    {
        //修改此通知是否再次显示状态1：以后不再显示
        if( ![sqlDatabase updateNotice:_notifyModel.notifyId  status:_notifyModel.frequencyType ])
        {
            NSLog(@"修改数据库失败！");
        }
    }
    if (self)
    {
        [self removeFromSuperview];
    }
}


#pragma mark 查看详情
-(void) onButtonOpenDetail
{
    [MobClick event:activityViewbtn1];
    /*
    1:活动中心"
    2:卡包页"
    3:钻石-vip特权页（捡便宜）"
    4:成长任务页"
    5:首页"
    6:影片购票页
    7:小卖部”
    8:我的订单”
    9:个人中心
    */
    if([_notifyModel.jumpType intValue] == 2)
    {
        [MobClick event:activityViewbtn4];
        //h5通知
        NotifyH5ViewController* h5ViewController = [[NotifyH5ViewController alloc]init];
        h5ViewController._notifyModel = _notifyModel;
        [_navigationController pushViewController:h5ViewController animated:YES];
    }
    if([_notifyModel.jumpType intValue] == 3)
    {
        //app内界面
        if ([_notifyModel.jumpUrl intValue] == 1)
        {
            NSDictionary* dictTab = @{@"tag":@0};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
            NSDictionary* dictHome = @{@"tag":@3};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
        }
        if ([_notifyModel.jumpUrl intValue] == 2)
        {
            MyCardViewController *myCardPackController = [[MyCardViewController alloc ]init];
            [self.navigationController pushViewController:myCardPackController animated:YES];
        }
        if ([_notifyModel.jumpUrl intValue] == 3)
        {
            NSDictionary* dictTab = @{@"tag":@0};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
            NSDictionary* dictHome = @{@"tag":@1};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
        }
        if ([_notifyModel.jumpUrl intValue] == 4)
        {
           
        }
        if ([_notifyModel.jumpUrl intValue] == 5)
        {
            NSDictionary* dictTab = @{@"tag":@0};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        if ([_notifyModel.jumpUrl intValue] == 6)
        {
    //        NSDictionary* dictTab = @{@"tag":@0};
    //        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
//            NSLog(@"%@",_notifyModel.movieId);
            ShowTimeViewController* showTimeVC = [[ShowTimeViewController alloc]init];
            showTimeVC.hotMovieModel = [[MovieModel alloc ] init];
            showTimeVC.hotMovieModel.movieId = [NSNumber numberWithInt:[_notifyModel.movieId intValue]];
            [self.navigationController pushViewController:showTimeVC animated:YES];
        }
        if ([_notifyModel.jumpUrl intValue] == 7)
        {
            //小卖部
            NSDictionary* dictTab = @{@"tag":@0};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
            
            NSDictionary* dictHome = @{@"tag":@2};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
        }
        if ([_notifyModel.jumpUrl intValue] == 8)
        {
            //我的订单
            MyOrderViewController *myOrderController = [[MyOrderViewController alloc ] init];
            [self.navigationController pushViewController:myOrderController animated:YES];
        }
        if ([_notifyModel.jumpUrl intValue] == 9)
        {
            NSDictionary* dictTab = @{@"tag":@2};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
        }
    }
    
    [self onButtonClose];

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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    switch (navigationType)
    {
        case UIWebViewNavigationTypeLinkClicked://点击链接
        {
            if([[request.URL scheme] isEqualToString:@"movikr"])
            {
                //首页
                if([request.URL.host isEqualToString:@"home"])
                {
                    //修改此通知是否再次显示状态1：以后不再显示
                    if( ![sqlDatabase updateNotice:_notifyModel.notifyId  status:_notifyModel.frequencyType ])
                    {
                        NSLog(@"修改数据库失败！");
                    }
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [self removeFromSuperview];
                }
                if([request.URL.host isEqualToString:@"st"])
                {
                    MovieModel *movieModel = [[MovieModel alloc] init];
                    movieModel.movieId = [NSNumber numberWithInt:[_notifyModel.movieId intValue]];
                    ShowTimeViewController* showTimeVC = [[ShowTimeViewController alloc]init];
                    showTimeVC.hotMovieModel = movieModel;
                    [self.navigationController pushViewController:showTimeVC animated:YES];
                }
                if([request.URL.host isEqualToString:@"goods"])
                {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    NSDictionary* dictTab = @{@"tag":@0};
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
                    NSDictionary* dictHome = @{@"tag":@2};
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
                    [self removeFromSuperview];
                }
                if([request.URL.host isEqualToString:@"act"])
                {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    NSDictionary* dictTab = @{@"tag":@0};
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
                    NSDictionary* dictHome = @{@"tag":@3};
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
                    [self removeFromSuperview];
                }
                if([request.URL.host isEqualToString:@"vip"])
                {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    NSDictionary* dictTab = @{@"tag":@0};
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
                    NSDictionary* dictHome = @{@"tag":@1};
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
                    [self removeFromSuperview];
                }
                if([request.URL.host isEqualToString:@"icard"])
                {
                    MyCardViewController *myCardController = [[MyCardViewController alloc ] init];
                    [self.navigationController pushViewController:myCardController animated:YES];
                }
                if([request.URL.host isEqualToString:@"iorder"])
                {
                    MyOrderViewController *myOrderController = [[MyOrderViewController alloc ] init];
                    [self.navigationController pushViewController:myOrderController animated:YES];
                }
                if([request.URL.host isEqualToString:@"u"])
                {
                    
                }
            }
        }
        default:
            break;
    }
    return TRUE;
}


@end
