//
//  MyOrderViewController.h
//  supercinema
//
//  Created by dust on 16/11/24.
//
//

#import <UIKit/UIKit.h>
#import "MyGoodsOrderTableViewCell.h"
#import "MyTicketAndGoodsOrderTableViewCell.h"
#import "MyTicketOrderTableViewCell.h"
#import "MyVipCardOrderTableViewCell.h"
#import "TicketGoodsDetailViewController.h"
#import "MyOrderModel.h"
#import "PayViewController.h"
#import "LoadFailedView.h"

@interface MyOrderViewController : HideTabBarViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,deleteTicketDelegate,deleteTicketAndGoodsDelegate,deleteGoodsDelegate,deleteVipCardDelegate,UITextFieldDelegate>
{
    UIScrollView        *_scrollView;
    UIButton            *_btnAllOrder;
    UIButton            *_btnWaitPayment;
    UIButton            *_btnWaitUse;
    UIButton            *_btnRefund;
    UIView              *_viewLine;
    NSMutableArray      *_arrayAllOrder;
    NSMutableArray      *_arrayWaitPayment;
    NSMutableArray      *_arrayWaitUse;
    NSMutableArray      *_arrayRefund;
    int                 _currentPageNum;
    UILabel             *_textFieldCode[4];
    UIImageView         *_imageViewAllOrder;
    UIImageView         *_imageViewPayment;
    UIImageView         *_imageViewWaitUse;
    UIImageView         *_imageViewRefund;
    UILabel             *_labelAllOrder;
    UILabel             *_labelPayment;
    UILabel             *_labelWaitUse;
    UILabel             *_labelRefund;
    UILabel             *_viewAllOrder;
    UILabel             *_viewPayment;
    UILabel             *_viewWaitUse;
    UILabel             *_viewRefund;
    int                 _pageAllOrderIndex;
    int                 _pagePaymentIndex;
    int                 _pageWaitUseIndex;
    int                 _pageRefundIndex;
    BOOL                _isRefresh;
    MyOrderListModel    *_ordeModel;
    NSInteger           _delIndex;
    NSNumber            *_currentTime;
    LoadFailedView      *_viewLoadFailedAll;
    LoadFailedView      *_viewLoadFailedWaitPayment;
    LoadFailedView      *_viewLoadFailedWaitUse;
    LoadFailedView      *_viewLoadFailedRefund;
    
    NSMutableArray      *_arrIsLoadData;
    
}

@property (nonatomic,strong) UITableView         *_tableviewAllOrder;
@property (nonatomic,strong) UITableView         *_tableviewWaitPayment;
@property (nonatomic,strong) UITableView         *_tableviewWaitUse;
@property (nonatomic,strong) UITableView         *_tableviewRefund;
@end
