//
//  BuyCardSuccessViewController.m
//  supercinema
//
//  Created by mapollo91 on 16/11/16.
//
//

#import "BuyCardSuccessViewController.h"

@interface BuyCardSuccessViewController ()

@end

@implementation BuyCardSuccessViewController

- (void) viewDidAppear:(BOOL)animated
{
    //电池白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isPostMessage = FALSE;
    _arrayOrderList = [[NSMutableArray alloc ] initWithCapacity:0];
    _isGetAward = YES;
    
    [self initCtrl];
    [self loadOrderDetail];
}

-(void)initCtrl
{
    //顶部View（64高）
    [self._labelTitle setText:@"支付成功"];
    [self._labelTitle setTextColor:RGBA(255, 255, 255,1)];
    [self._btnBack setHidden:YES];
    self._labelTitle.frame = CGRectMake((SCREEN_WIDTH-180)/2, 36, 180, 17);
    [self._viewTop setBackgroundColor:RGBA(117, 112, 255, 1)];
    
    //隐藏线
    self._labelLine.hidden = YES;
    
    //返回首页
    UIButton *btnBackHomePage = [[UIButton alloc] initWithFrame:CGRectMake(15, 33, 44, 22)];
    [btnBackHomePage setBackgroundColor:[UIColor clearColor]];
    [btnBackHomePage.titleLabel setFont:MKFONT(15)];
    [btnBackHomePage setTitle:@"首页" forState:UIControlStateNormal];
    [btnBackHomePage setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [btnBackHomePage addTarget:self action:@selector(onButtonBackHomePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBackHomePage];
    
    //查看订单
    UIButton *btnLookOrder = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-68, 33, 68, 22)];
    [btnLookOrder setBackgroundColor:[UIColor clearColor]];
    [btnLookOrder.titleLabel setFont:MKFONT(15)];
    [btnLookOrder setTitle:@"查看订单" forState:UIControlStateNormal];
    [btnLookOrder setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [btnLookOrder addTarget:self action:@selector(onButtonLookOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLookOrder];
    
    _viewTopBG = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 125)];
    [_viewTopBG setBackgroundColor:RGBA(117, 112, 255, 1)];
    [self.view addSubview:_viewTopBG];
    
    //购买成功Logo
    _imageSuccessLogo = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, 3, 60, 60)];
    [_imageSuccessLogo setBackgroundColor:[UIColor clearColor]];
    [_imageSuccessLogo setImage:[UIImage imageNamed:@"image_buySuccess.png"]];
    [_viewTopBG addSubview:_imageSuccessLogo];
    
    //购买类型Logo（三张图各自算高度）
    _imageBuyTypeLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageBuyTypeLogo setBackgroundColor:[UIColor clearColor]];
    [_viewTopBG addSubview:_imageBuyTypeLogo];
    
    //支付金额：
    _labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(_imageSuccessLogo.frame.origin.x, _imageBuyTypeLogo.frame.origin.y+(_imageBuyTypeLogo.frame.size.height-15)/2, 40, 15)];
    [_labelPrice setBackgroundColor:[UIColor clearColor]];
    [_labelPrice setFont:MKFONT(15)];
    [_labelPrice setTextColor:RGBA(255, 255, 255, 1)];
    [_viewTopBG addSubview:_labelPrice];
    
    //TabView
    _tabViewBuyCardSuccess = [[UITableView alloc] initWithFrame:CGRectMake(0, _viewTopBG.frame.origin.y+_viewTopBG.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-118)];
    _tabViewBuyCardSuccess.delegate = self;
    _tabViewBuyCardSuccess.dataSource = self;
    [_tabViewBuyCardSuccess setBackgroundColor:RGBA(246, 246, 251, 1)];
    [_tabViewBuyCardSuccess setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_tabViewBuyCardSuccess];
}

