//
//  JKPhotoBrowser.m
//  JKPhotoBrowser
//
//  Created by Jecky on 14/12/29.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

#import "JKPhotoBrowser.h"
#import "JKPhotoBrowserCell.h"
#import "ViewPostion.h"
#import "JKUtil.h"


@interface JKPhotoBrowser() <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView   *topView;
@property (nonatomic, strong) UIView   *bottmView;
@property (nonatomic, strong) UIButton    *checkButton;

@end

static NSString *kJKPhotoBrowserCellIdentifier = @"kJKPhotoBrowserCellIdentifier";

@implementation JKPhotoBrowser

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //进入时候，隐藏电池栏
        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        self.backgroundColor = [JKUtil getColor:@"282828"];
        self.autoresizesSubviews = YES;
        [self collectionView];
        [self createTopView];
    }
    return self;
}

- (void)closePhotoBrower
{
    [self hide];
}

- (void)photoDidChecked
{
    if (!self.checkButton.selected)
        //self.pickerController.selectedImageCount++;
        [self.delegate photoBrowserAddSelectCount:self];
    else
        //self.pickerController.selectedImageCount--;
        [self.delegate photoBrowserReduceSelectCount:self];
    
//    更新选择数量 (int)self.pickerController.selectedImageCount]
    [self updateSelectCount:[self.delegate photoBrowserSelectCount]];
    
    //self.pickerController.maximumNumberOfSelection
    if (!self.checkButton.selected && [self.delegate photoBrowserSelectCount] > [self.delegate photoBrowserMaxSelectCount])
    {
        
        [self.delegate photoBrowserReduceSelectCount:self];
        NSString  *str = [NSString stringWithFormat:@"最多选择%d张照片",[self.delegate photoBrowserMaxSelectCount]];
        [Tool showWarningTip:str  time:2.0f];
        return;
    }
    
    if (self.checkButton.selected)
    {
        if ([_delegate respondsToSelector:@selector(photoBrowser:didDeselectAtIndex:)]) {
            [_delegate photoBrowser:self didDeselectAtIndex:self.currentPage];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(photoBrowser:didSelectAtIndex:)]) {
            [_delegate photoBrowser:self didSelectAtIndex:self.currentPage];
        }
    }
    self.checkButton.selected = !self.checkButton.selected;
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JKPhotoBrowserCell *cell = (JKPhotoBrowserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kJKPhotoBrowserCellIdentifier forIndexPath:indexPath];
    cell.isStills = self.isStills;
    cell.asset = [self.assetsArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.bounds.size.width+20, self.bounds.size.height);
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    float itemWidth = CGRectGetWidth(self.collectionView.frame);
    if (offsetX >= 0){
        int page = offsetX / itemWidth;
        [self didScrollToPage:page];
    }
}

- (void)didScrollToPage:(int)page
{
    _currentPage = page;
    [self updateStatus];
}

- (BOOL)assetIsSelected:(NSURL *)assetURL
{
    //self.pickerController.selectedAssetArray
    NSMutableArray *selectedAssetArray = [self.delegate getSelectedAssetArray];
    if(self.isStills)
    {
        
        for (int i = 0 ; i < [selectedAssetArray count]; i++)
        {
            if ([ [assetURL absoluteString] isEqualToString:selectedAssetArray[i] ])
            {
                return YES;
            }
        }
    }
    else
    {
        for (JKAssets *asset in selectedAssetArray)
        {
            if ([assetURL isEqual:asset.assetPropertyURL])
            {
                return YES;
            }
        }

    }
    return NO;
}


- (void)reloadPhotoeData
{
    [self.collectionView setContentOffset:CGPointMake(_currentPage*CGRectGetWidth(self.collectionView.frame), 0) animated:NO];
    [self updateStatus];
    [self.collectionView reloadData];
    [self updateSelectCount:[self.delegate photoBrowserSelectCount]];
    
}


- (void)updateStatus
{
    if(self.isStills)
    {
        NSString *strUrl =[self.assetsArray objectAtIndex:_currentPage];
        self.checkButton.selected = [self assetIsSelected:[NSURL URLWithString:[Tool MosaicString:strUrl replaceString:@"h80" ]] ];
    }
    else
    {
        ALAsset  *asset = [self.assetsArray objectAtIndex:_currentPage];
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        self.checkButton.selected = [self assetIsSelected:assetURL];
    }
}

