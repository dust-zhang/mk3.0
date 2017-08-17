//
//  SnackModel.h
//  supercinema
//
//  Created by dust on 16/11/15.
//
//
//单独购买小卖model

#import <JSONModel/JSONModel.h>

@protocol SnackListModel;
@interface SnackModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *seq;
@property (nonatomic,strong) NSArray <Optional,SnackListModel> *goodsList;
@end



@interface SnackPriceDataModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *priceService;
@property (nonatomic,strong) NSNumber <Optional> *priceBasic;
@property (nonatomic,strong) NSString <Optional> *cinemaCardName;
@property (nonatomic,strong) NSNumber <Optional> *cinemaCardId;
@property (nonatomic,strong) NSNumber <Optional> *cardItemId;
@property (nonatomic,strong) NSNumber <Optional> *goodsId;
@property (nonatomic,strong) NSNumber <Optional> *originalPrice;
@end

@interface SnackActivityDescListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *activityId;
@property (nonatomic,strong) NSString <Optional> *activityDesc;
@end


@protocol SnackActivityDescListModel;
@interface SnackListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *cinemaId;
@property (nonatomic,strong) NSString <Optional> *cinemaName;
@property (nonatomic,strong) NSNumber <Optional> *goodsId;
@property (nonatomic,strong) NSString <Optional> *goodsName;
@property (nonatomic,strong) NSString <Optional> *goodsLogoUrl;
@property (nonatomic,strong) NSString <Optional> *goodsDesc;
@property (nonatomic,strong) NSNumber <Optional> *maxSelectCount;
@property (nonatomic,strong) NSNumber <Optional> *validEndTime;
@property (nonatomic,strong) NSNumber <Optional> *promotionCount;
@property (nonatomic,strong) NSNumber <Optional> *couponMethod;
@property (nonatomic,strong) NSNumber <Optional> *promotionPrice;
@property (nonatomic,strong) NSString <Optional> *unit;
@property (nonatomic,strong) NSNumber <Optional> *count;
@property (nonatomic,strong) SnackPriceDataModel <Optional> *priceData;
@property (nonatomic,strong) NSArray <SnackActivityDescListModel,Optional> *activityDescList;
@end

@interface SnackRemainCountModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *goodsId;
@property (nonatomic,strong) NSNumber <Optional> *count;
@property (nonatomic,strong) NSNumber <Optional> *useCinemaCardId;
@end
