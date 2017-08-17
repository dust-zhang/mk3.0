//
//  CommentHeadTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/28.
//
//

#import "CommentHeadTableViewCell.h"

@implementation CommentHeadTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _labelMyComment = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelMyComment.font = MKFONT(15);
        _labelMyComment.backgroundColor = [UIColor clearColor];
        _labelMyComment.textColor = RGBA(51, 51, 51, 1);
        _labelMyComment.text = @"我的短评";
        [self.contentView addSubview:_labelMyComment];
        
        _labelGanggang = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelGanggang.font = MKFONT(11);
        _labelGanggang.backgroundColor = [UIColor clearColor];
        _labelGanggang.textColor = RGBA(123, 122, 152, 1);
        [self.contentView addSubview:_labelGanggang];
        
        _imgCommentIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgCommentIcon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imgCommentIcon];
        
        _labelCommentText = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelCommentText.font = MKFONT(12);
        _labelCommentText.backgroundColor = [UIColor clearColor];
        _labelCommentText.textColor = RGBA(180, 180, 180, 1);
        [self.contentView addSubview:_labelCommentText];
        
        _btnPoints = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPoints.frame = CGRectZero;
        _btnPoints.backgroundColor = [UIColor clearColor];
        [_btnPoints setBackgroundImage:[UIImage imageNamed:@"btn_moreBlack.png"] forState:UIControlStateNormal];
        [_btnPoints addTarget:self action:@selector(onButtonPoints) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnPoints];
        
        _labelMyCommentDesc = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 0)];
        _labelMyCommentDesc.font = MKFONT(14);
        _labelMyCommentDesc.backgroundColor = [UIColor clearColor];
        _labelMyCommentDesc.textColor = RGBA(85, 85, 85, 1);
        _labelMyCommentDesc.numberOfLines = 2;
        _labelMyCommentDesc.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_labelMyCommentDesc];
        
        _viewBack = [[UIView alloc]initWithFrame:CGRectZero];
        _viewBack.backgroundColor = RGBA(246, 246, 251, 1);
        [self.contentView addSubview:_viewBack];
        
        _labelTotalComment = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelTotalComment.font = MKFONT(12);
        _labelTotalComment.textColor = RGBA(123, 122, 152, 1);
        [_viewBack addSubview:_labelTotalComment];
    }
    return self;
}

-(void)setData:(MovieReviewSummaryModel*)model icon:(NSArray*)imgArr count:(NSInteger)count
{
    _model = model;
    
    _labelMyComment.frame = CGRectMake(15, 40, [Tool calStrWidth:_labelMyComment.text height:15], 15);
    
    if ([model.movieReview.score intValue]>0 && [model.movieReview.score intValue] <=10)
    {
        NSInteger index = [model.movieReview.score intValue]/2 - 1;
        NSArray* arrScore = [imgArr objectAtIndex:index];
        _imgCommentIcon.image = [UIImage imageNamed:arrScore[0]];
        _imgCommentIcon.frame = CGRectMake(SCREEN_WIDTH - 217/2-20, _labelMyComment.frame.origin.y-5/2, 20, 20);
        
        _labelCommentText.text = arrScore[1];
        _labelCommentText.frame = CGRectMake(_imgCommentIcon.frame.origin.x+_imgCommentIcon.frame.size.width+10, _imgCommentIcon.frame.origin.y, 80, _imgCommentIcon.frame.size.height);
    }
    
    if (model.movieReview.content.length>0)
    {
        _labelGanggang.text = [Tool getLeftStartTime:model.movieReview.publishTime endTime:model.currentTime];
        _labelGanggang.frame = CGRectMake(_labelMyComment.frame.origin.x+_labelMyComment.frame.size.width+15, _labelMyComment.frame.origin.y+4, 100, 11);

        _labelMyCommentDesc.text = model.movieReview.content;
        [_labelMyCommentDesc sizeToFit];
        _labelMyCommentDesc.frame = CGRectMake(15, _labelMyComment.frame.origin.y+_labelMyComment.frame.size.height+15, SCREEN_WIDTH-30, _labelMyCommentDesc.frame.size.height);
        
        _btnPoints.frame = CGRectMake(SCREEN_WIDTH-15-30, _labelMyComment.frame.origin.y+(_labelMyComment.frame.size.height-30)/2, 45, 30);
    }
    else
    {
        _labelGanggang.text = @"";
        
        _labelMyCommentDesc.text = @"说说你的看法，写条短评吧";
        _labelMyCommentDesc.textColor = RGBA(180, 180, 180, 1);
        _labelMyCommentDesc.frame = CGRectMake(15, _labelMyComment.frame.origin.y+_labelMyComment.frame.size.height+15, SCREEN_WIDTH-30, 14);
        
        _btnPoints.frame = CGRectZero;
    }
    
    if (count > 0)
    {
        _viewBack.frame = CGRectMake(0, _labelMyCommentDesc.frame.origin.y+_labelMyCommentDesc.frame.size.height+15, SCREEN_WIDTH, 42);
        _labelTotalComment.text = [NSString stringWithFormat:@"共%ld条短评",(long)count];
        _labelTotalComment.frame = CGRectMake(15, 20, 200, 12);
    }
}

-(void)onButtonComment
{
    if ([self.cHDelegate respondsToSelector:@selector(toComment)])
    {
        [MobClick event:mainViewbtn139];
        [self.cHDelegate toComment];
    }
}

-(void)onButtonPoints
{
    if ([self.cHDelegate respondsToSelector:@selector(threePoints:)])
    {
        [self.cHDelegate threePoints:_model.movieReview.id];
    }
}

@end
