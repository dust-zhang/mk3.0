//
//  FVCustomAlertView.m
//  FVCustomAlertView
//
//  Created by Francis Visoiu Mistrih on 13/07/2014.
//  Copyright (c) 2014 Francis Visoiu Mistrih. All rights reserved.
//

#import "FVCustomAlertView.h"

static const NSInteger kInsetValue = 15;
static const NSUInteger kFinalViewTag = 1337;
static const NSUInteger kAlertViewTag = 1338;
static const CGFloat kFadeOutDuration = 0.5f;
static const CGFloat kFadeInDuration = 0.2f;
static const CGFloat loadingAnimation = 10;
static const CGFloat kOtherIconsSize = 30;

@interface FVCustomAlertView ()

+ (NSArray *)setupCustomActivityIndicator;
+ (UIView *)contentViewFromType:(FVAlertType)type;
+ (void)fadeOutView:(UIView *)view completion:(void (^)(BOOL finished))completion;
+ (void)hideAlertByTap:(UITapGestureRecognizer *)sender;

@end

static UIView *currentView = nil;

@implementation FVCustomAlertView

+ (UIView *)currentView
{
    return currentView;
}

+ (void)showAlertOnView:(UIView *)view
              withTitle:(NSString *)title
             titleColor:(UIColor *)titleColor
                  width:(CGFloat)width
                 height:(CGFloat)height
                   blur:(BOOL)blur
        backgroundImage:(UIImage *)backgroundImage
        backgroundColor:(UIColor *)backgroundColor
           cornerRadius:(CGFloat)cornerRadius
            shadowAlpha:(CGFloat)shadowAlpha
                  alpha:(CGFloat)alpha
            contentView:(UIView *)contentView
                   type:(FVAlertType)type
               allowTap:(BOOL)tap
{
    if ([view viewWithTag:kFinalViewTag]) {
        NSLog(@"Can't add two FVCustomAlertViews on the same view. Hide the current view first.");
        return;
    }

    CGRect windowRect = view.bounds;

    UIView *resultView = [[UIView alloc] initWithFrame:windowRect];
    resultView.tag = kFinalViewTag; 
    resultView.alpha = 0.0f;

    if (blur) {
      UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

      UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
      visualEffectView.frame = windowRect;
      [resultView addSubview:visualEffectView];
    }
    
    UIView *shadowView = [[UIView alloc] initWithFrame:windowRect];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = shadowAlpha;
    [resultView addSubview:shadowView];

    
    UIView *alertView = [[UIView alloc] init];
    alertView.tag = kAlertViewTag;
    alertView.backgroundColor = backgroundColor;
    if (backgroundImage) {
        alertView.backgroundColor = [[UIColor alloc] initWithPatternImage:backgroundImage];
    }
    alertView.layer.cornerRadius = cornerRadius;
    alertView.alpha = alpha;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = titleColor;
    titleLabel.font = [UIFont systemFontOfSize:10];
    
    [titleLabel sizeToFit];
    
    
    float maxWidth = 205;
    float paddingWidth = 20;
    float contentTop = 10;
    
    if (type == FVAlertTypeLoading)
    {
        contentTop = 30;
    }
    else
    {
        contentTop = 15;
    }
    
    if(titleLabel.frame.size.width <= width-(paddingWidth*2))
    {
        titleLabel.frame = CGRectMake((width-titleLabel.frame.size.width)/2, contentTop+kInsetValue+kOtherIconsSize, titleLabel.frame.size.width, 12);
    }
    else if(titleLabel.frame.size.width+(paddingWidth*2) <= maxWidth)
    {
        width = titleLabel.frame.size.width+(paddingWidth*2);
        titleLabel.frame = CGRectMake(paddingWidth, contentTop+kOtherIconsSize+15, titleLabel.frame.size.width, 12);
    }
    else if(titleLabel.frame.size.width >= maxWidth-(paddingWidth*2))
    {
        width = maxWidth;
        height = 110;
        titleLabel.numberOfLines = 0;
        CGSize requiredSize = [titleLabel sizeThatFits:CGSizeMake(width - paddingWidth*2, height - kInsetValue)];
        titleLabel.frame = CGRectMake(paddingWidth, contentTop+kInsetValue+kOtherIconsSize, width - paddingWidth*2, requiredSize.height+7);
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
        titleLabel.attributedText = attributedString;
        //[titleLabel setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    }


    UIView *content = type == FVAlertTypeCustom ? contentView : [self contentViewFromType:type];
    
    content.frame = CGRectMake((width-content.frame.size.width)/2, contentTop, content.frame.size.width, content.frame.size.height);
    
    //loading图标
    if (type == FVAlertTypeLoading)
    {
        content.frame = CGRectMake((width-content.frame.size.width)/2, loadingAnimation, content.frame.size.width, content.frame.size.height);
    }
    [alertView addSubview:content];
    
    [alertView addSubview:titleLabel];
    
    alertView.frame = CGRectMake(windowRect.size.width/2 - width/2,
                                 windowRect.size.height/2 - height/2,
                                 width, height);
    
    [resultView addSubview:alertView];

    if (tap) {
        //tap the alert view to hide and remove it from the superview
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:[FVCustomAlertView class] action:@selector(hideAlertByTap:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [resultView addGestureRecognizer:tapGesture];
    }

    [view addSubview:resultView];
    [self fadeInView:resultView completion:nil];
    currentView = view;
}

+ (void)showDefaultLoadingAlertOnView:(UIView *)view withTitle:(NSString *)title withBlur:(BOOL)blur allowTap:(BOOL)tap {
    [self showAlertOnView:view
                withTitle:title
               titleColor:[UIColor whiteColor]
                    width:100.0
                   height:100.0
                     blur:blur
          backgroundImage:nil
          backgroundColor:[UIColor blackColor]
             cornerRadius:3.0
              shadowAlpha:0.1
                    alpha:0.8
              contentView:nil
                     type:FVAlertTypeLoading
                 allowTap:tap];
}

+ (void)showDefaultDoneAlertOnView:(UIView *)view withTitle:(NSString *)title withBlur:(BOOL)blur allowTap:(BOOL)tap {
    [self showAlertOnView:view
                withTitle:title
               titleColor:[UIColor whiteColor]
                    width:115.0
                   height:95.0
                     blur:blur
          backgroundImage:nil
          backgroundColor:[UIColor blackColor]
             cornerRadius:3.0
              shadowAlpha:0.3
                    alpha:0.8
              contentView:nil
                     type:FVAlertTypeDone
                 allowTap:tap];
}

+ (void)showDefaultErrorAlertOnView:(UIView *)view withTitle:(NSString *)title withBlur:(BOOL)blur allowTap:(BOOL)tap {
    [self showAlertOnView:view
                withTitle:title
               titleColor:[UIColor whiteColor]
                    width:115.0
                   height:95.0
                     blur:blur
          backgroundImage:nil
          backgroundColor:[UIColor blackColor]
             cornerRadius:3.0
              shadowAlpha:0.3
                    alpha:0.8
              contentView:nil
                     type:FVAlertTypeError
                 allowTap:tap];
}

+ (void)showDefaultWarningAlertOnView:(UIView *)view withTitle:(NSString *)title withBlur:(BOOL)blur allowTap:(BOOL)tap {
    [self showAlertOnView:view
                withTitle:title
               titleColor:[UIColor whiteColor]
                    width:115.0
                   height:95.0
                     blur:blur
          backgroundImage:nil
          backgroundColor:[UIColor blackColor]
             cornerRadius:3.0
              shadowAlpha:0.3
                    alpha:0.8
              contentView:nil
                     type:FVAlertTypeWarning
                 allowTap:tap];
}

+ (NSArray *)setupCustomActivityIndicator {
    NSMutableArray *array = [NSMutableArray array];
    //iterate through all the images and add it to the array for the animation
    for (int i = 1; i <= 13; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d.png",i]];
        [array addObject:image];
    }
    return array;
}

+ (UIView *)contentViewFromType:(FVAlertType)type {
    UIImageView *content = [[UIImageView alloc] init];
    //generate default content views based on the type of the alert
    switch (type) {
        case FVAlertTypeLoading:
        {
            content.frame = CGRectMake(0, 0, 184/2, 120/2);
            content.animationDuration = 1.3;
            content.animationImages = [self setupCustomActivityIndicator];
            [content startAnimating];
        }
            break;
        case FVAlertTypeDone:
        {
            content.frame = CGRectMake(0, kInsetValue, kOtherIconsSize, kOtherIconsSize);
            content.image = [UIImage imageNamed:@"success.png"];
        }
            break;
        case FVAlertTypeError:
        {
            content.frame = CGRectMake(0, kInsetValue, kOtherIconsSize, kOtherIconsSize);
            content.image = [UIImage imageNamed:@"error.png"];
        }
            break;
        case FVAlertTypeWarning:
        {
            content.frame = CGRectMake(0, kInsetValue, kOtherIconsSize, kOtherIconsSize);
            content.image = [UIImage imageNamed:@"warning_0.png"];
        }
            break;
        default:
            //FVAlertTypeCustom never reached
            break;
    }

    return content;
}

+ (void)fadeInView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:kFadeInDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [view setAlpha:1.0];
                     }
                     completion:completion];
}

+ (void)fadeOutView:(UIView *)view completion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:kFadeOutDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [view setAlpha:0.0];
                     }
                     completion:completion];
}

+ (void)hideAlertFromView:(UIView *)view fading:(BOOL)fading {
    if (fading) {
        [self fadeOutView:[view viewWithTag:kFinalViewTag] completion:^(BOOL finished) {
            [[view viewWithTag:kFinalViewTag] removeFromSuperview];
        }];
    } else {
        [[view viewWithTag:kFinalViewTag] removeFromSuperview];
    }
    currentView = nil;
}

+ (void)hideAlertByTap:(UITapGestureRecognizer *)sender {
    //fade out and then remove from superview
    [self fadeOutView:sender.view
           completion:^(BOOL finished) {
               [[sender.view viewWithTag:kFinalViewTag] removeFromSuperview];
               currentView = nil;
           }];
}

@end
