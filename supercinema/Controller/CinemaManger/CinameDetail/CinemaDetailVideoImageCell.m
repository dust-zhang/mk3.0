//
//  CinemaDetailVideoImageCell.m
//  supercinema
//
//  Created by lianyanmin on 17/4/12.
//
//

#import "CinemaDetailVideoImageCell.h"
#import "MoreMovieStillsCell.h"


@implementation CinemaDetailVideoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageViewPlay = [[UIImageView alloc] initWithFrame:CGRectMake((167-32)/2,(100-32)/2,32,32)];
        _imageViewPlay.backgroundColor = [UIColor clearColor];
        [_imageViewPlay setImage:[UIImage imageNamed:@"poster_play.png"] ];
        [self addSubview:_imageViewPlay];
       
        self._imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [self._imageView setImage:[UIImage imageNamed:@"image_CinameDetailVideoLoading.png"] ];
        [self.contentView addSubview:self._imageView];
    }
    return self;
}

- (void)setData:(CinemaVideoModel *)model
{
    self._videoModel = model;
    [self._imageView sd_setImageWithURL:[NSURL URLWithString:model.coverImageUrl] placeholderImage:[UIImage imageNamed:@"image_CinameDetailVideoLoading.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error)
        {
            self._imageView.image = [UIImage imageNamed:@"image_cinemaViderDefault.png"];
        }
        else
        {
            self._imageView.image = image;
        }
    }];
    
}

@end


@implementation CinemaDetailImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
        self._imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:self._imageView];
    }
    return self;
}

- (void)setData:(StillModel *)model
{
    
    [Tool downloadImage:model.url button:nil imageView:self._imageView defaultImage:@"poster_loading.png"];
    
}
@end
