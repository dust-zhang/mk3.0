//
//  UserCenterViewController.m
//  supercinema
//
//  Created by mapollo91 on 29/7/16.
//
//

#import "UserCenterViewController.h"
#import "GlobalSearchViewController.h"
#import "CinemaSearchViewController.h"

@interface UserCenterViewController ()

@end

@implementation UserCenterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ServicesSystem  getSystemConfig:[Config getDeviceToken] clientId:[Config getGeTuiId] model:^(RequestResult *model)
     {
         
     } failure:^(NSError *error) {
         
     }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    //电池条变为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    if ( [Config getLoginState ] )
    {
        [Tool showTabBar];
        [self refreshUserCenter];
    }
    else
    {
        _userUnReadDataModel = nil;
        [self setControllerText];
    }
    
    if( [Config getLoginState])
    {
        [MkPullMessage showPushMessage:self.navigationController triggerType:OPEN_USER_CENTER apnsModel:nil typeTime:@"userCenterTime"];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(255, 255, 255, 1);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearNotiCount) name:NOTIFITION_USERCENTERSOCIALCOUNT object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUserCenter) name:NOTIFITION_USERCENTER object:nil];

    [self initCtrl];
    [self refreshUserCenter];
}

//刷新个人中心页面
-(void)refreshUserCenter
{
    if( [Config getLoginState] )
    {
        [self loadUserInfo];
        [self loadUnReadDataCount];
    }
}

#pragma mark 加载未读数据
-(void) loadUnReadDataCount
{
    [ServicesUser getUserCenterUnReadDataCount:nil model:^(UserUnReadDataModel *model)
    {
         _userUnReadDataModel = model;
         [self setControllerText];
         
     } failure:^(NSError *error) {
         
     }];
}

-(void)clearNotiCount
{
    [_labelNotice setHidden:YES];
}

-(void) setControllerText
{
    if ([_userUnReadDataModel.unpaidOrderCount intValue] > 0)
    {
        [_labelUnPayOrder setHidden:NO];
        [_labelUnPayOrder setText:[NSString stringWithFormat:@"%@笔待支付",_userUnReadDataModel.unpaidOrderCount] ];
    }
    else
    {
         [_labelUnPayOrder setHidden:YES];
    }
    
    if ([_userUnReadDataModel.unreadNoticeCount intValue] > 0)
    {
        [_labelNotice setHidden:NO];
        [_labelNotice setText:[NSString stringWithFormat:@"%@个新通知",_userUnReadDataModel.unreadNoticeCount] ];
    }
    else
    {
        [_labelNotice setHidden:YES];
    }
    
    NSLog(@"%d",[_userUnReadDataModel.wantSeeMovieCount intValue]);
    [_labelNumber[0] setText:[NSString stringWithFormat:@"%d",[_userUnReadDataModel.followUserCount intValue]]];
    [_labelNumber[1] setText:[NSString stringWithFormat:@"%d",[_userUnReadDataModel.fansCount intValue]]];
    [_labelNumber[2] setText:[NSString stringWithFormat:@"%d",[_userUnReadDataModel.wantSeeMovieCount intValue]]];
    [_labelNumber[3] setText:[NSString stringWithFormat:@"%d",[_userUnReadDataModel.reviewCount intValue]]];
    
    if( [Config getLoginState] )
    {
        [_btnLogin setHidden:YES];
        [_labelUserName setHidden:NO];
    }
    else
    {
        //未登录
        [_imageSex setHidden:YES];
        [_btnLogin setHidden:NO];
        [_labelUserName setHidden:YES];
        [_imageUserIcon setImage:[UIImage imageNamed:@"image_unLoginHead.png"] forState:UIControlStateNormal ];
        [_imageTopBG setImage:[UIImage imageNamed:@"image_userCenterTopBG.png"]];
        [_labelUserSignature setText:@"点击我就可以编写签名了哦~"];
    }
  
  
}

