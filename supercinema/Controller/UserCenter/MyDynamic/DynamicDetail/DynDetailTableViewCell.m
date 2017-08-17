//
//  DynDetailTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/12/3.
//
//

#import "DynDetailTableViewCell.h"

@implementation DynDetailTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier index:(NSInteger)index
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _isBtnCanTouch = YES;
        
        //头像
        _btnHead = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnHead.frame = CGRectMake(15, 15, 40, 40);
        _btnHead.layer.masksToBounds = YES;
        _btnHead.layer.borderColor = [RGBA(0, 0, 0, 0.05) CGColor];
        _btnHead.layer.borderWidth = 0.5;
        _btnHead.layer.cornerRadius = 20;
        [_btnHead addTarget:self action:@selector(onButtonHead) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnHead];
        
        //用户名
        _labelUserName = [[UILabel alloc]initWithFrame:CGRectMake(_btnHead.frame.origin.x+_btnHead.frame.size.width+15, 19, 200, 15)];
        _labelUserName.textColor = RGBA(51,51,51,1);
        _labelUserName.font = MKFONT(15);
        [self.contentView addSubview:_labelUserName];
        
        //评论详情
        _labelContent = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH-85, 0)];
        _labelContent.font = MKFONT(14);
        _labelContent.textColor = RGBA(85,85,85,1);
        _labelContent.numberOfLines = 0;
        _labelContent.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_labelContent];
        
        //时间
        _labelDate = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelDate.font = MKFONT(11);
        _labelDate.textColor = RGBA(123, 122, 152, 1);
        [self.contentView addSubview:_labelDate];
        
        //举报（删除）
        _btnPoints = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPoints.frame = CGRectZero;
        [_btnPoints setBackgroundImage:[UIImage imageNamed:@"btn_moreBlack.png"] forState:UIControlStateNormal];
        [_btnPoints addTarget:self action:@selector(onButtonPoints) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnPoints];
        
        if (index == 0)
        {
            //第一个cell
            _labelDetail = [[UILabel alloc]initWithFrame:CGRectZero];
            _labelDetail.textColor = RGBA(51,51,51,1);
            _labelDetail.font = MKFONT(12);
            [self.contentView addSubview:_labelDetail];
            
            _viewDesc = [[UIView alloc]initWithFrame:CGRectZero];
            _viewDesc.backgroundColor = RGBA(246, 246, 251, 1);
            _viewDesc.userInteractionEnabled = YES;
            [self.contentView addSubview:_viewDesc];
            
            UITapGestureRecognizer* tapViewDesc = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToNext)];
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
    }
    return self;
}

