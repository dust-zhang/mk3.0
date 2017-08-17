//
//  OrderTicketView.h
//  supercinema
//
//  Created by Mapollo28 on 2016/12/16.
//
//

#import <UIKit/UIKit.h>
#import "BuildOrderModel.h"

@interface OrderTicketView : UIView
{
    UIView* _backView;
    UIImageView* _imageLogo;
    UILabel* _labelName;
    UILabel* _labelDetail;
    UIView* _viewTicket;
    UILabel* _labelCount;
    UIImageView* _viewLine;
    UILabel* _labelService;
    UILabel* _labelSum;
    UILabel* _labelSumPrice;
    
    NSArray* _arrSeat;
    UILabel* _labelTicket[4];
}
-(id)initWithFrame:(CGRect)frame;
-(void)setData:(BuildOrderModel *)orderModel;
-(void)layoutFrame;
@end
