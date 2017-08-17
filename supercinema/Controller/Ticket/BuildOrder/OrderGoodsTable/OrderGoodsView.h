//
//  OrderGoodsView.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/12.
//
//

#import <UIKit/UIKit.h>
#import "OrderTicketView.h"
#import "OrderGoosTableViewCell.h"

typedef enum{
    discountHave= 1,
    discountNone= 2,
    discountSelected = 3
}DiscountType;

@protocol OrderGoodsViewDelegate <NSObject>

-(void)showDiscountView;

@end

@interface OrderGoodsView : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView* _table;
    NSArray         *_arrGoods;       //选中的小卖集合
    BuildOrderModel *_orderModel;
    BOOL    keyboardShowing;
    BOOL    isShowKeyboard;
    
    CGFloat _tableHeight;
    UIScrollView* _scroll;
    OrderTicketView* _ticketView;
    
    float   _totalPrice;
    //权益优惠
    UIView* _viewDiscount;
    UILabel* _labelDiscount;
    UILabel* _labelHaveDiscount;
    UIImageView* _imageArrow;
    
    //手机号码
    UIView* _viewPhone;
    UILabel* _labelPhone;
    UILabel* _labelDefault;
    UITextField* _textField;
    UIButton* _btnCancel;
}
@property(nonatomic,strong)NSString*  strTel;
@property(nonatomic) DiscountType discountType;
@property(nonatomic,weak) id<OrderGoodsViewDelegate> showDelegate;
-(id)initWithFrame:(CGRect)frame arrSale:(NSArray*)array orderModel:(BuildOrderModel*)model discountType:(DiscountType)type price:(float)price;
-(void)refreshData:(DiscountType)type;
-(void)showKeyBoard;
@end
