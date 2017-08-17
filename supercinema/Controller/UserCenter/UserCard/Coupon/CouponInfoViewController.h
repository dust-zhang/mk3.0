//
//  CouponInfoViewController.h
//  supercinema
//
//  Created by mapollo91 on 26/11/16.
//
//

#import <UIKit/UIKit.h>
#import "CouponInfoTableViewCell.h"
#import "OfflineCouponDetailsViewController.h"
#import "RedPacketDetailsViewController.h"
#import "ExchangeVoucherDetailsViewController.h"
#import "CouponInfoModel.h"

@interface CouponInfoViewController : HideTabBarViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, CouponInfoTableViewCellDelegate, UIAlertViewDelegate>
{
    UIScrollView        *_scrollView;
    //有效 & 失效 按钮
    UIButton            *_btnEffective;
    UIButton            *_btnFailure;
    BOOL                isLoadAllPastDueCoupon;
    
    //按钮下的蓝色线
    UIView              *_viewLine;
    //有效 & 失效 View
    UIView              *_viewEffective;
    UIView              *_viewFailure;
    //有效 & 失效 列表
    UITableView         *_tableviewAllValid;
    UITableView         *_tableviewAllPastDue;
    //删除按钮
    UIButton            *_btnDeleteType;
    UIView              *_viewConfirmDeleteBG;
    //确定删除按钮
    UIButton            *_btnConfirmDelete;
    //删除显示状态
    BOOL                boolDeleteButtonShow;
    //当前页面
    int                 _iCurrentPageNumber;
    //红包剩余张数
    NSNumber            *_quantity;
    
    CouponModel         *_couponAllValidModel;
    CouponModel         *_couponAllPastDueModel;
    
    NSMutableArray      *_arrayAllValid;
    NSMutableArray      *_arrayAllPastDue;
    NSMutableArray      *_arrDelete;    //存储删除ID的数组
    int                 _orderType;     //有效往期标识
    
}

@end
