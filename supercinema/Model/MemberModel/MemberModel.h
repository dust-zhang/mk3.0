//
//  MemberModel.h
//  movikr
//
//  Created by Mapollo27 on 15/9/14.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "JSONModel.h"

//会员卡list Model
@protocol activityDescListModel;
@interface MemberCardDetailModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *id;
@property (nonatomic,strong) NSNumber <Optional> *cardValidEndTme;
@property (nonatomic,strong) NSNumber <Optional> *cinemaCardItemId;
@property (nonatomic,strong) NSString <Optional> *validDayCountDesc;
@property (nonatomic,strong) NSString <Optional> *memo;
@property (nonatomic,strong) NSNumber <Optional> *validDayCount;
@property (nonatomic,strong) NSNumber <Optional> *price;
@property (nonatomic,strong) NSNumber <Optional> *discountPrice;
@property (nonatomic,strong) NSNumber <Optional> *cardId;
@property (nonatomic,strong) NSNumber <Optional> *continuedCardsPrice;
@property (nonatomic,strong) NSNumber <Optional> *cinemaId;
@property (nonatomic,strong) NSString <Optional> *cardName;
@property (nonatomic,strong) NSString <Optional> *cinemaName;
@property (nonatomic,strong) NSArray <activityDescListModel,Optional> *activityDescList;
@property (nonatomic,strong) NSNumber <Optional> *orderUseCount;//次卡的使用次数
@property (nonatomic,strong) NSNumber <Optional> *exchangeTicketCount;//套票的兑换次数

@end

//会员卡参与的活动描述
@interface activityDescListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *activityId;
@property (nonatomic,strong) NSString <Optional> *activityDesc;
@end

@protocol MemberCardDetailModel;
@interface CardListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *id;
@property (nonatomic,strong) NSNumber <Optional> *cinemaCardId;
@property (nonatomic,strong) NSString <Optional> *cinemaCardName;
@property (nonatomic,strong) NSString <Optional> *cardDesc;
//如果该值>0，则说明用户买了该卡，并且该值为过期时间
@property (nonatomic,strong) NSNumber <Optional> *cardValidEndTime;
@property (nonatomic,strong) NSNumber <Optional> *canContinuCard;
//卡类型(0:普通，1:次卡，2:套票，3:任看，4:通票)
@property (nonatomic,strong) NSNumber <Optional> *cardType;
//总的购买次数
@property (nonatomic,strong) NSNumber <Optional> *totalUseCount;
//剩余可用次数
@property (nonatomic,strong) NSNumber <Optional> *remainUseCount;
@property (nonatomic,strong) NSArray <MemberCardDetailModel,Optional> *cinemaCardItemList;
@property (nonatomic,strong) NSNumber <Optional> *isDelete;     //0已选   1未选
@end


//影院信息
@interface MemberCinemaModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *cinemaId;
@property (nonatomic,strong) NSString <Optional> *cinemaName;
@end


//会员Model
@protocol MemberCinemaModel;
@protocol CardListModel;
@interface MemberModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSArray <CardListModel,Optional> *cinemaCardList;
@property (nonatomic,strong) MemberCinemaModel <Optional> *cinema;
@property (nonatomic,strong) NSNumber <Optional> *currentTime;
@end


//购买会员卡
@interface MemberCardModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *orderId;
@property (nonatomic,strong) NSString <Optional> *subCinemaCardOrderId;
@end

//获取有效订单列表(会员卡)
@interface CardOrderModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *cinemaId;
@property (nonatomic,strong) NSString <Optional> *cinemaName;
@property (nonatomic,strong) NSNumber <Optional> *cardItemId;
@property (nonatomic,strong) NSNumber <Optional> *cinemaCardId;
@property (nonatomic,strong) NSString <Optional> *cardName;
@property (nonatomic,strong) NSNumber <Optional> *activeTime;           //卡有效期的天数
@property (nonatomic,strong) NSString <Optional> *cardDesc;
@property (nonatomic,strong) NSNumber <Optional> *totalPrice;
@property (nonatomic,strong) NSNumber <Optional> *cardType;             //卡类型(0:普通，1:次卡，2:套票，3:任看，4:通票)
@property (nonatomic,strong) NSNumber <Optional> *orderUseCount;        //次卡的使用次数
@property (nonatomic,strong) NSNumber <Optional> *exchangeTicketCount;  //套票的兑换次数
@property (nonatomic,strong) NSNumber <Optional> *validEndTime;         //卡得有效截止日期

@end

//会员卡优惠信息
@interface MemberCardFavorableInfoModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *cinemaCardItemId;
@property (nonatomic,strong) NSNumber <Optional> *couponMethod; //如果大于0，则说明有优惠
@end

