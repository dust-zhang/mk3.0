//
//  synchroCinemaData.m
//  movikr
//
//  Created by Mapollo27 on 15/11/28.
//  Copyright © 2015年 movikr. All rights reserved.
//

#import "synchroCinemaData.h"

@implementation synchroCinemaData

- (id)init
{
    self = [super init];
    return self;
}

-(void) addOfflineCinemeInfo
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(runSynCinema:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                             beforeDate:[NSDate dateWithTimeIntervalSinceNow:ORDERRUNMAXTIME]];

}
//轮询同步状态
-(void)runSynCinema:(NSTimer*) timer
{
    //登陆后才轮询
   if([[Config getUserCredential] length] >0)
   {
       //存在需要同步数据
       //NSLog(@"%@",[Config getCinemaIdArray]);
       
       if([[Config getNotLoginCinemaId] length] >0)
       {
           //切割本地存储的影院id
           NSMutableArray *arrayCinema = [[NSMutableArray alloc ] initWithCapacity:0];
           [arrayCinema addObject:[NSNumber numberWithInt:[[Config getNotLoginCinemaId] intValue] ]];
           NSDictionary* body = @{@"followCinemaIds":arrayCinema};
           NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
           //默认影院
           [dictionary setObject:[NSNumber numberWithInt:[[Config getNotLoginCinemaId] intValue]] forKey:@"defaultCinemaId"];
           [dictionary addEntriesFromDictionary:body ];
           //NSLog(@"%@",[dictionary JSONString]);

           [ServicesCinema synchroCinemaData:dictionary modle:^(RequestResult *model)
           {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_CLOSESETVIEW object:self];
               //同步成功后清空保存的影院数据
               [Config saveNotLoginCinemaId:@""];
               
           } failure:^(NSError *error) {
               NSLog(@"同步影院数据失败");
           }];
       }
   }
}


@end
