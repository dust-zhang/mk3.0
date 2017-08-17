//
//  SaleOrderViewController.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/16.
//
//

#import "HideTabBarViewController.h"
#import "OrderSaleView.h"
#import "SaleDiscountTableViewCell.h"
#import "PayViewController.h"

@interface SaleOrderViewController : HideTabBarViewController<OrderSaleViewDelegate,UITableViewDelegate,UITableViewDataSource,SaleDiscountTableViewCellDelegate,UIAlertViewDelegate>
{
    /***** 底部view ******/
    UIView* _viewFooter;
    UILabel*  _labelRealPrice;
    UIImageView* _imageArrowUp;
    UIButton* _btnConfirm;
    UIView* _footerAlpha;
    UILabel* _labelTip;
    UIView* _viewline;
    UILabel* _labelHeji;
    UILabel* _labelDikou;
    UILabel* _labelHejiPrice;
    float   _dikouPrice;
    UILabel* _labelDikouPrice;
    
    /****** 小卖列表 *****/
    OrderSaleView* _orderSaleView;
    
    UIButton        *_btnDiscount;
    UIView          *_viewAlpha;
    UIView          *_viewDiscount;
    UIView* _viewRule;
    
    /****** 红包相关 ******/
    UITableView*        _myTable;
    NSArray             *_packetArr;        //红包集合
    NSMutableArray      *arrayRedPacketModel;   //红包model数组
    BOOL                isHaveNotCommonSale;          //是否用过不通用卖品红包
    BOOL                lastIsHaveNotCommonSale;          //弹权益优惠前是否用过不通用卖品红包
    NSMutableArray             *_lastArrRedPacketModel;     //弹权益优惠前红包model集合
    NSMutableArray* _arrRedPackIds;        //红包ID数组
    NSMutableArray* _lastArrRedPackIds;      //弹权益优惠前红包ID数组
    NSMutableArray* _arrayPacketLimit;    //红包使用限制数组
    
    /****** 算价 *******/
    float              _priceRealPay;          //实付总计
    float           _priceDikou;            //抵扣金额
    float           _priceRealDikou;        //卖品实际抵扣金额
    float           _lastPriceDikou;        //弹权益优惠前票抵扣金额
    float           _lastPriceRealDikou;    //弹权益优惠前票实际抵扣金额
    float           _notAppointTotalPrice;  //非指定小卖总价
    float           _lastNotAppointTotalPrice;  //弹权益优惠前非指定小卖总价
    
    int             _lockSeatTimeCount;     //订单轮询时间
    
    NSString        *_orderId;
    
    UIImageView*    _imgShadow;
    NSTimer         *_orderTimer;
    
}
@property (nonatomic,assign)    float           totalPrice;
@property (nonatomic,assign)    int             smallSaleCount;   //小卖总份数
@property (nonatomic,strong)    NSString        *_strCardName;  //卡名称
@property (nonatomic,assign)    int             cardId;
@property (nonatomic,strong)    NSArray         *_arrGoods;       //选中的小卖集合
@property (nonatomic,strong)    NSArray         *_arrayGoods;     //选中的小卖的id－count集合

@end
