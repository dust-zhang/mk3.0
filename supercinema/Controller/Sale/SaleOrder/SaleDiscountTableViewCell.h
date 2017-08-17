//
//  SaleDiscountTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/16.
//
//

#import <UIKit/UIKit.h>
#import "RedPacketModel.h"

typedef enum{
    indexSaleFirst = 0,
    indexSaleMiddle = 1,
    indexSaleLast = 2,
    indexSaleOnly = 3
}SaleCellIndex;

@protocol SaleDiscountTableViewCellDelegate<NSObject>
@optional
-(void)isUsePacket:(BOOL)isPlus packetModel:(RedPacketListModel*)model cellModel:(RedPacketCellModel*)cellModel;
@end

@interface SaleDiscountTableViewCell : UITableViewCell
{
    UIImageView*            _imageLogo;
    UILabel*                _labelName;
    UILabel*                _labelLeft;
    UILabel*                _labelLeftCount;
    UILabel*                _labelEndDate;
    UILabel*                _labelDetail;
    
    UIButton*               _btnMinus;
    UIButton*               _btnPlus;
    UILabel*                _labelCount;
    
    UIImageView*            _imgLine;
    UILabel*                _labelSaleCount;
    
    UIView              *_viewAlpha;
    UIImageView         *_imgCommon;
    RedPacketListModel*     _packetModel;
    RedPacketCellModel*     _redPacketCellModel;
}
@property(nonatomic, weak) id<SaleDiscountTableViewCellDelegate>  cellDelegate;
//初始化cell类
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
//设置红包数据
- (void)setPacketData:(RedPacketListModel*)model cellModel:(RedPacketCellModel*)cellModel cellIndex:(SaleCellIndex)index;
//设置红包frame
-(void)layoutPacket:(SaleCellIndex)index;

@end
