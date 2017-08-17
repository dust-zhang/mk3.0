//
//  BuildOrderModel.h
//  movikr
//
//  Created by Mapollo28 on 15/9/23.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShowTimeDetailModel.h"

@interface BuildOrderModel : NSObject
@property (nonatomic,assign) NSInteger showtimeId;      //场次ID
@property (nonatomic,strong) NSString *strCinema;       //影院名
@property (nonatomic,strong) NSNumber *strCinemaId;     //影院id
@property (nonatomic,strong) NSNumber *strCardId;       //会员卡id
@property (nonatomic,strong) NSString *strImgFilm;      //电影图标
@property (nonatomic,strong) NSString *strFilmName;     //电影名
@property (nonatomic,strong) NSString *strFilmLanguage; //电影语种
@property (nonatomic,strong) NSString *version;         //2D、3D
@property (nonatomic,strong) NSString *strDate;         //放映日期
@property (nonatomic,strong) NSNumber *currentDate;         //当前日期
@property (nonatomic,strong) NSNumber *strTime;         //放映时间
@property (nonatomic,strong) NSString *strHall;         //放映厅
@property (nonatomic,strong) NSString *strPlayType;     //播放属性
@property (nonatomic,strong) NSArray *arrSeats;         //选中座位
@property (nonatomic,strong) NSArray *arrSeatIds;       //选中座位ID

//价格
@property (nonatomic,strong) NSString *strFilmPrice;    //单张票价
@property (nonatomic,strong) NSString *strServicePrice; //服务费
@property (nonatomic,strong) NSString *strTotalPrice;   //总票价
@property (nonatomic,strong) NSString *strAllPrice;     //总票价+总小卖价
//@property (nonatomic,strong) NSDictionary *dictPrice;   //票价集合      ps:购卡流程取消
//@property (nonatomic,strong) NSArray *arrServicePrice;  //服务费集合
@end
