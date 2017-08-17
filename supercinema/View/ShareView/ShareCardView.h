//
//  ShareCardView.h
//  supercinema
//
//  Created by mapollo91 on 12/4/17.
//
//

#import <UIKit/UIKit.h>
#import "DrawShareImage.h"

@protocol ShareCardViewDelegate <NSObject>
//画卡片View
@required
-(UIView *)shareCardView;
//显示 或 影藏 View中的某些控件
-(void)hideShareViewSubview:(UIView *)shareView;
-(void)showShareViewSubview:(UIView *)shareView;
//离开View
-(void)cancelView;
@end

@interface ShareCardView : UIVisualEffectView <UIScrollViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    UINavigationController  *_nav;
    
    //分享内容
    UIScrollView    *_scrollViewContent;
    UIView          *_viewOverallBG;
    
    //分享到...
    UIView          *_viewShareToBG;          //分享到背景
    UIImageView     *_imageShadow;            //渐变蒙层
    
    //保存 & 分享
    UIView          *_viewSaveShareBG;        //保存 & 分享背景
    
   
    
    BOOL            _isClickBlank;            //是否点击过空白
    float           _fViewShareToBGHeight;    //分享背景高度
}

@property (nonatomic, weak) id <ShareCardViewDelegate> delegate;


//初始化控件
-(id)initWithFrame:(CGRect)frame;
//画View
-(void)drawView;
//弹起动画
-(void)bounceViews;


@end


