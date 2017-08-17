//
//  CinameDetailViewController.h
//  supercinema
//
//  Created by lianyanmin on 17/4/12.
//
//

#import "HideTabBarViewController.h"
#import "CinemaDetailVideoImageView.h"
#import "CinemaDetailTagsView.h"
#import "GlobalSearchViewController.h"
#import "CinemaSearchViewController.h"
#import "CinemaShareView.h"
#import "CinemaVideoListViewController.h"
#import "MapViewController.h"
#import "CinemaPhoneView.h"

@interface CinameDetailViewController : HideTabBarViewController<UITextViewDelegate,CinameDeatilVideoImageViewDelegate>//CinemaShareViewDelegate
{
    
    UIScrollView                *_scrollView;
    UIButton                    *_btnShare;
    UIButton                    *_btnSearch;
    UIView                      *_viewCinemaName;      //影院的名称view
    UILabel                     *_labelCinemaName;     //影院标题
    UIButton                    *_buttonChangeCinema;  //切换影院
    UIView                      *_viewEverCome;        //来人看过view
    UILabel                     *_labelPeopleNumber;   //来人看过
    CinemaDetailTagsView        *_viewCinemaTags;      //影院标签view
    CinemaDetailTagsView        *_viewFacilityTags;    //特色设施标签view
    UIView                      *_viewCinemaPublic;    //影院公告view
    UILabel                     *_labelPublicTitle;    //影院公告标题
    UILabel                     *_labelPublicContent;  //影院公告的内容
    CinemaDetailVideoImageView  *_videoImageView;      //视频和图片view
    UIView                      *_viewCinemaLocation;  //影院地址view
    UILabel                     *_labelLocationTitle;  //影院地址标题
    UIButton                    *_buttonLocationShare; //定位
    UILabel                     *_labelLocation;       //影院详细地址
    UIView                      *_viewCinemaInfo;      //影院信息view
    UILabel                     *_labelbBusinessHours; //营业时间
    UILabel                     *_labelCinemaSeat;     //影厅座位
    UILabel                     *_labelCreatedTime;    //成立时间
    UILabel                     *_labelCircuit;        //所属院线
    UIView                      *_viewCooperation;     //合作商家view
    UILabel                     *_labelCooperationTitle;//合作商家
    CinemaShareView             *_cinemaShareView;      //分享view
    UIView                      *_viewWhiteLine;
    CinemaPhoneView             *_viewCinamePhone;      //影院电话标签
    UIWebView                   *_phoneCallWebView;
    NSMutableArray              *_merchantsData;         //合作商户
}

@property (nonatomic, strong) CinemaModel               *_cinemaModel;
@property (nonatomic, strong) KrVideoPlayerController   *_videoController;



@end
