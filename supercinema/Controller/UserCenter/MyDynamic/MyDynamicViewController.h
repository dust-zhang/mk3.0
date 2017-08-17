//
//  MyDynamicViewController.h
//  supercinema
//
//  Created by Mapollo28 on 2016/12/2.
//
//

#import "HideTabBarViewController.h"
#import "MyDynamicTableViewCell.h"
#import "DynamicDetailViewController.h"
#import "OtherCenterViewController.h"

@interface MyDynamicViewController : HideTabBarViewController<UITableViewDelegate,UITableViewDataSource,MyDynamicTableViewCellDelegate,FDActionSheetDelegate,UIAlertViewDelegate>
{
    /*******test*******/
    NSMutableArray* _muArrType;
    NSArray*    _arrType;
    
    UITableView* _myTable;
    UserDynamicModel*   _dynModel;
    NSString*   _pageIndex;
    NSInteger   _curIndex;
    UIAlertView         *_alterView;
    
    FeedListModel* _curModel;
}

//加载失败
@property(nonatomic,strong)LoadFailedView    *viewLoadFailed;
@end
