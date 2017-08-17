//
//  synchroCinemaData.h
//  movikr
//
//  Created by Mapollo27 on 15/11/28.
//  Copyright © 2015年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServicesCinema.h"

@interface synchroCinemaData : NSObject
{
    NSTimer *_timer;
}

-(void) addOfflineCinemeInfo;

@end
