//
//  PhotoImagePickerController.m
//  movikr
//
//  Created by mapollo91 on 8/3/16.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import "PhotoImagePickerController.h"
#import "ViewPostion.h"
#import "AlbumViewCell.h"
#import "PhotoAlbumManager.h"
#import "JKPhotoBrowser.h"
#import "JKAssetsCollectionFooterView.h"


ALAssetsFilter * ALAssetsFilterFromPhotoImagePickerControllerFilterType(PhotoImagePickerControllerFilterType type)
{
    switch (type)
    {
        case PhotoImagePickerControllerFilterTypeNone:
            return [ALAssetsFilter allAssets];
            break;
        case PhotoImagePickerControllerFilterTypePhotos:
            return [ALAssetsFilter allPhotos];
            break;
        case PhotoImagePickerControllerFilterTypeVideos:
            return [ALAssetsFilter allVideos];
            break;
    }
}

@interface PhotoImagePickerController ()<UICollectionViewDataSource,UICollectionViewDelegate,AlbumViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,JKPhotoBrowserDelegate,JKAssetsGroupsViewDelegate>

@end

@implementation PhotoImagePickerController
- (id)init
{
    self = [super init];
    if (self)
    {
        self.filterType = PhotoImagePickerControllerFilterTypeNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishPhotoDidSelected)
                                                 name:@"Notification_Selectimage" object:nil];
    [self.navigationController.navigationBar setBackgroundImage:[ImageOperation imageWithColor:RGBA(244, 238, 231, 1) size:CGSizeMake(44, SCREEN_WIDTH) ] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpProperties];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self collectionView];
}

#pragma mark  完成 button
- (void)setUpProperties
{
    // Property settings
    self.groupTypes = @[@(ALAssetsGroupLibrary),@(ALAssetsGroupSavedPhotos),@(ALAssetsGroupPhotoStream),@(ALAssetsGroupAlbum)];
    
    self.navigationItem.titleView = self.titleButton;
    
    //完成按钮
    _btnFinish = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnFinish.frame = CGRectMake(0, 0, 50, 30);
    [_btnFinish setTitle:@"完成" forState:UIControlStateNormal];
    [_btnFinish setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [_btnFinish setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _btnFinish.titleLabel.font = MKFONT(15);
    [_btnFinish addTarget:self action:@selector(finishPhotoDidSelected) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *preItem = [[UIBarButtonItem alloc] initWithCustomView:_btnFinish];
    [self.navigationItem setRightBarButtonItem:preItem animated:NO];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self SelectAlbumAndStills];
}

#pragma mark 相册
-(void) SelectAlbumAndStills
{
    //设置按钮颜色
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CancelLoadImage" object:nil];
    [self.selectedAssetArray removeAllObjects];
    //重新将相册数组赋值
    self.selectedAssetArray = [NSMutableArray arrayWithArray:_arrayAlbumSelected];
    [self loadAssetsGroups];
    _arrayAlbumSelected = [NSMutableArray arrayWithArray:self.selectedAssetArray];
}

#pragma mark 加载照片
- (void)cancelEventDidTouched
{
    if ([_delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)])
    {
        [_delegate imagePickerControllerDidCancel:self];
    }
}

- (void)selectOriginImage
{
    _selectButton.selected = !_selectButton.selected;
}

- (void)loadAssetsGroups
{
    // Load assets groups
    __weak typeof(self) weakSelf = self;
    [self loadAssetsGroupsWithTypes:self.groupTypes   completion:^(NSArray *assetsGroups)
     {
         if ([assetsGroups count]>0)
         {
             weakSelf.titleButton.enabled = YES;
             weakSelf.selectAssetsGroup = [assetsGroups objectAtIndex:0];
             
             weakSelf.assetsGroupsView.assetsGroups = assetsGroups;
             
             NSMutableDictionary  *dic = [NSMutableDictionary dictionaryWithCapacity:0];
             for (JKAssets  *asset in weakSelf.selectedAssetArray)
             {
                 if (asset.groupPropertyID)
                 {
                     NSInteger  count = [[dic objectForKey:asset.groupPropertyID] integerValue];
                     [dic setObject:[NSNumber numberWithInteger:count+1] forKey:asset.groupPropertyID];
                 }
             }
             weakSelf.assetsGroupsView.selectedAssetCount = dic;
             [weakSelf resetFinishFrame];
         }
         else
         {
             weakSelf.titleButton.enabled = NO;
         }
     }];
    // Validation
}

- (JKAssetsGroupsView *)assetsGroupsView{
    if (!_assetsGroupsView) {
        _assetsGroupsView = [[JKAssetsGroupsView alloc] initWithFrame:CGRectMake(0, -self.view.height, self.view.width, self.view.height)];
        _assetsGroupsView.delegate = self;
        _assetsGroupsView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_assetsGroupsView];
    }
    return _assetsGroupsView;
}

