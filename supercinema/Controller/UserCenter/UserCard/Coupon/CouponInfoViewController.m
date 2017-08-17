//
//  CouponInfoViewController.m
//  supercinema
//
//  Created by mapollo91 on 26/11/16.
//
//

#import "CouponInfoViewController.h"

@interface CouponInfoViewController ()

@end

@implementation CouponInfoViewController

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
    //每次进入都重新刷新有效，失效列表
//    [self loadAllValidCoupon];
//    [self loadAllPastDueCoupon];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _iCurrentPageNumber = 0;
    _quantity = 0;
    _orderType = 0;
    boolDeleteButtonShow = NO;
    _couponAllValidModel = [[CouponModel alloc] init];
    _couponAllPastDueModel = [[CouponModel alloc] init];
    _arrayAllValid = [[NSMutableArray alloc] init];
    _arrayAllPastDue = [[NSMutableArray alloc] init];
    _arrDelete = [[NSMutableArray alloc] init];
    
    //需要加载失效列表（默认）
    isLoadAllPastDueCoupon = YES;
    [self initController];
    //加载有效列表（需求：加载默认列表内数据，切换其它列表才加载）
    [self loadAllValidCoupon];
}

-(void)initController
{
    self._labelTitle.text = @"优惠券";
    self._labelLine.hidden = YES;
    
    //删除按钮状态
    _btnDeleteType = [[UIButton alloc] initWithFrame: CGRectMake(SCREEN_WIDTH-15-21, 27, 21, 21.5)];//21
    [_btnDeleteType setBackgroundColor:[UIColor clearColor]];
    [_btnDeleteType setImage:[UIImage imageNamed:@"btn_orderDelete.png"] forState:UIControlStateNormal];
    [_btnDeleteType.titleLabel setFont:MKFONT(15)];
    [_btnDeleteType setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    _btnDeleteType.tag = 300;
    [_btnDeleteType addTarget:self action:@selector(onButtonDeleteType:) forControlEvents:UIControlEventTouchUpInside];
    [_btnDeleteType setHidden:YES];
    [self.view addSubview:_btnDeleteType];
    
    //按钮下方的白色背景
    UILabel *labelBtnBG = [[UILabel alloc]initWithFrame:CGRectMake(0, self._viewTop.frame.origin.y+self._viewTop.frame.size.height, SCREEN_WIDTH, 42)];
    [labelBtnBG setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:labelBtnBG];
    
    //有效按钮
    _btnEffective = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6,self._viewTop.frame.origin.y+self._viewTop.frame.size.height, SCREEN_WIDTH/3, 42)];
    [_btnEffective setTitle:@"有效券" forState:UIControlStateNormal];
    _btnEffective.backgroundColor = [UIColor whiteColor];
    [_btnEffective.titleLabel setFont:MKFONT(15) ];
    [_btnEffective setTitleColor:RGBA(117, 112, 255,1) forState:UIControlStateNormal];
    _btnEffective.tag = 0;
    [_btnEffective addTarget:self action:@selector(onButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnEffective];
    
    //失效按钮
    _btnFailure = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6+_btnEffective.frame.size.width,_btnEffective.frame.origin.y, SCREEN_WIDTH/3, 42)];
    [_btnFailure setTitle:@"失效券" forState:UIControlStateNormal];
    _btnFailure.backgroundColor = [UIColor whiteColor];
    [_btnFailure.titleLabel setFont:MKFONT(15) ];
    [_btnFailure setTitleColor:RGBA(0, 0, 0, 1) forState:UIControlStateNormal];
    _btnFailure.tag = 1;
    [_btnFailure addTarget:self action:@selector(onButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnFailure];
    
    //按钮下蓝色线
    _viewLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4.8, _btnEffective.frame.origin.y+_btnEffective.frame.size.height-2, SCREEN_WIDTH/4, 1)];
    [_viewLine setBackgroundColor:RGBA(117, 112, 255,1)];
    [self.view addSubview:_viewLine];
    
    //按钮下方的阴影线
    UILabel *lableCutLine = [[UILabel alloc] initWithFrame:CGRectMake(0, _viewLine.frame.origin.y+_viewLine.frame.size.height, SCREEN_WIDTH, 1)];
    [lableCutLine setBackgroundColor: RGBA(0, 0, 0, 0.05) ];
    [self.view addSubview:lableCutLine];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lableCutLine.frame.origin.y+lableCutLine.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-64-_btnEffective.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [_scrollView setBackgroundColor:RGBA(246, 246, 251,1)];
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH*2, _scrollView.frame.size.height)];
    
    //有效View
    _viewEffective = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.frame.size.height)];
    [_viewEffective setBackgroundColor:[UIColor clearColor]];
    _viewEffective.tag = 1000;
    [_scrollView addSubview:_viewEffective];
    [self showList:_viewEffective type:0];
    
    //失效View
    _viewFailure = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.frame.size.height)];
    [_viewFailure setBackgroundColor:[UIColor clearColor]];
    _viewFailure.tag = 1001;
    [_scrollView addSubview:_viewFailure];
    [self showList:_viewFailure type:1];

    //确认删除按钮
    _viewConfirmDeleteBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    _viewConfirmDeleteBG.backgroundColor = RGBA(255, 255, 255, 1);
    [self.view addSubview:_viewConfirmDeleteBG];
    
    _btnConfirmDelete = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-15*2, 40)];
    [_btnConfirmDelete setBackgroundColor:RGBA(0, 0, 0, 0.5)];
    _btnConfirmDelete.enabled = NO;
    [_btnConfirmDelete setTitle:@"删除" forState:UIControlStateNormal];
    [_btnConfirmDelete setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    [_btnConfirmDelete.titleLabel setFont:MKFONT(15)];//按钮字体大小
    [_btnConfirmDelete.layer setCornerRadius:20.f];//按钮设置圆角
    [_btnConfirmDelete addTarget:self action:@selector(onButtonConfirmDelete) forControlEvents:UIControlEventTouchUpInside];
    [_viewConfirmDeleteBG addSubview:_btnConfirmDelete];
    _viewConfirmDeleteBG.hidden = YES;
}

