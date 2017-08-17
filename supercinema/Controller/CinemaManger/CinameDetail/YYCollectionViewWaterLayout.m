//
//  YYCollectionViewWaterLayout.m
//  supercinema
//
//  Created by lianyanmin on 17/4/12.
//
//

#import "YYCollectionViewWaterLayout.h"

@interface YYCollectionViewWaterLayout ()

@end

@implementation YYCollectionViewWaterLayout
/**
 *  返回每个item的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == YYCollectionViewWaterLayoutVertical)
    {
        __block NSString *minArrange = @"0";
        
        [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *arrange, NSNumber *minY, BOOL *stop) {
            if ([minY floatValue] < [self.maxYDict[minArrange]floatValue])
            {
                minArrange = arrange;
                
            }
        }];
        
        CGFloat itemW = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.arrangeCount - 1)*self.arrangeMargin)/self.arrangeCount;
        
        CGFloat itemH = [self.delegate itemHeightForWaterLayout:self forItemWitdh:itemW atIndexPath:indexPath];
        CGFloat itemX = self.sectionInset.left + [minArrange integerValue] *(self.arrangeMargin + itemW);
        CGFloat itemY = [self.maxYDict[minArrange]floatValue] + self.rowMargin;
        // 更新这一列的最大Y值
        self.maxYDict[minArrange] = @(itemY + itemH);
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame  = CGRectMake(itemX, itemY, itemW, itemH);
        return attr;
    }
    else if (_type == YYCollectionViewWaterLayoutHorizontalEndless)
    {
        __block NSString *minRow = @"0";
        
        [self.maxXDict enumerateKeysAndObjectsUsingBlock:^(NSString *arrange, NSNumber *minX, BOOL *stop)
        {
            if ([minX floatValue] < [self.maxXDict[minRow]floatValue])
            {
                minRow = arrange;
            }
        }];
        
        CGFloat itemH = (self.collectionView.frame.size.height - self.sectionInset.top - self.sectionInset.bottom - (self.rowCount - 1)*self.rowMargin)/self.rowCount;
        
        CGFloat itemW = [self.delegate itemWitdhForWaterLayout:self forItemHeight:itemH atIndexPath:indexPath];
        CGFloat itemY = self.sectionInset.top + [minRow integerValue] *(self.rowMargin + itemH);
        CGFloat itemX = [self.maxXDict[minRow]floatValue] + self.arrangeMargin;
        self.maxXDict[minRow] = @(itemX + itemW);
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame  = CGRectMake(itemX, itemY, itemW, itemH);
        return attr;
        
    }else if (_type == YYCollectionViewWaterLayoutHorizontalLimit || _type == YYCollectionViewWaterLayoutHorizontalNoSlid)
    {
        //确定行数
        NSString *row = self.lastItemAttrsDic[@"row"];
        NSString *indexPathFrameKey = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.item];
        if (self.lastItemAttrsDic[indexPathFrameKey])
        {
            NSString *frameString = self.lastItemAttrsDic[@"indexPathFrame"];
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attr.frame  = CGRectFromString(frameString);
            return attr;
        }
        else
        {
            CGFloat itemH = self.itemHeight;
            
            CGFloat itemW = [self.delegate itemWitdhForWaterLayout:self forItemHeight:itemH atIndexPath:indexPath];
            CGFloat itemY = self.sectionInset.top + [row integerValue] *(self.rowMargin + itemH);
            CGFloat itemX = [self.lastItemAttrsDic[@"maxX"] floatValue] + self.arrangeMargin;
            if (indexPath.item == 0)
            {
                itemX = self.sectionInset.left;
            }
            if (itemW + itemX + self.sectionInset.right > self.collectionView.bounds.size.width) {
                itemX = self.sectionInset.left;
                itemY += itemH + self.rowMargin;
                self.currentRow ++;
                self.rowCount = (int)self.currentRow + 1;
            }
            //行数
            self.lastItemAttrsDic[@"row"] = [NSString stringWithFormat:@"%ld",(long)self.currentRow];
            //maxX
            self.lastItemAttrsDic[@"maxX"] = @(itemX + itemW);
            CGRect frame = CGRectMake(itemX, itemY, itemW, itemH);
            self.lastItemAttrsDic[indexPathFrameKey] = NSStringFromCGRect(frame);
            UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attr.frame = frame;
            return attr;
        }
    }
    return [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
}
/**
 *  返回rect范围内的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}
/**
 *  返回ContentSize
 */
