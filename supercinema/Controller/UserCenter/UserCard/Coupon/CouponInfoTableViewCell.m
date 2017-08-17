//
//  CouponInfoTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 26/11/16.
//
//

#import "CouponInfoTableViewCell.h"

@implementation CouponInfoTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:RGBA(246, 246, 251, 1)];
        self._commonListModel = [[CommonListModel alloc] init];
        
        [self initController];
    }
    return self;
}

-(void)initController
{
    _viewWhiteBg = [[UIView alloc] initWithFrame:CGRectZero];
    [_viewWhiteBg setBackgroundColor:[UIColor whiteColor]];
    [_viewWhiteBg.layer setBorderWidth:1];
    [_viewWhiteBg.layer setBorderColor:RGBA(233, 233, 238,1).CGColor];
    [self.contentView addSubview:_viewWhiteBg];
    
    //优惠券Logo
    _imageLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageLogo.backgroundColor = [UIColor clearColor];
    [_viewWhiteBg addSubview:_imageLogo];
    
    //金额
    _labelPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelPrice setBackgroundColor:[UIColor clearColor]];
    [_labelPrice setFont:MKFONT(20)];
    [_labelPrice setTextColor:RGBA(249, 81, 81, 1)];
    [_labelPrice setTextAlignment:NSTextAlignmentLeft];
    [_viewWhiteBg addSubview:_labelPrice];
    
    //名称
    _labelName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelName setBackgroundColor:[UIColor clearColor]];
    [_labelName setFont:MKFONT(15)];
    [_labelName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [_viewWhiteBg addSubview:_labelName];

    //个数
    _labelCount = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelCount setBackgroundColor:[UIColor clearColor]];
    [_labelCount setFont:MKFONT(14)];
    [_labelCount setTextColor:RGBA(50, 50, 50, 1)];
    [_labelCount setTextAlignment:NSTextAlignmentLeft];
    [_viewWhiteBg addSubview:_labelCount];

    //有效期
    _labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelDate setBackgroundColor:[UIColor clearColor]];
    [_labelDate setFont:MKFONT(11)];
    [_labelDate setTextColor:RGBA(123, 122, 152, 1)];
    [_labelDate setTextAlignment:NSTextAlignmentLeft];
    
    [_viewWhiteBg addSubview:_labelDate];
    
    //激活标识
    _imageActiveStatus = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageActiveStatus setBackgroundColor:[UIColor clearColor]];
    [_imageActiveStatus setImage:[UIImage imageNamed:@"image_activeStatus.png"]];
    _imageActiveStatus.hidden = YES;
    [_viewWhiteBg addSubview:_imageActiveStatus];
    
    //通用标识
    _imageGeneralType = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageGeneralType setBackgroundColor:[UIColor clearColor]];
    [_imageGeneralType setImage:[UIImage imageNamed:@"image_sharing.png"]];
    _imageGeneralType.hidden = YES;
    [_viewWhiteBg addSubview:_imageGeneralType];
    
    //影院名称
    _labelCinemaName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelCinemaName setBackgroundColor:[UIColor clearColor]];
    [_labelCinemaName setFont:MKFONT(12)];
    [_labelCinemaName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelCinemaName setTextAlignment:NSTextAlignmentLeft];
    [_viewWhiteBg addSubview:_labelCinemaName];
    
    //失效的蒙版
    _viewMask = [[UIView alloc] initWithFrame:CGRectZero];
    _viewMask.backgroundColor = RGBA(255, 255, 255, 0.5);
    _viewMask.hidden = YES;
    [_viewWhiteBg addSubview:_viewMask];
    
    //删除按钮
    _btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15*3-21, 40, 21, 21)];
    [_btnDelete setBackgroundImage:[UIImage imageNamed:@"btn_card_select_not.png"] forState:UIControlStateNormal];//没勾选
    _btnDelete.hidden = YES;
    _btnDelete.tag = 1234567;
    [_btnDelete addTarget:self action:@selector(onButtonDelete:) forControlEvents:UIControlEventTouchUpInside];
    [_viewWhiteBg addSubview:_btnDelete];
    
}

