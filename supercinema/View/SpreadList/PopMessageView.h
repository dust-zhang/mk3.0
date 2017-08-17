//
//  PopMessageView.h
//  supercinema
//
//  Created by mapollo91 on 24/4/17.
//
//

#import <UIKit/UIKit.h>

@protocol PopMessageViewDelegate <NSObject>
////画卡片View
//@required
//-(UIView *)messageView;
//离开View
-(void)cancelViewAndIsRemove:(BOOL)isRemoveFromSuperview;
@end

@interface PopMessageView : UIView

@property (nonatomic, strong) UIView   *_viewOverallBG;   //整体View
@property (nonatomic, weak) id  <PopMessageViewDelegate> delegate;

//初始化控件
-(id)initWithFrame:(CGRect)frame;
////画View
//-(void)drawPopMessageView;
//弹起动画
-(void)bouncePopMessageViews;

@end
