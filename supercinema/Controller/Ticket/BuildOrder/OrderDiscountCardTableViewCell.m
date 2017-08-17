//
//  OrderDiscountCardTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/21.
//
//

#import "OrderDiscountCardTableViewCell.h"

@implementation OrderDiscountCardTableViewCell

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
        
        //勾选卡btn
        _btnCard = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnCard addTarget:self action:@selector(onButtonCard:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnCard];
        
        //消耗次数
        _labelUseCount = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelUseCount.font = MKFONT(11);
        _labelUseCount.textAlignment = NSTextAlignmentRight;
        _labelUseCount.backgroundColor = [UIColor clearColor];
        _labelUseCount.textColor = RGBA(123, 122, 152, 1);
        [self.contentView addSubview:_labelUseCount];
        
        //使用规则btn
        _btnDetail = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDetail setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];
        _btnDetail.titleLabel.font = MKFONT(12);
        [_btnDetail setTitle:@"使用规则" forState:UIControlStateNormal];
        [_btnDetail addTarget:self action:@selector(onButtonDetail) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnDetail];
        
        _imgArrow = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgArrow.image = [UIImage imageNamed:@"image_rightArrow_notRight.png"];
        _imgArrow.userInteractionEnabled = YES;
        [self.contentView addSubview:_imgArrow];
        
        UITapGestureRecognizer* tapArrow = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onButtonDetail)];
        [_imgArrow addGestureRecognizer:tapArrow];
        
        //分割线
        _imgLine = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgLine.image = [UIImage imageNamed:@"image_dottedLine.png"];
        [self.contentView addSubview:_imgLine];
        
        _viewAlpha = [[UIView alloc]init];
        _viewAlpha.backgroundColor = [UIColor whiteColor];
        _viewAlpha.alpha = 0.8;
        [self.contentView addSubview:_viewAlpha];
    }
    return self;
}

//设置次卡、任看卡、套票数据
-(void)setCardData:(cinemaCardItemListModel*)model cardStateModel:(CardStateModel*)sModel cellIndex:(CellIndex)index
{
    _cardType = [model.cardType integerValue];
    _btnCard.selected = sModel.chooseState;
    _cardModel = sModel;
    
    if (index == 0 || index == 3)
    {
        //第一个卡
        _imageLogo.image = [UIImage imageNamed:@"img_order_card_default"];
    }
    _labelName.text = model.cardItemName;
    if (_cardType == 1)
    {
        //次卡
        _labelLeft.text = @"剩余次数：";
    }
    else if (_cardType == 2 || _cardType == 4)
    {
        //套票、通票
        _labelLeft.text = @"余额：";
    }
    
    NSString* strUnit = _cardType == 1 ? @"次" : @"张";
    //设置勾选按钮图片
    if (sModel.chooseState)
    {
        //勾选
        [_btnCard setBackgroundImage:[UIImage imageNamed:@"btn_card_select.png"] forState:UIControlStateNormal];
        if ([model.cardType integerValue] != 3)
        {
            //任看卡不显示余额
            _labelLeftCount.text = [NSString stringWithFormat:@"%d%@",sModel.usedLeftCount,strUnit];
        }
        //消耗次数
        int useCount = sModel.canUseCount;
        if (_cardType == 4)
        {
            //通票
            useCount = sModel.canUseCount * [sModel.cardExchangeStep intValue];
        }
        _labelUseCount.text = [NSString stringWithFormat:@"本次消耗%d%@",useCount,strUnit];
    }
    else
    {
        //不勾选
        [_btnCard setBackgroundImage:[UIImage imageNamed:@"btn_card_select_not.png"] forState:UIControlStateNormal];
        if ([model.cardType integerValue] != 3)
        {
            //任看卡不显示余额
            _labelLeftCount.text = [NSString stringWithFormat:@"%d%@",[model.leftUseCount intValue],strUnit];
        }
        _labelUseCount.text = @"";
    }
    
    if (_cardType == 4)
    {
        //显示通票详情按钮
        _btnDetail.hidden = NO;
        _tongpiaoId = [NSNumber numberWithInteger:_cardModel.id];
    }
    else
    {
        //不显示通票详情按钮
        _btnDetail.hidden = YES;
        _imgArrow.hidden = YES;
    }
    if (_cardType != 1 && [model.currMovieCanUseMaxCount intValue] != -1 && _cardType!= 4)
    {
        //不是次卡、通票，并且当前电影可以使用的最大次数不是－1
        //显示说明
        _labelDetail.text = [NSString stringWithFormat:@"当前影片可用%d张，已用%d张",[model.currMovieCanUseMaxCount intValue],[model.currMovieUsedCount intValue]];//@"当前影片可用 4 张，已用 0 张";
    }
    _labelEndDate.text = [Tool returnTime:model.validEndTime format:@"有效期至：YYYY年MM月dd日"];
    
    if (sModel.isShowViewAlpha)
    {
        _viewAlpha.hidden = NO;
    }
    else
    {
        _viewAlpha.hidden = YES;
    }
}

