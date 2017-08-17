//
//  ActivityDetailsViewController.h
//  supercinema
//
//  Created by mapollo91 on 7/3/17.
//
//

#import <UIKit/UIKit.h>
#import "ActivityCenterWebViewController.h"

@interface ActivityDetailsViewController : HideTabBarViewController
{
    //整体的ScrollView
    UIScrollView    *_scrollViewContent;
    
    //活动图片
    UIImageView     *_imageActivity;
    
    //参加人数
    UILabel         *_labelJoinPeople;
    
    //活动标题
    UILabel         *_labelActivityTitle;
    
    //活动时间
    UILabel         *_labelActivityTimeTitle;
    UILabel         *_labelActivityTime;
    
    //活动描述
    UILabel         *_labelActivityDetailsTitle;
    UILabel         *_labelActivityDetails;
    
    //详情按钮
    UIButton        *_btnCheckDetails;
    
    //整体参加按钮背景
    UIView          *_viewJoinButtonBG;
    UIButton        *_btnJoinActivity;
    //蒙层
    UIImageView     *_imageShadow;
    
}
@property (nonatomic, strong) ActivityModel *_activityModel;

-(void)setActivityDetailsFrameAndData;

@end





