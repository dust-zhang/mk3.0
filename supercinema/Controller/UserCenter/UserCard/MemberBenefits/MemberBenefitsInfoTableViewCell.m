//
//  MemberBenefitsInfoTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 25/11/16.
//
//

#import "MemberBenefitsInfoTableViewCell.h"

@implementation MemberBenefitsInfoTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _cinemaModel = [[CinemaModel alloc]init];
        
        [self setBackgroundColor:RGBA(246, 246, 251,1)];
        [self initController];
    }
    return self;
}

-(void)initController
{
    _viewWhiteBg = [[UIView alloc ] initWithFrame:CGRectZero];
    [_viewWhiteBg setBackgroundColor:[UIColor whiteColor]];
    [_viewWhiteBg.layer setBorderWidth:1];
    [_viewWhiteBg.layer setBorderColor:RGBA(233, 233, 238,1).CGColor];
    [self.contentView addSubview:_viewWhiteBg];
    
    //影院地址
    _labelCinemaAddress = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelCinemaAddress setBackgroundColor:[UIColor clearColor]];
    [_labelCinemaAddress setFont:MKFONT(12)];
    [_labelCinemaAddress setTextColor:RGBA(117, 112, 255, 1)];
    _labelCinemaAddress.numberOfLines = 2;
    _labelCinemaAddress.lineBreakMode = NSLineBreakByCharWrapping;
    [_viewWhiteBg addSubview:_labelCinemaAddress];
    
    //箭头
    _imageArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageArrow setImage:[UIImage imageNamed:@"btn_rightArrow_ purple.png"]];
    [_viewWhiteBg addSubview:_imageArrow];
    
    //跳转到影院的透明Button
    _btnCinemaAddress = [[UIButton alloc] initWithFrame:CGRectZero];
    _btnCinemaAddress.backgroundColor = [UIColor clearColor];
    [_viewWhiteBg addSubview:_btnCinemaAddress];
    
    //权利个数
    _labelRightsCount = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelRightsCount setBackgroundColor:[UIColor clearColor]];
    [_labelRightsCount setTextAlignment:NSTextAlignmentRight];
    [_viewWhiteBg addSubview:_labelRightsCount];
    
    //纵向分割线
    _labelLine = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelLine setBackgroundColor:RGBA(217, 217, 217, 1)];
    [_viewWhiteBg addSubview:_labelLine];
    
    //分割线
    _imageLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageLine setBackgroundColor:[UIColor clearColor]];
    [_imageLine setImage:[UIImage imageNamed:@"image_dottedLine.png"]];
    [_viewWhiteBg addSubview:_imageLine];
    
    //失效的蒙版
    _viewMask = [[UIView alloc] initWithFrame:CGRectZero];
    _viewMask.backgroundColor = RGBA(255, 255, 255, 0.5);
    _viewMask.hidden = YES;
    [_viewWhiteBg addSubview:_viewMask];
}

