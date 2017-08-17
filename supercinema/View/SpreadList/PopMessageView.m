//
//  PopMessageView.m
//  supercinema
//
//  Created by mapollo91 on 24/4/17.
//
//

#import "PopMessageView.h"

@implementation PopMessageView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
        [self drawPopMessageView];
    }
    return self;
}

-(void)drawPopMessageView
{
    /*******画消息内容View*******/
    //背景
    self.backgroundColor = RGBA(0, 0, 0, 0.6);
    
    //整体View
    CGFloat widthBack = SCREEN_WIDTH - 70;
    CGFloat heightBack = widthBack*10/7;
    self._viewOverallBG = [[UIView alloc] initWithFrame:CGRectMake(35,(SCREEN_HEIGHT-heightBack)/2, widthBack, heightBack)];
    self._viewOverallBG.backgroundColor = [UIColor whiteColor];
    [self._viewOverallBG.layer setMasksToBounds:YES];
    [self._viewOverallBG.layer setCornerRadius:10];
    [self addSubview:self._viewOverallBG];
    
    //关闭按钮
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(widthBack - 33 , 0, 33, 33)];
    [closeBtn setImage:[UIImage imageNamed:@"btn_notifictionClose.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(onButtonClose) forControlEvents:UIControlEventTouchUpInside];
    [self._viewOverallBG addSubview:closeBtn];
}

#pragma mark 弹起 - 整个View
-(void)bouncePopMessageViews
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1, 1);
                         self.alpha=1;
                         
                     }completion:^(BOOL finish){
                         
                     }];
}

- (void)onButtonClose
{
    NSLog(@"点击了取消");
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1.3, 1.3);
                         self.alpha=0;
                         
                     }completion:^(BOOL finish){
                     }];
}


@end
