//
//  PayViewController.h
//  movikr
//
//  Created by Mapollo27 on 15/7/29.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayTableViewCell.h"
#import "OrderModel.h"
#import "BuildOrderModel.h"
#import "PayFaildVIew.h"
#import "HideTabBarViewController.h"
#import "BuyCardSuccessViewController.h"
#import "BuyTicketSuccessViewController.h"
#import "SaleSuccessViewController.h"
#import <PassKit/PassKit.h>
#import "ApplePayPMCHmacmd5AndDescrypt.h"
#import "ApplePayRequestViewController.h"

@protocol  reLoadMemberDelegate<NSObject>
@optional
-(void)getMemberCard;
@end


@interface PayViewController : HideTabBarViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,PKPaymentAuthorizationViewControllerDelegate, reLoadMemberDelegate>
{
    NSMutableArray  *_arrayPayWay;
    UIButton        *btnCheck[3];
    UITableView     *_tablePay;
    NSInteger       _nSelectPayWay;
    NSInteger       _nPayWay;
    UILabel         *_lableTime;
    NSTimer         *_countTimer;
    NSInteger       _serviceTime;
    PayTypeModel    *_payModel;
    //支付成功后计时器
    NSInteger       _paySuccessCountTime;
    //接口返回是否可以继续请求
    BOOL            _isContinueRequstPayReturnAPI;
    NSString        *_newOrderId;
    UIButton        *_btnPay;
    PayFaildVIew    *_payFaildView;
//    BOOL            isSkipCardpage;
    PayModelList    *_payModelList;
   
    ApplePayRequestViewController *_applePayRVC;
    //支付
    PKPaymentRequest    *_request;
    PKShippingMethod    *_expressShipping;
    ApplePayModel       *_applePayModel;
    UIAlertController   *_alertVC;
}

@property (nonatomic, copy)     NSArray<PKPaymentSummaryItem *> *SummaryItems;
@property (nonatomic,strong)    NSString                        *_orderId;
//上个view
@property (nonatomic,strong)    NSString                        *_viewName;
//轮询订单timer
@property (nonatomic,strong)    NSTimer                         *_orderTimer;
@property (nonatomic,strong)    BuildOrderModel                 *_orderModel;
@property (nonatomic,assign)    id <reLoadMemberDelegate>       _Delegate;
@property (nonatomic,assign)    BOOL                            isHaveSale;    //是否有小卖,选择页
@property (nonatomic,strong)    NSString                        *_payType;
@property (nonatomic,assign)    float                           _priceSale;
@property (nonatomic,strong)    NSString*                       strOrderViewType; //1卡 2小卖 3票
@property (nonatomic,assign)    BOOL                            isHaveSaleVC;
@end
