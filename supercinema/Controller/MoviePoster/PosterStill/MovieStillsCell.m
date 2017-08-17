
//
//  PictureCollectionViewCell.m
//  NotificationDemo
//
//  Created by lianyanmin on 17/3/22.
//  Copyright © 2017年 lianyanmin. All rights reserved.
//

#import "MovieStillsCell.h"

@interface MovieStillsCell ()


@end
@implementation MovieStillsCell

- (instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:imageView];
        self._imageView = imageView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //2017- 4-18改动
//    self._imageView.frame = CGRectMake(0, 0, (SCREEN_WIDTH-3)/3, (SCREEN_WIDTH-3)/3);
    self._imageView.frame = self.contentView.bounds;
}

- (void)setData:(StillModel *)model
{
    [Tool downloadImage:model.url button:nil imageView:self._imageView defaultImage:@"poster_loading.png"];
}
@end
