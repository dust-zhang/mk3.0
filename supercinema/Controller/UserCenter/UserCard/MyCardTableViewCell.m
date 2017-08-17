//
//  MyCardTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 25/11/16.
//
//

#import "MyCardTableViewCell.h"

@implementation MyCardTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:RGBA(246, 246, 251,1)];
        
        [self initController];
    }
    return self;
}

-(void)initController
{
    UIView *viewWhiteBg = [[UIView alloc ] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 100)];
    [viewWhiteBg setBackgroundColor:[UIColor whiteColor]];
    [viewWhiteBg.layer setBorderWidth:0.5];
    [viewWhiteBg.layer setBorderColor:RGBA(0, 0, 0, 0.05).CGColor];
    viewWhiteBg.layer.cornerRadius = 2.f;//圆角
    [self.contentView addSubview:viewWhiteBg];

    _imageLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageLogo setBackgroundColor:[UIColor clearColor]];//RGBA(123, 122, 152, 1)
    [_imageLogo.layer setCornerRadius:15.f];
    [viewWhiteBg addSubview:_imageLogo];
    
    _labelName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelName setBackgroundColor:[UIColor clearColor]];
    [_labelName setFont:MKBOLDFONT(15)];
    [_labelName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [viewWhiteBg addSubview:_labelName];
    
    _labelCountInfo = [[UILabel alloc] initWithFrame:CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+10, SCREEN_WIDTH/2, 15)];
    [_labelCountInfo setBackgroundColor:[UIColor clearColor]];
    [_labelCountInfo setTextAlignment:NSTextAlignmentLeft];
    
    [viewWhiteBg addSubview:_labelCountInfo];
}

-(void)setCardAndCouponFrameData:(CardAndCouponCountModel *)cardAndCouponCountModel indexPath:(NSInteger)indexPath
{
    _imageLogo.frame = CGRectMake(15, 33.5, 30, 30);
    
    _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, 30, SCREEN_WIDTH/2, 15);
    
    _labelCountInfo.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+10, SCREEN_WIDTH/2, 15);
    
    if (indexPath == 0)
    {
        _labelName.text = @"会员权益";
        [_imageLogo setImage:[UIImage imageNamed:@"image_membershipCard.png"]];
        
        NSString *str = [NSString stringWithFormat:@"共拥有%d项会员权益",[cardAndCouponCountModel.cinemaCardCount intValue]];
        NSUInteger joinCount =[[NSString stringWithFormat:@"%d项", [cardAndCouponCountModel.cinemaCardCount intValue]] length];
        //算出range的位置
        NSRange oneRange =NSMakeRange(0,3);
        NSRange twoRange =NSMakeRange(3,joinCount);
        NSRange threeRange =NSMakeRange(joinCount+3,4);
        NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
        //设置字号 & 颜色
        [strAtt addAttribute:NSFontAttributeName value:MKFONT(12) range:oneRange];
        [strAtt addAttribute:NSFontAttributeName value:MKFONT(15) range:twoRange];
        [strAtt addAttribute:NSFontAttributeName value:MKFONT(12) range:threeRange];
        [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:oneRange];
        [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(249, 81, 81, 1) range:twoRange];
        [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1)range:threeRange];
        [_labelCountInfo setAttributedText:strAtt];
    }
    else
    {
        _labelName.text = @"优惠券";
        [_imageLogo setImage:[UIImage imageNamed:@"image_coupon.png"]];
        
        NSString *str = [NSString stringWithFormat:@"共拥有%d张可用优惠券",[cardAndCouponCountModel.couponCount intValue]];
        NSUInteger joinCount =[[NSString stringWithFormat:@"%d张", [cardAndCouponCountModel.couponCount intValue]] length];
        //算出range的位置
        NSRange oneRange =NSMakeRange(0,3);
        NSRange twoRange =NSMakeRange(3,joinCount);
        NSRange threeRange =NSMakeRange(joinCount+3,5);
        NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
        //设置字号 & 颜色
        [strAtt addAttribute:NSFontAttributeName value:MKFONT(12) range:oneRange];
        [strAtt addAttribute:NSFontAttributeName value:MKFONT(15) range:twoRange];
        [strAtt addAttribute:NSFontAttributeName value:MKFONT(12) range:threeRange];
        [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1) range:oneRange];
        [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(249, 81, 81, 1) range:twoRange];
        [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1)range:threeRange];
        [_labelCountInfo setAttributedText:strAtt];
    }
}



@end
