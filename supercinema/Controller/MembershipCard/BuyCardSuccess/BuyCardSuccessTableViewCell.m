//
//  BuyCardSuccessTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 16/11/16.
//
//

#import "BuyCardSuccessTableViewCell.h"

@implementation BuyCardSuccessTableViewCell

//初始化控件
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //背景
        _viewBasicInformationBG = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewBasicInformationBG setBackgroundColor:RGBA(255, 255, 255, 1)];
        _viewBasicInformationBG.layer.borderWidth = 0.5;//边框宽度
        _viewBasicInformationBG.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];//边框颜色
        _viewBasicInformationBG.layer.cornerRadius = 2.f;//圆角
        [self addSubview:_viewBasicInformationBG];

        _imageCardLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageCardLogo setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_imageCardLogo];
        
        //卡名称
        _labelCardName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelCardName setBackgroundColor:[UIColor clearColor]];
        [_labelCardName setFont:MKBOLDFONT(15)];
        [_labelCardName setTextColor:RGBA(51, 51, 51, 1)];
        [_labelCardName setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_labelCardName];
        
        //影院名称
        _labelCinemaName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelCinemaName setBackgroundColor:[UIColor clearColor]];
        [_labelCinemaName setFont:MKFONT(12)];
        [_labelCinemaName setTextColor:RGBA(51, 51, 51, 1)];
        _labelCinemaName.numberOfLines = 0;
        _labelCinemaName.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_labelCinemaName];
        
        //有效期
        _labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDate setBackgroundColor:[UIColor clearColor]];
        [_labelDate setFont:MKFONT(10)];
        [_labelDate setTextColor:RGBA(123, 122, 152, 1)];
        [_labelDate setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_labelDate];

        _imageLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageLine setBackgroundColor:[UIColor clearColor]];
        [_imageLine setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
        [self addSubview:_imageLine];
        
        //截至有效期
        _labelDateUpTo = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDateUpTo setBackgroundColor:[UIColor clearColor]];
        [_labelDateUpTo setFont:MKFONT(10)];
        [_labelDateUpTo setTextColor:RGBA(123, 122, 152, 1)];
        [_labelDateUpTo setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_labelDateUpTo];
        
        //小计：金额
        _labelSubtotal = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelSubtotal setBackgroundColor:[UIColor clearColor]];
        [_labelSubtotal setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_labelSubtotal];
        
        _viewDetailsBG = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewDetailsBG setBackgroundColor:RGBA(255, 255, 255, 1)];
        _viewDetailsBG.layer.borderWidth = 0.5;//边框宽度
        _viewDetailsBG.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];//边框颜色
        _viewDetailsBG.layer.cornerRadius = 2.f;//圆角
        [self addSubview:_viewDetailsBG];
        
        //实付金额
        _labelReal = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelReal setBackgroundColor:[UIColor clearColor]];
        [_labelReal setFont:MKFONT(12)];
        [_labelReal setTextColor:RGBA(123, 122, 152, 1)];
        [_labelReal setTextAlignment:NSTextAlignmentLeft];
        [_labelReal setText:@"实付金额："];
        [self addSubview:_labelReal];
        
        _labelRealPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelRealPrice setBackgroundColor:[UIColor clearColor]];
        [_labelRealPrice setFont:MKFONT(17)];
        [_labelRealPrice setTextColor:RGBA(248, 37, 37, 1)];
        [_labelRealPrice setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_labelRealPrice];
        
        //分割线
        _labelLine = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelLine setBackgroundColor:RGBA(242, 242, 242, 1)];
        [self addSubview:_labelLine];
        
        //合计金额
        _labelSum = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelSum setBackgroundColor:[UIColor clearColor]];
        [_labelSum setFont:MKFONT(11)];
        [_labelSum setTextColor:RGBA(123, 122, 152, 1)];
        [_labelSum setTextAlignment:NSTextAlignmentLeft];
        [_labelSum setText:@"合计金额："];
        [self addSubview:_labelSum];
        
        _labelSumPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelSumPrice setBackgroundColor:[UIColor clearColor]];
        [_labelSumPrice setFont:MKFONT(11)];
        [_labelSumPrice setTextColor:RGBA(51, 51, 51, 1)];
        [_labelSumPrice setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_labelSumPrice];
        
        
        //抵扣金额
        _labelDicount = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDicount setBackgroundColor:[UIColor clearColor]];
        [_labelDicount setFont:MKFONT(11)];
        [_labelDicount setTextColor:RGBA(123, 122, 152, 1)];
        [_labelDicount setTextAlignment:NSTextAlignmentLeft];
        [_labelDicount setText:@"抵扣金额："];
        [self addSubview:_labelDicount];
    
        _labelDicountPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDicountPrice setBackgroundColor:[UIColor clearColor]];
        [_labelDicountPrice setFont:MKFONT(11)];
        [_labelDicountPrice setTextColor:RGBA(51, 51, 51, 1)];
        [_labelDicountPrice setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_labelDicountPrice];
    }
    
    return self;
}

