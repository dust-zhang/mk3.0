//
//  CinemaVideoTableViewCell.m
//  supercinema
//
//  Created by dust on 2017/4/13.
//
//

#import "CinemaVideoTableViewCell.h"

@implementation CinemaVideoTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _imageViewVideo = [[UIImageView alloc ] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 414/2)];
        [_imageViewVideo setImage:[UIImage imageNamed:@"image_CinameDetailVideoLoading.png"] ];
        [_imageViewVideo setUserInteractionEnabled:YES];
        [self addSubview:_imageViewVideo];
        
        _imageViewPlay = [[UIImageView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, _imageViewVideo.frame.size.height/2-30, 60, 60)];
        [_imageViewPlay setUserInteractionEnabled:YES];
        [_imageViewPlay setImage:[UIImage imageNamed:@"image_CinameVideoPlay.png"]];
        [self addSubview:_imageViewPlay];
        
        _labelVideoName= [[UILabel alloc ] initWithFrame:CGRectMake(15, _imageViewVideo.frame.size.height-10-14, SCREEN_WIDTH-130, 14)];
        [_labelVideoName setFont:MKFONT(14)];
        [_labelVideoName setTextColor:[UIColor whiteColor]];
        [_labelVideoName setBackgroundColor:[UIColor clearColor]];
        [_labelVideoName setTextAlignment:NSTextAlignmentLeft];
        [_imageViewVideo addSubview:_labelVideoName];
        
        _labelVideoTime= [[UILabel alloc ] initWithFrame:CGRectMake(0, _labelVideoName.frame.origin.y, _imageViewVideo.frame.size.width-15, 14)];
        [_labelVideoTime setFont:MKFONT(14)];
        [_labelVideoTime setBackgroundColor:[UIColor clearColor]];
        [_labelVideoTime setTextAlignment:NSTextAlignmentRight];
        [_labelVideoTime setTextColor:[UIColor whiteColor]];
        [_imageViewVideo addSubview:_labelVideoTime];
        
    }
    return self;
}

-(void) setVideoUrl:(CinemaVideoModel *)model
{
    [_imageViewVideo sd_setImageWithURL:[NSURL URLWithString:model.coverImageUrl] placeholderImage:[UIImage imageNamed:@"image_CinameDetailVideoLoading.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error)
        {
            _imageViewVideo.image = [UIImage imageNamed:@"image_cinemaViderDefault.png"];
        }
        else
        {
            _imageViewVideo.image = image;
        }
    }];

    [_labelVideoName setText:model.videoName];
    [_labelVideoTime setText:model.duration];
    
}


@end
