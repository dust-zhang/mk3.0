//
//  MyFansViewController.m
//  supercinema
//
//  Created by dust on 16/11/25.
//
//

#import "MyFansViewController.h"

@interface MyFansViewController ()
@end

@implementation MyFansViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pageIndex = 1;
    
    [self._labelTitle setText:[NSString stringWithFormat:@"粉丝（%d）",0]];
    _arrayFans = [[NSMutableArray alloc ] initWithCapacity:0];
    _dic = [[NSMutableDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(follow:) name:NOTIFITION_FOLLOWUSER object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelFollow:) name:NOTIFITION_CANCELFOLLOWUSER object:nil];
    
    [self initController];
    [self loadFailed:YES];
    [self loadFansData];
}

#pragma mark 加载失败 显示UI
-(void) loadFailed:(BOOL) showHide
{
    _imageLoadFailed = [[UIImageView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH/2-(98/4),self._viewTop.frame.size.height+ 200/2, 98/2, 139/2)];
    [_imageLoadFailed setImage:[UIImage imageNamed:@"image_NoDataFans.png"]];
    [self.view addSubview:_imageLoadFailed];
    _imageLoadFailed.hidden = showHide;
    
    _labelDescLoadFailed = [[UILabel alloc ] initWithFrame:CGRectMake(0, _imageLoadFailed.frame.origin.y+_imageLoadFailed.frame.size.height+15, SCREEN_WIDTH, 14)];
    [_labelDescLoadFailed setText:@"暂无粉丝"];
    [_labelDescLoadFailed setTextColor:RGBA(96, 94, 134, 1)];
    [_labelDescLoadFailed setTextAlignment:NSTextAlignmentCenter];
    [_labelDescLoadFailed setFont:MKFONT(14)];
    [self.view addSubview:_labelDescLoadFailed];
    _labelDescLoadFailed.hidden = showHide;
}

-(void)initController
{
    _tableViewMyfans = [[UITableView alloc] initWithFrame:CGRectMake(0,self._viewTop.frame.origin.y+self._viewTop.frame.size.height+10, SCREEN_WIDTH, SCREEN_HEIGHT-(self._viewTop.frame.origin.y+self._viewTop.frame.size.height+10) )];
    _tableViewMyfans.delegate = self;
    _tableViewMyfans.dataSource = self;
    _tableViewMyfans.backgroundColor = RGBA(246, 246, 251, 1);
    _tableViewMyfans.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewMyfans];
}

-(void)follow:(NSNotification *)noti{
    NSMutableDictionary *dic = noti.object;
    NSString *userId = [dic objectForKey:@"user_id"];
    if(_arrayFans != nil && _arrayFans.count > 0){
        for(FollowPersonListModel * follow in _arrayFans){
            if(follow.id.intValue == [userId intValue]){
                NSNumber *relationEnum = [_dic objectForKey:follow.id];
                if(relationEnum.intValue == 0){
                    follow.relationEnum = [NSNumber numberWithInt:1];
                }else if(relationEnum.intValue == 1){
                    follow.relationEnum = [NSNumber numberWithInt:3];
                }
                break;
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableViewMyfans reloadData];
    });
}

-(void)cancelFollow:(NSNotification *)noti{
    NSMutableDictionary *dic = noti.object;
    NSString *userId = [dic objectForKey:@"user_id"];
    if(_arrayFans != nil && _arrayFans.count > 0){
        for(FollowPersonListModel * follow in _arrayFans){
            if(follow.id.intValue == [userId intValue]){
                follow.relationEnum = [NSNumber numberWithInt:2];
                break;
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableViewMyfans reloadData];
    });
}

-(void)loadMoreFansData
{
    _pageIndex+=1;
    [self loadFansData];
}

-(void)loadFansData
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesUser getFansUserList:self._userId pageIndex:_pageIndex model:^(MyFansModel *fansModel)
     {
         _viewLoadFailed.hidden = YES;
         [weakSelf._labelTitle setText:[NSString stringWithFormat:@"粉丝（%d）",[fansModel.totoalCount intValue]]];
         [_arrayFans addObjectsFromArray:fansModel.fansList];
         [_tableViewMyfans reloadData];
         
         if (_pageIndex < [fansModel.pageTotal intValue])
         {
             for(FollowPersonListModel * follow in fansModel.fansList)
             {
                  [_dic setObject:follow.isFollowMe forKey:follow.id];
             }
             [_tableViewMyfans addLegendFooterWithRefreshingTarget:weakSelf refreshingAction:@selector(loadMoreFansData)];
             [_tableViewMyfans.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
             [_tableViewMyfans.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
             [_tableViewMyfans.footer endRefreshing];
         }
         if (_pageIndex == [fansModel.pageTotal intValue])
         {
             [_tableViewMyfans removeFooter];
             _pageIndex =[fansModel.pageTotal intValue];
         }
         
         //没有数据
         if ([_arrayFans count] == 0)
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
            [ws loadFansData];
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
    if (indexPath.row == [_arrayFans count]-1)
    {
        return 200/2;
    }
    return 150/2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayFans count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier= @"UserTableViewCell";
    UserTableViewCell *cell = (UserTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell._attentionDelegate = self;
    }
    
    FollowPersonListModel* model = [_arrayFans objectAtIndex:indexPath.row];
    [cell setAttentionUserText:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    FollowPersonListModel* model = [_arrayFans objectAtIndex:indexPath.row];
    
    if ([[Config getUserId] isEqualToString:[model.id stringValue]])
    {
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
        [MobClick event:myCenterViewbtn11];
        self._userId = userId;
        [self onButtonFocusCancel];
    }
    else
    {
        if(_arrayFans != nil && _arrayFans.count > 0)
        {
            for(FollowPersonListModel * follow in _arrayFans)
            {
                if(follow.id.intValue == [userId intValue])
                {
                    NSNumber *relationEnum = [_dic objectForKey:follow.id];
                    if(relationEnum.intValue == 0)
                    {
                        [MobClick event:myCenterViewbtn13];
                        follow.relationEnum = [NSNumber numberWithInt:1];
                    }
                    else if(relationEnum.intValue == 1)
                    {
                        [MobClick event:myCenterViewbtn12];
                        follow.relationEnum = [NSNumber numberWithInt:3];
                    }
                    
                    [_tableViewMyfans reloadData];
                    
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
        if(_arrayFans != nil && _arrayFans.count > 0)
        {
            for(FollowPersonListModel * follow in _arrayFans)
            {
                if(follow.id.intValue == [self._userId intValue])
                {
                    follow.relationEnum = [NSNumber numberWithInt:2];
                    break;
                }
            }
        }
        [_tableViewMyfans reloadData];
        
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
