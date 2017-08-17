//
//  CommentTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/11/28.
//
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

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
        
        _labelUserName = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelUserName.font = MKFONT(15);
        _labelUserName.textColor = RGBA(51, 51, 51, 1);
        _labelUserName.userInteractionEnabled = YES;
        [self.contentView addSubview:_labelUserName];
        
        UITapGestureRecognizer* tapUser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onButtonHead)];
        [_labelUserName addGestureRecognizer:tapUser];
        
        _imgCommentIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgCommentIcon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imgCommentIcon];
        
        _labelCommentText = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelCommentText.font = MKFONT(12);
        _labelCommentText.textColor = RGBA(180, 180, 180, 1);
        [self.contentView addSubview:_labelCommentText];
        
        _btnPoints = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPoints.frame = CGRectZero;
        [_btnPoints setBackgroundImage:[UIImage imageNamed:@"btn_moreBlack.png"] forState:UIControlStateNormal];
        [_btnPoints addTarget:self action:@selector(onButtonPoints) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnPoints];
        
        _labelDesc = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-15*3-40, 0)];
        _labelDesc.font = MKFONT(14);
        _labelDesc.textColor = RGBA(85, 85, 85, 1);
        _labelDesc.numberOfLines = 2;
        _labelDesc.lineBreakMode = NSLineBreakByTruncatingTail;
        _labelDesc.userInteractionEnabled = YES;
        [self.contentView addSubview:_labelDesc];
        
        UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onButtonComment:)];
        [_labelDesc addGestureRecognizer:tap1];
        
        _labelDate = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelDate.font = MKFONT(11);
        _labelDate.textColor = RGBA(123, 122, 152, 1);
        [self.contentView addSubview:_labelDate];
        
        _btnDianzan = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnDianzan.frame = CGRectZero;
        _btnDianzan.userInteractionEnabled = YES;
        _btnDianzan.backgroundColor = [UIColor clearColor];
        [_btnDianzan addTarget:self action:@selector(onButtonZan:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnDianzan];
        
//        _imgDianzan = [[UIImageView alloc]initWithFrame:CGRectZero];
//        _imgDianzan.backgroundColor = [UIColor grayColor];
//        [_btnDianzan addSubview:_imgDianzan];
        
        _labelCount = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelCount.font = MKFONT(12);
        _labelCount.textColor = RGBA(153, 153, 153, 1);
        _labelCount.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_labelCount];
        
        _imgCment = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgCment.backgroundColor = [UIColor clearColor];
        _imgCment.userInteractionEnabled = YES;
        [self.contentView addSubview:_imgCment];
        
        UITapGestureRecognizer* tapImgCment = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onButtonComment:)];
        [_imgCment addGestureRecognizer:tapImgCment];
        
        _labelCment = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelCment.font = MKFONT(12);
        _labelCment.userInteractionEnabled = YES;
        _labelCment.textColor = RGBA(153, 153, 153, 1);
        [self.contentView addSubview:_labelCment];
        
        UITapGestureRecognizer* tapCment = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onButtonComment:)];
        [_labelCment addGestureRecognizer:tapCment];
        
        _viewMore = [[UIView alloc]initWithFrame:CGRectZero];
        _viewMore.backgroundColor = RGBA(246, 246, 251, 1);
        [self.contentView addSubview:_viewMore];
        
        UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onButtonComment:)];
        [_viewMore addGestureRecognizer:tap2];
        
        _labelMore = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelMore.font = MKFONT(13);
        _labelMore.tag = 333;
        _labelMore.text = @"更多回复";
        _labelMore.textColor = RGBA(117, 112, 255, 1);
        [_viewMore addSubview:_labelMore];
    }
    return self;
}