#pragma mark 返回首页
-(void)onButtonBackHomePage
{
    [MobClick event:mainViewbtn87];
    //切换到看电影
    NSDictionary* dictHome = @{@"tag":@0};
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 查看订单
-(void)onButtonLookOrder
{
    [MobClick event:mainViewbtn88];
    MyOrderViewController *myOrderController = [[MyOrderViewController alloc] init];
    [self.navigationController pushViewController:myOrderController animated:YES];
}

#pragma mark 加载生成的订单信息
-(void)loadOrderDetail
{
    [_arrayOrderList removeAllObjects ];
    __weak BuyCardSuccessViewController *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesOrder getOrderDetail:self._orderId model:^(OrderInfoModel *model)//@"810000193733" 
     {
         
         weakself._modelOrderInfo = model;
         [_arrayOrderList addObject:model.cardOrder];
         [weakself reloadFrameAndData];
         [_tabViewBuyCardSuccess reloadData];
         [weakself getOrderStatus];
         [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
         
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
         [Tool showWarningTip:error.domain time:2];
     }];
    
}

-(void)reloadFrameAndData
{
    //微信Logo
    if ([self._strPayWay isEqualToString:@"WX_APP"])
    {
        _imageBuyTypeLogo.frame = CGRectMake(15*2, _imageSuccessLogo.frame.origin.y+_imageSuccessLogo.frame.size.height+15, 46/2, 44/2);
        [_imageBuyTypeLogo setImage:[UIImage imageNamed:@"image_weixinPay_white.png"]];
    }
    //支付宝Logo
    if ([self._strPayWay isEqualToString:@"ALIPAYCASH"])
    {
        _imageBuyTypeLogo.frame = CGRectMake(15*2, _imageSuccessLogo.frame.origin.y+_imageSuccessLogo.frame.size.height+15, 56/2, 44/2);
        [_imageBuyTypeLogo setImage:[UIImage imageNamed:@"image_zhifubaoPay_white.png"]];
    }
    //银联Logo
    if ([self._strPayWay isEqualToString:@"SXAPPLEPAY"])
    {
        _imageBuyTypeLogo.frame = CGRectMake(15*2, _imageSuccessLogo.frame.origin.y+_imageSuccessLogo.frame.size.height+15, 161/2, 47/2);
        [_imageBuyTypeLogo setImage:[UIImage imageNamed:@"image_unionpay.png"]];
    }
    [_labelPrice setText:[NSString stringWithFormat:@"支付金额：￥%@",[Tool PreserveTowDecimals:self._modelOrderInfo.totalPrice]]];
    [Tool setLabelSpacing:_labelPrice spacing:2 alignment:NSTextAlignmentLeft];
    
    _labelPrice.frame = CGRectMake(_imageSuccessLogo.frame.origin.x, _imageSuccessLogo.frame.origin.y+_imageSuccessLogo.frame.size.height+19, _labelPrice.frame.size.width, 15);//_imageBuyTypeLogo.frame.origin.x+_imageBuyTypeLogo.frame.size.width+15
    //重新排列显示购买类型与支付金额
    _imageBuyTypeLogo.frame = CGRectMake(_labelPrice.frame.origin.x-_imageBuyTypeLogo.frame.size.width-15, _imageSuccessLogo.frame.origin.y+_imageSuccessLogo.frame.size.height+15, _imageBuyTypeLogo.frame.size.width, _imageBuyTypeLogo.frame.size.height);
    
    //当支付金额为0元时，文案保持现有位置不用动。
    if ([Tool PreserveTowDecimals:self._modelOrderInfo.totalPrice] == 0)
    {
        //成功页不显示银行icon
        _imageBuyTypeLogo.hidden = YES;
    }
    
    //计算背景的高度
    _viewTopBG.frame = CGRectMake(0, 64, SCREEN_WIDTH, _imageBuyTypeLogo.frame.origin.y+_imageBuyTypeLogo.frame.size.height+20);
    
    if ([self._strPayWay isEqualToString:@""])
    {
        _viewTopBG.frame = CGRectMake(0, 64, SCREEN_WIDTH, _labelPrice.frame.origin.y+_labelPrice.frame.size.height+14);
    }
    
    _tabViewBuyCardSuccess.frame = CGRectMake(0, _viewTopBG.frame.origin.y+_viewTopBG.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-118);
    
}

#pragma mark 支付成功去检查订单状态
-(void)getOrderStatus
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"正验证购卡状态，请稍候" withBlur:NO allowTap:NO];
    self._orderTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(runOrderStatus:)
                                                      userInfo:nil
                                                       repeats:YES];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                             beforeDate:[NSDate dateWithTimeIntervalSinceNow:ORDERRUNMAXTIME]];
}

