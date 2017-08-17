//
//  CinemaDetailTagsView.h
//  supercinema
//
//  Created by lianyanmin on 17/4/12.
//
//

#import <UIKit/UIKit.h>
#import "YYCollectionViewWaterLayout.h"
#import "CinemaDetailTagCell.h"
#import "CinemaModel.h"

@interface CinemaDetailTagsView : UIView<YYCollectionViewWaterLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UILabel             *_labelTitle;
    UIView              *_viewWhiteLine;
    UIImageView         *_imageViewLamp;
    UICollectionView    *_collectionView;
    NSMutableArray      *_arrayTags;
    
}

@property (strong, nonatomic) YYCollectionViewWaterLayout *layout;
@property (assign, nonatomic) BOOL isCinemaTags; //是否是影院标签

- (CGFloat)heightWithTags:(NSArray *)tags;

@end

