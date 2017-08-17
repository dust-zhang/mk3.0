//
//  SeatManager.m
//  mTime
//
//  Created by jax on 13-7-12.
//  Copyright (c) 2013年 com.mtime. All rights reserved.
//

#import "SeatManager.h"

@interface ChooseSeatManager()
@end

@implementation ChooseSeatManager
@synthesize columnCount = _columnCount, rowCount = _rowCount;
@synthesize allSeats = _allSeats;

- (id) init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) clearData
{
//    SAFERELEASE(_allSeats);
//    SAFERELEASE(_selectedSeats);
    arrWeight[0] = arrWeight[1] = 0;
}

- (void) initSeatsWithSeatsData:(NSArray *) seatList limitCount:(NSInteger) limitCount rowCount:(NSInteger)rowCount columnCount:(NSInteger)columnCount
{
    [self clearData];
    _limitCount = limitCount;
    _columnCount = columnCount;
    _rowCount = rowCount;
    _allSeats = [[NSMutableArray alloc]init];
    _selectedSeats = [[NSMutableArray alloc] initWithCapacity:4];
    for (SeatInfo *seatData in seatList)
    {
        _allSeats[_columnCount * seatData.y + seatData.x] = seatData;
    }
}

- (void) initSeatsWithSeatsData:(NSArray *) seatList limitCount:(NSInteger) limitCount
{
    NSInteger seatColumn = 0;
    NSInteger seatRow = 0;
    for (int i = 0; i < [seatList count]; i++)
    {
        SeatInfo *entity = seatList[i];
        if (seatColumn < entity.x ) {
            seatColumn = entity.x ;
        }
    }
    seatColumn ++;
    seatRow = [seatList count] / seatColumn;
    [self initSeatsWithSeatsData:seatList limitCount:limitCount rowCount:seatRow columnCount:seatColumn];
}

- (NSArray *) getAllSelectedSeats
{
    //获取所有被选择座位的信息
    if (nil != _selectedSeats)
    {
        return [NSArray arrayWithArray:_selectedSeats];
    }
    return nil;
}

//- (NSArray *) getGoldSelectedSeats:(NSInteger)number
//{
//    return nil;
//}

- (ChooseSeatResultEnum) chooseSeat: (NSInteger)x y:(NSInteger)y
{
    //不是座位
    if(x >= _columnCount || y >= _rowCount)
    {
        return ChooseSeatResult_NotSeat;
    }
    
    NSInteger curPos = [self getPositionInSeatArray:x y:y];
    SeatInfo* findSeat = _allSeats[curPos];
    
    //不是座位
    if (findSeat.status == notSeat_SeatStatus)
        return ChooseSeatResult_NotSeat;
        
    //被别人选啦
    if (findSeat.status == selectedByOthers_SeatStatus)
        return ChooseSeatResult_SelectedByOthers;
        
    //判断当前座位是选中状态(true)还是取消选中状态(true)
    if (findSeat.status == canSelect_SeatStatus) //选中的逻辑
    {
        return [self performChooseSeat:findSeat];
    }
    else //取消选中的逻辑 即findSeat.Status == SeatStatus.SelectedByMyself
    {
        return [self performCancelSeat: findSeat];
    }
}

//选座
- (ChooseSeatResultEnum) performChooseSeat: (SeatInfo*) findSeat
{
    if (self.lastAreaName.length == 0)
    {
        self.lastAreaName = findSeat.areaName;
    }
    if ([_selectedSeats count] >= _limitCount) //超过买票上限
        return ChooseSeatResult_MoreThanLimit;
    
    //如果是不同区域
    if (self.lastAreaName != findSeat.areaName)
    {
        return ChooseSeatResult_NotSameArea;
    }
    
    //如果是情侣座
    ChooseSeatResultEnum result = [self handleLoverSeatWhenSelectSeat:findSeat];
    if (result != ChooseSeatResult_None)
        return result;
    
    //接下来是普通座的连选逻辑
    //这里不可选的定义是，墙，情侣座，被其他人选，不是座位
    //处理孤岛1个座，能处理就直接返回，否则继续下面的逻辑
    result = [self handle1IslandWhenSelectSeat:findSeat];
    if (result != ChooseSeatResult_None)
        return result;
    
    //处理孤岛2个座，能处理就直接返回，否则继续下面的逻辑
    result = [self handle2IslandWhenSelectSeat:findSeat];
    if (result != ChooseSeatResult_None)
        return result;
    
    //处理孤岛3个座，能处理就直接返回，否则继续下面的逻辑
    result = [self handle3IslandWhenSelectSeat:findSeat];
    if (result != ChooseSeatResult_None)
        return result;
    
    //处理孤岛>=4个座，能处理就直接返回，否则继续下面的逻辑
    result = [self handle4IslandWhenSelectSeat:findSeat];
    if (result != ChooseSeatResult_None)
        return result;
    
    //处理上述所有情况的漏网之鱼，都是单选，而且视为成功
    [self selectSeat:findSeat]; //其他座位都是单选
    return ChooseSeatResult_OK;
}

