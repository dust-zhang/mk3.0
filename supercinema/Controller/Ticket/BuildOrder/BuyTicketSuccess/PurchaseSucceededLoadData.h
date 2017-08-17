//
//  PurchaseSucceededLoadData.h
//  supercinema
//
//  Created by mapollo91 on 21/11/16.
//
//

#import <Foundation/Foundation.h>
#import "ActivityAwardModel.h"
#import "AwardView.h"
//#import "OrderFinishViewController.h"
//#import "BuyTicketSuccessViewController.h"

@interface PurchaseSucceededLoadData : NSObject
{
    UIView                      *_view;
    BOOL                        _bshowAward;
    ActivityAwardModel          *_activityAwardModel;
    AwardView                   *_awardView;
}
@property (nonatomic, assign)ActivityAwardModel       *_awardModel;
@property (nonatomic, weak  ) NSTimer                 *_awardTimer;
@property (nonatomic, assign) int                     _ncount;
@property (nonatomic, strong) NSString                *_curOrderId;



- (void)startAwardTimer:(UIView*)view orderId:(NSString*)orderId;

@end
