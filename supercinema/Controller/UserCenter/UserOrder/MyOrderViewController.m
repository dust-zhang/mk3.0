//
//  MyOrderViewController.m
//  supercinema
//
//  Created by dust on 16/11/24.
//
//

#import "MyOrderViewController.h"

@interface MyOrderViewController ()

@end

@implementation MyOrderViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrayAllOrder = [[NSMutableArray alloc ] initWithCapacity:0];
    _arrayWaitPayment = [[NSMutableArray alloc ] initWithCapacity:0];
    _arrayWaitUse = [[NSMutableArray alloc ] initWithCapacity:0];
    _arrayRefund = [[NSMutableArray alloc ] initWithCapacity:0];
    _arrIsLoadData = [[NSMutableArray alloc ] initWithObjects:@"NO",@"NO",@"NO",@"NO", nil];
    
    [self._labelLine setHidden:YES];
    
    _currentPageNum = 0;
    _pageAllOrderIndex= 1;
    _pagePaymentIndex= 1;
    _pageWaitUseIndex= 1;
    _pageRefundIndex= 1;
    _isRefresh  =   FALSE;
    [self initController];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(refreshUnPayOrder) name:NOTIFITION_REFRESHORDER object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:NOTIFITION_REFRESHORDER];
}

#pragma mark 加载所有订单
-(void) loadMyAllorder
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesOrder getMyAllOrder:_pageAllOrderIndex model:^(MyOrderModel *model)
    {
        _currentTime = model.currentTime;
        [_arrayAllOrder addObjectsFromArray:model.orderList];
        [weakSelf._tableviewAllOrder reloadData];
        
        //如果未读到最后一页则添加到数组中
        if (_pageAllOrderIndex < [model.pageTotal intValue])
        {
            [weakSelf._tableviewAllOrder addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMyAllorder)];
            [weakSelf._tableviewAllOrder.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [weakSelf._tableviewAllOrder.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
            [weakSelf._tableviewAllOrder.footer endRefreshing];
        }
        else
        {
            [weakSelf._tableviewAllOrder removeFooter ];
            _pageAllOrderIndex =[model.pageTotal intValue];
        }
        
        if ([_arrayAllOrder count] > 0)
        {
            [_imageViewAllOrder setHidden:YES];
            [_labelAllOrder setHidden:YES];
        }
        else
        {
            [weakSelf._tableviewAllOrder removeFooter ];
            [_imageViewAllOrder setHidden:NO];
            [_labelAllOrder setHidden:NO];
        }
        _viewLoadFailedAll.hidden = YES;
        _pageAllOrderIndex += 1;
        
        if ([[_arrIsLoadData objectAtIndex:0] isEqualToString:@"NO"])
        {
            [_arrIsLoadData removeObjectAtIndex:0];
            [_arrIsLoadData insertObject:@"YES" atIndex:0];
        }
        [FVCustomAlertView hideAlertFromView:self.view fading:YES];
      
    } failure:^(NSError *error) {
        [FVCustomAlertView hideAlertFromView:self.view fading:YES];
        [weakSelf._tableviewAllOrder removeFooter ];
        [weakSelf._tableviewAllOrder reloadData];
        [weakSelf initFailureViewAllOrder];
        [_imageViewAllOrder setHidden:YES];
        [_labelAllOrder setHidden:YES];
    }];
}

#pragma mark 加载需要支付订单
-(void) loadMyWaitPaymentOrder
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesOrder getMyUnPaidOrder:_pagePaymentIndex model:^(MyOrderModel *model)
    {
        _currentTime = model.currentTime;
        [_arrayWaitPayment addObjectsFromArray:model.orderList];
        [weakSelf._tableviewWaitPayment reloadData];
        
        if (_pagePaymentIndex < [model.pageTotal intValue])
        {
            [weakSelf._tableviewWaitPayment addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMyWaitPaymentOrder)];
            [weakSelf._tableviewWaitPayment.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [weakSelf._tableviewWaitPayment.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
            [weakSelf._tableviewWaitPayment.footer endRefreshing];
        }
        else
        {
            [weakSelf._tableviewWaitPayment removeFooter ];
            _pagePaymentIndex =[model.pageTotal intValue];
        }
        
        if ([_arrayWaitPayment count] > 0)
        {
            [_imageViewPayment setHidden:YES];
            [_labelPayment setHidden:YES];
        }
        else
        {
            [weakSelf._tableviewWaitPayment removeFooter ];
            [_imageViewPayment setHidden:NO];
            [_labelPayment setHidden:NO];
        }
        _viewLoadFailedWaitPayment.hidden = YES;
        
        _pagePaymentIndex += 1;
        _isRefresh  =   TRUE;
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
        
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
         [weakSelf._tableviewWaitPayment removeFooter ];
         [weakSelf._tableviewWaitPayment reloadData];
         [weakSelf initFailureViewAllOrderWaitPayment ];
         [_imageViewPayment setHidden:YES];
         [_labelPayment setHidden:YES];

     }];
}

