//
//  MembershipCardTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 7/11/16.
//
//

#import "MembershipCardTableViewCell.h"

@implementation MembershipCardTableViewCell

//初始化控件
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _cardListModel = [[CardListModel alloc] init];
        
        //背景View
        _viewMembershipCardCellBG = [[UIView alloc] initWithFrame:CGRectZero];
        [_viewMembershipCardCellBG setBackgroundColor:RGBA(255, 255, 255, 1)];
        _viewMembershipCardCellBG.layer.borderWidth = 0.5;//边框宽度
        _viewMembershipCardCellBG.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];//边框颜色
        [self addSubview:_viewMembershipCardCellBG];
        
        //图标
        _imageMembershipCardIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageMembershipCardIcon setBackgroundColor:[UIColor clearColor]];
        [_imageMembershipCardIcon.layer setCornerRadius:15.f];
        [_viewMembershipCardCellBG addSubview:_imageMembershipCardIcon];
        
        //名称
        _labelMembershipCardName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelMembershipCardName setBackgroundColor:[UIColor clearColor]];
        [_labelMembershipCardName setFont:MKFONT(15)];
        [_labelMembershipCardName setTextColor:RGBA(51, 51, 51, 1)];
        [_labelMembershipCardName setTextAlignment:NSTextAlignmentLeft];
        [_viewMembershipCardCellBG addSubview:_labelMembershipCardName];
        
        //描述
        _labelMembershipCardDescribe = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelMembershipCardDescribe setBackgroundColor:[UIColor clearColor]];
        [_labelMembershipCardDescribe setFont:MKFONT(12)];
        [_labelMembershipCardDescribe setTextColor:RGBA(51, 51, 51, 1)];
        [_labelMembershipCardDescribe setTextAlignment:NSTextAlignmentLeft];
        _labelMembershipCardDescribe.lineBreakMode = NSLineBreakByTruncatingTail;
        [_viewMembershipCardCellBG addSubview:_labelMembershipCardDescribe];
        
        //有效期
        _labelExpiryDate = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelExpiryDate setBackgroundColor:[UIColor clearColor]];
        [_labelExpiryDate setFont:MKFONT(11)];
        [_labelExpiryDate setTextColor:RGBA(123, 122, 152, 1)];
        [_labelExpiryDate setTextAlignment:NSTextAlignmentLeft];
        [_viewMembershipCardCellBG addSubview:_labelExpiryDate];
        
        //状态按钮
        _btnMembershipCardType = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnMembershipCardType .titleLabel setFont:MKFONT(12)];//按钮字体大小
        [_btnMembershipCardType.layer setCornerRadius:12.f];//按钮设置圆角
        _btnMembershipCardType.tag = 0;
        [_btnMembershipCardType addTarget:self action:@selector(onButtonMembershipCardDetails:) forControlEvents:UIControlEventTouchUpInside];
        [_viewMembershipCardCellBG addSubview:_btnMembershipCardType];
    }
    return self;
}

