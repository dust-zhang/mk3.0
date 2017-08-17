//
//  GoodsListModel.h
//  movikr
//
//  Created by Mapollo27 on 16/1/9.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import "JSONModel.h"

@interface memberPriceListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *servicePrice;
@property (nonatomic,strong) NSString <Optional> *cinemaCardName;
@property (nonatomic,strong) NSNumber <Optional> *memberPrice;
@property (nonatomic,strong) NSNumber <Optional> *cinemaCardId;
@end

@protocol memberPriceListModel;
@interface priceDataModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *priceService;
@property (nonatomic,strong) NSNumber <Optional> *priceBasic;
@property (nonatomic,strong) NSNumber <Optional> *originalPrice;
@property (nonatomic,strong) NSNumber <Optional> *goodsId;
@property (nonatomic,strong) NSArray <memberPriceListModel,Optional> *memberPriceList;
@end

@protocol priceDataModel;
@interface GoodsListModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *cinemaName;
@property (nonatomic,strong) NSString <Optional> *goodsName;
@property (nonatomic,strong) NSString <Optional> *goodsDesc;
@property (nonatomic,strong) NSNumber <Optional> *goodsId;
@property (nonatomic,strong) NSNumber <Optional> *maxSelectCount;
@property (nonatomic,strong) NSNumber <Optional> *validEndTime;
@property (nonatomic,strong) NSNumber <Optional> *cinemaId;
@property (nonatomic,strong) NSString <Optional> *unit;
@property (nonatomic,strong) NSString <Optional> *goodsLogoUrl;
@property (nonatomic,strong) priceDataModel <Optional> *priceData;
@property (nonatomic,strong) NSNumber <Optional> *couponMethod; //优惠方式  大于零就算有优惠
@property (nonatomic,strong) NSNumber <Optional> *promotionCount;   //小卖的促销数目
@property (nonatomic,strong) NSNumber <Optional> *promotionPrice;  //价格是否为促销价
@end


@interface GoodsListDetailModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *cinemaAddress;
@property (nonatomic,strong) NSString <Optional> *goodsDesc;
@property (nonatomic,strong) NSString <Optional> *goodsOrderId;
@property (nonatomic,strong) NSString <Optional> *unit;
@property (nonatomic,strong) NSNumber <Optional> *validEndTime;
@property (nonatomic,strong) NSNumber <Optional> *exchangeTime;
@property (nonatomic,strong) NSNumber <Optional> *sellCount;
@property (nonatomic,strong) NSString <Optional> *goodsName;
@property (nonatomic,strong) NSString <Optional> *goodsLogoUrl;
@property (nonatomic,strong) NSNumber <Optional> *servicePrice;
@property (nonatomic,strong) NSNumber <Optional> *useStatus;//状态 1为未兑换,2为已兑换,3为已过期
@property (nonatomic,strong) NSNumber <Optional> *totalPrice;
@property (nonatomic,strong) NSNumber <Optional> *cinemaId;
@property (nonatomic,strong) NSString <Optional> *cinemaName;
@property (nonatomic,strong) NSString <Optional> *exchangeType;//-1:未知核销类型0:不需要核销码1:需要核销码
@property (nonatomic,strong) NSNumber <Optional> *refundStatus;//0未退款、1（已申请退款）2(退款成功)、3(退款失败)、4（部分退款）5（退款失败，需要人工退款）
@property (nonatomic,strong) NSNumber <Optional> *subOrderStatus;//30成功 40失败
@property (nonatomic,strong) NSString <Optional> *exchangeDesc;

@end

//通票详情model
@interface TongPiaoInfoModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *id;
@property (nonatomic,strong) NSNumber <Optional> *cinemaCardId;
@property (nonatomic,strong) NSString <Optional> *cinemaCardName; //通票名称
@property (nonatomic,strong) NSString <Optional> *cardDesc;       //通票描述
@property (nonatomic,strong) NSString <Optional> *useRulesDesc;   //通票规则描述
@property (nonatomic,strong) NSNumber <Optional> *cardValidEndTime;
@property (nonatomic,strong) NSNumber <Optional> *canContinuCard;
@property (nonatomic,strong) NSNumber <Optional> *cardType;
@property (nonatomic,strong) NSNumber <Optional> *totalUseCount;
@property (nonatomic,strong) NSNumber <Optional> *remainUseCount;
@property (nonatomic,strong) NSArray  <Optional> *useMovieNameList;  //适用影片
@property (nonatomic,strong) NSArray  <Optional> *useCinemaNameList; //适用影院

@end
