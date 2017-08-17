//
//  ApplePayRequestViewController.h
//  libPayEaseApplePay
//
//  Created by PSPdev on 15/11/2.
//  Copyright © 2015年 Relly. All rights reserved.
//

#import <UIKit/UIKit.h>

//apple pay 支付结果的几种状态的几种状态
typedef enum{
    ApplePaySuccess = 0,//支付成功
    ApplePayFailed,     //支付失败
    ApplePayPending,    //状态未明
    ApplePaySystemError,//请求出错
}ApplePayResultStatus;

typedef void(^ApplePayResultBlock)(ApplePayResultStatus status,NSString *desc);

@interface ApplePayRequestViewController : UIViewController

@property (assign,nonatomic) BOOL isPayMent;

@property (assign,nonatomic) NSInteger CardType;

-(void)ApplePayRequestWithPara:(NSString *)paramteStr withComplete:(ApplePayResultBlock)complete;

-(void)ApplePayCancelWithPara:(NSString *)paramteStr withComplete:(ApplePayResultBlock)complete;

@end
