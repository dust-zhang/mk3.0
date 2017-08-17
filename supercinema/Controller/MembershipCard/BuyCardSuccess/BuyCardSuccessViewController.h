//
//  BuyCardSuccessViewController.h
//  supercinema
//
//  Created by mapollo91 on 16/11/16.
//
//

#import <UIKit/UIKit.h>
#import "BuyCardSuccessTableViewCell.h"
#import "PurchaseSucceededLoadData.h"

@protocol payMemberDelegate <NSObject>
-(void)payLoadMember;
@end

@interface BuyCardSuccessViewController : HideTabBarViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView     *_tabViewBuyCardSuccess;

    
    NSMutableArray      *_arrayOrderList;

    int                 _paySuccessCountTime;
    BOOL                isPostMessage;
    
    UIView              *_viewTopBG;
    //购买类型Logo（三张图个子算高度）
    UIImageView         *_imageBuyTypeLogo;
    UILabel             *_labelPrice;
    //购买成功Logo
    UIImageView         *_imageSuccessLogo;
    
    BOOL                _isGetAward;
}

@property(nonatomic, strong)NSString    *_orderId;
@property(nonatomic, strong)NSString    *_title;
@property(nonatomic, strong)NSTimer     *_orderTimer;
@property(nonatomic, strong)NSString    *_strPayWay;
@property(nonatomic, strong)OrderInfoModel  *_modelOrderInfo;

@property(nonatomic, assign)id <payMemberDelegate> payDelegate;

@end