-(void)setCouponInfoCellFrameDataCommonListModel:(CommonListModel *)commonListModel index:(NSInteger)indexPath boolDeleteButtonShow:(BOOL)boolDeleteButtonShow isPastDue:(BOOL)isPastDue
{
    self._commonListModel = commonListModel;
    objc_setAssociatedObject(_btnDelete, "model", self._commonListModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //2:则是线下优惠券; 5:票红包; 6:会员卡红包; 7:小卖红包; 8:商家优惠券;
    if ([commonListModel.dataType intValue] == 2 ||
        [commonListModel.dataType intValue] == 3 ||
        [commonListModel.dataType intValue] == 8 )
    {
        //优惠券类型
        _viewWhiteBg.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, 120);

        //Logo
        _imageLogo.frame = CGRectMake(15, 46.5, 27, 27);
        [_imageLogo setImage:[UIImage imageNamed:@"image_coupon.png"]];
        
        //名称
        _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, 30, 30, 15);
        _labelName.text = commonListModel.couponInfo.couponName;
        [_labelName sizeToFit];
        _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, 30, _labelName.frame.size.width, 15);

        //个数
        _labelCount.frame = CGRectMake(_labelName.frame.origin.x+_labelName.frame.size.width+5, 31, 30, 14);
        _labelCount.text = [NSString stringWithFormat:@"x%d",[commonListModel.couponInfo.quantity intValue]];
        [_labelCount sizeToFit];
        _labelCount.frame = CGRectMake(_labelName.frame.origin.x+_labelName.frame.size.width+5, 31, _labelCount.frame.size.width, 14);

        //影院名称
        _labelCinemaName.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+15, SCREEN_WIDTH/2, 12);
        _labelCinemaName.text = commonListModel.couponInfo.cinemaName;
        [_labelCinemaName sizeToFit];
        //显示屏宽的距离
        if (boolDeleteButtonShow == YES)
        {
            //显示出删除按钮
            _labelCinemaName.frame = CGRectMake(_labelName.frame.origin.x,  _labelName.frame.origin.y+_labelName.frame.size.height+15, _viewWhiteBg.frame.size.width-_imageLogo.frame.size.width-_btnDelete.frame.size.width-15*3, 12);
        }
        else
        {
            _labelCinemaName.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+15, _viewWhiteBg.frame.size.width-_imageLogo.frame.size.width-15*3, 12);
        }
        
        //有效期
        _labelDate.frame = CGRectMake(_labelName.frame.origin.x, _labelCinemaName.frame.origin.y+_labelCinemaName.frame.size.height+10, _viewWhiteBg.frame.size.width, 11);
        _labelDate.text = [NSString stringWithFormat:@"有效期至：%@",[Tool returnTime:commonListModel.couponInfo.validEndDate format:@"yyyy年MM月dd日"]];
        
        /***********************************************************/
        //激活标识
        _imageActiveStatus.frame = CGRectMake(_viewWhiteBg.frame.size.width-39.5, 0, 39.5, 39.5);
        //激活标识显示逻辑 1:已激活  0:未激活
        if ([commonListModel.couponInfo.activeStatus intValue] == 1)
        {
            //已激活
            _imageActiveStatus.hidden = YES;
        }
        else
        {
            //未激活 显示未激活标识
            _imageActiveStatus.hidden = NO;
        }
        //如果是3：成长体系 或者是8：商家优惠券
        if ([commonListModel.dataType intValue] == 3 ||
            [commonListModel.dataType intValue] == 8 )
        {
            //不牵着到激活，不显示激活标识
            _imageActiveStatus.hidden = YES;
        }
        /***********************************************************/
    }
    else if ([commonListModel.dataType intValue] == 5 ||
             [commonListModel.dataType intValue] == 6 ||
             [commonListModel.dataType intValue] == 7)
    {
        //红包类型
        _viewWhiteBg.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, 100);
        
        //Logo
        _imageLogo.frame = CGRectMake(15, 37, 27, 27);
        [_imageLogo setImage:[UIImage imageNamed:@"image_redPacket.png"]];
        
        //金额
        _labelPrice.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+12, 30, 30, 20);
        //_labelPrice.text = [NSString stringWithFormat:@"￥%d",[commonListModel.couponInfo.worth intValue]/100];
        _labelPrice.text = [NSString stringWithFormat:@"¥%@",[Tool PreserveTowDecimals:commonListModel.couponInfo.worth]];
        [_labelPrice sizeToFit];
        _labelPrice.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+12, 30, _labelPrice.frame.size.width, 20);
        
        //名称
        _labelName.frame = CGRectMake(_labelPrice.frame.origin.x+_labelPrice.frame.size.width+5, 35, 30, 15);
        _labelName.text = commonListModel.couponInfo.couponName;
        [_labelName sizeToFit];
        _labelName.frame = CGRectMake(_labelPrice.frame.origin.x+_labelPrice.frame.size.width+5, 35, _labelName.frame.size.width, 15);
        
    
        //个数
        _labelCount.frame = CGRectMake(_labelName.frame.origin.x+_labelName.frame.size.width+5, 36, 30, 14);
        _labelCount.text = [NSString stringWithFormat:@"x%d",[commonListModel.couponInfo.quantity intValue]];
        [_labelCount sizeToFit];
        _labelCount.frame = CGRectMake(_labelName.frame.origin.x+_labelName.frame.size.width+5, 36, _labelCount.frame.size.width, 14);
        
