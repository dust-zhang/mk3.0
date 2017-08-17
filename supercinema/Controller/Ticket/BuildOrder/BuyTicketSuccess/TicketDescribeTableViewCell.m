//
//  TicketDescribeTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 19/11/16.
//
//

#import "TicketDescribeTableViewCell.h"

@implementation TicketDescribeTableViewCell

//初始化控件
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //背景
        _viewInformationBG = [[UIView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-15*2, 118)];
        [_viewInformationBG setBackgroundColor:RGBA(255, 255, 255, 1)];
        _viewInformationBG.layer.borderWidth = 0.5;//边框宽度
        _viewInformationBG.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];//边框颜色
        _viewInformationBG.layer.cornerRadius = 2.f;//圆角
        [self.contentView addSubview:_viewInformationBG];
        
        //序列号
        _labelNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, _viewInformationBG.frame.size.width, 14)];
        [_labelNumber setBackgroundColor:[UIColor clearColor]];
        [_labelNumber setFont:MKFONT(14)];
        [_labelNumber setTextColor:RGBA(117, 112, 255, 1)];
        [_labelNumber setTextAlignment:NSTextAlignmentCenter];
        _labelNumber.numberOfLines = 0;
        _labelNumber.lineBreakMode = NSLineBreakByCharWrapping;
        _labelNumber.hidden = YES;
        [_viewInformationBG addSubview:_labelNumber];
        
        //验证码
        _labelCode = [[UILabel alloc] initWithFrame:CGRectMake(_labelNumber.frame.origin.x, _labelNumber.frame.origin.y+_labelNumber.frame.size.height+4, _labelNumber.frame.size.width, _labelNumber.frame.size.height)];
        [_labelCode setBackgroundColor:[UIColor clearColor]];
        [_labelCode setFont:MKFONT(14)];
        [_labelCode setTextColor:RGBA(117, 112, 255, 1)];
        [_labelCode setTextAlignment:NSTextAlignmentCenter];
        _labelCode.numberOfLines = 0;
        _labelCode.lineBreakMode = NSLineBreakByCharWrapping;
        _labelCode.hidden = YES;
        [_viewInformationBG addSubview:_labelCode];
        
        //取票说明
        _labelExchangeInfo = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelExchangeInfo setBackgroundColor:[UIColor clearColor]];
        [_labelExchangeInfo setFont:MKFONT(11)];
        [_labelExchangeInfo setTextColor:RGBA(123, 122, 152, 1)];
        [_labelExchangeInfo setTextAlignment:NSTextAlignmentCenter];
        [_viewInformationBG addSubview:_labelExchangeInfo];
        
        //退款状态
        _labelReimburseType = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelReimburseType setBackgroundColor:[UIColor clearColor]];
        [_labelReimburseType setFont:MKFONT(15)];
        [_labelReimburseType setTextColor:RGBA(51, 51, 51, 1)];
        [_labelReimburseType setTextAlignment:NSTextAlignmentCenter];
        [_viewInformationBG addSubview:_labelReimburseType];
        
        //客服时间
        _labelServicePhone = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelServicePhone setBackgroundColor:[UIColor clearColor]];
        [_labelServicePhone setFont:MKFONT(11)];
        [_labelServicePhone setTextColor:RGBA(123, 122, 152, 1)];
        [_labelServicePhone setTextAlignment:NSTextAlignmentCenter];
        [_viewInformationBG addSubview:_labelServicePhone];
    
        _imageLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageLogo setBackgroundColor:[UIColor clearColor]];
        [_viewInformationBG addSubview:_imageLogo];
        
        _labelName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelName setBackgroundColor:[UIColor clearColor]];
        [_labelName setFont:MKFONT(16)];
        [_labelName setTextColor:RGBA(51, 51, 51, 1)];
        [_labelName setTextAlignment:NSTextAlignmentLeft];
        [_viewInformationBG addSubview:_labelName];
        
        //电影类型
        _labelMovieTpye = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelMovieTpye setBackgroundColor:[UIColor clearColor]];
        [_labelMovieTpye setFont:MKFONT(9)];
        [_labelMovieTpye setTextColor:RGBA(51, 51, 51, 1)];
        [_labelMovieTpye setTextAlignment:NSTextAlignmentLeft];
        [_viewInformationBG addSubview:_labelMovieTpye];
        
        //描述
        _labelDetail = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDetail setBackgroundColor:[UIColor clearColor]];
        [_labelDetail setFont:MKFONT(12)];
        [_labelDetail setTextColor:RGBA(51, 51, 51, 1)];
        [_labelDetail setTextAlignment:NSTextAlignmentLeft];
        [_viewInformationBG addSubview:_labelDetail];
        
        //座位
        _viewTicket = [[UIView alloc]initWithFrame:CGRectZero];
        _viewTicket.backgroundColor = [UIColor clearColor];
        [_viewInformationBG addSubview:_viewTicket];
        
        //数量
        _labelCount =[[UILabel alloc] initWithFrame:CGRectZero];
        [_labelCount setBackgroundColor:[UIColor clearColor]];
        [_labelCount setFont:MKFONT(12)];
        [_labelCount setTextColor:RGBA(51, 51, 51, 1)];
        [_viewInformationBG addSubview:_labelCount];
        
        //服务费
        _labelFee = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelFee setBackgroundColor:[UIColor clearColor]];
        [_labelFee setFont:MKFONT(10)];
        [_labelFee setTextColor:RGBA(123, 122, 152, 1)];
        [_labelFee setTextAlignment:NSTextAlignmentLeft];
        [_viewInformationBG addSubview:_labelFee];
        
        //分割线
        _imageLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageLine setBackgroundColor:[UIColor clearColor]];
        [_viewInformationBG addSubview:_imageLine];
    }
    return self;
}

