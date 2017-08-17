//
//  OrderDiscountTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/12.
//
//

#import <UIKit/UIKit.h>
#import "RedPacketModel.h"
#import "BuildOrderModel.h"
#import "MemberModel.h"
#import "SmallSaleModel.h"

typedef enum{
    indexFirst = 0,
    indexMiddle = 1,
    indexLast = 2,
    indexOnly = 3
}CellIndex;

@protocol OrderDiscountTableViewCellDelegate<NSObject>
@optional
-(void)isUsePacket:(BOOL)isPlus packetModel:(RedPacketListModel*)model cellModel:(RedPacketCellModel*)cellModel;
@end

@interface OrderDiscountTableViewCell : UITableViewCell
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
    UIImageView*            _imgCommon;

    UIView              *_viewAlpha;

    RedPacketListModel*     _packetModel;
    RedPacketCellModel*     _redPacketCellModel;
}
@property(nonatomic, weak) id<OrderDiscountTableViewCellDelegate>  cellDelegate;
//初始化cell类
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
//设置红包数据
- (void)setPacketData:(RedPacketListModel*)model cellModel:(RedPacketCellModel*)cellModel cellIndex:(CellIndex)index;
//设置红包frame
-(void)layoutPacket:(CellIndex)index;
@end
