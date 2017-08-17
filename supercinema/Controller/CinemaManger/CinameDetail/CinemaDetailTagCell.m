
//
//  CinemaDetailTagCell.m
//  supercinema
//
//  Created by lianyanmin on 17/4/12.
//
//

#import "CinemaDetailTagCell.h"

@interface CinemaDetailTagCell()

@end

@implementation CinemaDetailTagCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createdSubviews];
    }
    return self;
}

- (void)createdSubviews
{
    _cinameLabelTag = [[UILabel alloc]initWithFrame:self.contentView.bounds];
    _cinameLabelTag.textColor = RGBA(255, 255, 255, 0.6);
    _cinameLabelTag.font = MKFONT(12);
    [self.contentView addSubview:_cinameLabelTag];
}

- (void)setTagString:(NSString *)tagString
{
    _tagString = tagString;
    _cinameLabelTag.text = [tagString stringByAppendingString:@"；"];
}

@end


@interface CinemaFacilityTagCell()
@end

@implementation CinemaFacilityTagCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createdSubviews];
    }
    return self;
}

- (void)createdSubviews
{
    _labelTag = [[UILabel alloc]initWithFrame:self.contentView.bounds];
    _labelTag.textColor = RGBA(255, 255, 255, 0.6);
    _labelTag.font = MKFONT(12);
    _labelTag.textAlignment = NSTextAlignmentCenter;
    _labelTag.layer.cornerRadius = 2;
    _labelTag.layer.masksToBounds = YES;
    [self.contentView addSubview:_labelTag];
    _labelTag.backgroundColor = RGBA(255, 255, 255, 0.05);
}

- (void)setTagString:(NSString *)tagString
{
    _tagString = tagString;
    _labelTag.text = tagString;
}


@end

@interface CinemaPhoneTagCell()
@end

@implementation CinemaPhoneTagCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createdSubviews];
    }
    return self;
}

- (void)createdSubviews
{
    _labelTag = [[UILabel alloc]initWithFrame:self.contentView.bounds];
    _labelTag.textColor = RGBA(255, 255, 255, 0.6);
    _labelTag.font = MKFONT(12);
    _labelTag.textAlignment = NSTextAlignmentCenter;
    _labelTag.layer.cornerRadius = 2;
    _labelTag.layer.masksToBounds = YES;
    [self.contentView addSubview:_labelTag];
    _labelTag.backgroundColor = RGBA(255, 255, 255, 0.05);
}

- (void)setTagString:(NSString *)tagString
{
    _tagString = tagString;
    _labelTag.text = tagString;
}


@end
