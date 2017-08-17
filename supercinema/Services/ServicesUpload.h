//
//  ServicesUpload.h
//  movikr
//
//  Created by Mapollo27 on 15/9/1.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServicesUpload : NSObject

+(NSMutableArray *)getUploadYpaiParam:(NSDictionary *)stringJson;

+ (void)requestUpdateImage:(NSInteger)count type:(NSString *) type
                     success:(void (^)(NSDictionary *suc))success failure:(void (^)(NSError *error))failure;
@end