#pragma mark - 有效
-(void)setAllValidBasicInformationCellFrameData:(CinemaModel *)cinemaModel arrayCardList:(NSArray *)arrayCardList
{
    _cinemaModel = cinemaModel;
    _viewWhiteBg.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, 70);
    
    //影院地址
    _labelCinemaAddress.frame = CGRectMake(15, 15,  _viewWhiteBg.frame.size.width-60-15-35, 12);
    _labelCinemaAddress.text = cinemaModel.cinemaName;
    [Tool setLabelSpacing:_labelCinemaAddress spacing:2 alignment:NSTextAlignmentLeft];
    _labelCinemaAddress.frame = CGRectMake(15, 15,  _labelCinemaAddress.frame.size.width, _labelCinemaAddress.frame.size.height);//_viewWhiteBg.frame.size.width-60-15-35

    //箭头
    _imageArrow.frame = CGRectMake(_labelCinemaAddress.frame.origin.x+_labelCinemaAddress.frame.size.width+5, _labelCinemaAddress.frame.origin.y, 7.5, 13);
    
    //跳转到影院的透明Button
    _btnCinemaAddress.frame = CGRectMake(_labelCinemaAddress.frame.origin.x, _labelCinemaAddress.frame.origin.y, _labelCinemaAddress.frame.size.width+_imageArrow.frame.size.width, _labelCinemaAddress.frame.size.height);
    _btnCinemaAddress.tag = 0;
    [_btnCinemaAddress addTarget:self action:@selector(onButtonCinemaAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    //权利个数
    _labelRightsCount.frame = CGRectMake(_viewWhiteBg.frame.size.width-60-15, 11, 60, 16);
    NSString *str = [NSString stringWithFormat:@"%lu个特权",(unsigned long)[arrayCardList count]];
    NSUInteger joinCount =[[NSString stringWithFormat:@"%lu", (unsigned long)[arrayCardList count]] length];
    //算出range的位置
    NSRange oneRange =NSMakeRange(0,joinCount);
    NSRange twoRange =NSMakeRange(joinCount,3);
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
    //设置字号 & 颜色
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(16) range:oneRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(12) range:twoRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(249, 81, 81, 1) range:oneRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:twoRange];
    [_labelRightsCount setAttributedText:strAtt];
    
    //纵向分割线
    _labelLine.frame = CGRectMake(_labelRightsCount.frame.origin.x-1, 16.5, 0.5, 10);
    
    //分割线
    _imageLine.frame = CGRectMake(15, _labelCinemaAddress.frame.origin.y+_labelCinemaAddress.frame.size.height+15, _viewWhiteBg.frame.size.width-15*2, 0.5);
}

