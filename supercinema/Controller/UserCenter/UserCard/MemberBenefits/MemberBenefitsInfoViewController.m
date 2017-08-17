//
//  MemberBenefitsInfoViewController.m
//  supercinema
//
//  Created by mapollo91 on 25/11/16.
//
//

#import "MemberBenefitsInfoViewController.h"

@interface MemberBenefitsInfoViewController ()

@end

@implementation MemberBenefitsInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _iCurrentPageNumber = 0;
    isShowDeleteButton = NO;
    isAllPastDue = NO;
    nTipStatus = 0;
    _strCinemaId = @"";
    _cardPackAllValidModel = [[CardPackAllValidModel alloc] init];
    _cardListModel = [[CardListModel alloc] init];
    _arrayAllValid = [[NSMutableArray alloc] init];
    _arrayAllPastDue = [[NSMutableArray alloc] init];
    _arrDelete = [[NSMutableArray alloc] init];
    
    //需要加载失效列表（默认）
    isLoadAllPastDueCard = YES;
    [self initController];
    //加载有效列表（需求：加载默认列表内数据，切换其它列表才加载）
    [self loadAllValidCard];
}
-(void)initController
{
    self._labelTitle.text = @"会员权益";
    self._labelLine.hidden = YES;
    
    //删除按钮
    _btnDeleteType = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-21, 27, 21, 21.5)];
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
    [_btnEffective setTitle:@"有效权益" forState:UIControlStateNormal];
    _btnEffective.backgroundColor = [UIColor whiteColor];
    [_btnEffective.titleLabel setFont:MKFONT(15) ];
    [_btnEffective setTitleColor:RGBA(117, 112, 255,1) forState:UIControlStateNormal];
    _btnEffective.tag = 0;
    [_btnEffective addTarget:self action:@selector(onButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnEffective];
    
    //失效按钮
    _btnFailure = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/6+_btnEffective.frame.size.width,_btnEffective.frame.origin.y, SCREEN_WIDTH/3, 42)];
    [_btnFailure setTitle:@"失效权益" forState:UIControlStateNormal];
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
    [lableCutLine setBackgroundColor: RGBA(0, 0, 0, 0.05)];
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
        [MobClick event:myCenterViewbtn31];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [_btnEffective setTitleColor:RGBA(117, 112, 255,1) forState:UIControlStateNormal];
        [_btnFailure setTitleColor:RGBA(0, 0, 0,1) forState:UIControlStateNormal];
        [_btnDeleteType setHidden:YES];
    }
    else
    {
        //点中失效
        [MobClick event:myCenterViewbtn34];
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        [_btnEffective setTitleColor:RGBA(0, 0, 0,1) forState:UIControlStateNormal];
        [_btnFailure setTitleColor:RGBA(117, 112, 255,1) forState:UIControlStateNormal];
        if (isLoadAllPastDueCard == YES)
        {
            //加载失效列表（需求：在当前页内，再次点击切换页签不在加载数据。每个列表仅加载一次）
            isLoadAllPastDueCard = NO;
            [self loadAllPastDueCard];
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
    isShowDeleteButton = NO;
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
//        [self loadAllValidCard];
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
//        [self loadAllPastDueCard];
    }
}