#pragma mark 加载待使用订单
-(void) loadMyWaitUserOrder
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesOrder getMyUnUserdOrder:_pageWaitUseIndex model:^(MyOrderModel *model)
     {
         _currentTime = model.currentTime;
         [_arrayWaitUse addObjectsFromArray:model.orderList];
         [weakSelf._tableviewWaitUse reloadData];
         
         if (_pageWaitUseIndex <[model.pageTotal intValue])
         {
             [weakSelf._tableviewWaitUse addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMyWaitUserOrder)];
             [weakSelf._tableviewWaitUse.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
             [weakSelf._tableviewWaitUse.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
             [weakSelf._tableviewWaitUse.footer endRefreshing];
         }
         else
         {
             [weakSelf._tableviewWaitUse removeFooter ];
             _pageWaitUseIndex =[model.pageTotal intValue];
         }
         
         if ([_arrayWaitUse count] > 0)
         {
             [_imageViewWaitUse setHidden:YES];
             [_labelWaitUse setHidden:YES];
         }
         else
         {
             [weakSelf._tableviewWaitUse removeFooter ];
             [_imageViewWaitUse setHidden:NO];
             [_labelWaitUse setHidden:NO];
         }
        _viewLoadFailedWaitUse.hidden = YES;
         
         _pageWaitUseIndex += 1;
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
         
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
         [weakSelf._tableviewWaitUse removeFooter ];
         [weakSelf._tableviewWaitUse reloadData];
         [weakSelf initFailureViewAllOrderWaitUse];
         [_imageViewWaitUse setHidden:YES];
         [_labelWaitUse setHidden:YES];
     }];
}

#pragma mark 加载待退款订单
-(void) loadMyRefundOrder
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesOrder getMyRefundedOrder:_pageRefundIndex model:^(MyOrderModel *model)
    {
        _currentTime = model.currentTime;
        [_arrayRefund addObjectsFromArray:model.orderList];
        [weakSelf._tableviewRefund reloadData];
        
        if (_pageRefundIndex < [model.pageTotal intValue])
        {
            [weakSelf._tableviewRefund addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMyRefundOrder)];
            [weakSelf._tableviewRefund.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [weakSelf._tableviewRefund.footer setTitle:@"" forState:MJRefreshFooterStateRefreshing];
            [weakSelf._tableviewRefund.footer endRefreshing];
        }
        else
        {
            [weakSelf._tableviewRefund removeFooter ];
            _pageRefundIndex =[model.pageTotal intValue];
        }
        
        if ([_arrayRefund count] > 0)
        {
            [_labelRefund setText:@""];
            [_imageViewRefund setHidden:YES];
            [_labelRefund setHidden:YES];
        }
        else
        {
            [weakSelf._tableviewRefund removeFooter ];
            [_imageViewRefund setHidden:NO];
            [_labelRefund setHidden:NO];
        }
        _viewLoadFailedRefund.hidden = YES;
        
        _pageRefundIndex += 1;
        [FVCustomAlertView hideAlertFromView:self.view fading:YES];
        
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
         [weakSelf._tableviewRefund removeFooter ];
         [weakSelf._tableviewRefund reloadData];
         [weakSelf initFailureViewAllOrderRefund ];
         [_imageViewRefund setHidden:YES];
         [_labelRefund setHidden:YES];
     }];
}

-(void)initFailureViewAllOrder
{
    if (!_viewLoadFailedAll)
    {
        _viewLoadFailedAll = [[LoadFailedView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT/3, SCREEN_WIDTH, HEIGHT_FAILEDVIEW)];
        WeakSelf(ws);
        [_viewLoadFailedAll setRefreshData:^{
            
                [ws loadMyAllorder];
        }];
        [self.view addSubview:_viewLoadFailedAll];
    }
    else
    {
        _viewLoadFailedAll.hidden = NO;
    }
    _viewLoadFailedWaitPayment.hidden = YES;
    _viewLoadFailedWaitUse.hidden = YES;
    _viewLoadFailedRefund.hidden = YES;
}

-(void)initFailureViewAllOrderWaitPayment
{
    if (!_viewLoadFailedWaitPayment)
    {
        _viewLoadFailedWaitPayment = [[LoadFailedView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT/3, SCREEN_WIDTH, HEIGHT_FAILEDVIEW)];
        WeakSelf(ws);
        [_viewLoadFailedWaitPayment setRefreshData:^{
            
            [ws loadMyWaitPaymentOrder];
        }];
        [self.view addSubview:_viewLoadFailedWaitPayment];
    }
    else
    {
        _viewLoadFailedWaitPayment.hidden = NO;
    }
    _viewLoadFailedAll.hidden = YES;
    _viewLoadFailedWaitUse.hidden = YES;
    _viewLoadFailedRefund.hidden = YES;
}

-(void)initFailureViewAllOrderWaitUse
{
    if (!_viewLoadFailedWaitUse)
    {
        _viewLoadFailedWaitUse = [[LoadFailedView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT/3, SCREEN_WIDTH, HEIGHT_FAILEDVIEW)];
        WeakSelf(ws);
        [_viewLoadFailedWaitUse setRefreshData:^{
            
            [ws loadMyWaitUserOrder];
        }];
        [self.view addSubview:_viewLoadFailedWaitUse];
    }
    else
    {
        _viewLoadFailedWaitUse.hidden = NO;
    }
    _viewLoadFailedAll.hidden = YES;
    _viewLoadFailedWaitPayment.hidden = YES;
    _viewLoadFailedRefund.hidden = YES;
    
}

-(void)initFailureViewAllOrderRefund
{
    if (!_viewLoadFailedRefund)
    {
        _viewLoadFailedRefund = [[LoadFailedView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT/3, SCREEN_WIDTH, HEIGHT_FAILEDVIEW)];
        WeakSelf(ws);
        [_viewLoadFailedRefund setRefreshData:^{
            
            [ws loadMyRefundOrder];
        }];
        [self.view addSubview:_viewLoadFailedRefund];
    }
    else
    {
        _viewLoadFailedRefund.hidden = NO;
    }
    _viewLoadFailedAll.hidden = YES;
    _viewLoadFailedWaitPayment.hidden = YES;
    _viewLoadFailedWaitUse.hidden = YES;
}

