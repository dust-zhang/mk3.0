//
//  CinemaDetailVideoImageCell.h
//  supercinema
//
//  Created by lianyanmin on 17/4/12.
//
//

#import <UIKit/UIKit.h>
#import "KrVideoPlayerController.h"

@class StillModel, CinemaVideoModel;

@interface CinemaDetailVideoCell : UICollectionViewCell
{
    UIImageView         *_imageViewPlay;
}
@property (nonatomic, strong) CinemaVideoModel          *_videoModel;
@property (nonatomic, strong) UIImageView               *_imageView;


-(void)setData:(CinemaVideoModel*)model;

@end


@interface CinemaDetailImageCell : UICollectionViewCell

@property (nonatomic, strong) StillModel *model;
@property (nonatomic, strong) UIImageView *_imageView;

-(void)setData:(StillModel*)model;

@end
