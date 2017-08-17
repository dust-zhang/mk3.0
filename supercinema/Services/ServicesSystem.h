//
//  ServiceSystem
//  movikr
//
//  Created by Mapollo27 on 15/8/27.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionUpdateModel.h"

@interface ServicesSystem : NSObject
//版本更新
+ (void)getVersionInfo:(void (^)(NSDictionary *versionModel))success failure:(void (^)(NSError *error))failure;
//获取协议内容
+ (void)getProtocolContent:(void (^)(NSString *protocolContent))success failure:(void (^)(NSError *error))failure;
//获取配置
+ (void)getSystemConfig:(NSString* )deviceToken clientId:(NSString *)getuiClientId
                  model:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;
//第一次启动
+ (void)firstStartApp:(NSString *)getuiClientId
                  mdoel:(void (^)(RequestResult *model))success failure:(void (^)(NSError *error))failure;
//添加扫描结果
+ (void)addScanLog:(NSString *)address latitude:(NSString *)_latitude longitude:(NSString *)_longitude  scanContent:(NSString *)_scanContent
             mdoel:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
