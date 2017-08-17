//
//  MyDynamicViewController.m
//  supercinema
//
//  Created by Mapollo28 on 2016/12/2.
//
//

#import "MyDynamicViewController.h"

@interface MyDynamicViewController ()

@end

@implementation MyDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _arrType = @[@1,@2,@3,@5,@4,@6,@3];
    _muArrType = [[NSMutableArray alloc]init];
    
    self._labelTitle.text = [Config getUserNickName];
    _pageIndex = @"1";
    [self initControl];
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:NOTIFITION_REFRESHDYNLIST object:nil];
}

-(void)refreshData
{
    _pageIndex = @"1";
    [_muArrType removeAllObjects];
    [self loadData];
}

-(void)loadData
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    [ServicesUser getUserDynamicList:[Config getUserId] pageIndex:_pageIndex model:^(UserDynamicModel *userList)
    {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        _dynModel = userList;
        [weakSelf setFooterState];
        [_muArrType addObjectsFromArray:userList.feedList];
        
        if (weakSelf.viewLoadFailed)
        {
            weakSelf.viewLoadFailed.hidden = YES;
        }
        
        //没有数据
        if ([_muArrType count] <= 0)
        {
            [weakSelf noData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myTable reloadData];
        });
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        [weakSelf loadFailed];
    }];
}

-(void) noData
{
    UIImageView* imgDefault = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-176/2)/2, self._viewTop.frame.origin.y + self._viewTop.frame.size.height + 120/2, 176/2, 118/2)];
    imgDefault.image = [UIImage imageNamed:@"image_NoDataOtherUser.png"];
    [self.view addSubview:imgDefault];
    
    UILabel* labelDefault = [[UILabel alloc]initWithFrame:CGRectMake(0, imgDefault.frame.origin.y+imgDefault.frame.size.height+15, SCREEN_WIDTH, 14)];
    labelDefault.text = @"不想动，哪来的动态......";
    [labelDefault setTextColor:RGBA(123, 122, 152, 1)];
    [labelDefault setTextAlignment:NSTextAlignmentCenter];
    [labelDefault setFont:MKFONT(14)];
    [self.view addSubview:labelDefault];
}

#pragma mark 加载失败 显示UI
-(void)loadFailed
{
    if (!_viewLoadFailed)
    {
        _viewLoadFailed = [[LoadFailedView alloc]initWithFrame:CGRectMake(0, self._viewTop.frame.origin.y + self._viewTop.frame.size.height + 120/2, SCREEN_WIDTH, HEIGHT_FAILEDVIEW)];
        WeakSelf(ws);
        [_viewLoadFailed setRefreshData:^{
            [ws loadData];
        }];
        [self.view addSubview:_viewLoadFailed];
    }
    else
    {
        _viewLoadFailed.hidden = NO;
    }
    [self.view bringSubviewToFront:_viewLoadFailed];
}

-(void)initControl
{
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor = RGBA(248, 248, 252, 1);
    [self.view addSubview:backView];
    
    UILabel* labelFooter = [[UILabel alloc]initWithFrame:CGRectMake(0, backView.frame.size.height-100, SCREEN_WIDTH, 100)];
    labelFooter.text = NoMoreData;
    labelFooter.textAlignment = NSTextAlignmentCenter;
    labelFooter.textColor = RGBA(123, 122, 152, 0.6);
    labelFooter.font = MKFONT(12);
    [backView addSubview:labelFooter];
    
    [self.view sendSubviewToBack:backView];
    
    _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self._viewTop.frame.origin.y+self._viewTop.frame.size.height, self.view.frame.size.width, SCREEN_HEIGHT-(self._viewTop.frame.origin.y+self._viewTop.frame.size.height))];
    _myTable.dataSource = self;
    _myTable.delegate = self;
    _myTable.backgroundColor = [UIColor clearColor];
    _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTable];
    
    [_myTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [_myTable.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
    [_myTable.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
}

-(void)loadNewData
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    [ServicesUser getUserDynamicList:[Config getUserId] pageIndex:_pageIndex model:^(UserDynamicModel *userList)
     {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        _dynModel = userList;
        [weakSelf setFooterState];
        [_muArrType addObjectsFromArray:userList.feedList];
        [_myTable reloadData];
        [_myTable.footer endRefreshing];
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        [_myTable.footer endRefreshing];
    }];
}

-(void)setFooterState
{
    if ([_pageIndex integerValue] == [_dynModel.pageTotal integerValue] || [_dynModel.pageTotal integerValue] == 0)
    {
        [_myTable.footer setState:MJRefreshFooterStateNoMoreData];
        [_myTable.footer setHidden:YES];
    }
    else
    {
        [_myTable.footer setHidden:NO];
        _pageIndex = [NSString stringWithFormat:@"%d",[_pageIndex intValue]+1];
    }
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
        originYImgIcon = 65;
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
    [ServicesUser checkFeedCanJump:model.intType objectId:model.contentId dataType:@1 model:^(RequestResult *userList)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
         if (type == 1)
         {
             [MobClick event:myCenterViewbtn50];
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
             [MobClick event:myCenterViewbtn54];
             //写了短评，跳到短评页
             CommentElseViewController* vc = [[CommentElseViewController alloc]init];
             vc.reviewId = model.contentId;
             [weakSelf.navigationController pushViewController:vc animated:YES];
         }
         else if (type == 4 )
         {
             [MobClick event:myCenterViewbtn51];
             //关注用户，跳到他人主页
             if ([[Config getUserId] isEqualToString:[model.contentId stringValue]])
             {
                 //回到个人中心
//                 NSDictionary* dictTab = @{@"tag":@2};
//                 [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
//                 [self.navigationController popToRootViewControllerAnimated:YES];
                 //切换tab
                 AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                 [appDelegate switchTab:2];
                 [weakSelf.navigationController popToRootViewControllerAnimated:NO];
             }
             else
             {
                 OtherCenterViewController* vc = [[OtherCenterViewController alloc]init];
                 vc._strUserId = [model.contentId stringValue];
                 [weakSelf.navigationController pushViewController:vc animated:YES];
             }
         }
         else if (type == 5 || type == 6)
         {
             [MobClick event:myCenterViewbtn52];
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
         _alterView = [[UIAlertView alloc ] initWithTitle:nil message:[NSString stringWithFormat:@"是否要切换影院『%@』",model.cinemaName] delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
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
    [MobClick event:myCenterViewbtn53];
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
            
            FeedListModel* lModel = _muArrType[_curIndex];
            [_muArrType removeObjectAtIndex:_curIndex];  //删除_data数组里的数据
            [_myTable reloadData];
            if ([_muArrType count] ==0)
            {
                [self noData];
            }
            
            [ServicesUser deleteUserDynamic:lModel.id model:^(RequestResult *userList) {
                NSLog(@"删除动态成功");
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_REFRESHDYNLIST];
}

@end
