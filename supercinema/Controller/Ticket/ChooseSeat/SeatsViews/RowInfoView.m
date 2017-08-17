//
//  RowInfoView.m
//

#import "RowInfoView.h"

const NSUInteger kRowInfoViewHeight = 23;
const float kRowInfoViewHorizentalMargin = 10; //两个座位信息水平间距

#define kRowInfoViewMinWidth (SCREEN_WIDTH - 15*2 - kRowInfoViewHorizentalMargin*3)/4
#define kLeftCapWidth 8

@implementation RowInfoView
@synthesize infoLabel = infoLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIImage *image = [[UIImage imageNamed:@"v10_selected_seats_background"]stretchableImageWithLeftCapWidth:kLeftCapWidth topCapHeight:0];
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:imageView];
        infoLabel = [[UILabel alloc] initWithFrame:imageView.frame];
        infoLabel.textColor = [UIColor blackColor];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.font = MKBOLDFONT(12);
        infoLabel.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:infoLabel];
    }
    return self;
}

+(CGFloat)rowInfoViewWidthForSeatName:(NSString*)seatName
{
    //判断
    CGSize infoLabelSize =[Tool boundingRectWithSize:seatName textFont:MKBOLDFONT(1) textSize:CGSizeMake(CGFLOAT_MAX, kRowInfoViewHeight)];
    CGFloat rowInfoViewActualWidth =  infoLabelSize.width + kLeftCapWidth*2;
    rowInfoViewActualWidth = rowInfoViewActualWidth < kRowInfoViewMinWidth ? kRowInfoViewMinWidth : rowInfoViewActualWidth;
    return rowInfoViewActualWidth;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void)dealloc
{
   
}

@end
