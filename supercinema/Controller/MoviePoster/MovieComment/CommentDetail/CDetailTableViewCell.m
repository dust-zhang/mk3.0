//
//  CDetailTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/30.
//
//

#import "CDetailTableViewCell.h"

@implementation CDetailTableViewCell

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
        
        //举报（删除）
        _btnPoints = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPoints.frame = CGRectZero;
        [_btnPoints setBackgroundImage:[UIImage imageNamed:@"btn_moreBlack.png"] forState:UIControlStateNormal];
        [_btnPoints addTarget:self action:@selector(onButtonPoints) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnPoints];
        
        //评论详情
        _labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH-85, 0)];
        _labelDetail.textColor = RGBA(85,85,85,1);
        _labelDetail.font = MKFONT(14);
        _labelDetail.numberOfLines = 0;
        _labelDetail.userInteractionEnabled = YES;
        _labelDetail.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_labelDetail];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRespond)];
        [_labelDetail addGestureRecognizer:tap];

        //时间
        _labelDate = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelDate.font = MKFONT(11);
        _labelDate.textColor = RGBA(123, 122, 152, 1);
        [self.contentView addSubview:_labelDate];
        
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
    }
    return self;
}

-(void)setData:(MovieReviewCommentListModel *)model curTime:(NSNumber*)curTime
{
    _model = model;
    
    _btnHead.frame = CGRectMake(15, 15, 40, 40);
    _btnHead.layer.masksToBounds = YES;
    _btnHead.layer.cornerRadius = _btnHead.frame.size.height/2;
    _btnHead.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];
    _btnHead.layer.borderWidth = 0.5;
    [Tool downloadImage:model.publishUser.portraitUrl button:_btnHead imageView:nil defaultImage:@"image_defaultHead1.png"];
    _labelUserName.text = model.publishUser.nickname;//@"18K纯帅";
    _labelUserName.frame = CGRectMake(_btnHead.frame.origin.x+_btnHead.frame.size.width+15, 19, 200, 15);
    
    _btnPoints.frame = CGRectMake(SCREEN_WIDTH-15-30, _labelUserName.frame.origin.y+(_labelUserName.frame.size.height-30)/2, 45, 30);
    
    NSString* strContent = model.content;
    if (model.replyUser.nickname.length>0)
    {
        strContent = [NSString stringWithFormat:@"回复%@：%@",model.replyUser.nickname,strContent];
    }
    _labelDetail.text = strContent;//@"这个电影真的很一般，很一般的很一般，我看到了第二十分钟的时候就睡着了，太无聊了，今年最烂国产片没有之一。5毛钱的特效。";
    [_labelDetail sizeToFit];
    _labelDetail.frame = CGRectMake(_labelUserName.frame.origin.x, _labelUserName.frame.origin.y+_labelUserName.frame.size.height+15, SCREEN_WIDTH-_labelUserName.frame.origin.x-15, _labelDetail.frame.size.height);
    
    _labelDate.text =  [Tool getLeftStartTime:model.publishTime endTime:curTime];//[Tool returnTime:model.publishTime format:@"YYYY年MM月dd日"];//@"1小时前";
    _labelDate.frame = CGRectMake(_labelUserName.frame.origin.x, _labelDetail.frame.origin.y+_labelDetail.frame.size.height+15, 100, 11);
    
    if ([model.laudStatus intValue] == 1)
    {
        //点赞状态
        _btnDianzan.tag = 11;
        [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
        _labelCount.text = [Tool getPersonCount:model.laudCount];
    }
    else
    {
        //未点赞状态
        _btnDianzan.tag = 10;
        [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_not_zan.png"] forState:UIControlStateNormal];
        _labelCount.text = [Tool getPersonCount:model.laudCount];
    }
   
    _btnDianzan.frame = CGRectMake(SCREEN_WIDTH-25-45, _labelDate.frame.origin.y-(25-_labelDate.frame.size.height)+5-1.5, 45, 25);
    _labelCount.backgroundColor = [UIColor clearColor];
    _labelCount.frame = CGRectMake(_btnDianzan.frame.origin.x+_btnDianzan.frame.size.width-15, _labelDate.frame.origin.y-1-1.5, 40, 12);
}

-(void)tapRespond
{
    if (self.canTouch)
    {
        if ([self.cDelegate respondsToSelector:@selector(respondUser:)])
        {
            [self.cDelegate respondUser:_model];
        }
    }
    else
    {
        if ([self.cDelegate respondsToSelector:@selector(hideKeyboard)])
        {
            [self.cDelegate hideKeyboard];
        }
    }
}

-(void)onButtonHead
{
    //跳到个人主页
    if ([self.cDelegate respondsToSelector:@selector(toElseHome:)])
    {
        [self.cDelegate toElseHome:0];
    }
}

-(void)onButtonDianzan:(UIButton*)btn
{
    if (!_isBtnCanTouch)
    {
        return;
    }
    _isBtnCanTouch = NO;
    if (btn.tag == 11)
    {
        //取消点赞
        _model.laudStatus = [NSNumber numberWithInt:0];
        _model.laudCount = [NSNumber numberWithInteger:[_model.laudCount integerValue]-1];
        [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_not_zan.png"] forState:UIControlStateNormal];
         _labelCount.text = [Tool getPersonCount:_model.laudCount];
        [ServicesMovie cancelLikeMovieReviewOrComment:[_model.id stringValue] model:^(RequestResult *movieDetail) {
            NSLog(@"取消点赞成功");
            btn.tag = 10;
            _isBtnCanTouch = YES;
        } failure:^(NSError *error) {
            _model.laudStatus = [NSNumber numberWithInt:1];
            _model.laudCount = [NSNumber numberWithInteger:[_model.laudCount integerValue]+1];
            [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
            _labelCount.text = [Tool getPersonCount:_model.laudCount];
            _isBtnCanTouch = YES;
        }];
    }
    else
    {
        //点赞
        _model.laudStatus = [NSNumber numberWithInt:1];
        _model.laudCount = [NSNumber numberWithInteger:[_model.laudCount integerValue]+1];
        [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
        _labelCount.text = [Tool getPersonCount:_model.laudCount];
        [ServicesMovie likeMovieReviewOrComment:[_model.id stringValue] model:^(RequestResult *movieDetail) {
            NSLog(@"点赞成功");
            btn.tag = 11;
            _isBtnCanTouch = YES;
        } failure:^(NSError *error) {
            _model.laudStatus = [NSNumber numberWithInt:0];
            _model.laudCount = [NSNumber numberWithInteger:[_model.laudCount integerValue]-1];
            [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_not_zan.png"] forState:UIControlStateNormal];
            _labelCount.text = [Tool getPersonCount:_model.laudCount];
            _isBtnCanTouch = YES;
        }];
    }
}

-(void)onButtonPoints
{
    int type = 1;
    if ([_model.userDeleteStatus intValue] == 0)
    {
        //举报
        type = 0;
    }
    if ([self.cDelegate respondsToSelector:@selector(jubaoUser:type:)])
    {
        [self.cDelegate jubaoUser:_model.id type:type];
    }
}

@end