- (void)setSelectAssetsGroup:(ALAssetsGroup *)selectAssetsGroup
{
    if (_selectAssetsGroup != selectAssetsGroup)
    {
        _selectAssetsGroup = selectAssetsGroup;
        
        NSString  *assetsName = [selectAssetsGroup valueForProperty:ALAssetsGroupPropertyName];
        self.titleLabel.text = assetsName;
        [self.titleLabel sizeToFit];
        
        CGFloat  width = CGRectGetWidth(self.titleLabel.frame)/2+2+CGRectGetWidth(self.arrowImageView.frame)+15;
        self.titleButton.width = width*2;
        
        self.titleLabel.centerY = self.titleButton.height/2;
        self.titleLabel.centerX = self.titleButton.width/2;
        
        self.arrowImageView.left = self.titleLabel.right + 5;
        self.arrowImageView.centerY = self.titleLabel.centerY;
        [self loadAllAssetsForGroups];
    }
}

//读取相册
- (void)loadAllAssetsForGroups
{
    [self.selectAssetsGroup setAssetsFilter:ALAssetsFilterFromPhotoImagePickerControllerFilterType(self.filterType)];
    // Load assets
    NSMutableArray *assets = [NSMutableArray array];
    __block NSUInteger numberOfAssets = 0;
    __block NSUInteger numberOfPhotos = 0;
    __block NSUInteger numberOfVideos = 0;
    
    [self.selectAssetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
     {
         if (result)
         {
             numberOfAssets++;
             NSString *type = [result valueForProperty:ALAssetPropertyType];
             if ([type isEqualToString:ALAssetTypePhoto])
             {
                 numberOfPhotos++;
             }
             else if ([type isEqualToString:ALAssetTypeVideo])
             {
                 numberOfVideos++;
             }
             [assets addObject:result];
         }
     }];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    //反序遍历图片
    for(int i = (int)[assets count]-1; i >-1  ; i--)
    {
        [tempArr addObject:assets[i]];
    }
    self.assetsArray = tempArr;
    //    self.numberOfAssets = numberOfAssets;
    //    self.numberOfPhotos = numberOfPhotos;
    //    self.numberOfVideos = numberOfVideos;
    
    // Update view
    [self.collectionView reloadData];
}

- (void)loadAssetsGroupsWithTypes:(NSArray *)types completion:(void (^)(NSArray *assetsGroups))completion
{
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    for (NSNumber *type in types)
    {
        __weak typeof(self) weakSelf = self;
        [self.assetsLibrary enumerateGroupsWithTypes:[type unsignedIntegerValue] usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop)
         {
             if (assetsGroup)
             {
                 // Filter the assets group
                 [assetsGroup setAssetsFilter:ALAssetsFilterFromPhotoImagePickerControllerFilterType(weakSelf.filterType)];
                 // Add assets group
                 if (assetsGroup.numberOfAssets > 0)
                 {
                     // Add assets group
                     [assetsGroups addObject:assetsGroup];
                 }
             }
             else
             {
                 numberOfFinishedTypes++;
             }
             // Check if the loading finished
             if (numberOfFinishedTypes == types.count)
             {
                 // Sort assets groups
                 NSArray *sortedAssetsGroups = [self sortAssetsGroups:(NSArray *)assetsGroups typesOrder:types];
                 // Call completion block
                 if (completion)
                 {
                     completion(sortedAssetsGroups);
                 }
             }
         }failureBlock:^(NSError *error){
                
            }];
    }
}

