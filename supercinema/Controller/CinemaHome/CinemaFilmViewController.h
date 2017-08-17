//
//  CinemaFilmViewController.h
//  supercinema
//
//  Created by mapollo91 on 29/7/16.
//
//

#import <UIKit/UIKit.h>
#import "MovieCollectionViewCell.h"
#import "CinemaSearchViewController.h"
#import "LoginViewController.h"
#import "MembershipCardView.h"
#import "GlobalSearchViewController.h"
#import "SaleListView.h"
#import "ActivityView.h"
#import "NotificationView.h"
#import "MoviePosterViewController.h"
#import "CinameDetailViewController.h"

@interface CinemaFilmViewController : ShowTabBarViewController<UIScrollViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,MovieCollectionViewCellDelegate,QRCodeReaderDelegate,CLLocationManagerDelegate,ActivityViewDelegate,MAMapViewDelegate, AMapLocationManagerDelegate>
{
    UIImageView*            _headBigImage;                  //头部大图
    UIImageView*            _headSmallImage;                //头部小图
    UIView*                 _headAlphaView;                 //顶部半透明view
    UIButton*               _btnScan;                       //二维码按钮
    UIButton*               _btnSearch;                     //搜索按钮
    UIButton*               _btnCinema;
    UIImageView*            _imgArrow;
    UIScrollView*           _viewCinemaFeature;             //影院特色view
    UIView*                 _viewTitleBtn;                  //栏目btn
    NSInteger               lastBtnTag;
    UIView*                 _viewTitleBack1;                //看电影栏目view
    MembershipCardView*     _viewTitleBack2;                //捡便宜栏目view
    SaleListView*           _viewTitleBack3;                //小卖部栏目view
    ActivityView            *_viewTitleBack4;                //凑热闹栏目view
    CGRect                  viewBackFrame;
    UICollectionView*       _collectionView;
    UIButton                *_btnShowing;                   //正在热映按钮
    UIButton                *_btnWillShow;                  //即将上映按钮
    UIView                  *_btnLineView;                  //按钮亮条
    
    NSArray                 *_arrMovieData;
    NSArray                 *_arrCommingMovieData;
    UIAlertView             *_alterViewQR;
    float                   _lastScrollContentOffset;
    CGFloat                 _defaultHeight;
    UIAlertView             *_alterView;
    NSArray                 *_arrQrResult;
    UIImage                 *_originFrontImage;
    BOOL                    _isScrollTop;
    NSString                *_clickType;
    
    //加载失败
    LoadFailedView           *_viewLoadFailed;
    
    //四个tab是否点击过
    BOOL                    _isHaveLoadData[4];
    
}

// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary       *cellDic;
@property (nonatomic,strong) AMapLocationManager        *_locationManager;
@property (nonatomic,copy )  AMapLocatingCompletionBlock _completionBlock;
@end
