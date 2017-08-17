//
//  SocietyTableViewCell.m
//  supercinema
//
//  Created by Mapollo28 on 2016/12/2.
//
//

#import "SocietyTableViewCell.h"

@implementation SocietyTableViewCell
#define MAXLENGTH  39
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _viewLine.backgroundColor = RGBA(0, 0, 0, 0.05);
        [self.contentView addSubview:_viewLine];
        
        //头像
        _btnHead = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnHead.frame = CGRectMake(25, 15, 40, 40);
//        _btnHead.backgroundColor = [UIColor grayColor];
        _btnHead.layer.masksToBounds = YES;
        _btnHead.layer.cornerRadius = 20;
        [_btnHead addTarget:self action:@selector(onButtonHead) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnHead];
        
        //小圆点
        _viewPoint = [[UIView alloc]initWithFrame:CGRectMake(9, _btnHead.frame.origin.y+(_btnHead.frame.size.height-7)/2, 7, 7)];
        _viewPoint.layer.cornerRadius = 7/2;
        _viewPoint.hidden = YES;
        _viewPoint.backgroundColor = RGBA(117, 112, 255, 1);
        _viewPoint.layer.masksToBounds = YES;
        [self.contentView addSubview:_viewPoint];
        
        //
        _labelUserName = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelUserName.textColor = RGBA(117, 112, 255, 1);
        _labelUserName.font = MKFONT(15);
        _labelUserName.backgroundColor = [UIColor clearColor];
        _labelUserName.userInteractionEnabled = YES;
        [self.contentView addSubview:_labelUserName];
        
        UITapGestureRecognizer* tapHome = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onButtonHead)];
        [_labelUserName addGestureRecognizer:tapHome];
        
        _labelFocus = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelFocus.textColor = RGBA(123, 122, 152, 1);
        _labelFocus.font = MKFONT(15);
        [self.contentView addSubview:_labelFocus];
        
        _labelRespond = [[UILabel alloc]initWithFrame:CGRectMake(_btnHead.frame.origin.x+_btnHead.frame.size.width+15, 0, SCREEN_WIDTH-95, 0)];
        _labelRespond.textColor = RGBA(51, 51, 51, 1);
        _labelRespond.font = MKFONT(15);
        _labelRespond.numberOfLines = 0;
        _labelRespond.backgroundColor = [UIColor clearColor];
        _labelRespond.lineBreakMode = NSLineBreakByClipping;
        _labelRespond.userInteractionEnabled = YES;
        [self.contentView addSubview:_labelRespond];
        
//        UITapGestureRecognizer* tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTo)];
//        [_labelRespond addGestureRecognizer:tap2];
    
        _viewDesc = [[UIView alloc]initWithFrame:CGRectZero];
        _viewDesc.backgroundColor = RGBA(246, 246, 251, 1);
        _viewDesc.userInteractionEnabled = YES;
        [self.contentView addSubview:_viewDesc];
        
//        UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTo)];
//        [_viewDesc addGestureRecognizer:tap1];
        
        _labelTargetTitle = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelTargetTitle.textColor = RGBA(102, 102, 102, 1);
        _labelTargetTitle.font = MKFONT(16);
        _labelTargetTitle.textAlignment = NSTextAlignmentLeft;
        [_viewDesc addSubview:_labelTargetTitle];
        
        _labelTargetDesc = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-125, 0)];
        _labelTargetDesc.textColor = RGBA(102, 102, 102, 1);
        _labelTargetDesc.font = MKFONT(12);
        [_viewDesc addSubview:_labelTargetDesc];
        
        _labelTargetType = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelTargetType.textColor = RGBA(51, 51, 51, 1);
        _labelTargetType.font = MKFONT(12);
        [_viewDesc addSubview:_labelTargetType];
        
        _imgTarget = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imgTarget.userInteractionEnabled = YES;
//        _imgTarget.backgroundColor = [UIColor blueColor];
        [_viewDesc addSubview:_imgTarget];

        _labelTime = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelTime.textColor = RGBA(123, 122, 152, 1);
        _labelTime.font = MKFONT(12);
        [self.contentView addSubview:_labelTime];
    }
    return self;
}

