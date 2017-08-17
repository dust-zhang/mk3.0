//
//  OrderDiscountTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/12.
//
//

#import "OrderDiscountTableViewCell.h"

@implementation OrderDiscountTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //logo
        _imageLogo = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_imageLogo];
        
        //卡名（红包名）
        _labelName = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelName.font = MKFONT(15);
        _labelName.backgroundColor = [UIColor clearColor];
        _labelName.textColor = RGBA(51, 51, 51, 1);
        [self.contentView addSubview:_labelName];
        
        //剩余label
        _labelLeft = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelLeft.font = MKFONT(12);
        _labelLeft.backgroundColor = [UIColor clearColor];
        _labelLeft.textColor = RGBA(51, 51, 51, 1);
        [self.contentView addSubview:_labelLeft];
        
        //剩余次数
        _labelLeftCount = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelLeftCount.font = MKFONT(15);
        _labelLeftCount.backgroundColor = [UIColor clearColor];
        _labelLeftCount.textColor = RGBA(249, 81, 81, 1);
        [self.contentView addSubview:_labelLeftCount];
        
        //截止日期
        _labelEndDate = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelEndDate.font = MKFONT(11);
        _labelEndDate.backgroundColor = [UIColor clearColor];
        _labelEndDate.textColor = RGBA(123, 122, 152, 1);
        [self.contentView addSubview:_labelEndDate];

        //详情
        _labelDetail = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelDetail.font = MKFONT(12);
        _labelDetail.backgroundColor = [UIColor clearColor];
        _labelDetail.textColor = RGBA(51, 51, 51, 1);
        [self.contentView addSubview:_labelDetail];
        
        //卖品数
        _labelSaleCount = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelSaleCount.font = MKFONT(14);
        _labelSaleCount.backgroundColor = [UIColor clearColor];
        _labelSaleCount.textColor = RGBA(50, 50, 50, 1);
        [self.contentView addSubview:_labelSaleCount];
        
        //加
        _btnPlus = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlus.frame = CGRectZero;
        [_btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
        _btnPlus.backgroundColor = [UIColor clearColor];
        _btnPlus.tag = 0;
        [_btnPlus addTarget:self action:@selector(onButtonCount:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnPlus];
        
        //减
        _btnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMinus.frame = CGRectZero;
        _btnMinus.tag = 1;
        _btnMinus.backgroundColor = [UIColor clearColor];
        [_btnMinus setBackgroundImage:[UIImage imageNamed:@"btn_minus_not.png"] forState:UIControlStateNormal];
        [_btnMinus addTarget:self action:@selector(onButtonCount:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnMinus];
        
        //卖品选择数
        _labelCount = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelCount.font = MKFONT(15);
        _labelCount.textAlignment = NSTextAlignmentCenter;
        _labelCount.textColor = RGBA(51, 51, 51, 1);
        [self.contentView addSubview:_labelCount];
        
        //分割线
        _imgLine = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgLine.image = [UIImage imageNamed:@"image_dottedLine.png"];
        [self.contentView addSubview:_imgLine];
        
        //通用image
        _imgCommon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgCommon.backgroundColor = [UIColor clearColor];
        _imgCommon.image = [UIImage imageNamed:@"img_common.png"];
        _imgCommon.hidden = YES;
        [self.contentView addSubview:_imgCommon];
        
        _viewAlpha = [[UIView alloc]init];
        _viewAlpha.backgroundColor = [UIColor whiteColor];
        _viewAlpha.alpha = 0.8;
        [self.contentView addSubview:_viewAlpha];
    }
    return self;
}

//设置红包数据
- (void)setPacketData:(RedPacketListModel*)model cellModel:(RedPacketCellModel*)cellModel cellIndex:(CellIndex)index
{
    _packetModel = model;
    _redPacketCellModel = cellModel;
    if (index == 0 || index == 3)
    {
        //第一个红包
        _imageLogo.image = [UIImage imageNamed:@"img_order_sale_default.png"];
    }
    _labelLeftCount.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:model.worth]];
    _labelLeftCount.font = MKFONT(20);
    _labelName.text = model.redPacketName;
    _labelSaleCount.text = [NSString stringWithFormat:@"x%d",[model.totalCount intValue]];
    _labelLeft.text = [Tool getRedPacketDetail:model.redPacketType useLimit:model.useLimit]; //common:cellModel.common];
    if ([model.redPacketType intValue] == 0)
    {
        //票红包
        _labelLeft.text = [_labelLeft.text stringByReplacingOccurrencesOfString:@"。" withString:@"；"];
        if ([model.movieLimitCount intValue] == 0)
        {
            _labelDetail.text = @"每部影片使用个数不限。";
        }
        else
        {
            _labelDetail.text = [NSString stringWithFormat:@"每部影片最多可用%@个。",model.movieLimitCount];
        }
    }
    _labelEndDate.text =  [Tool returnTime:model.validEndTime format:@"有效期至：YYYY年MM月dd日"];
    _labelCount.text = [NSString stringWithFormat:@"%ld",(long)cellModel.currentCount];
    if (!cellModel.isCanTouchPlus)
    {
        //不能点＋
        _btnPlus.enabled = NO;
        [_btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_plus_not.png"] forState:UIControlStateNormal];
    }
    else
    {
        _btnPlus.enabled = YES;
        [_btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
    }
    
    if (!cellModel.isCanTouchMinus)
    {
        //不能点－
        _btnMinus.enabled = NO;
        [_btnMinus setBackgroundImage:[UIImage imageNamed:@"btn_minus_not.png"] forState:UIControlStateNormal];
    }
    else
    {
        _btnMinus.enabled = YES;
        [_btnMinus setBackgroundImage:[UIImage imageNamed:@"btn_minus.png"] forState:UIControlStateNormal];
    }
    if (cellModel.common)
    {
        //通用红包
        _imgCommon.hidden = NO;
    }
    
    _viewAlpha.hidden = cellModel.isViewAlphaHidden;
}

//设置红包frame
-(void)layoutPacket:(CellIndex)index
{
    CGFloat originY = 15;
    if (index == 0 || index == 3)
    {
        //第一个红包
        _imageLogo.frame = CGRectMake(15, 30, 54/2, 54/2);
        originY = 30;
    }
    _labelLeftCount.frame = CGRectMake(15+50/2+15, originY, [Tool calStrWidth:_labelLeftCount.text height:20], 20);
    _labelName.frame = CGRectMake(_labelLeftCount.frame.origin.x+_labelLeftCount.frame.size.width+10, _labelLeftCount.frame.origin.y+5, [Tool calStrWidth:_labelName.text height:15], 15);
    _labelSaleCount.frame = CGRectMake(_labelName.frame.origin.x+_labelName.frame.size.width+5, _labelName.frame.origin.y+1, 50, 14);
    _labelLeft.frame = CGRectMake(_labelLeftCount.frame.origin.x, _labelLeftCount.frame.origin.y+_labelLeftCount.frame.size.height+15, SCREEN_WIDTH-_labelLeftCount.frame.origin.x, 12);
    _labelDetail.frame = CGRectMake(_labelLeft.frame.origin.x, _labelLeft.frame.origin.y+_labelLeft.frame.size.height+5, 250, 12);
    _labelEndDate.frame = CGRectMake(_labelLeftCount.frame.origin.x, _labelDetail.frame.origin.y+_labelDetail.frame.size.height+10, 250, 11);
    if (_imgCommon.hidden == NO)
    {
        _imgCommon.frame = CGRectMake(SCREEN_WIDTH-35, _labelEndDate.frame.origin.y-4, 35, 15);
    }
    _btnPlus.frame = CGRectMake(SCREEN_WIDTH-15-23, originY, 23, 23);
    _labelCount.frame = CGRectMake(_btnPlus.frame.origin.x - 33, _btnPlus.frame.origin.y+(23-15)/2, 33, 15);
    _btnMinus.frame = CGRectMake(_labelCount.frame.origin.x - 23, _btnPlus.frame.origin.y, 23, 23);
    
    if (index == indexOnly || index == indexLast)
    {
        //最后一个卡cell
        _imgLine.frame = CGRectMake(0, _labelEndDate.frame.origin.y+_labelEndDate.frame.size.height+15-1, SCREEN_WIDTH, 1);
    }
    else
    {
        _imgLine.frame = CGRectMake(_labelLeftCount.frame.origin.x, _labelEndDate.frame.origin.y+_labelEndDate.frame.size.height+15-1, SCREEN_WIDTH-_labelLeftCount.frame.origin.x, 1);
    }
    _viewAlpha.frame = CGRectMake(0, 0, SCREEN_WIDTH, _imgLine.frame.origin.y+_imgLine.frame.size.height);
}

-(void)onButtonCount:(UIButton*)btn
{
    if ([self.cellDelegate respondsToSelector:@selector(isUsePacket:packetModel:cellModel:)])
    {
        if (btn.tag == 0)
        {
            [MobClick event:mainViewbtn40];
            [self.cellDelegate isUsePacket:YES packetModel:_packetModel cellModel:_redPacketCellModel];
        }
        else
        {
            [MobClick event:mainViewbtn41];
            [self.cellDelegate isUsePacket:NO packetModel:_packetModel cellModel:_redPacketCellModel];;
        }
    }
}
@end
