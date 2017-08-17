//
//  SeatUIButton.h
//

#import <UIKit/UIKit.h>

@class MTSeatDataEntity;
@class SeatInfo;
@interface SeatUIButton : UIButton
{
    SeatInfo *_seatInfo;
}

@property (nonatomic, strong) SeatInfo *seatInfo;

@end
