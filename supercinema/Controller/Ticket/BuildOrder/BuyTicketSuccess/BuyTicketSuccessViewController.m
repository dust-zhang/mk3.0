//
//  BuyTicketSuccessViewController.m
//  supercinema
//
//  Created by mapollo91 on 17/11/16.
//
//

#import "BuyTicketSuccessViewController.h"

@interface BuyTicketSuccessViewController ()

@end

@implementation BuyTicketSuccessViewController


- (void) viewDidAppear:(BOOL)animated
{
    //电池白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _orderModel = [[OrderWhileModel alloc ] init];
    isSkipCardpage = TRUE;
    _paySuccessCountTime = 0;
    _isContinueRequstPayReturnAPI = YES;
    _isGetAward = YES;
    _exchangeType = 0;
    _exchangeIndex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initCtrl];
    [self loadOrderDetail];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}

-(void)initCtrl
{
    //顶部View（64高）
    [self._labelTitle setText:@"支付成功"];
    [self._labelTitle setTextColor:RGBA(255, 255, 255,1)];
    self._labelTitle.frame = CGRectMake((SCREEN_WIDTH-180)/2, 36, 180, 17);
    [self._btnBack setHidden:YES];
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
    
    //购买类型Logo（三张图个子算高度）
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
    _tabViewBuyTicketSuccess = [[UITableView alloc] initWithFrame:CGRectMake(0, _viewTopBG.frame.origin.y+_viewTopBG.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-(_viewTopBG.frame.origin.y+_viewTopBG.frame.size.height))];
    _tabViewBuyTicketSuccess.delegate = self;
    _tabViewBuyTicketSuccess.dataSource = self;
    [_tabViewBuyTicketSuccess setBackgroundColor:RGBA(246, 246, 251, 1)];
    [_tabViewBuyTicketSuccess setSeparatorColor:[UIColor clearColor]];
    [self.view addSubview:_tabViewBuyTicketSuccess];
}

#pragma mark 返回首页
-(void)onButtonBackHomePage
{
    //切换到看电影
    [MobClick event:mainViewbtn52];
    NSDictionary* dictHome = @{@"tag":@0};
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -5)] animated:YES];
}

#pragma mark 查看订单
-(void)onButtonLookOrder
{
    [MobClick event:mainViewbtn53];
    MyOrderViewController *myOrderController = [[MyOrderViewController alloc] init];
    [self.navigationController pushViewController:myOrderController animated:YES];
}

#pragma mark 获取订单详情接口
-(void) loadOrderDetail
{
    __weak BuyTicketSuccessViewController *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"正在出票，请稍候..." withBlur:NO allowTap:NO];
    [ServicesOrder getOrderDetail:self._orderId model:^(OrderInfoModel *model)//@"810000196134"
     {
         weakself._modelOrderInfo = model;
         
         [weakself reloadFrameAndData];
         [_tabViewBuyTicketSuccess reloadData];
         
         [weakself getOrderStatus];
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
         [Tool showWarningTip:error.domain time:2];
     }];
}

//支付成功后，再次请求订单详情接口，刷新UI，显示订单号以及取票吗
-(void)loadGetOrderInfo
{
    __weak BuyTicketSuccessViewController *weakself = self;
    [ServicesOrder getOrderDetail:self._orderId model:^(OrderInfoModel *model)//@"810000196134"
     {
         weakself._modelOrderInfo = model;
         
         [weakself reloadFrameAndData];
         [_tabViewBuyTicketSuccess reloadData];
         
     } failure:^(NSError *error) {
         [Tool showWarningTip:error.domain time:2];
     }];
}

