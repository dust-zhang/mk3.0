//
//  MovieStillsViewController.h
//  supercinema
//
//  Created by lianyanmin on 17/3/23.
//
//

#import "HideTabBarViewController.h"
#import "ServicesStills.h"

@interface MovieStillsViewController : HideTabBarViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray              *_arrStill;
    UICollectionView            *_collectionView;
    UIImageView                 *_imageFailure;
    UILabel                     *_labelFailure;
    UIButton                    *_btnTryAgain;
    NSInteger                    _currentPageIndex;
    NSMutableArray              *_cinameStill;
}

@property (nonatomic, strong) MovieModel        *movieModel;

@property (nonatomic, assign) BOOL isCinameImage;

@end
