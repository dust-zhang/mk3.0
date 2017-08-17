//
//  SaleListTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/16.
//
//

#import "SaleListTableViewCell.h"

@implementation SaleListTableViewCell

#define MAXSIZE_SALENAME SCREEN_WIDTH-15*5-75

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
        _backView.layer.borderWidth = 0.5;
        _backView.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];
        [self.contentView addSubview:_backView];
        
        //卖品logo
        _btnLogo = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnLogo.frame = CGRectMake(15, 15, 75, 75);
        _btnLogo.backgroundColor = [UIColor clearColor];
        [_btnLogo addTarget:self action:@selector(onButtonLogo:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_btnLogo];
        
        //卖品名称
        _labelSaleName = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelSaleName.font = MKFONT(15);
        _labelSaleName.backgroundColor = [UIColor clearColor];
        _labelSaleName.textColor = RGBA(51, 51, 51, 1);
        [_backView addSubview:_labelSaleName];
        
        //卖品说明
        _labelSaleDetail = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelSaleDetail.font = MKFONT(12);
        _labelSaleDetail.backgroundColor = [UIColor clearColor];
        _labelSaleDetail.textColor = RGBA(51, 51, 51, 1);
        [_backView addSubview:_labelSaleDetail];
        
        //第一行价格
        _labelFirstPrice = [[LPLabel alloc]initWithFrame:CGRectZero];
        _labelFirstPrice.font = MKFONT(12);
        _labelFirstPrice.textColor = RGBA(180, 180, 180, 1);
        _labelFirstPrice.strikeThroughEnabled = YES;
        [_backView addSubview:_labelFirstPrice];
        
        //第二行价格
        _labelSecondPrice = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelSecondPrice.font = MKFONT(16);
        _labelSecondPrice.textColor = [UIColor redColor];
        [_backView addSubview:_labelSecondPrice];
        
        //加
        _btnPlus = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlus.frame = CGRectZero;
        [_btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_sale_plus.png"] forState:UIControlStateNormal];
        _btnPlus.backgroundColor = [UIColor clearColor];
        _btnPlus.tag = 0;
        [_btnPlus addTarget:self action:@selector(onButtonCount:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_btnPlus];
        
        //减
        _btnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMinus.frame = CGRectZero;
        _btnMinus.tag = 1;
        _btnMinus.backgroundColor = [UIColor clearColor];
        [_btnMinus setBackgroundImage:nil forState:UIControlStateNormal];
        [_btnMinus addTarget:self action:@selector(onButtonCount:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_btnMinus];
        
        //count
        _labelCount = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelCount.font = MKFONT(15);
        _labelCount.textAlignment = NSTextAlignmentCenter;
        _labelCount.textColor = RGBA(51, 51, 51, 1);
        [_backView addSubview:_labelCount];
        
        //空白view
        _viewBlank = [[UIView alloc]initWithFrame:CGRectZero];
        _viewBlank.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_viewBlank];
        
        UITapGestureRecognizer* tapBlank = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBlank)];
        [_viewBlank addGestureRecognizer:tapBlank];
    }
    return self;
}

-(void)setCellData:(SnackListModel*)model
{
    _smallSaleModel = model;
    
    [Tool downloadImage:model.goodsLogoUrl button:_btnLogo imageView:nil defaultImage:@"image_saleList_default.png"];
    _labelSaleName.text = model.goodsName;
    _labelSaleDetail.text = model.goodsDesc;
    
    SnackPriceDataModel* priceModel = model.priceData;
    float originPrice = [priceModel.originalPrice floatValue];
    float memberPrice = [priceModel.priceBasic floatValue] + [priceModel.priceService floatValue];
    
    if (originPrice > 0 && originPrice > memberPrice)
    {
        _labelFirstPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:originPrice]]];
    }
    else
    {
        _labelFirstPrice.text = @"";
    }
    _labelSecondPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:memberPrice]]];   //会员价
    
    if ([model.count intValue] >= [model.maxSelectCount intValue])
    {
        [_btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_sale_plus_not.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_sale_plus.png"] forState:UIControlStateNormal];
    }
    if ([model.count intValue]>0)
    {
        _labelCount.text = [NSString stringWithFormat:@"%d",[model.count intValue]];
        _btnMinus.hidden = NO;
        [_btnMinus setBackgroundImage:[UIImage imageNamed:@"btn_sale_minus.png"] forState:UIControlStateNormal];
    }
    else
    {
        _labelCount.text = @"";
        _btnMinus.hidden = YES;
    }
}

