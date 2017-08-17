//
//  PayViewController.m
//  movikr
//
//  Created by Mapollo27 on 15/7/29.
//  Copyright (c) 2015年 movikr. All rights reserved.
//
/*
 orderStatus: 主订单状态，具体值如下：
 0-新建(此时订单对用户不可见)，
 10-创建成功(调用FinishOrder时所有子订单创建成功，此后主订单再不允许添加子订单),
 20-创建失败(调用了FinishOrder时部分或全部子订单创建失败，此后主订单再不允许添加子订单)，
 30-成功(已支付，且所有子订单都成功)，
 40-失败(已支付，但部分或全部子订单失败)
 100-已取消(用户在支付前主动取消)
 110 超时，系统主动释放订单，
 */

#import "PayViewController.h"
#import "PayModel.h"
#import "MKPayManager.h"

@interface PayViewController ()

@end

@implementation PayViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopTimer];
    [self killTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _nSelectPayWay = 0; //默认没有选择支付方式
    _paySuccessCountTime = 0;
    _isContinueRequstPayReturnAPI = YES;
    _newOrderId = @"";
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGBA(255, 255, 255,1)];
    _arrayPayWay = [[NSMutableArray alloc ] initWithCapacity:0];
    [self initViewCtrl];
    //加载支付方式
    [self loadPayWay];
    
    //微信支付成功通知
    [[NSNotificationCenter defaultCenter ]addObserver:self
                                            selector:@selector(weiXinPaySuccess)
                                            name:NOTIFITION_WEIXINPAYSUCCESS
                                            object:nil];
    
    //支付宝支付成功通知
    [[NSNotificationCenter defaultCenter ]addObserver:self
                                             selector:@selector(weiXinPaySuccess)
                                                 name:NOTIFITION_ALIPAYSUCCESS
                                               object:nil];

    //唤起app重新加载时间
    [[NSNotificationCenter defaultCenter ]addObserver:self
                                             selector:@selector(reCountTime)
                                                 name:NOTIFITION_RELOADCOUNTTIME
                                               object:nil];
    if (_applePayRVC)
    {
        _applePayRVC = nil;
    }
    _applePayRVC = [[ApplePayRequestViewController alloc] init];
}

-(void)reCountTime
{
    if ( [[NSString stringWithFormat:@"%@",[self.navigationController.topViewController class] ] isEqualToString:@"PayViewController"])
    {
        __weak typeof(self) weakSelf = self;
        [ServicesPay getPayWayList:self._orderId model:^(PayModelList *payModelList)
         {
             [weakSelf setCountdown:[Tool calcSysTimeLength:payModelList.payEndTime SysTime:payModelList.currentTime]];//
         } failure:^(NSError *error) {
             
             if(error.code == -38)
             {
                 [weakSelf setCountdown:0];
             }
             else
             {
                 [Tool showWarningTip:error.domain time:1];
             }
             
         }];

    }
}

