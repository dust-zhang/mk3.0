//
//  PurchaseSucceededLoadData.m
//  supercinema
//
//  Created by mapollo91 on 21/11/16.
//
//

#import "PurchaseSucceededLoadData.h"

@implementation PurchaseSucceededLoadData

- (void)startAwardTimer:(UIView*)view orderId:(NSString*)orderId
{
    self._ncount = 0;
    self._curOrderId = orderId;
    _view = view;
    _bshowAward = YES;
    _activityAwardModel = [[ActivityAwardModel alloc] init];
    [self loadData];
}

-(void)loadData
{
    __weak PurchaseSucceededLoadData* weakSelf = self;
    self._awardTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:weakSelf
                                                      selector:@selector(runOrderStatus:)
                                                      userInfo:nil
                                                       repeats:YES];
    [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes
                             beforeDate:[NSDate dateWithTimeIntervalSinceNow:ORDERRUNMAXTIME]];
    
}

-(void)runOrderStatus:(NSTimer*) timer
{
    self._ncount ++;
    __weak typeof(self) weakSelf = self;
    
//    NSLog(@"self._ncount\n%d",self._ncount);
    
    if (!_bshowAward)
    {
        return;
    }
    [ServiceActivity getAwardList:self._curOrderId model:^(ActivityAwardModel *model)
     {
         _activityAwardModel = model;
         
         //如果为true则停止轮询此接口
         if ([model.grantSuccess boolValue] || weakSelf._ncount >= ORDERRUNMAXTIME ||![model.hasActivityGrant boolValue]|| [model.activityGrantList count] <= 0)
         {
             [weakSelf stopTimer];
             NSLog(@"没有奖励的红包");
         }
         
         if ([model.activityGrantList count] > 0 || [model.shareRedpackFee intValue] >0)
         {
             //如果有奖励列表数 或者 有群发红包金额
             
             [weakSelf stopTimer];
             //如果奖励列表有数据
             _bshowAward = NO;
            //弹起奖励页
             [weakSelf bounceAwardView];
         }
         else
         {
             [weakSelf stopTimer];
             //如果奖励列表没有数据
//             [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_GETAWARDDATA object:nil];
         }
     } failure:^(NSError *error) {
         [weakSelf stopTimer];
     }];
}

//弹起奖励页
-(void)bounceAwardView
{
    [MobClick event:mainViewbtn55];
    [_awardView removeFromSuperview];
    _awardView = nil;
    if (_awardView == nil)
    {
        _awardView= [[AwardView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) arr:_activityAwardModel.activityGrantList shareRedpackFee:_activityAwardModel.shareRedpackFee];
        NSInteger num = [self._curOrderId integerValue];
        _awardView._orderId = @(num);
        _awardView.hidden = YES;
        _awardView.alpha = 0;
        _awardView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        [_view addSubview:_awardView];
        
        [UIView animateWithDuration:0.4
                         animations:^{
                             _awardView.transform = CGAffineTransformMakeScale(1, 1);
                             _awardView.hidden=NO;
                             _awardView.alpha=1;
                         }completion:^(BOOL finish){
                             
                         }];
    }
}

-(void)stopTimer
{
    [self._awardTimer invalidate];
    self._awardTimer = nil;
}
-(void)dealloc
{
    [self._awardTimer invalidate];
    self._awardTimer = nil;
}


@end


