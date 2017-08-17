//
//  ExAlertView.m
//  supercinema
//
//  Created by mapollo91 on 10/10/16.
//
//

#import "ExAlertView.h"

@interface ExAlertView ()

@property (nonatomic, assign) BOOL isShowAlert;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *maskView;
@end

static ExAlertView *shareAlertView;
@implementation ExAlertView

// 弹窗单例
+ (instancetype)sharedAlertView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareAlertView == nil)
        {
            shareAlertView = [[ExAlertView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
            shareAlertView.backgroundColor = RGBA(0, 0, 0, 0.5);
            shareAlertView.alpha = 0;
            shareAlertView.maskView = [[UIView alloc] initWithFrame:shareAlertView.bounds];
            shareAlertView.maskView.backgroundColor = RGBA(0, 0, 0,0.5);
            shareAlertView.maskView.alpha = 0;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:shareAlertView action:@selector(touchBlankDismissAlertView)];
            [shareAlertView.maskView addGestureRecognizer:tapGesture];
            [shareAlertView addSubview:shareAlertView.maskView];
        }
    });

    return shareAlertView;
}

//显示AlertView的内容
- (void)showAlertViewWithAlertContentView:(UIView *)contentView
{
    if (!self.isShowAlert)
    {
        shareAlertView.alpha = 1.0;
        self.contentView = contentView;
        self.contentView.frame = CGRectMake(contentView.frame.origin.x, self.bounds.size.height, contentView.bounds.size.width, contentView.bounds.size.height);
        [self addSubview:self.contentView];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 0.5;
            self.contentView.transform = CGAffineTransformMakeTranslation(0, -contentView.bounds.size.height);
            
        } completion:^(BOOL finished) {
            self.isShowAlert = YES;

        }];
    }
}

-(void)setShowContentView:(UIView *)contentView{
    self.maskView.alpha = 0.5;
    self.contentView = contentView;
    self.contentView.frame = CGRectMake(contentView.frame.origin.x, self.bounds.size.height, contentView.bounds.size.width, contentView.bounds.size.height);
    [self addSubview:self.contentView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)showAlertViewWithAlertContentViewKeyboardHeight:(CGFloat)height
{
    if (!self.isShowAlert)
    {
        self.alpha = 1.0;
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.bounds.size.height - height - self.contentView.bounds.size.height, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
        self.isShowAlert = YES;
        
    }
}


-(void)touchBlankDismissAlertView
{
    if (self.isShowAlert)
    {
        [self.contentView endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 0;
            self.contentView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            self.isShowAlert = NO;
            [self.contentView removeFromSuperview];
            [self removeFromSuperview];
            
            if ([self.delegate respondsToSelector:@selector(dismissExAlertView:isTouchBlank:)])
            {
                [self.delegate dismissExAlertView:self isTouchBlank:true];
            }
            
        }];
    }
}

//收起AlertView
- (void)dismissAlertView
{
    if (self.isShowAlert)
    {
        [self.contentView endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            
            self.maskView.alpha = 0;
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            self.isShowAlert = NO;
            [self.contentView removeFromSuperview];
            [self removeFromSuperview];
            
            if ([self.delegate respondsToSelector:@selector(dismissExAlertView:isTouchBlank:)])
            {
                [self.delegate dismissExAlertView:self isTouchBlank:false];
            }
        }];
    }
}

//弹起键盘
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [[userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGRect rect = [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        self.contentView.transform = CGAffineTransformTranslate(self.contentView.layer.affineTransform ,0, -rect.size.height);
    }];
}


@end