-(void)setData:(MovieReviewListModel*)model icon:(NSArray*)imgArr curTime:(NSNumber*)curTime
{
    _model = model;
//    model.commentCount =@1111;
    
    _btnHead.frame = CGRectMake(15, 15, 40, 40);
    _btnHead.layer.masksToBounds = YES;
    _btnHead.layer.cornerRadius = _btnHead.frame.size.height/2;
    _btnHead.layer.borderWidth = 0.5;
    _btnHead.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];
    [Tool downloadImage:model.publishUser.portraitUrl button:_btnHead imageView:nil defaultImage:@"image_defaultHead1.png"];
    NSString* strUserName = model.publishUser.nickname;
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
    _labelUserName.frame = CGRectMake(_btnHead.frame.origin.x+_btnHead.frame.size.width+15, 15, [Tool calStrWidth:strUserName height:15], 15);
    
    if ([model.score intValue] > 0 && [model.score intValue] <= 10)
    {
        NSInteger index = [model.score intValue]/2 - 1;
        NSArray* arrScore = [imgArr objectAtIndex:index];
        _imgCommentIcon.image = [UIImage imageNamed:arrScore[0]];
        _imgCommentIcon.frame = CGRectMake(SCREEN_WIDTH - 217/2-20, 15, 20, 20);
        _labelCommentText.text = arrScore[1];
        _labelCommentText.frame = CGRectMake(_imgCommentIcon.frame.origin.x+_imgCommentIcon.frame.size.width+10, _imgCommentIcon.frame.origin.y, 80, _imgCommentIcon.frame.size.height);
    }
    _btnPoints.frame =  CGRectMake(SCREEN_WIDTH-15-30, _labelUserName.frame.origin.y+(_labelUserName.frame.size.height-30)/2, 45, 30);
    
    _labelDesc.text = model.content;
    [_labelDesc sizeToFit];
    _labelDesc.frame = CGRectMake(_btnHead.frame.origin.x+_btnHead.frame.size.width+15, _labelUserName.frame.origin.y+_labelUserName.frame.size.height+15, _labelDesc.frame.size.width, _labelDesc.frame.size.height);
    
    _labelDate.text = [Tool getLeftStartTime:model.publishTime endTime:curTime];  //[Tool returnTime:model.publishTime format:@"YYYY年MM月dd日"];//@"1小时前";
    _labelDate.frame = CGRectMake(_btnHead.frame.origin.x+_btnHead.frame.size.width+15, _labelDesc.frame.origin.y+_labelDesc.frame.size.height+15, 200, 11);
    //评论数量
    if ([model.commentCount intValue] ==0 )
    {
        _labelCment.text = @"评论";
    }
    else
    {
        _labelCment.text = [Tool getPersonCount:model.commentCount];
    }
    
    _labelCment.frame = CGRectMake(SCREEN_WIDTH-15-25, _labelDate.frame.origin.y-1, 40, 12);
    
    _imgCment.image = [UIImage imageNamed:@"btn_comment_other.png"];
    _imgCment.frame = CGRectMake(SCREEN_WIDTH-15-45-12, _labelDate.frame.origin.y-(25-_labelDate.frame.size.height)+5, 45, 25);
    
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

        _labelCount.text =[Tool getPersonCount:model.laudCount];
    }
    
    _labelCount.frame = CGRectMake(_imgCment.frame.origin.x - 15-25+3, _labelDate.frame.origin.y-1, 35, 12);
    _btnDianzan.frame = CGRectMake(_imgCment.frame.origin.x - 15-50, _labelDate.frame.origin.y-(25-_labelDate.frame.size.height)+5, 45, 25);
    
    if (model.commentList.count>0)
    {
        for (UIView* vV in _viewMore.subviews)
        {
            if (vV.tag!=333)
            {
                [vV removeFromSuperview];
            }
        }
        //有回复内容
        for (int i = 0 ; i<model.commentList.count; i++)
        {
            MovieReviewCommentListModel* cModel = model.commentList[i];
            MovieReviewUserModel* commentUser = cModel.publishUser;
            MovieReviewUserModel* replyUser = cModel.replyUser;
            NSString* stringContent = cModel.content;
            if (stringContent.length>20)
            {
                stringContent = [stringContent substringWithRange:NSMakeRange(0, 19)];
                stringContent = [stringContent stringByAppendingString:@"..."];
            }
            NSString* strNickName;
            __block NSInteger uId;
            if (replyUser.nickname.length>0)
            {
                //回复用户
                stringContent = [NSString stringWithFormat:@"回复%@：%@",replyUser.nickname,stringContent];
                strNickName = [NSString stringWithFormat:@"%@：",commentUser.nickname];
                uId = [replyUser.id integerValue];
            }
            else
            {
                //发布的评论
                strNickName = [NSString stringWithFormat:@"%@：",commentUser.nickname];
                uId = [commentUser.id integerValue];
            }
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.alignment = NSTextAlignmentLeft;
            NSDictionary *dic = @{
                                  NSFontAttributeName:[UIFont systemFontOfSize:13],/*(字体)*/
                                  NSParagraphStyleAttributeName:paragraph,/*(段落)*/
                                  };
            NSMutableAttributedString *labelTitle = [NSString getNSAttributedString:[NSString stringWithFormat:@"%@%@",strNickName,stringContent] labelDict:dic];
            
            _view[i] = [[UIView alloc]init];
            _view[i].backgroundColor = [UIColor clearColor];
            _view[i].tag = 80+i;
            [_viewMore addSubview:_view[i]];
            
            _labelRes[i] = [[CJLabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15*4-40, 0)];
            _labelRes[i].textColor = RGBA(123, 122, 152, 1);
            _labelRes[i].userInteractionEnabled = YES;
            _labelRes[i].attributedText = labelTitle;
            _labelRes[i].numberOfLines = 0;
            _labelRes[i].lineBreakMode = NSLineBreakByCharWrapping;
            [_labelRes[i] sizeToFit];
            NSDictionary *linkDic2 = @{
                                       NSForegroundColorAttributeName:[UIColor colorWithRed:0.2758 green:0.2585 blue:0.9705 alpha:1.0]
                                       };
            [_labelRes[i] addLinkString:strNickName linkAddAttribute:linkDic2 block:^(CJLinkLabelModel *linkModel) {
                NSLog(@"点击了id: %ld",(long)uId);
                if ([self.cDelegate respondsToSelector:@selector(toUserHome:)])
                {
                    [self.cDelegate toUserHome:uId];
                }
            }];
            [_viewMore addSubview:_labelRes[i]];
            
            if (i == 0)
            {
                _labelRes[i].frame = CGRectMake(15, 15, SCREEN_WIDTH-15*4-40, _labelRes[i].frame.size.height);
            }
            else
            {
                _labelRes[i].frame = CGRectMake(15, _labelRes[i-1].frame.origin.y+_labelRes[i-1].frame.size.height+10, SCREEN_WIDTH-15*4-40, _labelRes[i].frame.size.height);
            }
            _view[i].frame = CGRectMake(15, _labelRes[i].frame.origin.y-3, [Tool calStrWidth:strNickName height:13], 13+6);
        }
        if ([model.commentCount intValue] > model.commentList.count)
        {
            //有更多回复
            CGFloat widthBtnMore = [Tool calStrWidth:@"更多回复" height:15];
            _labelMore.frame = CGRectMake(SCREEN_WIDTH-15*2-40-widthBtnMore, _labelRes[model.commentList.count-1].frame.origin.y+_labelRes[model.commentList.count-1].frame.size.height+15, widthBtnMore, 13);
            _viewMore.frame = CGRectMake(15*2+40, _labelDate.frame.origin.y+_labelDate.frame.size.height+15, SCREEN_WIDTH-15*2-40, _labelMore.frame.size.height+_labelMore.frame.origin.y+10);
        }
        else
        {
            _viewMore.frame = CGRectMake(15*2+40, _labelDate.frame.origin.y+_labelDate.frame.size.height+15, SCREEN_WIDTH-15*2-40, _labelRes[model.commentList.count-1].frame.size.height+_labelRes[model.commentList.count-1].frame.origin.y+15);
        }
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
    if ([self.cDelegate respondsToSelector:@selector(threePointsElse:type:)])
    {
        [self.cDelegate threePointsElse:_model.id type:type];
    }
}