//取消选座
- (ChooseSeatResultEnum) performCancelSeat: (SeatInfo*) findSeat
{
    //先找"同生共死连坐对"
    ChooseSeatResultEnum result = [self handleDouobleSelectWhenCancelSeat: (SeatInfo*)findSeat];
    if (result != ChooseSeatResult_None)
        return result;
    
    //如果没有"同生共死连坐对",也就是说，都是一个一个选上的，分2种情况
    //情况1：从墙开始，按顺序一个一个选
    //情况2：//从中间的某个位置开始，按顺序一个一个选，这个中间位置，距离最近的不可选座位，至少要有2个座位，不然会导致连选
    
    //先考虑一种特例，孤岛2个座，两边都是不可选的.那么仅仅是单删
    result = [self handle2IslandSpecialCaseWhenCancelSeat: (SeatInfo*)findSeat];
    if (result != ChooseSeatResult_None)
        return result;
    
    //取消选座，处理从墙（左边）的一边，一个一个选起
    result = [self handleSelectFromLeftWallOneByOneWhenCancelSeat: (SeatInfo*)findSeat];
    if (result != ChooseSeatResult_None)
        return result;
    
    //取消选座，处理从墙（右边）的一边，一个一个选起
    result = [self handleSelectFromRightWallOneByOneWhenCancelSeat: (SeatInfo*)findSeat];
    if (result != ChooseSeatResult_None)
        return result;
    
    //从中间的某个位置开始，按顺序一个一个选
    result = [self handleSelectFromMiddleOneByOneWhenCancelSeat: (SeatInfo*)findSeat];
    if (result != ChooseSeatResult_None)
        return result;
    
    //处理所有其他情况，漏网之鱼，全都视为单删
    [self deselectSeat:findSeat];
    return ChooseSeatResult_OK;
}

//取消选座，处理"同生共死连坐对"
- (ChooseSeatResultEnum) handleDouobleSelectWhenCancelSeat: (SeatInfo*) findSeat
{
    for (NSInteger i = 0; i < 2; i++)
    {
        NSInteger weight = arrWeight[i];
        if (weight == 0)
            continue;
        
        if (weight == (findSeat.x * 2 + 1) + findSeat.y * 1000) //找到"同生共死连坐对"，findSeat在左，另一个是R1
        {
            SeatInfo* seatR1 = [self getRightSeat: findSeat rightStep: 1];
            [self unbindSeats:findSeat withSeat:seatR1];
            return ChooseSeatResult_OK;
        }
        else if (weight == (findSeat.x * 2 - 1) + findSeat.y * 1000) //找到"同生共死连坐对"，findSeat在右，另一个是L1
        {
            SeatInfo* seatL1 = [self getLeftSeat: findSeat leftStep: 1];
            [self unbindSeats:findSeat withSeat:seatL1];
            return ChooseSeatResult_OK;
        }
    }

    return ChooseSeatResult_None;
}

