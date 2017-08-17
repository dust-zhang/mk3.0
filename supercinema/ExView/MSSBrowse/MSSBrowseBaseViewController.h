//
//  MSSBrowseBaseViewController.h
//  MSSBrowse
//
//  Created by 于威 on 16/4/26.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSBrowseCollectionViewCell.h"
#import "MSSBrowseModel.h"

@interface MSSBrowseBaseViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate,UIActionSheetDelegate>
{
    UIImageView* _imgViewUp;
    UIImageView* _imgViewDown;
    UIButton*   _btnClose;
    UILabel*    _labelCount;
    UIView*     _imgLineLeft;
    UIView*     _imgLineRight;
    BOOL        _isHideView;
    MSSBrowseCollectionViewCell*    _curCell;
}
@property (nonatomic,assign)BOOL                isEqualRatio;// 大小图是否等比（默认为等比）
@property (nonatomic,strong)UICollectionView    *collectionView;
@property (nonatomic,assign)BOOL                isFirstOpen;
@property (nonatomic,assign)CGFloat             screenWidth;
@property (nonatomic,assign)CGFloat             screenHeight;

- (instancetype)initWithBrowseItemArray:(NSArray *)browseItemArray currentIndex:(NSInteger)currentIndex;
- (void)showBrowseViewController;

// 子类重写此方法
- (void)loadBrowseImageWithBrowseItem:(MSSBrowseModel *)browseItem Cell:(MSSBrowseCollectionViewCell *)cell bigImageRect:(CGRect)bigImageRect;
// 获取指定视图在window中的位置
- (CGRect)getFrameInWindow:(UIView *)view;

@end