#pragma mark - 加载 有效列表
-(void)loadAllValidCard
{
    __weak MemberBenefitsInfoViewController *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesCardPack getCardPakeForAllValidCard:^(CardPackAllValidModel *model)
    {
        _cardPackAllValidModel = model;
        _arrayAllValid = [[NSMutableArray alloc] initWithArray:_cardPackAllValidModel.cinemaAndCardRelationshipList];
        
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
-(void)loadAllPastDueCard
{
    __weak MemberBenefitsInfoViewController *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesCardPack getCardPakeForAllPastDueCard:^(CardPackAllPastDueModel *model)
    {
        [_arrayAllPastDue removeAllObjects];
        [_arrayAllPastDue addObjectsFromArray:model.cinemaAndCardRelationshipList];
        for (cinemaAndCardRelationshipListModel* cModel in _arrayAllPastDue)
        {
            for (CardListModel* cardModel in cModel.cardList)
            {
                //初始化所有的删除按钮为未勾选状态
                cardModel.isDelete = [NSNumber numberWithInt:1];
            }
        }

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
        [labelDescLoadFailed setText:@"暂无权益"];
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
        [self loadAllValidCard];
        [_tableviewAllValid reloadData];
    }
    else
    {
        //点中失效
        [self loadAllPastDueCard];
        
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
        isShowDeleteButton = YES;
        _viewConfirmDeleteBG.hidden = NO;
        _tableviewAllPastDue.frame = CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.frame.size.height-60);
        
    }
    else
    {
        _btnDeleteType.frame = CGRectMake(SCREEN_WIDTH-15-21, 27, 21, 21.5);
        button.tag = 300;
        [button setImage:[UIImage imageNamed:@"btn_orderDelete.png"] forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
        isShowDeleteButton = NO;
        _viewConfirmDeleteBG.hidden = YES;
        _tableviewAllPastDue.frame = CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.frame.size.height);
        
        if (_arrayAllPastDue != nil && _arrayAllPastDue.count >0)
        {
            for (cinemaAndCardRelationshipListModel *_commonListModel in _arrayAllPastDue) {
                
                NSArray *arrayCardList = _commonListModel.cardList;
                if(arrayCardList != nil && arrayCardList.count > 0){
                    for (int i = 0 ; i <[arrayCardList count] ; i++)
                    {
                        CardListModel *cardListModel = arrayCardList[i];
                        cardListModel.isDelete = [NSNumber numberWithInteger:1];
                    }
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

//立即删除
-(void)onButtonConfirmDelete
{
    NSLog(@"立即删除");
    nTipStatus = 1;
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"真的要删除这些失效权益嘛~？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (nTipStatus == 0)
    {
        //跳转影院
        if (buttonIndex == 1)
        {
            //点击确定
            [Config saveCinemaId:_strCinemaId];
            [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_REFRESHCINEMAHOME object:nil];
            
            NSDictionary* dictTab = @{@"tag":@0};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
            NSDictionary* dictHome = @{@"tag":@0};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else
    {
        //删除会员卡
        if (buttonIndex == 1)
        {
            __weak MemberBenefitsInfoViewController *weakself = self;
            [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
            [ServicesCardPack deleteCardPackCardItem:_arrDelete model:^(RequestResult *model)
             {
                 [_btnConfirmDelete setBackgroundColor:RGBA(0, 0, 0, 0.5)];
                 _btnConfirmDelete.enabled = NO;
                 
                 [_arrDelete removeAllObjects];
                 [weakself loadAllPastDueCard];
                 [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
                 
             } failure:^(NSError *error) {
                 [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
             }];
        }
    }
}

#pragma mark - 切换影院
-(void)onButtonChangeCinema:(CinemaModel *)cinemaModel
{
    NSLog(@"%@",[cinemaModel toJSONString]);
    NSLog(@"%@",[Config getCinemaId]);
    
    _strCinemaId = cinemaModel.cinemaId.description;
    
    //如果当前影院ID 与 跳转影院ID一致
    if ([[Config getCinemaId] intValue] == [cinemaModel.cinemaId intValue])
    {
        [self addCinemaBrowsingHistory:_strCinemaId];
        [Config saveCinemaId:_strCinemaId];
        [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_REFRESHCINEMAHOME object:nil];
        
        NSDictionary* dictTab = @{@"tag":@0};
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
        NSDictionary* dictHome = @{@"tag":@0};
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    else
    {
        //ID 不一致 弹出确认跳转提示框
        nTipStatus = 0;
        UIAlertView *alter = [[UIAlertView alloc ] initWithTitle:nil message:[NSString stringWithFormat:@"影院即将切换至%@",cinemaModel.cinemaName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alter show];
    }
}

#pragma mark - TableViewDelegate
//Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableviewAllValid)
    {
        cinemaAndCardRelationshipListModel* model = _arrayAllValid[indexPath.row];
        NSArray* array = model.cardList;
        if (indexPath.row == _arrayAllValid.count-1)
        {
            //如果是最后一行的时候，留出底边10像素的距离
            return 10+75+array.count*85+30+30;
        }
        return 10+75+array.count*85+20;
    }
    
    //获取大数组下面小数组个数
    //失效
    else
    {
        cinemaAndCardRelationshipListModel* model = _arrayAllPastDue[indexPath.row];
        NSArray* array = model.cardList;
        if (indexPath.row == _arrayAllPastDue.count-1)
        {
            //如果是最后一行的时候，留出底边10像素的距离
            return 10+75+array.count*85+30+30;
        }
        return 10+75+array.count*85+20;
    }
}

//Cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //有效
    if (tableView == _tableviewAllValid)
    {
        return _arrayAllValid.count;
    }
    //失效
    if (tableView == _tableviewAllPastDue)
    {
        return _arrayAllPastDue.count;
    }
    return 0;
}

//Cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    //有效
    if (tableView == _tableviewAllValid)
    {
        MemberBenefitsInfoTableViewCell *memberBenefitsInfoCell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (memberBenefitsInfoCell == nil)
        {
            memberBenefitsInfoCell = [[MemberBenefitsInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            memberBenefitsInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            memberBenefitsInfoCell.memberBenefitsInfoDelegate = self;
        }
        cinemaAndCardRelationshipListModel* model = _arrayAllValid[indexPath.row];

        //基本信息
        [memberBenefitsInfoCell setAllValidBasicInformationCellFrameData:model.cinema arrayCardList:model.cardList];
        //详情
        [memberBenefitsInfoCell setAllValidDetailsCellFrameData:model.cardList index:indexPath.row];
        
        return memberBenefitsInfoCell;
    }
    //失效
    if (tableView == _tableviewAllPastDue)
    {
        MemberBenefitsInfoTableViewCell *memberBenefitsInfoCell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (memberBenefitsInfoCell == nil)
        {
            memberBenefitsInfoCell = [[MemberBenefitsInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            memberBenefitsInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            memberBenefitsInfoCell.memberBenefitsInfoDelegate = self;
        }
        cinemaAndCardRelationshipListModel* model = _arrayAllPastDue[indexPath.row];
   
        //基本信息
        [memberBenefitsInfoCell setAllPastDueBasicInformationCellFrameData:model.cinema arrayCardList:model.cardList];
        //详情
        [memberBenefitsInfoCell setAllPastDueDetailsCellFrameData:model.cardList index:indexPath.row boolDeleteButtonShow:isShowDeleteButton];
        
        return memberBenefitsInfoCell;
    }
    return cell;
}

//从Cell过来的代理
//买卡
-(void)buyCardMemberBenefitsInfoCellSkip:(UIButton*)btn tableType:(TableType)tableType index:(NSInteger)row
{
    
    CinemaModel *cinema = nil;
    CardListModel *cardListModel = nil;
    if (tableType == Valid)
    {
        cinemaAndCardRelationshipListModel* model = _arrayAllValid[row];
        cinema = model.cinema;
        cardListModel = model.cardList[btn.tag];
    }
    
    //失效
    if (tableType == PastDue)
    {
        cinemaAndCardRelationshipListModel* model = _arrayAllPastDue[row];
        cinema = model.cinema;
        cardListModel = model.cardList[btn.tag];
    }
    
    if(cinema == nil)
        return;

    MemberCinemaModel * memberCinema = [[MemberCinemaModel alloc] init];
    memberCinema.cinemaId = cinema.cinemaId;
    memberCinema.cinemaName = cinema.cinemaName;
    
    BuyCardViewController *buyCardVC = [[BuyCardViewController alloc] init];
    buyCardVC._cinema = memberCinema;
    buyCardVC.cinemaCardId = cardListModel.cinemaCardId;
//    buyCardVC._cardListModel = cardListModel;
    [self.navigationController pushViewController:buyCardVC animated:YES];
}

//卡详情
-(void)cardInfoMemberBenefitsInfoCellSkip:(UIButton*)btn delBtn:(UIButton*)delBtn tableType:(TableType)tableType index:(NSInteger)row
{
    NSLog(@"跳转到卡详情");
    
    CinemaModel *cinema = nil;
    CardListModel *cardListModel = nil;
    if (tableType == Valid)
    {
        cinemaAndCardRelationshipListModel* model = _arrayAllValid[row];
        cinema = model.cinema;
        cardListModel = model.cardList[btn.tag];
    }
    
    //失效
    if (tableType == PastDue)
    {
        cinemaAndCardRelationshipListModel* model = _arrayAllPastDue[row];
        cinema = model.cinema;
        cardListModel = model.cardList[btn.tag];
    }
    
    if(cinema == nil || cardListModel == nil)
        return;
    
    //判断状态
    if (isShowDeleteButton == YES)
    {
        [delBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        //跳转卡详情页之前，告诉详情页卡包列表状态 （NO是有效；YES是失效）
        isAllPastDue = YES;
        
        //有效
        if (tableType == Valid)
        {
            MembershipCardDetailsViewController *membershipCardDetailsController = [[MembershipCardDetailsViewController alloc] init];
            membershipCardDetailsController._cardListModel = cardListModel;
            MemberCinemaModel * tempCinema = [[MemberCinemaModel alloc] init];
            [tempCinema setCinemaId:cinema.cinemaId];
            [tempCinema setCinemaName:cinema.cinemaName];
            membershipCardDetailsController._cinema = tempCinema;
            membershipCardDetailsController._isAllPastDue = isAllPastDue;
            [self.navigationController pushViewController:membershipCardDetailsController animated:YES];
        }
        
        //失效
        if (tableType == PastDue)
        {
            MemberCinemaModel * memberCinema = [[MemberCinemaModel alloc] init];
            memberCinema.cinemaId = cinema.cinemaId;
            memberCinema.cinemaName = cinema.cinemaName;
            
            BuyCardViewController *buyCardVC = [[BuyCardViewController alloc] init];
            buyCardVC._cinema = memberCinema;
            buyCardVC.cinemaCardId = cardListModel.cinemaCardId;
//            buyCardVC._cardListModel = cardListModel;
            [self.navigationController pushViewController:buyCardVC animated:YES];
        }
        
    }
}

#pragma mark - 从Cell过来的代理
//删除回调
-(void)deleteCardCellDataId:(NSNumber *)cardId isSelected:(BOOL)isSelected
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
        
        [_arrDelete addObject:cardId];
        
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
            [_arrDelete removeObject:cardId];
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