-(void)setAllValidDetailsCellFrameData:(NSArray *)arrayCardList index:(NSInteger)indexPath
{
    _index = indexPath;
    
    for (int i = 0 ; i <[arrayCardList count] ; i++)
    {
        CardListModel *cardListModel = arrayCardList[i];
        
        //卡类型透明背景
        UIButton *btnTransparentBG = [[UIButton alloc] initWithFrame:CGRectMake(15, _imageLine.frame.origin.y+_imageLine.frame.size.height+30+(85*i), _viewWhiteBg.frame.size.width-15*2, 85)];
        [btnTransparentBG setBackgroundColor:[UIColor clearColor]];
        objc_setAssociatedObject(btnTransparentBG, "tableType", [NSNumber numberWithInt:Valid], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        btnTransparentBG.tag = i;//给标签
        [btnTransparentBG addTarget:self action:@selector(onButtonCardInfo:) forControlEvents:UIControlEventTouchUpInside];
        [_viewWhiteBg addSubview:btnTransparentBG];
        
        //卡Logo
        UIImageView *imageLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 30, 30)];
        [imageLogo setBackgroundColor:[UIColor clearColor]];
        [imageLogo.layer setCornerRadius:15.f];
        
        /**
         *  卡类型   普通:-1
         *          常规:0
         *          次卡:1
         *          套票:2
         *          任看:3
         *          通票:4
         */
        if (
            [cardListModel.cardType intValue] == -1  ||
            [cardListModel.cardType intValue] == 0   ||
            [cardListModel.cardType intValue] == 1   )
        {
            //卡类型Logo
            [imageLogo setImage:[UIImage imageNamed:@"image_membershipCard.png"]];
        }
        else
        {
            //票类型Logo
            [imageLogo setImage:[UIImage imageNamed:@"image_ticketType.png"]];
        }
        [btnTransparentBG addSubview:imageLogo];
        
        //卡名称
        UILabel *labelCardName = [[UILabel alloc] initWithFrame:CGRectMake(imageLogo.frame.origin.x+imageLogo.frame.size.width+15, 0, _viewWhiteBg.frame.size.width/2, 15)];
        [labelCardName setBackgroundColor:[UIColor clearColor]];
        [labelCardName setFont:MKBOLDFONT(15)];
        [labelCardName setTextColor:RGBA(51, 51, 51, 1)];
        [labelCardName setTextAlignment:NSTextAlignmentLeft];
        labelCardName.text = cardListModel.cinemaCardName;
        [btnTransparentBG addSubview:labelCardName];
        
        CGFloat fHightCardDescribe = 210;
        if (IPhone5)
        {
            fHightCardDescribe = 170;
        }
        //卡描述
        UILabel *labelCardDescribe = [[UILabel alloc] initWithFrame:CGRectMake(labelCardName.frame.origin.x, labelCardName.frame.origin.y+labelCardName.frame.size.height+10, fHightCardDescribe, 12)];//135
        [labelCardDescribe setBackgroundColor:[UIColor clearColor]];
        [labelCardDescribe setFont:MKFONT(12)];
        [labelCardDescribe setTextColor:RGBA(51, 51, 51, 1)];
        [labelCardDescribe setTextAlignment:NSTextAlignmentLeft];
        labelCardDescribe.text = cardListModel.cardDesc;
        [btnTransparentBG addSubview:labelCardDescribe];
        
        //卡有效期
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(labelCardDescribe.frame.origin.x, labelCardDescribe.frame.origin.y+labelCardDescribe.frame.size.height+10, _viewWhiteBg.frame.size.width, 11)];
        [labelDate setBackgroundColor:[UIColor clearColor]];
        [labelDate setFont:MKFONT(11)];
        [labelDate setTextColor:RGBA(123, 122, 152, 1)];
        [labelDate setTextAlignment:NSTextAlignmentLeft];
        labelDate.text = [NSString stringWithFormat:@"有效期至：%@",[Tool returnTime:cardListModel.cardValidEndTime format:@"yyyy年MM月dd日"]];
        [btnTransparentBG addSubview:labelDate];

        //按钮卡状态
        UIButton *btnBuyCardState = [[UIButton alloc] initWithFrame:CGRectMake(btnTransparentBG.frame.size.width-50, 17, 65, 24)];
        [btnBuyCardState setBackgroundColor:[UIColor clearColor]];
        btnBuyCardState.tag = i;//给标签
        [btnBuyCardState .titleLabel setFont:MKFONT(12)];//按钮字体大小
        [btnBuyCardState setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];//按钮文字颜色
        [btnBuyCardState.layer setCornerRadius:12.f];//按钮设置圆角
        btnBuyCardState.enabled = NO;//不能点击
        [btnBuyCardState setTitle:@"已开通" forState:UIControlStateNormal];
        objc_setAssociatedObject(btnBuyCardState, "tableType", [NSNumber numberWithInt:Valid], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [btnBuyCardState addTarget:self action:@selector(onButtonBuyCard:) forControlEvents:UIControlEventTouchUpInside];
        [btnTransparentBG addSubview:btnBuyCardState];
    }
    
    
    _viewWhiteBg.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, 75+(arrayCardList.count*85)+20);
    
    
}

