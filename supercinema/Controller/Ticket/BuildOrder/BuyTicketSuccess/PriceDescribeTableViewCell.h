//
//  PriceDescribeTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 19/11/16.
//
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface PriceDescribeTableViewCell : UITableViewCell
{
    //背景
    UIView          *_viewInformationBG;
    
    //实付金额
    UILabel         *_labelReal;
    UILabel         *_labelRealPrice;

    //分割线
    UILabel         *_labelLine;
    
    //合计金额
    UILabel         *_labelSum;
    UILabel         *_labelSumPrice;
    
    //抵扣金额
    UILabel         *_labelDicount;
    UILabel         *_labelDicountPrice;
}

//初始化（自定义）
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//金额Cell
-(void)setPriceDescribeCellFrameData:(OrderInfoModel *)model;

@end
