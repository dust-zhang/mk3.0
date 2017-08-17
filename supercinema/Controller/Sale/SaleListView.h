//
//  SaleListView.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/16.
//
//

#import <UIKit/UIKit.h>
#import "SaleListTableViewCell.h"
#import "SaleOrderViewController.h"
#import "LoginViewController.h"
#import "LPLabel.h"
#import "SYFireworksButton.h"
#import "ParabolaTool.h"
#import <objc/runtime.h>
#import "SYFireworksView.h"

@interface SaleListView : UIView<UITableViewDelegate,UITableViewDataSource,SaleListTableViewCellDelegate,ParabolaToolDelegate>
{
    NSInteger       _currentIndex;
    
    int             _totalCount;
    
    CGFloat         _detailViewWidth;
    CGFloat         _detailViewHeight;
    
    //小卖详情view
    UIView*         _viewSaleDetail;
    UIView*         _viewDetailAlpha;
    UIImageView*    _imageSaleDetail;
    UIImageView*    _imageSaleDetailShadow;
    UILabel*        _labelSaleName;
    UILabel*        _labelSaleDetail;
    UILabel*        _labelCardName;
    UILabel*        _labelMemberPrice;
    LPLabel*        _labelOriginPrice;
    UIButton*       _btnSalePlus;
    UIButton*       _btnSaleMinus;
    UILabel*        _labelSaleCount;
    
    float           _delayTime;
    
    //加载失败
    UIImageView             *_imageFailure;
    UILabel                 *_labelFailure;
    UIButton                *_btnTryAgain;
}
@property(nonatomic,strong) UITableView* myTable;
@property(nonatomic,strong) SYFireworksButton* btnPay;
@property(nonatomic,strong) UINavigationController* _nav;
@property(nonatomic,strong) NSArray* arrSnack;
@property(nonatomic,strong) NSMutableArray* arrSnackPrice;
@property(nonatomic,assign)BOOL                _isScrollTop;
@property(nonatomic,assign)CGFloat _lastScrollContentOffset;
@property(nonatomic,strong)UIImageView* imgDefault;
@property(nonatomic,strong)UILabel* labelDefault;
@property (nonatomic,strong)UIImageView *redView;
-(id)initWithFrame:(CGRect)frame navigation:(UINavigationController *)navigation;
-(void)loadData;
-(void)removeAllData;
@end