//        //显示屏宽的距离
//        if (boolDeleteButtonShow == YES)
//        {
//            //显示出删除按钮
//            _labelCount.frame = CGRectMake(_labelName.frame.origin.x+_labelName.frame.size.width+5, 36, _viewWhiteBg.frame.size.width-15*3-_imageLogo.frame.size.width-_labelPrice.frame.size.width-_labelName.frame.size.width-_btnDelete.frame.size.width, 14);
//        }
//        else
//        {
//            _labelCount.frame = CGRectMake(_labelName.frame.origin.x+_labelName.frame.size.width+5, 36, _viewWhiteBg.frame.size.width-15*3-_imageLogo.frame.size.width-_labelPrice.frame.size.width-_labelName.frame.size.width, 14);
//        }
        
        //激活标识
        _imageActiveStatus.frame = CGRectMake(_viewWhiteBg.frame.size.width-39.5, 0, 39.5, 39.5);
        
        //通用红包标识
        _imageGeneralType.frame = CGRectMake(_viewWhiteBg.frame.size.width-35, 55, 35, 15);
        
        //有效期
        _labelDate.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, _labelPrice.frame.origin.y+_labelPrice.frame.size.height+15, _viewWhiteBg.frame.size.width/2, 11);
        _labelDate.text = [NSString stringWithFormat:@"有效期至：%@",[Tool returnTime:commonListModel.couponInfo.validEndDate format:@"yyyy年MM月dd日"]];
        
        //激活标识显示逻辑 1:已激活  0:未激活
        if ([commonListModel.couponInfo.activeStatus intValue] == 1)
        {
            //已激活
            _imageActiveStatus.hidden = YES;
        }
        else
        {
            //未激活
            _imageActiveStatus.hidden = NO;
        }
        
        //通用红包标识显示逻辑
        if ([commonListModel.couponInfo.common intValue] == 1)
        {
            _imageGeneralType.hidden = NO;
        }
        else
        {
            //false 为不通用
            _imageGeneralType.hidden = YES;
        }
    }
    else if ([commonListModel.dataType intValue] == 9)
    {
        //通票类型
        _viewWhiteBg.frame = CGRectMake(15, 10, SCREEN_WIDTH-15*2, 100);

        //Logo
        _imageLogo.frame = CGRectMake(15, 37, 27, 27);
        [_imageLogo setImage:[UIImage imageNamed:@"image_ticketType.png"]];

        //名称
        _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, 35, 30, 15);
        _labelName.text = commonListModel.cardInfo.cinemaCardName;
        [_labelName sizeToFit];
//        _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, 35, _labelName.frame.size.width, 15);
        
        //判断长度显示
        //显示屏宽的距离
        if (boolDeleteButtonShow == YES)
        {
            //显示出删除按钮
            _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, 35, _viewWhiteBg.frame.size.width-15*3-_imageLogo.frame.size.width-_btnDelete.frame.size.width, 15);
        }
        else
        {
            _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, 35, _viewWhiteBg.frame.size.width-15*3-_imageLogo.frame.size.width, 15);
        }
        
        //有效期
        _labelDate.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+15, SCREEN_WIDTH/2, 11);
        _labelDate.text = [NSString stringWithFormat:@"有效期至：%@",[Tool returnTime:commonListModel.cardInfo.cardValidEndTime format:@"yyyy年MM月dd日"]];
    }
    else
    {
    
    }
    
    if (boolDeleteButtonShow == YES)
    {
        //显示出删除按钮
        _imageGeneralType.hidden = YES;
        _btnDelete.hidden = NO;
    }
    else
    {
        //不显示删除按钮
        //通用红包标识显示逻辑
        if ([commonListModel.couponInfo.common boolValue] == 1)
        {
            _imageGeneralType.hidden = NO;
        }
        else
        {
            //false 为不通用
            _imageGeneralType.hidden = YES;
        }
        _btnDelete.hidden = YES;
    }

    if ([commonListModel.isDelete intValue] == 1)
    {
        _btnDelete.selected = NO;
        [_btnDelete setBackgroundImage:[UIImage imageNamed:@"btn_card_select_not.png"] forState:UIControlStateNormal];//没勾选
    }
    else
    {
        _btnDelete.selected = YES;
        [_btnDelete setBackgroundImage:[UIImage imageNamed:@"btn_card_select.png"] forState:UIControlStateNormal];//没勾选
    }
    
    if (isPastDue == YES)
    {
        //失效显示蒙层
        _viewMask.hidden = NO;
        _viewMask.frame = CGRectMake(0, 0, _viewWhiteBg.frame.size.width, _viewWhiteBg.frame.size.height);
    }
    else
    {
        //有效不显示蒙层
        _viewMask.hidden = YES;
    }
}

//勾选删除按钮
-(void)onButtonDelete:(UIButton*)button
{
    CommonListModel *model = objc_getAssociatedObject(button, "model");
    
    button.selected = !button.selected;

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
    if ([self.couponInfoDelegate respondsToSelector:@selector(deleteCardCellDataId:couponType:isSelected:)])
    {
        if ([model.dataType intValue] == 9)
        {
            [self.couponInfoDelegate deleteCardCellDataId:model.cardInfo.id couponType:model.dataType isSelected:button.selected];
        }
        else
        {
            [self.couponInfoDelegate deleteCardCellDataId:model.couponInfo.couponId couponType:model.dataType isSelected:button.selected];
        }
        
    }
}


@end