#pragma mark - 票Cell
-(void)setTicketDescribeCellFrameData:(OnlineTicketsModel *)model orderWhileModel:(OrderWhileModel *)orderWhileModel
{
    NSLog(@"%@",[model toJSONString]);
    
//    orderWhileModel = [[OrderWhileModel alloc] init];
//    orderWhileModel.payStatus = [NSNumber numberWithInt:1];
//    orderWhileModel.orderStatus = [NSNumber numberWithInt:20];

    //序列号；验证码
    _labelNumber.text = model.ticketKey;
    NSArray *array = [Tool cutOrderAndTicket:model.ticketKey];
    
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    [array addObject:@"订单号:8192 8192 8192 8192"];
//    [array addObject:@"验证码:453893"];
    
    if ([orderWhileModel.orderStatus intValue ] == 30)
    {
        //30出票成功；显示：订单号 验证码
        if (array.count == 1)
        {
            _labelNumber.hidden = NO;
            _labelNumber.text = array[0];
            _labelNumber.frame = CGRectMake(0, 15, _viewInformationBG.frame.size.width, 14);
            
            _labelExchangeInfo.frame = CGRectMake(0, _labelNumber.frame.origin.y + _labelNumber.frame.size.height + 10, _viewInformationBG.frame.size.width, 11);
            _labelExchangeInfo.text = model.exchangeInfo;
            
            _imageLine.frame = CGRectMake(0, _labelExchangeInfo.frame.origin.y+_labelExchangeInfo.frame.size.height+15, SCREEN_WIDTH-15*2, 5);
        }
        else if (array.count == 2)
        {
            _labelNumber.hidden = NO;
            _labelCode.hidden = NO;
            _labelNumber.text = array[0];
            _labelNumber.frame = CGRectMake(0, 15, _viewInformationBG.frame.size.width, 14);
            
            _labelCode.text = array[1];
            _labelCode.frame = CGRectMake(0, _labelNumber.frame.origin.y + _labelNumber.frame.size.height + 4, _viewInformationBG.frame.size.width, 14);
            
            _labelExchangeInfo.frame = CGRectMake(0, _labelCode.frame.origin.y + _labelCode.frame.size.height + 10, _viewInformationBG.frame.size.width, 11);
            _labelExchangeInfo.text = model.exchangeInfo;
            
            _imageLine.frame = CGRectMake(0, _labelExchangeInfo.frame.origin.y+_labelExchangeInfo.frame.size.height+15, SCREEN_WIDTH-15*2, 5);
        }
    }
    else if ([orderWhileModel.orderStatus intValue ] == 20  ||
             [orderWhileModel.orderStatus intValue ] == 40  ||
             [orderWhileModel.orderStatus intValue ] == 100 ||
             [orderWhileModel.orderStatus intValue ] == 110 )
    {
        //20出票失败；显示：正在退款
        _labelReimburseType.frame = CGRectMake((_viewInformationBG.frame.size.width-140)/2, 15, 140, 15);
        _labelReimburseType.text = @"正在退款";
        
        _labelServicePhone.frame = CGRectMake(0, _labelReimburseType.frame.origin.y+_labelReimburseType.frame.size.height+10, _viewInformationBG.frame.size.width, 11);
        _labelServicePhone.text = [NSString stringWithFormat:@"客服工作时间 %@",[Config getConfigInfo:@"movikrPhoneNumberDesc"]];
        
        _imageLine.frame = CGRectMake(0, _labelServicePhone.frame.origin.y+_labelServicePhone.frame.size.height+15, SCREEN_WIDTH-15*2, 5);
        
    }
    else
    {
        //默认显示 正在出票
        _labelReimburseType.frame = CGRectMake((_viewInformationBG.frame.size.width-140)/2, 15, 140, 15);
        _labelReimburseType.text = @"正在出票";
        
        _labelServicePhone.frame = CGRectMake(0, _labelReimburseType.frame.origin.y+_labelReimburseType.frame.size.height+10, _viewInformationBG.frame.size.width, 11);
        _labelServicePhone.text = @"出票结果，请稍后查看";
        
        _imageLine.frame = CGRectMake(0, _labelServicePhone.frame.origin.y+_labelServicePhone.frame.size.height+15, SCREEN_WIDTH-15*2, 5);
    }
    
    [_imageLine setImage:[UIImage imageNamed:@"image_holeLine.png"]];
    
    //影片Logo
    _imageLogo.frame = CGRectMake(15, _imageLine.frame.origin.y+_imageLine.frame.size.height+25, 135/2, 180/2);
    //判断图片是不是下载过，如果缓存中有，那么就不下载，直接用缓存的
    [Tool downloadImage:model.movie.movieLogoUrl button:nil imageView:_imageLogo defaultImage:@"img_homelogo_small_default.png"];
//    [_imageLogo sd_setImageWithURL:[NSURL URLWithString:model.movie.movieLogoUrl] placeholderImage:[UIImage imageNamed:@"img_homelogo_small_default.png"]];
    
    //影片名称
    _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, _imageLogo.frame.origin.y, _viewInformationBG.frame.size.width-15-_imageLogo.frame.size.width-15-15, 16);
    [_labelName setText:model.movie.movieTitle];
  
    //电影类型
    _labelMovieTpye.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+7, _labelName.frame.size.width, 9);
    _labelMovieTpye.text = [NSString stringWithFormat:@"%@ %@",model.showtime.language,model.showtime.versionDesc];
    
    //有效期描述
    _labelDetail.frame = CGRectMake(_labelName.frame.origin.x, _labelMovieTpye.frame.origin.y+_labelMovieTpye.frame.size.height+10, _labelName.frame.size.width, 12);
    
    NSString* strDate = [Tool returnTime:model.showtime.startPlayTime format:@"MM月dd日"];
    NSString* strWeek = [Tool returnWeek:model.showtime.startPlayTime];
    NSString* strTime = [Tool returnTime:model.showtime.startPlayTime format:@"HH:mm"];
    _labelDetail.text = [NSString stringWithFormat:@"%@ %@ %@ (%@)",strDate,strWeek,strTime,model.hall.hallName];
    
    //座位
    _viewTicket.frame = CGRectMake(_labelName.frame.origin.x, _labelDetail.frame.origin.y+_labelDetail.frame.size.height+8, SCREEN_WIDTH-15*5-135/2, 12);
    _arrSeat = [NSArray arrayWithArray:model.seateNames];
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
    
    //数量
    _labelCount.frame = CGRectMake(_labelName.frame.origin.x-2, _imageLogo.frame.origin.y+_imageLogo.frame.size.height-12, 50, 12);
    if (_arrSeat.count == 4 && SCREEN_WIDTH == 320)
    {
        _labelCount.frame = CGRectMake(_labelName.frame.origin.x, _viewTicket.frame.origin.y+_viewTicket.frame.size.height+10, 50, 12);
    }
    _labelCount.text = [NSString stringWithFormat:@"￥%@(%ld张)",[Tool PreserveTowDecimals:model.totalPrice],(unsigned long)_arrSeat.count];
    [Tool setLabelSpacing:_labelCount spacing:2 alignment:NSTextAlignmentLeft];
    
    _labelFee.frame = CGRectMake(_labelCount.frame.origin.x+_labelCount.frame.size.width+5, _labelCount.frame.origin.y+2, 100, 10);
    if ([model.serviceFee floatValue] != 0)
    {
        _labelFee.text = [NSString stringWithFormat:@"含服务费%@元/张",[Tool PreserveTowDecimals:model.serviceFee]];
    }
    else
    {
        _labelFee.text = @"";
    }
    
    //背景
    _viewInformationBG.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, _labelCount.frame.origin.y+_labelCount.frame.size.height+30);
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width,_labelCount.frame.origin.y+_labelCount.frame.size.height+10+30);
}




@end