//刷新数据
-(void)reloadFrameAndData
{
    int type = 0;
    //微信Logo
    if ([self._strPayWay isEqualToString:@"WX_APP"])
    {
        type = 1;
        _imageBuyTypeLogo.frame = CGRectMake(15*2, _imageSuccessLogo.frame.origin.y+_imageSuccessLogo.frame.size.height+15, 46/2, 44/2);
        [_imageBuyTypeLogo setImage:[UIImage imageNamed:@"image_weixinPay_white.png"]];
    }
    //支付宝Logo
    if ([self._strPayWay isEqualToString:@"ALIPAYCASH"])
    {
        type = 2;
        _imageBuyTypeLogo.frame = CGRectMake(15*2, _imageSuccessLogo.frame.origin.y+_imageSuccessLogo.frame.size.height+15, 56/2, 44/2);
        [_imageBuyTypeLogo setImage:[UIImage imageNamed:@"image_zhifubaoPay_white.png"]];
    }
    //银联Logo
    if ([self._strPayWay isEqualToString:@"SXAPPLEPAY"])
    {
        type = 3;
        _imageBuyTypeLogo.frame = CGRectMake(15*2, _imageSuccessLogo.frame.origin.y+_imageSuccessLogo.frame.size.height+15, 161/2, 47/2);
        [_imageBuyTypeLogo setImage:[UIImage imageNamed:@"image_unionpay.png"]];
    }
    
    //金额
    [_labelPrice setText:[NSString stringWithFormat:@"支付金额：￥%@",[Tool PreserveTowDecimals:self._modelOrderInfo.totalPrice]]];
    [Tool setLabelSpacing:_labelPrice spacing:2 alignment:NSTextAlignmentLeft];
    
    _labelPrice.frame = CGRectMake(_imageSuccessLogo.frame.origin.x, _imageSuccessLogo.frame.origin.y+_imageSuccessLogo.frame.size.height+19, _labelPrice.frame.size.width, 15);
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
    
    if (type == 0)
    {
        _viewTopBG.frame = CGRectMake(0, 64, SCREEN_WIDTH, _labelPrice.frame.origin.y+_labelPrice.frame.size.height+14);
    }
}

#pragma mark 支付成功去检查订单状态
-(void)getOrderStatus
{
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
             
             _orderModel = model;
             if ([model.payStatus intValue] == 1)
             {
                 //payStatus：30出票成功，20出票失败
                 if ([model.orderStatus intValue ] == 30)
                 {
                     [weakSelf stopTimer];
                     [Tool showSuccessTip:@"购买成功"  time:1];
                     // 订单数据加载完成后，3秒自动跳转到卡包
                     if (_isGetAward)
                     {
                         [obj startAwardTimer:weakSelf.view orderId:weakSelf._orderId];
                         _isGetAward = NO;
                     }
                     //重新获取取票吗
                     [weakSelf loadGetOrderInfo];
                     //                 [weakSelf performSelector:@selector(onButtonOK) withObject:self afterDelay:3];
                 }
                if([model.orderStatus intValue ] == 20 || [model.orderStatus intValue ] == 40 || [model.orderStatus intValue ]== 100 || [model.orderStatus intValue ] == 110)
                 {
                     [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
                     _paySuccessCountTime = 0;
                     [weakSelf stopTimer];
                     [weakSelf showOrderFaildView:_orderModel];
                 }
                 if(_paySuccessCountTime >= ORDERRUNMAXTIME)
                 {
                     //轮询超时60秒出票还没有成功，弹框提醒
                     [FVCustomAlertView hideAlertFromView:weakSelf.view fading:YES];
                     [weakSelf stopTimer];
                     UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"提示" message:@"当前网络环境不佳，您可稍后在卡包中查看购票结果。如有疑问，请致电\n4000-681-681" delegate:self cancelButtonTitle:@"返回影院首页" otherButtonTitles:nil, nil];
                     [alertView show];
                 }
             }
//             else
//             {
//                 [weakSelf stopTimer];
//                 UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"提示" message:@"当前网络环境不佳，您可稍后在卡包中查看购票结果。如有疑问，请致电\n4000-681-681" delegate:self cancelButtonTitle:@"返回影院首页" otherButtonTitles:nil, nil];
//                 [alertView show];
//             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [_tabViewBuyTicketSuccess reloadData];
             });
             
             
         } failure:^(NSError *error) {
             [Tool showWarningTip:error.domain time:2.0];
             [weakSelf stopTimer];
             [weakSelf showOrderFaildView:_orderModel];
         }];
    }
}

-(void) stopTimer
{
    [self._orderTimer invalidate];
    self._orderTimer = nil;
}

#pragma mark 失败view
-(void) showOrderFaildView:(OrderWhileModel *)model
{
    [MobClick event:mainViewbtn58];
    if(!_payFaildView)
    {
        _payFaildView = [[PayFaildVIew alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) orderModel:model];
        _payFaildView.hidden=YES;
        _payFaildView.alpha=0;
        _payFaildView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        [self.view addSubview:_payFaildView];
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         _payFaildView.transform = CGAffineTransformMakeScale(1, 1);
                         _payFaildView.hidden=NO;
                         _payFaildView.alpha=1;
                     }completion:^(BOOL finish){
                         
                     }];
}

//关闭失败view
-(void) closeFaildView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         _payFaildView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                         _payFaildView.alpha=0;
                     }completion:^(BOOL finish){
                         [_payFaildView removeFromSuperview];
                         _payFaildView = nil;
                     }];
    //关闭后跳转到卡包
    [self backMember];
}