#pragma mark - 切换按钮事件
-(void)onButtonTouch:(UIButton*)btn
{
    if(btn.tag == 0)
    {
        //点中有效
        [MobClick event:myCenterViewbtn39];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [_btnEffective setTitleColor:RGBA(117, 112, 255,1) forState:UIControlStateNormal];
        [_btnFailure setTitleColor:RGBA(0, 0, 0,1) forState:UIControlStateNormal];
        [_btnDeleteType setHidden:YES];
//        [self loadAllValidCoupon];
    }
    else
    {
        //点中失效
        [MobClick event:myCenterViewbtn41];
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        [_btnEffective setTitleColor:RGBA(0, 0, 0,1) forState:UIControlStateNormal];
        [_btnFailure setTitleColor:RGBA(117, 112, 255,1) forState:UIControlStateNormal];
        if (isLoadAllPastDueCoupon == YES)
        {
            //加载失效列表（需求：在当前页内，再次点击切换页签不在加载数据。每个列表仅加载一次）
            isLoadAllPastDueCoupon = NO;
            [self loadAllPastDueCoupon];
        }
        
        if (_arrayAllPastDue != nil && _arrayAllPastDue.count > 0)
        {
            [_btnDeleteType setHidden:NO];
        }
        else
        {
            [_btnDeleteType setHidden:YES];
        }
    }
    
    _viewConfirmDeleteBG.hidden = YES;
    boolDeleteButtonShow = NO;
    _btnDeleteType.frame = CGRectMake(SCREEN_WIDTH-15-21, 27, 21, 21.5);
    _tableviewAllPastDue.frame = CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.frame.size.height);
    
    [_btnDeleteType setImage:[UIImage imageNamed:@"btn_orderDelete.png"] forState:UIControlStateNormal];
    [_btnDeleteType setTitle:@"" forState:UIControlStateNormal];
    _btnDeleteType.tag = 300;
    
    [_tableviewAllPastDue reloadData];
    
    CGRect btnLineViewFrame = _viewLine.frame;
    btnLineViewFrame.origin.x = btn.frame.origin.x + SCREEN_WIDTH/22;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_viewLine setFrame:btnLineViewFrame];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - 切换 有效 & 失效 列表
