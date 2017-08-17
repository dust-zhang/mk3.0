//
//  ExAlertView.h
//  supercinema
//
//  Created by mapollo91 on 10/10/16.
//
//

#import <UIKit/UIKit.h>

@class ExAlertView;
@protocol ExAlertViewDelegate <NSObject>
@optional
-(void)dismissExAlertView:(ExAlertView *)view isTouchBlank:(BOOL)flag;
@end

@interface ExAlertView : UIView

+ (instancetype)sharedAlertView;
- (void)showAlertViewWithAlertContentView:(UIView *)contentView;
- (void)setShowContentView:(UIView *)contentView;
- (void)showAlertViewWithAlertContentViewKeyboardHeight:(CGFloat)height;
- (void)dismissAlertView;

@property(nonatomic, weak) id<ExAlertViewDelegate> delegate;

@end
