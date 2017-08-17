
//
//  MoreCollectionViewCell.m
//  NotificationDemo
//
//  Created by lianyanmin on 17/3/24.
//  Copyright © 2017年 lianyanmin. All rights reserved.
//

#import "MoreMovieStillsCell.h"

@interface MoreMovieStillsCell ()
@end


@implementation MoreMovieStillsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _labelMore = [[UILabel alloc]init];
        _labelMore.text = @"更多...";
        _labelMore.textColor = [UIColor whiteColor];
        _labelMore.backgroundColor =RGBA(0, 0, 0, 0.5);
        _labelMore.textAlignment = NSTextAlignmentCenter;
        _labelMore.font = MKFONT(12);
        [self.contentView addSubview:_labelMore];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _labelMore.frame = self.contentView.bounds;
}
@end
