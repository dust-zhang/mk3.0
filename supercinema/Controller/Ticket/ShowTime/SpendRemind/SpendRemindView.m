//
//  SpendRemindView.m
//  supercinema
//
//  Created by Mapollo28 on 2017/4/13.
//
//

#import "SpendRemindView.h"

@implementation SpendRemindView

-(instancetype) initWithFrame:(CGRect)frame arrRemind:(NSArray*)arrRemind
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initController:arrRemind];
    }
    return self;
}

- (void)initController:(NSArray*)arrRemind
{
    CGFloat widthBack = SCREEN_WIDTH - 70;
    CGFloat heightBack = widthBack*10/7;
    
    UIView* viewBackground = [[UIView alloc ] initWithFrame:CGRectMake(35,(SCREEN_HEIGHT-heightBack)/2,widthBack, heightBack)];
    [viewBackground setBackgroundColor:[UIColor whiteColor]];
    [viewBackground.layer setMasksToBounds:YES];
    [viewBackground.layer setCornerRadius:10];
    [self addSubview:viewBackground];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(widthBack - 33 ,0,33, 33)];
    [closeBtn setImage:[UIImage imageNamed:@"btn_notifictionClose.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(onButtonClose) forControlEvents:UIControlEventTouchUpInside];
    [viewBackground addSubview:closeBtn];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,76/2,widthBack,18)];
    labelTitle.font = MKFONT(18);
    labelTitle.textColor = RGBA(51, 51, 51, 1);
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.text = @"消费提醒";
    [viewBackground addSubview:labelTitle];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,labelTitle.frame.origin.y+labelTitle.frame.size.height+15,widthBack, heightBack- labelTitle.frame.origin.y-labelTitle.frame.size.height-15 - 30)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [viewBackground addSubview:_scrollView];
    
    UIImageView *imageRemind = [[UIImageView alloc] initWithFrame:CGRectMake(15,0,widthBack-30,(widthBack-30)/2)];
    imageRemind.layer.cornerRadius = 5;
    imageRemind.layer.masksToBounds = YES;
    imageRemind.image = [UIImage imageNamed:@"img_default_remind.png"];
    [_scrollView addSubview:imageRemind];
    
    NSString* strRemind = arrRemind[0];
    for (int i = 1; i<arrRemind.count; i++)
    {
        NSString* str = arrRemind[i];
        strRemind = [strRemind stringByAppendingString:[NSString stringWithFormat:@"\n%@",str]];
    }
    
    UILabel* labelRemind = [[UILabel alloc]initWithFrame:CGRectMake(15, imageRemind.frame.origin.y+imageRemind.frame.size.height+20, widthBack-30, 12)];
    labelRemind.text = strRemind;
    labelRemind.font = MKFONT(12);
    labelRemind.textColor = RGBA(102, 102, 102, 1);
    labelRemind.lineBreakMode = NSLineBreakByCharWrapping;
    labelRemind.numberOfLines = 0;
    [Tool setLabelSpacing:labelRemind spacing:8 alignment:NSTextAlignmentLeft];
    [_scrollView addSubview:labelRemind];
    
    _scrollView.contentSize = CGSizeMake(0, labelRemind.frame.origin.y+labelRemind.frame.size.height);
}

- (void)onButtonClose
{
    if (self.hideSpend)
    {
        self.hideSpend();
    }
}


@end
