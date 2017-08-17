	//
//  CardOrderRightsTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 12/11/16.
//
//

#import "CardOrderRightsTableViewCell.h"

@implementation CardOrderRightsTableViewCell

//初始化控件
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //红包Logo
        _imageRedPacketLogo = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageRedPacketLogo.backgroundColor = [UIColor clearColor];
        [_imageRedPacketLogo setImage:[UIImage imageNamed:@"image_redPacket.png"]];
        [self.contentView addSubview:_imageRedPacketLogo];
        
        //红包的钱
        _labelRedPacketPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelRedPacketPrice setBackgroundColor:[UIColor clearColor]];
        [_labelRedPacketPrice setFont:MKFONT(20)];
        [_labelRedPacketPrice setTextColor:RGBA(249, 81, 81, 1)];
        [self addSubview:_labelRedPacketPrice];
        
        //红包名称
        _labelRedPacketName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelRedPacketName setBackgroundColor:[UIColor clearColor]];
        [_labelRedPacketName setFont:MKFONT(15)];
        [_labelRedPacketName setTextColor:RGBA(51, 51, 51, 1)];
        [self addSubview:_labelRedPacketName];
        
        //红包总数量
        _labelRedPackeAllCount = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelRedPackeAllCount setBackgroundColor:[UIColor clearColor]];
        [_labelRedPackeAllCount setFont:MKFONT(14)];
        [_labelRedPackeAllCount setTextColor:RGBA(51, 51, 51, 1)];
        [self addSubview:_labelRedPackeAllCount];
        
        //权益描述
        _labelRightDescribe = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelRightDescribe setBackgroundColor:[UIColor clearColor]];
        [_labelRightDescribe setFont:MKFONT(12)];
        [_labelRightDescribe setTextColor:RGBA(51, 51, 51, 1)];
        [self addSubview:_labelRightDescribe];
        
        //有效期
        _labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelDate setBackgroundColor:[UIColor clearColor]];
        [_labelDate setFont:MKFONT(11)];
        [_labelDate setTextColor:RGBA(123, 122, 152, 1)];
        [_labelDate setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_labelDate];
        
        //是否通用（红包）
        _imageCommonIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageCommonIcon setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_imageCommonIcon];
        