#pragma mark 初始化控件
-(void) initViewCtrl
{
    //影院名称
    self._labelTitle.text = @"支付";
    //时间
    _lableTime =[[UILabel alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 20, 85, 40)];
    [_lableTime setBackgroundColor:[UIColor clearColor]];
    [_lableTime setTextAlignment:NSTextAlignmentRight];
    [_lableTime setText:self._orderModel.strDate ];
    [_lableTime setTextColor:RGBA(249, 81, 81, 1)];
    [_lableTime setFont:MKFONT(16)];
    [self.view addSubview:_lableTime];
    if ([self._viewName isEqualToString:@"UserVIPView"])
    {
        [_lableTime setHidden:YES];
    }
    
    _tablePay= [[UITableView alloc ] initWithFrame:CGRectMake(0, self._viewTop.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT- self._viewTop.frame.size.height-60) style:UITableViewStylePlain];
    _tablePay.dataSource = self;
    _tablePay.delegate = self;
    [_tablePay setBackgroundColor:RGBA(246, 246, 251,1)];
    _tablePay.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tablePay];
    
    UIImageView *imageView = [[UIImageView alloc ] initWithFrame:CGRectMake(0, _tablePay.frame.origin.y+_tablePay.frame.size.height-6, SCREEN_WIDTH, 6)];
    [imageView setImage:[UIImage imageNamed:@"img_public_shadow.png"]];
    [self.view addSubview:imageView];
    
    //支付
    _btnPay = [[UIButton alloc] initWithFrame:CGRectMake(15,SCREEN_HEIGHT-50 , SCREEN_WIDTH-30, 40)];
    [_btnPay setBackgroundColor:[UIColor blackColor]];
    _btnPay.layer.masksToBounds = YES;
    _btnPay.layer.cornerRadius = 20;
    
    if ([self._viewName isEqualToString:@"SaleOrderView"])
    {
        [_btnPay setTitle:[NSString stringWithFormat:@"确认支付 ￥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:self._priceSale]]] forState:UIControlStateNormal];
    }
    else
    {
        [_btnPay setTitle:[NSString stringWithFormat:@"确认支付 ￥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:[self._orderModel.strAllPrice floatValue]]]] forState:UIControlStateNormal];
    }
    [_btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnPay.titleLabel setFont:MKFONT(15) ];
    [_btnPay addTarget:self action:@selector(onButtonPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnPay];
}

#pragma mark 重新选座(后退 取消订单)
-(void) onButtonBack
{
    UIAlertView *alter = [[UIAlertView alloc ] initWithTitle:@"是否取消订单" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alter show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2000)
    {
        if ([self._viewName isEqualToString:@"SaleOrderView"])
        {
            //回小卖部，清理库存
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHGOODS object:nil];
        }
        
        //页面跳转至个人中心首页
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate switchTab:2];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        if (buttonIndex == 1)
        {
            //会员卡单独购买(取消)
            if ([self._viewName isEqualToString:@"UserVIPView"] || [self._viewName isEqualToString:@"SaleOrderView"] || [self._viewName isEqualToString:@"OrderView"]    )
            {
                [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"正在取消订单" withBlur:NO allowTap:NO];
                [ServicesOrder orderCancel:self._orderId model:^(CancelOrderModel *model)
                 {
                     [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
                     //返回时，要杀掉timer
                     [weakSelf killTimer];
                     
                     [_lableTime setHidden:YES];
                     if( [weakSelf._viewName isEqualToString:@"OrderView"])
                     {
                         [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_REFRESHORDER object:nil];
                         [weakSelf.navigationController popViewControllerAnimated:YES];
                     }
                     else if ([weakSelf._viewName isEqualToString:@"SaleOrderView"])
                     {
                         //回小卖部，清理库存
                         [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHGOODS object:nil];
                         [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                     }
                     else
                     {
                         [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:0] animated:YES];
                     }
                     
                 } failure:^(NSError *error) {
                     [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
                     [weakSelf killTimer];
                     [Tool showWarningTip:error.domain time:2];
                     if( [weakSelf._viewName isEqualToString:@"OrderView"])
                     {
                         [weakSelf.navigationController popViewControllerAnimated:YES];
                     }
                     else if ([weakSelf._viewName isEqualToString:@"SaleOrderView"])
                     {
                         //回小卖部，清理库存
                         [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHGOODS object:nil];
                         [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                     }
                     else
                     {
                         [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:0] animated:YES];
                     }
                     [_lableTime setHidden:YES];
                 }];
            }
            else
            {
                //取消订单
                [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
                [ServicesOrder orderCancel:self._orderId model:^(CancelOrderModel *model)
                 {
                     [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
                     if ([weakSelf._viewName isEqualToString:@"CardDetailView"] || [weakSelf._viewName isEqualToString:@"ChooseSeatView"])
                     {
                         NSDictionary* dict = @{@"seatArray":model.seatNumbers};
                         [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_CANCELORDERSUCCESS object:nil userInfo:dict];
                         [weakSelf.navigationController popViewControllerAnimated:YES];
                     }
                     else
                     {
                         NSInteger index = 4;
                         if (!weakSelf.isHaveSaleVC)
                         {
                             index = 3;
                         }
                         [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHSEATS object:nil];
                         [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex: ([weakSelf.navigationController.viewControllers count] -index)] animated:YES];
                     }
                     //返回时，要杀掉timer
                     [weakSelf killTimer];
                 } failure:^(NSError *error) {
                     [FVCustomAlertView hideAlertFromView:weakSelf.view fading:NO];
                     [weakSelf killTimer];
                     [Tool showWarningTip:error.domain time:2];
                     if ([weakSelf._viewName isEqualToString:@"CardDetailView"])
                     {
                         [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_CANCELORDERFAILED object:nil];
                         [weakSelf.navigationController popViewControllerAnimated:YES];
                     }
                     else
                     {
                         [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex: ([weakSelf.navigationController.viewControllers count] -(weakSelf.isHaveSale?4:3))] animated:YES];
                     }
                 }];
            }
        }
    }
}

#pragma mark 倒计时
-(void)setCountdown:(NSInteger) time
{
    _serviceTime = time;
    _lableTime.text = [Tool convertTime:time];
    
    if (time >=0)
    {
        [self killTimer];
        _serviceTime = time;
        _countTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_countTimer forMode:NSRunLoopCommonModes];
    }
    else
    {
        _lableTime.text = @"00:00";
    }
}

// 倒计时响应的方法.
- (void)timeAction:(NSTimer *)timer
{
    if (_serviceTime <= 0)
    {
        _lableTime.text = @"00:00";
        [self killTimer];
        [Tool showWarningTip:@"订单支付超时啦~请重新下单~" time:1.5];
        [self performSelector:@selector(backView) withObject:self afterDelay:1.6];
        return;
    }
    _lableTime.text = [Tool convertTime: _serviceTime--];
}

-(void) backView
{
    if( [self._viewName isEqualToString:@"OrderView"])
    {
        [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_REFRESHORDER object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([self._viewName isEqualToString:@"SaleOrderView"])
    {
        //回小卖部，清理库存
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHGOODS object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([self._viewName isEqualToString:@"UserVIPView"])
    {
         [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        //后退到排期
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -(self.isHaveSale?5:4))] animated:YES];
    }
}

#pragma mark 加载支付方式
-(void) loadPayWay
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载支付方式" withBlur:NO allowTap:NO];
    [ServicesPay getPayWayList:self._orderId model:^(PayModelList *payModelList)
    {
        [_arrayPayWay removeAllObjects];
        _payModelList =payModelList;
        _arrayPayWay = [[NSMutableArray alloc ] initWithArray:payModelList.list];
        //如果不支持，则删除apple pay
        [weakSelf isShowApplePayIcon];
        [_tablePay reloadData];
        //数据加载成功后开始倒计时15分钟
        [weakSelf setCountdown:[Tool calcSysTimeLength:payModelList.payEndTime SysTime:payModelList.currentTime]];
        
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
    } failure:^(NSError *error) {
       [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"出错了，请稍后在我的订单里支付吧～" message:nil delegate:weakSelf cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        alert.tag = 2000;
        [alert show];
    }];
}

#pragma mark 是否显示apple pay 图标
-(void) isShowApplePayIcon
{
    if( ![self isSupportApplePay] )
    {
        for (int i = 0; i < [_arrayPayWay count]; i++)
        {
            PayTypeModel *model = [[PayTypeModel alloc ] init];
            model =_arrayPayWay[i];
            if ([model.payTypeCode isEqualToString:@"SXAPPLEPAY"])
            {
                [_arrayPayWay removeObjectAtIndex:i];
                break;
            }
        }
    }
}

#pragma mark 不支付直接轮询支付成功
-(void)notPayRunPayStatus
{
    if ([self._viewName isEqualToString:@"OrderView"])
    {
        [self waitPayOrderSuccess:self.strOrderViewType];
    }
    else if ([self._viewName isEqualToString:@"UserVIPView"])
    {
        //购买会员卡
        [self buyMemberCardSuccess];
    }
    else if ([self._viewName isEqualToString:@"SaleOrderView"])
    {
        //购买小卖
        [self buyMemberSaleSuccess];
    }
    else
    {
        //支付成功后 ，验证订单是否成功
        [self orderIsSuccess];
    }
    
}

#pragma mark支付
-(void) onButtonPay
{
    [MobClick event:mainViewbtn50];
    if ( [_payModelList.notNeedPay boolValue] )
    {
        _newOrderId = @"1";
        [self notPayRunPayStatus];
    }
    else
    {
        PayTypeModel *model= _arrayPayWay[_nSelectPayWay];
        _nPayWay =[model.payTypeId intValue];
        self._payType = model.payTypeCode;
        if ([model.payTypeCode isEqualToString:@"WX_APP"])
        {
            [MobClick event:mainViewbtn47];
            [Config savePayWay:model.payTypeCode];
            [self getWeixinPayInfo];
        }
        if( [model.payTypeCode isEqualToString:@"ALIPAYCASH"] )
        {
            [MobClick event:mainViewbtn48];
            [Config savePayWay:model.payTypeCode];
            [self zhifubaoPay];
        }
        if( [model.payTypeCode isEqualToString:@"SXAPPLEPAY"] )
        {
            [MobClick event:mainViewbtn49];
            [Config savePayWay:model.payTypeCode];
            [self getApplePayInfo];
        }
        
    }
}

#pragma mark 获取支付宝支付信息
-(void) zhifubaoPay
{
     __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载支付信息" withBlur:NO allowTap:NO];
    [ServicesPay getPayDetail:self._orderId payType:_nPayWay model:^(ThirdPayModel *thirdPayModel)
    {
        //支付成功后，重新获取支付订单
        _newOrderId =thirdPayModel.payOrderId;
        [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
        //支付宝支付
        [MKPayManager zhifubaoPay:thirdPayModel.formXml model:^(ZhifubaoModel *zfbModel)
        {
             //支付成功
             if ([zfbModel.resultStatus intValue] == 9000)
             {
                 if ([weakSelf._viewName isEqualToString:@"OrderView"])
                 {
                     [weakSelf waitPayOrderSuccess:weakSelf.strOrderViewType];
                 }
                 else if ([weakSelf._viewName isEqualToString:@"UserVIPView"])
                 {
                     //购买会员卡
                     [weakSelf buyMemberCardSuccess];
                 }
                 else if ([weakSelf._viewName isEqualToString:@"SaleOrderView"])
                 {
                     //购买小卖
                     [weakSelf buyMemberSaleSuccess];
                 }
                 else
                 {
                     //支付成功后 ，验证订单是否成功
                     [weakSelf orderIsSuccess];
                 }
             }
         }];
        
    } failure:^(NSError *error) {
        if (error.code == -1001 || error.code == 20000)
        {
            [Tool showWarningTip:error.domain time:2.0];
            return;
        }
        if ([weakSelf._viewName isEqualToString:@"SaleOrderView"])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHGOODS object:nil];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [weakSelf backViewControllor:error index:4];
        }
    }];
}

#pragma mark 获取微信支付信息
-(void) getWeixinPayInfo
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载支付信息" withBlur:NO allowTap:NO];
    if([self isSupportWXPay])
    {
        __weak typeof(self) weakSelf = self;
        [ServicesPay getPayDetail:self._orderId payType:_nPayWay model:^(ThirdPayModel *thirdPayModel)
        {
            [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
            
            _newOrderId =thirdPayModel.payOrderId;
            WeinxinPayModel *wxPayModel = [[WeinxinPayModel alloc]
                                           initWithString:[[Tool dictionaryWithJsonString:thirdPayModel.formXml] JSONString]
                                           error:nil];
            //微信支付
            [MKPayManager weixinPay:wxPayModel];
            
        } failure:^(NSError *error) {
            //如果支付成功，跳转到出票view
            if (error.code == -1001 || error.code == 20000)
            {
                [Tool showWarningTip:error.domain time:2.0];
                return;
            }
            if(error.code  == -37)
            {
                [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
                [weakSelf weiXinPaySuccess];
            }
            else
            {
                if ([weakSelf._viewName isEqualToString:@"SaleOrderView"])
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHGOODS object:nil];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
                else
                {
                    [weakSelf backViewControllor:error index:4];
                }
            }
        }];
        
    }
}
#pragma mark 是否支持微信支付
-(BOOL) isSupportWXPay
{
    if (![WXApi isWXAppInstalled])
    {
        [Tool showWarningTip:@"没有安装微信"  time:1];
        return FALSE;
    }
    else if (![WXApi isWXAppSupportApi])
    {
        [Tool showWarningTip:@"微信版本不支持"  time:1];
        return FALSE;
    }
    return TRUE;
}

#pragma mark 微信支付成功
-(void)weiXinPaySuccess
{
    if ([self._viewName isEqualToString:@"OrderView"])
    {
        [self waitPayOrderSuccess:self.strOrderViewType];
    }
    else if ([self._viewName isEqualToString:@"UserVIPView"])
    {
        //购买会员卡
        [self buyMemberCardSuccess];
    }
    else if ([self._viewName isEqualToString:@"SaleOrderView"])
    {
        //购买小卖
        [self buyMemberSaleSuccess];
    }
    else
    {
        //支付成功后 ，验证订单是否成功
        [self orderIsSuccess];
    }
}

#pragma mark 购买会员卡成功
-(void) buyMemberCardSuccess
{
    BuyCardSuccessViewController *buyCardSuccessView = [[BuyCardSuccessViewController alloc ] init];
    buyCardSuccessView._orderId = self._orderId;
    buyCardSuccessView._title =self._orderModel.strCinema;
    buyCardSuccessView._strPayWay =self._payType;
    [self.navigationController pushViewController:buyCardSuccessView animated:YES];

}

#pragma mark 购买小卖成功
-(void) buyMemberSaleSuccess
{
    SaleSuccessViewController *SaleSuccessVC = [[SaleSuccessViewController alloc] init];
    SaleSuccessVC._orderId = self._orderId;
    SaleSuccessVC._title =self._orderModel.strCinema;
    SaleSuccessVC._strPayWay =self._payType;
    [self.navigationController pushViewController:SaleSuccessVC animated:YES];
}

#pragma mark 支付成功去检查订单状态()
-(void)orderIsSuccess
{
   [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"验证支付状态，请稍候" withBlur:NO allowTap:NO];
    self._orderTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(runOrderStatus:)
                                                      userInfo:nil
                                                       repeats:YES];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                             beforeDate:[NSDate dateWithTimeIntervalSinceNow:ORDERRUNMAXTIME]];

}

#pragma mark 轮询支付订单状态（查看支付状态是否成功）
-(void)runOrderStatus:(NSTimer*) timer
{
    //支付成功计时器
    _paySuccessCountTime++;
    
    if ([_newOrderId length] > 0)
    {
        __weak typeof(self) weakSelf = self;
        [ServicesPay orderCycle:self._orderId model:^(OrderWhileModel *model)
        {
             //payStatus：0未支付，1已支付
             if ([model.payStatus intValue ] == 1 )
             {
                 [weakSelf killTimer];
                 [weakSelf stopTimer];
                 [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
                 //支付成功跳转到下一页

                if ( [[NSString stringWithFormat:@"%@",[self.navigationController.topViewController class] ] isEqualToString:@"PayViewController"])
                {
                    BuyTicketSuccessViewController *buyTicketSuccessVC = [[BuyTicketSuccessViewController alloc ] init];
                    buyTicketSuccessVC._orderId =weakSelf._orderId;
                    buyTicketSuccessVC._strPayWay = weakSelf._payType;
                    [weakSelf.navigationController pushViewController:buyTicketSuccessVC animated:YES];
                }
             }
             if ([model.payStatus intValue ] == 0 )
             {
                 [weakSelf mainOrderFaild:model];
             }
         
         } failure:^(NSError *error) {
            [weakSelf killTimer];
            [weakSelf stopTimer];
            [Tool showWarningTip:error.domain time:2];
         }];
    }
}

#pragma mark 订单支付验证失败
-(void) mainOrderFaild:(OrderWhileModel *)model
{
    //支付成功后，如果超过60秒还没有成功，则去服务器验证是否支付成功
    if(_paySuccessCountTime > ORDERRUNTIMELENG && _isContinueRequstPayReturnAPI == YES)
    {
        __weak typeof(self) weakSelf = self;
        //请求服务器端支付接口，验证是否支付成功
        [ServicesPay payReturn:[NSString stringWithFormat:@"%ld",(long)_paySuccessCountTime] orderId:_newOrderId model:^(PayReturnModel *model)
        {
            if([model.canContinue intValue] == 0)
            {
                _isContinueRequstPayReturnAPI = FALSE;
            }
        } failure:^(NSError *error) {
            [weakSelf stopTimer];
            [Tool showWarningTip:error.domain time:2];
        }];
    }
    //超时60秒，并且服务器返回状态不可继续请求
    if(_paySuccessCountTime >= ORDERRUNMAXTIME || _isContinueRequstPayReturnAPI == FALSE)
    {
        [self killTimer];
        [self stopTimer];
        [Tool showWarningTip:@"支付失败,请重试."  time:2];
    }
}

//订单轮询计时器
-(void) stopTimer
{
    if (self._orderTimer)
    {
        [self._orderTimer invalidate];
        self._orderTimer = nil;
    }
}
//倒计时计时器
-(void) killTimer
{
    if(_countTimer)
    {
        [_countTimer invalidate];
        _countTimer = nil;
    }
}

#pragma mark UITableView delegate
//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

//cell 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayPayWay count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"UITableViewCell";
    PayTableViewCell *cell=(PayTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
    {
        cell = [[PayTableViewCell alloc] initWithReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    _payModel =_arrayPayWay[indexPath.row];
    [cell setCellData:_payModel];
    //选中button
    if(!btnCheck[indexPath.row])
    {
        btnCheck[indexPath.row]  = [[UIButton alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-30-21, 10+61/2, 21, 21)];
        [btnCheck[indexPath.row] addTarget:self action:@selector(onButtonCheck:) forControlEvents:UIControlEventTouchUpInside];
        [btnCheck[indexPath.row] setBackgroundImage:[UIImage imageNamed:@"image_buynocheck.png"] forState:UIControlStateNormal];
        btnCheck[indexPath.row].tag =indexPath.row;
        [cell addSubview:btnCheck[indexPath.row]];
    }
    if (indexPath.row == [_arrayPayWay count]-1)
    {
        [self setDefaultPayWay ];
    }
    return cell;
}

-(void) setDefaultPayWay
{
    if ([[Config getPayWay] length] == 0)
    {
        [self selectCell:0];
        return;
    }
    for (int i = 0 ; i <_arrayPayWay.count ; i++)
    {
        _payModel =_arrayPayWay[i];
        if ( [[Config getPayWay] isEqualToString:_payModel.payTypeCode])
        {
            [self selectCell:i];
            return;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectCell:indexPath.row];
}
-(void)selectCell:(NSInteger) tag
{
    [self checkImageStatus:tag];
}
-(void)onButtonCheck:(UIButton *) btn
{
    [self checkImageStatus:btn.tag];
}
-(void)checkImageStatus:(NSInteger) tag
{
    _nSelectPayWay = tag;
    int tagNext = 0;
    int tagNextNext = 0;
    if (tag == 0)
    {
        tagNext = 1;
        tagNextNext = 2;
    }
    if (tag == 1)
    {
        tagNext = 0;
        tagNextNext = 2;
    }
    if (tag == 2)
    {
        tagNext = 0;
        tagNextNext = 1;
    }
    [btnCheck[tag] setBackgroundImage:[UIImage imageNamed:@"image_buycheck.png"] forState:UIControlStateNormal];
    [btnCheck[tagNext] setBackgroundImage:[UIImage imageNamed:@"image_buynocheck.png"] forState:UIControlStateNormal];
    [btnCheck[tagNextNext] setBackgroundImage:[UIImage imageNamed:@"image_buynocheck.png"] forState:UIControlStateNormal];
}

//会员卡购买delegate
-(void)payLoadMember
{
    if ([self._Delegate respondsToSelector:@selector(getMemberCard)])
    {
        [self._Delegate getMemberCard];
    }
}

#pragma mark 获取Apple Pay支付信息
-(void) getApplePayInfo
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载支付信息" withBlur:NO allowTap:NO];
    if([self isSupportApplePay])
    {
        __weak typeof(self) weakSelf = self;
        [ServicesPay getPayDetail:self._orderId payType:_nPayWay model:^(ThirdPayModel *thirdPayModel)
         {
             [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
             _newOrderId =thirdPayModel.payOrderId;
             ApplePayModel *applePayModel = [[ApplePayModel alloc]
                                            initWithString:[[Tool dictionaryWithJsonString:thirdPayModel.formXml] JSONString]
                                            error:nil];
             
             [weakSelf applePay:applePayModel];
             
         } failure:^(NSError *error) {
             if (error.code == -1001 || error.code == 20000)
             {
                 [Tool showWarningTip:error.domain time:2.0];
                 return;
             }
             [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
             if ([weakSelf._viewName isEqualToString:@"SaleOrderView"])
             {
                 [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHGOODS object:nil];
                 [weakSelf.navigationController popToRootViewControllerAnimated:YES];
             }
             else
             {
                 [weakSelf backViewControllor:error index:4];
             }
         }];
    }
}

-(void) applePay:(ApplePayModel*)_model
{
    _applePayModel = _model;
    _request = [[PKPaymentRequest alloc] init];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"超影文化科技（北京）有限公司" amount:[NSDecimalNumber decimalNumberWithString:_applePayModel.v_amount]];
    _expressShipping = [PKShippingMethod summaryItemWithLabel:@"超影文化科技（北京）有限公司" amount:[NSDecimalNumber decimalNumberWithString:_applePayModel.v_amount]];
    _expressShipping.identifier = _applePayModel.v_ordername;
    _expressShipping.detail = _applePayModel.v_ordername;
    _request.shippingMethods = @[_expressShipping];
    self.SummaryItems = @[total];
    
    _request.paymentSummaryItems = self.SummaryItems;
    _request.countryCode = @"CN";
    _request.currencyCode = @"CNY";
    _request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay];
    _request.merchantIdentifier =MerchantId;
    _request.merchantCapabilities = PKMerchantCapabilityEMV|PKMerchantCapability3DS;
    _request.requiredBillingAddressFields = PKAddressFieldNone;
    _request.requiredShippingAddressFields = PKAddressFieldNone;
    _request.shippingType = PKShippingTypeDelivery;
    PKPaymentAuthorizationViewController *paymentAVC = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:_request];
    paymentAVC.delegate = self;
    //paymentPane  不存在
    if (paymentAVC)
    {
        [self presentViewController:paymentAVC animated:TRUE completion:nil];
    }
    else
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"授权页面对象创建失败,支付环境不满足" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            //点击了确定事件
        }];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark 是否支持apple pay
-(BOOL) isSupportApplePay
{
    if(SYSTEMVERSION < 9.2)
    {
        return FALSE;
    }
    if (![PKPaymentAuthorizationViewController class])
    {
        return FALSE;
    }
    //检查当前设备是否可以支付
    if (![PKPaymentAuthorizationViewController canMakePayments])
    {
        //支付需iOS9.0以上支持
        return FALSE;
    }
    //检查用户是否可进行某种卡的支付，是否支持Amex、MasterCard、Visa与银联四种卡，根据自己项目的需要进行检测
    NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks])
    {
        return FALSE;
    }
    return TRUE;
    
}
#pragma mark -- 选择shippingMethod  刷新SummaryItems
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus status,NSArray<PKPaymentSummaryItem *> *summaryItems))completion
{
    completion(PKPaymentAuthorizationStatusSuccess,self.SummaryItems);
}

