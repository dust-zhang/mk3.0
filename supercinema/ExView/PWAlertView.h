//
//  PWAlertView.h
//  自定义提示框
//
//  Created by DFSJ on 17/1/16.
//  Copyright © 2017年 Oriental Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>
//点击按钮回调
typedef void(^AlertResult)(NSInteger index);

@interface PWAlertView : UIView

/**  */
@property(nonatomic,copy) AlertResult resultIndex;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;

-(void)showMKPAlertView;



@end
