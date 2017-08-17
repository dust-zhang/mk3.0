//
//  ShowTimeDetailModel.h
//  movikr
//
//  Created by Mapollo27 on 15/9/14.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "JSONModel.h"
#import "ShowTimeModel.h"

@interface RowNameListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *rowId;//排id等于座位y值。
@property (nonatomic,strong) NSString <Optional> *rowName;////排名称。
@end

@interface SeatModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *seatId;//0表示不是座位
@property (nonatomic,strong) NSNumber <Optional> *x;//座位的横坐标
@property (nonatomic,strong) NSNumber <Optional> *y;//座位的纵坐标
@property (nonatomic,strong) NSString <Optional> *seatName;//座位名字
@property (nonatomic,strong) NSNumber <Optional> *seatType;// 0普通座;1残疾人座;2情侣左座;3情侣右座
@property (nonatomic,strong) NSString <Optional> *seatNumber;//座位号
@property (nonatomic,strong) NSNumber <Optional> *status;//座位状态（可选和不可选）
@property (nonatomic,strong) NSString <Optional> *areaId;//座位区号
@end

@interface AreaModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *areaName;//区域名
@property (nonatomic,strong) NSString <Optional> *areaId;//座位区号
@end


@interface ShowTimeInfoModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *showtimeId;//
@property (nonatomic,strong) NSString <Optional> *version;////版本
@property (nonatomic,strong) NSString <Optional> *language;//语言
@property (nonatomic,strong) NSNumber <Optional> *salePrice;//销售价,单位分
@property (nonatomic,strong) NSNumber <Optional> *realTime;//放映时间
@end

@interface MovieDetailModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *movieId;
@property (nonatomic,strong) NSString <Optional> *movieLogoUrl;
@property (nonatomic,strong) NSString <Optional> *rate;
@property (nonatomic,strong) NSString <Optional> *duration;
@property (nonatomic,strong) NSString <Optional> *movieTitle;
@property (nonatomic,strong) NSString <Optional> *movieHorizontalLogoUrl;
@property (nonatomic,strong) NSString <Optional> *movieHaibaoUrl;
@end

@interface MemberPriceModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *servicePrice;
@property (nonatomic,strong) NSString <Optional> *cinemaCardName;
@property (nonatomic,strong) NSNumber <Optional> *memberPrice;
@property (nonatomic,strong) NSNumber <Optional> *cinemaCardId;
@property (nonatomic,strong) NSNumber <Optional> *cardType;
@property (nonatomic,strong) NSNumber <Optional> *id;
@property (nonatomic,strong) NSNumber <Optional> *isLowestPrice;
@end

@protocol MemberPriceModel;
@interface PriceListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *priceService;  //服务费
@property (nonatomic,strong) NSNumber <Optional> *priceBasic;    //结算价
@property (nonatomic,strong) NSNumber <Optional> *showtimeId;
@property (nonatomic,strong) NSArray <Optional,MemberPriceModel> *memberPriceList;
@property (nonatomic,strong) NSNumber <Optional> *cinemaPrice;
@property (nonatomic,strong) NSNumber <Optional> *isLowestPrice;
@end

//活动信息
@interface HallActivityModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *activityTtitle;
@property (nonatomic,strong) NSString <Optional> *activityContent;
@end

@interface FilmDetailModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *showtimeId;
@property (nonatomic,strong) NSString <Optional> *version;
@property (nonatomic,strong) NSString <Optional> *language;
//@property (nonatomic,strong) NSNumber <Optional> *salPrice;
//@property (nonatomic,strong) NSNumber <Optional> *serviceFee;
@property (nonatomic,strong) PriceListModel<Optional> *priceList;
@property (nonatomic,strong) NSNumber <Optional> *startPlayTime;
@property (nonatomic,strong) HallActivityModel<Optional> *activity;             //活动信息
@property (nonatomic,strong) NSString<Optional>         *showtimeTip;           //进入场次的提示信息，符号$之间的是需要特殊显示的
@end

//座位图
@interface SpecialSeatImageModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *commonSoldSeatImage;
@property (nonatomic,strong) NSString <Optional> *loveSoldSeatImage;
@property (nonatomic,strong) NSString <Optional> *loveSelectSeatImage;
//普通默认可选座位
@property (nonatomic,strong) NSString <Optional> *commonSaleSeatImage;
//默认可选情侣座位
@property (nonatomic,strong) NSString <Optional> *loveSaleSeatImage;
@property (nonatomic,strong) NSArray<Optional>*commonSelectSeatImageList;   //座位
@end

//排期详情Model
@protocol SeatModel;
@protocol AreaModel;
@protocol RowNameListModel;
@interface ShowTimeDetailModel : JSONModel
@property (nonatomic,strong) CinemaInfoModel<Optional>  *cinema;                //影院信息
@property (nonatomic,strong) HallModel<Optional>        *hall;                  //影厅信息
@property (nonatomic,strong) MovieDetailModel<Optional> *movie;                 //影片信息
@property (nonatomic,strong) NSArray<Optional,SeatModel>*seats;                 //座位
@property (nonatomic,strong) NSNumber<Optional>         *remainSeat;            //剩余可选座位
@property (nonatomic,strong) NSNumber<Optional>         *isSale;                //是否可售
@property (nonatomic,strong) NSArray<Optional,RowNameListModel>  *rowList;
@property (nonatomic,strong) NSString<Optional>         *subOrderId;            //未支付子订单Id
@property (nonatomic,strong) NSString<Optional>         *orderId;               //未支付订单Id
@property (nonatomic,strong) FilmDetailModel<Optional>  *showtime;              //影片信息
@property (nonatomic,strong) NSArray<Optional,AreaModel>*areaList;              //座位
@property (nonatomic,strong) SpecialSeatImageModel<Optional>*specialSeatImage;  //选中座位图
@property (nonatomic,strong) NSNumber <Optional> *currentTime;
@property (nonatomic,strong) NSNumber <Optional> *full;
@end













