//
//  PayFaildVIew.h
//  movikr
//
//  Created by Mapollo27 on 15/9/21.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHRealTimeBlur.h"
#import "OrderModel.h"

@protocol  PayFaildVIewDelegate<NSObject>
-(void)payFailedToCard;
@end

@interface PayFaildVIew : UIView
{
    XHRealTimeBlur      *_realTimeBlur;
    UIWebView           *_phoneCallWebView;

    UILabel             *_labelFaild;
    
    UILabel             *_labelTip;
   
    UILabel          *_labelContent1;
   
    UILabel          *_labelContent2;
   
    UIButton            *_btnCallImage;
    UIButton            *_btnCallTel;
}
@property(nonatomic,assign) id <PayFaildVIewDelegate> payFaildViewDelegate;
-(instancetype)initWithFrame:(CGRect)frame orderModel:(OrderWhileModel *)Model;

@end
