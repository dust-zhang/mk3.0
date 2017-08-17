//
//  MKPay.h
//  movikr
//
//  Created by Mapollo27 on 15/9/18.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayModel.h"

@interface MKPayManager : NSObject
//支付宝支付
+(void) zhifubaoPay:(NSString *) orderString model:(void (^)(ZhifubaoModel *zfbModel))success;
//微信支付
+(void) weixinPay:(WeinxinPayModel *) weixinModel;
//apple pay 支付参数
+ (NSString *)PayNormaWith:(NSString *)payInfo applePayModel:(ApplePayModel *)model;
@end