-(void)setData:(SysNotifyListModel *)model curTime:(NSNumber *)curTime isFirst:(NSInteger)isFirst
{
    if (isFirst>0)
    {
       _viewLine.frame = CGRectMake(25, 0, SCREEN_WIDTH-25, 0.5);
    }
    
    _model = model;
    _type = [model.intType intValue];
    [Tool downloadImage:model.rpUserPortrait button:_btnHead imageView:nil defaultImage:@"image_unLoginHead.png"];
    NSString* strName = model.rpUserNickName;
    if (SCREEN_WIDTH == 320)
    {
        if (strName.length>6)
        {
            strName = [[strName substringWithRange:NSMakeRange(0, 5)] stringByAppendingString:@"..."];
        }
    }
    else
    {
        if (strName.length>9)
        {
            strName = [[strName substringWithRange:NSMakeRange(0, 8)] stringByAppendingString:@"..."];
        }
    }
    _labelUserName.text = strName;
    _labelUserName.frame = CGRectMake(_btnHead.frame.origin.x+_btnHead.frame.size.width+15, _btnHead.frame.origin.y+(_btnHead.frame.size.height-15)/2, [Tool calStrWidth:strName height:15] + 10, 15);
    
    if ([model.status intValue] == 0)
    {
        _viewPoint.hidden = NO;
    }
    else
    {
        _viewPoint.hidden = YES;
    }
    _labelFocus.text = model.strType;
    _labelFocus.frame = CGRectMake(_labelUserName.frame.origin.x+_labelUserName.frame.size.width, _labelUserName.frame.origin.y, 200, 15);
    
    if (model.content.length>0)
    {
        //有内容
        NSString* strRespond = model.content;
        if (strRespond.length > MAXLENGTH)
        {
            //截取39个字符
            strRespond = [strRespond substringWithRange:NSMakeRange(0, 39)];
            strRespond = [strRespond stringByAppendingString:@"..."];
        }
        _labelRespond.text = strRespond;
        [_labelRespond sizeToFit];
        _labelRespond.frame = CGRectMake(_labelRespond.frame.origin.x, _labelUserName.frame.origin.y+_labelUserName.frame.size.height+15, _labelRespond.frame.size.width, _labelRespond.frame.size.height);
    }
    else
    {
         _labelRespond.frame = CGRectMake(_labelRespond.frame.origin.x, _labelUserName.frame.origin.y+_labelUserName.frame.size.height+15, _labelRespond.frame.size.width, 0);
    }
    
    BOOL isViewDescShow = NO;
    CGFloat heightDesc = 0;
    if ([model.intTargetType intValue] > 0)
    {
        //有targetType的描述
        _labelTargetType.text = model.strTargetType;
        _labelTargetType.frame = CGRectMake(15, 15, 200, 12);
        
        isViewDescShow = YES;
        heightDesc = _labelTargetType.frame.origin.y+_labelTargetType.frame.size.height;
    }
    
    if (model.targetImg.length>0)
    {
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
        //有logo
        [Tool downloadImage:model.targetImg button:nil imageView:_imgTarget defaultImage:strDefaultHead];
        _imgTarget.frame = CGRectMake(15, _labelTargetType.frame.origin.y+_labelTargetType.frame.size.height+15, 40, 40);
        isViewDescShow = YES;
        heightDesc = _imgTarget.frame.origin.y+_imgTarget.frame.size.height;
    }
    
    if (model.targetTitle.length>0)
    {
        _labelTargetTitle.text = model.targetTitle;
        _labelTargetTitle.frame = CGRectMake(15+_imgTarget.frame.origin.x+_imgTarget.frame.size.width, _labelTargetType.frame.origin.y+_labelTargetType.frame.size.height+15, SCREEN_WIDTH-_labelUserName.frame.origin.x-15-(15*2+_imgTarget.frame.origin.x+_imgTarget.frame.size.width), 16);
        isViewDescShow = YES;
        
        heightDesc = _labelTargetTitle.frame.origin.y+_labelTargetTitle.frame.size.height;
    }
    
    if (model.targetDesc.length>0)
    {
        NSString* strDesc = model.targetDesc;
        if (strDesc.length > 19)
        {
            //截取19个字符
            strDesc = [strDesc substringWithRange:NSMakeRange(0, 19)];
            strDesc = [strDesc stringByAppendingString:@"..."];
        }
        _labelTargetDesc.text = strDesc;
        [_labelTargetDesc sizeToFit];
        CGFloat heightTitle = _labelTargetType.frame.origin.y+_labelTargetType.frame.size.height+15+_labelTargetTitle.frame.size.height+10;
        if (model.targetTitle.length==0)
        {
            heightTitle = _labelTargetType.frame.origin.y+_labelTargetType.frame.size.height+15;
        }
        _labelTargetDesc.frame = CGRectMake(_labelTargetTitle.frame.origin.x, heightTitle,_labelTargetTitle.frame.size.width, _labelTargetDesc.frame.size.height);
        isViewDescShow = YES;
        
        heightDesc = _labelTargetDesc.frame.origin.y+_labelTargetDesc.frame.size.height;
    }
    if (isViewDescShow)
    {
        CGFloat originYView = _labelUserName.frame.origin.y+_labelUserName.frame.size.height+15;
        if (model.content.length>0)
        {
            originYView = _labelRespond.frame.origin.y+_labelRespond.frame.size.height+15;
        }
        _viewDesc.frame = CGRectMake(_labelUserName.frame.origin.x, originYView, SCREEN_WIDTH-_labelUserName.frame.origin.x-15, heightDesc+15);
    }
    
    CGFloat originYTime = _labelUserName.frame.origin.y+_labelUserName.frame.size.height+10;
    if (model.content.length>0)
    {
        originYTime = _labelRespond.frame.origin.y+_labelRespond.frame.size.height+10;
    }
    if (heightDesc>0)
    {
        originYTime = _viewDesc.frame.origin.y+_viewDesc.frame.size.height+10;
    }
    _labelTime.text = [Tool getLeftStartTime:model.createTime endTime:curTime];//[Tool returnTime:model.createTime format:@"MM月dd日"];
    _labelTime.frame = CGRectMake(_labelUserName.frame.origin.x, originYTime, 150, 12);
}

-(void)onButtonHead
{
    //跳到个人主页
    if ([self.sDelegate respondsToSelector:@selector(respondToUserHome:)])
    {
        [MobClick event:myCenterViewbtn57];
        [MobClick event:myCenterViewbtn58];
        [self.sDelegate respondToUserHome:_model.rpUserId];
    }
}

@end
