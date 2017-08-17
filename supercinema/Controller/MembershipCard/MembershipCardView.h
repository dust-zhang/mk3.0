//
//  MembershipCardView.h
//  supercinema
//
//  Created by mapollo91 on 7/11/16.
//
//

#import <UIKit/UIKit.h>
#import "MembershipCardTableViewCell.h"
#import "BuyCardViewController.h"
#import "MembershipCardDetailsViewController.h"
#import "LoginViewController.h"

@interface MembershipCardView : UIView <UITableViewDelegate, UITableViewDataSource, MembershipCardTableViewCellDelegate>
{
    MemberModel         *_modelMember;
    NSMutableArray      *_arrayCardTable;
    
    UIImageView         *_imageLoadFailed;
    UILabel             *_labelDescLoadFailed;
    
    //加载失败
    UIImageView             *_imageFailure;
    UILabel                 *_labelFailure;
    UIButton                *_btnTryAgain;
}

-(id)initWithFrame:(CGRect)frame navigation:(UINavigationController *)navigation;
//清理缓存数据
-(void)removeAllObjectsCardTable;

@property(nonatomic,strong)UINavigationController* navigation;
@property(nonatomic,strong)UITableView *tabViewMembershipCard;   //整体的tableView
@property(nonatomic,assign)BOOL                _isScrollTop;
@property(nonatomic,assign)CGFloat _lastScrollContentOffset;
@end
