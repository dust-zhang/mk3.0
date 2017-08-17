//
//  CinemaPhoneView.h
//  supercinema
//
//  Created by lianyanmin on 2017/4/19.
//
//

#import <UIKit/UIKit.h>
#import "YYCollectionViewWaterLayout.h"

@interface CinemaPhoneViewCell : UICollectionViewCell


@property (nonatomic, copy)   NSString   *text;
@property (nonatomic, strong) UILabel    *labelText;

@end

@interface CinemaPhoneView : UIView

@property (strong, nonatomic) NSArray<__kindof NSString *> *phone;

- (CGFloat)contentHeight;

@end

@interface CinemaPhoneView ()<YYCollectionViewWaterLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView              *collectionView;
@property (strong, nonatomic) YYCollectionViewWaterLayout   *layout;
@property (strong, nonatomic) UILabel                       *labelTitle;

@end
