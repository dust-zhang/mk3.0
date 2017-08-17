//
//  SeatManager.h
//  mTime
//
//  Created by jax on 13-7-12.
//  Copyright (c) 2013年 com.mtime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeatEnum.h"
#import "CinemaShowtimeInfo.h"
@class SeatInfo;

@interface ChooseSeatManager : NSObject {
    NSMutableArray *_allSeats; //存放所有座位信息
    NSMutableArray *_selectedSeats; //存放所有选择的座位信息
    NSInteger _limitCount;  //最大选择数量
    NSInteger _columnCount;
    NSInteger _rowCount;
    NSInteger arrWeight[2];
}
@property (nonatomic, readonly) NSInteger columnCount;
@property (nonatomic, retain) NSMutableArray *selectedSeats;
@property (nonatomic, readonly) NSInteger rowCount;
@property (nonatomic, retain) NSMutableArray *allSeats;
@property (nonatomic, retain) NSString* lastAreaName;
- (NSArray *) getAllSelectedSeats;  //获取所有被选择座位的信息
- (void) initSeatsWithSeatsData:(NSArray *) seatList limitCount:(NSInteger) limitCount;
- (void) initSeatsWithSeatsData:(NSArray *) seatList limitCount:(NSInteger) limitCount rowCount:(NSInteger)rowCount columnCount:(NSInteger)columnCount;
- (ChooseSeatResultEnum) chooseSeat: (NSInteger)x y:(NSInteger)y;
- (NSString *) getSeatInfoKey:(SeatInfo *)seatInfo;

- (NSString *) chooseSeatResultFromEnum:(ChooseSeatResultEnum)result;

//用服务器返回的最新一行座位信息数组，更新原来_allSeats存储得座位信息(用户选座位时，会向服务器请求最新的一行座位信息，并更新_allSeats 存储得座位数据)
-(void)refreshSeatsDataByNewSeatsInfoArray:(NSArray*)newSeatsInfoArray selectedSeatsAry:(NSArray*)selectedSeatsAry;

//每次局部刷新座位图后，将服务器返回得不可选座位，从用户已选座位列表中移除
-(void)deleteFromSelectedSeatsByDisabledRowArray:(NSArray*)disabledRowArray;

//- (NSArray *) getGoldSelectedSeats:(NSInteger)number;  //获取黄金座位的信息

@end