#pragma mark 轮询支付订单状态
-(void)runOrderStatus:(NSTimer*) timer
{
    _paySuccessCountTime++;
    __weak typeof(self) weakSelf = self;
    
    if ([self._orderId length] > 0)
    {
        __block PurchaseSucceededLoadData* obj = [[PurchaseSucceededLoadData alloc] init];
        [ServicesPay orderCycle:self._orderId model:^(OrderWhileModel *model)
         {
             NSLog(@"model.orderStatus\n%d",[model.orderStatus intValue]);
             //payStatus：30出卡成功
             
             if ([model.payStatus intValue] == 1)
             {
                 //payStatus：30出票成功，20出票失败
                 if ([model.orderStatus intValue ] == 30  && isPostMessage == FALSE )
                 {
                     isPostMessage = TRUE;//防止发送多次刷新请求
                     [weakSelf stopTimer];
                     [Tool showSuccessTip:@"购买成功"  time:1];
                     // 订单数据加载完成后，3秒自动跳转到卡包
                     if (_isGetAward)
                     {
                        [obj startAwardTimer:weakSelf.view orderId:weakSelf._orderId];
                         _isGetAward = NO;
                     }
                 }
                 if ([model.orderStatus intValue ] == 20 || [model.orderStatus intValue ] == 40 || [model.orderStatus intValue ]== 100 || [model.orderStatus intValue ] == 110 || _paySuccessCountTime >= ORDERRUNMAXTIME)
                 {
                     _paySuccessCountTime = 0;
                     [weakSelf stopTimer];
                     [Tool showWarningTip:@"购卡失败" time:1];
                     [weakSelf performSelector:@selector(backMemberCard) withObject:weakSelf afterDelay:3];
                 }
             }
             else
             {
                 [weakSelf stopTimer];
                 [Tool showWarningTip:@"购卡失败" time:1];
                 [weakSelf performSelector:@selector(backMemberCard) withObject:weakSelf afterDelay:3];
             }
             
             
         } failure:^(NSError *error) {
             [weakSelf stopTimer];
             [Tool showWarningTip:error.domain time:1 ];
             [weakSelf performSelector:@selector(backMemberCard) withObject:weakSelf afterDelay:3];
         }];
    }
}

-(void)stopTimer
{
    [self._orderTimer invalidate];
    self._orderTimer = nil;
}

-(void)backMemberCard
{
    //订单取消后返回到首页
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -4)] animated:YES];
}

#pragma mark - TableViewDelegate
//Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    10+10+30+15+10+12+15+10+10+0.5+15+15+15+10+15+16 +15+1+30+11+30
//    return 295.5;
    
    BuyCardSuccessTableViewCell *cell = (BuyCardSuccessTableViewCell *)[self tableView:_tabViewBuyCardSuccess cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}

//Cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayOrderList count];
}

//Cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardOrderModel *cardOrderModel = [_arrayOrderList objectAtIndex:indexPath.row];
    
    NSLog(@"%@",[cardOrderModel toJSONString]);
    
    static NSString *identifier = @"BuyCardSuccessTableViewCell";
    BuyCardSuccessTableViewCell *cell;
    
    if (cell == nil)
    {
        cell = [[BuyCardSuccessTableViewCell alloc] initWithReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell._modelOrderInfo = self._modelOrderInfo;
    //购买成功详情Cell
    [cell setBuyCardSuccessDetailsCellFrameData:cardOrderModel];
   
    return cell;
}



@end







