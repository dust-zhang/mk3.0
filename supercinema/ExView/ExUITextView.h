//
//  ExUITextView.h
//  movikr
//
//  Created by Mapollo28 on 15/11/23.
//  Copyright © 2015年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExUITextViewDelegate <NSObject>
-(void)showHide:(UIView*)view;
@end

@interface ExUITextView : UIView
@property(strong,nonatomic)UIButton* btnDelete;
@property(strong,nonatomic)UITextField* myTextField;
@property (nonatomic,weak) id<ExUITextViewDelegate> tfDelegate;
@end
