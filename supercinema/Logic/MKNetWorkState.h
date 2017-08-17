//
//  MKNetWorkState.h
//  movikr
//
//  Created by Mapollo27 on 15/5/29.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface MKNetWorkState : NSObject

+(NetworkStatus ) getNetWorkState;

@end
