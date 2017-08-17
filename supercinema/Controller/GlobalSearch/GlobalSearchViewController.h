//
//  GlobalSearchViewController.h
//  supercinema
//
//  Created by dust on 16/11/7.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SearchResultTableViewCell.h"
#import "CitySelectViewController.h"
#import "SearchHistoryTableViewCell.h"
#import "MovieTableViewCell.h"
#import "UserTableViewCell.h"
#import "UserModel.h"
#import "SearchUserViewController.h"
#import "SearchMovieViewController.h"
#import "CinemaSearchViewController.h"
#import "ExUISearchBar.h"
#import "OtherCenterViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "LoadFailedView.h"

@interface GlobalSearchViewController : HideTabBarViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,clearHistoryDelegate,ExUISearchBarDelegate,buyTicketDelegate,MAMapViewDelegate, AMapLocationManagerDelegate,SearchUserDelegate,SearchMovieDelegate,CinemaSearchDelegate>

{
    UIAlertView         *_alterViewMedia;
    UITableView         *_tableViewCinema;
    UIButton            *_btnBack;
    NSString            *_strSetCamerOrLocation;
    NSTimer             *_timeRefrush;
    UIButton            *_btnLocation;
    //推荐影院数组
    NSMutableArray      *_arrCinema;
    //历史记录数组
    NSMutableArray      *_arrHistory;
    //常去影院数组
    NSMutableArray      *_arrOftenCinema;
    //影片数组
    NSMutableArray      *_arrMovie;
    //用户数组
    NSMutableArray      *_arrUser;
    //是否输入搜索条件标示
    BOOL                _isSearch;
    
    NSString            *_strLocationCity;
    
    NSString            *_strSelectCityId;
    NSString            *_strLocationCityId;
    
    UIImageView         *_imageView;
    UILabel             *_labelDesc;
    SearchModel         *_searchModel;
    
    int                 _totalUser;
    int                 _totalMovie;
    int                 _totalCinema;
    LoadFailedView      *_viewLoadFailed;
}

@property (nonatomic,retain) CLLocationManager          *_locationMgr;
@property (nonatomic,assign) CLLocationCoordinate2D     _localCoordinate;
@property (nonatomic,strong) AMapLocationManager        *_locationManager;
@property (nonatomic,copy )  AMapLocatingCompletionBlock _completionBlock;
@property (nonatomic,strong) UIWindow                   *_window;
@property (nonatomic,strong) NSString                   *_longitude;
@property (nonatomic,strong) NSString                   *_latitude;
@property (nonatomic,strong) ExUISearchBar              *_searchBar;
@end