-(void) initController
{
    self._labelTitle.text = @"我的订单";
    
    _btnAllOrder = [[UIButton alloc] initWithFrame:CGRectMake(0,self._viewTop.frame.origin.y+self._viewTop.frame.size.height, SCREEN_WIDTH/4, 44)];
    [_btnAllOrder setTitle:@"全部" forState:UIControlStateNormal];
    _btnAllOrder.backgroundColor = [UIColor whiteColor];
    [_btnAllOrder.titleLabel setFont:MKFONT(14) ];
    [_btnAllOrder setTitleColor:RGBA(117, 112, 255,1) forState:UIControlStateNormal];
    _btnAllOrder.tag = 0;
    [_btnAllOrder addTarget:self action:@selector(onButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnAllOrder];
    
    _btnWaitPayment= [[UIButton alloc] initWithFrame:CGRectMake(_btnAllOrder.frame.size.width,_btnAllOrder.frame.origin.y, SCREEN_WIDTH/4, 44)];
    [_btnWaitPayment setTitle:@"待付款" forState:UIControlStateNormal];
    _btnWaitPayment.backgroundColor = [UIColor whiteColor];
    [_btnWaitPayment.titleLabel setFont:MKFONT(14) ];
    [_btnWaitPayment setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];
    _btnWaitPayment.tag = 1;
    [_btnWaitPayment addTarget:self action:@selector(onButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnWaitPayment];

    _btnWaitUse = [[UIButton alloc] initWithFrame:CGRectMake(_btnAllOrder.frame.size.width*2,_btnAllOrder.frame.origin.y, SCREEN_WIDTH/4, 44)];
    [_btnWaitUse setTitle:@"待使用" forState:UIControlStateNormal];
    _btnWaitUse.backgroundColor = [UIColor whiteColor];
    [_btnWaitUse.titleLabel setFont:MKFONT(14) ];
    [_btnWaitUse setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];
    _btnWaitUse.tag = 2;
    [_btnWaitUse addTarget:self action:@selector(onButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnWaitUse];

    _btnRefund= [[UIButton alloc] initWithFrame:CGRectMake(_btnAllOrder.frame.size.width*3,_btnAllOrder.frame.origin.y, SCREEN_WIDTH/4, 44)];
    [_btnRefund setTitle:@"退款" forState:UIControlStateNormal];
    _btnRefund.backgroundColor = [UIColor whiteColor];
    [_btnRefund.titleLabel setFont:MKFONT(14) ];
    [_btnRefund setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];
    _btnRefund.tag = 3;
    [_btnRefund addTarget:self action:@selector(onButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnRefund];
    
    //按钮下蓝色线
    _viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, _btnAllOrder.frame.origin.y+_btnAllOrder.frame.size.height-2, SCREEN_WIDTH/4, 1)];
    [_viewLine setBackgroundColor:RGBA(117, 112, 255,1)];
    [self.view addSubview:_viewLine];
    
    UILabel *lableCutLine = [[UILabel alloc] initWithFrame:CGRectMake(0, _viewLine.frame.origin.y+_viewLine.frame.size.height, SCREEN_WIDTH, 1)];
    [lableCutLine setBackgroundColor: RGBA(0, 0, 0,0.05) ];
    [self.view addSubview:lableCutLine];
   
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lableCutLine.frame.origin.y+lableCutLine.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-_btnAllOrder.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [_scrollView setBackgroundColor:RGBA(246, 246, 251,1)];
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH*4, _scrollView.frame.size.height)];

#pragma mark 如果没有数据可以在这里添加没有数据UI

    //全部订单
    _viewAllOrder = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-_scrollView.frame.origin.y)];
    [_viewAllOrder setBackgroundColor:[UIColor clearColor]];
    [_scrollView addSubview:_viewAllOrder];
    [_viewAllOrder setUserInteractionEnabled:YES];
    [self showList:_viewAllOrder type:0];
    
    _imageViewAllOrder = [[UIImageView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH/2-(146/4),_viewLine.frame.size.height+ 205/2, 146/2, 134/2)];
    [_imageViewAllOrder setImage:[UIImage imageNamed:@"image_NoDataOrder.png"]];
    [_scrollView addSubview:_imageViewAllOrder];
    [_imageViewAllOrder setHidden:YES];
    
    _labelAllOrder = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageViewAllOrder.frame.origin.y+_imageViewAllOrder.frame.size.height+10, SCREEN_WIDTH, 14)];
    [_labelAllOrder setBackgroundColor:[UIColor clearColor]];
    [_labelAllOrder setText:@"暂无订单"];
    [_labelAllOrder setFont:MKFONT(14)];
    [_labelAllOrder setTextColor:RGBA(96, 94, 134, 1)];
    [_labelAllOrder setTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:_labelAllOrder];
    [_labelAllOrder setHidden:YES];
    
    //待付款
     _viewPayment = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-_scrollView.frame.origin.y)];
    [_viewPayment  setBackgroundColor:[UIColor clearColor]];
    [_scrollView addSubview:_viewPayment];
    [_viewPayment setUserInteractionEnabled:YES];
    [self showList:_viewPayment type:1];
    
    _imageViewPayment = [[UIImageView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH/2-(146/4) +SCREEN_WIDTH,_viewLine.frame.size.height+ 205/2, 146/2, 134/2)];
    [_imageViewPayment setImage:[UIImage imageNamed:@"image_NoDataOrder.png"]];
    [_scrollView addSubview:_imageViewPayment];
    [_imageViewPayment setHidden:YES];
    
    _labelPayment = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH,_imageViewPayment.frame.origin.y+_imageViewPayment.frame.size.height+10, SCREEN_WIDTH, 14)];
    [_labelPayment setBackgroundColor:[UIColor clearColor]];
    [_labelPayment setText:@"暂无订单"];
    [_labelPayment setFont:MKFONT(14)];
    [_labelPayment setTextColor:RGBA(96, 94, 134, 1)];
    [_labelPayment setTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:_labelPayment];
    [_labelPayment setHidden:YES];
    
    //待使用
     _viewWaitUse = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-_scrollView.frame.origin.y)];
    [_viewWaitUse setBackgroundColor:[UIColor clearColor]];
    [_scrollView addSubview:_viewWaitUse];
    [_viewWaitUse setUserInteractionEnabled:YES];
    [self showList:_viewWaitUse type:2];
    
    _imageViewWaitUse = [[UIImageView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH/2-(146/4)+SCREEN_WIDTH*2,_viewLine.frame.size.height+ 205/2, 146/2, 134/2)];
    [_imageViewWaitUse setImage:[UIImage imageNamed:@"image_NoDataOrder.png"]];
    [_scrollView addSubview:_imageViewWaitUse];
    [_imageViewWaitUse setHidden:YES];
    
    _labelWaitUse = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2,_imageViewWaitUse.frame.origin.y+_imageViewWaitUse.frame.size.height+10, SCREEN_WIDTH, 14)];
    [_labelWaitUse setBackgroundColor:[UIColor clearColor]];
    [_labelWaitUse setText:@"暂无订单"];
    [_labelWaitUse setFont:MKFONT(14)];
    [_labelWaitUse setTextColor:RGBA(96, 94, 134, 1)];
    [_labelWaitUse setTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:_labelWaitUse];
    [_labelWaitUse setHidden:YES];
    
    //退款
     _viewRefund = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT-_scrollView.frame.origin.y)];
    [_viewRefund setBackgroundColor:[UIColor clearColor]];
    [_scrollView addSubview:_viewRefund];
    [_viewRefund setUserInteractionEnabled:YES];
    
    _imageViewRefund = [[UIImageView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH/2-(146/4)+SCREEN_WIDTH*3,_viewLine.frame.size.height+ 205/2, 146/2, 134/2)];
    [_imageViewRefund setImage:[UIImage imageNamed:@"image_NoDataOrder.png"]];
    [_scrollView addSubview:_imageViewRefund];
    [_imageViewRefund setHidden:YES];
    
    _labelRefund = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 3,_imageViewRefund.frame.origin.y+_imageViewRefund.frame.size.height+10, SCREEN_WIDTH, 14)];
    [_labelRefund setBackgroundColor:[UIColor clearColor]];
    [_labelRefund setText:@"暂无订单"];
    [_labelRefund setFont:MKFONT(14)];
    [_labelRefund setTextColor:RGBA(96, 94, 134, 1)];
    [_labelRefund setTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:_labelRefund];
    [_labelRefund setHidden:YES];
    
    [self showList:_viewRefund type:3];
    
}