-(void)showList:(UIView*)view type:(int)type
{
    if (type == 0)
    {
        //有效
        _tableviewAllValid = [[UITableView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, view.frame.size.height) style:UITableViewStylePlain];
        [_tableviewAllValid setSeparatorColor:[UIColor clearColor]];//隐藏TableView线的颜色
        _tableviewAllValid.delegate = self;
        _tableviewAllValid.dataSource = self;
        [_tableviewAllValid setBackgroundColor:RGBA(246, 246, 251,1)];
        [view addSubview:_tableviewAllValid];
//        [self loadAllValidCoupon];
    }
    if (type == 1)
    {
        //失效
        _tableviewAllPastDue = [[UITableView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, view.frame.size.height) style:UITableViewStylePlain];
        [_tableviewAllPastDue setSeparatorColor:[UIColor clearColor]];//隐藏TableView线的颜色
        _tableviewAllPastDue.delegate = self;
        _tableviewAllPastDue.dataSource = self;
        [_tableviewAllPastDue setBackgroundColor:RGBA(246, 246, 251,1)];
        [view addSubview:_tableviewAllPastDue];
//        [self loadAllPastDueCoupon];
    }
}

#pragma mark - 加载 有效列表
-(void)loadAllValidCoupon
{
    __weak CouponInfoViewController *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesCardPack getUserCouponList:[NSNumber numberWithInt:0] model:^(CouponModel *model)
    {
        _couponAllValidModel = model;
        _arrayAllValid = [[NSMutableArray alloc] initWithArray:_couponAllValidModel.commonList];
    
        //没有数据
        if ([_arrayAllValid count] <= 0)
        {
            //有效列表
            [weakself loadFailedIsValidParentView:_viewEffective isFailedShow:1];
        }
        else
        {
            [weakself loadFailedIsValidParentView:_viewEffective isFailedShow:2];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableviewAllValid reloadData];
        });
        
        [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
        
    } failure:^(NSError *error) {
        //有效列表
        [_arrayAllValid removeAllObjects];
        [weakself loadFailedIsValidParentView:_viewEffective isFailedShow:3];
        [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
        [Tool showWarningTip:error.domain time:1.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableviewAllValid reloadData];
        });
    }];
}

#pragma mark - 加载 失效列表
-(void)loadAllPastDueCoupon
{
    __weak CouponInfoViewController *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesCardPack getUserCouponList:[NSNumber numberWithInt:1] model:^(CouponModel *model)
    {
        _couponAllPastDueModel = model;
        
        for (CommonListModel *commonListModel in _couponAllPastDueModel.commonList)
        {
            commonListModel.isDelete = [NSNumber numberWithInt:1];
        }
        _arrayAllPastDue = [[NSMutableArray alloc] initWithArray:_couponAllPastDueModel.commonList];
        
        //没有数据
        if ([_arrayAllPastDue count] <= 0)
        {
            //失效列表
            [weakself loadFailedIsValidParentView:_viewFailure isFailedShow:1];
//            [_btnDeleteType setHidden:NO];
        }
        else
        {
            [weakself loadFailedIsValidParentView:_viewFailure isFailedShow:2];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableviewAllPastDue reloadData];
            
        });
        
        [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
        
    } failure:^(NSError *error) {
        //失效列表
        [_arrayAllPastDue removeAllObjects];
        [weakself loadFailedIsValidParentView:_viewFailure isFailedShow:3];
        [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
        [Tool showWarningTip:error.domain time:1.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableviewAllPastDue reloadData];
        });
    }];
}