#pragma mark - 失效
-(void)setAllPastDueBasicInformationCellFrameData:(CinemaModel *)cinemaModel arrayCardList:(NSArray *)arrayCardList
{
    _cinemaModel = cinemaModel;
    _viewWhiteBg.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, 70);
    
    //影院地址
    _labelCinemaAddress.frame = CGRectMake(15, 15, _viewWhiteBg.frame.size.width-60-15-35, 12);
    _labelCinemaAddress.text = cinemaModel.cinemaName;
    [Tool setLabelSpacing:_labelCinemaAddress spacing:2 alignment:NSTextAlignmentLeft];
    _labelCinemaAddress.frame = CGRectMake(15, 15, _labelCinemaAddress.frame.size.width, _labelCinemaAddress.frame.size.height);//_viewWhiteBg.frame.size.width-60-15-35
    
    //箭头
    _imageArrow.frame = CGRectMake(_labelCinemaAddress.frame.origin.x+_labelCinemaAddress.frame.size.width+5, _labelCinemaAddress.frame.origin.y, 7.5, 13);
    
    //跳转到影院的透明Button
    _btnCinemaAddress.frame = CGRectMake(_labelCinemaAddress.frame.origin.x, _labelCinemaAddress.frame.origin.y, _labelCinemaAddress.frame.size.width+_imageArrow.frame.size.width, _labelCinemaAddress.frame.size.height);
    _btnCinemaAddress.tag = 1;
    [_btnCinemaAddress addTarget:self action:@selector(onButtonCinemaAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    //权利个数
    _labelRightsCount.frame = CGRectMake(_viewWhiteBg.frame.size.width-60-15, 11, 60, 16);
    NSString *str = [NSString stringWithFormat:@"%lu个特权",(unsigned long)[arrayCardList count]];
    NSUInteger joinCount =[[NSString stringWithFormat:@"%lu", (unsigned long)[arrayCardList count]] length];
    //算出range的位置
    NSRange oneRange =NSMakeRange(0,joinCount);
    NSRange twoRange =NSMakeRange(joinCount,3);
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str];
    //设置字号 & 颜色
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(16) range:oneRange];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(12) range:twoRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(249, 81, 81, 1) range:oneRange];
    [strAtt addAttribute:NSForegroundColorAttributeName value:RGBA(102, 102, 102, 1) range:twoRange];
    [_labelRightsCount setAttributedText:strAtt];
    
    //纵向分割线
    _labelLine.frame = CGRectMake(_labelRightsCount.frame.origin.x-1, 16.5, 0.5, 10);
    
    //分割线
    _imageLine.frame = CGRectMake(15, _labelCinemaAddress.frame.origin.y+_labelCinemaAddress.frame.size.height+15, _viewWhiteBg.frame.size.width-15*2, 0.5);

}