//取消选座，处理特例，孤岛2个座，两边都是不可选的.那么仅仅是单删
- (ChooseSeatResultEnum) handle2IslandSpecialCaseWhenCancelSeat: (SeatInfo*) findSeat
{
    SeatInfo* seatL1 = [self getLeftSeat: findSeat leftStep: 1];
    SeatInfo* seatR1 = [self getRightSeat: findSeat rightStep: 1];
    SeatInfo* seatL2 = [self getLeftSeat: findSeat leftStep: 2];
    SeatInfo* seatR2 = [self getRightSeat: findSeat rightStep: 2];

    if ((![self canSelect:seatL2] && ![self canSelect:seatR1]) ||(![self canSelect:seatL1] && ![self canSelect:seatR2]))
    {
        [self deselectSeat:findSeat];
        return ChooseSeatResult_OK;
    }

    return ChooseSeatResult_None;
}

//取消选座，处理从墙（左边）的一边，一个一个选起
- (ChooseSeatResultEnum) handleSelectFromLeftWallOneByOneWhenCancelSeat: (SeatInfo*) findSeat
{
    SeatInfo* seatL1 = [self getLeftSeat: findSeat leftStep: 1];
    SeatInfo* seatR1 = [self getRightSeat: findSeat rightStep: 1];
    SeatInfo* seatL2 = [self getLeftSeat: findSeat leftStep: 2];
    SeatInfo* seatR2 = [self getRightSeat: findSeat rightStep: 2];
    SeatInfo* seatL3 = [self getLeftSeat: findSeat leftStep: 3];
    SeatInfo* seatR3 = [self getRightSeat: findSeat rightStep: 3];

    if (![self canSelect: seatL1] && [self isSelectByMyselfInNormalMode:seatR1] && [self isSelectByMyselfInNormalMode:seatR2]&& [self isSelectByMyselfInNormalMode:seatR3])
    {
        //4个连选，取消1，连删2
        [self deselectSeat:findSeat];
        [self deselectSeat:seatR1];
        return ChooseSeatResult_OK;
    }
    else if(![self canSelect: seatL2] && [self isSelectByMyselfInNormalMode:seatL1] && [self isSelectByMyselfInNormalMode:seatR1] && [self isSelectByMyselfInNormalMode:seatR2])
    {
        //4个连选，取消2，连删1
        [self deselectSeat:findSeat];
        [self deselectSeat:seatL1];
        return ChooseSeatResult_OK;
    }
    else if(![self canSelect: seatL3] && [self isSelectByMyselfInNormalMode:seatL2] && [self isSelectByMyselfInNormalMode:seatL1] && [self isSelectByMyselfInNormalMode:seatR1] )
    {
        //4个连选，取消3，连删4
        [self deselectSeat:findSeat];
        [self deselectSeat:seatR1];
        return ChooseSeatResult_OK;
    }
    else if (![self canSelect: seatL1] && [self isSelectByMyselfInNormalMode:seatR1] && [self isSelectByMyselfInNormalMode:seatR2])
    {
        //3个连选，取消1，连删2
        [self deselectSeat:findSeat];
        [self deselectSeat:seatR1];
        return ChooseSeatResult_OK;
    }
    else if(![self canSelect: seatL2] && [self isSelectByMyselfInNormalMode:seatL1] && [self isSelectByMyselfInNormalMode:seatR1])
    {
        //3个连选，取消2，连删3
        [self deselectSeat:findSeat];
        [self deselectSeat:seatR1];
        return ChooseSeatResult_OK;
    }
    else if(![self canSelect: seatL1] && [self isSelectByMyselfInNormalMode:seatR1])
    {
        //2个连选，取消1，连删2
        [self deselectSeat:findSeat];
        [self deselectSeat:seatR1];
        return ChooseSeatResult_OK;
    }

    return ChooseSeatResult_None;
}

