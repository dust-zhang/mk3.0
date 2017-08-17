//
//  CDetailHeadTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/30.
//
//

#import "CDetailHeadTableViewCell.h"

@implementation CDetailHeadTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _isBtnCanTouch = YES;
        
        //头像
        _btnHead = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnHead.frame = CGRectZero;
        [_btnHead addTarget:self action:@selector(onButtonHead) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnHead];
        
        //用户名
        _labelUserName = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelUserName.textColor = RGBA(51,51,51,1);
        _labelUserName.font = MKFONT(15);
        [self.contentView addSubview:_labelUserName];
        
        //评论icon
        _imgCommentIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgCommentIcon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imgCommentIcon];
        
        //评论结果
        _labelCommentText = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelCommentText.font = MKFONT(12);
        _labelCommentText.textColor = RGBA(180, 180, 180, 1);
        [self.contentView addSubview:_labelCommentText];
        
        //关注按钮
        _btnFocus = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnFocus.frame = CGRectZero;
        _btnFocus.tag = 0;
        [_btnFocus addTarget:self action:@selector(onButtonFocus:) forControlEvents:UIControlEventTouchUpInside];
        _btnFocus.titleLabel.font = MKFONT(12);
        [self.contentView addSubview:_btnFocus];

        //评论详情
        _labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 0)];
        _labelDetail.textColor = RGBA(85,85,85,1);
        _labelDetail.font = MKFONT(14);
        _labelDetail.numberOfLines = 0;
        _labelDetail.lineBreakMode = NSLineBreakByCharWrapping;
        _labelDetail.userInteractionEnabled = YES;
        [self.contentView addSubview:_labelDetail];
        
        //点赞icon
        _btnDianzan = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnDianzan.frame = CGRectZero;
        _btnDianzan.tag = 10;
        [_btnDianzan addTarget:self action:@selector(onButtonDianzan:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnDianzan];
        
        //点赞数
        _labelCount = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelCount.font = MKFONT(12);
        _labelCount.textColor = RGBA(153, 153, 153, 1);
        [self.contentView addSubview:_labelCount];
        
        //分割线
        _viewLine = [[UIView alloc]initWithFrame:CGRectZero];
        _viewLine.backgroundColor = RGBA(0, 0, 0, 0.05);
        [self.contentView addSubview:_viewLine];
        
        //影片名
        _labelMovieName = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelMovieName.font = MKFONT(15);
        _labelMovieName.textColor = RGBA(51, 51, 51, 1);
        [self.contentView addSubview:_labelMovieName];
        
        //日期/国家
        _labelDate = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelDate.font = MKFONT(12);
        _labelDate.textColor = RGBA(123, 122, 152, 1);
        [self.contentView addSubview:_labelDate];
        
        //评分
        _labelScore = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelScore.font = MKFONT(15);
        _labelScore.textColor = RGBA(51, 51, 51, 1);
        _labelScore.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_labelScore];
        
        //回复数背景
        _viewBack = [[UIView alloc]initWithFrame:CGRectZero];
        _viewBack.backgroundColor = RGBA(246, 246, 251, 1);
        [self.contentView addSubview:_viewBack];
        
        //回复数
        _labelTotalComment = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelTotalComment.font = MKFONT(12);
        _labelTotalComment.textColor = RGBA(123, 122, 152, 1);
        [_viewBack addSubview:_labelTotalComment];
    }
    return self;
}

