//
//  OrderSaleTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/16.
//
//

#import <UIKit/UIKit.h>
#import "SnackModel.h"



@interface OrderSaleTableViewCell : UITableViewCell
{
//    UIImageView* _imageLogo;
    UILabel*    _labelName;
    UILabel*    _labelDetail;
    UILabel*    _labelCount;
//    UILabel*    _labelCardName;
    UILabel*    _labelHeji;
    UILabel*    _labelHejiPrice;
    UIImageView*    _imageLine;
    UILabel*    _labelEndDate;
}
//初始化cell类
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
-(void)setCellData:(SnackListModel*)model isLast:(BOOL)isLast price:(float)price;
-(void)setCellFrame:(BOOL)isLast;
@end