#pragma mark 切换按钮事件
-(void)onButtonTouch:(UIButton*)btn
{
    if(btn.tag == 0)
    {
        [MobClick event:myCenterViewbtn23];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [_btnAllOrder setTitleColor:RGBA(117, 112, 255,1) forState:UIControlStateNormal];
        [_btnWaitPayment setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];
        [_btnWaitUse setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];
        [_btnRefund setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];
        
        if ([[_arrIsLoadData objectAtIndex:0] isEqualToString:@"NO"])
        {
            _pageAllOrderIndex = 1;
            [_arrayAllOrder removeAllObjects];
            [self loadMyAllorder];
            
            if ([MKNetWorkState getNetWorkState] != AFNetworkReachabilityStatusNotReachable)
            {
                [_arrIsLoadData removeObjectAtIndex:0];
                [_arrIsLoadData insertObject:@"YES" atIndex:0];
            }
        }
        
        if ([_arrayAllOrder count] > 0)
        {
            _viewLoadFailedAll.hidden = YES;
        }
        _viewLoadFailedWaitPayment.hidden = YES;
        _viewLoadFailedWaitUse.hidden = YES;
        _viewLoadFailedRefund.hidden = YES;
    }
    else if(btn.tag == 1)
    {
        [MobClick event:myCenterViewbtn24];
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
        [_btnAllOrder setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];
        [_btnWaitPayment setTitleColor:RGBA(117, 112, 255,1) forState:UIControlStateNormal];
        [_btnWaitUse setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];
        [_btnRefund setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];
        
        if ([[_arrIsLoadData objectAtIndex:1] isEqualToString:@"NO"])
        {
            _pagePaymentIndex = 1;
            [_arrayWaitPayment removeAllObjects];
            [self loadMyWaitPaymentOrder];
            
            if ([MKNetWorkState getNetWorkState] != AFNetworkReachabilityStatusNotReachable)
            {
                [_arrIsLoadData removeObjectAtIndex:1];
                [_arrIsLoadData insertObject:@"YES" atIndex:1];
            }
        }
        if ([_arrayWaitPayment count] > 0)
        {
            _viewLoadFailedWaitPayment.hidden = YES;
        }
        _viewLoadFailedAll.hidden = YES;
        _viewLoadFailedWaitUse.hidden = YES;
        _viewLoadFailedRefund.hidden = YES;
    }
    else if(btn.tag == 2)
    {
        [MobClick event:myCenterViewbtn25];
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
        [_btnAllOrder setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];
        [_btnWaitPayment setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];
        [_btnWaitUse setTitleColor:RGBA(117, 112, 255,1) forState:UIControlStateNormal];
        [_btnRefund setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];

        if ([[_arrIsLoadData objectAtIndex:2] isEqualToString:@"NO"])
        {
            _pageWaitUseIndex = 1;
            [_arrayWaitUse removeAllObjects];
            [self loadMyWaitUserOrder];
            if ([MKNetWorkState getNetWorkState] != AFNetworkReachabilityStatusNotReachable)
            {
                [_arrIsLoadData removeObjectAtIndex:2];
                [_arrIsLoadData insertObject:@"YES" atIndex:2];
            }
        }
        if ([_arrayWaitUse count] > 0)
        {
            _viewLoadFailedWaitUse.hidden = YES;
        }
        _viewLoadFailedAll.hidden = YES;
        _viewLoadFailedWaitPayment.hidden = YES;
        _viewLoadFailedRefund.hidden = YES;
    }
    else
    {
        [MobClick event:myCenterViewbtn26];
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*3, 0) animated:YES];
        [_btnAllOrder setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];
        [_btnWaitPayment setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];
        [_btnWaitUse setTitleColor:RGBA(123, 122, 152,1) forState:UIControlStateNormal];
        [_btnRefund setTitleColor:RGBA(117, 112, 255,1) forState:UIControlStateNormal];

        if ([[_arrIsLoadData objectAtIndex:3] isEqualToString:@"NO"])
        {
            _pageRefundIndex = 1;
            [_arrayRefund removeAllObjects];
            [self loadMyRefundOrder];
            if ([MKNetWorkState getNetWorkState] != AFNetworkReachabilityStatusNotReachable)
            {
                [_arrIsLoadData removeObjectAtIndex:3];
                [_arrIsLoadData insertObject:@"YES" atIndex:3];
            }
        }
        if ([_arrayRefund count] > 0)
        {
            _viewLoadFailedRefund.hidden = YES;
        }
        _viewLoadFailedAll.hidden = YES;
        _viewLoadFailedWaitPayment.hidden = YES;
        _viewLoadFailedWaitUse.hidden = YES;
        
    }
    _currentPageNum =(int)btn.tag;
    
    CGRect btnLineViewFrame = _viewLine.frame;
    btnLineViewFrame.origin.x = btn.frame.origin.x;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_viewLine setFrame:btnLineViewFrame];
    } completion:^(BOOL finished) {
    }];
}

