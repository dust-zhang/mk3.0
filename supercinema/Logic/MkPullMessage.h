//
//  MkPullMessage.h
//  movikr
//
//  Created by Mapollo27 on 16/4/11.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServicesNotification.h"
#import "NotifyH5ViewController.h"


@interface MkPullMessage : UIView

+(void) showPushMessage:(UINavigationController *)navigationController triggerType:(int ) triggerType apnsModel:(NotifyListModel*)model typeTime:(NSString *)typeTime;
+(void) apnsShowNotice:(NSString*)jumpUrl type:(NSNumber*)jumpType apnsModel:(NotifyListModel*)model nav:(UINavigationController*)navigation;
+(NSMutableArray *)getLocalNotifiction:(int ) triggerType typeTime:(NSString *)typeTime;
@end