-(void)onButtonZan:(UIButton*)btn
{
    if ( ![Config getLoginState ] )
    {
        if ([self.cDelegate respondsToSelector:@selector(toLoginVC)])
        {
            [self.cDelegate toLoginVC];
        }
    }
    else
    {
        if (!_isBtnCanTouch)
        {
            return;
        }
        [MobClick event:mainViewbtn147];
        _isBtnCanTouch = NO;
        if (btn.tag == 11)
        {
            _model.laudStatus = [NSNumber numberWithInt:0];
            _model.laudCount = [NSNumber numberWithInteger:[_model.laudCount integerValue]-1];
            _labelCount.text = [Tool getPersonCount:_model.laudCount];
            [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_not_zan.png"] forState:UIControlStateNormal];
            NSLog(@"本地-1");
            [ServicesMovie cancelLikeMovieReviewOrComment:[_model.id stringValue] model:^(RequestResult *movieDetail) {
                NSLog(@"取消点赞成功");
                btn.tag = 10;
                _isBtnCanTouch = YES;
            } failure:^(NSError *error) {
                _model.laudStatus = [NSNumber numberWithInt:1];
                _model.laudCount = [NSNumber numberWithInteger:[_model.laudCount integerValue]+1];
                _labelCount.text = [Tool getPersonCount:_model.laudCount];
                [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
                _isBtnCanTouch = YES;
                NSLog(@"回调+1");
            }];
        }
        else
        {
            _model.laudStatus = [NSNumber numberWithInt:1];
            _model.laudCount = [NSNumber numberWithInteger:[_model.laudCount integerValue]+1];
            _labelCount.text = [Tool getPersonCount:_model.laudCount];
            [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
            NSLog(@"本地+1");
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
                NSLog(@"回调-1");
            }];
        }
    }
}

-(void)onButtonHead
{
    //跳到个人主页
    if ([self.cDelegate respondsToSelector:@selector(toUserHome:)])
    {
        [self.cDelegate toUserHome:[_model.publishUser.id integerValue]];
    }
}

-(void)onButtonComment:(UITapGestureRecognizer*)ges
{
    BOOL isNotTap = NO;
    CGPoint point = [ges locationInView:_viewMore];
    for (UIView* view in _viewMore.subviews)
    {
        if (view.tag >= 80 && view.tag < 85)
        {
            isNotTap = CGRectContainsPoint(view.frame,point);
            if (isNotTap)
            {
                return;
            }
        }
    }
    if (!isNotTap)
    {
        if ([self.cDelegate respondsToSelector:@selector(commentElse:)])
        {
            [MobClick event:mainViewbtn158];
            [MobClick event:mainViewbtn160];
            
            [self.cDelegate commentElse:_model.id];
        }
    }
}

@end