-(void)backMember
{
    //订单取消后返回到首页
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -4)] animated:YES];
}

#pragma mark - 领取小卖
-(void)makeContentView{
    //弹起的View
    UIView *contentSetView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height -213-128, self.view.frame.size.width, 128)];
    contentSetView.backgroundColor = RGBA(255, 255, 255, 1);
    
    _textField = [[UITextField alloc ] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _textField.delegate = self;
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [_textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.backgroundColor = [UIColor redColor];
    [contentSetView addSubview:_textField];
    
    //四个输入框线
    _labelTopLine= [[UILabel alloc ] initWithFrame:CGRectMake((SCREEN_WIDTH-40*4)/2, 30, 40*4, 1)];
    [_labelTopLine setBackgroundColor:RGBA(204, 204, 204, 1)];
    [contentSetView addSubview:_labelTopLine];
    
    _labelDownLine= [[UILabel alloc ] initWithFrame:CGRectMake((SCREEN_WIDTH-40*4)/2, 70, 40*4, 1)];
    [_labelDownLine setBackgroundColor:RGBA(204, 204, 204, 1)];
    [contentSetView addSubview:_labelDownLine];
    
    _arrayVerticalLine = [[NSMutableArray alloc ] initWithCapacity:0];
    for(int i = 0 ;i < 5 ;i++)
    {
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-40*4)/2 +40*i,30,1, 40)];
        lineImageView.backgroundColor = RGBA(204, 204, 204, 1);
        [contentSetView addSubview:lineImageView];
        [_arrayVerticalLine addObject:lineImageView];
    }
    
    //输入框
    for (int i = 0; i < 5-1; i++)
    {
        _textFieldCode[i] = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-40*4)/2 +40*i,30,40, 40)];
        [_textFieldCode[i] setTextAlignment:NSTextAlignmentCenter];
        [_textFieldCode[i] setFont:MKFONT(20)];
        [_textFieldCode[i] setBackgroundColor:[UIColor clearColor]];
        [contentSetView addSubview:_textFieldCode[i]];
    }
    
    //核销描述
    UILabel *labelDescribe = [[UILabel alloc] initWithFrame:CGRectMake(0, _labelDownLine.frame.origin.y+_labelDownLine.frame.size.height+15, SCREEN_WIDTH, 14)];
    [labelDescribe setBackgroundColor:[UIColor clearColor]];
    [labelDescribe setFont:MKFONT(14)];
    [labelDescribe setTextColor:RGBA(204, 204, 204, 1)];
    [labelDescribe setTextAlignment:NSTextAlignmentCenter];
    [labelDescribe setText:@"到影院卖品柜台请工作人员输入4位核销码"];
    [contentSetView addSubview:labelDescribe];
    
    [[ExAlertView sharedAlertView] setShowContentView:contentSetView];
}

-(void)onButtonReceiveSmallSale:(NSString *)goodsOrderId exchangeType:(NSNumber *)exchangeType Index:(NSInteger)index
{
    [MobClick event:mainViewbtn54];
    _exchangeType = exchangeType;
    _exchangeIndex = index;
    PWAlertView *alertView = [[PWAlertView alloc]initWithTitle:@"是否核销？" message:@"" sureBtn:@"是" cancleBtn:@"否"];
    alertView.resultIndex = ^(NSInteger index)
    {
        NSLog(@"%ld",(long)index);
        if (index == 2)
        {
            //兑换方式 1:需要核销，0:不需要核销
            if ([_exchangeType intValue] == 0)
            {
                //不需要核销码
                [self directlyReceiveGoods];
            }
            else
            {
                //需要核销码（弹起键盘）
                [self makeContentView];
                [_textField becomeFirstResponder];
            }
        }
    };
    [alertView showMKPAlertView];
    
}

