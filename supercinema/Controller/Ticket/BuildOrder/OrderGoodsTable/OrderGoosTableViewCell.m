//
//  OrderGoosTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/12.
//
//

#import "OrderGoosTableViewCell.h"

@implementation OrderGoosTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //logo
        _imageLogo = [[UIImageView alloc]initWithFrame:CGRectZero];
        //_imageLogo.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_imageLogo];
        
        //卖品名
        _labelName = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelName.font = MKBOLDFONT(15);
        _labelName.backgroundColor = [UIColor clearColor];
        _labelName.textColor = RGBA(51, 51, 51, 1);
        [self.contentView addSubview:_labelName];
        
        //卖品详细
        _labelDetail = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelDetail.font = MKFONT(12);
        _labelDetail.backgroundColor = [UIColor clearColor];
        _labelDetail.textColor = RGBA(51, 51, 51, 1);
        _labelDetail.numberOfLines = 2;
        _labelDetail.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_labelDetail];
        
        //卖品数
        _labelCount = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelCount.font = MKFONT(12);
        _labelCount.backgroundColor = [UIColor clearColor];
        _labelCount.textColor = RGBA(51, 51, 51, 1);
        [self.contentView addSubview:_labelCount];
        
        //卡名称
        _labelCardName = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelCardName.font = MKFONT(9);
        _labelCardName.textAlignment = NSTextAlignmentCenter;
        _labelCardName.layer.masksToBounds = YES;
        _labelCardName.layer.cornerRadius = 2;
        _labelCardName.backgroundColor = RGBA(248, 188, 41, 1);
        _labelCardName.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_labelCardName];
        
        //截止日期
        _labelEndDate = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelEndDate.font = MKFONT(10);
        _labelEndDate.backgroundColor = [UIColor clearColor];
        _labelEndDate.textColor = RGBA(123, 122, 152, 1);
        [self.contentView addSubview:_labelEndDate];
        
        //卖品小计
        _labelHeji = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelHeji.font = MKFONT(12);
        _labelHeji.backgroundColor = [UIColor clearColor];
        _labelHeji.textColor = RGBA(123, 122, 152, 1);
        [self.contentView addSubview:_labelHeji];
        
        //小计价格
        _labelHejiPrice = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelHejiPrice.font = MKFONT(17);
        _labelHejiPrice.backgroundColor = [UIColor clearColor];
        _labelHejiPrice.textColor = RGBA(249, 81, 81, 1);
        [self.contentView addSubview:_labelHejiPrice];
        
        //分割线
        _imageLine = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_imageLine];
    }
    return self;
}
-(void)setCellData:(SmallSaleModel*)saleModel isLast:(BOOL)isLast price:(float)price
{
    [Tool downloadImage:saleModel._strImageLogo button:nil imageView:_imageLogo defaultImage:@"img_sale_default.png"];
//    [_imageLogo sd_setImageWithURL:[NSURL URLWithString:saleModel._strImageLogo] placeholderImage:[UIImage imageNamed:@"img_sale_default.png"]];
    _labelName.text = saleModel._strSaleName;
    _labelDetail.text = saleModel._strSaleDetail;
    _labelCount.text = [NSString stringWithFormat:@"%d份",saleModel._count];
    if (isLast)
    {
//        _labelCardName.text = saleModel.priceData.cinemaCardName;
        _labelHeji.text = @"卖品小计：";
//        float saleTotalPrice = saleModel._count * saleModel._price;
        _labelHejiPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:price]]];
        _imageLine.backgroundColor = RGBA(0, 0, 0, 0.05);
        
        _labelEndDate.text =  [Tool returnTime:saleModel.endTime format:@"有效期至：YYYY年MM月dd日"];
    }
    else
    {
        _imageLine.image = [UIImage imageNamed:@"image_dottedLine.png"];
    }
}

-(void)setCellFrame:(BOOL)isLast
{
    _imageLogo.frame = CGRectMake(15, 15, 180/2, 150/2);
    _labelName.frame = CGRectMake(_imageLogo.frame.origin.x + _imageLogo.frame.size.width + 15, 15, SCREEN_WIDTH-15*5-_imageLogo.frame.size.width, 15);
    _labelDetail.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+10, SCREEN_WIDTH-15*5-_imageLogo.frame.size.width, 12);
    [_labelDetail sizeToFit];
    _labelCount.frame = CGRectMake(_labelName.frame.origin.x, _imageLogo.frame.origin.y+_imageLogo.frame.size.height-12, 50, 12);
    if (isLast)
    {
        //最后一个cell
        _imageLine.frame = CGRectMake(0, _labelCount.frame.origin.y+_labelCount.frame.size.height+14.5, SCREEN_WIDTH-30, 0.5);
        CGFloat widthPrice = [Tool calStrWidth:_labelHejiPrice.text  height:17];
        _labelHejiPrice.frame = CGRectMake(SCREEN_WIDTH - 45 - widthPrice, _imageLine.frame.origin.y+_imageLine.frame.size.height+5, widthPrice, 17);
        CGFloat widthHeji = [Tool calStrWidth:_labelHeji.text height:12];
        _labelHeji.frame = CGRectMake(_labelHejiPrice.frame.origin.x - widthHeji, _imageLine.frame.origin.y+_imageLine.frame.size.height+10, widthHeji, 12);
        CGFloat widthCardName = [Tool calStrWidth:_labelCardName.text height:9];
        if (_labelCardName.text.length>0)
        {
            _labelCardName.frame = CGRectMake(_labelHeji.frame.origin.x-10-widthCardName-2, _labelHejiPrice.frame.origin.y, widthCardName+2, 15);
        }
        
        _labelEndDate.frame = CGRectMake(15, _imageLine.frame.origin.y+_imageLine.frame.size.height+12, 250, 10);
    }
    else
    {
        _imageLine.frame = CGRectMake(15, _labelCount.frame.origin.y+_labelCount.frame.size.height+14.5, SCREEN_WIDTH-60, 0.5);
    }

}



@end
