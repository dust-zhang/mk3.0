//
//  ContractView.h
//  movikr
//
//  Created by zeyuan on 15/6/2.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHRealTimeBlur.h"
#import "UIERealTimeBlurView.h"


@interface ContractView : UIView
{
    XHRealTimeBlur*  _realTimeBlur;
}

-(id)initWithFrame:(CGRect)frame str:(NSString*)str;

@property(nonatomic, strong) NSString                   *_strContent;


@end