//设置次卡、任看卡、套票frame
-(void)layoutCard:(CellIndex)index
{
    if (index == 0 || index == 3)
    {
        _imageLogo.frame = CGRectMake(15, 15, 54/2, 54/2);
    }
    _labelName.frame = CGRectMake(15+50/2+15, 15, 150, 15);
    _labelLeft.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+10, [Tool calStrWidth:_labelLeft.text height:12], 12);
    if (_labelLeftCount.text.length>0)
    {
        _labelLeftCount.frame = CGRectMake(_labelLeft.frame.origin.x+_labelLeft.frame.size.width, _labelName.frame.origin.y+_labelName.frame.size.height+7, 100, 15);
    }
    if (_cardType == 1 || _cardType == 4)
    {
        //次卡和通票的有效期显示在余额下方
        _labelEndDate.frame = CGRectMake(_labelName.frame.origin.x, _labelLeft.frame.origin.y+_labelLeft.frame.size.height+10, 200, 11);
        if (_cardType == 4)
        {
            _btnDetail.frame = CGRectMake(_labelName.frame.origin.x, _labelEndDate.frame.origin.y+_labelEndDate.frame.size.height+10, [Tool calStrWidth:@"使用规则" height:12], 12);
            _imgArrow.frame = CGRectMake(_btnDetail.frame.size.width+_btnDetail.frame.origin.x+5, _btnDetail.frame.origin.y + (_btnDetail.frame.size.height-9)/2, 5.5, 9);
        }
    }
    if (_cardType == 2 || _cardType == 3)
    {
        if (_cardType == 2)
        {
            //套票
            _labelDetail.frame = CGRectMake(_labelName.frame.origin.x, _labelLeft.frame.origin.y+_labelLeft.frame.size.height, 250, 12);
        }
        if (_cardType == 3)
        {
            //任看卡
            _labelDetail.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+10, 250, 12);
        }
        _labelEndDate.frame = CGRectMake(_labelName.frame.origin.x, _labelDetail.frame.origin.y+_labelDetail.frame.size.height+10, 200, 11);
    }
    _btnCard.frame = CGRectMake(SCREEN_WIDTH - 60, 79/2-15, 21, 21);
    _labelUseCount.frame = CGRectMake(SCREEN_WIDTH-15-150, _btnCard.frame.origin.y+_btnCard.frame.size.height+7, 150, 11);
    
    CGFloat contentHeight = 0;
    if (_cardType == 4)
    {
        //通票
        contentHeight = _btnDetail.frame.origin.y+_btnDetail.frame.size.height+15;
    }
    else if (_cardType == 1 || _cardType == 2 || _cardType == 3)
    {
        //次卡、套票、任看卡
        contentHeight = _labelEndDate.frame.origin.y+_labelEndDate.frame.size.height+15;
    }
    if (index == indexOnly || index == indexLast)
    {
        //最后一个卡cell
        _imgLine.frame = CGRectMake(0, contentHeight-1, SCREEN_WIDTH, 1);
    }
    else
    {
        _imgLine.frame = CGRectMake(_labelName.frame.origin.x, contentHeight-1, SCREEN_WIDTH-_labelName.frame.origin.x, 1);
    }
    _viewAlpha.frame = CGRectMake(0, 0, SCREEN_WIDTH,_imgLine.frame.origin.y +_imgLine.frame.size.height);
}

-(void)onButtonCard:(UIButton*)button
{
    [MobClick event:mainViewbtn39];
    button.selected = !button.selected;
    _cardModel.chooseState = button.selected;
    if (button.selected)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"btn_card_select.png"] forState:UIControlStateNormal];
    }
    else
    {
        [button setBackgroundImage:[UIImage imageNamed:@"btn_card_select_not.png"] forState:UIControlStateNormal];
    }
    if ([self.cellDelegate respondsToSelector:@selector(isUseCard:cardModel:)])
    {
        [self.cellDelegate isUseCard:button.selected cardModel:_cardModel];
    }
}

-(void)onButtonDetail
{
    if ([self.cellDelegate respondsToSelector:@selector(showTongPiaoDetail:)])
    {
        [self.cellDelegate showTongPiaoDetail:_tongpiaoId];
    }
}

@end
