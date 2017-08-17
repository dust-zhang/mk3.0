//
//  CouponInfoTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 26/11/16.
//
//

#import <UIKit/UIKit.h>

@protocol CouponInfoTableViewCellDelegate <NSObject>
-(void)deleteCardCellDataId:(NSNumber *)cellDataId couponType:(NSNumber *)couponType isSelected:(BOOL)isSelected;
@end

@interface CouponInfoTableViewCell : UITableViewCell
{
    UIView          *_viewWhiteBg;
    
    //优惠券Logo
    UIImageView     *_imageLogo;
    //金额
    UILabel         *_labelPrice;
    //名称
    UILabel         *_labelName;
    //个数
    UILabel         *_labelCount;
    //有效期
    UILabel         *_labelDate;
    //激活标识
    UIImageView     *_imageActiveStatus;
    //通用标识
    UIImageView     *_imageGeneralType;
    //影院名称
    UILabel         *_labelCinemaName;
    //删除按钮
    UIButton        *_btnDelete;
    
    //失效的蒙版
    UIView          *_viewMask;
}

@property (nonatomic, strong)CommonListModel        *_commonListModel;
@property (nonatomic, strong)NewsCommonListModel    *orderModel;

@property (nonatomic, weak) id<CouponInfoTableViewCellDelegate> couponInfoDelegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

//优惠券Cell
-(void)setCouponInfoCellFrameDataCommonListModel:(CommonListModel *)commonListModel index:(NSInteger)indexPath boolDeleteButtonShow:(BOOL)boolDeleteButtonShow isPastDue:(BOOL)isPastDue;


@end
