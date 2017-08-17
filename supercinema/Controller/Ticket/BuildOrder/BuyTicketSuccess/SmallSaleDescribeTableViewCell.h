//
//  SmallSaleDescribeTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 19/11/16.
//
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

//#define editWidthHegiht     40
//#define inputTextCount      5
//#define posX    (SCREEN_WIDTH-editWidthHegiht*4)/2

@protocol SmallSaleDescribeCellDelegate <NSObject>

-(void)onButtonReceiveSmallSale:(NSString *)goodsOrderId exchangeType:(NSNumber *)exchangeType Index:(NSInteger)index;

@end

@interface SmallSaleDescribeTableViewCell : UITableViewCell
{
    //背景
    UIView          *_viewInformationBG;
    
    //领取按钮
    UIButton        *_btnReceive;
    //提示
    UILabel         *_labelPrompt;
    
    //退款状态 & 客服时间
    UILabel         *_labelReimburseType;
    UILabel         *_labelServicePhone;
    
    UIImageView     *_imageLogo;
    UILabel         *_labelName;
    UILabel         *_labelDetail;      //描述
    UIImageView     *_imageLine;        //分割线
    
    UILabel         *_labelCount;       //数量
    
    UIImageView     *_imageLine1;
    
    //有效期
    UILabel         *_labelDate;
    
    GoodsListCardPackModel  *_goodsListCardPackModel;
    
}
@property(nonatomic, strong)CouponInfoModel *_couponModel;
@property(nonatomic, strong)NSString        *_strGoodsOrderId;
@property(nonatomic, weak)id<SmallSaleDescribeCellDelegate> smallSaleCellDelegate;

//初始化（自定义）
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//小卖Cell
-(void)setSmallSaleDescribeCellFrameData:(GoodsListCardPackModel *)model orderWhileModel:(OrderWhileModel *)orderWhileModel;

-(void)setIndex:(NSInteger)index;


@end
