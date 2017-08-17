//
//  MembershipCardView.m
//  supercinema
//
//  Created by mapollo91 on 7/11/16.
//
//

#import "MembershipCardView.h"

@implementation MembershipCardView

-(id)initWithFrame:(CGRect)frame navigation:(UINavigationController *)navigation
{
    self = [super initWithFrame:frame];
    self.navigation = navigation;
    
    _tabViewMembershipCard = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height)];
    _tabViewMembershipCard.delegate = self;
    _tabViewMembershipCard.dataSource = self;
    [_tabViewMembershipCard setBackgroundColor:RGBA(246, 246, 251, 1)];
    //分割条颜色
    [_tabViewMembershipCard setSeparatorColor:[UIColor clearColor]];
    [self addSubview:_tabViewMembershipCard];
    
    //加载失败
    _imageLoadFailed = [[UIImageView alloc ] initWithFrame:CGRectMake((SCREEN_WIDTH-126)/2,_tabViewMembershipCard.frame.origin.y+90, 126, 78.5)];
    [_imageLoadFailed setImage:[UIImage imageNamed:@"image_NoDataMemberCard.png"]];
    _imageLoadFailed.hidden = YES;
    [self addSubview:_imageLoadFailed];
    
    _labelDescLoadFailed = [[UILabel alloc ] initWithFrame:CGRectMake(0, _imageLoadFailed.frame.origin.y+_imageLoadFailed.frame.size.height+15, SCREEN_WIDTH, 14)];
    [_labelDescLoadFailed setText:@"超值权益即将推出，常来看看哦！"];
    [_labelDescLoadFailed setTextColor:RGBA(123, 122, 152, 1)];
    [_labelDescLoadFailed setTextAlignment:NSTextAlignmentCenter];
    [_labelDescLoadFailed setFont:MKFONT(14)];
    _labelDescLoadFailed.hidden = YES;
    [self addSubview:_labelDescLoadFailed];

    //下拉刷新
    [self initMembershipCardList];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(loadCardData) name:NOTIFITION_REFRESHCARD object:nil];
    
    //加载失败
    _imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-73)/2, 103, 73, 67)];
    _imageFailure.image = [UIImage imageNamed:@"image_NoDataOrder.png"];
    _imageFailure.hidden = YES;
    [self addSubview:_imageFailure];
    
    _labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageFailure.frame.origin.y+_imageFailure.frame.size.height+15, SCREEN_WIDTH, 14)];
    _labelFailure.text = @"加载失败";
    _labelFailure.textColor = RGBA(123, 122, 152, 1);
    _labelFailure.font = MKFONT(14);
    _labelFailure.textAlignment = NSTextAlignmentCenter;
    _labelFailure.hidden = YES;
    [self addSubview:_labelFailure];
    
    _btnTryAgain = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnTryAgain.frame = CGRectMake((SCREEN_WIDTH-146/2)/2, _labelFailure.frame.origin.y+_labelFailure.frame.size.height+25, 146/2, 24);
    [_btnTryAgain setTitle:@"重新加载" forState:UIControlStateNormal];
    [_btnTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnTryAgain.titleLabel.font = MKFONT(14);
    _btnTryAgain.backgroundColor = RGBA(117, 112, 255, 1);
    _btnTryAgain.layer.masksToBounds = YES;
    _btnTryAgain.layer.cornerRadius = _btnTryAgain.frame.size.height/2;
    [_btnTryAgain addTarget:self action:@selector(onButtonTryAgain) forControlEvents:UIControlEventTouchUpInside];
    _btnTryAgain.hidden = YES;
    [self addSubview:_btnTryAgain];
    
    return self;
}

-(void)loadCardData
{
    [self removeAllObjectsCardTable];
    [self reloadCardData];
}

//清理缓存数据
-(void)removeAllObjectsCardTable
{
    [_arrayCardTable removeAllObjects];
    [_tabViewMembershipCard reloadData];
}

//重新加载
-(void)onButtonTryAgain
{
    [self reloadCardData];
}

#pragma mark 渲染列表UI
-(void)initMembershipCardList
{
    [_tabViewMembershipCard addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshNewData)];
    [_tabViewMembershipCard.header setTitle:@"" forState:MJRefreshHeaderStateRefreshing];
}

