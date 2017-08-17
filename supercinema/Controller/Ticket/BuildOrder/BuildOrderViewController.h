//
//  BuildOrderViewController.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/10.
//
//

#import "HideTabBarViewController.h"
#import "BuildOrderModel.h"
#import "OrderGoodsView.h"
#import "GoodsListModel.h"
#import "OrderDiscountTableViewCell.h"
#import "PayViewController.h"
#import "OrderDiscountCardTableViewCell.h"
#import "BuyTicketSuccessViewController.h"

@interface BuildOrderViewController : HideTabBarViewController<UITableViewDelegate,UITableViewDataSource,OrderGoodsViewDelegate,OrderDiscountTableViewCellDelegate,UIAlertViewDelegate,OrderDiscountCardTableViewCellDelegate,PayFaildVIewDelegate>
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
    UILabel* _labelDikouPrice;
    
    UIView* _viewRule;
   
    /***** 订单table ******/
    OrderGoodsView* _orderGoodsView;
    
    NSString        *_orderId;
    
    /******  价格model ******/
    MemberPriceModel    *currentPriceModel;     //当前价格model
    MemberPriceModel *lastCurrentPriceModel;    //弹权益优惠前当前价格model
    
    /****** 算价 *******/
    float           saleTotalPrice;             //小卖合计价
    NSInteger       ticketNum;                  //票数
    int             currentUseCardNum;          //当前已用套票或任看卡张数
    int             lastCurrentUseCardNum;      //弹权益优惠前当前已用套票或任看卡张数
    float           _priceTicketZongji;         //票总价
    float           _lastPriceTicketZongji;     //弹权益优惠前票总价
    float           _priceSaleZongji;           //小卖总价
    float           _lastPriceSaleZongji;       //弹权益优惠前小卖总价
    float           _priceZongji;               //票+小卖总价
    float           _orginPriceZongji;          //初始的票+小卖总价
    float           _notAppointTotalPrice;      //非指定小卖总价
    float           _lastNotAppointTotalPrice;  //弹权益优惠前非指定小卖总价
    
    /***** 卡相关 ******/
    NSArray         *arrCanUseCard;             //返回的可用卡列表集合
    NSMutableArray  *_arrUsedCardState;         //可用卡列表状态model集合
    NSMutableArray         *_lastArrUsedCardState;     //弹权益优惠前可用卡列表状态model集合
    NSMutableArray  *_arrUsedCardName;          //使用的卡的名称集合
    
//    NSMutableArray  *arrayCanUseCard;   //可用卡集合（可变）
    NSNumber*           _taopiaoId;
    NSNumber*           _lastTaopiaoId;         //弹权益优惠前taopiaoid
    NSNumber*           _cikaId;
    NSNumber*       memberCardItemId;
    MemberPriceModel *exceptModel;              //次卡之外最优惠价格model
    NSMutableArray  *_arrUsedCardTicketName;    //使用的卡的名称集合,在票价左方显示
    NSMutableArray  *_arrUsedCardSaleName;      //使用的卡的名称集合,在小卖价左方显示
    NSMutableArray  *_arrayUsedCardIndex;
    int                 curCardNum;
    int                 lastCurCardNum;
    
    float           _priceDikou;                //抵扣金额
    float           _priceTicketDikou;          //票抵扣金额
    float           _lastPriceTicketDikou;      //弹权益优惠前票抵扣金额
    float           _priceSaleDikou;            //卖品抵扣金额
    float           _lastPriceSaleDikou;        //弹权益优惠前卖品抵扣金额
    float           _priceRealTicketDikou;      //票实际抵扣金额
    float           _lastPriceRealTicketDikou;  //弹权益优惠前票实际抵扣金额
    float           _priceRealSaleDikou;        //卖品实际抵扣金额
    float           _lastPriceRealSaleDikou;    //弹权益优惠前卖品实际抵扣金额
    float               _priceRealPay;          //实付总计
    /***** 红包相关 *****/
    BOOL                isHaveNotCommonTicket;        //是否用过不通用票红包
    BOOL                isHaveNotCommonSale;          //是否用过不通用卖品红包
    BOOL                lastIsHaveNotCommonTicket;    //弹权益优惠前是否用过不通用票红包
    BOOL                lastIsHaveNotCommonSale;      //弹权益优惠前是否用过不通用卖品红包
    NSArray             *_packetArr;                  //红包集合
    NSMutableArray      *arrayRedPacketModel;         //红包model数组
    NSMutableArray      *_lastArrRedPacketModel;      //弹权益优惠前红包model集合
    NSMutableArray      *_arrayPacketLimit;           //红包使用限制数组
    NSMutableArray      *_arrRedPackIds;              //红包ID数组
    NSMutableArray      *_lastArrRedPackIds;          //弹权益优惠前红包ID数组
    BOOL            isCanUseTicketPack;      //是否可再用票红包
    BOOL            isCanUseSalePack;        //是否可再用卖品红包
    BOOL            isHaveUseCountPack;      //是否用过数量红包
    BOOL            isHaveUseNotLimitPack;   //是否用过不限制红包
    BOOL            isHaveUseOrderPack;      //是否用过订单红包
    
    UIView          *_viewDiscount;
    UIView          *_viewAlpha;
    UITableView     *_myTable;
    UIButton        *_btnDiscount;
    
    int             _lockSeatTimeCount;     //订单轮询时间
    
    PayFaildVIew*   _payFaildView;
    
    UIImageView*    _imgShadow;
}
@property (nonatomic,strong)    NSArray         *_arrGoods;       //选中的小卖集合
@property (nonatomic,strong)    BuildOrderModel *_orderModel;
@property (nonatomic,strong)    PriceListModel  *priceListModel;  //票价格model
@property (nonatomic,strong)    NSArray         *arrGoodsList;    //选中的小卖集合
@property (nonatomic,assign)    int             smallSaleCount;   //小卖总份数
@property (nonatomic,assign)    float           smallSalePrice;
@property (nonatomic,strong)    NSArray         *_arrayGoods;     //选中的小卖的id－count集合
@property (nonatomic,assign)    BOOL            isFromSale;       //是否有小卖页
//轮询订单timer
@property (nonatomic,strong)    NSTimer *_orderTimer;
@end
