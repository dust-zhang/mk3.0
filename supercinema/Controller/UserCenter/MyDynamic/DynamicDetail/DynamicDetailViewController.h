//
//  DynamicDetailViewController.h
//  supercinema
//
//  Created by Mapollo28 on 2016/12/3.
//
//

#import "HideTabBarViewController.h"
#import "DynDetailTableViewCell.h"
#import "OtherCenterViewController.h"
@interface DynamicDetailViewController : HideTabBarViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,DynDetailTableViewCellDelegate,UIAlertViewDelegate,FDActionSheetDelegate>
{
    CGRect       _rectOriginSendView;
    CGRect       _rectOriginSendBtn;
    CGRect       _rectOriginSendText;
    CGFloat      _widthSendBtn;
    UIView*      _viewSend;
    UITextView*  _textView;
    UIButton*    _btnSend;
    UILabel*     _labelDefault;
    
    
    UITableView* _myTable;
    NSMutableArray*     _muArrData;
    NSNumber*       _curPage;
    NSInteger       _curIndex;
    
    NSNumber*       _lastCommentId;
    NSString*       _laststrResUser;
    FeedUserModel*   _curCommentModel;
    UserDynamicDetailModel *_detailModel;
    
    BOOL            _keyboardShowing;
    
     NSNumber*       _deleteId;
     FeedListModel* _curModel;
}
@property(nonatomic,strong)NSNumber* _feedId;
@end
