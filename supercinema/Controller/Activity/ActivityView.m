//
//  ActivityView.m
//  supercinema
//
//  Created by dust on 16/11/18.
//
//

#import "ActivityView.h"
#import "ActivityCenterWebViewController.h"

@implementation ActivityView

#define CELL_WIDTH SCREEN_WIDTH * 0.8

-(id)initWithFrame:(CGRect)frame navigation:(UINavigationController *)navigation
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _arrayActivity = [[NSMutableArray alloc ] initWithCapacity:0];
        frameHeight = frame.size.height;
        self._navigationController = navigation;
        
        //当前活动
        _arrCurrentActivity = [[NSMutableArray alloc] init];
        //往期活动
        _arrOverdueActivity = [[NSMutableArray alloc] init];
        [self initialize];

        [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(loadActityData) name:NOTIFITION_REFRESHACTIVITY object:nil];
    }
    return self;
}

//初始化
-(void)initialize
{
    self.backgroundColor = RGBA(246, 246, 251, 1);
    
    //整体的Tab
    _tableViewActive = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frameHeight)];
    _tableViewActive.backgroundColor = RGBA(246, 246, 251, 1);
    [_tableViewActive setSeparatorColor:[UIColor clearColor]];//隐藏线
    _tableViewActive.delegate = self;
    _tableViewActive.dataSource = self;
    [self addSubview:_tableViewActive];
    
    //============================异常状态控件=================================
    CGFloat imageViewWidth = 611/2;
    CGFloat imageViewHeight = 840/2;
    imageViewWidth = SCREEN_WIDTH/375 * imageViewWidth;
    imageViewHeight = SCREEN_WIDTH/375 * imageViewHeight;
    CGFloat imageViewX = (self.frame.size.width - imageViewWidth)/2;
    CGFloat imageViewY = (self.frame.size.height - imageViewHeight - tabbarHeight)/2;
    
    //没有活动
    _imageView = [[UIImageView alloc ] initWithFrame:CGRectMake(imageViewX, imageViewY,  imageViewWidth, imageViewHeight)];
    [_imageView setImage:[UIImage imageNamed:@"image_NoDataActivity.png"]];
    _imageView.hidden = YES;
    _imageView.userInteractionEnabled = YES;//图片可以响应点击事件
    [self addSubview:_imageView];
    
    float fTextY = 0;
    if (IPhone5)
    {
        fTextY = 185;
    }
    else if (IPhone6)
    {
        fTextY = 225;
    }
    else
    {
        fTextY = 250;
    }
    
    UILabel *labelNOActivity = [[UILabel alloc]initWithFrame:CGRectMake((imageViewWidth-130)/2, fTextY, 130, 14)];
    [labelNOActivity setBackgroundColor:[UIColor clearColor]];
    [labelNOActivity setFont:MKFONT(14)];
    [labelNOActivity setTextColor:RGBA(255, 255, 255, 1)];
    [labelNOActivity setText:@"暂无活动"];
    [labelNOActivity setTextAlignment:NSTextAlignmentCenter];
    [_imageView addSubview:labelNOActivity];
    
    UIButton *btnGoToLookMovie = [[UIButton alloc] initWithFrame:CGRectMake((imageViewWidth-130)/2, labelNOActivity.frame.origin.y+labelNOActivity.frame.size.height+8, 130, 30)];
    [btnGoToLookMovie setBackgroundColor:[UIColor clearColor]];
    [btnGoToLookMovie setTitle:@"去看场电影吧" forState:UIControlStateNormal];
    [btnGoToLookMovie setTitleColor:RGBA(253, 189, 34, 1) forState:UIControlStateNormal];//按钮文字颜色
    [btnGoToLookMovie .titleLabel setFont:MKFONT(14)];//按钮字体大小
    [btnGoToLookMovie.layer setCornerRadius:15.f];//按钮设置圆角
    btnGoToLookMovie.layer.borderWidth = 1;//边框宽度
    btnGoToLookMovie.layer.borderColor = [RGBA(253, 189, 34, 1) CGColor];//边框颜色
    btnGoToLookMovie.tag = 100;
    [btnGoToLookMovie addTarget:self action:@selector(onButtonGoToLookMovie:) forControlEvents:UIControlEventTouchUpInside];
    [_imageView addSubview:btnGoToLookMovie];
    
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

    //============================异常状态控件=================================
}

//从Cell过来的代理
-(void)openJoinDetails:(ActivityModel*)model
{
    NSLog(@"%@",[model toJSONString]);
    
    ActivityDetailsViewController *activityDetailsVC = [[ActivityDetailsViewController alloc] init];
    activityDetailsVC._activityModel = model;
    [self._navigationController pushViewController:activityDetailsVC animated:YES];
}

