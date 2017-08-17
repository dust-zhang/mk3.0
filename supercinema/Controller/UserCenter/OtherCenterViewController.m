//
//  OtherCenterViewController.m
//  supercinema
//
//  Created by mapollo91 on 8/12/16.
//
//

#import "OtherCenterViewController.h"
#import "GlobalSearchViewController.h"
#import "CinemaSearchViewController.h"
#import "MovieReviewViewController.h"

@interface OtherCenterViewController ()

@end

@implementation OtherCenterViewController


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //电池条变为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    if ([Config getLoginState ])
    {
        [self loadUserInfo];
        [self loadUnReadDataCount];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(255, 255, 255, 1);
    _pageIndex = @"1";
    _muArrType = [[NSMutableArray alloc]init];
    [self loadDynData];
    [self initCtrl];
}

#pragma mark 加载未读数据
-(void)loadUnReadDataCount
{
    __weak OtherCenterViewController *weakself = self;
    [ServicesUser getUserCenterUnReadDataCount:[NSNumber numberWithInt:[self._strUserId intValue]] model:^(UserUnReadDataModel *model)
     {
         _userUnReadDataModel = model;
         [weakself setControllerText];
         
     } failure:^(NSError *error) {
         
     }];
}

-(void)setControllerText
{
    if (_userUnReadDataModel != nil)
    {
        [_labelNumber[0] setText:[NSString stringWithFormat:@"%@",_userUnReadDataModel.followUserCount]];
        [_labelNumber[1] setText:[NSString stringWithFormat:@"%@",_userUnReadDataModel.fansCount]];
        [_labelNumber[2] setText:[NSString stringWithFormat:@"%@",_userUnReadDataModel.wantSeeMovieCount]];
        [_labelNumber[3] setText:[NSString stringWithFormat:@"%@",_userUnReadDataModel.reviewCount]];
        
        if ([_userUnReadDataModel.followPersonRelation intValue] == 1)
        {
            [_btnFocus setTitle:@"已关注" forState:UIControlStateNormal];
            [_btnFocus setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];//按钮文字颜色
            [_btnFocus setBackgroundColor:[UIColor whiteColor]];
            _btnFocus.layer.borderColor = [RGBA(123, 122, 152, 1) CGColor];
            
            _btnFocus.tag = 1;
        }
        else if ([_userUnReadDataModel.followPersonRelation intValue] == 2)
        {
            [_btnFocus setTitle:@"关注" forState:UIControlStateNormal];
            [_btnFocus setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
            [_btnFocus setBackgroundColor:RGBA(117, 112, 255, 1)];
            _btnFocus.layer.borderColor = [[UIColor clearColor] CGColor];
            
            _btnFocus.tag = 2;
        }
        else if ([_userUnReadDataModel.followPersonRelation intValue] == 3)
        {
            [_btnFocus setTitle:@"互相关注" forState:UIControlStateNormal];
            [_btnFocus setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];//按钮文字颜色
            [_btnFocus setBackgroundColor:[UIColor whiteColor]];
            _btnFocus.layer.borderColor = [RGBA(123, 122, 152, 1) CGColor];
            
            _btnFocus.tag = 3;
        }
        else
        {
            _btnFocus.tag = 0;
            _btnFocus.hidden = YES;
        }
        
        [_imageSex setHidden:NO];
        [_labelUserName setHidden:NO];
    }
    else
    {
        [_labelNumber[0] setText:@"0"];
        [_labelNumber[1] setText:@"0"];
        [_labelNumber[2] setText:@"0"];
        [_labelNumber[3] setText:@"0"];
        [_labelUserSignature setText:@"目前还没签名~好懒哦~"];
        [_imageUserIcon setImage:[UIImage imageNamed:@"image_defaultHead1.png"] forState:UIControlStateNormal ];
        [_imageSex setHidden:YES];
        [_labelUserName setHidden:YES];
    }
}

#pragma mark 弹出登录view
-(void) showLoginController
{
    LoginViewController *loginControlller = [[LoginViewController alloc ] init];
    [self.navigationController pushViewController:loginControlller animated:YES];
}

#pragma mark 加载用户信息
-(void) loadUserInfo
{
    [ServicesUser getMyInfo:self._strUserId model:^(UserModel *userModel)
    {
         _userModel = userModel;
         
         //用户签名
         if([userModel.signature length] <= 0)
         {
             [_labelUserSignature setText:@"目前还没签名~好懒哦~"];
         }
         else
         {
             [_labelUserSignature setText:userModel.signature];
         }
        
         //用户昵称
         [_labelUserName setText:userModel.nickname];
         [_labelTopTitle setText:_userModel.nickname];
        
         [Tool setLabelSpacing:_labelUserName spacing:2 alignment:NSTextAlignmentLeft];
         _labelUserName.frame = CGRectMake((SCREEN_WIDTH-_labelUserName.frame.size.width)/2, _imageUserIcon.frame.origin.y+_imageUserIcon.frame.size.height+14, _labelUserName.frame.size.width, 15);
         
         //用户性别
        _imageSex.frame = CGRectMake(_labelUserName.frame.origin.x+_labelUserName.frame.size.width+9.5, _labelUserName.frame.origin.y+1, 13, 13);
        
        if([userModel.portrait_url length] > 0)
        {
            [_imageUserIcon sd_setImageWithURL:[NSURL URLWithString:[Tool urlIsNull:userModel.portrait_url]] forState:UIControlStateNormal];
        }
        
         if ( [userModel.gender intValue] == 1)
         {
             [_imageSex setImage:[UIImage imageNamed:@"image_men.png"]];
         }
         else
         {
             [_imageSex setImage:[UIImage imageNamed:@"image_women.png"]];
         }
        
         for (int i = 0 ; i < [userModel.settingList count]; i++)
         {
             SettingListModel *model = userModel.settingList[i];
             if ([model.settingType  intValue] == 1)
             {
//                 [_imageTopBG sd_setImageWithURL:[NSURL URLWithString:model.settingValue] placeholderImage:[UIImage imageNamed:@"image_userCenterTopBG.png"]];
                 [Tool downloadImage:model.settingValue button:nil imageView:_imageTopBG defaultImage:@"image_userCenterTopBG.png"];
                 
                 return ;
             }
         }
         
     } failure:^(NSError *error) {
         //        [Tool showWarningTip:error.domain time:1];
     }];
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
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [_topView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_topView];

    //顶部标题
    _labelTopTitle = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2, 30, 180, 17)];//23+15;SCREEN_WIDTH-(23+15)*2
    [_labelTopTitle setBackgroundColor:[UIColor clearColor]];
    [_labelTopTitle setTextColor:RGBA(51, 51, 51, 0)];
    [_labelTopTitle setTextAlignment:NSTextAlignmentCenter];
    [_labelTopTitle setFont:MKFONT(17)];
    [self.view addSubview:_labelTopTitle];
    
    //顶部描边
    _labelTopLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5)];
    [_labelTopLine setBackgroundColor:RGBA(0, 0, 0, 0)];
    [self.view addSubview:_labelTopLine];
    
    //返回按钮
    _btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 23, 82/2, 30)];
    [_btnBack setImage:[UIImage imageNamed:@"btn_backWhite.png"] forState:UIControlStateNormal];
    [_btnBack addTarget:self action:@selector(onButtonBack) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_btnBack];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    //签名View背景
    _userSignature = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    _userSignature.backgroundColor = [UIColor clearColor];
    [headerView addSubview:_userSignature];
    
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
    [_userSignature addSubview:_labelUserSignature];


    //白色弧线背景
    _imageCurveBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 280-65-15, SCREEN_WIDTH, 87+20)];
    [_imageCurveBG setImage:[UIImage imageNamed:@"image_curveBG.png"]];
    _imageCurveBG.backgroundColor = [UIColor clearColor];
    _imageCurveBG.userInteractionEnabled = YES;
    [headerView addSubview:_imageCurveBG];
    
    //用户头像
    _imageUserIcon = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-65)/2, _userSignature.frame.origin.y+_userSignature.frame.size.height, 65, 65)];
    [_imageUserIcon setBackgroundColor:[UIColor clearColor]];
    [_imageUserIcon setContentMode:UIViewContentModeScaleAspectFill];//图片内容填满
    [_imageUserIcon.layer setMasksToBounds:YES];
    [_imageUserIcon setImage:[UIImage imageNamed:@"image_defaultHead1.png"] forState:UIControlStateNormal ];
    [_imageUserIcon.layer setCornerRadius:65/2];
    _imageUserIcon.layer.borderWidth = 0.5;//边框宽度
    _imageUserIcon.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];//边框颜色
    [headerView addSubview:_imageUserIcon];
    [_imageUserIcon addTarget:self action:@selector(onButtonShowBigHeadImage) forControlEvents:UIControlEventTouchUpInside];
    
    //用户昵称
    _labelUserName = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, _imageUserIcon.frame.origin.y+_imageUserIcon.frame.size.height+14, 40, 15)];
    [_labelUserName setBackgroundColor:[UIColor clearColor]];
    [_labelUserName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelUserName setFont:MKFONT(15)];
    [headerView addSubview:_labelUserName];
    
    //用户性别
    _imageSex = [[UIImageView alloc] initWithFrame:CGRectMake(_labelUserName.frame.origin.x+_labelUserName.frame.size.width+9.5, _labelUserName.frame.origin.y+1, 13, 13)];
    [headerView addSubview:_imageSex];
    [_imageSex setHidden:YES];
    
    //关注
    _btnFocus = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-90)/2, _labelUserName.frame.origin.y+_labelUserName.frame.size.height+14, 90, 24)];
    [_btnFocus setBackgroundColor:[UIColor clearColor]];
    [_btnFocus setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    [_btnFocus.layer setCornerRadius:12.f];//按钮设置圆角
    [_btnFocus .titleLabel setFont:MKFONT(12)];//按钮字体大小
    _btnFocus.layer.borderColor = [[UIColor clearColor] CGColor];
    _btnFocus.layer.borderWidth = 1.0f;
    [_btnFocus addTarget:self action:@selector(onButtonFocus:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_btnFocus];
    
    //关注；粉丝；想看；短评
    _viewUserBtnsBG = [[UIView alloc] initWithFrame: CGRectMake(0, _imageCurveBG.frame.origin.y+_imageCurveBG.frame.size.height, SCREEN_WIDTH, 61)];
    [_viewUserBtnsBG setBackgroundColor:[UIColor whiteColor]];
    [headerView addSubview:_viewUserBtnsBG];
    
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
    
    //动态的TabView
    _tabelDynamic = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tabelDynamic.dataSource = self;
    _tabelDynamic.delegate = self;
    _tabelDynamic.backgroundColor = [UIColor clearColor];
    _tabelDynamic.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabelDynamic];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _viewUserBtnsBG.frame.origin.y + _viewUserBtnsBG.frame.size.height, headerView.frame.size.width, 10)];
    lineView.backgroundColor = RGBA(246, 246, 251, 1);
    [headerView addSubview:lineView];
    
    headerView.frame = CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y, headerView.frame.size.width, lineView.frame.origin.y + lineView.frame.size.height);
    _tabelDynamic.tableHeaderView = headerView;
    
    [_tabelDynamic addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [_tabelDynamic.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
    [_tabelDynamic.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
}

-(void)loadDynData
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:[UIApplication sharedApplication].keyWindow withTitle:@"加载中..." withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    [ServicesUser getUserDynamicList:self._strUserId pageIndex:_pageIndex model:^(UserDynamicModel *userList) {
        
        _dynModel = userList;
        [weakSelf setFooterState];
        [_muArrType addObjectsFromArray:userList.feedList];
        //没有数据
        if ([_muArrType count] <= 0)
        {
            [weakSelf loadFailed];
        }
        [_tabelDynamic reloadData];
        
        [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
        //        _tabelDynamic.frame = CGRectMake(_tabelDynamic.frame.origin.x, _tabelDynamic.frame.origin.y, _tabelDynamic.frame.size.width, _tabelDynamic.contentSize.height);
        //        _scrollViewUserSet.contentSize = CGSizeMake(_scrollViewUserSet.frame.size.width, _tabelDynamic.contentSize.height + 600	);
        
    } failure:^(NSError *error) {
        [weakSelf loadFailed];
        [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
    }];
}

-(void) loadFailed
{
    UIView *viewWhiteBG = [[UIView alloc] initWithFrame:CGRectMake(0, _viewUserBtnsBG.frame.origin.y+_viewUserBtnsBG.frame.size.height + 10, SCREEN_WIDTH, 80+59+15+14+60)];
    [viewWhiteBG setBackgroundColor:[UIColor whiteColor]];
    [_tabelDynamic addSubview:viewWhiteBG];
    
    UIImageView* imgDefault = [[UIImageView alloc]initWithFrame:CGRectZero];
    imgDefault.image = [UIImage imageNamed:@"image_NoDataOtherUser.png"];
    [viewWhiteBG addSubview:imgDefault];
    
    if (IPhone5)
    {
        imgDefault.frame = CGRectMake((SCREEN_WIDTH-176/2)/2, 20, 176/2, 118/2);
    }
    else
    {
        imgDefault.frame = CGRectMake((SCREEN_WIDTH-176/2)/2, 80, 176/2, 118/2);
    }
    
    UILabel* labelDefault = [[UILabel alloc]initWithFrame:CGRectMake(0, imgDefault.frame.origin.y+imgDefault.frame.size.height+15, SCREEN_WIDTH, 14)];
    labelDefault.text = @"不想动，哪来的动态......";
    [labelDefault setTextColor:RGBA(123, 122, 152, 1)];
    [labelDefault setTextAlignment:NSTextAlignmentCenter];
    [labelDefault setFont:MKFONT(14)];
    [viewWhiteBG addSubview:labelDefault];
}

-(void)loadNewData
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:[UIApplication sharedApplication].keyWindow withTitle:@"加载中..." withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    [ServicesUser getUserDynamicList:self._strUserId pageIndex:_pageIndex model:^(UserDynamicModel *userList) {
        [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
        _dynModel = userList;
        [weakSelf setFooterState];
        [_muArrType addObjectsFromArray:userList.feedList];
        [_tabelDynamic reloadData];
        [_tabelDynamic.footer endRefreshing];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
        [_tabelDynamic.footer endRefreshing];
    }];
}

-(void)setFooterState
{
    if ([_pageIndex integerValue] == [_dynModel.pageTotal integerValue] || [_dynModel.pageTotal integerValue] == 0)
    {
        [_tabelDynamic.footer setState:MJRefreshFooterStateNoMoreData];
        [_tabelDynamic.footer setHidden:YES];
    }
    else
    {
        [_tabelDynamic.footer setHidden:NO];
        _pageIndex = [NSString stringWithFormat:@"%d",[_pageIndex intValue]+1];
    }
}

#pragma mark 返回按钮
-(void)onButtonBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击关注按钮
-(void)onButtonFocus:(UIButton *)sender
{
    //__weak OtherCenterViewController *weakself = self;
    if (sender.tag == 1 || sender.tag == 3)
    {
        [Tool showSuccessTip:@"取消关注" time:1];
        
        [_btnFocus setTitle:@"关注" forState:UIControlStateNormal];
        [_btnFocus setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
        [_btnFocus setBackgroundColor:RGBA(117, 112, 255, 1)];
        _btnFocus.layer.borderColor = [[UIColor clearColor] CGColor];
        
        _btnFocus.tag = 2;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self._strUserId forKey:@"user_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_CANCELFOLLOWUSER object:dic];
        
        //取消关注
        [ServicesUser cancelAttentionUser:self._strUserId model:^(RequestResult *userList)
         {
             
             //[weakself loadUnReadDataCount];
         } failure:^(NSError *error) {
             [Tool showSuccessTip:error.domain time:1];
         }];
        
    }
    else if (sender.tag == 2)
    {
        [Tool showSuccessTip:@"已关注" time:1];
        
        //判断对方关注状态
        if ([_userUnReadDataModel.isFollowMe intValue] == 0)
        {
            //0：对方未关注
            [_btnFocus setTitle:@"已关注" forState:UIControlStateNormal];
        }
        else
        {
            //1：对方已关注
            [_btnFocus setTitle:@"互相关注" forState:UIControlStateNormal];
        }
        [_btnFocus setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];//按钮文字颜色
        [_btnFocus setBackgroundColor:[UIColor whiteColor]];
        _btnFocus.layer.borderColor = [RGBA(123, 122, 152, 1) CGColor];
        
        _btnFocus.tag = 1;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:self._strUserId forKey:@"user_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_FOLLOWUSER object:dic];
        //关注
        [ServicesUser attentionUser:self._strUserId model:^(RequestResult *userList)
         {
             //[weakself loadUnReadDataCount];
         } failure:^(NSError *error) {
             [Tool showSuccessTip:error.domain time:1];
         }];
    }
}

#pragma mark ScrollViewView delegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat fContentOffsetY = scrollView.contentOffset.y;
    if(fContentOffsetY < 0)
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
    
    //改变头部状态栏的颜色
    if (fContentOffsetY/251 > 0)
    {
        [_topView setBackgroundColor:RGBA(255, 255, 255, fContentOffsetY/251)];
        [_labelTopTitle setTextColor:RGBA(51, 51, 51, fContentOffsetY/251)];
        [_labelTopLine setBackgroundColor:RGBA(233, 233, 238, fContentOffsetY/251)];
        
        
        if (fContentOffsetY > 246)
        {
            [_btnBack setImage:[UIImage imageNamed:@"btn_backBlack.png"] forState:UIControlStateNormal];
            
            //电池条变为黑色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        }
    }
    else
    {
        [_topView setBackgroundColor:RGBA(255, 255, 255, 0)];
        [_labelTopTitle setTextColor:RGBA(51, 51, 51, 0)];
        [_labelTopLine setBackgroundColor:RGBA(233, 233, 238, 0)];
        
        
        if (fContentOffsetY < 246)
        {
            [_btnBack setImage:[UIImage imageNamed:@"btn_backWhite.png"] forState:UIControlStateNormal];
            
            //电池条变为白色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        }
    }
}

#pragma mark *关注；粉丝；想看；看过*点击事件
-(void)onButtonAboutInfo:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 1000:
        {
            if ( ![Config getLoginState ] )
            {
                [self showLoginController];
            }
            else
            {
                MyAttentionViewController *myAttentionController = [[MyAttentionViewController alloc ] init];
                myAttentionController._attentionCount = _userUnReadDataModel.followUserCount;
                myAttentionController._userId = self._strUserId;
                [self.navigationController pushViewController:myAttentionController animated:YES];
            }
        }
            break;
        case 1001:
        {
            if ( ![Config getLoginState ] )
            {
                [self showLoginController];
            }
            else
            {
                MyFansViewController *myFansController = [[MyFansViewController alloc ] init];
                myFansController._fansCount = _userUnReadDataModel.fansCount;
                myFansController._userId = self._strUserId;
                [self.navigationController pushViewController:myFansController animated:YES];
            }
        }
            break;
        case 1002:
        {
            if ( ![Config getLoginState ] )
            {
                [self showLoginController];
            }
            else
            {
                WantLookViewController *wantLookController = [[WantLookViewController alloc ] init];
//                wantLookController._wangLookCount = _userUnReadDataModel.wantSeeMovieCount;
                wantLookController._userId = self._strUserId;
                [self.navigationController pushViewController:wantLookController animated:YES];
            }
        }
            break;
        case 1003:
        {
            if ( ![Config getLoginState ] )
            {
                [self showLoginController];
            }
            else
            {
                MovieReviewViewController *movieReviewController = [[MovieReviewViewController alloc] init];
//                movieReviewController._movieCount = _userUnReadDataModel.reviewCount;
                movieReviewController._userId = self._strUserId;
                [self.navigationController pushViewController:movieReviewController animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

-(void)onButtonRemind
{
    CinemaSearchViewController *globalSearchController = [[CinemaSearchViewController alloc ] init];
    [self.navigationController pushViewController:globalSearchController animated:NO];
}

#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _muArrType.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat originYImgIcon = 0;
    if (indexPath.row == 0)
    {
        originYImgIcon = 55;
    }
    FeedListModel* model = _muArrType[indexPath.row];
    CGFloat originYDesc = originYImgIcon+5+12+10;
    if (model.feedContent.length>0)
    {
        NSString* strContent = model.feedContent;
        if (strContent.length > 49)
        {
            //截取49个字符
            strContent = [strContent substringWithRange:NSMakeRange(0, 49)];
            strContent = [strContent stringByAppendingString:@"..."];
        }
        CGSize sizeContent = [Tool CalcString:strContent fontSize:MKFONT(14) andWidth:SCREEN_WIDTH-62];
        originYDesc = originYImgIcon+5+12+10+sizeContent.height+10;
    }
    if (model.targetTitle.length>0)
    {
        originYDesc += 60+15+12;
    }
    else
    {
        originYDesc+= 5+12;
    }
    if (model.commentList.count>0)
    {
        CGFloat heightLabelRes = 0;
        for (int i = 0 ; i<model.commentList.count; i++)
        {
            CommentListModel* cModel = model.commentList[i];
            FeedUserModel* commentUser = cModel.commentUser;
            FeedUserModel* replyUser = cModel.replyUser;
            NSString* stringContent = cModel.content;
            NSString* strNickName;
            if (replyUser.nickname.length>0)
            {
                //回复用户
                stringContent = [NSString stringWithFormat:@"回复%@：%@",replyUser.nickname,stringContent];
                strNickName = [NSString stringWithFormat:@"%@：",replyUser.nickname];
            }
            else
            {
                //发布的评论
                strNickName = [NSString stringWithFormat:@"%@：",commentUser.nickname];
            }
            NSString* str = [NSString stringWithFormat:@"%@%@",strNickName,stringContent];
            CGSize sizeContent = [Tool CalcString:str fontSize:MKFONT(13) andWidth:SCREEN_WIDTH-47-30];
            if (i == 0)
            {
                heightLabelRes = 15+sizeContent.height;
            }
            else
            {
                heightLabelRes += sizeContent.height+10;
            }
        }
        CGFloat heightRes = 0;
        //有回复内容
        if ([model.commentCount intValue] > model.commentList.count)
        {
            //有更多回复
            heightRes = heightLabelRes+15+13+10+15;
        }
        else
        {
            heightRes = heightLabelRes+15+15;
        }
        return  originYDesc+heightRes+40;
    }
    else
    {
        return  originYDesc+40;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = [NSString stringWithFormat:@"MyDynamicTableViewCell%ld",(long)indexPath.row];
    MyDynamicTableViewCell* cell;// = (MyDynamicTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[MyDynamicTableViewCell alloc]initWithReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.backgroundColor = [UIColor yellowColor];
        cell.dDelegate = self;
    }
    [cell setData:_muArrType[indexPath.row] index:indexPath.row model:_dynModel];
    return cell;
}

-(void)toNextPage:(DynamicType)type feedModel:(FeedListModel *)model
{
    _curModel = model;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    [ServicesUser checkFeedCanJump:model.intType objectId:model.contentId dataType:@1 model:^(RequestResult *userList) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        if (type == 1)
        {
            //想看电影，跳到影片详情页
            [FVCustomAlertView showDefaultLoadingAlertOnView:weakSelf.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
            [ServicesMovie getMovieDetail:[model.contentId stringValue] cinemaId:[Config getCinemaId] model:^(MovieModel *movieDetail) {
                [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
                MoviePosterViewController* vc = [[MoviePosterViewController alloc]init];
                vc.currentIndex = 0;
                if ([movieDetail.buyTicketStatus integerValue] == 0)
                {
                    //不能购票
                    vc.arrCommingMovieData = @[movieDetail];
                }
                else
                {
                    vc.arrMovieData = @[movieDetail];
                }
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } failure:^(NSError *error) {
                [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
            }];
        }
        if (type == 2)
        {
            //写了短评，跳到短评页
            CommentElseViewController* vc = [[CommentElseViewController alloc]init];
            vc.reviewId = model.contentId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else if (type == 3 )
        {
            
        }
        else if (type == 4 )
        {
            if ([[Config getUserId] isEqualToString:[model.contentId stringValue]])
            {
                //回到个人中心
//                NSDictionary* dictTab = @{@"tag":@2};
//                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
//                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                //切换tab
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate switchTab:2];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
            else
            {
                //关注用户，跳到他人主页
                OtherCenterViewController* vc = [[OtherCenterViewController alloc]init];
                vc._strUserId = [model.contentId stringValue];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
        else if (type == 5 || type == 6)
        {
            //活动，跳到凑热闹
            if (![[model.cinemaId stringValue] isEqualToString:[Config getCinemaId]])
            {
                [weakSelf changeCinema:[model.cinemaId stringValue]];
            }
            else
            {
                [weakSelf changeToAct];
            }
        }
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        [Tool showWarningTip:error.domain time:2.0];
    }];
}

-(void)changeToAct
{
    //活动，跳到凑热闹
    NSDictionary* dictTab = @{@"tag":@0};
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHCINEMAHOME object:nil];
    
    NSDictionary* dictHome = @{@"tag":@3,@"actId":_curModel.contentId};
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [Tool showTabBar];
}

-(void) changeCinema:(NSString *)cinemaId
{
    __weak typeof(self) weakSelf = self;
    [ServicesCinema getCinemaDetail:cinemaId cinemaModel:^(CinemaModel *model)
     {
         UIAlertView *_alterView = [[UIAlertView alloc ] initWithTitle:nil message:[NSString stringWithFormat:@"是否要切换影院『%@』",model.cinemaName] delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
         _alterView.tag = 998;
         [_alterView show];
         
     } failure:^(NSError *error) {
         
     }];
}

//跳到用户主页
-(void)toUserHome:(NSNumber *)uId
{
    if ([[Config getUserId] isEqualToString:[uId stringValue]])
    {
        //回到个人中心
//        NSDictionary* dictTab = @{@"tag":@2};
//        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
//        [self.navigationController popToRootViewControllerAnimated:YES];
        //切换tab
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate switchTab:2];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else
    {
        OtherCenterViewController* vc = [[OtherCenterViewController alloc]init];
        vc._strUserId = [uId stringValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)toDynDetail:(NSNumber *)feedId
{
    DynamicDetailViewController* vc = [[DynamicDetailViewController alloc]init];
    vc._feedId = feedId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)deleteCell:(NSInteger)index
{
    _curIndex = index;
    
    NSMutableArray* arrDelete = [[NSMutableArray alloc] init];
    [arrDelete addObject:@{ @"name" : @"删除" }];
    FDActionSheet* sheetDelete = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:arrDelete];
    for (int i = 0; i < arrDelete.count; i++)
    {
        [sheetDelete setButtonTitleColor:RGBA(249, 81, 81, 1) bgColor:[UIColor whiteColor] fontSize:15 atIndex:i];
    }
    sheetDelete.delegate = self;
    [sheetDelete show];
}

- (void)actionSheet:(FDActionSheet*)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    //删除
    UIAlertView* alertDelete = [[UIAlertView alloc]initWithTitle:@"提示" message:@"动态删除后，它的所有回复、点赞也将被删除。真的删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alertDelete show];
}

#pragma mark 切换影院记录
-(void) addCinemaBrowsingHistory:(NSString *)cinemaId
{
    if ([cinemaId length] > 0 )
    {
        [ServicesCinema addCinemaBrowseRecord:@"" longitude:@"" lastVisitCinemaId:cinemaId model:^(RequestResult *model) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 998)
    {
        if (buttonIndex == 1)
        {
            [self addCinemaBrowsingHistory:[_curModel.cinemaId stringValue]];
            [Config saveCinemaId:[_curModel.cinemaId stringValue]];
            [self changeToAct];
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            NSLog(@"删除cell");
            [_muArrType removeObjectAtIndex:_curIndex];  //删除_data数组里的数据
            //        NSIndexPath* path = [NSIndexPath indexPathForRow:_curIndex inSection:0];
            //        [_myTable deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
            [_tabelDynamic reloadData];
            FeedListModel* lModel = _muArrType[_curIndex];
            [ServicesUser deleteUserDynamic:lModel.id model:^(RequestResult *userList) {
                NSLog(@"删除动态成功");
            } failure:^(NSError *error) {
                
            }];
        }
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
