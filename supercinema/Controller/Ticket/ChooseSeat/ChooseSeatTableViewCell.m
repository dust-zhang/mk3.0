//
//  ChooseSeatTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/10.
//
//

#import "ChooseSeatTableViewCell.h"

@implementation ChooseSeatTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(!self) return self;
    
    _imageShowTimeType = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_imageShowTimeType];
    
    //开始时间
    _labelShowTimeType = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelShowTimeType.textColor = RGBA(123, 122, 152, 1);
    _labelShowTimeType.font = MKFONT(12);
    [self.contentView addSubview:_labelShowTimeType];
    
    //时间轴
    _imageTimeLine = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_imageTimeLine];
    
    //开始时间
    _labelStartTime = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelStartTime.textColor = RGBA(51, 51, 51, 1);
    _labelStartTime.font = MKFONT(20);
    [self.contentView addSubview:_labelStartTime];
    
    //散场时间
    _labelEndTime = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelEndTime.textColor = RGBA(123, 122, 152, 1);
    _labelEndTime.font = MKFONT(12);
    [self.contentView addSubview:_labelEndTime];
    
    //语言
    _labelLanguage = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelLanguage.textColor = RGBA(85, 85, 85, 1);
    _labelLanguage.font = MKFONT(13);
    [self.contentView addSubview:_labelLanguage];
    
    //厅
    _labelHall = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelHall.textColor = RGBA(123, 122, 152, 1);
    _labelHall.font = MKFONT(12);
    [self.contentView addSubview:_labelHall];
    
    //第一行
    _labelFirst = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelFirst.textColor = RGBA(51, 51, 51, 1);
    _labelFirst.font = MKFONT(13);
    _labelFirst.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_labelFirst];
    
    //第二行
    _labelSecond = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelSecond.textColor = RGBA(123, 122, 152, 0.6);
    _labelSecond.font = MKFONT(12);
    _labelSecond.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_labelSecond];
    
    //第一行价格
    _labelFirstPrice = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelFirstPrice.textColor = RGBA(249, 81, 81, 1);
    _labelFirstPrice.font = MKFONT(16);
    [self.contentView addSubview:_labelFirstPrice];
    
    //第二行价格
    _labelSecondPrice = [[LPLabel alloc]initWithFrame:CGRectZero];
    _labelSecondPrice.textColor = RGBA(123, 122, 152, 0.6);
    _labelSecondPrice.font = MKFONT(12);
    _labelSecondPrice.strikeThroughColor = RGBA(51, 51, 51, 1);
    _labelSecondPrice.strikeThroughEnabled = NO;
    [self.contentView addSubview:_labelSecondPrice];
    
    _imageLastPic = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:_imageLastPic];
    return self;
}

-(void)setData:(ShowTimesModel*)showTModel
{
    if ([showTModel.showTimeType isEqualToString:@"0"])
    {
        //第一场早场
        _imageShowTimeType.image = [UIImage imageNamed:@"img_morning.png"];
        _labelShowTimeType.text = @"  ";
    }
    else if ([showTModel.showTimeType isEqualToString:@"1"])
    {
        //第一场晚场
        _imageShowTimeType.image = [UIImage imageNamed:@"img_night.png"];
        _labelShowTimeType.text = @"  ";
    }
    else if ([showTModel.showTimeType isEqualToString:@"2"])
    {
        //第一场次日场
        _imageShowTimeType.image = [UIImage imageNamed:@"img_tomorrow.png"];
        _labelShowTimeType.text = @"次日";
    }
    
    NSString *strHour = [Tool returnTime:showTModel.startPlayTime format:@"HH"];
    if ([strHour intValue] < 18 && [strHour intValue] >= 6)
    {
        //早场
        _imageTimeLine.backgroundColor = RGBA(255, 198, 0, 0.2);
    }
    if ([strHour intValue] >= 18 && [strHour intValue] < 24)
    {
        //晚场
        _imageTimeLine.backgroundColor = RGBA(117, 112, 255, 0.2);
    }
    if ([strHour intValue] >= 0 && [strHour intValue] < 6)
    {
        //次日场
        _imageTimeLine.backgroundColor = RGBA(218, 161, 255, 0.2);
    }
    
    _labelStartTime.text = [Tool returnTime:showTModel.startPlayTime format:@"HH : mm"];
    [_labelEndTime setText:[NSString stringWithFormat:@"%@散场",[Tool returnTime:showTModel.endPlayTime format:@"HH:mm"]]];
    NSString* strCut = @"/";
    if (showTModel.language.length<=0 || showTModel.versionDesc.length<=0)
    {
        strCut = @"";
    }
    [_labelLanguage setText:[NSString stringWithFormat:@"%@%@%@",showTModel.language,strCut,showTModel.versionDesc]];
    if ([showTModel.hall.hallSizeDesc length] == 0)
    {
        [_labelHall setText:[NSString stringWithFormat:@"%@",showTModel.hall.hallName]];
    }
    else
    {
        [_labelHall setText:[NSString stringWithFormat:@"%@(%@)",showTModel.hall.hallName,showTModel.hall.hallSizeDesc]];
    }
    
    [self setMoviePrice:showTModel];
}

