//
//  ChooseSeatShowView.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/10.
//
//

#import <UIKit/UIKit.h>
#import "HotMovieListModel.h"
#import "ChooseSeatTableViewCell.h"
#import "HMSegmentedControl.h"

@protocol ChooseSeatShowViewDelegate <NSObject>

-(void)reloadSeat:(ShowTimesModel*)model;

@end

@interface ChooseSeatShowView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    HMSegmentedControl  *_segmentedControl;     //日期切换控制器
    
    NSArray             *arrShowDates;          //排期日期
    NSArray             *arrShowTimes;          //排期列表
    NSMutableArray      *arrWeek;
    MovieInfoModel      *movieInfo;             //影片信息Model
    ShowTimeModel       *showtimeModel;         //排期Model
    
    UILabel             *_noShowTimeLabel;      //暂无排期标签
    
    UITableView* _myTable;
    
    //场次获取失败的控件
    UIImageView* imageFailure;
    UILabel* labelFailure;
    UIButton* btnTryAgain;
    
    CGRect myFrame;
    NSNumber    *_movieId;
}
@property(nonatomic,weak) id<ChooseSeatShowViewDelegate> showViewDelegate;
@property(nonatomic,assign) NSInteger   dateSelectedIndex;     //日期选择索引
-(id)initWithFrame:(CGRect)frame movieId:(NSNumber*)movieId;
-(void)loadShowtimeData;
@end
