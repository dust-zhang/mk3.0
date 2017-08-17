//
//  SpreadListTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 24/4/17.
//
//

#import "SpreadListTableViewCell.h"

@implementation SpreadListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:RGBA(246, 246, 251, 1)];
        
        //标签名字
        _labelName = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, self.frame.size.width-15*2, 12)];
        _labelName.backgroundColor = [UIColor clearColor];
        [_labelName setFont:MKFONT(12)];
        [_labelName setTextColor:RGBA(102, 102, 102, 1)];
        [_labelName setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_labelName];
    }
    return self;
}

-(void)setSpreadListTableViewCellFrameAndData:(NSString *)labelText
{
    _labelName.text = labelText;
}

@end