/****************红包的加减按钮****************/
        //合并红包的加减按钮
        _btnPlus = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlus.frame = CGRectZero;
        _btnPlus.enabled = YES;
        [_btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
        _btnPlus.backgroundColor = [UIColor clearColor];
        _btnPlus.tag = 0;
        [_btnPlus addTarget:self action:@selector(onButtonCount:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnPlus];
        
        //按钮蒙层（加号）
//        _btnPlusViewAlpha = [[UIView alloc] initWithFrame:CGRectZero];
//        _btnPlusViewAlpha.backgroundColor = [UIColor whiteColor];
//        _btnPlusViewAlpha.alpha = 0.8;
//        _btnPlusViewAlpha.hidden = YES;
//        [_btnPlus addSubview:_btnPlusViewAlpha];
        
        //红包个数
        _labelCount = [[UILabel alloc]initWithFrame:CGRectZero];
        [_labelCount setBackgroundColor:[UIColor clearColor]];
        _labelCount.font = MKFONT(14);
        _labelCount.textAlignment = NSTextAlignmentCenter;//居中显示
        _labelCount.textColor = [UIColor blackColor];
        [self addSubview:_labelCount];
        
        _btnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMinus.frame = CGRectZero;
        _btnMinus.tag = 1;
        _btnMinus.backgroundColor = [UIColor clearColor];
        _btnMinus.enabled = NO;
        [_btnMinus setBackgroundImage:[UIImage imageNamed:@"btn_minus_not.png"] forState:UIControlStateNormal];
        //[_btnMinus setImage:[UIImage imageNamed:@"btn_minus.png"] forState:UIControlStateNormal];
        [_btnMinus addTarget:self action:@selector(onButtonCount:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnMinus];
        
        //按钮蒙层（减号）
//        _btnMinusViewAlpha = [[UIView alloc]init];
//        _btnMinusViewAlpha.backgroundColor = [UIColor whiteColor];
//        _btnMinusViewAlpha.alpha = 0.8;
//        [_btnMinus addSubview:_btnMinusViewAlpha];
        
        //分割线（虚线）
        _imageLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageLine setBackgroundColor:[UIColor clearColor]];
        [_imageLine setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
        [self addSubview:_imageLine];
        
        self._viewAlpha = [[UIView alloc]init];
        self._viewAlpha.backgroundColor = [UIColor whiteColor];
        self._viewAlpha.alpha = 0.8;
        [self addSubview:self._viewAlpha];
    }
    return self;
}

#pragma mark - 设置红包数据
- (void)setPacketData:(RedPacketCellVO*)cellModel
{
    _redPacketCellModel = cellModel;
    
    //红包Logo
    _imageRedPacketLogo.frame = CGRectMake(15, 30, 25, 25);
    
    //红包的钱
    _labelRedPacketPrice.frame = CGRectMake(_imageRedPacketLogo.frame.origin.x+_imageRedPacketLogo.frame.size.width+11, 31.5, 40, 20);
    //[_labelRedPacketPrice setText:[NSString stringWithFormat:@"￥%ld",[_redPacketCellModel.worth integerValue]/100]];
    [_labelRedPacketPrice setText:[NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:_redPacketCellModel.worth]]];
    [Tool setLabelSpacing: _labelRedPacketPrice spacing:2 alignment:NSTextAlignmentLeft];
    _labelRedPacketPrice.frame = CGRectMake(_imageRedPacketLogo.frame.origin.x+_imageRedPacketLogo.frame.size.width+11, 31.5, _labelRedPacketPrice.frame.size.width, 20);
    
    //红包名称
    _labelRedPacketName.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x+_labelRedPacketPrice.frame.size.width+13, 35, 70, 15);
    [_labelRedPacketName setText:cellModel.redPacketName];
    [Tool setLabelSpacing: _labelRedPacketName spacing:2 alignment:NSTextAlignmentLeft];
    _labelRedPacketName.frame = CGRectMake(_labelRedPacketPrice.frame.origin.x+_labelRedPacketPrice.frame.size.width+13, 35, _labelRedPacketName.frame.size.width, 15);
    
    //红包总数量（合并红包剩余数量）
    _labelRedPackeAllCount.frame = CGRectMake(_labelRedPacketName.frame.origin.x+_labelRedPacketName.frame.size.width+5, 36.5, 70, 14);
    [_labelRedPackeAllCount setText:[NSString stringWithFormat:@"x%ld",(long)cellModel.redPacketLeftCount]];
    [Tool setLabelSpacing: _labelRedPackeAllCount spacing:2 alignment:NSTextAlignmentLeft];
    _labelRedPackeAllCount.frame = CGRectMake(_labelRedPacketName.frame.origin.x+_labelRedPacketName.frame.size.width+5, 36.5, _labelRedPackeAllCount.frame.size.width, 14);
    
    //权益描述
    [_labelRightDescribe setText:cellModel.redPacketDetails];
    
    //有效期
    [_labelDate setText:cellModel.validEndTime];
    
    //通用红包（为true则是通用红包，否则就是不通用红包）
    if (cellModel.isCurrency)
    {
        _imageCommonIcon.hidden = NO;
    }
    else
    {
        _imageCommonIcon.hidden = YES;
    }
    
    //是否通用icon(红包)
    if (cellModel.isCurrency)
    {
        [_imageCommonIcon setImage:[UIImage imageNamed:@"image_sharing.png"]];
    }


    _labelCount.text = [NSString stringWithFormat:@"%ld",(long)cellModel.currentCount];
    
    self._viewAlpha.hidden = _redPacketCellModel.isViewAlphaHidden;
    
    if (_redPacketCellModel.isCanTouchMinus)
    {
        _btnMinus.enabled = YES;
        [_btnMinus setBackgroundImage:[UIImage imageNamed:@"btn_minus.png"] forState:UIControlStateNormal];
    }
    else
    {
         _btnMinus.enabled = NO;
        [_btnMinus setBackgroundImage:[UIImage imageNamed:@"btn_minus_not.png"] forState:UIControlStateNormal];
    }
    
    if (_redPacketCellModel.isCanTouchPlus)
    {
        _btnPlus.enabled = YES;
        [_btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_plus.png"] forState:UIControlStateNormal];
    }
    else
    {
        _btnPlus.enabled = NO;
        [_btnPlus setBackgroundImage:[UIImage imageNamed:@"btn_plus_not.png"] forState:UIControlStateNormal];
    }
    
//    _btnMinusViewAlpha.hidden = _redPacketCellModel.isCanTouchMinus;
//    _btnPlusViewAlpha.hidden = _redPacketCellModel.isCanTouchPlus;
    
}

