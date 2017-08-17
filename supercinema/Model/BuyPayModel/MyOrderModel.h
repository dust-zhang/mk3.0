//
//  MyOrderModel.h
//  supercinema
//
//  Created by dust on 16/11/29.
//
//

#import <JSONModel/JSONModel.h>

//0未退款、1（已申请退款）2(退款成功)、3(退款失败)、4（部分退款）5（退款失败，需要人工退款）
//0未支付，1已支付

@protocol MyOrderListModel;
@interface MyOrderModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional> *respStatus;
@property (nonatomic,strong) NSString<Optional> *respMsg;
@property (nonatomic,strong) NSNumber<Optional> *pageSize;
@property (nonatomic,strong) NSNumber<Optional> *pageIndex;
@property (nonatomic,strong) NSNumber<Optional> *pageTotal;
@property (nonatomic,strong) NSNumber<Optional> *currentTime;
@property (nonatomic,strong) NSArray<MyOrderListModel,Optional> *orderList;
@end


@interface MyTicketOrderModel : JSONModel
@property (nonatomic,strong) NSString<Optional> *subOrderId;
@property (nonatomic,strong) NSString<Optional> *movieTitle;
@property (nonatomic,strong) NSNumber<Optional> *startPlayTime;
@property (nonatomic,strong) NSNumber<Optional> *ticketCount;
@property (nonatomic,strong) NSNumber<Optional> *orderStatus;
@property (nonatomic,strong) NSNumber<Optional> *payStatus;
@property (nonatomic,strong) NSNumber<Optional> *refundStatus;
@end

@interface MyCardOrderModel : JSONModel
@property (nonatomic,strong) NSString<Optional> *subOrderId;
@property (nonatomic,strong) NSString<Optional> *cardName;
@property (nonatomic,strong) NSNumber<Optional> *orderStatus;
@property (nonatomic,strong) NSNumber<Optional> *refundStatus;
@property (nonatomic,strong) NSNumber<Optional> *payStatus;
@property (nonatomic,strong) NSNumber<Optional> *activeTime;
@end

@interface MyGoodsOrderListModel : JSONModel
@property (nonatomic,strong) NSString<Optional> *subOrderId;
@property (nonatomic,strong) NSString<Optional> *goodsName;
@property (nonatomic,strong) NSNumber<Optional> *goodsCount;
@property (nonatomic,strong) NSNumber<Optional> *orderStatus;
@property (nonatomic,strong) NSNumber<Optional> *validEndTime;
@property (nonatomic,strong) NSNumber<Optional> *exchangeTime;
@property (nonatomic,strong) NSNumber<Optional> *payStatus;
@property (nonatomic,strong) NSNumber<Optional> *refundStatus;
@end

//订单列表
@protocol MyGoodsOrderListModel;
@interface MyOrderListModel : JSONModel
@property (nonatomic,strong) NSString<Optional> *orderId;
@property (nonatomic,strong) NSNumber<Optional> *createTime;
@property (nonatomic,strong) NSNumber<Optional> *totalPrice;
@property (nonatomic,strong) NSNumber<Optional> *orderStatus;
@property (nonatomic,strong) NSNumber<Optional> *payStatus;
@property (nonatomic,strong) NSNumber<Optional> *refundStatus;
@property (nonatomic,strong) NSNumber<Optional> *canDelete;
@property (nonatomic,strong) NSNumber<Optional> *orderShowStatus;                       //订单显示状态
@property (nonatomic,strong) NSNumber<Optional> *payEndTime;                            //支付截止时间
@property (nonatomic,strong) CinemaModel<Optional> *cinema;                             //影院信息
@property (nonatomic,strong) MyTicketOrderModel<Optional> *ticketOrder;                 //票订单
@property (nonatomic,strong) MyCardOrderModel<Optional> *cardOrder;                     //卡订单
@property (nonatomic,strong) NSArray<Optional,MyGoodsOrderListModel> *goodsOrderList;   //小卖订单
@end