#pragma mark 加载失败 显示UI
-(void)loadFailedIsValidParentView:(UIView *)parentView isFailedShow:(int)isFailedShow
{
    /*
     *  isFailedShow
     *  1 : 请求成功 没有数据
     *  2 : 请求成功 有数据
     *  3 : 请求没成功
     */
    if(parentView == nil)
        return;
    
    int imageLoadFailedTag = 123;
    int labelDescLoadFailedTag = 456;
    int btnTryAgainTag = 789;
    
    //失败默认图
    UIImageView *imageLoadFailed = [parentView viewWithTag:imageLoadFailedTag];
    if(imageLoadFailed != nil){
        [imageLoadFailed removeFromSuperview];
    }
    imageLoadFailed = [[UIImageView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH/2-(146/4),self._viewTop.frame.size.height+ 200/2, 146/2, 134/2)];
    [imageLoadFailed setImage:[UIImage imageNamed:@"image_NoDataOrder.png"]];
    [imageLoadFailed setTag:imageLoadFailedTag];
    [parentView addSubview:imageLoadFailed];
    if (isFailedShow == 1 || isFailedShow == 3)
    {
        imageLoadFailed.hidden = NO;
    }
    else
    {
        imageLoadFailed.hidden = YES;
    }
    
    //加载默认文字
    UILabel *labelDescLoadFailed = [parentView viewWithTag:labelDescLoadFailedTag];
    if(labelDescLoadFailed != nil){
        [labelDescLoadFailed removeFromSuperview];
    }
    labelDescLoadFailed = [[UILabel alloc ] initWithFrame:CGRectMake(0, imageLoadFailed.frame.origin.y+imageLoadFailed.frame.size.height+15, SCREEN_WIDTH, 14)];
    [labelDescLoadFailed setTag:labelDescLoadFailedTag];
    [labelDescLoadFailed setTextColor:RGBA(96, 94, 134, 1)];
    [labelDescLoadFailed setTextAlignment:NSTextAlignmentCenter];
    [labelDescLoadFailed setFont:MKFONT(14)];
    [parentView addSubview:labelDescLoadFailed];
    if (isFailedShow == 1)
    {
        labelDescLoadFailed.hidden = NO;
        [labelDescLoadFailed setText:@"暂无优惠券"];
    }
    else if (isFailedShow == 2)
    {
        labelDescLoadFailed.hidden = YES;
    }
    else
    {
        labelDescLoadFailed.hidden = NO;
        [labelDescLoadFailed setText:@"加载失败"];
    }

    //重新加载按钮
    UIButton *btnTryAgain = [parentView viewWithTag:btnTryAgainTag];
    if(btnTryAgain != nil){
        [btnTryAgain removeFromSuperview];
    }
    btnTryAgain = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-146/2)/2, labelDescLoadFailed.frame.origin.y+labelDescLoadFailed.frame.size.height+25, 146/2, 24)];
    [btnTryAgain setTitle:@"重新加载" forState:UIControlStateNormal];
    [btnTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTryAgain.titleLabel.font = MKFONT(14);
    btnTryAgain.backgroundColor = RGBA(117, 112, 255, 1);
    btnTryAgain.layer.masksToBounds = YES;
    btnTryAgain.layer.cornerRadius = btnTryAgain.frame.size.height/2;
    [btnTryAgain setTag:btnTryAgainTag];
    //用来传递所在tab的值；0是有效列表，1是无效列表
    NSInteger tableTypeInteger = parentView.tag - 1000;
    objc_setAssociatedObject(btnTryAgain, "tableType", [NSNumber numberWithInteger:tableTypeInteger], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [btnTryAgain addTarget:self action:@selector(onButtonTryAgainList:) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:btnTryAgain];
    if (isFailedShow == 3)
    {
        btnTryAgain.hidden = NO;
    }
    else
    {
        btnTryAgain.hidden = YES;
    }
}

#pragma mark 重新加载按钮
-(void)onButtonTryAgainList:(UIButton *)sender
{
    id tableType = objc_getAssociatedObject(sender, "tableType");
    if([tableType integerValue] == 0)
    {
        //点中有效
        [self loadAllValidCoupon];
        [_tableviewAllValid reloadData];
    }
    else
    {
        //点中失效
        [self loadAllPastDueCoupon];
        
        if (_arrayAllPastDue != nil && _arrayAllPastDue.count > 0)
        {
            [_btnDeleteType setHidden:NO];
        }
        else
        {
            [_btnDeleteType setHidden:YES];
        }
        [_tableviewAllPastDue reloadData];
    }
}

#pragma mark - 删除按钮
-(void)onButtonDeleteType:(UIButton*)button
{
    NSLog(@"点击了删除按钮");
    if (button.tag == 300)
    {
        _btnDeleteType.frame = CGRectMake(SCREEN_WIDTH-15-34, 28, 34, 21.5);
        button.tag = 301;
        [button setImage:nil forState:UIControlStateNormal];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        boolDeleteButtonShow = YES;
        _viewConfirmDeleteBG.hidden = NO;
        
        _tableviewAllPastDue.frame = CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.frame.size.height-60);
    }
    else
    {
        _btnDeleteType.frame = CGRectMake(SCREEN_WIDTH-15-21, 27, 21, 21.5);
        button.tag = 300;
        [button setImage:[UIImage imageNamed:@"btn_orderDelete.png"] forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
        boolDeleteButtonShow = NO;
        _viewConfirmDeleteBG.hidden = YES;
        
        _tableviewAllPastDue.frame = CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.frame.size.height);
        if (_arrayAllPastDue != nil && _arrayAllPastDue.count >0)
        {
            for (CommonListModel *_commonListModel in _arrayAllPastDue)
            {
                if(_commonListModel.isDelete.integerValue == 0){
                    _commonListModel.isDelete = [NSNumber numberWithInteger:1];
                }
            }
        }
        
        //清理删除数据集
        if(_arrDelete != nil && _arrDelete.count > 0){
            [_arrDelete removeAllObjects];
        }
    }
    
    [_btnConfirmDelete setBackgroundColor:RGBA(0, 0, 0, 0.5)];
    _btnConfirmDelete.enabled = NO;
    
    [_tableviewAllPastDue reloadData];
}

