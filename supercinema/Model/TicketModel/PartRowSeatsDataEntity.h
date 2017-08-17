//
//  PartRowSeatsDataEntity.h
//  movikr
//
//  Created by Mapollo25 on 15/8/4.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartRowSeatsDataEntity : NSObject

@property (nonatomic, strong) NSArray *selectedRows;
@property (nonatomic, strong) NSArray *rowSeats;

- (void)objectMapping;

@end

@interface SeatItemEntity : NSObject
@property (nonatomic,strong) NSNumber *seatId;
@property (nonatomic,strong) NSNumber *x;
@property (nonatomic,strong) NSNumber *y;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *seatNumber;
@property (nonatomic,strong) NSNumber *enable;

- (void)objectMapping;

@end

@interface SelectedRowItem : NSObject
@property (nonatomic,strong) NSNumber *seatId;
@property (nonatomic,strong) NSNumber *enable;

- (void)objectMapping;

@end
