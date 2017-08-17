//
//  BuyTicketSuccessViewController.h
//  supercinema
//
//  Created by mapollo91 on 17/11/16.
//
//

#import <UIKit/UIKit.h>
#import "TicketDescribeTableViewCell.h"
#import "SmallSaleDescribeTableViewCell.h"
#import "PriceDescribeTableViewCell.h"
#import "PayFaildVIew.h"
#import "AwardView.h"
#import "PurchaseSucceededLoadData.h"

@interface BuyTicketSuccessViewController : HideTabBarViewController <UITableViewDelegate, UITableViewDataSource, SmallSaleDescribeCellDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    UITableView         *_tabViewBuyTicketSuccess;
    
    int                 _paySuccessCountTime;
    BOOL                _isContinueRequstPayReturnAPI;
    BOOL                isSkipCardpage;
    OrderWhileModel     *_orderModel;

    PayFaildVIew        *_payFaildView;
    
    NSArray             *_arrGoodsOrderList;
    OnlineTicketsModel  *_modelOnlineTickets;
    
    UIView              *_viewTopBG;
    
    //购买成功Logo
    UIImageView         *_imageSuccessLogo;
    
    //支付金额：
    UILabel             *_labelPrice;
    UIImageView         *_imageBuyTypeLogo;
    
    
    UILabel             *_textFieldCode[4];     //输入框
    UILabel             *_labelTopLine;         //输入框的线（上部分）
    UILabel             *_labelDownLine;        //输入框的线（下部分）
    UITextField         *_textField;            //输入核销码
    NSMutableArray      *_arrayVerticalLine;    //画框存线的字典（竖线）
    
    BOOL                _isGetAward;
    NSNumber            *_exchangeType;
    NSInteger           _exchangeIndex;
}

@property(nonatomic, strong)NSString        *_orderId;
@property(nonatomic, strong)NSString        *_title;
@property(nonatomic, strong)NSTimer         *_orderTimer;
@property(nonatomic, strong)NSString        *_strPayWay;
@property(nonatomic, strong)OrderInfoModel  *_modelOrderInfo;

@property(nonatomic, strong)GoodsListCardPackModel *_modeGoodsListCardPack;



@end
