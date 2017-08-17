//
//  OrderDiscountCardTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/21.
//
//

#import <UIKit/UIKit.h>
#import "BuildOrderModel.h"
#import "MemberModel.h"
#import "RedPacketModel.h"
#import "OrderDiscountTableViewCell.h"

//typedef enum{
//    indexFirst = 0,
//    indexMiddle = 1,
//    indexLast = 2,
//    indexOnly = 3
//}CellIndex;

@protocol OrderDiscountCardTableViewCellDelegate<NSObject>
@optional
-(void)isUseCard:(BOOL)isUse cardModel:(CardStateModel*)cardModel;
-(void)showTongPiaoDetail:(NSNumber*)tongpiaoId;
@end

@interface OrderDiscountCardTableViewCell : UITableViewCell
{
    UIImageView*            _imageLogo;
    UILabel*                _labelName;
    UILabel*                _labelLeft;
    UILabel*                _labelLeftCount;
    UILabel*                _labelEndDate;
    UILabel*                _labelDetail;
    UILabel*                _labelUseCount;
    UIButton*               _btnCard;
    UILabel*                _labelCount;
    UIButton*               _btnDetail;
    UIImageView*            _imgArrow;
    UIImageView*            _imgLine;
    
    UIView              *_viewAlpha;
    
    CardStateModel*         _cardModel;
    NSNumber*               _tongpiaoId;           //通票id
    NSInteger               _cardType;
}
@property(nonatomic, weak) id<OrderDiscountCardTableViewCellDelegate>  cellDelegate;
//初始化cell类
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
//设置次卡、任看卡、套票数据
-(void)setCardData:(cinemaCardItemListModel*)model cardStateModel:(CardStateModel*)sModel cellIndex:(CellIndex)index;
//设置次卡、任看卡、套票frame
-(void)layoutCard:(CellIndex)index;
@end
