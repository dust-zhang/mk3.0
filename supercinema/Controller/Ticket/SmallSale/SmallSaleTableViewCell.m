//
//  SmallSaleTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/10.
//
//

#import "SmallSaleTableViewCell.h"

@implementation SmallSaleTableViewCell
#define MAXSIZE_SALENAME SCREEN_WIDTH-15*5-90-10-40

//初始化cell类
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //白色背景
        _backView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 150-10)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 2;
        _backView.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];
        _backView.layer.borderWidth = 0.5;
        [self.contentView addSubview:_backView];
        
        //卖品logo
        _imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 90, 75)];
        [_backView addSubview:_imageLogo];
        
        //卖品名称
        _labelSaleName = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelSaleName.font = MKBOLDFONT(15);
        _labelSaleName.backgroundColor = [UIColor clearColor];
        _labelSaleName.textColor = RGBA(51, 51, 51, 1);
        [_backView addSubview:_labelSaleName];
        
        //可用优惠label
        _labelHaveDiscount = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelHaveDiscount.font = MKFONT(9);
        _labelHaveDiscount.text = @"可用优惠";
//        CGSize sizeDiscount = [Tool boundingRectWithSize:_labelHaveDiscount.text textFont:MKFONT(9) textSize:CGSizeMake(MAXFLOAT, 9)];
//        _labelHaveDiscount.frame = CGRectMake(0, 0, 40, 15);
        _labelHaveDiscount.textAlignment = NSTextAlignmentCenter;
        _labelHaveDiscount.layer.masksToBounds = YES;
        _labelHaveDiscount.layer.cornerRadius = 2;
        _labelHaveDiscount.backgroundColor = RGBA(248, 188, 41, 1);
        _labelHaveDiscount.textColor = [UIColor whiteColor];
        _labelHaveDiscount.hidden = YES;
        [_backView addSubview:_labelHaveDiscount];
        
//        //仅剩label
//        _labelOnlyLeft = [[UILabel alloc]initWithFrame:CGRectZero];
//        _labelOnlyLeft.font = MKFONT(12);
//        _labelOnlyLeft.backgroundColor = [UIColor clearColor];
//        _labelOnlyLeft.textColor = RGBA(51, 51, 51, 1);
//        [_backView addSubview:_labelOnlyLeft];
        
        //卖品说明
        _labelSaleDetail = [[UILabel alloc]initWithFrame:CGRectMake(120, 40, SCREEN_WIDTH-15*5-90, 12)];
        _labelSaleDetail.font = MKFONT(12);
        _labelSaleDetail.backgroundColor = [UIColor clearColor];
        _labelSaleDetail.textColor = RGBA(51, 51, 51, 1);
        [_backView addSubview:_labelSaleDetail];
        
        //第一行
        _labelFirst = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelFirst.font = MKFONT(12);
        _labelFirst.text = @"原价：";
        _labelFirst.textColor = RGBA(51, 51, 51, 1);
        [_backView addSubview:_labelFirst];
        
        //第一行价格
        _labelFirstPrice = [[LPLabel alloc]initWithFrame:CGRectZero];
        _labelFirstPrice.font = MKFONT(12);
        _labelFirstPrice.textColor = RGBA(51, 51, 51, 1);
        _labelFirstPrice.strikeThroughEnabled = YES;
        [_backView addSubview:_labelFirstPrice];
        
        //第二行
        _labelSecond = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelSecond.font = MKFONT(12);
        _labelSecond.textColor = RGBA(51, 51, 51, 1);
        _labelSecond.text = @"普通会员：";
        [_backView addSubview:_labelSecond];
        
        //第二行价格
        _labelSecondPrice = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelSecondPrice.font = MKFONT(16);
        _labelSecondPrice.textColor = [UIColor redColor];
        [_backView addSubview:_labelSecondPrice];
        
        //加
        _btnPlus = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlus.frame = CGRectZero;
        [_btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
        _btnPlus.backgroundColor = [UIColor clearColor];
        _btnPlus.tag = 0;
        [_btnPlus addTarget:self action:@selector(onButtonCount:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_btnPlus];
        
        //减
        _btnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMinus.frame = CGRectZero;
        _btnMinus.tag = 1;
        _btnMinus.backgroundColor = [UIColor clearColor];
        [_btnMinus setBackgroundImage:[UIImage imageNamed:@"btn_minus_not.png"] forState:UIControlStateNormal];
        [_btnMinus addTarget:self action:@selector(onButtonCount:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_btnMinus];
        
        //count
        _labelCount = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelCount.font = MKFONT(15);
        _labelCount.textAlignment = NSTextAlignmentCenter;
        _labelCount.textColor = RGBA(51, 51, 51, 1);
        [_backView addSubview:_labelCount];
    }
    return self;
}

-(void)setCellData:(SmallSaleModel*)model
{
    _smallSaleModel = model;
    
    [Tool downloadImage:model._strImageLogo button:nil imageView:_imageLogo defaultImage:@"img_sale_default.png"];
//    [_imageLogo sd_setImageWithURL:[NSURL URLWithString:model._strImageLogo] placeholderImage:[UIImage imageNamed:@"img_sale_default.png"]];
    _labelSaleName.text = model._strSaleName;
//    _labelOnlyLeft.text = [NSString stringWithFormat:@"仅剩%d个",100];
    _labelSaleDetail.text = model._strSaleDetail;
    if (model._priceOrigin > 0)
    {
        _labelFirstPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:model._priceOrigin]]];
    }
    if (model._strCardName.length>0)
    {
        _labelSecond.text = [NSString stringWithFormat:@"%@：",model._strCardName];     //会员卡名
    }
    _labelSecondPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:model._price]]];   //会员价
    _labelCount.text = [NSString stringWithFormat:@"%d",model._count];
    
    if (model._count >= model._maxCount)
    {
        [_btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_plus_not.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
    }
    if (model._count>0)
    {
        [_btnMinus setBackgroundImage:[UIImage imageNamed:@"btn_minus.png"] forState:UIControlStateNormal];
        _btnMinus.enabled = YES;
    }
    else
    {
        [_btnMinus setBackgroundImage:[UIImage imageNamed:@"btn_minus_not.png"] forState:UIControlStateNormal];
        _btnMinus.enabled = NO;
    }
    
    if ([model.couponMethod integerValue] > 0)
    {
        //有可用优惠
        _labelHaveDiscount.hidden = NO;
    }
}