- (NSArray *)sortAssetsGroups:(NSArray *)assetsGroups typesOrder:(NSArray *)typesOrder
{
    NSMutableArray *sortedAssetsGroups = [NSMutableArray array];
    for (ALAssetsGroup *assetsGroup in assetsGroups)
    {
        if (sortedAssetsGroups.count == 0)
        {
            [sortedAssetsGroups addObject:assetsGroup];
            continue;
        }
        
        ALAssetsGroupType assetsGroupType = [[assetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
        NSUInteger indexOfAssetsGroupType = [typesOrder indexOfObject:@(assetsGroupType)];
        
        for (NSInteger i = 0; i <= sortedAssetsGroups.count; i++)
        {
            if (i == sortedAssetsGroups.count)
            {
                [sortedAssetsGroups addObject:assetsGroup];
                break;
            }
            
            ALAssetsGroup *sortedAssetsGroup = sortedAssetsGroups[i];
            ALAssetsGroupType sortedAssetsGroupType = [[sortedAssetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
            NSUInteger indexOfSortedAssetsGroupType = [typesOrder indexOfObject:@(sortedAssetsGroupType)];
            
            if (indexOfAssetsGroupType < indexOfSortedAssetsGroupType)
            {
                [sortedAssetsGroups insertObject:assetsGroup atIndex:i];
                break;
            }
        }
    }
    return sortedAssetsGroups;
}

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    BOOL qualifiesMaximumNumberOfSelection = YES;
    
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection)
    {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}

- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection)
    {
        return (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return YES;
}

#pragma mark - JKAssetsGroupsViewDelegate
- (void)assetsGroupsViewDidCancel:(JKAssetsGroupsView *)groupsView
{
    [self assetsGroupsDidDeselected];
}

- (void)assetsGroupsView:(JKAssetsGroupsView *)groupsView didSelectAssetsGroup:(ALAssetsGroup *)assGroup
{
    [self assetsGroupsDidDeselected];
    
    self.selectAssetsGroup = assGroup;
}
- (void)assetsGroupsDidDeselected
{
    self.showsAssetsGroupSelection = NO;
    [self hideAssetsGroupView];
}

- (void)assetsGroupDidSelected
{
    if (self.showsAssetsGroupSelection == NO)
    {
        [self showAssetsGroupView];
    }
    else
    {
        [self hideAssetsGroupView];
    }
    self.showsAssetsGroupSelection = !self.showsAssetsGroupSelection;
    
}

- (void)showAssetsGroupView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.touchButton];
    
    self.overlayView.alpha = 0.0f;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.assetsGroupsView.top = 0;
                         self.overlayView.alpha = 0.85f;
                     }completion:^(BOOL finished) {
                         
                     }];
}

- (void)hideAssetsGroupView
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.assetsGroupsView.top = -self.assetsGroupsView.height;
                         self.overlayView.alpha = 0.0f;
                     }completion:^(BOOL finished) {
                         [_touchButton removeFromSuperview];
                         _touchButton = nil;
                         
                         [_overlayView removeFromSuperview];
                         _overlayView = nil;
                     }];
    
}


#pragma mark - setter
- (void)setShowsAssetsGroupSelection:(BOOL)showsAssetsGroupSelection
{
    
    _showsAssetsGroupSelection = showsAssetsGroupSelection;
    self.arrowImageView.selected = _showsAssetsGroupSelection;
    
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    _showsCancelButton = showsCancelButton;
    // Show/hide cancel button
    if (showsCancelButton)
    {
        //取消按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(-10, 0, 50, 30);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = MKFONT(15);
        [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelEventDidTouched) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
        [self.navigationItem setLeftBarButtonItem:cancelItem animated:NO];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    }
}

- (void)finishPhotoDidSelected
{
    _arrayAlbumSelected = [NSMutableArray arrayWithArray:self.selectedAssetArray];
    
    [_delegate imagePickerController:self didSelectAssets:_arrayAlbumSelected isSource:_selectButton.selected];
}

