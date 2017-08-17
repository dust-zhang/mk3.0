//
//  ContractView.m
//  movikr
//
//  Created by zeyuan on 15/6/2.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "ContractView.h"


@implementation ContractView

-(id)initWithFrame:(CGRect)frame str:(NSString*)str
{
    self = [super initWithFrame:frame];
    _realTimeBlur = [[XHRealTimeBlur alloc] initWithFrame:self.bounds];
    _realTimeBlur.blurStyle = XHBlurStyleTranslucent;
    _realTimeBlur.hasTapGestureEnable = NO;
    [self addSubview:_realTimeBlur];
    [self initCtrlAndData:str];
    
    return self;
}

//渲染UI & 数据
-(void)initCtrlAndData:(NSString*)strContent
{
    //顶部View
    UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    viewTop.backgroundColor = RGBA(255, 255, 255, 1);
    [self addSubview:viewTop];
    
    UILabel *labelTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 33, SCREEN_WIDTH, 17)];
    [labelTop setBackgroundColor:[UIColor clearColor]];
    [labelTop setTextColor:RGBA(51, 51, 51,1)];
    [labelTop setTextAlignment:NSTextAlignmentCenter];
    [labelTop setFont:MKFONT(17)];
    [labelTop setText:@"使用协议"];
    [labelTop setUserInteractionEnabled:YES];
    [viewTop addSubview:labelTop];
    
    //返回按钮
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 23, 82/2, 30)];
    [btnBack setImage:[UIImage imageNamed:@"btn_backBlack.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(onButtonBack) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:btnBack];
    
    //使用说明的显示内容
    UILabel *labelDetail = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 100)];
    labelDetail.numberOfLines = 0;
    [labelDetail setFont:MKFONT(14) ];
    [labelDetail setTextColor:RGBA(51, 51, 51,1)];
    NSString *labelText = [[@"\n" stringByAppendingString:strContent] stringByAppendingString:@"\n"];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //调整行间距
    [paragraphStyle setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    labelDetail.attributedText = attributedString;
    [labelDetail sizeToFit];
    
    //滚动视图
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [contentView addSubview:labelDetail];
    contentView.backgroundColor = RGBA(246, 246, 251,1);
    [contentView setContentSize:CGSizeMake(SCREEN_WIDTH, labelDetail.frame.size.height)];
    [self addSubview:contentView];
}

//关闭
-(void)onButtonBack
{
    if (self)
    {
        [MobClick event:myCenterViewbtn125];
        [self removeFromSuperview];
    }
}

@end
