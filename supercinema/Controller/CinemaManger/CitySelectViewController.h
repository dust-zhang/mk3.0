//
//  CitySelectViewController.h
//  supercinema
//
//  Created by dust on 16/10/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CitySelectHeadCollectionReusableView.h"
#import "CitySelectCollectionViewCell.h"
#import "ExUISearchBar.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
//定义Block
typedef void (^SelectCity)(NSString *cityName);

@interface CitySelectViewController : HideTabBarViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate,ExUISearchBarDelegate,MAMapViewDelegate, AMapLocationManagerDelegate>
{
    NSMutableDictionary     *_newCityDic;
    NSMutableArray          *_arrAllCityNames;
    NSMutableArray          *_allKeysArray;
    NSMutableArray          *_arrHostCities;
    NSMutableArray          *_arrAllCityModel;
    //搜索历史
    NSMutableArray          *_arrSearchHistory;
    //当前位置的城市名称
    NSString                *_strCurrentLocationCityName;
    BOOL                    isLocationFail;
    BOOL                    isLocating;
    ExUISearchBar           *_searchBar;
}

//整体的TabelView（除搜索框之外的部分）
@property (nonatomic,strong) UITableView            *_mainTable;
@property (nonatomic,assign) BOOL                   isSearch;
@property (nonatomic,strong) NSArray                *_arrData;
@property (nonatomic,strong) NSMutableArray         *_arrSearchData;
@property (nonatomic,strong) UICollectionView       *_collectionView;
//获取用户位置
@property (nonatomic,strong) CLLocationManager      *_userLocation;
//反地理编码
@property (nonatomic,strong) CLGeocoder             *_geocoder;
//定义Block
@property (nonatomic,strong) SelectCity             selectCity;
@property (nonatomic,strong) AMapLocationManager        *_locationManager;
@property (nonatomic, copy ) AMapLocatingCompletionBlock _completionBlock;

@end
