//
//  TicketOrderTableViewCell.h
//  supercinema
//
//  Created by dust on 16/11/24.
//
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"

@protocol  deleteTicketDelegate<NSObject>
-(void) onButtonDeleteOrder:(UIButton *)btn;
-(void) refreshUnPayOrder;
@end

@interface MyTicketOrderTableViewCell : UITableViewCell
{
    NSTimer             *_countTimer;
    NSInteger           _serviceTime;
    BOOL                _isRefresh;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic ,strong) UIImageView       *_labelCutLine1;
@property (nonatomic ,strong) UIImageView       *_labelCutLine2;
@property (nonatomic ,strong) UILabel       *_labelCinemaName;
@property (nonatomic ,strong) UILabel       *_labelPayStatus;
@property (nonatomic ,strong) UILabel       *_labelFilmName;
@property (nonatomic ,strong) UILabel       *_labelFilmDetail;
@property (nonatomic ,strong) UILabel       *_labelSum;
@property (nonatomic ,strong) UILabel       *_labelOrderNo;
@property (nonatomic ,strong) UIButton      *_btnDelete;

@property(nonatomic,assign) id <deleteTicketDelegate> _deleteTicketDelegate;

-(void) setOrderCellText:(MyOrderListModel*)model index:(NSInteger)cellIndex time:(NSNumber *)currentTime;

@end