//取消选座，处理从墙（右边）的一边，一个一个选起
- (ChooseSeatResultEnum) handleSelectFromRightWallOneByOneWhenCancelSeat: (SeatInfo*) findSeat
{
    SeatInfo* seatL1 = [self getLeftSeat: findSeat leftStep: 1];
    SeatInfo* seatR1 = [self getRightSeat: findSeat rightStep: 1];
    SeatInfo* seatL2 = [self getLeftSeat: findSeat leftStep: 2];
    SeatInfo* seatR2 = [self getRightSeat: findSeat rightStep: 2];
    SeatInfo* seatL3 = [self getLeftSeat: findSeat leftStep: 3];
    SeatInfo* seatR3 = [self getRightSeat: findSeat rightStep: 3];

    if (![self canSelect: seatR1] && [self isSelectByMyselfInNormalMode:seatL1] && [self isSelectByMyselfInNormalMode:seatL2] && [self isSelectByMyselfInNormalMode:seatL3])
    {
        //4个连选，取消1，连删2
        [self deselectSeat:findSeat];
        [self deselectSeat:seatL1];
        return ChooseSeatResult_OK;
    }
    else if (![self canSelect: seatR2] && [self isSelectByMyselfInNormalMode:seatR1] && [self isSelectByMyselfInNormalMode:seatL1] && [self isSelectByMyselfInNormalMode:seatL2])
    {
        //4个连选，取消2，连删1
        [self deselectSeat:findSeat];
        [self deselectSeat:seatR1];
        return ChooseSeatResult_OK;
    }
    else if (![self canSelect: seatR3] && [self isSelectByMyselfInNormalMode:seatR2] && [self isSelectByMyselfInNormalMode:seatR1] && [self isSelectByMyselfInNormalMode:seatL1])
    {
        //4个连选，取消3，连删4
        [self deselectSeat:findSeat];
        [self deselectSeat:seatL1];
        return ChooseSeatResult_OK;
    }
    else if (![self canSelect: seatR1] && [self isSelectByMyselfInNormalMode:seatL1] && [self isSelectByMyselfInNormalMode:seatL2])
    {
        //3个连选，取消1，连删2
        [self deselectSeat:findSeat];
        [self deselectSeat:seatL1];
        return ChooseSeatResult_OK;
    }
    else if (![self canSelect: seatR2] && [self isSelectByMyselfInNormalMode:seatR1] && [self isSelectByMyselfInNormalMode:seatL1])
    {
        //3个连选，取消2，连删3
        [self deselectSeat:findSeat];
        [self deselectSeat:seatL1];
        return ChooseSeatResult_OK;
    }
    else if (![self canSelect: seatR1] && [self isSelectByMyselfInNormalMode:seatL1])
    {
        //2个连选，取消1，连删2
        [self deselectSeat:findSeat];
        [self deselectSeat:seatL1];
        return ChooseSeatResult_OK;
    }

    return ChooseSeatResult_None;
}

//从中间的某个位置开始，按顺序一个一个选
- (ChooseSeatResultEnum) handleSelectFromMiddleOneByOneWhenCancelSeat: (SeatInfo*) findSeat
{
    SeatInfo* seatL1 = [self getLeftSeat: findSeat leftStep: 1];
    SeatInfo* seatR1 = [self getRightSeat: findSeat rightStep: 1];
    SeatInfo* seatL2 = [self getLeftSeat: findSeat leftStep: 2];
    SeatInfo* seatR2 = [self getRightSeat: findSeat rightStep: 2];

    //4个连续，1，2，3，4。取消2，连删1
    if ([self isSelectByMyselfInNormalMode:seatL1] && [self isSelectByMyselfInNormalMode:seatR1] && [self isSelectByMyselfInNormalMode:seatR2])
    {
        [self deselectSeat:findSeat];
        [self deselectSeat:seatL1];
        return ChooseSeatResult_OK;
    }
    //4个连续，1，2，3，4。取消3，连删4
    else if ([self isSelectByMyselfInNormalMode:seatL2] && [self isSelectByMyselfInNormalMode:seatL1] && [self isSelectByMyselfInNormalMode:seatR1])
    {
        [self deselectSeat:findSeat];
        [self deselectSeat:seatR1];
        return ChooseSeatResult_OK;
    }
    //3个连选，取消中间的，连删，从已选中座位数组中，从后往前找L1或R1，先找到哪个就删除哪个
    else if([self isSelectByMyselfInNormalMode:seatL1] && [self isSelectByMyselfInNormalMode:seatR1])
    {
        for (NSInteger i = [_selectedSeats count] - 1; i >= 0; i--)
        {
            SeatInfo *seatInfo = _selectedSeats[i];
            if (seatInfo.x == seatL1.x && seatInfo.y == seatL1.y)
            {
                [self deselectSeat:findSeat];
                [self deselectSeat:seatL1];
                return ChooseSeatResult_OK;
            }
            else if (seatInfo.x == seatR1.x && seatInfo.y == seatR1.y)
            {
                [self deselectSeat:findSeat];
                [self deselectSeat:seatR1];
                return ChooseSeatResult_OK;
            }
        }
    }

    return ChooseSeatResult_None;
}

