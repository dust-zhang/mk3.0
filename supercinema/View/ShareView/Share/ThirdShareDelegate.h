//
//  ShareDelegate.h
//  movikr
//
//  Created by Mapollo25 on 15/6/1.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shareInfoModel.h"

@protocol ThirdShareDelegate <NSObject>

@required
-(BOOL)checkIsInstall;
@required
-(void)shareImage:(UIImage *)shareImage;
@required
-(void)shareText:(NSString *)shareText;
@required
-(void)shareContent:(shareInfoModel *)shareInfo;
@end
