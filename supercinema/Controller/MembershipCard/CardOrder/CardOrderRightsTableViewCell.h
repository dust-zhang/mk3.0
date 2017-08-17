//
//  CardOrderRightsTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 12/11/16.
//
//

#import <UIKit/UIKit.h>
#import "RedPacketModel.h"

@protocol CardOrderRightsTableViewCellDelegate<NSObject>
@optional
-(BOOL)changeredPacketValue:(RedPacketCellVO *)redPacketCellModel isMinu:(BOOL)isMinu;
@end

@interface CardOrderRightsTableViewCell : UITableViewCell
{
    UIImageView         *_imageRedPacketLogo;
    //红包的钱
    UILabel             *_labelRedPacketPrice;
    //红包名称
    UILabel             *_labelRedPacketName;
    //红包总数量
    UILabel             *_labelRedPackeAllCount;
    
    //加号按钮
    UIButton            *_btnPlus;
    UIView              *_btnPlusViewAlpha;
    //减号按钮
    UIButton            *_btnMinus;
    UIView              *_btnMinusViewAlpha;
    //加减后的个数
    UILabel             *_labelCount;
    
    //权益描述
    UILabel             *_labelRightDescribe;
    //有效期
    UILabel             *_labelDate;
    
    //是否通用（红包）
    UIImageView         *_imageCommonIcon;
    //分割线
    UIImageView         *_imageLine;
    
    //红包Cell的数据
    RedPacketCellVO     *_redPacketCellModel;
    
    int isCount ;
    
    NSInteger           _currentIndexPath;
    NSIndexPath         *_indexPath;
}

@property(nonatomic,strong) UIView   *_viewAlpha;
@property(nonatomic, weak) id<CardOrderRightsTableViewCellDelegate> orderCellDelegate;

//初始化控件
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
//设置红包数据
- (void)setPacketData:(RedPacketCellVO*)cellModel;
//设置红包frame
-(void)layoutPacket:(NSInteger)indexPath isShowMore:(BOOL)isShow;

@end