//选情侣座
- (ChooseSeatResultEnum) handleLoverSeatWhenSelectSeat: (SeatInfo*) findSeat
{
    if (findSeat.type == loverLeft_SeatType || findSeat.type == loverRight_SeatType)
    {
        if ([_selectedSeats count] + 2 > _limitCount)    //就只能买一张票了，可又选中了情侣座，不行的啦
        {
            return ChooseSeatResult_OneLeftButChooseLoverSeat;
        }
        
        //情侣座 2为左边
        if (findSeat.type == loverLeft_SeatType)
        {
            //顺便把右边也选了
            SeatInfo* seatR1 = [self getRightSeat: findSeat rightStep: 1];
            if (seatR1 != nil)
            {
                return [self bindSeats:findSeat withSeat:seatR1];;
            }
        }
        else if (findSeat.type == loverRight_SeatType)
        {
            //3为右边，顺便把左边也选了
            SeatInfo* seatL1 = [self getLeftSeat: findSeat leftStep: 1];
            if (seatL1 != nil)
            {
                return [self bindSeats:findSeat withSeat:seatL1];;
            }
        }
    }
    
    return ChooseSeatResult_None;
}

//选座，处理孤岛>=4个座位
- (ChooseSeatResultEnum) handle4IslandWhenSelectSeat: (SeatInfo*) findSeat
{
    SeatInfo* seatL1 = [self getLeftSeat: findSeat leftStep: 1];
    SeatInfo* seatR1 = [self getRightSeat: findSeat rightStep: 1];
    SeatInfo* seatL2 = [self getLeftSeat: findSeat leftStep: 2];
    SeatInfo* seatR2 = [self getRightSeat: findSeat rightStep: 2];

    //对于孤岛>=4
    //1)从任意一边算起，如果当前选中了第二个座位，那么会把第一个座位也选中
    //2)其他座位都是单选
    
    //L2不可选或者被我选，并且L1可选，那么顺便把L1选上
    if ((![self canSelect:seatL2] || [self isSelectByMyselfInNormalMode:seatL2]) && ([self canSelect:seatL1] && seatL1.status != selectedByMyself_SeatStatus)) //从左边算起
    {
        if ([_selectedSeats count] + 2 > _limitCount)    //就只能买一张票了，可又搞出来连选
            return ChooseSeatResult_OneLeftButChooseContinuousSeat;
        
        return [self bindSeats:findSeat withSeat:seatL1];;
    }
    
    //R2不可选或者被我选，并且L1可选，那么顺便把R1选上
    else if ((![self canSelect:seatR2] || [self isSelectByMyselfInNormalMode:seatR2]) && ([self canSelect:seatR1] && seatR1.status != selectedByMyself_SeatStatus))    //从右边算起
    {
        if ([_selectedSeats count] + 2 > _limitCount)    //就只能买一张票了，可又搞出来连选
            return ChooseSeatResult_OneLeftButChooseContinuousSeat;
        
        return [self bindSeats:findSeat withSeat:seatR1];;
    }

    return ChooseSeatResult_None;
}

