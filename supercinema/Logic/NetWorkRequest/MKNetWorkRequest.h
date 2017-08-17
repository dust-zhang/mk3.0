//
//  CYPNetWorkRequest.h
//  CYPSecondCar
//
//  Created by zhangjingfei on 24/3/15.
//
//

#import <Foundation/Foundation.h>

@interface MKNetWorkRequest : NSObject

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)bodys
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