#pragma mark 加载用户信息
-(void) loadUserInfo
{
    [ServicesUser getMyInfo:@"" model:^(UserModel *userModel)
    {
        [Config saveUserHeadImage:userModel.portrait_url];
        
        _userModel = userModel;
        if([userModel.signature length] <= 0)
        {
            [_labelUserSignature setText:@"点击我就可以编写签名了哦~"];
        }
        else
        {
            [_labelUserSignature setText:userModel.signature];
        }
        
        [_labelUserName setText:userModel.nickname];
        [Config saveUserNickName:userModel.nickname];
        [Tool setLabelSpacing:_labelUserName spacing:2 alignment:NSTextAlignmentLeft];
        _labelUserName.frame = CGRectMake((SCREEN_WIDTH-_labelUserName.frame.size.width)/2, _imageUserIcon.frame.origin.y+_imageUserIcon.frame.size.height+14, _labelUserName.frame.size.width, 15);
        
        _imageSex.frame = CGRectMake(_labelUserName.frame.origin.x+_labelUserName.frame.size.width+9.5, _labelUserName.frame.origin.y+1, 13, 13);
        
        if([userModel.portrait_url length] > 0)
        {
            [_imageUserIcon sd_setImageWithURL:[NSURL URLWithString:[Tool urlIsNull:userModel.portrait_url]] forState:UIControlStateNormal];
        }
        else
        {
            [_imageUserIcon setImage:[UIImage imageNamed:@"image_defaultHead1.png"] forState:UIControlStateNormal ];
        }
        
        if ( [userModel.gender intValue] == 0)
        {
            [_imageSex setHidden:YES];
        }
        if ( [userModel.gender intValue] == 1)
        {
            [_imageSex setImage:[UIImage imageNamed:@"image_men.png"]];
            [_imageSex setHidden:NO];
        }
        if ( [userModel.gender intValue] == 2)
        {
            [_imageSex setImage:[UIImage imageNamed:@"image_women.png"]];
            [_imageSex setHidden:NO];
        }
        
        for (int i = 0 ; i < [userModel.settingList count]; i++)
        {
            SettingListModel *model = userModel.settingList[i];
            if ([model.settingType  intValue] == 1)
            {
//                [_imageTopBG sd_setImageWithURL:[NSURL URLWithString:model.settingValue] placeholderImage:[UIImage imageNamed:@"image_userCenterTopBG.png"]];
                [Tool downloadImage:model.settingValue button:nil imageView:_imageTopBG defaultImage:@"image_userCenterTopBG.png"];
                return ;
            }
        }
        
    } failure:^(NSError *error) {
//        [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
        if (error.code == -101)
        {
            [Config deleteUserLoactionData];
            [_btnLogin setHidden:NO];
        }
        else
        {
            [Tool showWarningTip:error.domain time:1];
        }
    }];
}

-(void) showLoginView
{
    LoginViewController *loginController = [[LoginViewController alloc ] init];
    [self.navigationController pushViewController:loginController animated:NO];
}