-(void)setAllPastDueDetailsCellFrameData:(NSArray *)arrayCardList index:(NSInteger)indexPath boolDeleteButtonShow:(BOOL)boolDeleteButtonShow
{
    //得到cell的indexPath.row
    _index = indexPath;
    
    for (int i = 0 ; i <[arrayCardList count] ; i++)
    {
        CardListModel *cardListModel = arrayCardList[i];
        
        //卡类型透明背景
        UIButton *btnTransparentBG = [[UIButton alloc] initWithFrame:CGRectMake(15, _imageLine.frame.origin.y+_imageLine.frame.size.height+27.5+(85*i), _viewWhiteBg.frame.size.width-15*2, 85)];
        [btnTransparentBG setBackgroundColor:[UIColor clearColor]];
        objc_setAssociatedObject(btnTransparentBG, "tableType", [NSNumber numberWithInt:PastDue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        btnTransparentBG.tag = i;//给标签
        if ([cardListModel.canContinuCard boolValue])
        {
            //再次购买；能看详情
            [btnTransparentBG addTarget:self action:@selector(onButtonCardInfo:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            //本身买过但是不让买，显示 已下架；
            //不能点击详情
        }
        [_viewWhiteBg addSubview:btnTransparentBG];
    
        
        //失效的蒙版
        UILabel *labelMaskFailure = [[UILabel alloc] initWithFrame:CGRectZero];
        labelMaskFailure.backgroundColor = RGBA(255, 255, 255, 0.5);
        labelMaskFailure.hidden = YES;
        [_viewWhiteBg addSubview:labelMaskFailure];
        
        //卡Logo
        UIImageView *imageLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 30, 30)];
        [imageLogo setBackgroundColor:[UIColor clearColor]];
        [imageLogo.layer setCornerRadius:15.f];
        /**
         *  卡类型   普通:-1
         *          常规:0
         *          次卡:1
         *          套票:2
         *          任看:3
         *          通票:4
         */
        if (
            [cardListModel.cardType intValue] == -1  ||
            [cardListModel.cardType intValue] == 0   ||
            [cardListModel.cardType intValue] == 1   )
        {
            //卡类型Logo
            [imageLogo setImage:[UIImage imageNamed:@"image_membershipCard.png"]];
        }
        else
        {
            //票类型Logo
            [imageLogo setImage:[UIImage imageNamed:@"image_ticketType.png"]];
        }

        [btnTransparentBG addSubview:imageLogo];
        
        //卡名称
        UILabel *labelCardName = [[UILabel alloc] initWithFrame:CGRectMake(imageLogo.frame.origin.x+imageLogo.frame.size.width+15, 0, _viewWhiteBg.frame.size.width/2, 15)];
        [labelCardName setBackgroundColor:[UIColor clearColor]];
        [labelCardName setFont:MKBOLDFONT(15)];
        [labelCardName setTextColor:RGBA(51, 51, 51, 1)];
        [labelCardName setTextAlignment:NSTextAlignmentLeft];
        labelCardName.text = cardListModel.cinemaCardName;
        [btnTransparentBG addSubview:labelCardName];
        
        CGFloat fHightCardDescribe = 210;
        if (IPhone5)
        {
            fHightCardDescribe = 170;
        }
        //卡描述
        UILabel *labelCardDescribe = [[UILabel alloc] initWithFrame:CGRectMake(labelCardName.frame.origin.x, labelCardName.frame.origin.y+labelCardName.frame.size.height+10, fHightCardDescribe, 12)];//135
        [labelCardDescribe setBackgroundColor:[UIColor clearColor]];
        [labelCardDescribe setFont:MKFONT(12)];
        [labelCardDescribe setTextColor:RGBA(51, 51, 51, 1)];
        [labelCardDescribe setTextAlignment:NSTextAlignmentLeft];
        labelCardDescribe.text = cardListModel.cardDesc;
        [btnTransparentBG addSubview:labelCardDescribe];
        
        //卡有效期
        UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(labelCardDescribe.frame.origin.x, labelCardDescribe.frame.origin.y+labelCardDescribe.frame.size.height+10, _viewWhiteBg.frame.size.width, 11)];
        [labelDate setBackgroundColor:[UIColor clearColor]];
        [labelDate setFont:MKFONT(11)];
        [labelDate setTextColor:RGBA(123, 122, 152, 1)];
        [labelDate setTextAlignment:NSTextAlignmentLeft];
        labelDate.text = [NSString stringWithFormat:@"有效期至：%@",[Tool returnTime:cardListModel.cardValidEndTime format:@"yyyy年MM月dd日"]];
        [btnTransparentBG addSubview:labelDate];
        
        //按钮卡状态
        UIButton *btnBuyCardState = [[UIButton alloc] initWithFrame:CGRectMake(btnTransparentBG.frame.size.width-65, 17, 65, 24)];
        btnBuyCardState.tag = i;//给标签
        [btnBuyCardState .titleLabel setFont:MKFONT(12)];//按钮字体大小
        
        if ([cardListModel.canContinuCard boolValue])
        {
            //能续卡
            [btnBuyCardState setBackgroundColor:RGBA(117, 112, 255, 1)];
            [btnBuyCardState setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
            [btnBuyCardState.layer setCornerRadius:12.f];//按钮设置圆角
            [btnBuyCardState setTitle:@"再次购买" forState:UIControlStateNormal];
            objc_setAssociatedObject(btnBuyCardState, "tableType", [NSNumber numberWithInt:PastDue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [btnBuyCardState addTarget:self action:@selector(onButtonBuyCard:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            //本身买过但是不让买，显示 已下架；
            //不能续卡
            [btnBuyCardState setBackgroundColor:[UIColor clearColor]];
            [btnBuyCardState setTitleColor:RGBA(102, 102, 102, 1) forState:UIControlStateNormal];//按钮文字颜色
            [btnBuyCardState setTitle:@"已下架" forState:UIControlStateNormal];
            btnBuyCardState.frame = CGRectMake(btnTransparentBG.frame.size.width-50, 17, 65, 24);//(11.30日定为文字靠右对齐)
        }
        [btnTransparentBG addSubview:btnBuyCardState];
        
        //删除按钮
        UIButton *btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(btnTransparentBG.frame.size.width-21, 17, 21, 21)];
        if ([cardListModel.isDelete intValue] == 1)
        {
            btnDelete.selected = NO;
            [btnDelete setBackgroundImage:[UIImage imageNamed:@"btn_card_select_not.png"] forState:UIControlStateNormal];//没勾选
        }
        else
        {
            btnDelete.selected = YES;
            [btnDelete setBackgroundImage:[UIImage imageNamed:@"btn_card_select.png"] forState:UIControlStateNormal];//没勾选
        }
        
        btnDelete.tag = i;//给标签
        objc_setAssociatedObject(btnDelete, "model", cardListModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [btnDelete addTarget:self action:@selector(onButtonDelete:) forControlEvents:UIControlEventTouchUpInside];
        [btnTransparentBG addSubview:btnDelete];
        
        objc_setAssociatedObject(btnTransparentBG, "delBtn", btnDelete, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        
        if (boolDeleteButtonShow == YES)
        {
            btnDelete.hidden = NO;
            btnBuyCardState.hidden = YES;
            _viewMask.hidden = NO;
            labelMaskFailure.hidden = NO;
        
        }
        else
        {
            btnDelete.hidden = YES;
            btnBuyCardState.hidden = NO;
            _viewMask.hidden = YES;
            labelMaskFailure.hidden = YES;
        }
        
        labelMaskFailure.frame = CGRectMake(btnTransparentBG.frame.origin.x, btnTransparentBG.frame.origin.y, btnTransparentBG.frame.size.width-21, btnTransparentBG.frame.size.height);
    }
    _viewWhiteBg.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, 75+(arrayCardList.count*85)+20);
    _viewMask.frame = CGRectMake(0, 0, _viewWhiteBg.frame.size.width, _imageLine.frame.origin.y+_imageLine.frame.size.height);
}

#pragma mark - 买卡
-(void)onButtonBuyCard:(UIButton*)sender
{
    [MobClick event:myCenterViewbtn35];
    if ([self.memberBenefitsInfoDelegate respondsToSelector:@selector(buyCardMemberBenefitsInfoCellSkip:tableType:index:)])
    {
        id tableType = objc_getAssociatedObject(sender, "tableType");
        [self.memberBenefitsInfoDelegate buyCardMemberBenefitsInfoCellSkip:sender tableType:[tableType integerValue] index:_index];
    }
}

#pragma mark - 卡详情
-(void)onButtonCardInfo:(UIButton*)sender
{
    if ([self.memberBenefitsInfoDelegate respondsToSelector:@selector(cardInfoMemberBenefitsInfoCellSkip:delBtn:tableType:index:)])
    {
        id tableType = objc_getAssociatedObject(sender, "tableType");
        id delBtn = objc_getAssociatedObject(sender, "delBtn");
        [self.memberBenefitsInfoDelegate cardInfoMemberBenefitsInfoCellSkip:sender delBtn:delBtn tableType:[tableType integerValue] index:_index];
    }
}

//勾选删除按钮
-(void)onButtonDelete:(UIButton*)button
{
    CardListModel* model = objc_getAssociatedObject(button, "model");
    
    button.selected = !button.selected;
    //    _cardModel.chooseState = button.selected;
    if (button.selected)
    {
        model.isDelete = [NSNumber numberWithInt:0];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_card_select.png"] forState:UIControlStateNormal];
    }
    else
    {
        model.isDelete = [NSNumber numberWithInt:1];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_card_select_not.png"] forState:UIControlStateNormal];
    }
    if ([self.memberBenefitsInfoDelegate respondsToSelector:@selector(deleteCardCellDataId:isSelected:)])
    {
        
        [self.memberBenefitsInfoDelegate deleteCardCellDataId:model.id isSelected:button.selected];
    }
}

//影院地址
-(void)onButtonCinemaAddress:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        //有效
        [MobClick event:myCenterViewbtn33];
    }
    else
    {
        //失效
        [MobClick event:myCenterViewbtn37];
    }
    
    if ([self.memberBenefitsInfoDelegate respondsToSelector:@selector(onButtonChangeCinema:)])
    {
        [self.memberBenefitsInfoDelegate onButtonChangeCinema:_cinemaModel];
    }
}


@end