-(void)setCellFrame
{
    CGSize sizeSaleName = [Tool boundingRectWithSize:_labelSaleName.text textFont:_labelSaleName.font textSize:CGSizeMake(MAXFLOAT, 15)];
    if (sizeSaleName.width <= MAXSIZE_SALENAME)
    {
        _labelSaleName.frame = CGRectMake(120, 15, sizeSaleName.width, 15);
    }
    else
    {
        _labelSaleName.frame = CGRectMake(120, 15, MAXSIZE_SALENAME, 15);
    }
    _labelHaveDiscount.frame = CGRectMake(_labelSaleName.frame.origin.x+_labelSaleName.frame.size.width+10, 15, 40, 15);
    _labelSaleDetail.frame = CGRectMake(_labelSaleDetail.frame.origin.x, _labelSaleName.frame.origin.y+_labelSaleName.frame.size.height+8, _labelSaleDetail.frame.size.width, _labelSaleDetail.frame.size.height);
    if (_labelFirstPrice.text.length>0)
    {
        CGSize sizeFirst = [Tool boundingRectWithSize:_labelFirst.text textFont:_labelFirst.font textSize:CGSizeMake(MAXFLOAT, 12)];
        CGSize sizeFirstPrice = [Tool boundingRectWithSize:_labelFirstPrice.text textFont:_labelFirstPrice.font textSize:CGSizeMake(MAXFLOAT, 12)];
        //有原价
        _labelFirst.frame = CGRectMake(120, _labelSaleDetail.frame.origin.y+_labelSaleDetail.frame.size.height+8, sizeFirst.width, 12);
        _labelFirstPrice.frame = CGRectMake(_labelFirst.frame.origin.x+_labelFirst.frame.size.width, _labelFirst.frame.origin.y, sizeFirstPrice.width, 12);
    }
    if (_labelSecond.text.length>0)
    {
        CGSize sizeSecond = [Tool boundingRectWithSize:_labelSecond.text textFont:_labelSecond.font textSize:CGSizeMake(MAXFLOAT, 12)];
        //有会员身份
        _labelSecond.frame = CGRectMake(120, _imageLogo.frame.origin.y+_imageLogo.frame.size.height-12, sizeSecond.width, 12);
        _labelSecondPrice.frame = CGRectMake(_labelSecond.frame.origin.x+_labelSecond.frame.size.width, _imageLogo.frame.origin.y+_imageLogo.frame.size.height-16, 80, 16);
    }
    else
    {
        _labelSecondPrice.frame = CGRectMake(120, _imageLogo.frame.origin.y+_imageLogo.frame.size.height-16, 80, 16);
    }
     _backView.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, _imageLogo.frame.origin.y+_imageLogo.frame.size.height+15);
    
    _btnPlus.frame = CGRectMake(_backView.frame.size.width-15-23, _imageLogo.frame.origin.y+_imageLogo.frame.size.height-23, 23, 23);
    _labelCount.frame = CGRectMake(_btnPlus.frame.origin.x-40, _btnPlus.frame.origin.y+4, 40, 15);
    _btnMinus.frame = CGRectMake(_btnPlus.frame.origin.x-40-23, _btnPlus.frame.origin.y, 23, 23);
    
    if (SCREEN_WIDTH == 320)
    {
        _btnPlus.frame = CGRectMake(_backView.frame.size.width-15-23, _imageLogo.frame.origin.y+_imageLogo.frame.size.height+15, 23, 23);
        _labelCount.frame = CGRectMake(_btnPlus.frame.origin.x-40, _btnPlus.frame.origin.y+4, 40, 15);
        _btnMinus.frame = CGRectMake(_btnPlus.frame.origin.x-40-23, _btnPlus.frame.origin.y, 23, 23);
        _backView.frame = CGRectMake(15, _backView.frame.origin.y, SCREEN_WIDTH-30, _btnPlus.frame.origin.y+_btnPlus.frame.size.height+15);
    }
}

-(void)onButtonCount:(UIButton*)btn
{
    if ([self.saleCellDelegate respondsToSelector:@selector(changeValue:isPlus:)])
    {
        if (btn.tag == 0)
        {
            [self.saleCellDelegate changeValue:_smallSaleModel isPlus:YES];
        }
        else
        {
            [self.saleCellDelegate changeValue:_smallSaleModel isPlus:NO];
        }
    }
}

@end
