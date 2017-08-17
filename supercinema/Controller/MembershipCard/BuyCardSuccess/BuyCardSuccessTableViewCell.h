//
//  BuyCardSuccessTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 16/11/16.
//
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface BuyCardSuccessTableViewCell : UITableViewCell
{
    //背景
    UIView          *_viewBasicInformationBG;
    UIView          *_viewDetailsBG;
    
    
    UIImageView     *_imageCardLogo;
    UILabel         *_labelCardName;    //卡Logo
    UILabel         *_labelCinemaName;  //影院名称
    UILabel         *_labelDate;        //有效期
    UIImageView     *_imageLine;        //分割线
    UILabel         *_labelDateUpTo;    //截至日期
    UILabel         *_labelSubtotal;    //小计：金额
    
    //实付金额
    UILabel         *_labelReal;
    UILabel         *_labelRealPrice;
    UILabel         *_labelLine;
    
    //合计金额
    UILabel         *_labelSum;
    UILabel         *_labelSumPrice;
    
    //抵扣金额
    UILabel         *_labelDicount;
    UILabel         *_labelDicountPrice;
}

@property(nonatomic, strong)OrderInfoModel  *_modelOrderInfo;


//初始化（自定义）
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//购买成功详情Cell
-(void)setBuyCardSuccessDetailsCellFrameData:(CardOrderModel *)orderModel;


@end