static NSString *kPhotoImagePickerCellIdentifier = @"kPhotoImagePickerCellIdentifier";
static NSString *kPhotoAssetsFooterViewIdentifier = @"kPhotoAssetsFooterViewIdentifier";

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assetsArray count]+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoImagePickerCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    //取消加载网络图片
    [cell._imageView sd_cancelCurrentImageLoad ];
    if ([indexPath row]<=0)
    {
        cell.asset = nil;
    }
    else
    {
        ALAsset *asset = self.assetsArray[indexPath.row-1];
        cell.asset = asset;
        //重新选择图片时默认选中上次已经选择的图片
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        cell.isSelected = [self assetIsSelected:assetURL];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 46.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter)
    {
        JKAssetsCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                      withReuseIdentifier:kPhotoAssetsFooterViewIdentifier
                                                                                             forIndexPath:indexPath];
        
        return footerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-10)/3, (SCREEN_WIDTH-10)/3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self browerPhotoes:self.assetsArray page:[indexPath row]];
}

#pragma mark - 放大后选择图片
- (void)photoBrowser:(JKPhotoBrowser *)photoBrowser didSelectAtIndex:(NSInteger)index
{
    NSURL *assetURL;
    ALAsset *asset = self.assetsArray[index];
    assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    
    [self addAssetsObject:assetURL];
    [self resetFinishFrame];
    [self.collectionView reloadData];
}

- (void)photoBrowser:(JKPhotoBrowser *)photoBrowser didDeselectAtIndex:(NSInteger)index
{
    NSURL *assetURL;
    ALAsset *asset = self.assetsArray[index];
    assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    
    [self removeAssetsObject:assetURL];
    [self resetFinishFrame];
    [self.collectionView reloadData];
}

#pragma mark- 浏览大图
- (void)browerPhotoes:(NSArray *)array page:(NSInteger)page
{
    JKPhotoBrowser  *photoBorwser = [[JKPhotoBrowser alloc] initWithFrame:[UIScreen mainScreen].bounds];
    photoBorwser.isStills = NO;
    photoBorwser.delegate = self;
    //photoBorwser.pickerController = self;
    photoBorwser.currentPage = page-1;
    photoBorwser.assetsArray = [NSMutableArray arrayWithArray:array];
    [photoBorwser show:YES];
}


#pragma mark- UIImagePickerViewController 摄像头拍照完成保存到相册
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    __weak typeof(self) weakSelf = self;
    NSString  *assetsName = [self.selectAssetsGroup valueForProperty:ALAssetsGroupPropertyName];
    [[PhotoAlbumManager sharedManager] saveImage:image toAlbum:assetsName completionBlock:^(ALAsset *asset, NSError *error)
     {
         if (error == nil && asset)
         {
             NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
             [self addAssetsObject:assetURL];
             [weakSelf finishPhotoDidSelected];
         }
     }];
    [picker dismissViewControllerAnimated:NO completion:^{}];
}

#pragma mark - AlbumViewCellDelegate
- (void)startPhotoAssetsViewCell:(AlbumViewCell *)assetsCell
{
    if (self.selectedAssetArray.count>=self.maximumNumberOfSelection)
    {
        [Tool showWarningTip:@"你已经选择了4张图片"  time:2.0f];
        return;
    }
    //摄像头拍照
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.allowsEditing = NO;
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerController animated:YES completion:^{
        }];
    }
}

#pragma mark 选择图片
- (void)didSelectItemAssetsViewCell:(AlbumViewCell *)assetsCell
{
    //统计一共选择的图片数量
    if (self.selectedImageCount++ >=4)
    {
        self.selectedImageCount--;
        NSString  *str = [NSString stringWithFormat:@"最多选择%lu张照片",(unsigned long)self.maximumNumberOfSelection];
        [Tool showWarningTip:str  time:2.0f];
        return;
    }
    if (self.selectedAssetArray.count>=self.maximumNumberOfSelection)
    {
        NSString  *str = [NSString stringWithFormat:@"最多选择%lu张照片",(unsigned long)self.maximumNumberOfSelection];
        [Tool showWarningTip:str  time:2.0f];
        return;
    }
    
    BOOL  validate = [self validateMaximumNumberOfSelections:(self.selectedAssetArray.count + 1)];
    if (validate)
    {
        // Add asset URL
        NSURL *assetURL = [assetsCell.asset valueForProperty:ALAssetPropertyAssetURL];
        [self addAssetsObject:assetURL];
        [self resetFinishFrame];
        assetsCell.isSelected = YES;
    }
}


