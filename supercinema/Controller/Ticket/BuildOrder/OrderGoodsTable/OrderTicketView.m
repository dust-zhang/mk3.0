//
//  OrderTicketView.m
//  supercinema
//
//  Created by Mapollo28 on 2016/12/16.
//
//

#import "OrderTicketView.h"

@implementation OrderTicketView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    //白色背景
    _backView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 100)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 2;
    _backView.layer.borderWidth = 0.5;
    _backView.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];
    [self addSubview:_backView];
    
    //logo
    _imageLogo = [[UIImageView alloc]initWithFrame:CGRectZero];
    _imageLogo.backgroundColor = [UIColor redColor];
    [_backView addSubview:_imageLogo];
    
    //电影名（卖品名）
    _labelName = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelName.font = MKBOLDFONT(15);
    _labelName.backgroundColor = [UIColor clearColor];
    _labelName.textColor = RGBA(51, 51, 51, 1);
    [_backView addSubview:_labelName];
    
    //日期（卖品详细）
    _labelDetail = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelDetail.font = MKFONT(12);
    _labelDetail.backgroundColor = [UIColor clearColor];
    _labelDetail.textColor = RGBA(51, 51, 51, 1);
    [_backView addSubview:_labelDetail];
    
    //座位
    _viewTicket = [[UIView alloc]initWithFrame:CGRectZero];
    _viewTicket.backgroundColor = [UIColor clearColor];
    [_backView addSubview:_viewTicket];
    
    //座位数（卖品数）
    _labelCount = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelCount.font = MKFONT(12);
    _labelCount.backgroundColor = [UIColor clearColor];
    _labelCount.textColor = RGBA(51, 51, 51, 1);
    [_backView addSubview:_labelCount];
    
    //分割线
    _viewLine = [[UIImageView alloc]initWithFrame:CGRectZero];
    _viewLine.image = [UIImage imageNamed:@"image_dottedLine.png"];
    [_backView addSubview:_viewLine];
    
    //服务费（卖品有效期）
    _labelService = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelService.font = MKFONT(10);
    _labelService.backgroundColor = [UIColor clearColor];
    _labelService.textColor = RGBA(123, 122, 152, 1);
    [_backView addSubview:_labelService];
    
    //小计
    _labelSum = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelSum.font = MKFONT(12);
    _labelSum.backgroundColor = [UIColor clearColor];
    _labelSum.textColor = RGBA(123, 122, 152, 1);
    [_backView addSubview:_labelSum];
    
    //小计价格
    _labelSumPrice = [[UILabel alloc]initWithFrame:CGRectZero];
    _labelSumPrice.font = MKFONT(17);
    _labelSumPrice.backgroundColor = [UIColor clearColor];
    _labelSumPrice.textColor = RGBA(249, 81, 81, 1);
    [_backView addSubview:_labelSumPrice];
    
    return self;
}

-(void)setData:(BuildOrderModel *)orderModel
{
    //票订单
    [Tool downloadImage:orderModel.strImgFilm button:nil imageView:_imageLogo defaultImage:@"img_ticketMovie_default.png"];
//    [_imageLogo sd_setImageWithURL:[NSURL URLWithString:orderModel.strImgFilm] placeholderImage:[UIImage imageNamed:@"img_ticketMovie_default.png"]];
    _labelName.text = orderModel.strFilmName;
    NSString* strDate = [Tool returnTime:orderModel.strTime format:@"MM月dd日 HH:mm"];
    _labelDetail.text = [NSString stringWithFormat:@"%@ %@  (%@)",[Tool getShowTimeDate:orderModel.strTime endTime:orderModel.currentDate],strDate,orderModel.strHall];
    _arrSeat = [NSArray arrayWithArray:orderModel.arrSeats];
    _labelCount.text = [NSString stringWithFormat:@"%lu张",(unsigned long)orderModel.arrSeats.count];
    
    if ([orderModel.strServicePrice floatValue] != 0)
    {
        _labelService.text = [NSString stringWithFormat:@"含服务费%@元/张",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:[orderModel.strServicePrice floatValue]]]];
    }
    else
    {
        _labelService.text = @"";
    }
    
    _labelSum.text = @"电影票小计：";
    _labelSumPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:[NSNumber numberWithFloat:[orderModel.strTotalPrice floatValue]]]];
}

-(void)layoutFrame
{
    //票订单
    _imageLogo.frame = CGRectMake(15, 30, 135/2, 180/2);
    _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, _imageLogo.frame.origin.y, SCREEN_WIDTH-15*5-135/2, 15);
    _labelDetail.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+15, 200, 12);
    _viewTicket.frame = CGRectMake(_labelName.frame.origin.x, _labelDetail.frame.origin.y+_labelDetail.frame.size.height+10, SCREEN_WIDTH-15*5-135/2, 12);
    for (UIView* vV in _viewTicket.subviews)
    {
        [vV removeFromSuperview];
    }
    for (int i =0; i<_arrSeat.count; i++)
    {
        _labelTicket[i] = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelTicket[i].font = MKFONT(12);
        _labelTicket[i].textColor = RGBA(51, 51, 51, 1);
        
        NSString* strTicket = _arrSeat[i];
        CGFloat widthTicket = [Tool calStrWidth:strTicket height:12];
        _labelTicket[i].text = strTicket;
        if (i == 0)
        {
            _labelTicket[i].frame = CGRectMake(0, 0, widthTicket, 12);
        }
        else
        {
            _labelTicket[i].frame = CGRectMake(_labelTicket[i-1].frame.origin.x+_labelTicket[i-1].frame.size.width+10, 0, widthTicket, 12);
        }
        if (i == 3 && SCREEN_WIDTH == 320)
        {
            //iphone5第四个座换行显示
            _viewTicket.frame = CGRectMake(_viewTicket.frame.origin.x, _viewTicket.frame.origin.y, _viewTicket.frame.size.height, 12+10+12);
            _labelTicket[i].frame = CGRectMake(0, 12+10, widthTicket, 12);
        }
        [_viewTicket addSubview:_labelTicket[i]];
    }
    _labelCount.frame = CGRectMake(_labelName.frame.origin.x, _imageLogo.frame.origin.y+_imageLogo.frame.size.height-12, 50, 12);
    if (_arrSeat.count == 4 && SCREEN_WIDTH == 320)
    {
        _labelCount.frame = CGRectMake(_labelName.frame.origin.x, _viewTicket.frame.origin.y+_viewTicket.frame.size.height+10, 50, 12);
    }
    _viewLine.frame = CGRectMake(15, _labelCount.frame.origin.y+_labelCount.frame.size.height+15, SCREEN_WIDTH-60, 0.5);
    _labelService.frame = CGRectMake(15, _viewLine.frame.origin.y+24/2, 250, 10);
    CGFloat widthPrice = [Tool calStrWidth:_labelSumPrice.text height:17];
    _labelSumPrice.frame = CGRectMake(SCREEN_WIDTH-45-widthPrice, _viewLine.frame.origin.y+5, widthPrice, 17);
    CGFloat widthSum = [Tool calStrWidth:_labelSum.text height:12];
    _labelSum.frame = CGRectMake(_labelSumPrice.frame.origin.x-widthSum, _viewLine.frame.origin.y+10, widthSum, 12);
    _backView.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, _labelSum.frame.origin.y+_labelSum.frame.size.height+10);
}

@end
