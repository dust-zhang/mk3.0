//
//  SYFireworksButton.m
//  ShoppingCartAnimationExample
//
//  Created by Mac on 16/3/25.
//  Copyright © 2016年 suya. All rights reserved.
//

#import "SYFireworksButton.h"
#import "SYFireworksView.h"
@interface SYFireworksButton()
@property (strong, nonatomic) SYFireworksView *fireworksView;

@end
@implementation SYFireworksButton

- (void)setup {
    self.clipsToBounds = NO;
    
    _imageCount = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 20, 18)];
    _imageCount.image = [UIImage imageNamed:@"image_sale_back.png"];
    _imageCount.hidden = YES;
    [self addSubview:_imageCount];
    
    _labelTotalCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 18)];
    _labelTotalCount.font = MKFONT(12);
    _labelTotalCount.textColor = [UIColor whiteColor];
    _labelTotalCount.textAlignment = NSTextAlignmentCenter;
    [_imageCount addSubview:_labelTotalCount];
    
    _fireworksView = [[SYFireworksView alloc] init];
    [self insertSubview:_fireworksView atIndex:0];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.fireworksView.frame = self.bounds;
    
    [self insertSubview:self.fireworksView atIndex:0];
}

#pragma mark - Methods

- (void)animate {
    [self.fireworksView animate];
}

- (void)popOutsideWithDuration:(NSTimeInterval)duration {
    __weak typeof(self) weakSelf = self;
    self.transform = CGAffineTransformIdentity;
//    __block CGRect btnRect = self.frame;
//    __block CGRect imgRect = self.imageCount.frame;
//    __block CGRect labelRect = self.labelTotalCount.frame;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 2.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(0.8, 0.8);
//            strongSelf.transform = CGAffineTransformMakeTranslation(0, 2);
//            strongSelf.frame = CGRectMake(btnRect.origin.x+btnRect.size.width*0.1, btnRect.origin.y+btnRect.size.height*0.1+2, btnRect.size.width*0.8, btnRect.size.height*0.8);
//            strongSelf.imageCount.frame = CGRectMake(imgRect.origin.x-imgRect.size.width*0.1, imgRect.origin.y+imgRect.size.height*0.1+2, imgRect.size.width*0.8, imgRect.size.height*0.8);
//            strongSelf.labelTotalCount.frame = CGRectMake(labelRect.origin.x-labelRect.size.width*0.1, labelRect.origin.y+labelRect.size.height*0.1+2, labelRect.size.width*0.8, labelRect.size.height*0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1 / 2.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(1, 1);
//            strongSelf.frame = btnRect;
//            strongSelf.imageCount.frame = imgRect;
//            strongSelf.labelTotalCount.frame = labelRect;
//            strongSelf.transform = CGAffineTransformMakeTranslation(0, 2);
            
        }];
    } completion:nil];
}

- (void)popInsideWithDuration:(NSTimeInterval)duration {
    __weak typeof(self) weakSelf = self;
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 2.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

#pragma mark - Properties

- (UIImage *)particleImage {
    return self.fireworksView.particleImage;
}

- (void)setParticleImage:(UIImage *)particleImage {
    self.fireworksView.particleImage = particleImage;
}

- (CGFloat)particleScale {
    return self.fireworksView.particleScale;
}

- (void)setParticleScale:(CGFloat)particleScale {
    self.fireworksView.particleScale = particleScale;
}

- (CGFloat)particleScaleRange {
    return self.fireworksView.particleScaleRange;
}

- (void)setParticleScaleRange:(CGFloat)particleScaleRange {
    self.fireworksView.particleScaleRange = particleScaleRange;
}

@end