-(void)setHeadData:(FeedListModel *)model index:(NSInteger)index
{
    _curIndex = index;
    
    _fModel = model;
    [Tool downloadImage:model.user.portraitUrl button:_btnHead imageView:nil defaultImage:@"image_unLoginHead.png"];
    _labelUserName.text = model.user.nickname;
    
    if ([model.canDelete boolValue])
    {
        //可以删除
        _btnPoints.frame = CGRectMake(SCREEN_WIDTH-15-30, _labelUserName.frame.origin.y+(_labelUserName.frame.size.height-30)/2, 45, 30);
    }
    
    _labelDetail.text = model.strType;
    _labelDetail.frame = CGRectMake(_labelUserName.frame.origin.x, _btnHead.frame.origin.y+_btnHead.frame.size.height-12, 200, 12);
    
    if (model.feedContent.length>0)
    {
        NSString* strContent = model.feedContent;
        if (strContent.length > 49)
        {
            //截取49个字符
            strContent = [strContent substringWithRange:NSMakeRange(0, 49)];
            strContent = [strContent stringByAppendingString:@"..."];
        }
        _labelContent.text = strContent;
        [_labelContent sizeToFit];
        _labelContent.frame = CGRectMake(_labelContent.frame.origin.x, _labelDetail.frame.origin.y+_labelDetail.frame.size.height+10, _labelContent.frame.size.width, _labelContent.frame.size.height);
    }
    CGFloat originYDesc = _labelDetail.frame.origin.y+_labelDetail.frame.size.height+15;
    if (_labelContent.text.length>0)
    {
        originYDesc = _labelContent.frame.origin.y+_labelContent.frame.size.height+10;
    }
    
    NSString* strDefaultHead = @"";
    switch ([model.intType intValue])
    {
        case 1:
            //想看电影
            strDefaultHead = @"img_dyn_movie_default.png";
            break;
        case 2:
            //写了短评
            strDefaultHead = @"img_dyn_movie_default.png";
            break;
        case 3:
            //更新了签名
            strDefaultHead = @"img_dyn_head_default.png";
            break;
        case 4:
            //关注了用户
            strDefaultHead = @"img_dyn_head_default.png";
            break;
        case 5:
        case 6:
            //参加了活动/领取了活动物品
            strDefaultHead = @"img_dyn_activity_default.png";
            break;
        default:
            break;
    }
    
    if (model.targetTitle.length>0)
    {
        _viewDesc.frame = CGRectMake(15, originYDesc, SCREEN_WIDTH-30, 60);
        
        _imgDescIcon.frame = CGRectMake(10, 10, 40, 40);
        [Tool downloadImage:model.targetImgUrl button:nil imageView:_imgDescIcon defaultImage:strDefaultHead];
        _labelDescTitle.text = model.targetTitle;
        _labelDescTitle.frame = CGRectMake(_imgDescIcon.frame.origin.x+_imgDescIcon.frame.size.width+15, 10, 150, 16);
        
        _labelDesc.text = model.targetDesc;
        _labelDesc.frame = CGRectMake(_labelDescTitle.frame.origin.x, _imgDescIcon.frame.origin.y+_imgDescIcon.frame.size.height-12, _viewDesc.frame.size.width-15-_labelDescTitle.frame.origin.x, 12);
        _labelDate.frame = CGRectMake(15, _viewDesc.frame.origin.y+_viewDesc.frame.size.height+15, 200, 12);
    }
    else
    {
        _labelDate.frame = CGRectMake(15, originYDesc, 200, 12);
    }
    _labelDate.text = [Tool returnTime:model.pushishTime format:@"YYYY年MM月dd日"];
    
    if ([model.canLaud intValue] == 0)
    {
        //点赞状态
        _btnDianzan.tag = 11;
        [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
    }
    else
    {
        //未点赞状态
        _btnDianzan.tag = 10;
        [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_not_zan.png"] forState:UIControlStateNormal];
    }
    _btnDianzan.frame = CGRectMake(SCREEN_WIDTH-15-55, _labelDate.frame.origin.y-10, 45, 25);
    _labelCount.text = [Tool getPersonCount:model.laudCount];
    _labelCount.frame = CGRectMake(_btnDianzan.frame.origin.x+_btnDianzan.frame.size.width-15, _labelDate.frame.origin.y-1, 50, 12);
//    _btnDianzan.backgroundColor = [UIColor yellowColor];
//    _labelCount.backgroundColor = [UIColor grayColor];
    _viewBack.frame = CGRectMake(0, _labelDate.frame.origin.y+_labelDate.frame.size.height+15, SCREEN_WIDTH, 42);
    
    _labelTotalComment.text = [NSString stringWithFormat:@"共%ld条回复",(long)[model.commentCount integerValue]];
    _labelTotalComment.frame = CGRectMake(15, 20, 200, 12);
}

-(void)setData:(CommentListModel*)model index:(NSInteger)index curTime:(NSNumber*)curTime
{
    _curIndex = index;
    
    _cModel = model;
    [Tool downloadImage:model.commentUser.portraitUrl button:_btnHead imageView:nil defaultImage:@"image_unLoginHead.png"];
    _labelUserName.text = model.commentUser.nickname;
    
//    if ([model.canDelete boolValue])
//    {
//        //可以删除
        _btnPoints.frame = CGRectMake(SCREEN_WIDTH-15-30, _labelUserName.frame.origin.y+(_labelUserName.frame.size.height-30)/2, 45, 30);
//    }
    
    NSString* strContent = model.content;
    if (model.replyUser.nickname.length>0)
    {
        //有回复用户
        strContent = [NSString stringWithFormat:@"回复%@：%@",model.replyUser.nickname,model.content];
    }
    _labelContent.text = strContent;
    [_labelContent sizeToFit];
    _labelContent.frame = CGRectMake(_labelUserName.frame.origin.x, _labelUserName.frame.origin.y+_labelUserName.frame.size.height+15, SCREEN_WIDTH-_labelUserName.frame.origin.x-15, _labelContent.frame.size.height);
    
    _labelContent.userInteractionEnabled = YES;
    _tapRes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRespond)];
    [_labelContent addGestureRecognizer:_tapRes];
    
    _labelDate.text = [Tool getLeftStartTime:model.createTime endTime:curTime];//[Tool returnTime:model.createTime format:@"YYYY年MM月dd日"];
    _labelDate.frame = CGRectMake(_labelUserName.frame.origin.x, _labelContent.frame.origin.y+_labelContent.frame.size.height+15, 100, 11);
}

