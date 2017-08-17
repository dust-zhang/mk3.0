//
//  CommentElseViewController.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/30.
//
//

#import "HideTabBarViewController.h"
#import "CDetailTableViewCell.h"
#import "CDetailHeadTableViewCell.h"

@interface CommentElseViewController : HideTabBarViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,CDetailHeadTableViewCellDelegate,CDetailTableViewCellDelegate,FDActionSheetDelegate,UIAlertViewDelegate>
{
    CGRect       _rectOriginSendView;
    CGRect       _rectOriginSendBtn;
    CGRect       _rectOriginSendText;
    CGFloat      _widthSendBtn;
    UIView*      _viewSend;
    UITextView*  _textView;
    UIButton*    _btnSend;
    UILabel*     _labelDefault;
    
    NSNumber*   _curPageIndex;
    UITableView* _myTable;
    
    MovieReviewDetailModel* _movieModel;
    NSMutableArray*      _arrList;
    NSArray*      _arrIcon;
    
    NSNumber*       _deleteId;
    
    NSNumber*       _lastCommentId;
    NSString*       _laststrResUser;
    MovieReviewCommentListModel*   _curCommentModel;
    MovieReviewModel1*   _listModel;
    BOOL            _deleteAll;
    BOOL            _isKeyBoardShow;
}
@property(nonatomic,strong)NSNumber*  reviewId;
@property (nonatomic, copy)     void(^refreshListBlock)(void);
@end
