//
//  IMageBrowseViewController.h
//  supercinema
//
//  Created by lianyanmin on 17/3/24.
//
//

#import "MSSBrowseNetworkViewController.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UIView+MSSLayout.h"
#import "UIImage+MSSScale.h"
#import "MSSBrowseDefine.h"

@interface ImageBrowseViewController : MSSBrowseNetworkViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>

@property (nonatomic, assign)   NSInteger    _currentIndex;
@property (nonatomic, strong)   NSArray      *_arrBrowseItem;

@end
