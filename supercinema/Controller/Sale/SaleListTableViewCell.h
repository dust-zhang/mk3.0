//
//  SaleListTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/16.
//
//

#import <UIKit/UIKit.h>
#import "SnackModel.h"
#import "LPLabel.h"

@protocol SaleListTableViewCellDelegate<NSObject>
@optional
-(void)changeValue:(SnackListModel*)saleModel isPlus:(BOOL)isPlus curIndex:(NSInteger)curIndex;
-(void)showSaleDetail:(SnackListModel*)saleModel curIndex:(NSInteger)curIndex;
@end

@interface SaleListTableViewCell : UITableViewCell
{
    UILabel*        _labelSaleName;
//    UILabel*        _labelHaveDiscount;
    //    UILabel*        _labelOnlyLeft;
    UILabel*        _labelSaleDetail;
//    UILabel*        _labelFirst;
    LPLabel*        _labelFirstPrice;
//    UILabel*        _labelSecond;
    UILabel*        _labelSecondPrice;
    
    SnackListModel* _smallSaleModel;
    
    UIView*         _viewBlank;
}
@property(nonatomic, weak) id<SaleListTableViewCellDelegate>  saleCellDelegate;
@property(nonatomic, assign) NSInteger curIndexPath;
@property(nonatomic, strong) UIView*   backView;
@property(nonatomic, strong) UIButton* btnLogo;
@property(nonatomic, strong) UIButton* btnPlus;
@property(nonatomic, strong) UIButton* btnMinus;
@property(nonatomic, strong) UILabel*  labelCount;
//初始化cell类
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
-(void)setCellData:(SnackListModel*)model;
-(void)setCellFrame:(NSInteger)index isLast:(BOOL)isLast;
@end
