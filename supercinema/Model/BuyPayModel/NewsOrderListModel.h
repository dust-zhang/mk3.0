//
//  NewsOrderListModel.h
//  movikr
//
//  Created by Mapollo27 on 15/12/12.
//  Copyright © 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CouponInfoModel.h"

//订单
@interface NewsOrderInfoModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *orderId;
@property (nonatomic,strong) NSString <Optional> *subOrderId;
@property (nonatomic,strong) NSNumber <Optional> *orderType;
@property (nonatomic,strong) NSString <Optional> *cinemaName;
@property (nonatomic,strong) NSNumber <Optional> *quantity;
@property (nonatomic,strong) NSString <Optional> *movieTitle;
@property (nonatomic,strong) NSNumber <Optional> *startPlayTime;
@property (nonatomic,strong) NSNumber <Optional> *createTime;
@property (nonatomic,strong) NSNumber <Optional> *orderStatus;
@property (nonatomic,strong) NSNumber <Optional> *subOrderStatus;
@property (nonatomic,strong) NSNumber <Optional> *payStatus;
@property (nonatomic,strong) NSNumber <Optional> *refundStatus; //0未退款、1（已申请退款）2(退款成功)、3(退款失败)
@end


//未支付订单
@interface NotPayModel : JSONModel
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
@property (nonatomic ,strong) NSNumber<Optional> *notDiscountTotalPrice;
@property (nonatomic ,strong) NSNumber<Optional> *discountPrice;
@property (nonatomic ,strong) NSNumber<Optional> *totalPrice;
@end

@protocol CouponInfoModel;
@protocol NotPayModel;
@protocol NewsOrderInfoModel;
@interface NewsOrderListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *seq;
@property (nonatomic,strong) NSNumber <Optional> *orderType;
@property (nonatomic,strong) NSString <Optional> *nextSeq;
@property (nonatomic,strong) NSArray <CouponInfoModel,Optional> *commonList;
@property (nonatomic,strong) NSArray <NewsOrderInfoModel,Optional> *refundOrders;
@property (nonatomic,strong) NotPayModel<Optional>  *notPayOrder;
@end


//小卖列表
@interface GoodsInfoModel : JSONModel
@property (nonatomic ,strong) NSString<Optional> *unit;
@property (nonatomic ,strong) NSString<Optional> *cinemaName;
@property (nonatomic ,strong) NSString<Optional> *goodsName;
@property (nonatomic ,strong) NSNumber<Optional> *sellCount;
@property (nonatomic ,strong) NSNumber<Optional> *servicePrice;
@property (nonatomic ,strong) NSNumber<Optional> *totalPrice;
@property (nonatomic ,strong) NSNumber<Optional> *cinemaId;
@property (nonatomic ,strong) NSNumber<Optional> *validEndTime;
@property (nonatomic ,strong) NSNumber<Optional> *useStatus;
@property (nonatomic ,strong) NSNumber<Optional> *exchangeTime;
@property (nonatomic ,strong) NSString<Optional> *goodsOrderId;
@end


//通票
@interface CardInfoModel : JSONModel
@property (nonatomic ,strong) NSNumber<Optional> *id;
@property (nonatomic ,strong) NSNumber<Optional> *cinemaCardId;
@property (nonatomic ,strong) NSString<Optional> *cinemaCardName;   //通票名称
@property (nonatomic ,strong) NSNumber<Optional> *cardValidEndTime; //剩余时间
@property (nonatomic ,strong) NSNumber<Optional> *cardType;
@property (nonatomic ,strong) NSNumber<Optional> *totalUseCount;    //总数
@property (nonatomic ,strong) NSNumber<Optional> *remainUseCount;   //剩余数
@property (nonatomic ,strong) NSNumber<Optional> *cardStatus;   //通票状态 0：正常；22306：停用；22307：失效
@end

@interface NewsCommonListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional>            *dataType;
@property (nonatomic,strong) NewsOrderInfoModel<Optional>   *orderInfo; //订单
@property (nonatomic,strong) CouponInfoModel<Optional>      *couponInfo;//优惠券
@property (nonatomic,strong) GoodsInfoModel<Optional>       *goodsInfo; //小卖
@property (nonatomic,strong) CardInfoModel<Optional>        *cardInfo;  //通票


@end