-(void)refreshNewData
{
    _modelMember = [[MemberModel alloc ] init];
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.superview withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMember getCinemaUserCardList:[Config getCinemaId] model:^(MemberModel *memberModel)
     {
         NSLog(@"%@",[memberModel toJSONString]);
        
         _modelMember = memberModel;
         _arrayCardTable = [[NSMutableArray alloc] initWithArray:memberModel.cinemaCardList];
         [_tabViewMembershipCard reloadData];
         [_tabViewMembershipCard.header endRefreshing];
//         //隐藏加载失败效果
//         _imageLoadFailed.hidden = YES;
//         _labelDescLoadFailed.hidden = YES;
//         //没有数据
//         if ([_arrayCardTable count] <= 0)
//         {
//             [weakSelf loadFailed];
//         }
         
         if( [_arrayCardTable count] > 0 )
         {
             [weakSelf showImageWithStatus:NO isLoadSuccess:YES];
             [_tabViewMembershipCard reloadData];
         }
         else
         {
             [weakSelf showImageWithStatus:YES isLoadSuccess:YES];
         }

         [FVCustomAlertView hideAlertFromView:weakSelf.superview fading:YES];
     } failure:^(NSError *error) {
         [_tabViewMembershipCard.header endRefreshing];
         _modelMember = nil;
         [weakSelf showImageWithStatus:NO isLoadSuccess:NO];
         [FVCustomAlertView hideAlertFromView:weakSelf.superview fading:YES];
         [Tool showWarningTip:error.domain time:2];
         
     }];
}

//#pragma mark 加载失败 显示UI
//-(void) loadFailed
//{
//    _imageLoadFailed.hidden = NO;
//    _labelDescLoadFailed.hidden = NO;
//}

#pragma mark 加载数据
-(void)reloadCardData
{
    _modelMember = [[MemberModel alloc ] init];
     __weak typeof(self) weakSelf = self;
    //[UIApplication sharedApplication].keyWindow
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.superview withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesMember getCinemaUserCardList:[Config getCinemaId] model:^(MemberModel *memberModel)
     {
         NSLog(@"%@",[memberModel toJSONString]);
         
         _modelMember = memberModel;
         _arrayCardTable = [[NSMutableArray alloc] initWithArray:memberModel.cinemaCardList];
//         [_tabViewMembershipCard reloadData];
//         //隐藏加载失败效果
//         _imageLoadFailed.hidden = YES;
//         _labelDescLoadFailed.hidden = YES;
//         //没有数据
//         if ([_arrayCardTable count] <= 0)
//         {
//             [weakSelf loadFailed];
//         }
         
         if( [_arrayCardTable count] > 0 )
         {
             [weakSelf showImageWithStatus:NO isLoadSuccess:YES];
             [_tabViewMembershipCard reloadData];
         }
         else
         {
             [weakSelf showImageWithStatus:YES isLoadSuccess:YES];
         }
         
         [FVCustomAlertView hideAlertFromView:self.superview fading:YES];
     } failure:^(NSError *error) {
         _modelMember = nil;
         [weakSelf showImageWithStatus:NO isLoadSuccess:NO];
         [FVCustomAlertView hideAlertFromView:self.superview fading:YES];
         [Tool showWarningTip:error.domain time:2];
     }];
}

-(void) showImageWithStatus:(BOOL)status isLoadSuccess:(BOOL)isLoadSuccess
{
    _imageFailure.hidden = isLoadSuccess;
    _labelFailure.hidden = isLoadSuccess;
    _btnTryAgain.hidden =  isLoadSuccess;
    if (isLoadSuccess)
    {
        _imageLoadFailed.hidden = !status;
        _labelDescLoadFailed.hidden = !status;
        _tabViewMembershipCard.hidden = status;
    }
    else
    {
        _imageLoadFailed.hidden = !status;
        _labelDescLoadFailed.hidden = !status;
        _tabViewMembershipCard.hidden = !status;
    }
}


#pragma mark - TabelViewDelegate
//Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_arrayCardTable count]-1)
    {
        //获取单元格高度
        MembershipCardTableViewCell *cell = (MembershipCardTableViewCell*)[self tableView:_tabViewMembershipCard cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height+tabbarHeight+10;
    }
    else
    {
        //获取单元格高度
        MembershipCardTableViewCell *cell = (MembershipCardTableViewCell*)[self tableView:_tabViewMembershipCard cellForRowAtIndexPath:indexPath];
        return cell.contentView.frame.size.height;
    }
}

//Cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayCardTable.count;
}

//Cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MembershipCardTableViewCell";
    MembershipCardTableViewCell *cell;
    
    if (cell == nil)
    {
        cell = [[MembershipCardTableViewCell alloc] initWithReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.cardListGotoDelegate = self;
    }
    
    [cell setMembershipCardTrendsTableCellData:_arrayCardTable[indexPath.row] index:indexPath.row memberModel:_modelMember];
    
    return cell;
}

//Cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardListModel *modelCard = _arrayCardTable[indexPath.row];
    NSLog(@"%@",[modelCard toJSONString]);
    
    
    if ([modelCard.cardType intValue] == -1)
    {
        //如果是普通卡，则直接跳转到详情页
        MembershipCardDetailsViewController *membershipCardDetailsVC = [[MembershipCardDetailsViewController alloc] init];
        membershipCardDetailsVC._cardListModel = modelCard;
        membershipCardDetailsVC._cinema = _modelMember.cinema;
        [self.navigation pushViewController:membershipCardDetailsVC animated:YES];
    }
    else
    {
        //如果 cardValidEndTime 该值 > 0，则说明用户买了该卡，并且该值为过期时间，并且是可以购卡的时显示 已开通
        if ([modelCard.cardValidEndTime integerValue] > 0 && [modelCard.cardValidEndTime integerValue] > [_modelMember.currentTime integerValue])
        {
            MembershipCardDetailsViewController *membershipCardDetailsVC = [[MembershipCardDetailsViewController alloc] init];
            membershipCardDetailsVC._cardListModel = modelCard;
            membershipCardDetailsVC._cinema = _modelMember.cinema;
            [self.navigation pushViewController:membershipCardDetailsVC animated:YES];
        }
        else
        {
            BuyCardViewController *buyCardViewController = [[BuyCardViewController alloc] init];
            buyCardViewController._cardListModel = modelCard;
            buyCardViewController._cinema = _modelMember.cinema;
            [self.navigation pushViewController:buyCardViewController animated:YES];
        }

    }
//    if (indexPath.row == 0)
//    {
//        CardListModel *modelCard = _arrayCardTable[indexPath.row];
//        MembershipCardDetailsViewController *membershipCardDetailsVC = [[MembershipCardDetailsViewController alloc] init];
//        membershipCardDetailsVC._cardListModel = modelCard;
//        membershipCardDetailsVC._cinema = _modelMember.cinema;
//        [self.navigation pushViewController:membershipCardDetailsVC animated:YES];
//    }
//    else
//    {
//        CardListModel *modelCard = _arrayCardTable[indexPath.row];
//        BuyCardViewController *buyCardViewController = [[BuyCardViewController alloc] init];
//        buyCardViewController._cardListModel = modelCard;
//        buyCardViewController._cinema = _modelMember.cinema;
//        [self.navigation pushViewController:buyCardViewController animated:YES];
//    }
}

//从Cell过来的代理
-(void)cardTableViewCellSkip:(UIButton *)btn index:(NSInteger)row
{
    if (btn.tag == 1)
    {
        //点击免费开通，弹出登录页
        [MobClick event:mainViewbtn62];
        LoginViewController *loginViewController = [[LoginViewController alloc ] init];
        [self.navigation pushViewController:loginViewController animated:YES];
    }
    else
    {
        CardListModel *modelCard = _arrayCardTable[row];
        BuyCardViewController *buyCardViewController = [[BuyCardViewController alloc] init];
        buyCardViewController._cardListModel = modelCard;
        buyCardViewController._cinema = _modelMember.cinema;
        [self.navigation pushViewController:buyCardViewController animated:YES];
    }
}

#pragma mark scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>0)
    {
        if (self._lastScrollContentOffset < scrollView.contentOffset.y)
        {
            //                            NSLog(@"up:------%f\n%f",_lastScrollContentOffset,scrollView.contentOffset.y);
            //scroll向上滚动
            if (!self._isScrollTop)
            {
                if (scrollView.contentOffset.y >= 30)
                {
                    if (!self._isScrollTop)
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHHOMEUP object:nil];
                        //[self refreshFrameUp];
                    }
                }
                else if(scrollView.contentOffset.y < 30)
                {
                    self._lastScrollContentOffset = scrollView.contentOffset.y;
                }
                else
                {
                    self._lastScrollContentOffset = 30;
                }
            }
        }
        else if (self._lastScrollContentOffset > scrollView.contentOffset.y)
        {
            //scroll向下滚动
            //                            NSLog(@"down:------%f\n%f",_lastScrollContentOffset,scrollView.contentOffset.y);
            if (self._isScrollTop)
            {
                //滑到顶
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHHOMEDOWN object:nil];
//                [self refreshFrameDown];
            }
            self._lastScrollContentOffset = scrollView.contentOffset.y;
        }
    }
    else if (scrollView.contentOffset.y<0)
    {
        //scroll向下滚动
        if (self._isScrollTop)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHHOMEDOWN object:nil];
        }
        self._lastScrollContentOffset = scrollView.contentOffset.y;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_REFRESHCARD];
}

@end
