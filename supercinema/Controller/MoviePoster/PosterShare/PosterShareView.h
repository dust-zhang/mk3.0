//
//  PosterShareView.h
//  supercinema
//
//  Created by mapollo91 on 25/3/17.
//
//

#import <UIKit/UIKit.h>
#import "DrawShareImage.h"
#import "ShareReasonViewController.h"
#import "ChangeShareImageViewController.h"
#import "ShareCardView.h"

//@protocol PosterShareViewDelegate <NSObject>
////修改图片
//-(void)pushToChangeShareImageViewController;
////修改推荐语
//-(void)pushToShareReasonViewController:(NSString *)shareReasoText;
//
////-(void)toViewController;
//@end

@interface PosterShareView : NSObject <UIGestureRecognizerDelegate, ShareCardViewDelegate, ChangeShareImageDelegate, ShareReasonTextDelegate>
{
    UINavigationController  *_nav;
}

//影院海报信息
@property (nonatomic,strong) UIImageView     *_imagePoster;              //图片海报
@property (nonatomic,strong) UILabel         *_labelPosterTitle;         //图片标题
@property (nonatomic,strong) UIView          *_viewBlackBG;              //黑色背景
@property (nonatomic,strong) UIView          *parentView;
@property (nonatomic,strong) ShareCardView   *_shareCardView;
@property (nonatomic,strong) UIImageView     *_imageUserIcon;              //用户头像
@property (nonatomic,strong) UILabel         *_labelUserName;              //用户昵称
@property (nonatomic,strong) UILabel         *_labelShareReaso;
@property (nonatomic,strong) UIView          *_viewShareReasonBG;           //分享理由背景
@property (nonatomic,strong) UIImageView     *_imageShareReasonIcon;        //分享理由图标
@property (nonatomic,strong) UIView          *_viewOverallBG;               //整体背景
@property (nonatomic,strong) MovieModel      *_movieModel;   //电影信息
//@property (nonatomic, weak) id <PosterShareViewDelegate> delegate;

//初始化控件
-(id)initWithParentView:(UIView *)parentView navigation:(UINavigationController *)navigation;
-(void)showView;

@end
