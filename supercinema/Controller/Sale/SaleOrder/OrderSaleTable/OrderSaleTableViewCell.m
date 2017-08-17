//
//  OrderSaleTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/16.
//
//

#import "OrderSaleTableViewCell.h"

@implementation OrderSaleTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //logo
//        _imageLogo = [[UIImageView alloc]initWithFrame:CGRectZero];
//        //_imageLogo.backgroundColor = [UIColor grayColor];
//        [self.contentView addSubview:_imageLogo];
        
        //卖品名
        _labelName = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelName.font = MKBOLDFONT(15);
        _labelName.backgroundColor = [UIColor clearColor];
        _labelName.textColor = RGBA(51, 51, 51, 1);
        _labelName.numberOfLines = 0;
        _labelName.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_labelName];
        
        //卖品详细
        _labelDetail = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelDetail.font = MKFONT(12);
        _labelDetail.backgroundColor = [UIColor clearColor];
        _labelDetail.textColor = RGBA(102, 102, 102, 1);
        _labelDetail.numberOfLines = 0;
        _labelDetail.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_labelDetail];
        
        //卖品数
        _labelCount = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelCount.font = MKFONT(12);
        _labelCount.backgroundColor = [UIColor clearColor];
        _labelCount.textColor = RGBA(51, 51, 51, 1);
        [self.contentView addSubview:_labelCount];
        
//        //卡名称
//        _labelCardName = [[UILabel alloc]initWithFrame:CGRectZero];
//        _labelCardName.font = MKFONT(9);
//        _labelCardName.textAlignment = NSTextAlignmentCenter;
//        _labelCardName.layer.masksToBounds = YES;
//        _labelCardName.layer.cornerRadius = 2;
//        _labelCardName.backgroundColor = RGBA(248, 188, 41, 1);
//        _labelCardName.textColor = [UIColor whiteColor];
//        [self.contentView addSubview:_labelCardName];
        
        //截止日期
        _labelEndDate = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelEndDate.font = MKFONT(11);
        _labelEndDate.backgroundColor = [UIColor clearColor];
        _labelEndDate.textColor = RGBA(123, 122, 152, 1);
        [self.contentView addSubview:_labelEndDate];
        
        //卖品小计
        _labelHeji = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelHeji.font = MKFONT(11);
        _labelHeji.backgroundColor = [UIColor clearColor];
        _labelHeji.textColor = RGBA(123, 122, 152, 1);
        [self.contentView addSubview:_labelHeji];
        
        //小计价格
        _labelHejiPrice = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelHejiPrice.font = MKBOLDFONT(17);
        _labelHejiPrice.backgroundColor = [UIColor clearColor];
        _labelHejiPrice.textColor = RGBA(249, 81, 81, 1);
        [self.contentView addSubview:_labelHejiPrice];
        
        //分割线
        _imageLine = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_imageLine];
    }
    return self;
}

-(void)setCellData:(SnackListModel*)model isLast:(BOOL)isLast price:(float)price
{
//    [Tool downloadImage:model.goodsLogoUrl button:nil imageView:_imageLogo defaultImage:@"img_sale_default.png"];
//    [_imageLogo sd_setImageWithURL:[NSURL URLWithString:model.goodsLogoUrl] placeholderImage:[UIImage imageNamed:@"img_sale_default.png"]];
    _labelName.text = model.goodsName;
    _labelDetail.text = model.goodsDesc;
    _labelCount.text = [NSString stringWithFormat:@"%d份",[model.count intValue]];
    if (isLast)
    {
//        _labelCardName.text = model.priceData.cinemaCardName;
        _labelHeji.text = @"卖品小计：";
        _labelHejiPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:price]]];
        _imageLine.backgroundColor = RGBA(0, 0, 0, 0.05);
        
        _labelEndDate.text =  [Tool returnTime:model.validEndTime format:@"有效期至：YYYY年MM月dd日"];
    }
    else
    {
        _imageLine.image = [UIImage imageNamed:@"image_dottedLine.png"];
    }
}

-(void)setCellFrame:(BOOL)isLast
{
//    _imageLogo.frame = CGRectMake(15, 15, 180/2, 150/2);
    _labelName.frame = CGRectMake(15, 15, SCREEN_WIDTH-15*4, 100);
    [_labelName sizeToFit];
    _labelDetail.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+10, SCREEN_WIDTH-15*4, 100);
    [_labelDetail sizeToFit];
    _labelCount.frame = CGRectMake(_labelName.frame.origin.x, _labelDetail.frame.origin.y+_labelDetail.frame.size.height+10, 50, 12);
    if (isLast)
    {
        //最后一个cell
        _imageLine.frame = CGRectMake(0, _labelCount.frame.origin.y+_labelCount.frame.size.height+14.5, SCREEN_WIDTH-30, 0.5);
        CGFloat widthPrice = [Tool calStrWidth:_labelHejiPrice.text  height:17] + 5;
        _labelHejiPrice.frame = CGRectMake(SCREEN_WIDTH - 45 - widthPrice, _imageLine.frame.origin.y+_imageLine.frame.size.height+6, widthPrice, 17);
        CGFloat widthHeji = [Tool calStrWidth:_labelHeji.text height:12];
        _labelHeji.frame = CGRectMake(_labelHejiPrice.frame.origin.x - widthHeji, _imageLine.frame.origin.y+_imageLine.frame.size.height+12, widthHeji, 11);
//        CGFloat widthCardName = [Tool calStrWidth:_labelCardName.text height:9];
//        if (_labelCardName.text.length>0)
//        {
//            _labelCardName.frame = CGRectMake(_labelHeji.frame.origin.x-10-widthCardName-2, _labelHejiPrice.frame.origin.y+2, widthCardName+2, 15);
//        }
        
        _labelEndDate.frame = CGRectMake(15, _labelHeji.frame.origin.y, 250, 11);
    }
    else
    {
        _imageLine.frame = CGRectMake(15, _labelCount.frame.origin.y+_labelCount.frame.size.height+14.5, SCREEN_WIDTH-60, 0.5);
    }
}

@end