-(void)layoutPacket:(NSInteger)indexPath isShowMore:(BOOL)isShow
{
    if (indexPath == 0)
    {
        _imageRedPacketLogo.hidden = NO;
    }
    else
    {
        _imageRedPacketLogo.hidden = YES;
    }
    
    //权益描述
    _labelRightDescribe.frame = CGRectMake(15+25+15, _labelRedPackeAllCount.frame.origin.y+_labelRedPackeAllCount.frame.size.height+15, SCREEN_WIDTH-15*2, 12);

    //有效期
    _labelDate.frame = CGRectMake(15+25+15,  _labelRightDescribe.frame.origin.y+_labelRightDescribe.frame.size.height+10, SCREEN_WIDTH-15*2, 11);
    //通用红包
    _imageCommonIcon.frame = CGRectMake(SCREEN_WIDTH-35, _labelDate.frame.origin.y-4, 35, 15);
    
/****************红包的加减按钮****************/
    //合并红包的加减按钮
    //红包个数
    _labelCount.frame = CGRectMake(SCREEN_WIDTH-15-23-40, _labelRedPacketName.frame.origin.y, 40, 23);

    //按钮减号
    _btnMinus.frame = CGRectMake(SCREEN_WIDTH-15-23*2-40, _labelRedPacketName.frame.origin.y, 23, 23);
    //_btnMinusViewAlpha.frame = CGRectMake(0, 0, _btnMinus.frame.size.width, _btnMinus.frame.size.height);

    //加号按钮
    _btnPlus.frame = CGRectMake(SCREEN_WIDTH-15-23, _btnMinus.frame.origin.y, 23, 23);
    //_btnPlusViewAlpha.frame = CGRectMake(0, 0, _btnPlus.frame.size.width, _btnPlus.frame.size.height);
    
    //分割线（虚线）
    _imageLine.frame = CGRectMake(15, _labelDate.frame.origin.y+_labelDate.frame.size.height+30, SCREEN_WIDTH-15*2, 0.5);
    
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width,_imageLine.frame.origin.y+_imageLine.frame.size.height);
    
    self._viewAlpha.frame = self.contentView.frame;
}

//点击加减红包按钮的方法
-(void)onButtonCount:(UIButton*)btn
{
    if ([self.orderCellDelegate respondsToSelector:@selector(changeredPacketValue:isMinu:)])
    {
        BOOL result;
        if (btn.tag == 0)
        {
            //加操作
            [MobClick event:mainViewbtn75];
            result = [self.orderCellDelegate changeredPacketValue:_redPacketCellModel isMinu:NO];
        }
        else
        {
            //减操作
            [MobClick event:mainViewbtn76];
            result = [self.orderCellDelegate changeredPacketValue:_redPacketCellModel isMinu:YES];
        }
        
        if(result)
        {
            _labelCount.text = [NSString stringWithFormat:@"%ld",(long)_redPacketCellModel.currentCount];
        }
    }
}


@end
