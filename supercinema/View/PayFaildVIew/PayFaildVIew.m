//
//  PayFaildVIew.m
//  movikr
//
//  Created by Mapollo27 on 15/9/21.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "PayFaildVIew.h"



@implementation PayFaildVIew

-(instancetype)initWithFrame:(CGRect)frame orderModel:(OrderWhileModel *)model
{
    self=[super initWithFrame:frame];
    if(self)
    {
        _realTimeBlur = [[XHRealTimeBlur alloc] initWithFrame:self.bounds];
        _realTimeBlur.blurStyle = XHBlurStyleTranslucent;
        _realTimeBlur.hasTapGestureEnable = NO;
        [self addSubview:_realTimeBlur];
        
        _labelFaild = [[UILabel alloc ] initWithFrame:CGRectMake(0, 67/2, SCREEN_WIDTH, 34/2)];
        [_labelFaild setBackgroundColor:[UIColor clearColor]];
        [_labelFaild setFont:MKBOLDFONT(17)];
        [_labelFaild setTextAlignment:NSTextAlignmentCenter];
        [_labelFaild setTextColor:[UIColor whiteColor]];
        [self addSubview:_labelFaild];
        
        _labelTip = [[UILabel alloc ] initWithFrame:CGRectMake(0, _labelFaild.frame.origin.y+_labelFaild.frame.size.height+192/2, SCREEN_WIDTH,34/2)];
        [_labelTip setBackgroundColor:[UIColor clearColor]];
        [_labelTip setFont:MKBOLDFONT(17)];
        [_labelTip setTextAlignment:NSTextAlignmentCenter];
        [_labelTip setTextColor:[UIColor whiteColor]];
        [self addSubview:_labelTip];
        
        _labelContent1= [[UILabel alloc ] initWithFrame:CGRectMake(30, _labelTip.frame.origin.y+_labelTip.frame.size.height+90/2, SCREEN_WIDTH-60, 70)];
        [_labelContent1 setBackgroundColor:[UIColor clearColor]];
        [_labelContent1 setFont:MKFONT(14) ];
         [_labelContent1 setTextColor:[UIColor whiteColor]];
        [_labelContent1 setTextAlignment:NSTextAlignmentLeft];
        [_labelContent1 setNumberOfLines:0];
        [_labelContent1 setLineBreakMode:NSLineBreakByCharWrapping];
        [self addSubview:_labelContent1];
       
        _labelContent2 = [[UILabel alloc ] initWithFrame:CGRectMake(_labelContent1.frame.origin.x, _labelContent1.frame.origin.y+_labelContent1.frame.size.height+60/2,SCREEN_WIDTH-60, 60)];
        [_labelContent2 setBackgroundColor:[UIColor clearColor]];
        [_labelContent2 setFont:MKFONT(14) ];
        [_labelContent2 setTextColor:[UIColor whiteColor]];
        [_labelContent2 setTextAlignment:NSTextAlignmentLeft];
        [_labelContent2 setNumberOfLines:0];
        [_labelContent2 setLineBreakMode:NSLineBreakByCharWrapping];
        [_labelContent2 setUserInteractionEnabled:YES];
        [self addSubview:_labelContent2];
        
        _btnCallTel = [[UIButton alloc ] initWithFrame:_labelContent2.frame];
        [_btnCallTel setBackgroundColor:[UIColor clearColor]];
        [_btnCallTel addTarget:self action:@selector(onButtonTel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCallTel];
        
        UIButton *btnClose = [[UIButton alloc ] initWithFrame:CGRectMake(0, 27, 94/2, 60/2)];
        [btnClose setImage:[UIImage imageNamed:@"btn_closeWhite.png"] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnClose];
        
        [self setViewCtrlText];
    }
    return self;
}

-(void) setViewCtrlText
{
    [_labelFaild setText:@"出票失败"];
    [_labelTip setText:@"退款正在处理中" ];
    [_labelContent1 setText:@"抱歉，您的订单没有订购成功，退款将会在5-7个工作日退还到您的账户，请注意查收。" ];
    CGSize size = [Tool CalcString:_labelContent1.text fontSize:MKFONT(14) andWidth:SCREEN_WIDTH-60];
    _labelContent1.frame = CGRectMake(30, _labelTip.frame.origin.y+_labelTip.frame.size.height+90/2, SCREEN_WIDTH-60, size.height);
    
    [_labelContent2 setText:[NSString stringWithFormat:@"如有其他疑问，请与客服联系\n%@ (%@)",
                             [Config getConfigInfo:@"movikrPhoneNumber"],
                             [Config getConfigInfo:@"movikrPhoneNumberDesc"]] ];
    
     size = [Tool CalcString:_labelContent2.text fontSize:MKFONT(14) andWidth:SCREEN_WIDTH-60];
    _labelContent2.frame = CGRectMake(_labelContent1.frame.origin.x, _labelContent1.frame.origin.y+_labelContent1.frame.size.height+60/2,SCREEN_WIDTH-60, size.height);
    _btnCallTel.frame = _labelContent2.frame;
}

-(void)onButtonTel
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[Config getConfigInfo:@"movikrPhoneNumber"]]];
    if ( !_phoneCallWebView )
    {
        _phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

-(void) closeView
{
    [MobClick event:mainViewbtn59];
    //如果自己不为空直接关闭
    if (self)
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(1.3, 1.3);
                             self.alpha=0;
                         }completion:^(BOOL finish){
                             [self removeFromSuperview];
                         }];

    }
}


@end