-(void)setData:(MovieReviewDetailModel*)model icon:(NSArray*)imgArr count:(NSInteger)count
{
    _model = model;
    
    _btnHead.frame = CGRectMake(15, 15, 31, 31);
    _btnHead.layer.masksToBounds = YES;
    _btnHead.layer.cornerRadius = _btnHead.frame.size.height/2;
    _btnHead.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];
    _btnHead.layer.borderWidth = 0.5;
    [Tool downloadImage:model.movieReview.publishUser.portraitUrl button:_btnHead imageView:nil defaultImage:@"image_defaultHead1.png"];
    NSString* strUserName = model.movieReview.publishUser.nickname;
    if (SCREEN_WIDTH == 320)
    {
        if (strUserName.length>7)
        {
            strUserName = [[strUserName substringWithRange:NSMakeRange(0, 6)] stringByAppendingString:@"..."];
        }
    }
    else
    {
        if (strUserName.length>10)
        {
            strUserName = [[strUserName substringWithRange:NSMakeRange(0, 9)] stringByAppendingString:@"..."];
        }
    }
    _labelUserName.text = strUserName;
    _labelUserName.frame = CGRectMake(_btnHead.frame.origin.x+_btnHead.frame.size.width+15, _btnHead.frame.origin.y+(_btnHead.frame.size.height-15)/2, [Tool calStrWidth:strUserName height:15], 15);
    
    if ([model.followButtonStatus intValue] != 0)
    {
        _btnFocus.frame = CGRectMake(SCREEN_WIDTH-15-60, _btnHead.frame.origin.y+(_btnHead.frame.size.height-25)/2, 60, 25);
        _btnFocus.layer.cornerRadius = _btnFocus.frame.size.height/2;
        
        if ([model.followPersonRelation intValue] == 2)
        {
            //未关注
            _btnFocus.tag = 20;
            [_btnFocus setBackgroundColor:RGBA(117, 112, 255, 1)];
            [_btnFocus setTitle:@"关注" forState:UIControlStateNormal];
            _btnFocus.layer.masksToBounds = NO;
            _btnFocus.layer.borderColor = [[UIColor clearColor] CGColor];
            _btnFocus.layer.borderWidth = 0;
            [_btnFocus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            _btnFocus.tag = 21;
            [_btnFocus setBackgroundColor:[UIColor clearColor]];
            _btnFocus.layer.masksToBounds = YES;
            _btnFocus.layer.borderColor = [RGBA(123, 122, 152, 1) CGColor];
            _btnFocus.layer.borderWidth = 1;
            [_btnFocus setTitle:@"已关注" forState:UIControlStateNormal];
            [_btnFocus setTitleColor:RGBA(123, 122, 152, 1) forState:UIControlStateNormal];
        }
    }
    
    if ([model.movieReview.score intValue]>0 && [model.movieReview.score intValue] <=10)
    {
        NSInteger index = [model.movieReview.score intValue]/2 - 1;
        NSArray* arrScore = [imgArr objectAtIndex:index];
        _imgCommentIcon.image = [UIImage imageNamed:arrScore[0]];
        _labelCommentText.text = arrScore[1];
        _labelCommentText.frame = CGRectMake(_btnFocus.frame.origin.x - 15 - [Tool calStrWidth:_labelCommentText.text height:12], _btnHead.frame.origin.y+(_btnHead.frame.size.height-12)/2, [Tool calStrWidth:_labelCommentText.text height:12], 12);
        _imgCommentIcon.frame = CGRectMake(_labelCommentText.frame.origin.x-5-20, _btnHead.frame.origin.y+(_btnHead.frame.size.height-20)/2, 20, 20);
    }

    _labelDetail.text = model.movieReview.content;
    [_labelDetail sizeToFit];
    _labelDetail.frame = CGRectMake(15, _btnHead.frame.origin.y+_btnHead.frame.size.height+15, SCREEN_WIDTH-30, _labelDetail.frame.size.height);
    
    if ([model.movieReview.laudStatus intValue] == 1)
    {
        //点赞状态
        _btnDianzan.tag = 11;
        [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
        _labelCount.text = [Tool getPersonCount:model.movieReview.laudCount];
    }
    else
    {
        //未点赞状态
        _btnDianzan.tag = 10;
        [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_not_zan.png"] forState:UIControlStateNormal];
        _labelCount.text = [Tool getPersonCount:model.movieReview.laudCount];
    }
    _btnDianzan.frame = CGRectMake(SCREEN_WIDTH-15-55, _labelDetail.frame.origin.y+_labelDetail.frame.size.height+15-8, 45, 25);
    _labelCount.frame = CGRectMake(_btnDianzan.frame.origin.x+_btnDianzan.frame.size.width-15, _btnDianzan.frame.origin.y+8, 40, 12);
    
    _viewLine.frame = CGRectMake(15, _btnDianzan.frame.origin.y+_btnDianzan.frame.size.height+15-4, SCREEN_WIDTH-15, 0.5);
    
    NSString* strName = model.movie.movieTitle;
    if (strName.length>10)
    {
        strName = [strName substringWithRange:NSMakeRange(0, 9)];
        strName = [strName stringByAppendingString:@"..."];
    }
    _labelMovieName.text = strName;// @"遇见你之前";
    _labelMovieName.frame = CGRectMake(15, _viewLine.frame.origin.y+_viewLine.frame.size.height+15, [Tool calStrWidth:_labelMovieName.text height:15], 15);
    
    NSMutableArray* arrDate = [[NSMutableArray alloc]initWithObjects:model.movie.releaseDate, nil];
    [arrDate addObjectsFromArray:model.movie.originCountryList];
    _labelDate.text = [Tool cutString:arrDate];//@"2016／芬兰／美国";
    _labelDate.frame = CGRectMake(_labelMovieName.frame.origin.x+_labelMovieName.frame.size.width+10, _labelMovieName.frame.origin.y+3/2, [Tool calStrWidth:_labelDate.text height:12], 12);
    
    float score = [model.movie.rate floatValue];
    NSString *strSore = [NSString stringWithFormat:@"%.1f分",score];
    NSUInteger countLength1 = [[NSString stringWithFormat:@"%.1f", score] length];
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:strSore];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(15) range:NSMakeRange(0, countLength1)];
    [strAtt addAttribute:NSFontAttributeName value:MKFONT(12) range:NSMakeRange(countLength1, 1)];
    _labelScore.attributedText = strAtt;
    _labelScore.frame = CGRectMake(SCREEN_WIDTH-15-100, _labelMovieName.frame.origin.y, 100, 15);
    
    _viewBack.frame = CGRectMake(0, _labelMovieName.frame.origin.y+_labelMovieName.frame.size.height+15, SCREEN_WIDTH, 42);
    
    _labelTotalComment.text = [NSString stringWithFormat:@"共%ld条回复",(long)count];
    _labelTotalComment.frame = CGRectMake(15, 20, 200, 12);
}

