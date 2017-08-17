//
//  YYCollectionViewWaterLayout.h
//  supercinema
//
//  Created by lianyanmin on 17/4/12.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYCollectionViewWaterLayoutType)
{
    YYCollectionViewWaterLayoutVertical , //竖直的瀑布流 default
    YYCollectionViewWaterLayoutHorizontalEndless , //水平的瀑布流
    YYCollectionViewWaterLayoutHorizontalLimit , //水平的不可水平滑动可以竖直滑动的瀑布流（类似京东搜索框下面的标签栏）
    YYCollectionViewWaterLayoutHorizontalNoSlid //不可滑动的
};


@class YYCollectionViewWaterLayout;
@protocol YYCollectionViewWaterLayoutDelegate <NSObject>
@optional
/** 竖直的必须实现这个方法 */
- (CGFloat)itemHeightForWaterLayout:(YYCollectionViewWaterLayout *)waterLayout forItemWitdh:(CGFloat)witdh atIndexPath:(NSIndexPath *)indexPath;
/** 水平的必须实现这个方法 */
- (CGFloat)itemWitdhForWaterLayout:(YYCollectionViewWaterLayout *)waterLayout forItemHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath;

@end

@interface YYCollectionViewWaterLayout : UICollectionViewLayout

@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 每一列之间的间距 */
@property (nonatomic, assign) CGFloat      arrangeMargin;
/** 每一行之间的间距 */
@property (nonatomic, assign) CGFloat      rowMargin;
/** 显示多少列 非YYCollectionViewWaterLayoutVertical 设置了也无效*/
@property (nonatomic, assign) int          arrangeCount;
/** 显示多少行 非YYCollectionViewWaterLayoutHorizontalEndless 设置了也无效*/
@property (nonatomic, assign) int          rowCount;
/** 显示多少行 非DFCollectionViewWaterLayoutHorizontalLimit/NoSlid 设置了也无效*/
@property (nonatomic , assign) CGFloat     itemHeight;

@property (nonatomic, weak) id<YYCollectionViewWaterLayoutDelegate> delegate;

@property (nonatomic , assign) YYCollectionViewWaterLayoutType type;

- (CGSize)contentSize;

/** 这个字典用来存储每一列最大的Y值(每一列的高度) */
@property (nonatomic, strong) NSMutableDictionary *maxYDict;

/** 这个字典用来存储每一行最大的X值(每一行的maxX) */
@property (nonatomic, strong) NSMutableDictionary *maxXDict;

@property (nonatomic, strong) NSMutableDictionary *lastItemAttrsDic;

/** 当前的行数 */
@property (nonatomic , assign) NSInteger currentRow;

/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end