//选座，处理孤岛3个座位
- (ChooseSeatResultEnum) handle3IslandWhenSelectSeat: (SeatInfo*) findSeat
{
    SeatInfo* seatL1 = [self getLeftSeat: findSeat leftStep: 1];
    SeatInfo* seatR1 = [self getRightSeat: findSeat rightStep: 1];
    SeatInfo* seatL2 = [self getLeftSeat: findSeat leftStep: 2];
    SeatInfo* seatR2 = [self getRightSeat: findSeat rightStep: 2];
    SeatInfo* seatL3 = [self getLeftSeat: findSeat leftStep: 3];
    SeatInfo* seatR3 = [self getRightSeat: findSeat rightStep: 3];

    //先考虑孤岛中间的那个位置
    if ([self isIsland:seatL2 rightSeat:seatR2] && [self canSelect:seatL1] && [self canSelect:seatR1])   //选中间座位, L2,(L1,cur,R1),R2
    {
        //1）如果孤岛的左1和右1（即L2和R2）都是不可选的，那么中间位置不可选
        if (![self canSelect:seatL2] && ![self canSelect:seatR2])
            return ChooseSeatResult_LeftSingleSeat;
        
        //2）如果孤岛的左1和右1（即L2和R2）都是自己选的，那么中间位置不可选
        else if ([self isSelectByMyselfInNormalMode:seatL2] && [self isSelectByMyselfInNormalMode:seatR2])
            return ChooseSeatResult_LeftSingleSeat;
        
        //3）如果孤岛的左1和右1（即L2和R2），R2是自己选的，L2不可选，那么选中中间位值的同时，也会勾选R1
        else if (![self canSelect:seatL2] && [self isSelectByMyselfInNormalMode:seatR2])
        {
            if ([_selectedSeats count] + 2 > _limitCount)    //就只能买一张票了，可又搞出来连选
                return ChooseSeatResult_OneLeftButChooseContinuousSeat;
            
            return   [self bindSeats:findSeat withSeat:seatR1];;
        }
        //4）如果孤岛的左1和右1（即L2和R2），L2是自己选的，R2不可选，那么选中中间位值的同时，也会勾选L1
        else if (![self canSelect:seatR2] && [self isSelectByMyselfInNormalMode:seatL2])
        {
            if ([_selectedSeats count] + 2 > _limitCount)    //就只能买一张票了，可又搞出来连选
                return ChooseSeatResult_OneLeftButChooseContinuousSeat;
            
            return [self bindSeats:findSeat withSeat:seatL1];;
        }
    }
    //孤岛3个座位，最左边和最右边的位置都是单选
    else if ([self isIsland:seatL1 rightSeat:seatR3] && [self canSelect:seatR1] && [self canSelect:seatR2])   //选最左边，单选, L1,(cur,R1,R2),R3
    {
        [self selectSeat:findSeat];
        return ChooseSeatResult_OK;
    }
    else if ([self isIsland:seatL3 rightSeat:seatR1] && [self canSelect:seatL2] && [self canSelect:seatL1])   //选最右边，单选, L3,(L2,L1,cur),R1
    {
        [self selectSeat:findSeat];
        return ChooseSeatResult_OK;
    }

    return ChooseSeatResult_None;
}

//选座，处理孤岛2个座位
- (ChooseSeatResultEnum) handle2IslandWhenSelectSeat: (SeatInfo*) findSeat
{
    SeatInfo* seatL1 = [self getLeftSeat: findSeat leftStep: 1];
    SeatInfo* seatR1 = [self getRightSeat: findSeat rightStep: 1];
    SeatInfo* seatL2 = [self getLeftSeat: findSeat leftStep: 2];
    SeatInfo* seatR2 = [self getRightSeat: findSeat rightStep: 2];

    if ([self isIsland:seatL1 rightSeat:seatR2] && [self canSelect:seatR1]) //孤岛2个座位，选中左边的座位，即findSeat和R1
    {
        //如果孤岛的两边(即L1和R2)都已经被自己选，那么会把另一个也选上
        if ([self isSelectByMyselfInNormalMode:seatL1] && [self isSelectByMyselfInNormalMode:seatR2])
        {
            if ([_selectedSeats count] + 2 > _limitCount)
                return ChooseSeatResult_OneLeftButChooseContinuousSeat;
            
            return [self bindSeats:findSeat withSeat:seatR1];;
        }
        //如果孤岛的两边(即L1和R2)，R2被自己选，L1不可选，那么会把另一个也选上
        else if (![self canSelect:seatL1] && [self isSelectByMyselfInNormalMode:seatR2])
        {
            if ([_selectedSeats count] + 2 > _limitCount)    //就只能买一张票了，可又搞出来连选
                return ChooseSeatResult_OneLeftButChooseContinuousSeat;
            
            return [self bindSeats:findSeat withSeat:seatR1];;
        }
        //孤岛2个座位，其他情形，那么仅仅是单选
        else
        {
            [self selectSeat:findSeat];
            return ChooseSeatResult_OK;
        }
    }
    else if ([self isIsland:seatL2 rightSeat:seatR1] && [self canSelect:seatL1]) //孤岛2个座位，选中右边的座位，即L1和findSeat
    {
        //如果孤岛的两边(即L2和R1)都已经被自己选，那么会把另一个也选上
        if ([self isSelectByMyselfInNormalMode:seatL2] && [self isSelectByMyselfInNormalMode:seatR1])
        {
            if ([_selectedSeats count] + 2 > _limitCount)    //就只能买一张票了，可又搞出来连选
                return ChooseSeatResult_OneLeftButChooseContinuousSeat;
            
            return [self bindSeats:findSeat withSeat:seatL1];;
        }
        //如果孤岛的两边(即L2和R1)，L2被自己选，R1不可选，那么会把另一个也选上
        else if ([self isSelectByMyselfInNormalMode:seatL2] && ![self canSelect:seatR1])
        {
            if ([_selectedSeats count] + 2 > _limitCount)    //就只能买一张票了，可又搞出来连选
                return ChooseSeatResult_OneLeftButChooseContinuousSeat;

            return [self bindSeats:findSeat withSeat:seatL1];;
        }
        //孤岛2个座位，其他情形，那么仅仅是单选
        else
        {
            [self selectSeat:findSeat];
            return ChooseSeatResult_OK;
        }
    }

    return ChooseSeatResult_None;
}