#pragma mark 点击头像 - 跳转到个人中心 & 他人个人中心
-(void)pushUserOrOtherCenterViewController:(NSString *)userId
{
    /*
     *  需要判断第一次进入的时候用户ID为nil的情况吗？
     *  如果没有登录，点击的时候要登录吗？
     */
    if([Config getLoginState])
    {
        //登录
        if ([userId intValue]  == [[Config getUserId] intValue])
        {
            //如果选择的是自己，则跳转到个人中心
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate switchTab:2];
            [self._navigationController popToRootViewControllerAnimated:NO];
        }
        else
        {
            //如果选中的是他人，则跳转到他人个人中心
            OtherCenterViewController* vc = [[OtherCenterViewController alloc]init];
            vc._strUserId = userId;
            [self._navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        //未登录 （跳转到登录）
        if ([Config getUserId] == nil)
        {
            LoginViewController *loginControlller = [[LoginViewController alloc ] init];
            [self._navigationController pushViewController:loginControlller animated:YES];
        }
        else
        {
            if ([userId intValue]  == [[Config getUserId] intValue])
            {
                //如果选择的是自己，则跳转到个人中心
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [self showLoginController:param controllerName:@"UserCenterViewController"];
            }
            else
            {
                //如果选中的是他人，则跳转到他人个人中心
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [param setObject:[NSString stringWithFormat:@"%@", userId] forKey:@"_strUserId"];
                [self showLoginController:param controllerName:@"OtherCenterViewController"];
            }
        }
    }
}

//弹出登录
-(void)showLoginController:(NSMutableDictionary *)param controllerName:(NSString *)name
{
    LoginViewController *loginControlller = [[LoginViewController alloc ] init];
    loginControlller.param = param;
    loginControlller._strTopViewName = name;
    [self._navigationController pushViewController:loginControlller animated:YES];
}

#pragma mark TableViewDelegate
//Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只存在有效的活动
    if([_arrOverdueActivity count] == 0 && [_arrCurrentActivity count] > 0)
    {
        //只有有效
        if (indexPath.row == 0)
        {
            //如果是第一行
            return 333+10;
        }
        else if(indexPath.row == [_arrCurrentActivity count]-1)
        {
            return 230.5+10+tabbarHeight+10;
        }
        else
        {
            return 230.5+10;
        }
    }
    if([_arrOverdueActivity count] > 0 && [_arrCurrentActivity count] == 0)
    {
        //只有往期
        if (indexPath.row == 0)
        {
            //分割行
            return 49;
        }
        else if (indexPath.row == [_arrOverdueActivity count])
        {
            //最后一行
            return 214.5+10+tabbarHeight+10;
        }
        else
        {
            //往期
            return 214.5+10;
        }
    }
    if([_arrOverdueActivity count] > 0 && [_arrCurrentActivity count] > 0)
    {
        if (indexPath.row == 0)
        {
            //如果是第一行
            return 333+10;
        }
        else if (indexPath.row > 0 && indexPath.row < [_arrCurrentActivity count])
        {
            return 230.5+10;
        }
        else if (indexPath.row == [_arrCurrentActivity count])
        {
            //分割行
            return 49;
        }
        else if (indexPath.row == [_arrCurrentActivity count]+[_arrOverdueActivity count])
        {
            //最后一行
            return 214.5+10+tabbarHeight+10;
        }
        else
        {
            //往期
            return 214.5+10;
        }
    }
    return 0;
}

//Cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //只存在有效的活动
    if([_arrOverdueActivity count] == 0 && [_arrCurrentActivity count] > 0)
    {
        //只有有效
       return _arrCurrentActivity.count;
    }
    if([_arrOverdueActivity count] > 0 && [_arrCurrentActivity count] == 0)
    {
        //只有往期
        return _arrOverdueActivity.count+1;
    }
    if([_arrOverdueActivity count] > 0 && [_arrCurrentActivity count] > 0)
    {
        return _arrCurrentActivity.count+_arrOverdueActivity.count+1;
    }
    return 0;
}

//Cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier= @"ActivityTableViewCell";
    ActivityTableViewCell *activityCell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];;

    [activityCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if([_arrOverdueActivity count] == 0 && [_arrCurrentActivity count] > 0)
    {
        //只有有效
        ActivityModel *activityModel = [_arrCurrentActivity objectAtIndex:indexPath.row];
        activityCell.activityDelegate = self;
        
        [activityCell setCurrentActivityCellFrameAndData:activityModel indexPath:indexPath.row];
        return activityCell;
    }
    
    if([_arrOverdueActivity count] > 0 && [_arrCurrentActivity count] == 0)
    {
        //只有往期
        if (indexPath.row == 0)
        {
            //分割行
            [activityCell setOverdueSegmentationLine];
            return activityCell;
        }
        else
        {
            ActivityModel *activityModel = [_arrOverdueActivity objectAtIndex:indexPath.row-1];
            activityCell.activityDelegate = self;
            [activityCell setOverdueActivityCellFrameAndData:activityModel];
            return activityCell;
        }
    }
    
    if([_arrOverdueActivity count] > 0 && [_arrCurrentActivity count] > 0)
    {
        ActivityModel *activityModel = [[ActivityModel alloc ] init];//[_arrOverdueActivity objectAtIndex:indexPath.row];
        activityCell.activityDelegate = self;
        
        //既有有效也有往期
        if (indexPath.row == 0)
        {
            //第一行显示有效
            activityModel = [_arrCurrentActivity objectAtIndex:indexPath.row];
            [activityCell setCurrentActivityCellFrameAndData:activityModel indexPath:indexPath.row];
            return activityCell;
        }
        else if (indexPath.row > 0 && indexPath.row < [_arrCurrentActivity count])
        {
            //有效
            activityModel = [_arrCurrentActivity objectAtIndex:indexPath.row];
            [activityCell setCurrentActivityCellFrameAndData:activityModel indexPath:indexPath.row];
            return activityCell;
        }
        else if (indexPath.row == [_arrCurrentActivity count])
        {
            //分割线
            [activityCell setOverdueSegmentationLine];
            return activityCell;
        }
        else
        {
            //往期
//            NSLog(@"%ld  %ld",indexPath.row,[_arrCurrentActivity count]);
            activityModel = [_arrOverdueActivity objectAtIndex:indexPath.row- [_arrCurrentActivity count]-1];
            [activityCell setOverdueActivityCellFrameAndData:activityModel];
            return activityCell;
        }
    }
    return activityCell;
}

#pragma mark 凑热闹跳转到看电影
-(void)onButtonGoToLookMovie:(UIButton *)sender
{
    if ([self.activityViewDelegate respondsToSelector:@selector(ActivityJumpLookMovie:)])
    {
        [self.activityViewDelegate ActivityJumpLookMovie:sender];
    }
}

#pragma mark 清理缓存数据
-(void)removeAllObjectsActivity
{
    if(_arrayActivity != nil && _arrayActivity.count > 0)
    {
        [_arrayActivity removeAllObjects];
    }
    
    if(_arrCurrentActivity != nil && _arrCurrentActivity.count > 0)
    {
        [_arrCurrentActivity removeAllObjects];
    }
    if(_arrOverdueActivity != nil && _arrOverdueActivity.count > 0)
    {
        [_arrOverdueActivity removeAllObjects];
    }
    
    self.activityId = nil;
}

-(void)loadActityData
{
    [self reloadActityData];
}

#pragma mark 重新加载
-(void)onButtonTryAgain
{
    [self reloadActityData];
}

#pragma mark 加载数据
-(void)reloadActityData
{
    __weak ActivityView *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.window withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServiceActivity getActivityListByCinemaId:[NSString stringWithFormat:@"%@",[Config getCinemaId]] array:^(ActivityListModel *model)
    {
        _arrayActivity = [[NSMutableArray alloc ] initWithArray:model.activityList];
        //遍历区分活动
        [weakself setTraverseListSeparationActivity:model.activityList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableViewActive reloadData];
        });
        
        if( [_arrayActivity count] > 0 )
        {
            [weakself showImageWithStatus:NO isLoadSuccess:YES];
//            [_tableViewActive reloadData];
            
//            if(weakself.activityId != nil)
//            {
//                weakself.activityId = nil;
//            }
        }
        else
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHHOMEUP object:nil];
            [weakself showImageWithStatus:YES isLoadSuccess:YES];
        }
        [FVCustomAlertView hideAlertFromView:weakself.window fading:YES];
        
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:weakself.window fading:YES];
        [Tool showWarningTip:error.domain time:2];
        [weakself showImageWithStatus:NO isLoadSuccess:NO];
        
    }];
}

#pragma mark 遍历区分 当前活动
-(void)setTraverseListSeparationActivity:(NSArray *)arrActList
{
    [_arrCurrentActivity removeAllObjects ];
    [_arrOverdueActivity removeAllObjects ];
    
    for (ActivityModel *activityModel in arrActList)
    {
        //添加相应活动到数组中 activityValidType（0:往期活动 1:有效活动）
        if ([activityModel.activityValidType intValue] == 1)
        {
            //当前活动
            [_arrCurrentActivity addObject:activityModel];
        }
        else
        {
            //往期活动
            [_arrOverdueActivity addObject:activityModel];
        }
    }
    
    NSLog(@"%lu",(unsigned long)_arrCurrentActivity.count);
    NSLog(@"%lu",(unsigned long)_arrOverdueActivity.count);
    
}

-(void) showImageWithStatus:(BOOL)status isLoadSuccess:(BOOL)isLoadSuccess
{
    _imageFailure.hidden = isLoadSuccess;
    _labelFailure.hidden = isLoadSuccess;
    _btnTryAgain.hidden =  isLoadSuccess;
    if (isLoadSuccess)
    {
        _imageView.hidden = !status;
        _tableViewActive.hidden = status;
    }
    else
    {
        _imageView.hidden = !status;
        _tableViewActive.hidden = !status;
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
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_REFRESHACTIVITY];
}

@end


