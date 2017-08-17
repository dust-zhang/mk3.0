//
//  SocietyTableView.m
//  supercinema
//
//  Created by Mapollo28 on 2016/12/1.
//
//

#import "SocietyTableView.h"

@implementation SocietyTableView

-(id)initWithFrame:(CGRect)frame navigation:(UINavigationController*)nav
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _pageIndex = @1;
        
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _myTable.dataSource = self;
        _myTable.delegate = self;
        _myTable.backgroundColor = [UIColor clearColor];
        _myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_myTable];
        
        [_myTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [_myTable.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
        [_myTable.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];

        _nav = nav;
    }
    return self;
}

-(void)loadData
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self withTitle:@"加载中..." withBlur:NO allowTap:YES];
    [ServicesNotification getNotifityList:@1 result:^(SystemNoticeModel *model) {
        [FVCustomAlertView hideAlertFromView:weakSelf fading:YES];
        _sModel = model;
        [weakSelf setSocietyNotifyListReaded];
        if (weakSelf.viewLoadFailed)
        {
            weakSelf.viewLoadFailed.hidden = YES;
        }
        if (model.notifyList.count == 0)
        {
            //没有社交通知
            [weakSelf noData];
            _myTable.footer.hidden = YES;
        }
        _arrData = [[NSMutableArray alloc]initWithArray:model.notifyList];
        [self setFooterState];
        [_myTable reloadData];
    } failure:^(NSError *error) {
        [weakSelf loadFailed];
        [FVCustomAlertView hideAlertFromView:weakSelf fading:YES];
    }];
}

-(void)setSocietyNotifyListReaded
{
    NSMutableArray *arrNoticeRead = [[NSMutableArray alloc]init];
    for (SysNotifyListModel* model in _sModel.notifyList)
    {
        if ([model.status intValue] == 0)
        {
            //未读
            [arrNoticeRead addObject:model.id];
        }
    }
    if (arrNoticeRead.count>0)
    {
        [ServicesNotification setNoticeRead:arrNoticeRead result:^(RequestResult *model) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)setPointsHidden
{
    for (SysNotifyListModel *model in _arrData)
    {
        model.status = [NSNumber numberWithInt:1];
    }
    [_myTable reloadData];
}

-(void)setFooterState
{
    if ([_pageIndex integerValue] == [_sModel.pageTotal integerValue] || [_sModel.pageTotal integerValue] == 0)
    {
        [_myTable.footer setState:MJRefreshFooterStateNoMoreData];
        [_myTable removeFooter];
    }
    else
    {
        _pageIndex = [NSNumber numberWithInteger:[_pageIndex integerValue]+1];
    }
}

#pragma mark 没有数据 显示UI
-(void) noData
{
    UIImageView* imgDefault = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-110/2)/2, 165/2, 110/2, 175/2)];
    imgDefault.image = [UIImage imageNamed:@"image_NoDataNotice.png"];
    [self addSubview:imgDefault];
    
    UILabel* labelDefault = [[UILabel alloc]initWithFrame:CGRectMake(0, imgDefault.frame.origin.y+imgDefault.frame.size.height+15, SCREEN_WIDTH, 14)];
    labelDefault.text = @"这里好安静啊，躲在盒子里可交不到朋友哦。";
    [labelDefault setTextColor:RGBA(123, 122, 152, 1)];
    [labelDefault setTextAlignment:NSTextAlignmentCenter];
    [labelDefault setFont:MKFONT(14)];
    [self addSubview:labelDefault];
}

#pragma mark 加载失败 显示UI
-(void)loadFailed
{
    if (!_viewLoadFailed)
    {
        _viewLoadFailed = [[LoadFailedView alloc]initWithFrame:CGRectMake(0, 165/2, SCREEN_WIDTH, HEIGHT_FAILEDVIEW)];
        WeakSelf(ws);
        [_viewLoadFailed setRefreshData:^{
            [ws loadData];
        }];
        [self addSubview:_viewLoadFailed];
    }
    else
    {
        _viewLoadFailed.hidden = NO;
    }
    [self bringSubviewToFront:_viewLoadFailed];
}

-(void)loadNewData
{
    __weak typeof(self) weakSelf = self;
//    [_muArrType addObjectsFromArray:_arrType];
    [ServicesNotification getNotifityList:_pageIndex result:^(SystemNoticeModel *model) {
        _pageIndex = model.pageIndex;
        [_arrData addObjectsFromArray:model.notifyList];
        [_myTable reloadData];
        [_myTable.footer endRefreshing];
        [weakSelf setFooterState];
    } failure:^(NSError *error) {
        [_myTable.footer endRefreshing];
    }];
}

