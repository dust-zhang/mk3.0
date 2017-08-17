//
//  TicketDescribeTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 19/11/16.
//
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface TicketDescribeTableViewCell : UITableViewCell
{
    //背景
    UIView          *_viewInformationBG;
    
    //序列号 & 验证码
    UILabel         *_labelNumber;
    UILabel         *_labelCode;
    UILabel         *_labelExchangeInfo;    //取票说明
    
    //退款状态 & 客服时间
    UILabel         *_labelReimburseType;
    UILabel         *_labelServicePhone;
    
    UIImageView     *_imageLogo;
    UILabel         *_labelName;
    UILabel         *_labelMovieTpye;   //电影类型
    UILabel         *_labelDetail;      //描述
    UIImageView     *_imageLine;        //分割线
    
    UIView          *_viewTicket;       //座位
    UILabel         *_labelCount;       //数量
    UILabel         *_labelFee;         //服务费
    
    NSArray         * _arrSeat;
    UILabel         *_labelTicket[4];   //座位的Label

}

//初始化（自定义）
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

//票Cell
-(void)setTicketDescribeCellFrameData:(OnlineTicketsModel *)model orderWhileModel:(OrderWhileModel *)orderWhileModel;

@end
