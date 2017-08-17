//
//  SmallSaleViewController.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/10.
//
//

#import "HideTabBarViewController.h"
#import "BuildOrderModel.h"
#import "BuildOrderViewController.h"
#import "SmallSaleTableViewCell.h"
#import "SmallSaleModel.h"

@interface SmallSaleViewController : HideTabBarViewController<UITableViewDataSource,UITableViewDelegate,SmallSaleTableViewCellDelegate>
{
    UILabel         *_lablePriceSum;
    float           _defaultTotalPrice;
    float           _defaultServicePrice;
    UITableView     *_myTable;
    NSMutableArray  *_arrData;
    float           totalPrice;
    UIButton        *_btnConfirm;
}

@property (nonatomic,strong)    BuildOrderModel *_orderModel;
@property (nonatomic,strong)    UIImageView     *imageViewHead;
@property (nonatomic,strong)    NSArray         *_arrList;
@property (nonatomic,assign)    NSInteger       _showTimeId;
@property (nonatomic,strong)    PriceListModel  *priceListModel;   //票价格model
@end
