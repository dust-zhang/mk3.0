//
//  MyDynamicTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/12/2.
//
//

#import "MyDynamicTableViewCell.h"

@implementation MyDynamicTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _isBtnCanTouch = YES;
        
        _viewTimeLine = [[UIView alloc]initWithFrame:CGRectZero];
        _viewTimeLine.backgroundColor = RGBA(180, 180, 180, 0.1);
        [self.contentView addSubview:_viewTimeLine];
        
        _imgIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgIcon];
        
        //第一个cell
        _viewPoint = [[UIView alloc]initWithFrame:CGRectZero];
        _viewPoint.layer.masksToBounds = YES;
        _viewPoint.layer.cornerRadius = 4;
        _viewPoint.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_viewPoint];
        
        _labelAllDyn = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelAllDyn.textColor = RGBA(123, 122, 152, 1);
        _labelAllDyn.font = MKFONT(12);
        [self.contentView addSubview:_labelAllDyn];
        
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelTitle.textColor = RGBA(51, 51, 51, 1);
        _labelTitle.font = MKFONT(12);
        [self.contentView addSubview:_labelTitle];
        
        //举报（删除）
        _btnPoints = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPoints.frame = CGRectZero;
        [_btnPoints setBackgroundImage:[UIImage imageNamed:@"btn_moreBlack.png"] forState:UIControlStateNormal];
        [_btnPoints addTarget:self action:@selector(onButtonPoints) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnPoints];
        
        _labelContent = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelContent.font = MKFONT(14);
        _labelContent.textColor = RGBA(51, 51, 51, 1);
        _labelContent.numberOfLines = 0;
        _labelContent.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_labelContent];
        
        _viewDesc = [[UIView alloc]initWithFrame:CGRectZero];
        _viewDesc.backgroundColor = RGBA(246, 246, 251, 1);
        _viewDesc.userInteractionEnabled = YES;
        [self.contentView addSubview:_viewDesc];
        
        UITapGestureRecognizer* tapViewDesc = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTo)];
        [_viewDesc addGestureRecognizer:tapViewDesc];
        
        _imgDescIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgDescIcon.layer.masksToBounds = YES;
        [_viewDesc addSubview:_imgDescIcon];
        
        _labelDescTitle = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelDescTitle.textColor = RGBA(51, 51, 51, 1);
        _labelDescTitle.font = MKBOLDFONT(16);
        [_viewDesc addSubview:_labelDescTitle];
        
        _labelDesc = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelDesc.textColor = RGBA(51, 51, 51, 1);
        _labelDesc.font = MKFONT(12);
        [_viewDesc addSubview:_labelDesc];
        
        _labelTime = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelTime.textColor = RGBA(123, 122, 152, 1);
        _labelTime.font = MKFONT(12);
        [self.contentView addSubview:_labelTime];
        
        _btnPraise = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPraise.frame = CGRectZero;
        _btnPraise.backgroundColor = [UIColor clearColor];
        [_btnPraise addTarget:self action:@selector(onButtonPraise:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnPraise];
        
        _labelPraise = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelPraise.font = MKFONT(12);
        _labelPraise.textColor = RGBA(153, 153, 153, 1);
        [self.contentView addSubview:_labelPraise];
        
        _btnComment = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnComment.frame = CGRectZero;
        [_btnComment setBackgroundImage:[UIImage imageNamed:@"btn_comment_other.png"] forState:UIControlStateNormal];
        [_btnComment addTarget:self action:@selector(onButtonCom) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnComment];
        
        _labelComment = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelComment.font = MKFONT(12);
        _labelComment.textColor = RGBA(153, 153, 153, 1);
        [self.contentView addSubview:_labelComment];
        
        _viewRespond = [[UIView alloc]initWithFrame:CGRectMake(47, 0, SCREEN_WIDTH-47, 0)];
        _viewRespond.backgroundColor = RGBA(246, 246, 251, 1);
        [self.contentView addSubview:_viewRespond];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onButtonComment:)];
        [_viewRespond addGestureRecognizer:tap];
        
        _labelMore = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelMore.font = MKFONT(13);
        _labelMore.text = @"更多回复";
        _labelMore.tag = 333;
        _labelMore.textColor = RGBA(117, 112, 255, 1);
        [_viewRespond addSubview:_labelMore];
        
        _viewFirst = [[UIView alloc]initWithFrame:CGRectZero];
        _viewFirst.backgroundColor = RGBA(246, 246, 251, 1);
        [self.contentView addSubview:_viewFirst];
    }
    return self;
}