//渲染UI
-(void)initCtrl
{
    //顶部背景
    _imageTopBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];//416.5
    [_imageTopBG setImage:[UIImage imageNamed:@"image_userCenterTopBG.png"]];
    [self.view addSubview:_imageTopBG];
    
    //蒙层
    _viewHazy = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
    [_viewHazy setBackgroundColor:RGBA(0, 0, 0, 0.6)];
    [self.view addSubview:_viewHazy];
    
    //顶部View
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [_topView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_topView];
    
    //整体ScrollView
    _scrollViewUserSet = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-50-20)];
    _scrollViewUserSet.delegate = self;
    [_scrollViewUserSet setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollViewUserSet];

    //签名View背景
    _userSignature = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    _userSignature.backgroundColor = [UIColor clearColor];
    [_scrollViewUserSet addSubview:_userSignature];
    
    //签名
    _labelUserSignature = [[UILabel alloc ] initWithFrame:CGRectMake((SCREEN_WIDTH-260)/2, (_userSignature.frame.size.height-45)/2, 260, 45)];
    [_labelUserSignature setBackgroundColor:[UIColor clearColor]];
    [_labelUserSignature setTextColor:RGBA(255, 255, 255, 1)];
    [_labelUserSignature setShadowColor:RGBA(0, 0, 0, 0.4)];//投影颜色
    [_labelUserSignature setShadowOffset:CGSizeMake(0, 1)];//投影的偏移
    [_labelUserSignature setFont:MKFONT(17)];
    _labelUserSignature.numberOfLines = 0;
    [_labelUserSignature setLineBreakMode:NSLineBreakByCharWrapping];
    [_labelUserSignature setTextAlignment:NSTextAlignmentCenter];
    [_labelUserSignature setText:@"点击我就可以编写签名了哦~"];
    [_userSignature addSubview:_labelUserSignature];
    
    //签名:添加点击事件
    UITapGestureRecognizer *tapSingle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSingleTextSignature:)];
    [tapSingle setNumberOfTapsRequired:1];//点击一次
    tapSingle.cancelsTouchesInView = NO;
    [_userSignature addGestureRecognizer:tapSingle];
    
    //白色弧线背景
    _imageCurveBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 280-65-15, SCREEN_WIDTH, 87)];
    [_imageCurveBG setUserInteractionEnabled:YES];
    [_imageCurveBG setImage:[UIImage imageNamed:@"image_curveBG.png"]];
    _imageCurveBG.backgroundColor = [UIColor clearColor];
    [_scrollViewUserSet addSubview:_imageCurveBG];
    
    //用户头像
    _imageUserIcon = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-65)/2, _imageCurveBG.frame.origin.y-(65/2), 65, 65)];
    [_imageUserIcon setBackgroundColor:[UIColor clearColor]];
    [_imageUserIcon setContentMode:UIViewContentModeScaleAspectFill];//图片内容填满
    [_imageUserIcon.layer setMasksToBounds:YES];
    [_imageUserIcon setImage:[UIImage imageNamed:@"image_unLoginHead.png"] forState:UIControlStateNormal ];
    [_imageUserIcon.layer setCornerRadius:65/2];
    _imageUserIcon.layer.borderWidth = 0.5;//边框宽度
    _imageUserIcon.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];//边框颜色
    [_scrollViewUserSet addSubview:_imageUserIcon];
    [_imageUserIcon addTarget:self action:@selector(onButtonShowBigHeadImage) forControlEvents:UIControlEventTouchUpInside];
    
    //点击登录
    _btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, _imageUserIcon.frame.origin.y+_imageUserIcon.frame.size.height+14, SCREEN_WIDTH, 15)];
    [_btnLogin setBackgroundColor:[UIColor clearColor]];
    [_btnLogin setTitle:@"点击登录" forState:UIControlStateNormal];
    [_btnLogin setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
    [_btnLogin addTarget:self action:@selector(onButtonLogin) forControlEvents:UIControlEventTouchUpInside];
    [_btnLogin.titleLabel setFont:MKFONT(15)];
    _btnLogin.hidden = YES;
    [_scrollViewUserSet addSubview:_btnLogin];

    //用户昵称
    _labelUserName = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, _imageUserIcon.frame.origin.y+_imageUserIcon.frame.size.height+14, 40, 15)];
    [_labelUserName setBackgroundColor:[UIColor clearColor]];
    [_labelUserName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelUserName setFont:MKFONT(15)];
    [_scrollViewUserSet addSubview:_labelUserName];
    
    //用户性别
    _imageSex = [[UIImageView alloc] initWithFrame:CGRectMake(_labelUserName.frame.origin.x+_labelUserName.frame.size.width+9.5, _labelUserName.frame.origin.y+1, 13, 13)];
    [_scrollViewUserSet addSubview:_imageSex];
    [_imageSex setHidden:YES];
    //关注；粉丝；想看；看过
    _viewUserBtnsBG = [[UIView alloc] initWithFrame: CGRectMake(0, _imageCurveBG.frame.origin.y+_imageCurveBG.frame.size.height, SCREEN_WIDTH, 61)];
    [_viewUserBtnsBG setBackgroundColor:[UIColor whiteColor]];
    [_scrollViewUserSet addSubview:_viewUserBtnsBG];
    
    NSArray *arryUserBtnsName = @[@"关注",@"粉丝",@"想看",@"短评"];
    for (int i = 0; i < 4; i++)
    {
        //点击按钮
        UIButton *btnAboutInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAboutInfo.frame = CGRectMake(((SCREEN_WIDTH - 1)/4)*i, 0, (SCREEN_WIDTH - 1)/4, 60);
        [btnAboutInfo setBackgroundColor:[UIColor clearColor]];
        btnAboutInfo.tag = 1000 + i;
        [btnAboutInfo addTarget:self action:@selector(onButtonAboutInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        //按钮上的个数
        _labelNumber[i] = [[UILabel alloc] initWithFrame:CGRectMake(((SCREEN_WIDTH - 1)/4)*i, 7, (SCREEN_WIDTH - 1)/4, 17)];
        [_labelNumber[i] setBackgroundColor:[UIColor clearColor]];
        [_labelNumber[i] setText:@"0"];
        [_labelNumber[i] setTextAlignment:NSTextAlignmentCenter];
        [_labelNumber[i] setTextColor:RGBA(51, 51, 51, 1)];
        [_labelNumber[i] setFont:MKFONT(17)];
        
        //按钮上的文字
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(((SCREEN_WIDTH - 1)/4)*i, _labelNumber[i].frame.origin.y+_labelNumber[i].frame.size.height+12, (SCREEN_WIDTH - 1)/4, 14)];
        [labelName setBackgroundColor:[UIColor clearColor]];
        [labelName setText:arryUserBtnsName[i]];
        [labelName setTextAlignment:NSTextAlignmentCenter];
        [labelName setTextColor:RGBA(123, 122, 152, 1)];
        [labelName setFont:MKFONT(14)];
        
        //纵向分割线
        UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(((SCREEN_WIDTH - 1)/4)*i-1, 18, 0.5, 25)];
        [labelLine setBackgroundColor:RGBA(206, 207, 208, 1)];
        
        [_viewUserBtnsBG addSubview:btnAboutInfo];
        [_viewUserBtnsBG addSubview:_labelNumber[i]];
        [_viewUserBtnsBG addSubview:labelName];
        [_viewUserBtnsBG addSubview:labelLine];
    }
    
    //功能背景
    _viewFunctionBG = [[UIView alloc] initWithFrame: CGRectMake(0, _viewUserBtnsBG.frame.origin.y+_viewUserBtnsBG.frame.size.height, SCREEN_WIDTH, 2000)];//420（设置成2000，目的是拉底不露白边）
    [_viewFunctionBG setBackgroundColor:RGBA(246, 246, 251, 1)];
    [_scrollViewUserSet addSubview:_viewFunctionBG];
    
    NSArray *arrFunctionList = @[
                         @[@[@"image_myOrder.png",@"我的订单",@0],@[@"image_myCard.png",@"我的卡包",@1],@[@"image_activation.png",@"激活码",@2],@[@"image_myDynamics.png",@"我的动态",@3]],
                         @[@[@"image_notice.png",@"通知",@4],@[@"image_settings.png",@"设置",@5],@[@"image_myShare.png",@"分享超级电影院",@6]]
                         ];
    float fListTop = 348;
    for (int j=0; j<arrFunctionList.count; j++)
    {
        NSArray *arrListj = arrFunctionList[j];
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, fListTop, SCREEN_WIDTH, arrListj.count*50+10)];
        for(int i=0; i<arrListj.count; i++)
        {
            UIButton *btnCell = [self onButtonCellList:arrListj[i][0] title:arrListj[i][1] btnTop:i*50];
            
            //分割线
            UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelLine setBackgroundColor:RGBA(242, 242, 242, 1)];
            [btnCell addSubview:labelLine];
            
            if ((j == 0 && i == 3) || (j == 1 && i == 1))
            {
                labelLine.frame = CGRectMake(0, 49, SCREEN_WIDTH, 0.5);
            }
            else
            {
                labelLine.frame = CGRectMake(15, 49, SCREEN_WIDTH-15, 0.5);
            }
            
            btnCell.tag = [[NSString stringWithFormat:@"%@", arrListj[i][2]] intValue];
            
            [btnCell addTarget:self action:@selector(onButtonFunctionCell:) forControlEvents:UIControlEventTouchUpInside];
            [viewCell addSubview:btnCell];
        }

        [_scrollViewUserSet addSubview:viewCell];
        //改变单元格区域之间的间距
        fListTop += arrListj.count*50+10;
    }
    [_scrollViewUserSet setContentSize:CGSizeMake(SCREEN_WIDTH, fListTop+30)];
    
    //未支付订单数量
    _labelUnPayOrder = [[UILabel alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 363, 80, 20)];
    [_labelUnPayOrder setBackgroundColor:RGBA(249, 81, 81, 1)];
    [_labelUnPayOrder setTextColor:[UIColor whiteColor]];
    [_labelUnPayOrder setTextAlignment:NSTextAlignmentCenter];
    [_labelUnPayOrder setFont:MKBOLDFONT(10)];
    [_labelUnPayOrder.layer setMasksToBounds:YES];
    [_labelUnPayOrder.layer setCornerRadius:10];
    [_scrollViewUserSet addSubview:_labelUnPayOrder];
    [_labelUnPayOrder setHidden:YES];
    
    //通知数量
    _labelNotice = [[UILabel alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 573, 80, 20)];
    [_labelNotice setBackgroundColor:RGBA(249, 81, 81, 1)];
    [_labelNotice setTextColor:[UIColor whiteColor]];
    [_labelNotice setTextAlignment:NSTextAlignmentCenter];
    [_labelNotice setFont:MKBOLDFONT(10)];
    [_labelNotice.layer setMasksToBounds:YES];
    [_labelNotice.layer setCornerRadius:10];
    [_scrollViewUserSet addSubview:_labelNotice];
    [_labelNotice setHidden:YES];
    
    //分享有奖
    _labelMyShare = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 676, 80, 14)];
    [_labelMyShare setBackgroundColor:[UIColor clearColor]];
    [_labelMyShare setTextColor:RGBA(249, 81, 81, 1)];
    [_labelMyShare setTextAlignment:NSTextAlignmentRight];
    [_labelMyShare setFont:MKFONT(14)];
    [_labelMyShare setText:[Config getConfigInfo:@"userHomeShareTipText"]];
    [_scrollViewUserSet addSubview:_labelMyShare]; 
}