#pragma mark - setter
- (void)setAssetsArray:(NSMutableArray *)assetsArray
{
    if (_assetsArray != assetsArray)
    {
        _assetsArray = assetsArray;
        [self reloadPhotoeData];
    }
}

#pragma mark - getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.bounds.size.width+20, self.bounds.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[JKPhotoBrowserCell class] forCellWithReuseIdentifier:kJKPhotoBrowserCellIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_collectionView];
        
    }
    return _collectionView;
}


- (void )createTopView
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _topView.backgroundColor = RGBA(0, 0, 0, 0.8);
    [self addSubview:_topView];
    
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkButton.frame = CGRectMake(0, 7, 33, 33);
    [_checkButton setBackgroundImage:[UIImage imageNamed:@"btn_album_defult.png"] forState:UIControlStateNormal];
    [_checkButton setBackgroundImage:[UIImage imageNamed:@"btn_checkBox_selected.png"] forState:UIControlStateSelected];
    [_checkButton addTarget:self action:@selector(photoDidChecked) forControlEvents:UIControlEventTouchUpInside];
    _checkButton.exclusiveTouch = YES;
    _checkButton.right = self.width-10;
    [_topView addSubview:_checkButton];
    //下面工具条
    _bottmView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-70,SCREEN_WIDTH, 70)];
    _bottmView.backgroundColor = RGBA(0, 0, 0, 0.8);
    [self addSubview:_bottmView];
    //    返回
    UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 13, 50, 50);
    [button setBackgroundImage:[UIImage imageNamed:@"btn_toback.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_toback_selected.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(closePhotoBrower) forControlEvents:UIControlEventTouchUpInside];
    [_bottmView addSubview:button];

    UIButton *btnFinish = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFinish.frame = CGRectMake(0, 0, 40, _bottmView.frame.size.height);
    [btnFinish setTitleColor:RGBA(152, 211, 59, 1) forState:UIControlStateNormal];
    [btnFinish setTitle:@"完成" forState:UIControlStateNormal];
    [btnFinish.titleLabel setFont:MKFONT(14)];
    [btnFinish addTarget:self action:@selector(onButtonFinish) forControlEvents:UIControlEventTouchUpInside];
    btnFinish.exclusiveTouch = YES;
    btnFinish.right = self.width-10;
    [_bottmView addSubview:btnFinish];
    
    self.btnNum = [[UIButton alloc ] initWithFrame:CGRectMake(btnFinish.frame.origin.x-35, 40/2, 35, 35) ];
    [self.btnNum setBackgroundImage:[UIImage imageNamed:@"image_circle.png" ] forState:UIControlStateNormal];
    [self.btnNum setTitleColor:RGBA(152, 211, 59, 1) forState:UIControlStateNormal];
    [self.btnNum.titleLabel setFont:MKFONT(16) ];
    [_bottmView addSubview:self.btnNum];
    
}
-(void)onButtonFinish
{
    if([self.delegate photoBrowserSelectCount] == 0 )
    {
        [Tool showWarningTip:@"请选择一张图片"  time:2.0f];
        return;
    }
    [self hide];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Selectimage" object:self];
}
- (void)show:(BOOL)animated
{
    if (animated)
    {
        self.hidden=YES;
        self.alpha=0;
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(1, 1);
                             self.hidden=NO;
                             self.alpha=1;
                         }completion:^(BOOL finish){
                             
                         }];
    }
    else
    {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

- (void)hide
{
    //返回的时候，显示出电池栏
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(1.3, 1.3);
                         self.hidden=NO;
                         self.alpha=0;
                     }completion:^(BOOL finish){
                         self.hidden = YES;
                         [self removeFromSuperview];
                     }];
}
-(void) updateSelectCount:(int ) count
{
    if ([[self.delegate getPhotoController] isKindOfClass:[JKImagePickerController class]])
    {
        if(count>6)
            count= 6;
    }
    else
    {
        if(count>4)
            count= 4;
    }
    [self.btnNum setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];

}
@end