-(void)setData:(FeedListModel*)model index:(NSInteger)index model:(UserDynamicModel*)dynModel
{
    _type = [model.intType intValue];
    _model = model;
    _curIndex = index;
    
    if (index == 0)
    {
        _viewPoint.frame = CGRectMake(22, 17+10, 8, 8);
        _labelAllDyn.frame = CGRectMake(_viewPoint.frame.origin.x+_viewPoint.frame.size.width+15, 15+10, 150, 12);
        _labelAllDyn.text = [NSString stringWithFormat:@"全部动态（%ld条）",(long)[dynModel.totalCount integerValue]];
        _imgIcon.frame = CGRectMake(15, _viewPoint.frame.origin.y+_viewPoint.frame.size.height+30+10, 22, 22);
        _viewFirst.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    }
    else
    {
        _imgIcon.frame = CGRectMake(15, 0, 22, 22);
    }
    
    CGFloat cellHeight;
    
    NSString* strDefaultHead = @"";
    switch ([model.intType intValue])
    {
        case 1:
            //想看电影
            _imgIcon.image = [UIImage imageNamed:@"img_dyn_want.png"];
            strDefaultHead = @"img_dyn_movie_default.png";
            break;
        case 2:
            //写了短评
            _imgIcon.image = [UIImage imageNamed:@"img_dyn_comment.png"];
            strDefaultHead = @"img_dyn_movie_default.png";
            break;
        case 3:
            //更新了签名
            _imgIcon.image = [UIImage imageNamed:@"img_dyn_sign.png"];
            strDefaultHead = @"img_dyn_head_default.png";
            break;
        case 4:
            //关注了用户
            _imgIcon.image = [UIImage imageNamed:@"img_dyn_focus.png"];
            strDefaultHead = @"img_dyn_head_default.png";
            break;
        case 5:
        case 6:
            //参加了活动/领取了活动物品
            _imgIcon.image = [UIImage imageNamed:@"img_dyn_activity"];
            strDefaultHead = @"img_dyn_activity_default.png";
            break;
        default:
            break;
    }
    
    _labelTitle.frame = CGRectMake(_imgIcon.frame.origin.x+_imgIcon.frame.size.width+10, _imgIcon.frame.origin.y+(_imgIcon.frame.size.height-12)/2, 150, 12);
    _labelTitle.text = model.strType;
    
    if ([model.canDelete boolValue])
    {
        //可以删除
        _btnPoints.frame = CGRectMake(SCREEN_WIDTH-15-30, _imgIcon.frame.origin.y+(_imgIcon.frame.size.height-30)/2, 45, 30);
    }
    
    if (model.feedContent.length>0)
    {
        _labelContent.frame = CGRectMake(47, 0, SCREEN_WIDTH-62, 0);
        NSString* strContent = model.feedContent;
        if (strContent.length > 49)
        {
            //截取49个字符
            strContent = [strContent substringWithRange:NSMakeRange(0, 49)];
            strContent = [strContent stringByAppendingString:@"..."];
        }
        _labelContent.text = strContent;
        [_labelContent sizeToFit];
        _labelContent.frame = CGRectMake(_labelContent.frame.origin.x, _labelTitle.frame.origin.y+_labelTitle.frame.size.height+10, _labelContent.frame.size.width, _labelContent.frame.size.height);
    }
    CGFloat originYDesc = _labelTitle.frame.origin.y+_labelTitle.frame.size.height+10;
    if (_labelContent.text.length>0)
    {
        originYDesc = _labelContent.frame.origin.y+_labelContent.frame.size.height+10;
    }
    if (model.targetTitle.length>0)
    {
        _viewDesc.frame = CGRectMake(_labelTitle.frame.origin.x, originYDesc, SCREEN_WIDTH-_labelTitle.frame.origin.x-15, 60);
        
        _imgDescIcon.frame = CGRectMake(10, 10, 40, 40);
        [Tool downloadImage:model.targetImgUrl button:nil imageView:_imgDescIcon defaultImage:strDefaultHead];
        _labelDescTitle.text = model.targetTitle;
        _labelDescTitle.frame = CGRectMake(_imgDescIcon.frame.origin.x+_imgDescIcon.frame.size.width+15, 10, 150, 16);
        
        _labelDesc.text = model.targetDesc;
        _labelDesc.frame = CGRectMake(_labelDescTitle.frame.origin.x, _imgDescIcon.frame.origin.y+_imgDescIcon.frame.size.height-12, _viewDesc.frame.size.width-_labelDescTitle.frame.origin.x-15, 12);
        _labelTime.frame = CGRectMake(_labelTitle.frame.origin.x, _viewDesc.frame.origin.y+_viewDesc.frame.size.height+15, 200, 12);
    }
    else
    {
        _labelTime.frame = CGRectMake(_labelTitle.frame.origin.x, originYDesc+5, 200, 12);
    }
    _labelTime.text = [Tool getLeftStartTime:model.pushishTime endTime:dynModel.currentTime];//[Tool returnTime:model.pushishTime format:@"YYYY年MM月dd日"];
    
    NSString* strCom = [model.commentCount stringValue];
    if ([model.commentCount intValue] == 0)
    {
        strCom = @"";
    }
    _labelComment.text = strCom;
    _labelComment.frame = CGRectMake(SCREEN_WIDTH-15-30+5, _labelTime.frame.origin.y-1, 45, 12);
    _btnComment.frame = CGRectMake(SCREEN_WIDTH-15-45-12, _labelTime.frame.origin.y-(25-_labelTime.frame.size.height)+2, 45, 25);
    
    if ([model.canLaud intValue] == 0)
    {
        //点赞状态
        _btnPraise.tag = 11;
        [_btnPraise setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
    }
    else
    {
        //未点赞状态
        _btnPraise.tag = 10;
        [_btnPraise setBackgroundImage:[UIImage imageNamed:@"img_comment_not_zan.png"] forState:UIControlStateNormal];
    }
    
    _labelPraise.text = [Tool getPersonCount:model.laudCount];
    _labelPraise.frame = CGRectMake(_btnComment.frame.origin.x - 15-25+3, _labelTime.frame.origin.y-1, 35, 12);
    _btnPraise.frame = CGRectMake(_btnComment.frame.origin.x - 15-50, _labelTime.frame.origin.y-(25-_labelTime.frame.size.height)+2, 45, 25);
    
    if (model.commentList.count>0)
    {
        for (UIView* vV in _viewRespond.subviews)
        {
            if (vV.tag!=333)
            {
                [vV removeFromSuperview];
            }
        }
        //有回复内容
        for (int i = 0 ; i<model.commentList.count; i++)
        {
            CommentListModel* cModel = model.commentList[i];
            FeedUserModel* commentUser = cModel.commentUser;
            FeedUserModel* replyUser = cModel.replyUser;
            NSString* stringContent = cModel.content;
            NSString* strNickName;
            __block NSNumber* uId;
            if (replyUser.nickname.length>0)
            {
                //回复用户
                stringContent = [NSString stringWithFormat:@"回复%@：%@",replyUser.nickname,stringContent];
                strNickName = [NSString stringWithFormat:@"%@：",replyUser.nickname];
                uId = replyUser.id;
            }
            else
            {
                //发布的评论
                strNickName = [NSString stringWithFormat:@"%@：",commentUser.nickname];
                uId = commentUser.id;
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
            [_viewRespond addSubview:_view[i]];
            
            _labelRes[i] = [[CJLabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-47-30, 0)];
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
                if ([self.dDelegate respondsToSelector:@selector(toUserHome:)])
                {
                    [self.dDelegate toUserHome:uId];
                }
            }];
            [_viewRespond addSubview:_labelRes[i]];
            
            if (i == 0)
            {
                _labelRes[i].frame = CGRectMake(15, 15, SCREEN_WIDTH-47-30, _labelRes[i].frame.size.height);
            }
            else
            {
                _labelRes[i].frame = CGRectMake(15, _labelRes[i-1].frame.origin.y+_labelRes[i-1].frame.size.height+10, SCREEN_WIDTH-47-30, _labelRes[i].frame.size.height);
            }
            _view[i].frame = CGRectMake(15, _labelRes[i].frame.origin.y-3, [Tool calStrWidth:strNickName height:13], 13+6);
        }
        
        if ([model.commentCount intValue] > model.commentList.count)
        {
            //有更多回复
            CGFloat widthBtnMore = [Tool calStrWidth:@"更多回复" height:15];
            _labelMore.frame = CGRectMake(SCREEN_WIDTH-47-15-widthBtnMore, _labelRes[model.commentList.count-1].frame.origin.y+_labelRes[model.commentList.count-1].frame.size.height+15, widthBtnMore, 13);
            
            _viewRespond.frame = CGRectMake(_viewRespond.frame.origin.x, _labelTime.frame.origin.y+_labelTime.frame.size.height+15, _viewRespond.frame.size.width, _labelMore.frame.size.height+_labelMore.frame.origin.y+10);
        }
        else
        {
            _viewRespond.frame = CGRectMake(_viewRespond.frame.origin.x, _labelTime.frame.origin.y+_labelTime.frame.size.height+15, _viewRespond.frame.size.width, _labelRes[model.commentList.count-1].frame.size.height+_labelRes[model.commentList.count-1].frame.origin.y+15);
        }
        cellHeight = _viewRespond.frame.origin.y+_viewRespond.frame.size.height+40;
    }
    else
    {
        cellHeight = _labelTime.frame.origin.y+_labelTime.frame.size.height+40;
    }
    _viewTimeLine.frame = CGRectMake(_imgIcon.frame.origin.x+(_imgIcon.frame.size.width-2)/2, _imgIcon.frame.origin.y, 2, cellHeight-_imgIcon.frame.origin.y);
    
    if (index == 0)
    {
        _viewTimeLine.frame = CGRectMake(_imgIcon.frame.origin.x+(_imgIcon.frame.size.width-2)/2, _viewPoint.frame.origin.y, 2, cellHeight-_viewPoint.frame.origin.y);
    }
}

