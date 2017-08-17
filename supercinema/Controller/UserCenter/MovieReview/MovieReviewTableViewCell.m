//
//  MovieReviewTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 9/12/16.
//
//

#import "MovieReviewTableViewCell.h"

@implementation MovieReviewTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:RGBA(246, 246, 251, 1)];
        [self initController];
    }
    return self;
}

-(void)initController
{
    //背景
    //UILabel *labelWhiteBG = [UILabel alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
    //影片Logo
    _imageLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageLogo setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_imageLogo];
    
    //影片名字
    _labelName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelName setBackgroundColor:[UIColor clearColor]];
    [_labelName setFont:MKFONT(15)];
    [_labelName setTextColor:RGBA(51, 51, 51, 1)];
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_labelName];
    
    //评分
    _labelScore = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelScore setBackgroundColor:[UIColor clearColor]];
    [_labelScore setFont:MKFONT(12)];
    [_labelScore setTextColor:RGBA(85, 85, 85, 1)];
    [_labelScore setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_labelScore];
    
    _labelMyScore = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelMyScore setBackgroundColor:[UIColor clearColor]];
    [_labelMyScore setFont:MKFONT(12)];
    [_labelMyScore setTextColor:RGBA(85, 85, 85, 1)];
    [_labelMyScore setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_labelMyScore];
    
    //短评
    _labelMovieReview = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelMovieReview setBackgroundColor:[UIColor clearColor]];
    [_labelMovieReview setFont:MKFONT(14)];
    [_labelMovieReview setTextColor:RGBA(51, 51, 51, 1)];
    [_labelMovieReview setTextAlignment:NSTextAlignmentLeft];
    _labelMovieReview.numberOfLines = 2;
    _labelMovieReview.lineBreakMode = NSLineBreakByCharWrapping;
    _labelMovieReview.lineBreakMode = NSLineBreakByTruncatingTail;//结尾部分的内容以。。。显示
    [self.contentView addSubview:_labelMovieReview];
    
    //有效期
    _labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelDate setBackgroundColor:[UIColor clearColor]];
    [_labelDate setFont:MKFONT(12)];
    [_labelDate setTextColor:RGBA(123, 122, 152, 1)];
    [_labelDate setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_labelDate];
    
    //上映状态
    _labelMovieType = [[UILabel alloc] initWithFrame:CGRectZero];
    [_labelMovieType setBackgroundColor:[UIColor clearColor]];
    [_labelMovieType setFont:MKFONT(14)];
    [_labelMovieType setTextAlignment:NSTextAlignmentRight];
    _labelMovieType.hidden = YES;
    [self.contentView addSubview:_labelMovieType];
    
    self.backgroundColor = [UIColor whiteColor];
}

-(void)setMovieReviewCellFrameAndData:(MyMovieModel *)myMovieModel sysTime:(NSNumber*)systemTime
{
    //影片Logo
    _imageLogo.frame = CGRectMake(15, 30, 75, 100);
    [Tool downloadImage:myMovieModel.logoUrl button:nil imageView:_imageLogo defaultImage:@"img_homelogo_small_default.png"];
//    [_imageLogo sd_setImageWithURL:[NSURL URLWithString:myMovieModel.logoUrl] placeholderImage:[UIImage imageNamed:@"img_homelogo_small_default.png"]];
    //影片名字
    _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, _imageLogo.frame.origin.y, SCREEN_WIDTH/2, 15);
    [_labelName setText:myMovieModel.movieTitle];
    //评分
    _labelScore.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+7, SCREEN_WIDTH/2, 12);
    if ([myMovieModel.rate length] == 0)
    {
        [_labelScore setText:@"暂无评分"];
    }
    else
    {
        [_labelScore setText:[NSString stringWithFormat:@"总评分：%@",myMovieModel.rate]];
    }
    [Tool setLabelSpacing:_labelScore spacing:2 alignment:NSTextAlignmentLeft];
    _labelScore.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+7, _labelScore.frame.size.width, 12);
    
    if ([myMovieModel.myRate length] > 0)
    {
        _labelMyScore.frame = CGRectMake(_labelScore.frame.origin.x+_labelScore.frame.size.width, _labelScore.frame.origin.y, 150, 12);
        [_labelMyScore setText:[NSString stringWithFormat:@" / 我的评分：%@",myMovieModel.myRate]];
    }
    //短评
//    _labelMovieReview.frame = CGRectMake(_labelName.frame.origin.x, _labelScore.frame.origin.y+_labelScore.frame.size.height+10, SCREEN_WIDTH-75-15*3, 34);//35
    [_labelMovieReview setText:myMovieModel.shortDescription];
    
    int highOnly = 14; //只有一行时候的高度
    int highTwo = 34;  //只有两行时候的高度
    int highReal = 34; //实际高度 同时也是默认高度
    
    if (IPhone5)
    {
        //苹果5 5s 4 4s
        if (_labelMovieReview.text.length < 15)
        {
            highReal = highOnly;
        }
        else
        {
            highReal = highTwo;
        }
    }
    if (IPhone6)
    {
        //苹果6 6s
        if (_labelMovieReview.text.length < 18)
        {
            highReal = highOnly;
        }
        else
        {
            highReal = highTwo;
        }
    }
    if (IPhone6plus)
    {
        //苹果6P 6sP
        if (_labelMovieReview.text.length < 21)
        {
            highReal = highOnly;
        }
        else
        {
            highReal = highTwo;
        }
    }
    _labelMovieReview.frame = CGRectMake(_labelName.frame.origin.x, _labelScore.frame.origin.y+_labelScore.frame.size.height+10, SCREEN_WIDTH-75-15*3, highReal);

//        _labelMovieReview.frame = CGRectMake(_labelName.frame.origin.x, _labelScore.frame.origin.y+_labelScore.frame.size.height+10, SCREEN_WIDTH-75-15*3, 34);

//        [_labelMovieReview setText:myMovieModel.shortDescription];
    
    //有效期
    _labelDate.frame = CGRectMake(_labelName.frame.origin.x, 116, SCREEN_WIDTH/2, 15);
    [_labelDate setText:[Tool getLeftStartTime:myMovieModel.followTime endTime:systemTime]];
    //上映状态
    _labelMovieType.frame = CGRectMake(SCREEN_WIDTH-90-15, 116, 90, 15);
    //买票状态 -1:无状态,0：即将上映,1：正常购票,2：超前预售
    if ([myMovieModel.buyTicketStatus intValue] == -1)
    {
        _labelMovieType.hidden = YES;
    }
    if ([myMovieModel.buyTicketStatus intValue] == 0)
    {
        _labelMovieType.hidden = NO;
        [_labelMovieType setTextColor:RGBA(253, 189, 34, 1)];
        [_labelMovieType setText:@"即将上映"];
    }
    if ([myMovieModel.buyTicketStatus intValue] == 1)
    {
        _labelMovieType.hidden = NO;
        [_labelMovieType setTextColor:RGBA(117, 112, 255, 1)];
        [_labelMovieType setText:@"正在热映"];
    }
    if ([myMovieModel.buyTicketStatus intValue] == 2)
    {
        _labelMovieType.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