-(void)setCellFrame:(NSInteger)index isLast:(BOOL)isLast
{
    _labelSaleName.frame = CGRectMake(_btnLogo.frame.origin.x+_btnLogo.frame.size.width+15, 15, MAXSIZE_SALENAME, 15);
    _labelSaleDetail.frame = CGRectMake(_labelSaleName.frame.origin.x, _labelSaleName.frame.origin.y+_labelSaleName.frame.size.height+10, MAXSIZE_SALENAME, 12);
    CGSize sizeSecondPrice = [Tool boundingRectWithSize:_labelSecondPrice.text textFont:_labelSecondPrice.font textSize:CGSizeMake(MAXFLOAT, 16)];
    _labelSecondPrice.frame = CGRectMake(_labelSaleName.frame.origin.x, _labelSaleDetail.frame.origin.y+_labelSaleDetail.frame.size.height+22, sizeSecondPrice.width, 16);
    if (_labelFirstPrice.text.length>0)
    {
        CGSize sizeFirstPrice = [Tool boundingRectWithSize:_labelFirstPrice.text textFont:_labelFirstPrice.font textSize:CGSizeMake(MAXFLOAT, 12)];
        //有原价
        _labelFirstPrice.frame = CGRectMake(_labelSecondPrice.frame.origin.x+_labelSecondPrice.frame.size.width+10, _labelSecondPrice.frame.origin.y+4, sizeFirstPrice.width, 12);
    }
    if (index == 0)
    {
        //第一个cell
        _backView.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, _btnLogo.frame.origin.y+_btnLogo.frame.size.height+15);
    }
    else
    {
        _backView.frame = CGRectMake(15, 15, SCREEN_WIDTH-30, _btnLogo.frame.origin.y+_btnLogo.frame.size.height+15);
    }
    _btnPlus.frame = CGRectMake(_backView.frame.size.width-15-30, _btnLogo.frame.origin.y+_btnLogo.frame.size.height-30, 30, 30);
    _labelCount.frame = CGRectMake(_btnPlus.frame.origin.x-23, _btnPlus.frame.origin.y+7.5, 23, 15);
    _btnMinus.frame = CGRectMake(_btnPlus.frame.origin.x-30-23, _btnPlus.frame.origin.y, 30, 30);
    
    if (isLast)
    {
        _viewBlank.frame = CGRectMake(0, _backView.frame.origin.y+_backView.frame.size.height, SCREEN_WIDTH, 150);
    }
}

-(void)onButtonCount:(UIButton*)btn
{
    if ([self.saleCellDelegate respondsToSelector:@selector(changeValue:isPlus:curIndex:)])
    {
        if (btn.tag == 0)
        {
            [MobClick event:mainViewbtn93];
            [self.saleCellDelegate changeValue:_smallSaleModel isPlus:YES curIndex:self.curIndexPath];
        }
        else
        {
            [MobClick event:mainViewbtn94];
            [self.saleCellDelegate changeValue:_smallSaleModel isPlus:NO curIndex:self.curIndexPath];
        }
    }
}

-(void)onButtonLogo:(UIButton*)btn
{
    if ([self.saleCellDelegate respondsToSelector:@selector(showSaleDetail:curIndex:)])
    {
        [self.saleCellDelegate showSaleDetail:_smallSaleModel curIndex:self.curIndexPath];
    }
}

-(void)tapBlank
{
    
}


@end
