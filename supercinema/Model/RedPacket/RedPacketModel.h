//
//  RedPacketModel.h
//  movikr
//
//  Created by Mapollo27 on 16/4/7.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShowTimeDetailModel.h"

@interface RedPacketPriceVO : NSObject
@property (nonatomic,assign) NSInteger  dicountPrice;   //折扣
@property (nonatomic,assign) NSInteger  sumPrice;       //合计
@property (nonatomic,assign) NSInteger  realPrice;      //实支
@property (nonatomic,assign) BOOL       isShowLableTip; //是否显示支付提示
@end

@interface RedPacketCellVO : NSObject
@property (nonatomic,assign) BOOL       isSelected;             //是否勾选红包
@property (nonatomic,assign) NSInteger  count;                  //剩余红包数量
@property (nonatomic,assign) NSInteger  currentCount;           //红包数量
@property (nonatomic,strong) NSNumber   *worth;                 //红包抵扣价格
@property (nonatomic,strong) NSString*   redPacketName;             //红包名称
@property (nonatomic,strong) NSString*   redPacketDetails;          //红包描述
@property (nonatomic,strong) NSString*   validEndTime;              //有效期
@property (nonatomic,assign) BOOL       isViewAlphaHidden;          //是否显示灰层
@property (nonatomic,strong) NSNumber    *useMaxCount;  //可用数目
@property (nonatomic,assign) BOOL       isPlusMinus;    //是否显示加减
@property (nonatomic,strong) NSNumber*  useLimit;       //红包使用数量限制类型
@property (nonatomic,assign) BOOL       isCanTouchPlus;         //是否可以点击加按钮
@property (nonatomic,assign) BOOL       isCanTouchMinus;        //是否可以点击减按钮
@property (nonatomic,strong) NSArray*   currentRedPacketIDs;    //红包使用数量限制类型
@property (nonatomic,assign) NSInteger  redPacketLeftCount;     //合并的红包剩余包数
@property (nonatomic,assign) BOOL       isCurrency;             //是否是通用

@end

//红包cell
@interface RedPacketCellModel : NSObject
@property (nonatomic,assign) BOOL       btnState;               //红包按钮的勾选状态
@property (nonatomic,assign) BOOL       useState;               //红包使用过的状态
@property (nonatomic,assign) NSInteger  count;                  //剩余红包数量
@property (nonatomic,assign) NSInteger  currentCount;           //红包数量
@property (nonatomic,assign) NSInteger  useMaxCount;            //红包最大使用数量
@property (nonatomic,assign) BOOL       isCanTouchPlus;         //是否可以点击加按钮
@property (nonatomic,assign) BOOL       isCanTouchMinus;        //是否可以点击减按钮
@property (nonatomic,strong) NSNumber   *worth;                 //红包抵扣价格
@property (nonatomic,assign) NSInteger   redPacketType;         //红包类型
@property (nonatomic,assign) NSInteger   useLimit;              //使用限制
@property (nonatomic,assign) BOOL       isViewAlphaHidden;      //是否显示灰层
@property (nonatomic,assign) NSInteger  leftCount;              //剩余红包数
@property (nonatomic,assign) BOOL       common;                 //是否通用
@property (nonatomic,assign) NSInteger  usedTicketCount;        //已使用票数
@property (nonatomic,assign) NSInteger  usedSaleCount;          //已使用卖品数
@end

//红包详情
@interface RedPacketModel : JSONModel
@property (nonatomic,strong) NSString<Optional>    *unitName;
@property (nonatomic,strong) NSNumber<Optional>    *redPacketId;
@property (nonatomic,strong) NSString<Optional>    *redPacketName;
@property (nonatomic,strong) NSNumber<Optional>    *validEndTime;
@property (nonatomic,strong) NSNumber<Optional>    *validStartTime;
@property (nonatomic,strong) NSString<Optional>    *redPacketDescription;
@property (nonatomic,strong) NSString<Optional>    *useStatus;
@property (nonatomic,strong) NSArray<Optional>     *cinemaNameList;
@property (nonatomic,strong) NSNumber<Optional>    *cinemaSize;
@property (nonatomic,strong) NSNumber<Optional>    *redPacketType;
@property (nonatomic,strong) NSNumber<Optional>    *useLimit;
@property (nonatomic,strong) NSArray<Optional>     *otherUseLimitList;
@property (nonatomic,assign) NSNumber<Optional>    *hasUseLimit;        //是否有使用限制
@property (nonatomic,assign) NSNumber<Optional>    *quantity;           //剩余张数
@property (nonatomic,assign) NSNumber<Optional>    *common;             //是否通用
@property (nonatomic,assign) NSNumber<Optional>    *isExpired;          //0为未过期 ； 1为已过期
@property (nonatomic,assign) NSNumber<Optional>    *movieLimitCount;    //当前影片可用数目
@property (nonatomic,strong) NSNumber<Optional>    *worth;              //红包价值
@property (nonatomic,strong) NSNumber<Optional>    *activeStatus;       //激活状态1:已激活  0:未激活
@end

