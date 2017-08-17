//
//  SmallSaleModel.h
//  movikr
//
//  Created by Mapollo28 on 16/1/5.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmallSaleModel : JSONModel
@property(nonatomic,strong)NSString*     _strImageLogo;
@property(nonatomic,strong)NSString*     _strSaleName;
@property(nonatomic,assign)float           _price;   //会员价
@property(nonatomic,assign)float          _priceOrigin; //_secondPrice; 原价
@property(nonatomic,strong)NSString*     _strCardName;  //会员身份
@property(nonatomic,strong)NSString*     _strSaleType;
@property(nonatomic,strong)NSString*     _strSaleDetail;
@property(nonatomic,strong)NSString*     _strEndTime;
@property (nonatomic,strong)NSNumber *endTime;
@property(nonatomic,assign)int           _count;
@property(nonatomic,assign)int           _maxCount;
@property(nonatomic,assign)int           _goodsId;
@property(nonatomic,strong)NSString*     _unit;
@property (nonatomic,strong) NSNumber *couponMethod; //优惠方式  大于零就算有优惠
@property (nonatomic,strong) NSNumber *promotionCount;   //小卖的促销数目
@property (nonatomic,strong) NSNumber *promotionPrice;  //价格是否为促销价
@end

