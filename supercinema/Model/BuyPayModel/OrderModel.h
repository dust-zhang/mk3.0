//
//  OrderModel.h
//  movikr
//
//  Created by Mapollo27 on 15/9/14.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "JSONModel.h"
#import "ShowTimeModel.h"
#import "ShowTimeDetailModel.h"
#import "MemberModel.h"

//创建订单
@interface CreateOrderModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional> *orderStatus;//判断在线选座订单创建成功，true为成功、false失败。
@property (nonatomic,strong) NSString<Optional> *orderId;//主订单Id
@property (nonatomic,strong) NSString<Optional> *subOrderId;//在线选座子订单Id
@property (nonatomic,strong) NSNumber<Optional> *respStatus;
@property (nonatomic,strong) NSString<Optional> *respMsg;
//1 成功, 0 操作失败(一般为数据库操作出错),-10 用户未登录,  -20 有未支付订单,   -30 场次无效,-40 座位无效, -50 场次关联的影厅无效, -60 场次关联的影院无效，-70 找不到合同, -80 找不到销售策略, -90 结算金额和合同不一致，-100 销售金额和销售策略不一致
@end

//排期详情
@interface OShowTimesModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *startPlayTime;//影讯Id
@property (nonatomic,strong) NSNumber <Optional> *showtimeId;//放映时间 时间戳 单位秒
@property (nonatomic,strong) NSString <Optional> *language;//散场时间 时间戳 单位秒
@property (nonatomic,strong) NSString <Optional> *versionDesc;//版本名称
@property (nonatomic,strong) NSNumber <Optional> *isTicket;//语言
@end

//未支付订单
@interface OnlineTicketsModel : JSONModel
@property (nonatomic,strong) MovieInfoModel<Optional>     *movie;
@property (nonatomic,strong) OShowTimesModel<Optional>    *showtime;
@property (nonatomic,strong) HallModel<Optional>          *hall;
@property (nonatomic,strong) CinemaInfoModel<Optional>    *cinema;
@property (nonatomic,strong) NSNumber<Optional> *subOrderStatus;
@property (nonatomic,strong) NSString<Optional> *exchangeInfo;
@property (nonatomic,strong) NSString<Optional> *ticketKey;
@property (nonatomic,strong) NSNumber<Optional> *refundStatus; //0未退款、1（已申请退款）2(退款成功)、3(退款失败)
@property (nonatomic,strong) NSString<Optional> *subOrderId;
@property (nonatomic,strong) NSArray <Optional> *seateNames;
@property (nonatomic,strong) NSNumber<Optional> *totalPrice;
@property (nonatomic,strong) NSNumber<Optional> *serviceFee;
@property (nonatomic,strong) NSNumber<Optional> *subOrderShowStatus;
@end

//卡包小卖
@interface GoodsListCardPackModel : JSONModel
@property (nonatomic,strong) NSString<Optional> *cinemaAddress;
@property (nonatomic,strong) NSString<Optional> *goodsDesc;
@property (nonatomic,strong) NSString<Optional> *goodsOrderId;
@property (nonatomic,strong) NSString<Optional> *unit;
@property (nonatomic,strong) NSNumber<Optional> *validEndTime;
@property (nonatomic,strong) NSNumber<Optional> *exchangeTime;
@property (nonatomic,strong) NSString<Optional> *exchangeDesc;
@property (nonatomic,strong) NSNumber<Optional> *sellCount;
@property (nonatomic,strong) NSString<Optional> *goodsName;
@property (nonatomic,strong) NSString<Optional> *goodsLogoUrl;
@property (nonatomic,strong) NSNumber<Optional> *servicePrice;
@property (nonatomic,strong) NSNumber<Optional> *useStatus;
@property (nonatomic,strong) NSNumber<Optional> *totalPrice;
@property (nonatomic,strong) NSNumber<Optional> *refundStatus;
@property (nonatomic,strong) NSNumber<Optional> *exchangeType;//兑换方式 1:需要核销，0:不需要核销
@property (nonatomic,strong) NSNumber<Optional> *payStatus;
@property (nonatomic,strong) NSNumber<Optional> *subOrderStatus;
@property (nonatomic,strong) NSNumber<Optional> *cinemaId;
@property (nonatomic,strong) NSString<Optional> *cinemaName;
@property (nonatomic,strong) NSNumber<Optional> *subOrderShowStatus;
@end

//获取订单信息
@protocol GoodsListCardPackModel;
@interface OrderInfoModel : JSONModel
@property (nonatomic,strong) OnlineTicketsModel<Optional>               *onlineTickets;
@property (nonatomic,strong) CardOrderModel<Optional>                   *cardOrder;
@property (nonatomic,strong) CinemaModel<Optional>                      *cinema;
@property (nonatomic,strong) NSArray<Optional,GoodsListCardPackModel>   *goodsOrderList;
@property (nonatomic,strong) NSString<Optional> *orderId;
@property (nonatomic,strong) NSNumber<Optional> *payStatus; //0未支付，1已支付
@property (nonatomic,strong) NSNumber<Optional> *payEndTime;
@property (nonatomic,strong) NSNumber<Optional> *totalPrice;
@property (nonatomic,strong) NSNumber<Optional> *respMsg;
@property (nonatomic,strong) NSNumber<Optional> *respStatus;
@property (nonatomic,strong) NSNumber<Optional> *createTime;
@property (nonatomic,strong) NSNumber<Optional> *orderStatus;
@property (nonatomic,strong) NSNumber<Optional> *notDiscountTotalPrice;   //未使用折扣的价格
@property (nonatomic,strong) NSNumber<Optional> *discountPrice;           //折扣
@property (nonatomic,strong) NSNumber<Optional> *shareRedpackFee;    //红包金额，大于0，则说明有红包可以分享

