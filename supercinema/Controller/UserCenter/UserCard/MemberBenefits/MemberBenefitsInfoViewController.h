//
//  MemberBenefitsInfoViewController.h
//  supercinema
//
//  Created by mapollo91 on 25/11/16.
//
//

#import <UIKit/UIKit.h>
#import "MemberBenefitsInfoTableViewCell.h"
#import "MembershipCardDetailsViewController.h"
#import "ServicesCardPack.h"
#import "CardPackModel.h"
#import "BuyCardViewController.h"


@interface MemberBenefitsInfoViewController : HideTabBarViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, MemberBenefitsInfoCellDelegate,UIAlertViewDelegate>
{
    UIScrollView        *_scrollView;
    
    //有效 & 失效 按钮
    UIButton            *_btnEffective;
    UIButton            *_btnFailure;
    BOOL                isLoadAllPastDueCard;
    
    //按钮下的蓝色线
    UIView              *_viewLine;
    
    //有效 & 失效 View
    UIView              *_viewEffective;
    UIView              *_viewFailure;
    
    //有效 & 失效 列表
    UITableView         *_tableviewAllValid;
    UITableView         *_tableviewAllPastDue;

    //删除按钮状态
    UIButton            *_btnDeleteType;
    UIView              *_viewConfirmDeleteBG;
    //确定删除按钮
    UIButton            *_btnConfirmDelete;
    //删除显示状态
    BOOL                isShowDeleteButton;
    //当前页面
    int                 _iCurrentPageNumber;
    
    
    CardPackAllValidModel        *_cardPackAllValidModel;
    CardPackAllPastDueModel      *_cardPackAllPastDueModel;
    CardListModel                *_cardListModel;
    
    NSString                     *_strCinemaId;
    
    NSMutableArray               *_arrayAllValid;
    NSMutableArray               *_arrayAllPastDue;

    NSMutableArray               *_arrDelete;
    
    NSNumber                     *_cinemaId;
    
    int                         nTipStatus;
    
    BOOL                        isAllPastDue;
    
}





@end
