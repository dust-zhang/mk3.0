//
//  ShowTimeModel.h
//  movikr
//
//  Created by Mapollo27 on 15/9/14.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "JSONModel.h"

@interface HallModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional>*hallId;//
@property (nonatomic,strong) NSString <Optional>*hallFeatureCode;
@property (nonatomic,strong) NSString <Optional>*hallSizeDesc;
@property (nonatomic,strong) NSNumber <Optional>*seatRowCount;
@property (nonatomic,strong) NSString <Optional>*hallName;//
@property (nonatomic,strong) NSNumber <Optional>*seatColumnCount;
@property (nonatomic,strong) NSString <Optional>*hallSpecialDesc;   //影厅特殊说明
@end

//活动信息
@interface MemberPriceListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional>*cinemaCardId;
@property (nonatomic,strong) NSString <Optional>*cinemaCardName;
@property (nonatomic,strong) NSNumber <Optional>*memberPrice;
@property (nonatomic,strong) NSNumber <Optional>*servicePrice;
@end

//@@@@@@@@-------   老结构弃用   ------@@@@@@@@@@@@@@@@@@@@
//@protocol MemberPriceListModel;
//@interface PriceListModel : JSONModel
//@property (nonatomic,strong) NSNumber <Optional>*priceService;//无会员的服务费
//@property (nonatomic,strong) NSNumber <Optional>*priceBasic;//无会员的售价
//@property (nonatomic,strong) NSNumber <Optional>*showtimeId;//排期id
//@property (nonatomic,strong) NSArray <Optional,MemberPriceListModel> *memberPriceList;//会员价格列表
//@property (nonatomic,strong) NSNumber <Optional> *cinemaPrice;//影院的门市价
//@end

//@@@@@@@@-------   新结构   ------@@@@@@@@@@@
@interface displayPriceListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional>*priceService;//服务费
@property (nonatomic,strong) NSNumber <Optional>*priceBasic;//基础价
@property (nonatomic,strong) NSNumber <Optional>*cinemaCardId;//对应的会员卡
@property (nonatomic,strong) NSString <Optional> *cinemaCardName;//会员卡名称
@end

//活动信息
@interface ActivityInfoModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *activityId;
@property (nonatomic,strong) NSString <Optional> *userLogo;
@property (nonatomic,strong) NSString <Optional> *userNickName;
@property (nonatomic,strong) NSString <Optional> *userRoleName;
@property (nonatomic,strong) NSString <Optional> *activityContent;
//排期详细信息用到下面三个字段
@property (nonatomic,strong) NSString <Optional> *activityTitle;
@property (nonatomic,strong) NSString <Optional> *activityImage;
@property (nonatomic,strong) NSNumber <Optional> *isLike;
@property (nonatomic,strong) NSNumber <Optional> *likeCount;
@end

@interface ShowtimeActivityModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *activityTitle;
@end

//排期详情
@protocol displayPriceListModel;
@interface ShowTimesModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *versionDesc;
@property (nonatomic,strong) NSNumber <Optional> *startSaleTime;
@property (nonatomic,strong) NSNumber <Optional> *endSaleTime;
@property (nonatomic,strong) NSNumber <Optional> *isTicket;
@property (nonatomic,strong) NSNumber <Optional> *showtimeId;
@property (nonatomic,strong) NSNumber <Optional> *startPlayTime;
@property (nonatomic,strong) NSString <Optional> *language;
@property (nonatomic,strong) NSNumber <Optional> *endPlayTime;
//@property (nonatomic,strong) PriceListModel<Optional>   *priceList; //老结构，无数据返回了
@property (nonatomic,strong) NSArray<Optional,displayPriceListModel>   *displayPriceList; //新结构
@property (nonatomic,strong) HallModel<Optional>        *hall;
@property (nonatomic,strong) NSString <Optional> *showTimeType; //0早场 1晚场 2次日场 3无
@property (nonatomic,strong) ShowtimeActivityModel<Optional>        *activity;
@end


//每个日期排期的信息
@protocol ShowTimesModel;
@interface DateShowTimeModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *showDate;
@property (nonatomic,strong) NSArray<Optional,ShowTimesModel> *showtimes;
@end


//影片信息Model
@interface MovieInfoModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *movieId;
@property (nonatomic,strong) NSString <Optional> *duration;
@property (nonatomic,strong) NSString <Optional> *movieTitle;
@property (nonatomic,strong) NSString <Optional> *movieLogoUrl;
@property (nonatomic,strong) NSString <Optional> *rate;
@property (nonatomic,strong) NSString <Optional> *movieHorizontalLogoUrl;
@end

//影院信息Model
@interface CinemaInfoModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *cinemaId;     //影院id
@property (nonatomic,strong) NSString <Optional> *cinemaName;   //影院名称
@property (nonatomic,strong) NSString <Optional> *cinemaAddress;   //影院名称
@end

//广告model
@interface AdModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *needShow;     //是否需要显示
@property (nonatomic,strong) NSString <Optional> *adText;       //广告文本
@end

//排期Model
@protocol DateShowTimeModel;
@interface ShowTimeModel : JSONModel
@property (nonatomic,strong) CinemaInfoModel<Optional>      *cinema;
@property (nonatomic,strong) NSArray<Optional>              *showDates;
@property (nonatomic,strong) MovieInfoModel<Optional>       *movie;
@property (nonatomic,strong) NSArray<DateShowTimeModel,Optional> *showtimes;
@property (nonatomic,strong) AdModel<Optional>              *ad;
@property (nonatomic,strong) NSNumber <Optional> *currentTime;
@end






