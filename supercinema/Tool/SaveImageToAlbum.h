//
//  SaveImageToAlbum.h
//  movikr
//
//  Created by Mapollo27 on 15/11/3.
//  Copyright © 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CTFont.h>
#import <CoreText/CTStringAttributes.h>
#import <CoreText/CTLine.h>
#import <CoreText/CTParagraphStyle.h>
#import <CoreText/CTFramesetter.h>
#import "OrderModel.h"
//#import "NewsOrderListModel.h"

@interface SaveImageToAlbum : NSObject

//合并图片
+(UIImage *)mergeImage:(OrderInfoModel*)orderInfo couponData:(NewsCouponInfoModel*)couponModel goodsData:(GoodsInfoModel*)goodsModel;


@end