#pragma  mark 切换订单项
-(void)showList:(UIView*)view type:(int)type
{
    if (type == 0)
    {
        self._tableviewAllOrder = [[UITableView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, view.frame.size.height) style:UITableViewStylePlain];
        [self._tableviewAllOrder setSeparatorColor:[UIColor clearColor]];
        self._tableviewAllOrder.delegate = self;
        self._tableviewAllOrder.dataSource = self;
        [self._tableviewAllOrder setBackgroundColor:RGBA(246, 246, 251,1) ];
        [view addSubview:self._tableviewAllOrder];
        [self._tableviewAllOrder addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMyAllorder)];

        [self loadMyAllorder];
    }
    if (type == 1)
    {
        self._tableviewWaitPayment = [[UITableView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, view.frame.size.height) style:UITableViewStylePlain];
        [self._tableviewWaitPayment setSeparatorColor:[UIColor clearColor]];
        self._tableviewWaitPayment.delegate = self;
        self._tableviewWaitPayment.dataSource = self;
        [self._tableviewWaitPayment setBackgroundColor:RGBA(246, 246, 251,1) ];
        [view addSubview:self._tableviewWaitPayment];
        [self._tableviewWaitPayment addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMyWaitPaymentOrder)];

//        [self loadMyWaitPaymentOrder];
    }
    if (type == 2)
    {
        self._tableviewWaitUse = [[UITableView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, view.frame.size.height) style:UITableViewStylePlain];
        [self._tableviewWaitUse setSeparatorColor:[UIColor clearColor]];
        self._tableviewWaitUse.delegate = self;
        self._tableviewWaitUse.dataSource = self;
        [self._tableviewWaitUse setBackgroundColor:RGBA(246, 246, 251,1) ];
        [view addSubview:self._tableviewWaitUse];
        
        [self._tableviewWaitUse addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMyWaitUserOrder)];

//        [self loadMyWaitUserOrder];
    }
    if (type == 3)
    {
        self._tableviewRefund = [[UITableView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, view.frame.size.height) style:UITableViewStylePlain];
        [self._tableviewRefund setSeparatorColor:[UIColor clearColor]];
        self._tableviewRefund.delegate = self;
        self._tableviewRefund.dataSource = self;
        [self._tableviewRefund setBackgroundColor:RGBA(246, 246, 251,1) ];
        [view addSubview:self._tableviewRefund];
        [self._tableviewRefund addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMyRefundOrder)];

//        [self loadMyRefundOrder];
    }
}

-(NSString *) calcGoodsHeight:(MyOrderListModel*)myOrderListModel
{
    //组合小卖信息
    NSString *str=@"" ;
    for (int i=0; i < [myOrderListModel.goodsOrderList count]; i++)
    {
        MyGoodsOrderListModel *goodsModel = myOrderListModel.goodsOrderList[i];
        
        str = [NSString stringWithFormat:@"%@%@(%@份)",str,goodsModel.goodsName,goodsModel.goodsCount];
        
        if (i < [myOrderListModel.goodsOrderList count]-1)
        {
            str = [NSString stringWithFormat:@"%@ \n",str];
        }
    }
    return str;
}

