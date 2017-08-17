//
//  JKAssetsCollectionFooterView.m
//  JKImagePicker
//
//  Created by Jecky on 15/1/12.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "JKAssetsCollectionFooterView.h"

@implementation JKAssetsCollectionFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a label
        [self textLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,(self.bounds.size.height - 21.0) / 2.0,SCREEN_WIDTH,21.0)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = MKFONT(14);
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}


@end
