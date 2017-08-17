//
//  MyAttentionViewController.m
//  supercinema
//
//  Created by dust on 16/11/25.
//
//

#import "MyAttentionViewController.h"

@interface MyAttentionViewController ()

@end

@implementation MyAttentionViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pageIndex = 1;
    
    // Do any additional setup after loading the view.
    [self._labelTitle setText:[NSString stringWithFormat:@"关注（%d）",0]];
    _arrayAttentionUser = [[NSMutableArray alloc ] initWithCapacity:0];
    _dic = [[NSMutableDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(follow:) name:NOTIFITION_FOLLOWUSER object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelFollow:) name:NOTIFITION_CANCELFOLLOWUSER object:nil];
    
    [self initController];
    [self loadFailed:YES];
    
    [self loadAttentionUserData];
    
}

-(void)follow:(NSNotification *)noti
{
    NSMutableDictionary *dic = noti.object;
    NSString *userId = [dic objectForKey:@"user_id"];
    if(_arrayAttentionUser != nil && _arrayAttentionUser.count > 0)
    {
        for(FollowPersonListModel * follow in _arrayAttentionUser)
        {
            if(follow.id.intValue == [userId intValue])
            {
                NSNumber *relationEnum = [_dic objectForKey:follow.id];
                if(relationEnum.intValue == 0)
                {
                    follow.relationEnum = [NSNumber numberWithInt:1];
                }
                else if(relationEnum.intValue == 1)
                {
                    follow.relationEnum = [NSNumber numberWithInt:3];
                }
                break;
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableViewAttention reloadData];
    });
    
}

-(void)cancelFollow:(NSNotification *)noti
{
    NSMutableDictionary *dic = noti.object;
    NSString *userId = [dic objectForKey:@"user_id"];
    if(_arrayAttentionUser != nil && _arrayAttentionUser.count > 0)
    {
        for(FollowPersonListModel * follow in _arrayAttentionUser)
        {
            if(follow.id.intValue == [userId intValue])
            {
                follow.relationEnum = [NSNumber numberWithInt:2];
                break;
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableViewAttention reloadData];
    });
}


#pragma mark 加载失败 显示UI
-(void) loadFailed:(BOOL) showHide
{
    _imageLoadFailed = [[UIImageView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH/2-(98/4),self._viewTop.frame.size.height+ 200/2, 98/2, 139/2)];
    [_imageLoadFailed setImage:[UIImage imageNamed:@"image_NoDataAttention.png"]];
    [self.view addSubview:_imageLoadFailed];
    _imageLoadFailed.hidden = showHide;
    
    _labelDescLoadFailed = [[UILabel alloc ] initWithFrame:CGRectMake(0, _imageLoadFailed.frame.origin.y+_imageLoadFailed.frame.size.height+15, SCREEN_WIDTH, 14)];
    [_labelDescLoadFailed setText:@"暂无关注"];
    [_labelDescLoadFailed setTextColor:RGBA(96, 94, 134, 1)];
    [_labelDescLoadFailed setTextAlignment:NSTextAlignmentCenter];
    [_labelDescLoadFailed setFont:MKFONT(14)];
    [self.view addSubview:_labelDescLoadFailed];
    _labelDescLoadFailed.hidden = showHide;
}

-(void)initController
{
    _tableViewAttention = [[UITableView alloc] initWithFrame:CGRectMake(0,self._viewTop.frame.origin.y+self._viewTop.frame.size.height+10, SCREEN_WIDTH, SCREEN_HEIGHT-(self._viewTop.frame.origin.y+self._viewTop.frame.size.height+10) )];
    _tableViewAttention.delegate = self;
    _tableViewAttention.dataSource = self;
    _tableViewAttention.backgroundColor = RGBA(246, 246, 251, 1);
    _tableViewAttention.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewAttention];
}

-(void)loadMoreAttentionUserData
{
    _pageIndex+=1;
    [self loadAttentionUserData];
}