#pragma mark - 购买成功详情Cell
-(void)setBuyCardSuccessDetailsCellFrameData:(CardOrderModel *)orderModel
{
    _imageCardLogo.frame = CGRectMake(15*2, 10+30, 27, 27);
    /**
     *  卡类型   普通:-1
     *          常规:0
     *          次卡:1
     *          套票:2
     *          任看:3
     *          通票:4
     */
    if (
        [orderModel.cardType intValue] == -1 ||
        [orderModel.cardType intValue]== 0   ||
        [orderModel.cardType intValue]== 1   )
    {
        //卡类型Logo
        [_imageCardLogo setImage:[UIImage imageNamed:@"image_membershipCard.png"]];
    }
    else
    {
        //票类型Logo
        [_imageCardLogo setImage:[UIImage imageNamed:@"image_ticketType.png"]];
    }
    
    float fCardNameWidth = (SCREEN_WIDTH-15*2)-15-_imageCardLogo.frame.size.width-15-15;
    //卡名称
    _labelCardName.frame = CGRectMake(_imageCardLogo.frame.origin.x+_imageCardLogo.frame.size.width+15, _imageCardLogo.frame.origin.y, fCardNameWidth, 15);
    [_labelCardName setText:orderModel.cardName];
    
    //影院名称
    _labelCinemaName.frame = CGRectMake(_labelCardName.frame.origin.x, _labelCardName.frame.origin.y+_labelCardName.frame.size.height+10, _labelCardName.frame.size.width, 12);
    [_labelCinemaName setText:orderModel.cinemaName];
    [Tool setLabelSpacing: _labelCinemaName spacing:2 alignment:NSTextAlignmentLeft];
    _labelCinemaName.frame = CGRectMake(_labelCardName.frame.origin.x, _labelCardName.frame.origin.y+_labelCardName.frame.size.height+10, _labelCardName.frame.size.width, _labelCinemaName.frame.size.height);
    
    //有效期
    _labelDate.frame = CGRectMake(_labelCinemaName.frame.origin.x, _labelCinemaName.frame.origin.y+_labelCinemaName.frame.size.height+15, _labelCinemaName.frame.size.width, 10);
    [_labelDate setText:[NSString stringWithFormat:@"有效期：%@天",orderModel.activeTime]];

    _imageLine.frame = CGRectMake(_imageCardLogo.frame.origin.x, _labelDate.frame.origin.y+_labelDate.frame.size.height+10, SCREEN_WIDTH-15*4, 0.5);
    
    _labelDateUpTo.frame = CGRectMake(_imageCardLogo.frame.origin.x,  _imageLine.frame.origin.y+_imageLine.frame.size.height+13, _imageLine.frame.size.width, 10);
    [_labelDateUpTo setText:[NSString stringWithFormat:@"有效期至：%@",[Tool returnTime:orderModel.validEndTime format:@"yyyy年MM月dd日"]]];
    
    //小计：金（没有使用折扣）
    _labelSubtotal.frame = CGRectMake(_imageLine.frame.origin.x, _imageLine.frame.origin.y+_imageLine.frame.size.height+10, _imageLine.frame.size.width, 15);
    NSString *str = [NSString stringWithFormat:@"小计：￥%@",[Tool PreserveTowDecimals:self._modelOrderInfo.notDiscountTotalPrice]];
    NSUInteger joinCount =[[NSString stringWithFormat:@"%@", [Tool PreserveTowDecimals:self._modelOrderInfo.notDiscountTotalPrice]] length];
    //算出range的位置
    NSRange oneRange =NSMakeRange(0,3);
    NSRange twoRange =NSMakeRange(3,joinCount+1);
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
    //设置字号 & 颜色
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(11) range:oneRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(15) range:twoRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(123, 122, 152, 1) range:oneRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(246, 81, 81, 1) range:twoRange];
    [_labelSubtotal setAttributedText:strAtt];
    
    _viewBasicInformationBG.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, _labelSubtotal.frame.origin.y + _labelSubtotal.frame.size.height);
    
