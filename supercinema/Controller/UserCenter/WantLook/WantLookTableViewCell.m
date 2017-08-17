//
//  WantLookTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 9/12/16.
//
//

#import "WantLookTableViewCell.h"

@implementation WantLookTableViewCell

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
    [self.contentView addSubview:_labelMovieType];
    
    self.backgroundColor = [UIColor whiteColor];
}

-(void)setWantLookCellFrameAndData:(MovieModel *)movieModel sysTime:(NSNumber*)systemTime
{
    //影片Logo
    _imageLogo.frame = CGRectMake(15, 30, 75, 100);
    [_imageLogo sd_setImageWithURL:[NSURL URLWithString:movieModel.logoUrl] placeholderImage:[UIImage imageNamed:@"img_homelogo_small_default.png"]];
    //影片名字
    _labelName.frame = CGRectMake(_imageLogo.frame.origin.x+_imageLogo.frame.size.width+15, _imageLogo.frame.origin.y, SCREEN_WIDTH/2, 15);
    [_labelName setText:movieModel.movieTitle];
    //评分
    _labelScore.frame = CGRectMake(_labelName.frame.origin.x, _labelName.frame.origin.y+_labelName.frame.size.height+7, SCREEN_WIDTH/2, 12);
    if ([movieModel.rate length] == 0)
    {
        [_labelScore setText:@"暂无评分"];
    }
    else
    {
        [_labelScore setText:[NSString stringWithFormat:@"总评分：%@",movieModel.rate]];
    }
    //有效期
    _labelDate.frame = CGRectMake(_labelName.frame.origin.x, 116, SCREEN_WIDTH/2, 15);
    [_labelDate setText:[Tool getLeftStartTime:movieModel.followTime endTime:systemTime]];
    //上映状态
    _labelMovieType.frame = CGRectMake(SCREEN_WIDTH-90-15, 116, 90, 15);
    _labelMovieType.hidden  = YES;
    //买票状态 -1:无状态,0：即将上映,1：正常购票,2：超前预售
    if ([movieModel.buyTicketStatus intValue] == 0)
    {
        _labelMovieType.hidden  = NO;
        [_labelMovieType setTextColor:RGBA(253, 189, 34, 1)];
        [_labelMovieType setText:@"即将上映"];
    }
    if ([movieModel.buyTicketStatus intValue] == 1)
    {
        _labelMovieType.hidden  = NO;
        [_labelMovieType setTextColor:RGBA(117, 112, 255, 1)];
        [_labelMovieType setText:@"正在热映"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
