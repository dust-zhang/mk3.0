//
//  CinemaDetailVideoImageView.h
//  supercinema
//
//  Created by lianyanmin on 17/4/12.
//
//

#import <UIKit/UIKit.h>
#import "CinemaDetailVideoImageCell.h"
#import "CinemaVideoListViewController.h"
#import "MoreMovieStillsCell.h"

@protocol CinameDeatilVideoImageViewDelegate <NSObject>
- (void)videoImageViewClick:(NSUInteger)section imageIndex:(NSUInteger)index;
@end

@interface CinemaDetailVideoImageView : UIView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIView                  *_viewWhiteLine;
    UICollectionView        *_collectionView;
    UILabel                 *_labelVideo;
    UILabel                 *_labelImage;
    UIImageView             *_imageViewVideoArraw;
    UIImageView             *_imageViewImageArraw;
    UIButton                *_buttonPlayView;
}

@property (nonatomic, strong) UIButton          *buttonImage;
@property (nonatomic, strong) UIButton          *buttonVideo;
@property (nonatomic, strong) NSMutableArray    *videoModels;
@property (nonatomic, strong) NSMutableArray    *imageModels;
@property (nonatomic, assign) id<CinameDeatilVideoImageViewDelegate> delagate;
@property (nonatomic, strong) CinemaModel           *_cinemaModel;

- (void)configWithVideos:(CinemaModel*)model;
- (void)videoAddTarget:(id)target action:(SEL)action;
- (void)imageAddTarget:(id)target action:(SEL)action;


@end

