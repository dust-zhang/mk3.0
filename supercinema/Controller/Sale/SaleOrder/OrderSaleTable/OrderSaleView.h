//
//  OrderSaleView.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/16.
//
//

#import <UIKit/UIKit.h>
#import "OrderSaleTableViewCell.h"
typedef enum{
    typeHave= 1,
    typeNone= 2,
    typeSelected = 3
}TypeDiscount;

@protocol OrderSaleViewDelegate <NSObject>

-(void)showDiscountView;

@end

@interface OrderSaleView : UIView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>
{
    UIScrollView* _scroll;
    UITableView* _table;
    NSArray         *_arrGoods;       //选中的小卖集合
    BOOL    keyboardShowing;
    float   _totalPrice;
    CGFloat _tableHeight;
    
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
    
    NSMutableArray  *_arrCellHeight;
}
@property(nonatomic,strong)NSString*  strTel;
@property(nonatomic) TypeDiscount discountType;
@property(nonatomic,weak) id<OrderSaleViewDelegate> showDelegate;
-(id)initWithFrame:(CGRect)frame arrSale:(NSArray*)array price:(float)price;
-(void)refreshDiscount:(TypeDiscount)type;
-(void)showKeyBoard;
@end