-(void)onButtonPraise:(UIButton*)btn
{
    if (!_isBtnCanTouch)
    {
        return;
    }
    [MobClick event:myCenterViewbtn48];
    _isBtnCanTouch = NO;
    
    if (btn.tag == 11)
    {
        _model.canLaud = [NSNumber numberWithInt:1];
        _model.laudCount = [NSNumber numberWithInt:[_model.laudCount intValue]-1];
        _labelPraise.text = [Tool getPersonCount:_model.laudCount];
        [_btnPraise setBackgroundImage:[UIImage imageNamed:@"img_comment_not_zan.png"] forState:UIControlStateNormal];
        NSLog(@"本地-1");
        [ServicesUser cancelPraiseUserDynamic:_model.id model:^(RequestResult *userList) {
            NSLog(@"取消点赞成功");
            btn.tag = 10;
            _isBtnCanTouch = YES;
        } failure:^(NSError *error) {
            _model.canLaud = [NSNumber numberWithInt:0];
            _model.laudCount = [NSNumber numberWithInt:[_model.laudCount intValue]+1];
            _labelPraise.text = [Tool getPersonCount:_model.laudCount];
            [_btnPraise setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
            _isBtnCanTouch = YES;
            NSLog(@"回调+1");
        }];
    }
    else
    {
        _model.canLaud = [NSNumber numberWithInt:0];
        _model.laudCount = [NSNumber numberWithInt:[_model.laudCount intValue]+1];
        _labelPraise.text = [Tool getPersonCount:_model.laudCount];
        [_btnPraise setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
        NSLog(@"本地+1");
        [ServicesUser praiseUserDynamic:_model.id model:^(RequestResult *userList) {
            NSLog(@"点赞成功");
            btn.tag = 11;
            _isBtnCanTouch = YES;
        } failure:^(NSError *error) {
            _model.canLaud = [NSNumber numberWithInt:1];
            _model.laudCount = [NSNumber numberWithInt:[_model.laudCount intValue]-1];
            [_btnPraise setBackgroundImage:[UIImage imageNamed:@"img_comment_not_zan.png"] forState:UIControlStateNormal];
            _labelPraise.text = [Tool getPersonCount:_model.laudCount];
            _isBtnCanTouch = YES;
            NSLog(@"回调-1");
        }];
    }
}

-(void)onButtonCom
{
    if ([self.dDelegate respondsToSelector:@selector(toDynDetail:)])
    {
        [self.dDelegate toDynDetail:_model.id];
    }
}

-(void)onButtonComment:(UITapGestureRecognizer*)ges
{
    BOOL isNotTap = NO;
    CGPoint point = [ges locationInView:_viewRespond];
    for (UIView* view in _viewRespond.subviews)
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
        if ([self.dDelegate respondsToSelector:@selector(toDynDetail:)])
        {
            [MobClick event:myCenterViewbtn49];
            [self.dDelegate toDynDetail:_model.id];
        }
    }
}

-(void)onButtonPoints
{
    if ([self.dDelegate respondsToSelector:@selector(deleteCell:)])
    {
        [self.dDelegate deleteCell:_curIndex];
    }
}

-(void)tapTo
{
    if ([self.dDelegate respondsToSelector:@selector(toNextPage:feedModel:)])
    {
        [self.dDelegate toNextPage:_type feedModel:_model];
    }
}

@end
