//
//  Header.h
//  movikr
//
//  Created by Mapollo25 on 15/8/3.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#ifndef ShowTime_SeatEnum_h
#define ShowTime_SeatEnum_h
typedef enum
{
    ///普通座位
    normal_SeatType = 0,
    ///残疾人座位
    disabled_SeatType = 1,
    ///情侣座-左
    loverLeft_SeatType = 2,
    ///情侣座-右
    loverRight_SeatType = 3,
}SeatType;

typedef enum
{
    ///可选
    canSelect_SeatStatus = 2,
    ///已选（自己选中）
    selectedByMyself_SeatStatus = 1,
    ///已选（别人选中）
    selectedByOthers_SeatStatus = 3,
    ///不是座位  通过SeatId == 0判断
    notSeat_SeatStatus = 4,
    
}SeatStatus;

typedef NS_ENUM(NSInteger, ChooseSeatResultEnum) {
    ///没选择
    ChooseSeatResult_None,
    ///正常
    ChooseSeatResult_OK,
    ///该座位不存在
    ChooseSeatResult_NotSeat,
    ///此座位已被他人锁定，如果20分钟内没有完成支付将自动解锁
    ChooseSeatResult_SelectedByOthers,
    ///超过买票上限
    ChooseSeatResult_MoreThanLimit,  //
    ///该座位为情侣座位，不单独销售，您还可以选择一个普通座位
    ChooseSeatResult_OneLeftButChooseLoverSeat,
    ///请连续选座位，不可留下单独座位
    ChooseSeatResult_LeftSingleSeat,
    ///您只能选择一张票
    ChooseSeatResult_OneLeftButChooseContinuousSeat,
    //不是一个区域
    ChooseSeatResult_NotSameArea
};

#endif