#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SysNotifyListModel* model = _arrData[indexPath.row];
    
    CGFloat originYTime =15+(40-15)/2+15+10;

    if (model.content.length>0)
    {
        NSString* strRespond = model.content;
        if (strRespond.length > 39)
        {
            //截取39个字符
            strRespond = [strRespond substringWithRange:NSMakeRange(0, 39)];
            strRespond = [strRespond stringByAppendingString:@"..."];
        }
        CGSize sizeRespond = [Tool CalcString:strRespond fontSize:MKFONT(15) andWidth:SCREEN_WIDTH-95];
        originYTime = 15+(40-15)/2+15+15+sizeRespond.height+10;
    }
    
    CGFloat heightDesc = 0;
    CGFloat heightType = 0;
    if ([model.intTargetType intValue] > 0)
    {
        //有targetType的描述
        heightType = 15+12;
        heightDesc = heightType;
    }
    
    if (model.targetImg.length>0)
    {
        heightDesc += 15+40;
    }
    
    if (model.targetTitle.length>0)
    {
        heightDesc = heightType+15+16;
    }
    
    if (model.targetDesc.length>0)
    {
        CGFloat heightTitle = heightType+15+16+10;
        if (model.targetTitle.length==0)
        {
            heightTitle = heightType+15;
        }
        heightDesc = heightTitle+12;
    }
    if (heightDesc>0)
    {
        originYTime += heightDesc+15+20;
    }

    return originYTime + 27;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = [NSString stringWithFormat:@"SocietyTableViewCell%ld",(long)indexPath.row];
    SocietyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[SocietyTableViewCell alloc]initWithReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sDelegate = self;
    }
    [cell setData:_arrData[indexPath.row] curTime:_sModel.currentTime isFirst:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SysNotifyListModel * model = _arrData[indexPath.row];
    int type = [model.intType intValue];
    [FVCustomAlertView showDefaultLoadingAlertOnView:self withTitle:@"加载中..." withBlur:NO allowTap:NO];
    __weak typeof(self) weakSelf = self;
    [ServicesUser checkFeedCanJump:model.intType objectId:[NSNumber numberWithInteger:[model.contentId integerValue]] dataType:@2 model:^(RequestResult *userList)
     {
         [FVCustomAlertView hideAlertFromView:weakSelf fading:YES];
         if (type == 3)
         {
             //关注用户
             if ([[Config getUserId] isEqualToString:[model.rpUserId stringValue]])
             {
                 //回到个人中心
//                 NSDictionary* dictTab = @{@"tag":@2};
//                 [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
//                 [_nav popToRootViewControllerAnimated:YES];
                 //切换tab
                 AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                 [appDelegate switchTab:2];
                 [_nav popToRootViewControllerAnimated:NO];
             }
             else
             {
                 OtherCenterViewController* vc = [[OtherCenterViewController alloc]init];
                 vc._strUserId = [model.rpUserId stringValue];
                 [_nav pushViewController:vc animated:YES];
             }
         }
         
         if (type == 1 || type == 2)
         {
             //回复短评、赞短评，跳到短评详情页
             CommentElseViewController* vc = [[CommentElseViewController alloc]init];
             vc.reviewId = [NSNumber numberWithInteger:[model.contentId integerValue]];
             [_nav pushViewController:vc animated:YES];
         }
         else if (type == 4 || type == 5)
         {
             //回复动态、赞动态，跳到动态详情页
             [MobClick event:myCenterViewbtn59];
             [MobClick event:myCenterViewbtn60];
             DynamicDetailViewController* vc = [[DynamicDetailViewController alloc]init];
             vc._feedId = [NSNumber numberWithInteger:[model.contentId integerValue]];
             [_nav pushViewController:vc animated:YES];
         }
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakSelf fading:YES];
         [Tool showWarningTip:error.domain time:2.0];
     }];
}

#pragma mark - SocietyTableViewCellDelegate
-(void)respondToUserHome:(NSNumber *)uId
{
    if ([[Config getUserId] isEqualToString:[uId stringValue]])
    {
        //回到个人中心
//        NSDictionary* dictTab = @{@"tag":@2};
//        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
//        [_nav popToRootViewControllerAnimated:YES];
        //切换tab
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate switchTab:2];
        [_nav popToRootViewControllerAnimated:NO];
    }
    else
    {
        OtherCenterViewController* vc = [[OtherCenterViewController alloc]init];
        vc._strUserId = [uId stringValue];
        [_nav pushViewController:vc animated:YES];
    }
}

@end