-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingContact:(PKContact *)contact
                               completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion
{
    completion(PKPaymentAuthorizationStatusSuccess,@[_expressShipping],self.SummaryItems);
}

#pragma mark --弹起授权页面会走这里  选择了支付卡片  获得支付卡的类型 借记卡、信用卡
//NS_AVAILABLE_IOS(9_0) 弹起授权页面会走这里  选择了支付卡片
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectPaymentMethod:(PKPaymentMethod *)paymentMethod
                                completion:(void (^)(NSArray<PKPaymentSummaryItem *> *summaryItems))completion
{
    _applePayRVC.CardType = paymentMethod.type;
    completion(self.SummaryItems);
}
#pragma mark 请求完毕 获取到payment数据
//进行了指纹验证，token  配送地址等会发给apple服务器进行签名，然后在这里拿到payment  取这里面的东西进行支付
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    NSData* data = payment.token.paymentData;
    NSString* paymentDataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //0： 预售权交易  1： 消费交易请求
    NSString *requestInfo = [MKPayManager PayNormaWith:paymentDataStr applePayModel:_applePayModel];
    //调用支付或者是预授权方法
    [_applePayRVC ApplePayRequestWithPara:requestInfo withComplete:^(ApplePayResultStatus status,NSString *desc)
    {
        switch (status)
        {
            case ApplePaySuccess:
            {
                completion(PKPaymentAuthorizationStatusSuccess);
            }
                break;
            case ApplePayFailed:
            {
                completion(PKPaymentAuthorizationStatusFailure);
            }
                break;
            case ApplePayPending:
            {
                completion(PKPaymentAuthorizationStatusFailure);
            }
                break;
            case ApplePaySystemError:
            {
                completion(PKPaymentAuthorizationStatusFailure);
            }
                break;
                
            default:
                break;
        }
        if (_alertVC)
        {
            [_alertVC dismissViewControllerAnimated:YES completion:nil];
        }
        [self applePaySuccess:status withDesc:desc];
    }];
}