//选座，处理孤岛1个座位
- (ChooseSeatResultEnum) handle1IslandWhenSelectSeat: (SeatInfo*) findSeat
{
    SeatInfo* seatL1 = [self getLeftSeat: findSeat leftStep: 1];
    SeatInfo* seatR1 = [self getRightSeat: findSeat rightStep: 1];
    
    if ([self isIsland:seatL1 rightSeat:seatR1])
    {
        //孤岛1个座位，仅仅单选当前的，孤岛1个座位的定义：左1右1都不可选
        [self selectSeat:findSeat];
        return ChooseSeatResult_OK;
    }

    return ChooseSeatResult_None;
}

 //组装"同生共死连坐对"
- (ChooseSeatResultEnum) bindSeats:(SeatInfo *) seat1 withSeat:(SeatInfo *)seat2
{
    if (seat1.areaName != seat2.areaName)
    {
        return ChooseSeatResult_NotSameArea;
    }
    else
    {
        NSLog(@"%@", NSStringFromSelector(_cmd));
        NSInteger count = 0;
        if (selectedByMyself_SeatStatus != seat1.status)
        {
            [self selectSeat:seat1];
            count++;
        }
        if (selectedByMyself_SeatStatus != seat2.status)
        {
            [self selectSeat:seat2];
            count++;
        }
        if (2 == count)
        {
            NSInteger weight = (seat1.x + seat2.x) + seat1.y * 1000;
            if (0 == arrWeight[0])
            {
                arrWeight[0] = weight;
            }
            else
            {
                arrWeight[1] = weight;
            }
        }
        return ChooseSeatResult_OK;
    }
}

- (void) unbindSeats:(SeatInfo *) seat1 withSeat:(SeatInfo *)seat2
{
    [self deselectSeat:seat1];
    [self deselectSeat:seat2];
    NSInteger weight = (seat1.x + seat2.x) + seat1.y * 1000;
    if (weight == arrWeight[0])
    {
        arrWeight[0] = 0;
    }
    else
    {
        arrWeight[1] = 0;
    }
}

- (void) selectSeat:(SeatInfo *)seat
{
    [_selectedSeats addObject:seat];
    seat.status = selectedByMyself_SeatStatus;
}

- (void) deselectSeat:(SeatInfo *)seat
{
    [_selectedSeats removeObject:seat];
    seat.status = canSelect_SeatStatus;
}

- (BOOL) isIsland:(SeatInfo *)seatL rightSeat:(SeatInfo *)seatR
{
     return (![self canSelect:seatL] || [self isSelectByMyselfInNormalMode:seatL]) && (![self canSelect:seatR] || [self isSelectByMyselfInNormalMode:seatR]);
}

