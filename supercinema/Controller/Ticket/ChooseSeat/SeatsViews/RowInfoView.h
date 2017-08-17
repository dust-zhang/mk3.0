//
//  RowInfoView.h
//

#import <UIKit/UIKit.h>

extern const NSUInteger kRowInfoViewHeight;
extern const float kRowInfoViewHorizentalMargin;

@interface RowInfoView : UIView
{
    UIImageView *imageView;         // 背景图
    UILabel *infoLabel;             // 座位信息
}

@property (nonatomic, strong) UILabel *infoLabel;

+(CGFloat)rowInfoViewWidthForSeatName:(NSString*)seatName;

@end