//立即删除
-(void)onButtonConfirmDelete
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"真的要删除这些失效券嘛~？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        __weak CouponInfoViewController *weakself = self;
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
        [ServicesCardPack deleteCoupon:_arrDelete model:^(RequestResult *model)
        {
            [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
            
            [_btnConfirmDelete setBackgroundColor:RGBA(0, 0, 0, 0.5)];
            _btnConfirmDelete.enabled = NO;
            
            [_arrDelete removeAllObjects];
             //删除成功后，刷新失效列表
             [weakself loadAllPastDueCoupon];
            
        } failure:^(NSError *error) {
            [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
        }];
    }
}

#pragma mark - TableViewDelegate
//Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //2:则是线下优惠券; 3:成长赠送的礼品; 5:票红包; 6:会员卡红包; 7:小卖红包; 8:商家优惠券; 9:通票；
    if (tableView == _tableviewAllValid)
    {
        //有效
        CommonListModel *_commonListModel = _arrayAllValid[indexPath.row];
        if ([_commonListModel.dataType intValue] == 5 ||
            [_commonListModel.dataType intValue] == 6 ||
            [_commonListModel.dataType intValue] == 7 ||
            [_commonListModel.dataType intValue] == 9 )
        {
            //票红包；会员卡红包；小卖红包；通票
            if (indexPath.row == _arrayAllValid.count)
            {
                //最后一行的时候
                return 10+100+10;
            }
            return 10+100;
        }
        else
        {
            //线下优惠券；商家优惠券；成长赠送的礼品
            if (indexPath.row == _arrayAllValid.count)
            {
                //最后一行的时候
                return 10+120+10;
            }
            return 10+120;
        }
    }
    else
    {
        //失效
        CommonListModel *_commonListModel = _arrayAllPastDue[indexPath.row];
        if ([_commonListModel.dataType intValue] == 5 ||
            [_commonListModel.dataType intValue] == 6 ||
            [_commonListModel.dataType intValue] == 7 ||
            [_commonListModel.dataType intValue] == 9 )
        {
            //票红包；会员卡红包；小卖红包；通票
            if (indexPath.row == _arrayAllPastDue.count)
            {
                //最后一行的时候
                return 10+100+10;
            }
            return 10+100;
        }
        else
        {
            //线下优惠券；商家优惠券；成长赠送的礼品
            if (indexPath.row == _arrayAllValid.count)
            {
                //最后一行的时候
                return 10+120+10;
            }
            return 10+120;
        }
    }
}

//Cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableviewAllValid)
    {
        //有效
        return _arrayAllValid.count;
    }
    else
    {
        //失效
        return _arrayAllPastDue.count;
    }
}

//Cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //有效
    if (tableView == _tableviewAllValid)
    {
        CouponInfoTableViewCell *couponInfoCell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (couponInfoCell == nil)
        {
            couponInfoCell = [[CouponInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            couponInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            couponInfoCell.couponInfoDelegate = self;
        }
        //优惠券Cell
        CommonListModel *_commonListModel = _arrayAllValid[indexPath.row];
        [couponInfoCell setCouponInfoCellFrameDataCommonListModel:_commonListModel index:indexPath.row boolDeleteButtonShow:boolDeleteButtonShow isPastDue:NO];
        
        return couponInfoCell;
    }
    //失效
    if (tableView == _tableviewAllPastDue)
    {

        CouponInfoTableViewCell *couponInfoCell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (couponInfoCell==nil)
        {
            couponInfoCell = [[CouponInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            couponInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            couponInfoCell.couponInfoDelegate = self;
        }
        //优惠券Cell
        CommonListModel *_commonListModel = _arrayAllPastDue[indexPath.row];
        [couponInfoCell setCouponInfoCellFrameDataCommonListModel:_commonListModel index:indexPath.row boolDeleteButtonShow:boolDeleteButtonShow isPastDue:YES];
        
        return couponInfoCell;
    }
    return cell;
}

//Cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tempDatas = nil;
    //有效
    if (tableView == _tableviewAllValid)
    {
        tempDatas = _arrayAllValid;
        _orderType = 0;
    }
    //失效
    if (tableView == _tableviewAllPastDue)
    {
        tempDatas = _arrayAllPastDue;
        _orderType = 1;
    }
    
    if(tempDatas == nil)
        return;
    
    if(boolDeleteButtonShow){
    
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *delBtn = (UIButton *)[cell viewWithTag:1234567];
        [delBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        [FVCustomAlertView showDefaultLoadingAlertOnView:[UIApplication sharedApplication].keyWindow withTitle:@"加载中..." withBlur:NO allowTap:NO];
        CommonListModel *_commonListModel = tempDatas[indexPath.row];
        
        //2:则是线下优惠券; 3:成长赠送的礼品; 5:票红包; 6:会员卡红包; 7:小卖红包; 8:商家优惠券; 9:通票；
        __weak typeof (self) weakSelf = self;
        if ([_commonListModel.dataType intValue] == 2 ||
            [_commonListModel.dataType intValue] == 3 ||
            [_commonListModel.dataType intValue] == 8 )
        {
            //优惠券
            [ServicesOrder getCouponInfoNew:_commonListModel.couponInfo.couponId couponType:_commonListModel.dataType model:^(CouponInfoModel *model)
             {
                 
                 [weakSelf showReceiveCouponView:model commonListModel:_commonListModel type:[_commonListModel.dataType intValue]];
                 [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
             } failure:^(NSError *error) {
                 [Tool showWarningTip:error.domain time:2];
                 [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
             }];
        }
        else if ([_commonListModel.dataType intValue] == 5 ||
                 [_commonListModel.dataType intValue] == 6 ||
                 [_commonListModel.dataType intValue] == 7 )
        {
            //红包
            //从红包列表中把剩余红包数量传人红包详情中
            _quantity = _commonListModel.couponInfo.quantity;
            [ServicesRedPacket getRedPacketDetail:_commonListModel.couponInfo.couponId model:^(RedPacketModel *model)
             {
                 [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
                 [weakSelf showReceiveRedPacketView:model type:[_commonListModel.dataType intValue]];
                 
             } failure:^(NSError *error) {
                 [Tool showWarningTip:error.domain time:2];
                 [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
             }];
        }
        else if ([_commonListModel.dataType intValue] == 9)
        {
            //通票
            [ServicesOrder getTongPiaoDetail:_commonListModel.cardInfo.id model:^(TongPiaoInfoModel *model)
             {
                 [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
                 [weakSelf showReceiveExchangeVoucherView:model type:[_commonListModel.dataType intValue]];
                 
             } failure:^(NSError *error) {
                 [Tool showWarningTip:error.domain time:2];
                 [FVCustomAlertView hideAlertFromView:[UIApplication sharedApplication].keyWindow fading:YES];
             }];
        }
        else
        {
        
        }
        
    }

}

#pragma mark - 显示优惠券详情view
-(void)showReceiveCouponView:(CouponInfoModel *)model commonListModel:(CommonListModel *)commonListModel type:(int) type
{
    OfflineCouponDetailsViewController *offlineCouponDetailsController = [[OfflineCouponDetailsViewController alloc] init];
    offlineCouponDetailsController._couponInfoModel = model;
    offlineCouponDetailsController._commonListModel = commonListModel;
    offlineCouponDetailsController._myOrderType = _orderType;
    [self.navigationController pushViewController:offlineCouponDetailsController animated:YES];
}

#pragma mark - 显示红包详情view
-(void) showReceiveRedPacketView:(RedPacketModel *)model type:(int)type
{
    RedPacketDetailsViewController *redPacketDetailsController = [[RedPacketDetailsViewController alloc] init];
    redPacketDetailsController._redPacketModel = model;
    redPacketDetailsController._myOrderType = _orderType;
    [self.navigationController pushViewController:redPacketDetailsController animated:YES];
}

#pragma mark - 显示通票详情view
-(void) showReceiveExchangeVoucherView:(TongPiaoInfoModel *)model type:(int) type
{
    ExchangeVoucherDetailsViewController *exchangeVoucherDetailsController = [[ExchangeVoucherDetailsViewController alloc] init];
    exchangeVoucherDetailsController._tongPiaoInfoModel = model;
    exchangeVoucherDetailsController._myOrderType = _orderType;
    [self.navigationController pushViewController:exchangeVoucherDetailsController animated:YES];
}

#pragma mark - 从Cell过来的代理
//删除回调
-(void)deleteCardCellDataId:(NSNumber *)cardId couponType:(NSNumber *)couponType isSelected:(BOOL)isSelected
{
    if (isSelected)
    {
        for(NSNumber *tempCardId in _arrDelete)
        {
            if(tempCardId.intValue == cardId.intValue)
            {
                return;
            }
        }
        [_arrDelete addObject:[NSString stringWithFormat:@"%@-%@",cardId,couponType]];
    }
    else
    {
        BOOL isExist = NO;
        for(NSNumber *tempCardId in _arrDelete)
        {
            if(tempCardId.intValue == cardId.intValue)
            {
                isExist = YES;
                break;
            }
        }
        
        if(isExist)
        {
            [_arrDelete removeObject:[NSString stringWithFormat:@"%@-%@",cardId,couponType]];
        }
        
    }
    NSLog(@"%@", _arrDelete);
    
    //如果选中之后，删除数组中有值
    if (_arrDelete.count > 0)
    {
        _btnConfirmDelete.backgroundColor = RGBA(0, 0, 0, 1);
        _btnConfirmDelete.enabled = YES;
    }
    else
    {
        _btnConfirmDelete.backgroundColor = RGBA(0, 0, 0, 0.5);
        _btnConfirmDelete.enabled = NO;
    }
    
    [_tableviewAllPastDue reloadData];
}

#pragma  mark scrollView Delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.width>SCREEN_WIDTH)
    {
        int page = floor((scrollView.contentOffset.x - SCREEN_WIDTH / 2) / SCREEN_WIDTH) + 1;
         _iCurrentPageNumber = page;
        if (page == 0)
        {
            [self onButtonTouch:_btnEffective];
        }
        else if(page == 1)
        {
            [self onButtonTouch:_btnFailure];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