//点击登录
-(void)onButtonLogin
{
    LoginViewController *loginViewController = [[LoginViewController alloc ] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

//按钮对象
-(UIButton *)onButtonCellList:(NSString *)icon title:(NSString *)title btnTop:(float)btnTop
{
    UIButton *btnView = [[UIButton alloc] initWithFrame:CGRectMake(0, btnTop, SCREEN_WIDTH, 50)];
    [btnView setBackgroundImage:[ImageOperation imageWithColor:RGBA(0, 0, 0,0.2) size:CGSizeMake(34, 34)] forState:UIControlStateHighlighted];
    [btnView setBackgroundColor:RGBA(255, 255, 255, 1)];
    
    //图标
    UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15 , 14, 22, 22)];
    imageIcon.backgroundColor = [UIColor clearColor];
    [imageIcon.layer setCornerRadius:22/2];
    [imageIcon setImage:[UIImage imageNamed:icon]];
    [btnView addSubview:imageIcon];
    
    //标题
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(52 , 17.5, SCREEN_WIDTH-100, 15)];
    [labelTitle setText:title];
    [labelTitle setTextColor:RGBA(51, 51, 51, 1)];
    [labelTitle setFont:MKFONT(15)];
    [btnView addSubview:labelTitle];
    
    //指示箭头
    UIImageView *imageArrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-7.5, 18.5, 7.5, 13)];
    [imageArrow setImage:[UIImage imageNamed:@"btn_rightArrow.png"]];
    [btnView addSubview:imageArrow];

    
    return btnView;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat fContentOffsetY = scrollView.contentOffset.y;
    if(fContentOffsetY<0)
    {
        CGRect rectFrame = _imageTopBG.frame;
        rectFrame.origin.x= fContentOffsetY;
        rectFrame.origin.y= fContentOffsetY;
        rectFrame.size.width= SCREEN_WIDTH-fContentOffsetY;
        rectFrame.size.height = 280-fContentOffsetY;
        _imageTopBG.frame = rectFrame;
        _imageTopBG.center = CGPointMake(SCREEN_WIDTH/2,280/2);
        _viewHazy.frame = rectFrame;
        _viewHazy.center = CGPointMake(SCREEN_WIDTH/2,280/2);
    }
}

