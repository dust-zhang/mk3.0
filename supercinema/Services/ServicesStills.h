//
//  ServiceStills.h
//  movikr
//
//  Created by Mapollo27 on 15/8/27.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceStills : NSObject

+ (void)getStills:(NSNumber*)movieId includeMainHaibao:(NSNumber *)_includeMainHaibao
            array:(void (^)(NSArray *arrStills))success failure:(void (^)(NSError *error))failure;


@end
