//
//  ShareRedPacketView.h
//  supercinema
//
//  Created by mapollo91 on 16/5/17.
//
//

#import <UIKit/UIKit.h>

@protocol ShareRedPacketViewDelegate <NSObject>
////显示 或 影藏 View中的某些控件
//-(void)hideShareViewSubview:(UIView *)shareView;
//-(void)showShareViewSubview:(UIView *)shareView;
////离开View
//-(void)cancelView;
@end

@interface ShareRedPacketView : UIView <UIGestureRecognizerDelegate>
{
    //分享到...
    UIView          *_viewShareToBG;          //分享到背景
    UIImageView     *_imageShadow;            //渐变蒙层
    
    BOOL            _isClickBlank;            //是否点击过空白
    float           _fViewShareToBGHeight;    //分享背景高度
}

@property (nonatomic, strong)NSNumber          *_orderId;
@property (nonatomic, weak) id <ShareRedPacketViewDelegate> delegate;


//初始化控件
-(id)initWithFrame:(CGRect)frame;
//画View
-(void)drawView;
//弹起动画
-(void)bounceViews;

@end
