//
//  SeatDataByShowTimeInfo.h
//  movikr
//
//  Created by Mapollo25 on 15/8/3.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeatEnum.h"

///场次供应商信息
@interface ShowtimeProviderInfo : NSObject

///场次ID
@property (nonatomic) NSInteger dId;
///供应商ID
@property (nonatomic) NSInteger provideId;
///供应商名称
@property (nonatomic,strong) NSString *name;

@end

///座位信息
@interface SeatInfo : NSObject

///座位ID
@property (nonatomic) NSInteger seatId;
///座位号
@property (nonatomic,strong) NSString *name;
///区域ID
@property (nonatomic,strong) NSString *areaId;
///区域名
@property (nonatomic,strong) NSString *areaName;
///座位状态
@property (nonatomic) SeatStatus status;
///座位类型
@property (nonatomic) SeatType type;
///座位的x坐标
@property (nonatomic) NSInteger x;
///座位的y坐标
@property (nonatomic) NSInteger y;
///座位号中的列号
@property (nonatomic) NSInteger seatNumber;
@property (nonatomic,strong) NSString* seatImageName;
@end



@interface ShowtimeRowNameInfo : NSObject

///行ID
@property(nonatomic) NSInteger rowId;
///行名称
@property(nonatomic, copy) NSString *rowName;

@end



@interface CinemaShowtimeInfo : NSObject

///场次是否可售
@property (nonatomic) BOOL isSale;
///单价
@property (nonatomic) NSInteger mtimeSellPrice;
///订单ID
@property (nonatomic) NSInteger orderId;
///坐席的影院信息
@property (nonatomic,strong) ShowtimeProviderInfo  *provider;
///座位信息
@property (nonatomic,strong) NSMutableArray *seats;
///子订单ID
@property (nonatomic) NSInteger subOrderID;
///供应商ID
@property (nonatomic) NSInteger supplierId;
///返回的错误信息
@property (nonatomic,strong) NSString *error;
///售价
@property (nonatomic) NSInteger price;
///服务费
@property (nonatomic) NSInteger serviceFee;
///影院名称
@property (nonatomic, strong) NSString *cinemaName;
///电影名称
@property (nonatomic, strong) NSString *movieName;
///电影时长
@property (nonatomic) NSInteger movieLength;
///影厅名称
@property (nonatomic, strong) NSString *hallName;
///版本
@property (nonatomic, strong) NSString *versionDesc;
///语言
@property (nonatomic, strong) NSString *language;
///放映开始时间
@property (nonatomic) long realTime;
///未支付订单的订单描述
@property (nonatomic, strong) NSString *orderMsg;
///剩余座位数
@property (nonatomic) NSInteger remainSeat;
///座位列数
@property (nonatomic) NSInteger seatColumnCount;
///座位行数
@property (nonatomic) NSInteger seatRowCount;
///座位行信息
@property (nonatomic,strong) NSMutableArray *rowNameList;
///影厅特殊说明
@property (nonatomic, strong) NSString *cinemaTip;
@end