//取消选择照片
- (void)didDeselectItemAssetsViewCell:(AlbumViewCell *)assetsCell
{
    self.selectedImageCount--;
    
    //        assetsCell.nImageCount = self.selectedImageCount;
    NSURL *assetURL = [assetsCell.asset valueForProperty:ALAssetPropertyAssetURL];
    [self removeAssetsObject:assetURL];
    [self resetFinishFrame];
    assetsCell.isSelected = NO;
    
}

- (void)removeAssetsObject:(NSURL *)assetURL
{
    for (JKAssets *asset in self.selectedAssetArray)
    {
        if ([assetURL isEqual:asset.assetPropertyURL])
        {
            [self.selectedAssetArray removeObject:asset];
            break;
        }
    }
}

- (void)addAssetsObject:(NSURL *)assetURL
{
    NSURL *groupURL = [self.selectAssetsGroup valueForProperty:ALAssetsGroupPropertyURL];
    NSString *groupID = [self.selectAssetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
    JKAssets  *asset = [[JKAssets alloc] init];
    asset.groupPropertyID = groupID;
    asset.groupPropertyURL = groupURL;
    asset.assetPropertyURL = assetURL;
    [self.selectedAssetArray addObject:asset];
}

- (BOOL)assetIsSelected:(NSURL *)assetURL
{
    for (JKAssets *asset in self.selectedAssetArray)
    {
        if ([assetURL isEqual:asset.assetPropertyURL])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)resetFinishFrame
{
    if (self.selectedAssetArray.count>0)
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [_btnFinish setTitleColor:RGBA(147, 214, 41, 1) forState:UIControlStateNormal];
        
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [_btnFinish setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

#pragma mark - getter/setter
- (NSMutableArray *)selectedAssetArray
{
    if (!_selectedAssetArray)
    {
        _selectedAssetArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedAssetArray;
}

- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary)
    {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2.0;
        layout.minimumInteritemSpacing = 2.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[AlbumViewCell class] forCellWithReuseIdentifier:kPhotoImagePickerCellIdentifier];
        [_collectionView registerClass:[JKAssetsCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kPhotoAssetsFooterViewIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIButton *)titleButton{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(0, 0, 120, 30);
        UIImage  *img =[UIImage imageNamed:@"navigationbar_title_highlighted"];
        [_titleButton setBackgroundImage:nil forState:UIControlStateNormal];
        [_titleButton setBackgroundImage:[JKUtil stretchImage:img capInsets:UIEdgeInsetsMake(5, 2, 5, 2) resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
        [_titleButton addTarget:self action:@selector(assetsGroupDidSelected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (UIButton *)arrowImageView
{
    if (!_arrowImageView)
    {
        UIImage  *img = [UIImage imageNamed:@"navigationbar_arrow_down.png"];
        UIImage  *imgSelect = [UIImage imageNamed:@"navigationbar_arrow_up.png"];
        _arrowImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _arrowImageView.frame = CGRectMake(0, 0, img.size.width/2, img.size.height/2);
        [_arrowImageView setBackgroundImage:img forState:UIControlStateNormal];
        [_arrowImageView setBackgroundImage:imgSelect forState:UIControlStateSelected];
        [self.titleButton addSubview:_arrowImageView];
    }
    return _arrowImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self.titleButton addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_Selectimage" object:nil];
}

////////////////////////////////
- (void)photoBrowserAddSelectCount:(JKPhotoBrowser *)photoBrowser{
    self.selectedImageCount++;
}

- (void)photoBrowserReduceSelectCount:(JKPhotoBrowser *)photoBrowser{
    self.selectedImageCount--;
}

- (int)photoBrowserMaxSelectCount{
    return (int)self.maximumNumberOfSelection;
}

- (int)photoBrowserSelectCount{
    return (int)self.selectedImageCount;
}

- (NSMutableArray *)getSelectedAssetArray{
    return self.selectedAssetArray;
}

- (UIViewController *)getPhotoController{
    return self;
}

@end