-(void)setMembershipCardTrendsTableCellData:(CardListModel*)cardListModel index:(NSInteger)indexPath memberModel:(MemberModel*)memberModel
{
    _cardListModel = cardListModel;
    
    _index = indexPath;
    
    //卡名称
//    [_labelMembershipCardName setText:cardListModel.cinemaCardName];
    
//    NSString* strCardName = cardListModel.cinemaCardName;
//    if (strCardName.length > 6)
//    {
//        strCardName = [strCardName substringWithRange:NSMakeRange(0, 5)];
//        strCardName = [strCardName stringByAppendingString:@"..."];
//    }
    _labelMembershipCardName.text = cardListModel.cinemaCardName;

    //卡描述
    [_labelMembershipCardDescribe setText:cardListModel.cardDesc];
   
    /**
     *  卡类型   普通:-1
     *          常规:0
     *          次卡:1
     *          套票:2
     *          任看:3
     *          通票:4
     */
    
    if ([cardListModel.cardType intValue] == -1 ||
        [cardListModel.cardType intValue] == 0  )
    {
        //卡类型Logo
        [_imageMembershipCardIcon setImage:[UIImage imageNamed:@"image_membershipCard.png"]];
    }
    else
    {
        //票类型Logo
        [_imageMembershipCardIcon setImage:[UIImage imageNamed:@"image_ticketType.png"]];
    }
    
     //如果 cardValidEndTime 该值 > 0，则说明用户买了该卡，并且该值为过期时间，并且是可以购卡的时显示 已开通
    if ([cardListModel.cardValidEndTime integerValue] > 0 && [cardListModel.cardValidEndTime integerValue] > [memberModel.currentTime integerValue])
    {
        //已开通
        //有效期
        [_labelExpiryDate setText:[NSString stringWithFormat:@"有效期至：%@",[Tool returnTime:cardListModel.cardValidEndTime format:@"yyyy年MM月dd日"]]];
        
        //计算高度
        if ([cardListModel.cardType intValue] != -1)
        {
            //其他会员
            _viewMembershipCardCellBG.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, 115);
            
            _imageMembershipCardIcon.frame = CGRectMake(15, 44, 27, 27);
            
            _btnMembershipCardType.frame = CGRectMake(SCREEN_WIDTH-15-15-60-15, 45, 60, 24);
            
            float fCardNameWidth = _viewMembershipCardCellBG.frame.size.width-15-_imageMembershipCardIcon.frame.size.width-15-15-_btnMembershipCardType.frame.size.width-15;
            _labelMembershipCardName.frame = CGRectMake(_imageMembershipCardIcon.frame.origin.x+_imageMembershipCardIcon.frame.size.width+15, 30, fCardNameWidth, 15);
            _labelMembershipCardDescribe.frame = CGRectMake(_labelMembershipCardName.frame.origin.x, _labelMembershipCardName.frame.origin.y+_labelMembershipCardName.frame.size.height+10, _labelMembershipCardName.frame.size.width, 12);
            
            _labelExpiryDate.frame = CGRectMake(_labelMembershipCardName.frame.origin.x,  _labelMembershipCardDescribe.frame.origin.y+_labelMembershipCardDescribe.frame.size.height+10, _labelMembershipCardName.frame.size.width, 11);
        }
        [_btnMembershipCardType setTitle:@"已开通" forState:UIControlStateNormal];
        [_btnMembershipCardType setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
        [_btnMembershipCardType setBackgroundColor:[UIColor clearColor]];
        [_btnMembershipCardType setUserInteractionEnabled:NO];//按钮不可点击
    }
    else
    {
        [_btnMembershipCardType setUserInteractionEnabled:YES];//按钮可点击
        //未开通
        //计算高度
        if ([cardListModel.cardType intValue] != -1)
        {
            //其他会员
            _btnMembershipCardType.frame = CGRectMake(SCREEN_WIDTH-15-15-60-15, 35.5, 60, 24);
            [_btnMembershipCardType setTitle:@"去看看" forState:UIControlStateNormal];
            [_btnMembershipCardType setBackgroundColor:RGBA(117, 112, 255, 1)];
        }
        
        _viewMembershipCardCellBG.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, 95);
        _imageMembershipCardIcon.frame = CGRectMake(15, 34, 27, 27);
        
        float fCardNameWidth = _viewMembershipCardCellBG.frame.size.width-15-_imageMembershipCardIcon.frame.size.width-15-15-_btnMembershipCardType.frame.size.width-15;
        _labelMembershipCardName.frame = CGRectMake(_imageMembershipCardIcon.frame.origin.x+_imageMembershipCardIcon.frame.size.width+15, 30, fCardNameWidth, 15);
        _labelMembershipCardDescribe.frame = CGRectMake(_labelMembershipCardName.frame.origin.x, _labelMembershipCardName.frame.origin.y+_labelMembershipCardName.frame.size.height+10, _labelMembershipCardName.frame.size.width, 12);
        
        [_btnMembershipCardType setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    }
    
    //根据登录状态，判断常规卡的显示
    if ( [Config getLoginState ] )
    {
        if ([cardListModel.cardType intValue] == -1)
        {
            //普通会员
            _viewMembershipCardCellBG.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, 95);
            
            _imageMembershipCardIcon.frame = CGRectMake(15, 34, 27, 27);
            
            _btnMembershipCardType.frame = CGRectMake(SCREEN_WIDTH-15-15-60-15, 35.5, 60, 24);
            
            float fCardNameWidth = _viewMembershipCardCellBG.frame.size.width-15-_imageMembershipCardIcon.frame.size.width-15-15-_btnMembershipCardType.frame.size.width-15;
            _labelMembershipCardName.frame = CGRectMake(_imageMembershipCardIcon.frame.origin.x+_imageMembershipCardIcon.frame.size.width+15, 30, fCardNameWidth, 15);
            _labelMembershipCardDescribe.frame = CGRectMake(_labelMembershipCardName.frame.origin.x, _labelMembershipCardName.frame.origin.y+_labelMembershipCardName.frame.size.height+10, _labelMembershipCardName.frame.size.width, 12);
            
            [_btnMembershipCardType setTitle:@"已开通" forState:UIControlStateNormal];
            [_btnMembershipCardType setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];
            [_btnMembershipCardType setBackgroundColor:[UIColor clearColor]];
            [_btnMembershipCardType setUserInteractionEnabled:NO];//按钮不可点击
        }
    }
    else
    {
        if ([cardListModel.cardType intValue] == -1)
        {
            //普通会员
            _viewMembershipCardCellBG.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, 95);
            
            _imageMembershipCardIcon.frame = CGRectMake(15, 34, 27, 27);

            _btnMembershipCardType.frame = CGRectMake(SCREEN_WIDTH-15-15-71-15, 35.5, 71, 24);
            
            float fCardNameWidth = _viewMembershipCardCellBG.frame.size.width-15-_imageMembershipCardIcon.frame.size.width-15-15-_btnMembershipCardType.frame.size.width-15;
            _labelMembershipCardName.frame = CGRectMake(_imageMembershipCardIcon.frame.origin.x+_imageMembershipCardIcon.frame.size.width+15, 30, fCardNameWidth, 15);
             _labelMembershipCardDescribe.frame = CGRectMake(_labelMembershipCardName.frame.origin.x, _labelMembershipCardName.frame.origin.y+_labelMembershipCardName.frame.size.height+10, _labelMembershipCardName.frame.size.width, 12);
            
            [_btnMembershipCardType setTitle:@"免费开通" forState:UIControlStateNormal];
            [_btnMembershipCardType setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
            [_btnMembershipCardType setBackgroundColor:RGBA(0, 0, 0, 1)];
            _btnMembershipCardType.tag = 1;

        }
    }
    
    //计算整体的Cell高度
    self.contentView.frame =CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, _viewMembershipCardCellBG.frame.size.height+10);
}

//跳转详情
-(void)onButtonMembershipCardDetails:(UIButton*)sender
{
    if ([_cardListModel.cardType intValue] != -1)
    {
        //其他会员
       [MobClick event:mainViewbtn67];
    }
    else
    {
        //常规卡会员
       [MobClick event:mainViewbtn61];
    }

    if ([self.cardListGotoDelegate respondsToSelector:@selector(cardTableViewCellSkip:index:)])
    {
        [self.cardListGotoDelegate cardTableViewCellSkip:sender index:_index];
    }
}


@end
