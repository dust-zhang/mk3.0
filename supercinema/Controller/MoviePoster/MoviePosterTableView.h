//
//  MoviePosterTableView.h
//  supercinema
//
//  Created by Mapollo28 on 2017/3/22.
//
//

#import <UIKit/UIKit.h>
//#import "AnimatedGif.h"
//#import "UIImageView+AnimatedGif.h"
#import "MoviePosterView.h"
#import "CommentTableViewCell.h"
#import "CommentHeadTableViewCell.h"
#import "CommentMovieView.h"
#import "OtherCenterViewController.h"
#import "CommentElseViewController.h"
#import "KrVideoPlayerController.h"

@interface MoviePosterTableView : UIView<UITableViewDelegate,UITableViewDataSource,CommentTableViewCellDelegate,CommentHeadTableViewCellDelegate,FDActionSheetDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
@property(nonatomic,assign)BOOL isLoadUI;
@property(nonatomic,strong)UIScrollView* wholeScroll;
@property(nonatomic,strong)UITableView* table;
@property(nonatomic,strong)MovieModel* movieModel;
@property(nonatomic,strong)MoviePosterView* posterView;
@property(nonatomic,strong)UIImageView *gifImageView;
@property(nonatomic,strong)NSNumber*   curPageIndex;
@property(nonatomic,assign)int   curIndex;
@property(nonatomic,strong)MovieReviewSummaryModel*    commentHeadModel;
@property(nonatomic,strong)MovieReviewModel*     commentListModel;
@property(nonatomic,strong)UINavigationController* nav;
@property(nonatomic,strong)NSArray*    arrIcon;
@property (nonatomic, copy)void(^showHideBlock)(BOOL showHide);
@property (nonatomic, copy)void(^isCanScroll)(BOOL isCanScroll);
@property(nonatomic,strong)NSMutableArray*     muArrData;
@property(nonatomic,strong)NSNumber*       deleteId;
@property(nonatomic,strong)UIButton* btnComment;
@property(nonatomic,strong)UILabel* labelFollowCount;
@property(nonatomic,strong)UIImageView*  headerView;
@property(nonatomic,assign)BOOL  isSecondSection;       //滑动到第二个section
@property(nonatomic,assign)BOOL  isFirstLoadList;       //首次请求短评列表接口
@property(nonatomic,assign)BOOL  haveScrollToBottom;    //是否滑至第一屏底部
@property(nonatomic,assign)BOOL  isBeginTouch;          //手势开始操作
@property(nonatomic,assign)BOOL  isDecelerating;        //正在减速
@property(nonatomic,strong) KrVideoPlayerController             *videoController;
@property(nonatomic,strong) UIView* viewFailure;
@property(nonatomic,strong) UIImageView* imageFailure;
@property(nonatomic,strong) UILabel* labelFailure;
@property(nonatomic,strong) UIButton* btnTryAgain;
@property(nonatomic,assign)BOOL  isTableScrollToTop;
@property (nonatomic,strong)UIVisualEffectView* effectview;

-(void)scrollToCommentList;
-(id)initWithFrame:(CGRect)frame movieModel:(MovieModel*)mModel navigation:(UINavigationController *)navigation;
-(void)changeFollowHead:(BOOL)isChange;
-(void)initVariable;
-(void)initUI;
@end