//红包列表
@interface RedPacketListModel : JSONModel
@property (nonatomic,strong) NSString<Optional>     *redPacketName;
@property (nonatomic,strong) NSNumber<Optional>     *validEndTime;
@property (nonatomic,strong) NSNumber<Optional>     *validStartTime;
@property (nonatomic,strong) NSNumber<Optional>     *redPacketType;
@property (nonatomic,strong) NSNumber<Optional>     *redPacketId;    //红包id
@property (nonatomic,strong) NSNumber<Optional>     *useStatus;
@property (nonatomic,strong) NSNumber<Optional>     *useLimit;
@property (nonatomic,strong) NSNumber<Optional>     *worth;
@property (nonatomic,strong) NSNumber<Optional>     *useMaxCount;    //可用数目
@property (nonatomic,strong) NSNumber<Optional>     *movieLimitCount;  //当前影片可用数目
@property (nonatomic,strong) NSNumber<Optional>     *totalCount;     //红包合并之后的数目
@property (nonatomic,strong) NSArray<Optional>      *combineRedPackIdList;
@property (nonatomic,strong) NSNumber<Optional>     *activityId;
@property (nonatomic,strong) NSNumber<Optional>     *common;         //为true则是通用红包，否则就是不通用红包
@property (nonatomic,strong) NSArray<Optional>      *goodsIds;
@end

//订单确认页获取可用的卡列表
@interface cinemaCardItemListModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>    *id;
@property (nonatomic,strong) NSNumber<Optional>    *cardType;                   //卡类型   0普通，1次卡，2套票，3任看，4通票
@property (nonatomic,strong) NSString<Optional>    *cardItemName;               //卡名称
@property (nonatomic,strong) NSNumber<Optional>    *cardId;                     //所属会员卡的ID
@property (nonatomic,strong) NSNumber<Optional>    *canUseMaxCount;             //本次可以使用的最大数目
@property (nonatomic,strong) NSNumber<Optional>    *totalUseCount;              //用户总共可以使用的次数
@property (nonatomic,strong) NSNumber<Optional>    *validEndTime;               //有效期的截止日期
@property (nonatomic,strong) NSNumber<Optional>    *currMovieCanUseMaxCount;    //当前电影可以使用的最大次数
@property (nonatomic,strong) NSNumber<Optional>    *currMovieUsedCount;         //当前电影已经使用过的次数
@property (nonatomic,strong) NSNumber<Optional>    *leftUseCount;               //剩余次数
@property (nonatomic,strong) NSNumber<Optional>    *cardExchangeStep;                //部长
@end

//可用卡列表状态model
@interface CardStateModel : JSONModel
@property (nonatomic,assign) NSInteger              cardType;             //卡类型   -1:注册即有，0普通，1次卡，2套票，3任看，4通票
@property (nonatomic,strong) NSString               *cardItemName;        //卡名称
@property (nonatomic,assign) NSInteger              cardId;
@property (nonatomic,assign) NSInteger              id;
@property (nonatomic,assign) BOOL                   chooseState;          //勾选状态
@property (nonatomic,assign) BOOL                   isShowViewAlpha;      //显示蒙层状态
@property (nonatomic,strong) MemberPriceModel       *ticketPriceModel;    //票价model
@property (nonatomic,assign) int                    usedLeftCount;        //使用后的余额
@property (nonatomic,assign) int                    canUseCount;          //消耗次数
@property (nonatomic,strong) NSNumber               *cardExchangeStep;                //部长
@end

//红包适用影院列表
@interface CityForCinemaModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* cityId;
@property(nonatomic,strong) NSString<Optional>* cityName;
@end

@interface CityIncludeCinemasModel : JSONModel
@property(nonatomic,strong) CityForCinemaModel<Optional>* city;
@property(nonatomic,strong) NSArray<Optional,CinemaModel>* cinemaList;
@end

@protocol CityIncludeCinemasModel;
@interface RedPacketCinemaListModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* currentTime;
@property(nonatomic,strong) NSArray<Optional,CityIncludeCinemasModel>* cityIncludeCinemas;

@end



