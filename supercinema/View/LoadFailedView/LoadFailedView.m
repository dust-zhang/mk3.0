//
//  LoadFailedView.m
//  supercinema
//
//  Created by dingdingdangdang on 2017/5/16.
//
//

#import "LoadFailedView.h"

@implementation LoadFailedView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initViews];
    }
    return self;
}

-(void)initViews
{
    UIImageView* imageFailure = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-73)/2, 0, 73, 67)];
    imageFailure.image = [UIImage imageNamed:@"image_NoDataOrder.png"];
    [self addSubview:imageFailure];
    
    UILabel* labelFailure = [[UILabel alloc]initWithFrame:CGRectMake(0, imageFailure.frame.origin.y+imageFailure.frame.size.height+15, SCREEN_WIDTH, 14)];
    labelFailure.text = @"加载失败";
    labelFailure.textColor = RGBA(123, 122, 152, 1);
    labelFailure.font = MKFONT(14);
    labelFailure.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelFailure];
    
    UIButton* btnTryAgain = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTryAgain.frame = CGRectMake((SCREEN_WIDTH-146/2)/2, labelFailure.frame.origin.y+labelFailure.frame.size.height+25, 146/2, 24);
    [btnTryAgain setTitle:@"重新加载" forState:UIControlStateNormal];
    [btnTryAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTryAgain.titleLabel.font = MKFONT(14);
    btnTryAgain.backgroundColor = RGBA(117, 112, 255, 1);
    btnTryAgain.layer.masksToBounds = YES;
    btnTryAgain.layer.cornerRadius = btnTryAgain.frame.size.height/2;
    [btnTryAgain addTarget:self action:@selector(onButtonAgain) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnTryAgain];
}

-(void)onButtonAgain
{
    if (self.refreshData)
    {
        self.refreshData();
    }
}

@end
