//
//  MovieCommentView.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/28.
//
//

#import <UIKit/UIKit.h>
//#import "CircleProgressView.h"
#import "CommentTableViewCell.h"
#import "CommentHeadTableViewCell.h"
#import "CommentMovieView.h"
#import "CommentElseViewController.h"
#import "OtherCenterViewController.h"
#import "UserCenterViewController.h"

@interface MovieCommentView : UIView<UITableViewDelegate,UITableViewDataSource,CommentTableViewCellDelegate,CommentHeadTableViewCellDelegate,FDActionSheetDelegate,UIAlertViewDelegate>
{
    UITableView* _myTable;
    UIView* _headerView;
    NSArray* _arrTable;
    UINavigationController* _nav;
    NSArray*    _arrIcon;
    NSString*   _movieId;
    NSNumber*   _curPageIndex;
    NSArray*    _arrIconText;
    
    MovieReviewSummaryModel*    _movieModel;
    MovieReviewModel*       _movieListModel;
    NSMutableArray*     _muArrData;
    
    NSNumber*       _deleteId;
    
}
@property(nonatomic,assign) NSInteger intFollow;
@property(nonatomic,assign) BOOL isNotFirst;
-(id)initWithFrame:(CGRect)frame navigation:(UINavigationController *)navigation movieId:(NSString*)movieId;
-(void)refreshData;
@end
