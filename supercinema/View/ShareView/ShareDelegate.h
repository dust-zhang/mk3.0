//
//  ShareDelegate.h
//  movikr
//
//  Created by Mapollo25 on 15/6/1.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareDelegate <NSObject>
@optional
-(void)touchUpCloseShare;

-(void)thirdLoginSucceed:(NSString*)token unionId:(NSString*)unionId loginType:(NSInteger)loginType authorizeStatus:(NSInteger)authorizeStatus;

-(void)thirdLoginFailed;

//-(void)touchUpShareButton:(UIButton *)sender;

@end
