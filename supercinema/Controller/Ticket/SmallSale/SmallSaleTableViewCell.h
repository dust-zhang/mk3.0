//
//  SmallSaleTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/10.
//
//

#import <UIKit/UIKit.h>
#import "SmallSaleModel.h"
#import "LPLabel.h"

@protocol SmallSaleTableViewCellDelegate<NSObject>
@optional
-(void)changeValue:(SmallSaleModel*)saleModel isPlus:(BOOL)isPlus;
@end

@interface SmallSaleTableViewCell : UITableViewCell
{
    UIView*         _backView;
    UIImageView*    _imageLogo;
    UILabel*        _labelSaleName;
    UILabel*        _labelHaveDiscount;
//    UILabel*        _labelOnlyLeft;
    UILabel*        _labelSaleDetail;
    UILabel*        _labelFirst;
    LPLabel*        _labelFirstPrice;
    UILabel*        _labelSecond;
    UILabel*        _labelSecondPrice;
    UILabel*        _labelCount;
    UIButton*       _btnPlus;
    UIButton*       _btnMinus;
    
    SmallSaleModel* _smallSaleModel;
}
@property(nonatomic, weak) id<SmallSaleTableViewCellDelegate>  saleCellDelegate;
//初始化cell类
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
-(void)setCellData:(SmallSaleModel*)model;
-(void)setCellFrame;
@end
