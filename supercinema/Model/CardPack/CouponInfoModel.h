//
//  CouponInfoModel
//  supercinema
//
//  Created by dust on 16/11/28.
//
//

#import <Foundation/Foundation.h>


//优惠券
@interface CouponInfoModel:JSONModel
@property (nonatomic,strong) NSNumber <Optional> *couponId;
@property (nonatomic,strong) NSString <Optional> *cinemaName;
@property (nonatomic,strong) NSString <Optional> *couponName;
@property (nonatomic,strong) NSNumber <Optional> *quantity;
@property (nonatomic,strong) NSString <Optional> *unit;
@property (nonatomic,strong) NSString <Optional> *exchangeDesc;
@property (nonatomic,strong) NSString <Optional> *couponDesc;
@property (nonatomic,strong) NSNumber <Optional> *totalPrice;
@property (nonatomic,strong) NSNumber <Optional> *status;
@property (nonatomic,strong) NSNumber <Optional> *couponStatus;// 1是已使用，2是未使用, 3:已过期,4:未激活
@property (nonatomic,strong) NSString <Optional> *couponImgUrl;
@property (nonatomic,strong) NSString <Optional> *cinemaAddress;
@property (nonatomic,strong) NSString <Optional> *useTip;
@property (nonatomic,strong) NSString <Optional> *uniqueId;
@property (nonatomic,strong) NSNumber <Optional> *servicePrice;
@property (nonatomic,strong) NSNumber <Optional> *validStartDate;
@property (nonatomic,strong) NSNumber <Optional> *validEndDate;
@property (nonatomic,strong) NSNumber <Optional> *useDate;
@property (nonatomic,strong) NSNumber <Optional> *exchangeType;//核销码兑换方式，-1:不明确，0:不需要 1:需要
@property (nonatomic,strong) NSNumber <Optional> *worth;       //价值
@property (nonatomic,strong) NSNumber <Optional> *common;      //是否通用
@property (nonatomic,strong) NSNumber <Optional>  *movieLimitCount;  //当前影片可用数目
@property (nonatomic,strong) NSNumber <Optional>  *activeStatus;     //激活状态1:已激活  0:未激活
@end

@interface CardInfo1Model : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *id;
@property (nonatomic,strong) NSNumber <Optional> *cinemaCardId;
@property (nonatomic,strong) NSString <Optional> *cinemaCardName;
@property (nonatomic,strong) NSString <Optional> *cardDesc;
//如果该值>0，则说明用户买了该卡，并且该值为过期时间
@property (nonatomic,strong) NSNumber <Optional> *cardValidEndTime;
@property (nonatomic,assign) BOOL canContinuCard;
//卡类型(0:普通，1:次卡，2:套票，3:任看，4:通票)
@property (nonatomic,strong) NSNumber <Optional> *cardType;
//总的购买次数
@property (nonatomic,strong) NSNumber <Optional> *totalUseCount;
//剩余可用次数
@property (nonatomic,strong) NSNumber <Optional> *remainUseCount;
@property (nonatomic,strong) NSNumber <Optional> *cardStatus;
@property (nonatomic,strong) NSString <Optional> *useRulesDesc;
@property (nonatomic,strong) NSNumber <Optional> *isDelete;     //0已选   1未选
@end

@interface CommonListModel:JSONModel
@property (nonatomic,strong) NSNumber <Optional> *past;
@property (nonatomic,strong) NSNumber <Optional> *dataType;
@property (nonatomic,strong) CouponInfoModel <Optional> *couponInfo;
@property (nonatomic,strong) CardInfo1Model <Optional> *cardInfo;
@property (nonatomic,strong) NSNumber <Optional> *isDelete;     //0已选   1未选
@end

@protocol CommonListModel;
@interface CouponModel:JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSNumber <Optional> *currentTime;
@property (nonatomic,strong) NSNumber <Optional> *seq;
@property (nonatomic,strong) NSNumber <Optional> *orderType;
@property (nonatomic,strong) NSString <Optional> *nextSeq;
@property (nonatomic,strong) NSArray <Optional,CommonListModel> *commonList;
@end


@interface CardAndCouponCountModel:JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *seq;
@property (nonatomic,strong) NSNumber <Optional> *cinemaCardCount;
@property (nonatomic,strong) NSNumber <Optional> *couponCount;
@end