- (BOOL) isSelectByMyselfInNormalMode:(SeatInfo *)seatInfo
{
    return (nil != seatInfo &&
            selectedByMyself_SeatStatus == seatInfo.status &&
            loverLeft_SeatType != seatInfo.type &&
            loverRight_SeatType != seatInfo.type);
}

- (BOOL) canSelect:(SeatInfo *)seatInfo
{
    if (nil == seatInfo ||                                  //墙
        loverLeft_SeatType == seatInfo.type ||
        loverRight_SeatType == seatInfo.type ||      //情侣座
        selectedByOthers_SeatStatus == seatInfo.status ||   //已被选
        notSeat_SeatStatus == seatInfo.status       //不是座位
        )
    {
        return NO;
    }
    return YES;
}

- (NSString *) getSeatInfoKey:(SeatInfo *)seatInfo
{
    return [NSString stringWithFormat:@"%ld", (long)(1000 * seatInfo.y + seatInfo.x) ];
}

- (SeatInfo *) getSeatInfo:(NSInteger) x y:(NSInteger) y
{
    if (x >= _columnCount || x < 0 || y >= _rowCount || y < 0 )
    {
        return nil;
    }
    NSInteger pos = [self getPositionInSeatArray:x y:y];
    if (pos >= [_allSeats count] || pos < 0)
    {
        return nil;
    }
    return _allSeats[pos];
}

- (NSInteger) getPositionInSeatArray:(NSInteger) x y:(NSInteger) y
{
    return _columnCount * y + x;
}

- (SeatInfo *) getLeftSeat:(SeatInfo *) seat leftStep:(NSInteger) step
{
    return [self getSeatInfo:seat.x - step y:seat.y];
}

- (SeatInfo *) getRightSeat:(SeatInfo *) seat rightStep:(NSInteger) step
{
    return [self getSeatInfo:seat.x + step y:seat.y];
}

- (NSString *) chooseSeatResultFromEnum:(ChooseSeatResultEnum)result
{
    NSString *message = nil;
    switch (result)
    {
        case ChooseSeatResult_OK:
            message = @"正常";
            break;
        case ChooseSeatResult_NotSeat:
            message = @"该座位不存在";
            break;
        case ChooseSeatResult_SelectedByOthers:
            message = @"此座位已被他人锁定，如果20分钟内没有完成支付将自动解锁";
            break;
        case ChooseSeatResult_MoreThanLimit:
            message = [NSString stringWithFormat:@"最多可选择%@个座位",@(_limitCount)];
            break;
        case ChooseSeatResult_LeftSingleSeat:
            message = @"请连续选座位，不可留下单独座位";
            break;
        case ChooseSeatResult_OneLeftButChooseContinuousSeat:
            message = @"请不要留下单独空座";
            break;
        case ChooseSeatResult_OneLeftButChooseLoverSeat:
            message = @"该座位为情侣座位，不单独销售，您还可以选择一个普通座位";
            break;
        case ChooseSeatResult_NotSameArea:
            message = @"选择的座位里面包含了多个座区，请重新选择";
            break;
        default:
            break;
    }
    return message;
}

#pragma mark 用服务器返回的最新一行座位信息数组，更新原来_allSeats存储得座位信息
-(void)refreshSeatsDataByNewSeatsInfoArray:(NSArray*)newSeatsInfoArray selectedSeatsAry:(NSArray*)selectedSeatsAry
{
    //用户选座位时，会向服务器请求最新的一行座位信息，并更新_allSeats 存储得座位数据
    for (int i = 0; i < [newSeatsInfoArray count]; i++)
    {
        SeatInfo *seatInfo = newSeatsInfoArray[i];
        if([selectedSeatsAry containsObject:seatInfo])
        {
            seatInfo.status =  selectedByMyself_SeatStatus;
        }
        NSUInteger subScript = _columnCount * seatInfo.y + seatInfo.x;
        [_allSeats replaceObjectAtIndex:subScript withObject:seatInfo];
    }
}

-(void)deleteFromSelectedSeatsByDisabledRowArray:(NSArray*)disabledRowArray
{
    [_selectedSeats removeObjectsInArray:disabledRowArray];
}

@end