#pragma mark -- 对支付的结果进行分类处理
-(void)applePaySuccess:(int)status withDesc:(NSString *)desc
{
    if (status == 0 )
    {
        if ([self._viewName isEqualToString:@"OrderView"])
        {
            [self waitPayOrderSuccess:self.strOrderViewType];
        }
        else if ([self._viewName isEqualToString:@"UserVIPView"])
        {
            //购买会员卡
            [self buyMemberCardSuccess];
        }
        else if ([self._viewName isEqualToString:@"SaleOrderView"])
        {
            //购买小卖
            [self buyMemberSaleSuccess];
        }
        else
        {
            //支付成功后 ，验证订单是否成功
            [self orderIsSuccess];
        }
    }
    else
    {
         [Tool showWarningTip:desc time:3];
    }
}

#pragma mark -- 支付/预授权完成，支付页面dismiss 或者是取消支付、取消预授权等操作
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:^{
        if (_applePayRVC.isPayMent)
        {
            _alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"支付正在进行中，请等待支付结果" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:_alertVC animated:YES completion:nil];
        }
    }];
}

-(void)waitPayOrderSuccess:(NSString*)type
{
    if ([type isEqualToString:@"1"])
    {
        //卡
        [self buyMemberCardSuccess];
    }
    else if ([type isEqualToString:@"2"])
    {
        //小卖
        [self buyMemberSaleSuccess];
    }
    else
    {
        //票
        [self orderIsSuccess];
    }
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter ] removeObserver:NOTIFITION_WEIXINPAYSUCCESS];
    [[NSNotificationCenter defaultCenter ] removeObserver:NOTIFITION_ALIPAYSUCCESS];
    [[NSNotificationCenter defaultCenter ] removeObserver:NOTIFITION_RELOADCOUNTTIME];
}

@end