-(void)onButtonHead
{
    //跳到个人主页
    if ([self.cHDelegate respondsToSelector:@selector(toUserHome:)])
    {
        [self.cHDelegate toUserHome:_model.movieReview.publishUser.id];
    }
}

-(void)onButtonFocus:(UIButton*)btn
{
    [MobClick event:mainViewbtn148];
    BOOL state = NO;
    if (btn.tag == 20)
    {
        state = YES;
    }
    else
    {
        
    }
    if ([self.cHDelegate respondsToSelector:@selector(focusComment:state:)])
    {
        [self.cHDelegate focusComment:_model.movieReview.publishUser.id state:state];
    }
}

-(void)onButtonDianzan:(UIButton*)btn
{
    if (!_isBtnCanTouch)
    {
        return;
    }
    [MobClick event:mainViewbtn147];
    _isBtnCanTouch = NO;
    if (btn.tag == 11)
    {
        //取消点赞
        _model.movieReview.laudStatus = [NSNumber numberWithInt:0];
        _model.movieReview.laudCount = [NSNumber numberWithInteger:[_model.movieReview.laudCount integerValue]-1];
        [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_not_zan.png"] forState:UIControlStateNormal];
        _labelCount.text = [Tool getPersonCount:_model.movieReview.laudCount];
        [ServicesMovie cancelLikeMovieReviewOrComment:[_model.movieReview.id stringValue] model:^(RequestResult *movieDetail) {
            NSLog(@"取消点赞成功");
            btn.tag = 10;
            _isBtnCanTouch = YES;
        } failure:^(NSError *error) {
            _model.movieReview.laudStatus = [NSNumber numberWithInt:1];
            _model.movieReview.laudCount = [NSNumber numberWithInteger:[_model.movieReview.laudCount integerValue]+1];
            [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
            _labelCount.text = [Tool getPersonCount:_model.movieReview.laudCount];
            _isBtnCanTouch = YES;
        }];
    }
    else
    {
        //点赞
        _model.movieReview.laudStatus = [NSNumber numberWithInt:1];
        _model.movieReview.laudCount = [NSNumber numberWithInteger:[_model.movieReview.laudCount integerValue]+1];
        [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
        _labelCount.text = [Tool getPersonCount:_model.movieReview.laudCount];
        [ServicesMovie likeMovieReviewOrComment:[_model.movieReview.id stringValue] model:^(RequestResult *movieDetail) {
            NSLog(@"点赞成功");
            btn.tag = 11;
            _isBtnCanTouch = YES;
        } failure:^(NSError *error) {
            _model.movieReview.laudStatus = [NSNumber numberWithInt:0];
            _model.movieReview.laudCount = [NSNumber numberWithInteger:[_model.movieReview.laudCount integerValue]-1];
            [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_not_zan.png"] forState:UIControlStateNormal];
            _labelCount.text = [Tool getPersonCount:_model.movieReview.laudCount];
            _isBtnCanTouch = YES;
        }];
    }
}

@end
