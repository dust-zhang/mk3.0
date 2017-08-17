//
//  CinemaDetailView.h
//  movikr
//
//  Created by zeyuan on 15/5/19.
//  Copyright (c) 2015年 zeyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKProgressTimer.h"
//#import "MkPullMessage.h"
#import "FDActionSheet.h"
#import <MapKit/MapKit.h>
#import "XHRealTimeBlur.h"

@interface CinemaCountDownView : UIView
{
    KKProgressTimer     *_progressTimer;
    UILabel             *_progressLabel;  //倒计时数字
    XHRealTimeBlur      *_realTimeBlur;
    
    UILabel             *_labelBusinessHours;       //影院营业时间
    UILabel             *_LabelPd;
    UILabel             *_labelCinemaName;          //影院标题
    UIButton            *_btnLocation;              //导航按钮
    UILabel             *_labelSurplusSeat;         //影院剩余座位
    UILabel             *_locationILabel;           //影院的地址
    UIImageView         *_locationImg;              //影院地址的图标
    UIImageView         *_imageViewCinemaLogo;      //影院Logo
    UILabel             *_labelPeople;              //周围有多少人加入的标签
    UILabel             *_labelTimeFire;            //显示倒计时
    UILabel             *_label;
}
-(id) initWithFrame:(CGRect)frame cinemaModel:(CinemaModel*)cinemaModel navigation:(UINavigationController *)nav;

@property(nonatomic,strong) UINavigationController  *_navigationController;
@property(nonatomic,strong) NSMutableArray          *_arrayMap;
@property(nonatomic,strong) CinemaModel             *_cinemaModel;
@end
