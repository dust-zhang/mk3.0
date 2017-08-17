//
//  CinemaShareView.h
//  supercinema
//
//  Created by mapollo91 on 10/4/17.
//
//

#import <UIKit/UIKit.h>
#import "DrawShareImage.h"
#import "ChangeCinemaImageViewController.h"

#import "ShareCardView.h"

//@protocol CinemaShareViewDelegate <NSObject>
////跳转页面的代理
//-(void)pushToChangeCinemaImageViewController:(NSArray *)arrImages viewName:(NSString *)name;
//@end

@interface CinemaShareView : NSObject <UIGestureRecognizerDelegate ,ShareCardViewDelegate,ChangeCinemaImageDelegate>
{
    UINavigationController *_nav;
    NSString    *_cinemaName;
}
//影院海报信息
@property (nonatomic,strong) UIImageView     *_imagePoster;              //图片海报
@property (nonatomic,strong) UIView          *_viewBlackBG;              //黑色背景
@property (nonatomic,strong) ShareCardView   *_shareCardView;

@property (nonatomic,strong) CinemaShareInfoModel    *_cinemaShareInfoModel;               //影院分享信息
//@property (nonatomic, weak) id <CinemaShareViewDelegate> delegate;

//初始化控件
-(id)initWithParentView:(UIView *)parentView model:(CinemaShareInfoModel*)model cinemaName:(NSString *)cinemaName navigation:(UINavigationController *)navigation;

@end
