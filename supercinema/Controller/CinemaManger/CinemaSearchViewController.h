//
//  CinemaSearchViewController.h
//  supercinema
//
//  Created by dust on 16/10/12.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SearchResultTableViewCell.h"
#import "CitySelectViewController.h"
#import "ExUISearchBar.h"
#import "SearchHistoryTableViewCell.h"
#import "LoginViewController.h"
#import "CinemaCountDownView.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "LoadFailedView.h"

@protocol CinemaSearchDelegate<NSObject>
- (void)searchContent:(NSString*)text;
@end


@interface CinemaSearchViewController : HideTabBarViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,ExUISearchBarDelegate,clearHistoryDelegate,MAMapViewDelegate, AMapLocationManagerDelegate>
{
    UIAlertView         *_alterViewMedia;
    UITableView         *_tableViewCinema;
    UILabel             *_labelLine;
    NSString            *_strSetCamerOrLocation;
    NSTimer             *_timeRefrush;
    UIButton            *_btnLocation;
    UIButton            *_btnLogin;
    
    NSMutableArray      *_arrHistory;
    NSMutableArray      *_arrOftenCinema;
    NSMutableArray      *_arrCinema;
    
    ExUISearchBar       *_searchBar;
    NSString            *_strLocationCity;
    //是否输入搜索条件标示
    BOOL                _isSearch;
    UIImageView         *_imageView;
    UILabel             *_labelDesc;
    
    int                 _pageIndex;
    NSString            *_strSelectCityId;
    NSString            *_strLocationCityId;
    NSString            *_strSearchContent;
    LoadFailedView      *_viewLoadFailed;
}

@property (nonatomic,strong) NSString                   *_strSearchCondition;
@property (nonatomic,strong) AMapLocationManager        *_locationManager;
@property (nonatomic, copy ) AMapLocatingCompletionBlock _completionBlock;
@property (nonatomic,assign) id <CinemaSearchDelegate>   _cinemaSearchDelegate;
@property (nonatomic,strong) NSString                   *_viewName;
@property (nonatomic,strong) NSString                   *_longitude;
@property (nonatomic,strong) NSString                   *_latitude;

@end