-(void)loadAttentionUserData
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesUser getAttentionUserList:self._userId pageIndex:_pageIndex model:^(AttentionUserModel *userList)
    {

        _viewLoadFailed.hidden = YES;
        [weakSelf._labelTitle setText:[NSString stringWithFormat:@"关注（%d）",[userList.totoalCount intValue]]];
        [_arrayAttentionUser addObjectsFromArray:userList.followPersonList];
        [_tableViewAttention reloadData];
        
        if (_pageIndex < [userList.pageTotal intValue])
        {
            for(FollowPersonListModel * follow in userList.followPersonList)
            {
                [_dic setObject:follow.isFollowMe forKey:follow.id];
            }
            [_tableViewAttention addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreAttentionUserData)];
            [_tableViewAttention.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [_tableViewAttention.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
            [_tableViewAttention.footer endRefreshing];
        }
        if (_pageIndex == [userList.pageTotal intValue])
        {
            [_tableViewAttention removeFooter];
            _pageIndex =[userList.pageTotal intValue];
        }
        
        //没有数据
        if ([_arrayAttentionUser count] == 0)
        {
            [weakSelf loadFailed:NO];
        }
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        
    } failure:^(NSError *error) {
        
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        [Tool showWarningTip:error.domain time:1];
        _viewLoadFailed.hidden = NO;
        [self initFailureView];
    }];
    
}

-(void)initFailureView
{
    if (!_viewLoadFailed)
    {
        _viewLoadFailed = [[LoadFailedView alloc]initWithFrame:CGRectMake(0,103, SCREEN_WIDTH, HEIGHT_FAILEDVIEW)];
        WeakSelf(ws);
        [_viewLoadFailed setRefreshData:^{
            //刷新数据
            [ws loadAttentionUserData];
        }];
        [self.view addSubview:_viewLoadFailed];
    }
    else
    {
        _viewLoadFailed.hidden = NO;
    }
}

//Cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_arrayAttentionUser count]-1)
    {
        return 200/2;
    }
    return 150/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayAttentionUser count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier= @"UserTableViewCell";
    UserTableViewCell *cell = (UserTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell._attentionDelegate = self;
        cell._btnAttention.tag = indexPath.row;
    }
    
    FollowPersonListModel* model = [_arrayAttentionUser objectAtIndex:indexPath.row];
    [cell setAttentionUserText:model];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    FollowPersonListModel* model = [_arrayAttentionUser objectAtIndex:indexPath.row];
    
    if ([[Config getUserId] isEqualToString:[model.id stringValue]])
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
        vc._strUserId = [model.id stringValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)onButtonAttentionDelegte:(UIButton *)btn userId:(NSNumber *)userId isCancel:(BOOL)isCancel
{
    [self attentionUser:[userId stringValue] isCancel:isCancel];
}

-(void)attentionUser:(NSString *)userId isCancel:(BOOL)isCancel
{
    if(isCancel)
    {
        self._userId = userId;
        [self onButtonFocusCancel];
    }
    else
    {
        if(_arrayAttentionUser != nil && _arrayAttentionUser.count > 0)
        {
            for(FollowPersonListModel * follow in _arrayAttentionUser)
            {
                if(follow.id.intValue == [userId intValue])
                {
                    NSNumber *relationEnum = [_dic objectForKey:follow.id];
                    
                    if(relationEnum.intValue == 0)
                    {
                        [MobClick event:myCenterViewbtn7];
                        //当前关注用户 未关注我
                        //设置为 已关注
                        follow.relationEnum = [NSNumber numberWithInt:1];
                    }
                    else if(relationEnum.intValue == 1)
                    {
                        [MobClick event:myCenterViewbtn6];
                        //当前关注用户 已关注我
                        //设置为 互相关注
                        follow.relationEnum = [NSNumber numberWithInt:3];
                    }
                    
                    [_tableViewAttention reloadData];
                    
                    [ServicesUser attentionUser:userId model:^(RequestResult *userList)
                    {} failure:^(NSError *error) {}];

                    break;
                }
            }
        }
        
    }
    
}

#pragma mark 取消关注 弹框
-(void)onButtonFocusCancel
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"真的要取消关注嘛~？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //点击确认 取消关注
    if (buttonIndex == 1)
    {
        if(_arrayAttentionUser != nil && _arrayAttentionUser.count > 0)
        {
            for(FollowPersonListModel * follow in _arrayAttentionUser)
            {
                if(follow.id.intValue == [self._userId intValue])
                {
                    follow.relationEnum = [NSNumber numberWithInt:2];
                    break;
                }
            }
        }
        [_tableViewAttention reloadData];
        
        [ServicesUser cancelAttentionUser:self._userId model:^(RequestResult *userList)
         {
         } failure:^(NSError *error) {
             
         }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_FOLLOWUSER];
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_CANCELFOLLOWUSER];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