@end

//轮询订单
@interface OrderWhileModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional> *respStatus;
@property (nonatomic,strong) NSString<Optional> *respMsg;
@property (nonatomic,strong) NSString<Optional> *orderId;
@property (nonatomic,strong) NSNumber<Optional> *orderStatus;
@property (nonatomic,strong) NSNumber<Optional> *payStatus;
@end

//取消订单
@interface CancelOrderModel : JSONModel
@property (nonatomic ,strong) NSString<Optional> *respMsg;
@property (nonatomic ,strong) NSString<Optional> *seatNumbers;
@property (nonatomic ,strong) NSNumber<Optional> *respStatus;
@end

//删除子订单
@interface DeleteSubOrderModel : JSONModel
@property (nonatomic ,strong) NSNumber<Optional> *respStatus;
@property (nonatomic ,strong) NSString<Optional> *respMsg;//错误信息
@property (nonatomic ,strong) NSNumber<Optional> *isSuccess;//0-失败，1-成功，2-主订单不是CreateSuccess状态
@property (nonatomic ,strong) NSString<Optional> *seq;//错误信息
@property (nonatomic ,strong) NSNumber<Optional> *status;//0-失败，1-成功，2-主订单不是CreateSuccess状态
@end

//未支付订单
@interface NotPayOrderModel : JSONModel
@property (nonatomic ,strong) NSString<Optional> *orderId;
@property (nonatomic ,strong) NSString<Optional> *subOrderId;
@property (nonatomic ,strong) NSNumber<Optional> *orderType;
@property (nonatomic ,strong) NSString<Optional> *cinemaName;
@property (nonatomic ,strong) NSNumber<Optional> *quantity;
@property (nonatomic ,strong) NSString<Optional> *movieTitle;
@property (nonatomic ,strong) NSNumber<Optional> *startPlayTime;
@property (nonatomic ,strong) NSNumber<Optional> *createTime;
@property (nonatomic ,strong) NSNumber<Optional> *orderStatus;
@property (nonatomic ,strong) NSNumber<Optional> *payEndTime;
@property (nonatomic ,strong) NSNumber<Optional> *payStatus;
@property (nonatomic ,strong) NSNumber<Optional> *refundStatus; //0未退款、1（已申请退款）2(退款成功)、3(退款失败)
@end


//订单列表
@interface OrderListInfoModel : JSONModel
@property (nonatomic ,strong) NSString<Optional> *cinemaName;
@property (nonatomic ,strong) NSString<Optional> *movieTitle;
@property (nonatomic ,strong) NSNumber<Optional> *payStatus;
@property (nonatomic ,strong) NSNumber<Optional> *refundStatus; //0未退款、1（已申请退款）2(退款成功)、3(退款失败)
@property (nonatomic ,strong) NSNumber<Optional> *createTime;
@property (nonatomic ,strong) NSNumber<Optional> *quantity;
@property (nonatomic ,strong) NSNumber<Optional> *orderType;
@property (nonatomic ,strong) NSString<Optional> *subOrderId;
@property (nonatomic ,strong) NSNumber<Optional> *orderStatus;
@property (nonatomic ,strong) NSString<Optional> *orderId;
@property (nonatomic ,strong) NSNumber<Optional> *subOrderStatus;
@property (nonatomic ,strong) NSNumber<Optional> *startPlayTime;
@end

//获取往期订单列表
@protocol OrderListInfoModel;
@interface OrderPastListModel : JSONModel
@property (nonatomic ,strong) NSArray<Optional,OrderListInfoModel> *commonOrders;
@property (nonatomic ,strong) NSArray<Optional,OrderListInfoModel> *refundOrders;
@property (nonatomic ,strong) NSNumber<Optional> *respStatus;
@property (nonatomic ,strong) NSString<Optional> *nextSeq;
@property (nonatomic ,strong) NSNumber<Optional> *orderType;
@property (nonatomic ,strong) NSString<Optional> *respMsg;
@end


//获取有效订单列表
@protocol OrderListInfoModel;
@interface OrderValidListModel : JSONModel
@property (nonatomic ,strong) NSArray<Optional,OrderListInfoModel> *commonOrders;
@property (nonatomic ,strong) NotPayOrderModel<Optional>  *notPayOrder;
@property (nonatomic ,strong) NSNumber<Optional> *respStatus;
@property (nonatomic ,strong) NSString<Optional> *nextSeq;
@property (nonatomic ,strong) NSNumber<Optional> *orderType;
@property (nonatomic ,strong) NSString<Optional> *respMsg;

@end
















