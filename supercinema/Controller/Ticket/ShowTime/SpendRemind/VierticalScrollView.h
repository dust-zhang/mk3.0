//
//  VierticalScrollView.h
//  上下滚动btn
//
//  Created by Mapollo28 on 17/4/13.
//  Copyright © 2016年 Mapollo28. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VierticalScrollViewDelegate <NSObject>
@optional
-(void)clickTitleButton:(UIButton *)button;
@end


@interface VierticalScrollView : UIView


@property (nonatomic,strong) id<VierticalScrollViewDelegate> delegate;

-(instancetype)initWithArray:(NSArray *)titles AndFrame:(CGRect)frame;
+(instancetype)initWithTitleArray:(NSArray *)titles AndFrame:(CGRect)frame;



@end