#pragma mark UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%ld",indexPath.row);
    MyOrderListModel *myOrderListModel;
    if (tableView == self._tableviewAllOrder)
    {
        myOrderListModel = [_arrayAllOrder objectAtIndex:indexPath.row];
       
        //会员卡订单
        if(myOrderListModel.cardOrder != nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            return 380/2;
        }
        //票
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            return 390/2+10;
        }
        //小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            CGSize size = [Tool CalcString:[self calcGoodsHeight:myOrderListModel] fontSize:MKBOLDFONT(14) andWidth:SCREEN_WIDTH-60];
            return 320/2+10+ size.height+([myOrderListModel.goodsOrderList count] -1)*15;
        }
        //票和小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            CGSize size = [Tool CalcString:[self calcGoodsHeight:myOrderListModel] fontSize:MKBOLDFONT(15) andWidth:SCREEN_WIDTH-60];
            return 426/2+ 13 +size.height+([myOrderListModel.goodsOrderList count] -1)*15;
        }
        return 0;
    }
    if (tableView == self._tableviewWaitPayment)
    {
        myOrderListModel = [_arrayWaitPayment objectAtIndex:indexPath.row];
        //会员卡订单
        if(myOrderListModel.cardOrder != nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            return 380/2;
        }
        //票
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            return 390/2+10;
        }
        //小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            CGSize size = [Tool CalcString:[self calcGoodsHeight:myOrderListModel] fontSize:MKBOLDFONT(14) andWidth:SCREEN_WIDTH-60];
            return 320/2+13+ size.height+([myOrderListModel.goodsOrderList count] -1)*15;
        }
        //票和小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            CGSize size = [Tool CalcString:[self calcGoodsHeight:myOrderListModel] fontSize:MKBOLDFONT(15) andWidth:SCREEN_WIDTH-60];
            return 426/2+ 13 +size.height+([myOrderListModel.goodsOrderList count] -1)*15;
        }

        return 0;
    }
    if (tableView == self._tableviewWaitUse)
    {
        myOrderListModel = [_arrayWaitUse objectAtIndex:indexPath.row];
        //会员卡订单
        if(myOrderListModel.cardOrder != nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            return 380/2;
        }
        //票
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            return 390/2+10;
        }
        //小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            CGSize size = [Tool CalcString:[self calcGoodsHeight:myOrderListModel] fontSize:MKBOLDFONT(14) andWidth:SCREEN_WIDTH-60];
            return 320/2+13+ size.height+([myOrderListModel.goodsOrderList count] -1)*15;
        }
        //票和小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            CGSize size = [Tool CalcString:[self calcGoodsHeight:myOrderListModel] fontSize:MKBOLDFONT(15) andWidth:SCREEN_WIDTH-60];
            return 426/2+ 13+size.height+([myOrderListModel.goodsOrderList count] -1)*15;
        }
        
        return 0;
    }
    if (tableView ==self._tableviewRefund)
    {
        myOrderListModel = [_arrayRefund objectAtIndex:indexPath.row];
        //会员卡订单
        if(myOrderListModel.cardOrder != nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            return 380/2;
        }
        //票
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            return 390/2+10;
        }
        //小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            CGSize size = [Tool CalcString:[self calcGoodsHeight:myOrderListModel] fontSize:MKBOLDFONT(14) andWidth:SCREEN_WIDTH-60];
            return 320/2+13+ size.height+([myOrderListModel.goodsOrderList count] -1)*15;
        }
        //票和小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            CGSize size = [Tool CalcString:[self calcGoodsHeight:myOrderListModel] fontSize:MKBOLDFONT(15) andWidth:SCREEN_WIDTH-60];
            return 426/2+13+ size.height+([myOrderListModel.goodsOrderList count] -1)*15;
        }
        return 0;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self._tableviewAllOrder)
    {
        return [_arrayAllOrder count];
    }
    if (tableView == self._tableviewWaitPayment)
    {
        return [_arrayWaitPayment count];
    }
    if (tableView == self._tableviewWaitUse)
    {
        return [_arrayWaitUse count];
    }
    if (tableView ==self._tableviewRefund)
    {
        return [_arrayRefund count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    MyOrderListModel *myOrderListModel;
    //所有订单
    if (tableView == self._tableviewAllOrder)
    {
//        NSLog(@"%ld",indexPath.row);
        myOrderListModel = [_arrayAllOrder objectAtIndex:indexPath.row];
        
        //会员卡订单
        if(myOrderListModel.cardOrder != nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            MyVipCardOrderTableViewCell *vipCardOrderCell  = [[MyVipCardOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            vipCardOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            vipCardOrderCell._deleteVipCardDelegate = self;
            
            [vipCardOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return vipCardOrderCell;
        }
        //票
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            MyTicketOrderTableViewCell *ticketOrderCell = [[MyTicketOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            ticketOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            ticketOrderCell._deleteTicketDelegate = self;
            
            [ticketOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return ticketOrderCell;
        }
        //小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            MyGoodsOrderTableViewCell *goodsOrderCell = [[MyGoodsOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            goodsOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            goodsOrderCell._deleteGoodsDelegate = self;
            
            [goodsOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return goodsOrderCell;
        }
        //票和小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            MyTicketAndGoodsOrderTableViewCell *ticketAndGoodsOrderCell= [[MyTicketAndGoodsOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            ticketAndGoodsOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            ticketAndGoodsOrderCell._deleteTicketAndGoodsDelegate = self;
            
            [ticketAndGoodsOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return ticketAndGoodsOrderCell;
        }
      
        return cell;
        
    }
    //待付款
    if (tableView == self._tableviewWaitPayment)
    {
//        NSLog(@"%ld",indexPath.row);
        myOrderListModel = [_arrayWaitPayment objectAtIndex:indexPath.row];
        
        //会员卡订单
        if(myOrderListModel.cardOrder != nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            MyVipCardOrderTableViewCell *vipCardOrderCell = [[MyVipCardOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            vipCardOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            vipCardOrderCell._deleteVipCardDelegate = self;
            
            [vipCardOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return vipCardOrderCell;
        }
        //票
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            MyTicketOrderTableViewCell *ticketOrderCell = [[MyTicketOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            ticketOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            ticketOrderCell._deleteTicketDelegate = self;
            
            [ticketOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return ticketOrderCell;
        }
        //小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            MyGoodsOrderTableViewCell *goodsOrderCell = [[MyGoodsOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            goodsOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            goodsOrderCell._deleteGoodsDelegate = self;
            
            [goodsOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return goodsOrderCell;
        }
        //票和小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            MyTicketAndGoodsOrderTableViewCell *ticketAndGoodsOrderCell= [[MyTicketAndGoodsOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            ticketAndGoodsOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            ticketAndGoodsOrderCell._deleteTicketAndGoodsDelegate = self;
            
            [ticketAndGoodsOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return ticketAndGoodsOrderCell;
        }
        
        return cell;
        
    }
    //待使用
    if (tableView == self._tableviewWaitUse)
    {
//        NSLog(@"%ld",indexPath.row);
        myOrderListModel = [_arrayWaitUse objectAtIndex:indexPath.row];
        
        //会员卡订单
        if(myOrderListModel.cardOrder != nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            MyVipCardOrderTableViewCell *vipCardOrderCell= [[MyVipCardOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            vipCardOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            vipCardOrderCell._deleteVipCardDelegate = self;
            
            [vipCardOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return vipCardOrderCell;
        }
        //票
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            MyTicketOrderTableViewCell *ticketOrderCell = [[MyTicketOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            ticketOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            ticketOrderCell._deleteTicketDelegate = self;
            
            [ticketOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return ticketOrderCell;
        }
        //小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            MyGoodsOrderTableViewCell *goodsOrderCell = [[MyGoodsOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            goodsOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            goodsOrderCell._deleteGoodsDelegate = self;
            
            [goodsOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return goodsOrderCell;
        }
        //票和小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            MyTicketAndGoodsOrderTableViewCell *ticketAndGoodsOrderCell = [[MyTicketAndGoodsOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            ticketAndGoodsOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            ticketAndGoodsOrderCell._deleteTicketAndGoodsDelegate = self;
            
            [ticketAndGoodsOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return ticketAndGoodsOrderCell;
        }
        
        return cell;
        
    }
    //退款
    if (tableView == self._tableviewRefund)
    {
//        NSLog(@"%ld",indexPath.row);
        
        myOrderListModel = [_arrayRefund objectAtIndex:indexPath.row];
        
        //会员卡订单
        if(myOrderListModel.cardOrder != nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            MyVipCardOrderTableViewCell *vipCardOrderCell  = [[MyVipCardOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            vipCardOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            vipCardOrderCell._deleteVipCardDelegate = self;
            
            [vipCardOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return vipCardOrderCell;
        }
        //票
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] == 0)
        {
            MyTicketOrderTableViewCell *ticketOrderCell= [[MyTicketOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            ticketOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            ticketOrderCell._deleteTicketDelegate = self;
            
            [ticketOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return ticketOrderCell;
        }
        //小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder== nil && [myOrderListModel.goodsOrderList count] > 0)
        {
            MyGoodsOrderTableViewCell *goodsOrderCell = [[MyGoodsOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            goodsOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            goodsOrderCell._deleteGoodsDelegate = self;
         
            [goodsOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return goodsOrderCell;
        }
        //票和小卖
        if(myOrderListModel.cardOrder == nil && myOrderListModel.ticketOrder != nil && [myOrderListModel.goodsOrderList count] > 0)
        {
//            NSLog(@"%ld",indexPath.row);
            MyTicketAndGoodsOrderTableViewCell *ticketAndGoodsOrderCell = [[MyTicketAndGoodsOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            ticketAndGoodsOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            ticketAndGoodsOrderCell._deleteTicketAndGoodsDelegate = self;
            
            [ticketAndGoodsOrderCell setOrderCellText:myOrderListModel index:indexPath.row time:_currentTime];
            return ticketAndGoodsOrderCell;
        }
        
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushDetailView:indexPath.row];
}

-(void)pushDetailView:(NSInteger)index
{
    MyOrderListModel *myOrderListModel = [[MyOrderListModel alloc ] init];
    
    if (_currentPageNum == 0)
    {
        myOrderListModel = [_arrayAllOrder objectAtIndex:index];
        
    }
    if (_currentPageNum == 1)
    {
         myOrderListModel = [_arrayWaitPayment objectAtIndex:index];;
        
    }
    if (_currentPageNum == 2)
    {
        myOrderListModel = [_arrayWaitUse objectAtIndex:index];
        
    }
    if (_currentPageNum == 3)
    {
         myOrderListModel = [_arrayRefund objectAtIndex:index];
    }
    
    TicketGoodsDetailViewController *ticketGoodsDetailController = [[TicketGoodsDetailViewController alloc ] init];
    ticketGoodsDetailController._orderDetialModel = myOrderListModel;
    [self.navigationController pushViewController:ticketGoodsDetailController animated:YES];
}

#pragma  mark scrollView Delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.width>SCREEN_WIDTH)
    {
        int page = floor((scrollView.contentOffset.x - SCREEN_WIDTH / 2) / SCREEN_WIDTH) + 1;
        _currentPageNum = page;
        if (page == 0)
        {
            [self onButtonTouch:_btnAllOrder];
        }
        else if(page == 1)
        {
           [self onButtonTouch:_btnWaitPayment];
        }
        else if(page == 2)
        {
            [self onButtonTouch:_btnWaitUse];
        }
        else
        {
            [self onButtonTouch:_btnRefund];
        }
    }
}

-(void)onButtonDeleteOrder:(UIButton *)btn
{
//    NSLog(@"%ld",btn.tag);
    _delIndex = btn.tag;
    
    _ordeModel = [[MyOrderListModel alloc]  init];
    
    if (_currentPageNum == 0)
    {
        _ordeModel =  _arrayAllOrder[btn.tag];
    }
    if (_currentPageNum == 1)
    {
        _ordeModel =  _arrayWaitPayment[btn.tag];
    }
    if (_currentPageNum == 2)
    {
        _ordeModel =  _arrayWaitUse[btn.tag];
    }
    if (_currentPageNum == 3)
    {
        _ordeModel =  _arrayRefund[btn.tag];
    }
    
    if ([btn.titleLabel.text isEqualToString:@"领取"])
    {
        [self pushDetailView:btn.tag];
    }
    else if ([btn.titleLabel.text isEqualToString:@"支付"])
    {
        [self toPayView:_ordeModel];
    }
    else
    {
        UIAlertView *alter = [[UIAlertView alloc ] initWithTitle:nil message:@"一定要删除这个订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //删除
        [self deleteOrder:_ordeModel index:_delIndex];
    }
}
#pragma mark 支付
-(void) toPayView:(MyOrderListModel *)ordeModel
{
    [MobClick event:myCenterViewbtn27];
    BuildOrderModel *_cardOrderModel = [[BuildOrderModel alloc ] init];
    PayViewController *payController = [[PayViewController alloc ] init];
    payController._orderId = ordeModel.orderId;
    _cardOrderModel.strAllPrice = [ordeModel.totalPrice stringValue];
    payController._orderModel =_cardOrderModel;
    payController._viewName = @"OrderView";
    payController.strOrderViewType = @"2";
    if (ordeModel.ticketOrder != nil)
    {
        payController.strOrderViewType = @"3";
    }
    if (ordeModel.cardOrder != nil)
    {
        payController.strOrderViewType = @"1";
    }
    [self.navigationController pushViewController:payController animated:YES];
}


#pragma mark 删除订单
-(void) deleteOrder:(MyOrderListModel *)ordeModel index:(NSInteger)tabIndex
{
    [MobClick event:myCenterViewbtn28];
    __weak typeof(self) weakSelf = self;
    NSArray *arr;
    if (_currentPageNum == 0)
    {
        arr = [NSArray arrayWithObjects:ordeModel.orderId, nil];
        [ServicesOrder deleteMyOrder:arr model:^(RequestResult *model)
         {
              _pageAllOrderIndex = 1;
             [_arrayAllOrder removeAllObjects];
             [weakSelf  loadMyAllorder];
             
         } failure:^(NSError *error) {
             [Tool showWarningTip:error.domain time:1];
         }];
    }
    if (_currentPageNum == 1)
    {
        arr = [NSArray arrayWithObjects:ordeModel.orderId, nil];
        [ServicesOrder deleteMyOrder:arr model:^(RequestResult *model)
         {
            _pagePaymentIndex = 1;
             [_arrayWaitPayment removeAllObjects];
             [weakSelf  loadMyWaitPaymentOrder];
             
         } failure:^(NSError *error) {
             [Tool showWarningTip:error.domain time:1];
         }];
    }
    if (_currentPageNum == 2)
    {
        arr = [NSArray arrayWithObjects:ordeModel.orderId, nil];
        [ServicesOrder deleteMyOrder:arr model:^(RequestResult *model)
         {
             _pageWaitUseIndex = 1;
             [_arrayWaitUse removeAllObjects];
             [weakSelf  loadMyWaitUserOrder];
             
         } failure:^(NSError *error) {
             [Tool showWarningTip:error.domain time:1];
         }];
    }
    if (_currentPageNum == 3)
    {
        arr = [NSArray arrayWithObjects:ordeModel.orderId, nil];
        [ServicesOrder deleteMyOrder:arr model:^(RequestResult *model)
         {
             _pageRefundIndex = 1;
             [_arrayRefund removeAllObjects];
             [weakSelf  loadMyRefundOrder];
             
         } failure:^(NSError *error) {
             [Tool showWarningTip:error.domain time:1];
         }];
    }
}

#pragma mark 刷新未支付订单
-(void) refreshUnPayOrder
{
    if (_isRefresh)
    {
        _isRefresh = FALSE;
        [_arrayWaitPayment removeAllObjects];
       
        if (_currentPageNum == 0)
        {
            _pageAllOrderIndex=1;
            [_arrayAllOrder removeAllObjects];
            [self performSelector:@selector(loadMyAllorder) withObject:nil afterDelay:0.2];
        }
        if (_currentPageNum == 1)
        {
            _pagePaymentIndex=1;
            [_arrayWaitPayment removeAllObjects];
             [self performSelector:@selector(loadMyWaitPaymentOrder) withObject:nil afterDelay:0.2];
        }
        if (_currentPageNum == 2)
        {
            _pageWaitUseIndex=1;
            [_arrayWaitUse removeAllObjects];
             [self performSelector:@selector(loadMyWaitUserOrder) withObject:nil afterDelay:0.2];
        }
        if (_currentPageNum == 3)
        {
            _pageRefundIndex=1;
            [_arrayRefund removeAllObjects];
             [self performSelector:@selector(loadMyRefundOrder) withObject:nil afterDelay:0.2];
        }
       
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