/**********************/
    //实付金额
    _labelReal.frame = CGRectMake(15*2, _viewBasicInformationBG.frame.origin.y+_viewBasicInformationBG.frame.size.height+10+15, SCREEN_WIDTH/2, 12);
    _labelRealPrice.frame = CGRectMake(SCREEN_WIDTH/2-15*2, _labelReal.frame.origin.y-2, SCREEN_WIDTH/2, 17);
    [_labelRealPrice setText:[NSString stringWithFormat:@"￥%@",[Tool PreserveTowDecimals:self._modelOrderInfo.totalPrice]]];
    
    _labelLine.frame = CGRectMake(15, _labelReal.frame.origin.y+_labelReal.frame.size.height+16, SCREEN_WIDTH-15*2, 0.5);
    
    //合计金额
    _labelSum.frame = CGRectMake(_labelReal.frame.origin.x, _labelLine.frame.origin.y+_labelLine.frame.size.height+15, SCREEN_WIDTH-15*2, 12);
    _labelSumPrice.frame = CGRectMake(SCREEN_WIDTH/2-15*2, _labelSum.frame.origin.y-2, SCREEN_WIDTH/2, 15);
    
    if ([self._modelOrderInfo.totalPrice intValue] == 0)
    {
        [_labelSumPrice setText:@"￥0"];
    }
    else
    {
        [_labelSumPrice setText:[NSString stringWithFormat:@"￥%@",[Tool PreserveTowDecimals:self._modelOrderInfo.totalPrice]]];
    }
    
    //抵扣金额
    _labelDicount.frame = CGRectMake(_labelReal.frame.origin.x, _labelSum.frame.origin.y+_labelSum.frame.size.height+10, SCREEN_WIDTH-15*2, 12);
    _labelDicountPrice.frame = CGRectMake(SCREEN_WIDTH/2-15*2, _labelDicount.frame.origin.y-2, SCREEN_WIDTH/2, 15);
    
    if ([self._modelOrderInfo.discountPrice intValue] == 0)
    {
        [_labelDicountPrice setText:@"￥0"];
    }
    else
    {
        [_labelDicountPrice setText:[NSString stringWithFormat:@"-￥%@",[Tool PreserveTowDecimals:self._modelOrderInfo.discountPrice]]];
    }
    
    //背景
    _viewDetailsBG.frame = CGRectMake(15, _viewBasicInformationBG.frame.origin.y+_viewBasicInformationBG.frame.size.height+10, SCREEN_WIDTH-15*2, 15+_labelReal.frame.size.height +15+_labelLine.frame.size.height+30+_labelSum.frame.size.height+_labelDicount.frame.size.height+12);
    
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width,_viewDetailsBG.frame.origin.y+_viewDetailsBG.frame.size.height);
}


@end
