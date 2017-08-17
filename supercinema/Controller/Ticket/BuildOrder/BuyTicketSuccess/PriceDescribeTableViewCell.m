//
//  PriceDescribeTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 19/11/16.
//
//

#import "PriceDescribeTableViewCell.h"

@implementation PriceDescribeTableViewCell
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
        
        //实付金额
        _labelReal = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelReal setBackgroundColor:[UIColor clearColor]];
        [_labelReal setFont:MKFONT(12)];
        [_labelReal setTextColor:RGBA(123, 122, 152, 1)];
        [_labelReal setTextAlignment:NSTextAlignmentLeft];
        [_labelReal setText:@"实付金额："];
        [_viewInformationBG addSubview:_labelReal];
        
        _labelRealPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelRealPrice setBackgroundColor:[UIColor clearColor]];
        [_labelRealPrice setFont:MKFONT(17)];
        [_labelRealPrice setTextColor:RGBA(249, 81, 81, 1)];
        [_labelRealPrice setTextAlignment:NSTextAlignmentRight];
        [_viewInformationBG addSubview:_labelRealPrice];
        
        _labelLine = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelLine setBackgroundColor:RGBA(242, 242, 242, 1)];
        [_viewInformationBG addSubview:_labelLine];
        
        //合计金额
        _labelSum = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelSum setBackgroundColor:[UIColor clearColor]];
        [_labelSum setFont:MKFONT(12)];
        [_labelSum setTextColor:RGBA(123, 122, 152, 1)];
        [_labelSum setTextAlignment:NSTextAlignmentLeft];
        [_labelSum setText:@"合计金额："];
        [_viewInformationBG addSubview:_labelSum];
        
        _labelSumPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelSumPrice setBackgroundColor:[UIColor clearColor]];
        [_labelSumPrice setFont:MKFONT(15)];
        [_labelSumPrice setTextColor:RGBA(51, 51, 51, 1)];
        [_labelSumPrice setTextAlignment:NSTextAlignmentRight];
        [_viewInformationBG addSubview:_labelSumPrice];
        
        //抵扣金额
        _labelDicount = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDicount setBackgroundColor:[UIColor clearColor]];
        [_labelDicount setFont:MKFONT(12)];
        [_labelDicount setTextColor:RGBA(123, 122, 152, 1)];
        [_labelDicount setTextAlignment:NSTextAlignmentLeft];
        [_labelDicount setText:@"抵扣金额："];
        [_viewInformationBG addSubview:_labelDicount];
        
        _labelDicountPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDicountPrice setBackgroundColor:[UIColor clearColor]];
        [_labelDicountPrice setFont:MKFONT(15)];
        [_labelDicountPrice setTextColor:RGBA(51, 51, 51, 1)];
        [_labelDicountPrice setTextAlignment:NSTextAlignmentRight];
        [_viewInformationBG addSubview:_labelDicountPrice];
    }
    return self;
}

#pragma mark - 金额Cell
-(void)setPriceDescribeCellFrameData:(OrderInfoModel *)model
{
    //实付金额
    _labelReal.frame = CGRectMake(15, 20, SCREEN_WIDTH/2, 12);
    _labelRealPrice.frame = CGRectMake(SCREEN_WIDTH/2-15, 15, SCREEN_WIDTH/2-15*2, 17);
    [_labelRealPrice setText:[NSString stringWithFormat:@"￥%@",[Tool PreserveTowDecimals:model.totalPrice]]];
    
    _labelLine.frame = CGRectMake(0, _labelReal.frame.origin.y+_labelReal.frame.size.height+15, SCREEN_WIDTH-15*2, 0.5);
    
    //合计金额
    _labelSum.frame = CGRectMake(15, _labelLine.frame.origin.y+_labelLine.frame.size.height+15, SCREEN_WIDTH/2, 12);
    _labelSumPrice.frame = CGRectMake(SCREEN_WIDTH/2-15, _labelSum.frame.origin.y-2, SCREEN_WIDTH/2-15*2, 15);
    [_labelSumPrice setText:[NSString stringWithFormat:@"￥%@",[Tool PreserveTowDecimals:model.notDiscountTotalPrice]]];

    //抵扣金额
    _labelDicount.frame = CGRectMake(15, _labelSum.frame.origin.y+_labelSum.frame.size.height+15, SCREEN_WIDTH/2, 12);
    _labelDicountPrice.frame = CGRectMake(SCREEN_WIDTH/2-15, _labelDicount.frame.origin.y-2, SCREEN_WIDTH/2-15*2, 15);
    if ([model.discountPrice intValue] == 0)
    {
        [_labelDicountPrice setText:@"￥0"];
    }
    else
    {
        [_labelDicountPrice setText:[NSString stringWithFormat:@"-￥%@",[Tool PreserveTowDecimals:model.discountPrice]]];
    }
    
    //背景
    _viewInformationBG.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, _labelDicount.frame.origin.y+_labelDicount.frame.size.height+15);
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width,_labelDicount.frame.origin.y+_labelDicount.frame.size.height+10+15+10);

}

@end
