//
//  ShowTimeView.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/7.
//
//

#import <UIKit/UIKit.h>
#import "HotMovieListModel.h"
#import "ShowTimeCell.h"
#import "ChooseSeatViewController.h"
#import "ShowTimeHeadCell.h"
#import "VierticalScrollView.h"
#import "SpendRemindView.h"

@interface ShowTimeView : UIView<UITableViewDelegate,UITableViewDataSource,VierticalScrollViewDelegate>
{
    NSArray             *arrShowDates;          //排期日期
    NSArray             *arrShowTimes;          //排期列表
    NSInteger           _dateSelectedIndex;     //日期选择索引
    NSMutableArray      *arrWeek;
    UIScrollView        *scrollDate;
    MovieInfoModel      *movieInfo;             //影片信息Model
    ShowTimeModel       *showtimeModel;         //排期Model
    MovieModel          *_hotMovieModel;
    
    UITableView* _myTable;
//    UILabel*    _labelCinemaName;
//    UILabel*    _labelAddress;
    
    UIView* _viewLine2;
    
    //场次获取失败的控件
    UIImageView* imageFailure;
    UILabel* labelFailure;
    UIButton* btnTryAgain;
    
    UINavigationController* _nav;
    
    UIView*         _headerView;
    float               _lastScrollContentOffset;
    float           _heightChange;
    BOOL                _isScrollTop;
}
@property(nonatomic) CGRect myFrame;
@property(nonatomic,strong)NSArray* arrRemind;
@property(nonatomic,strong)UIView* viewCover;
@property(nonatomic,strong)SpendRemindView* spendView;
-(id)initWithFrame:(CGRect)frame movieListModel:(MovieModel*)hotMovieModel navigation:(UINavigationController *)navigation;
-(void)loadShowtimeData;
@end
