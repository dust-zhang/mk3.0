//
//  MovieCollectionViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 16/8/9.
//
//

#import "MovieCollectionViewCell.h"

@implementation MovieCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        //logo
        _imageLogo = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_imageLogo];
        
        _imgBack = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgBack.image = [UIImage imageNamed:@"img_homeMovie_default.png"];
        [self.contentView addSubview:_imgBack];
        
        //豆瓣icon
        _imageScore = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageScore.image = [UIImage imageNamed:@"poster_douban.png"];
        [self.contentView addSubview:_imageScore];
        
        //评分
        _labelScore = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelScore.font = MKFONT(11);
        _labelScore.textColor = [UIColor whiteColor];
        _labelScore.shadowColor = RGBA(0, 0, 0, 0.4);
        [self.contentView addSubview:_labelScore];
        
        //电影名
        _labelMovieName = [[UILabel alloc]initWithFrame:CGRectMake(15, frame.size.height - 15 - 15, frame.size.width-30, 15)];
        _labelMovieName.textColor = [UIColor whiteColor];
        _labelMovieName.font = MKFONT(15);
        _labelMovieName.shadowColor = RGBA(0, 0, 0, 0.4);
        [self.contentView addSubview:_labelMovieName];
    
//        //影厅特色
//        _labelHall = [[UILabel alloc]initWithFrame:CGRectMake(15, _labelMovieName.frame.origin.y+_labelMovieName.frame.size.height+15 , frame.size.width-15, 11)];
//        _labelHall.textColor = [UIColor whiteColor];
//        _labelHall.font = MKFONT(11);
//        [self.contentView addSubview:_labelHall];
        
        //购票按钮
        _btnTicket = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnTicket.frame = CGRectZero;
        [_btnTicket setBackgroundImage:[UIImage imageNamed:@"btn_ticket.png"] forState:UIControlStateNormal];
        [_btnTicket addTarget:self action:@selector(onButtonTicket) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnTicket];
    }
    return self;
}

-(void)setData:(MovieModel*)model isNoMore:(BOOL)isNoMore
{
    if (isNoMore)
    {
        _imageLogo.image = [UIImage imageNamed:@"img_home_noMore.png"];
        _imageLogo.frame = CGRectMake(1.5, 1.5, SCREEN_WIDTH/2-1.5, SCREEN_WIDTH/2 * 526/372-3);
        
        self.isNoMoreCell = YES;
        [self setUIHide:YES];
    }
    else
    {
        [self setUIHide:NO];
        _movieModel = model;
        if ([model.doubanRate floatValue]>0)
        {
            _labelScore.text = model.doubanRate;
        }
        else
        {
            _labelScore.text = @"";
            _imageScore.hidden = YES;
        }
        _labelMovieName.text = model.movieTitle;
        [Tool downloadImage:model.logoUrl button:nil imageView:_imageLogo defaultImage:@"img_homelogo_default.png"];
        if ([model.buyTicketStatus integerValue] == 0)
        {
            //不能购票
            _btnTicket.hidden = YES;
        }
        else
        {
            _btnTicket.hidden = NO;
        }
        self.isNoMoreCell = NO;
        
        if (!self.isHotMovie)
        {
            //即将上映
            NSString* strReleaseDate;
            
            NSString* strDate = model.releaseDate;
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSDate* date = [formatter dateFromString:strDate];
            [formatter setDateFormat:@"YYYY"];
            NSString* strYear = [formatter stringFromDate:date];
            
            //获取当前年份
            NSDate *now = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
            NSInteger curYear = [dateComponent year];
            
            if ([strYear integerValue] == curYear)
            {
                //即将上映的年份是当前年份
                [formatter setDateFormat:@"MM月dd日"];
                strReleaseDate = [formatter stringFromDate:date];
            }
            else
            {
                [formatter setDateFormat:@"yyyy年MM月dd日"];
                strReleaseDate = [formatter stringFromDate:date];
            }
            strReleaseDate = [strReleaseDate stringByAppendingString:@"   上映"];
            _labelScore.text = strReleaseDate;
            _imageScore.hidden = YES;
        }
    }
}

-(void)setUIHide:(BOOL)isHide
{
    _imageScore.hidden = isHide;
    _labelScore.hidden = isHide;
    _labelMovieName.hidden = isHide;
    _btnTicket.hidden = isHide;
}

-(void)layoutFrame:(BOOL)isLeft
{
    if (isLeft)
    {
        _imageLogo.frame = CGRectMake(0, 1.5, self.frame.size.width-1.5, self.frame.size.height-3);
        _imgBack.frame = CGRectMake(0, self.frame.size.height-1.5-100, self.frame.size.width-1.5, 100);
        _labelMovieName.frame = CGRectMake(15, self.frame.size.height -1.5 - 15 - 15, self.frame.size.width-30-1.5, 15);
    }
    else
    {
        _imageLogo.frame = CGRectMake(1.5, 1.5, self.frame.size.width-1.5, self.frame.size.height-3);
        _imgBack.frame = CGRectMake(1.5, self.frame.size.height-1.5-100, self.frame.size.width-1.5, 100);
        _labelMovieName.frame = CGRectMake(15+1.5, self.frame.size.height -1.5 - 15 - 15, self.frame.size.width-30-1.5, 15);
    }
    CGFloat width = [Tool calStrWidth:_labelScore.text height:11];
    if (!self.isHotMovie)
    {
        _labelScore.frame = CGRectMake(_labelMovieName.frame.origin.x, _labelMovieName.frame.origin.y-7-11, width, 11);
    }
    else
    {
        if ([_movieModel.doubanRate floatValue]>0)
        {
            _imageScore.frame = CGRectMake(15, _labelMovieName.frame.origin.y-7-12, 12, 12);
            _labelScore.frame = CGRectMake(_imageScore.frame.origin.x+_imageScore.frame.size.width+5, _labelMovieName.frame.origin.y-7-11, width, 11);
        }
    }
    _btnTicket.frame = CGRectMake(_imgBack.frame.origin.x+_imgBack.frame.size.width-42, _labelMovieName.frame.origin.y-7-23, 42, 23);
}

-(void)onButtonTicket
{
    if ([self.cellDelegate respondsToSelector:@selector(buyTicket:)])
    {
        [self.cellDelegate buyTicket:_movieModel];
    }
}

@end
