//
//  PayTableViewCell.m
//  movikr
//
//  Created by Mapollo27 on 15/7/31.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "PayTableViewCell.h"

@implementation PayTableViewCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:RGBA(246, 246, 251,1)];
        [self initLayuot];
    }
    return self;
}

-(void) initLayuot
{
    UILabel *labelWhitebg = [[UILabel alloc ] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 82)];
    [labelWhitebg setBackgroundColor:[UIColor whiteColor]];
    [labelWhitebg.layer setBorderWidth:0.5];
    [labelWhitebg.layer setBorderColor:RGBA(0, 0, 0, 0.05).CGColor];
    [self addSubview:labelWhitebg];
    
    //    支付类型图片
    self._imageViewPayType = [[UIImageView alloc ] initWithFrame:CGRectMake(30, 10+59/2, 64/2, 46/2)];
    [self addSubview:self._imageViewPayType];
    
    //    支付类型名称
    self._labelPayType = [[UILabel alloc ] initWithFrame:CGRectMake(self._imageViewPayType.frame.origin.x+self._imageViewPayType.frame.size.width+15, self._imageViewPayType.frame.origin.y, 100, 23)];
    [self._labelPayType setFont:MKFONT(15) ];
    [self._labelPayType setTextColor:RGBA(51, 51, 51, 1)];
    [self._labelPayType setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self._labelPayType];

    self._imageViewUnionPay = [[UIImageView alloc ] initWithFrame:CGRectZero];
    [self addSubview:self._imageViewUnionPay];
}


-(void) setCellData:(PayTypeModel *)model
{
    [self._labelPayType setText:model.payTypeName];
    [self._labelPayType sizeToFit];
    
    if ([model.payTypeCode isEqualToString:@"WX_APP"])
    {
         [self._imageViewPayType setImage:[UIImage imageNamed:@"image_weixinPay.png"]];
    }
    if ([model.payTypeCode isEqualToString:@"ALIPAYCASH"])
    {
        [self._imageViewPayType setImage:[UIImage imageNamed:@"image_zhifubaoPay.png"]];
    }
    if ([model.payTypeCode isEqualToString:@"SXAPPLEPAY"])
    {
        [self._imageViewUnionPay setFrame:CGRectMake(self._labelPayType.frame.size.width+self._labelPayType.frame.origin.x+30, self._imageViewPayType.frame.origin.y, 161/2,47/2)];
        [self._imageViewPayType setImage:[UIImage imageNamed:@"image_ApplePay.png"]];
        [self._imageViewUnionPay setImage:[UIImage imageNamed:@"image_unionpay.png"]];
    }

}
@end
