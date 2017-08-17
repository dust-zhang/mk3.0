//
//  UserTableViewCell.m
//  supercinema
//
//  Created by dust on 16/11/8.
//
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor] ];
        
        _followPersonListModel = [[FollowPersonListModel alloc] init];
        
        _imageViewHead = [[UIImageView alloc ] initWithFrame:CGRectMake(15, 0, 45, 45)];
        _imageViewHead.layer.masksToBounds = YES;
        _imageViewHead.layer.cornerRadius = 45/2;
//        [_imageViewHead setBackgroundColor:[UIColor blueColor]];
        [self addSubview:_imageViewHead];
        
        _labelUserNane = [[UILabel alloc ] initWithFrame:CGRectMake(_imageViewHead.frame.origin.x+_imageViewHead.frame.size.width+30, _imageViewHead.frame.origin.y +15, SCREEN_WIDTH-140, 16)];
        [_labelUserNane setFont:MKFONT(15)];
        [_labelUserNane setTextColor:RGBA(51, 51, 51, 1)];
        [self addSubview:_labelUserNane];
        
        self._btnAttention = [[UIButton alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-150/2, 81/2, 60, 24)];
        [self._btnAttention addTarget:self action:@selector(onButtonAttentionDelegte:) forControlEvents:UIControlEventTouchUpInside];
        [self._btnAttention.layer setCornerRadius:12];
        [self._btnAttention.layer setMasksToBounds:YES];
        [self._btnAttention setBackgroundColor:RGBA(117, 112, 255, 1)];
        [self._btnAttention setTitle:@"关注" forState:UIControlStateNormal];
        [self._btnAttention setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self._btnAttention.titleLabel setFont:MKFONT(12)];
        [self addSubview:self._btnAttention];
        [self._btnAttention setHidden:YES];
    }
    return self;
}

-(void) setUserText:(FollowPersonListModel *)userModel  key:(NSString *)strKey
{
    //将图片缓存到本地，以防切换闪烁
    [Tool downloadImage:userModel.portraitUrl button:nil imageView:_imageViewHead defaultImage:@"image_defaultHead1.png"];

    [_labelUserNane setText:userModel.nickname];
    //设置关键字
    [_labelUserNane setAttributedText:[Tool setKeyAttributed:userModel.nickname key:strKey fontSize:MKFONT(15)]];
}

-(void) setAttentionUserText:(FollowPersonListModel *)model
{
    _followPersonListModel = model;
    
    _imageViewHead.frame = CGRectMake(15, 30, 45, 45);
//    [_imageViewHead sd_setImageWithURL:[NSURL URLWithString:[Tool urlIsNull:model.portraitUrl]]placeholderImage:[UIImage imageNamed:@"image_defaultHead1.png"]];
    [Tool downloadImage:model.portraitUrl button:nil imageView:_imageViewHead defaultImage:@"image_defaultHead1.png"];
    
    _labelUserNane.frame = CGRectMake(_imageViewHead.frame.origin.x+_imageViewHead.frame.size.width+30, _imageViewHead.frame.origin.y +15, SCREEN_WIDTH-140, 16);
    [_labelUserNane setText:model.nickname];
    
    [self._btnAttention setHidden:NO];
    //已关注
    if ([model.relationEnum intValue] == 1 || [model.relationEnum intValue] == 3)
    {
        if ([model.relationEnum intValue] == 1 )
        {
            [self._btnAttention setTitle:@"已关注" forState:UIControlStateNormal];
        }
        if ( [model.relationEnum intValue] == 3 )
        {
            [self._btnAttention setTitle:@"互相关注" forState:UIControlStateNormal];
        }
        [self._btnAttention.layer setBorderWidth:1];
        [self._btnAttention.layer setBorderColor:RGBA(123, 122,152, 1).CGColor];
        [self._btnAttention setBackgroundColor:[UIColor whiteColor]];
        [self._btnAttention setTitleColor:RGBA(123, 122,152, 1) forState:UIControlStateNormal];
         objc_setAssociatedObject(self._btnAttention, "status", [NSNumber numberWithInt:0], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else if([model.relationEnum intValue] == 2)
    {
        [self._btnAttention setTitle:@"关注" forState:UIControlStateNormal];
        [self._btnAttention.layer setBorderWidth:0];
        //[self._btnAttention.layer setBorderColor:RGBA(123, 122,152, 1).CGColor];
        [self._btnAttention setBackgroundColor:RGBA(117, 112, 255, 1)];
        [self._btnAttention setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
         objc_setAssociatedObject(self._btnAttention, "status", [NSNumber numberWithInt:1], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }else{
        self._btnAttention.hidden = YES;
    }
    
}

-(void)onButtonAttentionDelegte:(UIButton *)btn
{
//    NSLog(@"btn.tag: %ld",btn.tag);
//    NSLog(@"_followPersonListModel.id: %@",_followPersonListModel.id);

    NSNumber *status = objc_getAssociatedObject(btn, "status");
    
    BOOL isCancel = [status intValue] == 1 ? NO : YES;
    
    if ([self._attentionDelegate respondsToSelector:@selector(onButtonAttentionDelegte:userId:isCancel:)])
    {
        [self._attentionDelegate onButtonAttentionDelegte:btn userId:_followPersonListModel.id isCancel:isCancel];
    }
}


@end