//直接兑换小卖
-(void)directlyReceiveGoods
{
    __weak BuyTicketSuccessViewController *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesGoods exchangeGoods:self._modeGoodsListCardPack.goodsOrderId code:_textField.text model:^(RequestResult *model)
     {
         self._modeGoodsListCardPack.useStatus = @1;
         [_tabViewBuyTicketSuccess reloadData];
         [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
         
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
         self._modeGoodsListCardPack.useStatus = @0;
         [Tool showWarningTip:error.domain time:1];
     }];
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
////    [self.navigationController popToRootViewControllerAnimated:NO];
//    
//    //点击是 进行兑换
//    if (buttonIndex == 1)
//    {
//        if ([_exchangeType intValue] == 0)
//        {
//            //不需要核销码
//            [self directlyReceiveGoods];
//        }
//        else
//        {
//            //需要核销码（弹起键盘）
//            [self makeContentView];
//            [_textField becomeFirstResponder];
//        }
//    }
//}

//键盘输入核销码
-(void)textChange:(UITextField *)textField
{
    if ([_textField.text length] >= 4)
    {
        __weak BuyTicketSuccessViewController *weakself = self;
        [_textField resignFirstResponder];
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
        [ServicesGoods exchangeGoods:self._modeGoodsListCardPack.goodsOrderId code:_textField.text model:^(RequestResult *model)
         {
             self._modeGoodsListCardPack.useStatus = @1;
             
             [_tabViewBuyTicketSuccess reloadData];
             [[ExAlertView sharedAlertView]dismissAlertView];
             
             [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
             
         } failure:^(NSError *error) {
             [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
             self._modeGoodsListCardPack.useStatus = @0;
             [[ExAlertView sharedAlertView]dismissAlertView];
             [Tool showWarningTip:error.domain time:1];
             [weakself resetCodeText];
         }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    }
    else if(string.length == 0)
    {
        [self setDeleteCodeText:textField.text.length text:string];
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= 4)
    {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }
    else
    {
        [self setSetCodeText:textField.text.length text:string];
        return YES;
    }
}

- (void)setSetCodeText:(NSInteger)count text:(NSString *)textNum
{
    textNum = @"●";
    [_textFieldCode[count] setText:textNum ];
}

- (void)setDeleteCodeText:(NSInteger)count text:(NSString *)textNum
{
    [_textFieldCode[count-1] setText:textNum];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}

#pragma mark 清空核销码
-(void) resetCodeText
{
    _textField.text = @"";
    for (int i = 0; i < 4; i++)
    {
        _textFieldCode[i].text = @"";
    }
}


- (void)keyboardWasShown:(NSNotification *)notification
{
    
    NSDictionary *info = [notification userInfo];
    
    //double duration  = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat curkeyBoardHeight = [[info objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[info objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[info objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat keyBoardHeight;
    
    /*! 第三方键盘回调三次问题，监听仅执行最后一次 */
    if(begin.size.height > 0 && (begin.origin.y - end.origin.y > 0))
    {
        keyBoardHeight = curkeyBoardHeight;
        [[ExAlertView sharedAlertView] showAlertViewWithAlertContentViewKeyboardHeight:keyBoardHeight];
    }
}

- (void)keyboardWasHidden:(NSNotification *)notification
{
    [[ExAlertView sharedAlertView] dismissAlertView];
}



#pragma mark - TableViewDelegate
//Cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self tableView:_tabViewBuyTicketSuccess cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}

//Cell行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self._modelOrderInfo.goodsOrderList count]+2;
}

//Cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (indexPath.row == 0)
    {
        //票信息
        static NSString *identifier = @"TicketDescribeTableViewCell";
        TicketDescribeTableViewCell * cell = (TicketDescribeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[TicketDescribeTableViewCell alloc] initWithReuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        
        TicketDescribeTableViewCell * tableCell = (TicketDescribeTableViewCell *)cell;
        OnlineTicketsModel *modelOnlineTickets = self._modelOrderInfo.onlineTickets;
        [tableCell setTicketDescribeCellFrameData:modelOnlineTickets orderWhileModel:_orderModel];
        
        return cell;
    }
    else if (indexPath.row <= [self._modelOrderInfo.goodsOrderList count])
    {
        //小卖信息
        static NSString *identifier = @"SmallSaleDescribeTableViewCell";
        SmallSaleDescribeTableViewCell * cell = (SmallSaleDescribeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[SmallSaleDescribeTableViewCell alloc] initWithReuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.smallSaleCellDelegate = self;
        }
       
        SmallSaleDescribeTableViewCell * tableCell = (SmallSaleDescribeTableViewCell *)cell;
        self._modeGoodsListCardPack = [self._modelOrderInfo.goodsOrderList objectAtIndex:(indexPath.row -1)];
        [tableCell setSmallSaleDescribeCellFrameData:self._modeGoodsListCardPack orderWhileModel:_orderModel];
        [tableCell setIndex:indexPath.row];
        
        return cell;
    }
    else
    {
        //金额信息
        static NSString *identifier = @"PriceDescribeTableViewCell";
        PriceDescribeTableViewCell * cell = (PriceDescribeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[PriceDescribeTableViewCell alloc] initWithReuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        
        PriceDescribeTableViewCell * tableCell = (PriceDescribeTableViewCell *)cell;
        [tableCell setPriceDescribeCellFrameData:self._modelOrderInfo];
        return cell;
    }
}




@end


