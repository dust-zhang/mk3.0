//
//  CinemaModel.h
//  movikr
//
//  Created by zeyuan on 15/6/24.
//  Copyright (c) 2015年 movikr. All rights reserved.
//


//影院分享数据
@interface CinemaShareInfoModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>* respStatus;
@property (nonatomic,strong) NSString<Optional>* respMsg;
@property (nonatomic,strong) NSString<Optional>* seq;
@property (nonatomic,strong) NSNumber<Optional>* currentTime;
@property (nonatomic,strong) NSString<Optional>* shareTitle;
@property (nonatomic,strong) NSString<Optional>* shareImage;
@property (nonatomic,strong) NSString<Optional>* holiday;
@property (nonatomic,strong) NSNumber<Optional>* imageCount;
@property (nonatomic,strong) NSArray<Optional,StillModel>* images;
@end

//影院图片
@interface CinemaImageListModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>* respStatus;
@property (nonatomic,strong) NSString<Optional>* respMsg;
@property (nonatomic,strong) NSString<Optional>* seq;
@property (nonatomic,strong) NSNumber<Optional>* currentTime;
@property (nonatomic,strong) NSNumber<Optional>* imageCount;
@property (nonatomic,strong) NSArray<Optional,StillModel>* images;
@end

//影院视频
@interface CinemaVideoModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>* videoId;
@property (nonatomic,strong) NSString<Optional>* videoUrl;
@property (nonatomic,strong) NSString<Optional>* coverImageUrl;
@property (nonatomic,strong) NSString<Optional>* videoName;
@property (nonatomic,strong) NSString<Optional>* duration;
@end

@protocol CinemaVideoModel;
@interface CinemaMovieListModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>* respStatus;
@property (nonatomic,strong) NSString<Optional>* respMsg;
@property (nonatomic,strong) NSString<Optional>* seq;
@property (nonatomic,strong) NSNumber<Optional>* currentTime;
@property (nonatomic,strong) NSNumber<Optional>* videoCount;
@property (nonatomic,strong) NSArray<Optional,CinemaVideoModel>* videos;
@end

@interface MerchantsModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *id;
@property (nonatomic,strong) NSString <Optional> *name;
@property (nonatomic,strong) NSString <Optional> *activityContent;
@end

@protocol MerchantsModel;
@protocol FeatureListModel;
@protocol VisitUsersListModel;
@interface CinemaModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>* cinemaId;
@property (nonatomic,strong) NSString<Optional>* cinemaName;
@property (nonatomic,strong) NSString<Optional>* fullName;
@property (nonatomic,strong) NSString<Optional>* service_intro;
@property (nonatomic,strong) NSNumber<Optional>* canBuyTicket;      //是否显示购票图片
@property (nonatomic,strong) NSNumber<Optional>* canBuyGoods;       //是否显示小卖图片
@property (nonatomic,strong) NSNumber<Optional>* canBuyCard;      //是否显示购票图片
@property (nonatomic,strong) NSString<Optional>* longitude;
@property (nonatomic,strong) NSString<Optional>* latitude;
@property (nonatomic,strong) NSString<Optional>* dlongitude;
@property (nonatomic,strong) NSString<Optional>* dlatitude;
@property (nonatomic,strong) NSString<Optional>* address;
@property (nonatomic,strong) NSURL<Optional>* logoUrl;
@property (nonatomic,strong) NSArray<Optional,FeatureListModel>* featureList;   //影院特色
@property (nonatomic,strong) NSArray<Optional>* phoneNumberList;                //电话
@property (nonatomic,strong) NSString<Optional>* cinemaNotice;                  //影院公告
@property (nonatomic,strong) NSString<Optional>* businessStartTime;
@property (nonatomic,strong) NSString<Optional>* businessEndTime;
@property (nonatomic,strong) NSNumber<Optional>* hallCount;
@property (nonatomic,strong) NSNumber<Optional>* seatCount;
@property (nonatomic,strong) NSURL<Optional>* defaultBackgroundImgUrl;
@property (nonatomic,strong) NSNumber<Optional>* distance;
@property (nonatomic,strong) NSString<Optional>* cinemaAddress;
@property (nonatomic,strong) NSNumber<Optional>* joinCount;
@property (nonatomic,strong) NSNumber<Optional>* max;
@property (nonatomic,strong) NSNumber<Optional>* defaultCinema;
//新添加字段
@property (nonatomic,strong) NSNumber<Optional>* establishedYear;   //成立时间(为0表示后台没填,不显示)
@property (nonatomic,strong) NSString<Optional>* owner;             //所属院线
@property (nonatomic,strong) NSNumber<Optional>* visitCount;        //访问数
@property (nonatomic,strong) NSArray<Optional,VisitUsersListModel>* visitUsers;
@property (nonatomic,strong) NSArray<Optional>* tags;
@property (nonatomic,strong) NSNumber<Optional>* videoCount;
@property (nonatomic,strong) CinemaVideoModel<Optional>* cinemaVideoInfo;
@property (nonatomic,strong) NSNumber<Optional>* imageCount;
@property (nonatomic,strong) NSArray<Optional,StillModel>* images;
@property (nonatomic,strong) NSArray<Optional,MerchantsModel>* merchants;//合作商户(集合)
@end

//最近访问的人(集合)
@interface VisitUsersListModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>* id;
@property (nonatomic,strong) NSString<Optional>* nickname;
@property (nonatomic,strong) NSString<Optional>* portraitUrl;
@end

@interface FeatureListModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>* featureId;
@property (nonatomic,strong) NSString<Optional>* featureDesc;
@property (nonatomic,strong) NSString<Optional>* featureCode;
@property (nonatomic,strong) NSNumber<Optional>* importantValue;
@end

@protocol CinemaModel;
@interface OftenRecommendCinemaModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>* respStatus;
@property (nonatomic,strong) NSString<Optional>* respMsg;
@property (nonatomic,strong) NSString<Optional>* seq;
@property (nonatomic,strong) NSArray<Optional,CinemaModel>* recommendCinemaList;
@property (nonatomic,strong) NSArray<Optional,CinemaModel>* mostVisitCinemaList;
@end

@protocol CinemaModel;
@interface CinemaListModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>*   respStatus;
@property (nonatomic,strong) NSString<Optional>*   respMsg;
@property (nonatomic,strong) NSNumber<Optional>*   currentTime;
@property (nonatomic,strong) NSString<Optional>*   seq;
@property (nonatomic,strong) NSNumber<Optional>*   pageSize;
@property (nonatomic,strong) NSNumber<Optional>*   pageTotal;
@property (nonatomic,strong) NSNumber<Optional>*   pageIndex;
@property (nonatomic,strong) NSArray<Optional,CinemaModel>* cinemaList;
@end