-(void)setMoviePrice:(ShowTimesModel*)showTModel
{
    //得到第一行应该显示的价格
    displayPriceListModel* firstPriceModel = [showTModel.displayPriceList objectAtIndex:0];
    NSInteger firstTotal = 0;
    firstTotal = [firstPriceModel.priceBasic integerValue] + [firstPriceModel.priceService integerValue];
    [_labelFirstPrice setText:[NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithInteger:firstTotal]]]];
    if (firstPriceModel.cinemaCardName.length>0)
    {
        _labelFirst.text = firstPriceModel.cinemaCardName;
    }
    if (showTModel.displayPriceList.count > 1)
    {
        //得到第二行应该显示的价格
        displayPriceListModel* secondPriceModel = [showTModel.displayPriceList objectAtIndex:1];
        NSInteger secondTotal = 0;
        secondTotal = [secondPriceModel.priceBasic integerValue] + [secondPriceModel.priceService integerValue];
        
        if ([secondPriceModel.cinemaCardId intValue] == -1)
        {
            //门市价
            [_labelSecond setText:@"原价："];
            [_labelSecondPrice setText:[NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithInteger:secondTotal]]]];
            _labelSecondPrice.strikeThroughEnabled = YES;
        }
        else
        {
            _labelSecond.text = [NSString stringWithFormat:@"%@：",secondPriceModel.cinemaCardName];
            [_labelSecondPrice setText:[NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithInteger:secondTotal]]]];
        }
    }
}

-(void)layoutFrame:(BOOL)isLastCell
{
    CGFloat space = 0;
    CGFloat originX = 150;
    if (_labelShowTimeType.text.length>0)
    {
        //有早晚场标示
        _imageShowTimeType.frame = CGRectMake(15, 10, 12, 12);
        _labelShowTimeType.frame = CGRectMake(15+12+10, 10, 100, 12);
        space = 10;
    }
    if (SCREEN_WIDTH == 320)
    {
        originX = 130;
    }
    _imageTimeLine.frame = CGRectMake(20, _imageShowTimeType.frame.origin.y+_imageShowTimeType.frame.size.height+space, 2, 90);
    _labelStartTime.frame = CGRectMake(74/2, _imageTimeLine.frame.origin.y+18, 100, 20);
    _labelEndTime.frame = CGRectMake(74/2, _labelStartTime.frame.origin.y+_labelStartTime.frame.size.height+13, 100, 12);
    _labelLanguage.frame = CGRectMake(originX, _imageTimeLine.frame.origin.y+18+7, 100, 13);
    _labelHall.frame = CGRectMake(originX, _labelEndTime.frame.origin.y, 100, 12);
    
    CGSize sizeFirstPrice = [Tool boundingRectWithSize:_labelFirstPrice.text textFont:MKFONT(16) textSize:CGSizeMake(MAXFLOAT, 16)];
    _labelFirstPrice.frame = CGRectMake(SCREEN_WIDTH - 15 - sizeFirstPrice.width, _imageTimeLine.frame.origin.y+18+4, sizeFirstPrice.width, 16);
    _labelFirst.frame = CGRectMake(_labelFirstPrice.frame.origin.x - 2 - 100, _imageTimeLine.frame.origin.y+18+7, 100, 13);
    
    CGSize sizeSecondPrice = [Tool boundingRectWithSize:_labelSecondPrice.text textFont:MKFONT(12) textSize:CGSizeMake(MAXFLOAT, 12)];
    _labelSecondPrice.frame = CGRectMake(SCREEN_WIDTH - 15 - sizeSecondPrice.width, _labelEndTime.frame.origin.y, sizeSecondPrice.width, 12);
    _labelSecond.frame = CGRectMake(_labelSecondPrice.frame.origin.x - 2 - 100, _labelEndTime.frame.origin.y, 100, 12);
    
    if (isLastCell)
    {
        _imageLastPic.image = [UIImage imageNamed:@"img_showTime_ending.png"];
        _imageLastPic.frame = CGRectMake(15, _imageTimeLine.frame.origin.y+_imageTimeLine.frame.size.height+10, 28/2, 28/2);
    }
}

@end