- (CGSize)collectionViewContentSize
{
    
    if (_type == YYCollectionViewWaterLayoutVertical)
    {
        __block NSString *maxArrange = @"0";
        [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *arrange, NSNumber *maxY, BOOL *stop)
        {
            if ([maxY floatValue] > [_maxYDict[maxArrange] floatValue]) {
                maxArrange = arrange;
            }
        }];
        return CGSizeMake(self.collectionView.bounds.size.width, self.sectionInset.bottom + [self.maxYDict[maxArrange] floatValue]);
    }
    else if (_type == YYCollectionViewWaterLayoutHorizontalEndless)
    {
        __block NSString *maxRow = @"0";
        [self.maxXDict enumerateKeysAndObjectsUsingBlock:^(NSString *arrange, NSNumber *maxX, BOOL *stop) {
            if ([maxX floatValue] > [_maxXDict[maxRow] floatValue]) {
                maxRow = arrange;
            }
        }];
        return CGSizeMake([self.maxXDict[maxRow] floatValue] + self.sectionInset.right,0);
        
    }
    else if (_type == YYCollectionViewWaterLayoutHorizontalLimit || _type == YYCollectionViewWaterLayoutHorizontalNoSlid)
    {
        CGSize size = CGSizeMake(self.collectionView.bounds.size.width, (self.rowCount - 1) * self.rowMargin + self.rowCount * self.itemHeight + self.sectionInset.top + self.sectionInset.bottom);
        NSLog(@"%@",NSStringFromCGSize(size));
        return size;
    }
    return CGSizeZero;
}
- (CGSize)contentSize
{
    if (_type == YYCollectionViewWaterLayoutVertical)
    {
        __block NSString *maxArrange = @"0";
        [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *arrange, NSNumber *maxY, BOOL *stop)
        {
            if ([maxY floatValue] > [_maxYDict[maxArrange] floatValue])
            {
                maxArrange = arrange;
            }
        }];
        return CGSizeMake(self.collectionView.bounds.size.width, self.sectionInset.bottom + [self.maxYDict[maxArrange] floatValue]);
    }
    else if (_type == YYCollectionViewWaterLayoutHorizontalEndless)
    {
        __block NSString *maxRow = @"0";
        [self.maxXDict enumerateKeysAndObjectsUsingBlock:^(NSString *arrange, NSNumber *maxX, BOOL *stop) {
            if ([maxX floatValue] > [_maxXDict[maxRow] floatValue])
            {
                maxRow = arrange;
            }
        }];
        return CGSizeMake([self.maxXDict[maxRow] floatValue] + self.sectionInset.right,0);
        
    }
    else if (_type == YYCollectionViewWaterLayoutHorizontalLimit || _type == YYCollectionViewWaterLayoutHorizontalNoSlid)
    {
        CGSize size = CGSizeMake(self.collectionView.bounds.size.width, (self.rowCount - 1) * self.rowMargin + self.rowCount * self.itemHeight + self.sectionInset.top + self.sectionInset.bottom);
        NSLog(@"%@",NSStringFromCGSize(size));
        return size;
    }
    return CGSizeZero;
}
/**
 *  每次布局之前的准备
 */
- (void)prepareLayout{
    [super prepareLayout];
    //清空最大的Y值
    for (NSInteger i = 0; i < self.arrangeCount; i ++) {
        NSString *key = [NSString stringWithFormat:@"%ld",(long)i];
        self.maxYDict[key] = @(self.sectionInset.top);
    }
    //清空最大的X值
    for (NSInteger i = 0; i < self.rowCount; i ++) {
        NSString *key = [NSString stringWithFormat:@"%ld",(long)i];
        self.maxXDict[key] = @(self.sectionInset.left);
    }
    [self.lastItemAttrsDic removeAllObjects];
    self.currentRow = 0;
    
    //计算所有item的属性
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i ++) {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attr];
    }
    
}

/**
 *  设置默认的数据
 */
- (instancetype)init{
    if (self = [super init]) {
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.arrangeMargin = 10;
        self.rowMargin = 10;
        self.arrangeCount = 1;
        self.rowCount = 1;
        self.currentRow = 0;
        self.type = YYCollectionViewWaterLayoutVertical;
    }
    return self;
}

/**
 *  maxYDict初始化
 */
- (NSMutableDictionary *)maxYDict{
    if (_maxYDict == nil) {
        _maxYDict = [[NSMutableDictionary alloc]init];
    }
    return _maxYDict;
}

/**
 *  maxXDict初始化
 */
- (NSMutableDictionary *)maxXDict{
    if (_maxXDict == nil) {
        _maxXDict = [[NSMutableDictionary alloc]init];
    }
    return _maxXDict;
}

/**
 *  lastItemAttrsDic初始化
 */
- (NSMutableDictionary *)lastItemAttrsDic{
    if (_lastItemAttrsDic == nil) {
        _lastItemAttrsDic = [[NSMutableDictionary alloc]init];
    }
    return _lastItemAttrsDic;
}

/**
 *  attrsArray初始化
 */
- (NSMutableArray *)attrsArray{
    if (_attrsArray == nil) {
        _attrsArray = [[NSMutableArray alloc]init];
    }
    return _attrsArray;
}

/**
 *  实时刷新布局属性
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