//*关注；粉丝；想看；看过*点击事件
-(void)onButtonAboutInfo:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 1000:
        {
            [MobClick event:myCenterViewbtn5];
            if ( ![Config getLoginState ] )
            {
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [self showLoginController:param controllerName:@"MyAttentionViewController"];
            }
            else
            {
                MyAttentionViewController *myAttentionController = [[MyAttentionViewController alloc ] init];
                myAttentionController._attentionCount = _userUnReadDataModel.followUserCount;
                [self.navigationController pushViewController:myAttentionController animated:YES];
            }
        }
            break;
        case 1001:
        {
            [MobClick event:myCenterViewbtn10];
            if ( ![Config getLoginState ] )
            {
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [self showLoginController:param controllerName:@"MyFansViewController"];
            }
            else
            {
                MyFansViewController *myFansController = [[MyFansViewController alloc ] init];
                myFansController._fansCount = _userUnReadDataModel.fansCount;
                myFansController._userId = [Config getUserId];
                [self.navigationController pushViewController:myFansController animated:YES];
            }
        }
            break;
        case 1002:
        {
            [MobClick event:myCenterViewbtn16];
            if ( ![Config getLoginState ] )
            {
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [self showLoginController:param controllerName:@"WantLookViewController"];
            }
            else
            {
                WantLookViewController *wantLookController = [[WantLookViewController alloc ] init];
                wantLookController._userId = [Config getUserId];
                [self.navigationController pushViewController:wantLookController animated:YES];
            }
        }
            break;
        case 1003:
        {
            [MobClick event:myCenterViewbtn19];
            if ( ![Config getLoginState ] )
            {
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [self showLoginController:param controllerName:@"MovieReviewViewController"];
            }
            else
            {
                MovieReviewViewController *movieReviewController = [[MovieReviewViewController alloc] init];
                movieReviewController._userId = [Config getUserId];
                [self.navigationController pushViewController:movieReviewController animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

//点击进行签名
-(void)tapSingleTextSignature:(UITapGestureRecognizer *)sender
{
    [MobClick event:myCenterViewbtn2];
    if ( ![Config getLoginState ] )
    {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [self showLoginController:param controllerName:@"UserCenterViewController"];
    }
    else
    {
        ModifySignViewController *modifySignController = [[ModifySignViewController alloc ] init];
        modifySignController._strSign = _userModel.signature;
        [self.navigationController pushViewController:modifySignController animated:YES];
    }
}

//按钮点击事件
-(void)onButtonFunctionCell:(BFPaperButton *)sender
{
    switch (sender.tag)
    {
        case 0:
        {
            [MobClick event:myCenterViewbtn22];
            if (![Config getLoginState ])
            {
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [self showLoginController:param controllerName:@"MyOrderViewController"];
            }
            else
            {
                //我的订单
                MyOrderViewController *myOrderController = [[MyOrderViewController alloc ] init];
                [self.navigationController pushViewController:myOrderController animated:YES];
            }
            
        }
            break;
        case 1:
        {
            [MobClick event:myCenterViewbtn29];
            if (![Config getLoginState ])
            {
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [self showLoginController:param controllerName:@"MyCardViewController"];
            }
            else
            {
                //我的卡包
                MyCardViewController *myCardViewController = [[MyCardViewController alloc ] init];
                [self.navigationController pushViewController:myCardViewController animated:YES];
            }
           
        }
            break;
        case 2:
        {
            [MobClick event:myCenterViewbtn43];
            if (![Config getLoginState ])
            {
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [param setObject:[Config getConfigInfo:@"tongPiaoExchangeUrl"] forKey:@"_url"];
                [self showLoginController:param controllerName:@"ExchangeVoucherViewController"];
            }
            else
            {
                //激活码
                [self toExchangeVoucher];
            }
        }
            break;
        case 3:
        {
            [MobClick event:myCenterViewbtn47];
            if (![Config getLoginState ])
            {
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [self showLoginController:param controllerName:@"MyDynamicViewController"];
            }
            else
            {
                //我的动态
                MyDynamicViewController* dyn = [[MyDynamicViewController alloc]init];
                [self.navigationController pushViewController:dyn animated:YES];
            }
        }
            break;
        case 4:
        {
            [MobClick event:myCenterViewbtn55];
            if (![Config getLoginState ])
            {
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [self showLoginController:param controllerName:@"NotifiViewController"];
            }
            else
            {
                //通知
                NotifiViewController* noti = [[NotifiViewController alloc]init];
                [self.navigationController pushViewController:noti animated:YES];
            }
        }
            break;
        case 5:
        {
            [MobClick event:myCenterViewbtn62];
            if (![Config getLoginState ])
            {
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [self showLoginController:param controllerName:@"SettingsViewController"];
            }
            else
            {
                //设置
                SettingsViewController *settingsController = [[SettingsViewController alloc] init];
                [self.navigationController pushViewController:settingsController animated:YES];
            }
        }
            break;
        case 6:
        {
            if (![Config getLoginState ])
            {
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [self showLoginController:param controllerName:@"ShareCinemaViewController"];
            }
            else
            {
                //分享超级电影院
                ShareCinemaViewController* share = [[ShareCinemaViewController alloc]init];
                [self.navigationController pushViewController:share animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

-(void)showLoginController:(NSMutableDictionary *)param controllerName:(NSString *)name
{
    LoginViewController *loginControlller = [[LoginViewController alloc ] init];
    loginControlller.param = param;
    loginControlller._strTopViewName = name;
    [self.navigationController pushViewController:loginControlller animated:YES];
}

-(void)toExchangeVoucher
{
     ExchangeVoucherViewController *exchangeVoucherVC = [[ExchangeVoucherViewController alloc] init];
     exchangeVoucherVC._url = [NSURL URLWithString:[Tool stringH5UrlExchangeVoucheTime:[Config getConfigInfo:@"tongPiaoExchangeUrl"] systime:[Tool getSystemTime]]];
     [self.navigationController pushViewController:exchangeVoucherVC animated:YES];
}

-(void)onButtonShowBigHeadImage
{
    if ([Config getLoginState])
    {
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        _viewBigHead = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_viewBigHead setBackgroundColor:[UIColor blackColor]];
        [window addSubview:_viewBigHead];
        
        _imageViewBigHead = [[UIImageView alloc ] initWithFrame:window.frame];
        [_imageViewBigHead setBackgroundColor:[UIColor clearColor]];
        [_imageViewBigHead setContentMode:UIViewContentModeScaleAspectFit];
        [_viewBigHead addSubview:_imageViewBigHead];
        [_imageViewBigHead sd_setImageWithURL:[NSURL URLWithString:_userModel.portraitUrlOfBig] placeholderImage:[UIImage imageNamed:@"image_defaultHead1"]];
        _imageViewBigHead.alpha=0;
        _imageViewBigHead.transform = CGAffineTransformMakeScale(0.2, 0.2);
        [_imageViewBigHead setUserInteractionEnabled:YES];
        [_imageViewBigHead setMultipleTouchEnabled:YES];
        [self addGestureRecognizerToView:_imageViewBigHead];
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             _imageViewBigHead.transform = CGAffineTransformMakeScale(1, 1);
                             _imageViewBigHead.alpha=1;
                             _oldFrame = _imageViewBigHead.frame;
                             _largeFrame = CGRectMake(0 - SCREEN_WIDTH, 0 - SCREEN_HEIGHT, 3 * _oldFrame.size.width, 3 * _oldFrame.size.height);
                             
                         }completion:^(BOOL finish){
                         }];

    }
}

-(void) onButtonHideHeadImage
{
    [UIView animateWithDuration:0.2 animations:^{
        _viewBigHead.transform = CGAffineTransformMakeScale(0.2, 0.2);
        _viewBigHead.alpha = 0;
    } completion:^(BOOL finished) {
        [_viewBigHead removeFromSuperview];
        _viewBigHead = nil;
    }];
}

// 添加所有的手势
- (void) addGestureRecognizerToView:(UIView *)view
{
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    //点击收拾
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onButtonHideHeadImage)];
    [view addGestureRecognizer:tapGestureRecognizer];
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        if (view.frame.size.width < _oldFrame.size.width)
        {
            view.frame = _oldFrame;
            //让图片无法缩得比原图小
        }
        if (view.frame.size.width > 3 * _oldFrame.size.width)
        {
            view.frame = _largeFrame;
        }
        pinchGestureRecognizer.scale = 1;
    }
}

-(void)onButtonRemind
{
    CinemaSearchViewController *globalSearchController = [[CinemaSearchViewController alloc ] init];
    [self.navigationController pushViewController:globalSearchController animated:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_USERCENTERSOCIALCOUNT];
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_USERCENTER];
}


@end

