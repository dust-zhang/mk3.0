//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshLegendHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MJRefreshLegendHeader.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"

@interface MJRefreshLegendHeader()
//@property (nonatomic, weak) UIImageView *circleImage;

@property (nonatomic, weak) UIImageView *arrowImage;
@property (nonatomic, weak) UIActivityIndicatorView *activityView;
@end

@implementation MJRefreshLegendHeader
#pragma mark - 懒加载
- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"arrow.png")]];
        [self addSubview:_arrowImage = arrowImage];
    }
    return _arrowImage;
}

//- (UIImageView *)circleImage
//{
//    if (!_circleImage) {
//        UIImageView *circleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"image_loading.png")]];
//        circleImage.hidden = NO;
//        [self addSubview:_circleImage = circleImage];
//    }
//    return _circleImage;
//}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.bounds = self.arrowImage.bounds;
        [self addSubview:_activityView = activityView];
    }
    return _activityView;
}

#pragma mark - 初始化
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    //加载的圆圈
//    CGFloat circleX = self.mj_w/2;
//    self.circleImage.center = CGPointMake(circleX, self.mj_h * 0.5);
//    
//    _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    _rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
//    _rotationAnimation.duration = 0.8f;
//    _rotationAnimation.repeatCount = FLT_MAX;
    
    // 箭头
    CGFloat arrowX = (self.stateHidden && self.updatedTimeHidden) ? self.mj_w * 0.5 : (self.mj_w * 0.5 - 100);
    self.arrowImage.center = CGPointMake(arrowX, self.mj_h * 0.5);
    
    // 指示器
    self.activityView.center = self.arrowImage.center;
}

#pragma mark - 公共方法
#pragma mark 设置状态
- (void)setState:(MJRefreshHeaderState)state
{
    if (self.state == state) return;
    
    // 旧状态
    MJRefreshHeaderState oldState = self.state;
    
    switch (state) {
        case MJRefreshHeaderStateIdle: {
            if (oldState == MJRefreshHeaderStateRefreshing) {
                
//                _circleImage.hidden = YES;
//                [_circleImage.layer removeAnimationForKey:@"rotateAnimation"];
                
                
                self.arrowImage.transform = CGAffineTransformIdentity;
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    self.activityView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    self.arrowImage.alpha = 1.0;
                    self.activityView.alpha = 1.0;
                    [self.activityView stopAnimating];
                }];
            } else {
//                _circleImage.hidden = NO;
//                [_circleImage.layer addAnimation:_rotationAnimation forKey:@"rotateAnimation"];
                
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    self.arrowImage.transform = CGAffineTransformIdentity;
                }];
            }
            break;
        }
            
        case MJRefreshHeaderStatePulling: {
//            _circleImage.hidden = NO;
//            [_circleImage.layer addAnimation:_rotationAnimation forKey:@"rotateAnimation"];
            
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowImage.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
            break;
        }
            
        case MJRefreshHeaderStateRefreshing: {
//            _circleImage.hidden = NO;
//            [_circleImage.layer addAnimation:_rotationAnimation forKey:@"rotateAnimation"];
            
            [self.activityView startAnimating];
            self.arrowImage.alpha = 0.0;
            break;
        }
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}

@end