-(void)onButtonHead
{
    if ([self.detaildelegate respondsToSelector:@selector(toUserHome:)])
    {
        [self.detaildelegate toUserHome:_fModel.user.id];
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
        _fModel.canLaud = [NSNumber numberWithInt:1];
        _fModel.laudCount = [NSNumber numberWithInt:[_fModel.laudCount intValue]-1];
        _labelCount.text = [Tool getPersonCount:_fModel.laudCount];
        
        [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_not_zan.png"] forState:UIControlStateNormal];
        NSLog(@"本地-1");
        [ServicesUser cancelPraiseUserDynamic:_fModel.id model:^(RequestResult *userList) {
            NSLog(@"取消点赞成功");
            btn.tag = 10;
            _isBtnCanTouch = YES;
        } failure:^(NSError *error) {
            _fModel.canLaud = [NSNumber numberWithInt:0];
            _fModel.laudCount = [NSNumber numberWithInt:[_fModel.laudCount intValue]+1];
            _labelCount.text = [Tool getPersonCount:_fModel.laudCount];
            [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
            _isBtnCanTouch = YES;
            NSLog(@"回调+1");
        }];
    }
    else
    {
        _fModel.canLaud = [NSNumber numberWithInt:0];
        _fModel.laudCount = [NSNumber numberWithInt:[_fModel.laudCount intValue]+1];
        _labelCount.text = [Tool getPersonCount:_fModel.laudCount];
        [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_zan.png"] forState:UIControlStateNormal];
        NSLog(@"本地+1");
        [ServicesUser praiseUserDynamic:_fModel.id model:^(RequestResult *userList) {
            NSLog(@"点赞成功");
            btn.tag = 11;
            _isBtnCanTouch = YES;
        } failure:^(NSError *error) {
            _fModel.canLaud = [NSNumber numberWithInt:1];
            _fModel.laudCount = [NSNumber numberWithInt:[_fModel.laudCount intValue]-1];
            [_btnDianzan setBackgroundImage:[UIImage imageNamed:@"img_comment_not_zan.png"] forState:UIControlStateNormal];
            _labelCount.text = [Tool getPersonCount:_fModel.laudCount];
            _isBtnCanTouch = YES;
            NSLog(@"回调-1");
        }];
    }
}

-(void)onButtonPoints
{
    if ([self.detaildelegate respondsToSelector:@selector(deleteCell:)])
    {
        [self.detaildelegate deleteCell:_curIndex];
    }
}

-(void)tapRespond
{
    if (self.canTouch)
    {
        if ([self.detaildelegate respondsToSelector:@selector(respond:)])
        {
            [self.detaildelegate respond:_cModel];
        }
    }
    else
    {
        if ([self.detaildelegate respondsToSelector:@selector(hideKeyboard)])
        {
            [self.detaildelegate hideKeyboard];
        }
    }
}

-(void)tapToNext
{
    if ([self.detaildelegate respondsToSelector:@selector(toNextPage:feedModel:)])
    {
        [self.detaildelegate toNextPage:[_fModel.intType integerValue] feedModel:_fModel];
    }
}

@end
