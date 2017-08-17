//
//  PlotSummaryViewController.m
//  supercinema
//
//  Created by lianyanmin on 17/3/27.
//
//

#import "MovieDetialView.h"

@implementation MovieDetialView

-(instancetype) initWithFrame:(CGRect)frame model:(MovieModel *)movieModel
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initController:movieModel];
    }
    return self;
}

- (void)initController:(MovieModel *)movieModel
{
    UIView *viewWhiteBackground = [[UIView alloc ] initWithFrame:CGRectMake((SCREEN_WIDTH-610/2)/2,(SCREEN_HEIGHT-840/2)/2,610/2, 840/2)];
    [viewWhiteBackground setBackgroundColor:[UIColor whiteColor]];
    [viewWhiteBackground.layer setMasksToBounds:YES];
    [viewWhiteBackground.layer setCornerRadius:10];
    [self addSubview:viewWhiteBackground];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewWhiteBackground.frame.size.width - 33 ,0,33, 33)];
    [closeBtn setImage:[UIImage imageNamed:@"btn_notifictionClose.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(onButtonClose) forControlEvents:UIControlEventTouchUpInside];
    [viewWhiteBackground addSubview:closeBtn];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,76/2,viewWhiteBackground.frame.size.width, (viewWhiteBackground.frame.size.height- 76/2) - 30)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [viewWhiteBackground addSubview:_scrollView];
    
    UILabel *labelOpera = [[UILabel alloc] initWithFrame:CGRectMake(0,0,_scrollView.frame.size.width,20)];
    labelOpera.font = MKFONT(18);
    labelOpera.textColor = [UIColor blackColor];
    labelOpera.textAlignment = NSTextAlignmentCenter;
    labelOpera.text = @"剧情介绍";
    [_scrollView addSubview:labelOpera];
    
    UIImageView *imageViewStills = [[UIImageView alloc] initWithFrame:CGRectMake(15,15 + 18,_scrollView.frame.size.width-30,134)];
    imageViewStills.layer.cornerRadius = 5;
    imageViewStills.layer.masksToBounds = YES;
    [imageViewStills sd_setImageWithURL:[NSURL URLWithString:movieModel.logoLandscapeUrl] placeholderImage:[UIImage imageNamed:@"poster_landscape.png"]];
    [_scrollView addSubview:imageViewStills];
    
    UIView *viewStillsShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageViewStills.frame.size.width,imageViewStills.frame.size.height)];
    viewStillsShadow.backgroundColor = RGBA(0, 0, 0, 0.5);
    [imageViewStills addSubview:viewStillsShadow];
    
    UILabel *labelCiname = [[UILabel alloc] initWithFrame:CGRectMake(15,45,viewStillsShadow.frame.size.width - 30,18)];
    labelCiname.font = MKFONT(18);
    labelCiname.textColor = [UIColor whiteColor];
    labelCiname.textAlignment = NSTextAlignmentCenter;
    labelCiname.text = movieModel.movieTitle;
    [viewStillsShadow addSubview:labelCiname];
    
    UILabel *labelWantSee = [[UILabel alloc] initWithFrame:CGRectMake(0,45+18+14,viewStillsShadow.frame.size.width,12)];
    labelWantSee.hidden = NO;
    labelWantSee.font = MKFONT(12);
    labelWantSee.textColor = RGBA(255, 255, 255, 0.7);
    labelWantSee.textAlignment = NSTextAlignmentCenter;
    if ([movieModel.followCount isEqual:@0]) {
        
        labelWantSee.hidden = YES;
        [labelWantSee removeFromSuperview];
        
    }
    NSString* followCount = [Tool getPersonCount:movieModel.followCount];
    labelWantSee.text = [NSString stringWithFormat:@"%@ 人想看",followCount];
    [viewStillsShadow addSubview:labelWantSee];
    
    UILabel *labelPlotSummary = [[UILabel alloc] initWithFrame:CGRectMake(15,18+15+134+20,_scrollView.frame.size.width - 30,0)];
    labelPlotSummary.numberOfLines = 0;
    labelPlotSummary.text = movieModel.plot;
    labelPlotSummary.font = MKFONT(12);
    labelPlotSummary.textColor = RGBA(102, 102, 102, 1);
//    labelPlotSummary.attributedText = [self setTextString:movieModel.plot];
    [labelPlotSummary sizeToFit];
    [_scrollView addSubview:labelPlotSummary];
    _scrollView.contentSize = CGSizeMake(0,closeBtn.frame.size.height + labelOpera.frame.size.height + imageViewStills.frame.size.height + labelPlotSummary.frame.size.height + 66);
}

- (void)onButtonClose
{
    if (self.hideDetail)
    {
        self.hideDetail();
    }
}

//label字体两端对齐
-(NSAttributedString *)setTextString:(NSString *)text
{
    NSMutableAttributedString *mAbStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *npgStyle = [[NSMutableParagraphStyle alloc] init];
    npgStyle.alignment = NSTextAlignmentJustified;
    npgStyle.paragraphSpacing = 11.0;
    npgStyle.paragraphSpacingBefore = 10.0;
    npgStyle.firstLineHeadIndent = 0.0;
    npgStyle.headIndent = 0.0;
    NSDictionary *dic = @{
                            NSForegroundColorAttributeName :[UIColor blackColor],
                            NSFontAttributeName            :MKFONT(13),
                            NSParagraphStyleAttributeName  :npgStyle,
                            NSUnderlineStyleAttributeName  :[NSNumber numberWithInteger:NSUnderlineStyleNone]
                          };
    [mAbStr setAttributes:dic range:NSMakeRange(0, mAbStr.length)];
    NSAttributedString *attrString = [mAbStr copy];
    return attrString;
}



@end
