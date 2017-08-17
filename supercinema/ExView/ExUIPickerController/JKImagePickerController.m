//
//  JKImagePickerController.m
//  JKImagePicker
//
//  Created by Jecky on 15/1/9.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import "JKImagePickerController.h"
#import "ViewPostion.h"
#import "AlbumViewCell.h"
#import "PhotoAlbumManager.h"
#import "JKPhotoBrowser.h"
#import "JKAssetsCollectionFooterView.h"



ALAssetsFilter * ALAssetsFilterFromJKImagePickerControllerFilterType(JKImagePickerControllerFilterType type)
{
    switch (type)
    {
        case JKImagePickerControllerFilterTypeNone:
            return [ALAssetsFilter allAssets];
            break;
        case JKImagePickerControllerFilterTypePhotos:
            return [ALAssetsFilter allPhotos];
            break;
        case JKImagePickerControllerFilterTypeVideos:
            return [ALAssetsFilter allVideos];
            break;
    }
}


@interface JKImagePickerController ()<UICollectionViewDataSource,UICollectionViewDelegate,AlbumViewCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,JKPhotoBrowserDelegate>

@end

@implementation JKImagePickerController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.filterType = JKImagePickerControllerFilterTypePhotos;
        _arrayStillsSelected = [[NSMutableArray alloc ] initWithCapacity:0];
        _isStillsOrAbu = @"";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishPhotoDidSelected)
                                                 name:@"Notification_Selectimage" object:nil];
    //已经选择的照片数量
//    self.maximumNumberOfSelection = self.selectedImageCount;
    
    [self.navigationController.navigationBar setBackgroundImage:[ImageOperation imageWithColor:RGBA(244, 238, 231, 1) size:CGSizeMake(44, SCREEN_WIDTH) ] forBarMetrics:UIBarMetricsDefault];
    
    _isStills = YES;//不是剧照
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpProperties];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self collectionView];
    //    先加载剧照
    [self loadStills];
}

#pragma mark    完成 button
- (void)setUpProperties
{
    // Property settings
    self.groupTypes = @[@(ALAssetsGroupLibrary),@(ALAssetsGroupSavedPhotos),@(ALAssetsGroupPhotoStream),@(ALAssetsGroupAlbum)];
    _btnFinish = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_btnFinish setEnabled:NO];
    _btnFinish.frame = CGRectMake(0, 0, 50, 30);
    [_btnFinish setTitle:@"完成" forState:UIControlStateNormal];
    [_btnFinish setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [_btnFinish setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _btnFinish.titleLabel.font = MKFONT(15);
    [_btnFinish addTarget:self action:@selector(finishPhotoDidSelected) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *preItem = [[UIBarButtonItem alloc] initWithCustomView:_btnFinish];
    [self.navigationItem setRightBarButtonItem:preItem animated:NO];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    _btnStills = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnStills.titleLabel.font = MKFONT(15);
    _btnStills.frame = CGRectMake(SCREEN_WIDTH/2-50, 12, 50, self.navigationController.navigationBar.size.height-25);
    [_btnStills setTitle:@"剧照" forState:UIControlStateNormal];
    [_btnStills setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnStills setBackgroundColor:RGBA(80, 77, 75, 1)];
    [_btnStills addTarget:self action:@selector(SelectAlbumAndStills:) forControlEvents:UIControlEventTouchUpInside];
    _btnStills.layer.masksToBounds = YES;
    _btnStills.layer.cornerRadius = 3;
    [self.navigationController.navigationBar addSubview:_btnStills];
    
    _btnAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnAlbum.frame = CGRectMake(SCREEN_WIDTH/2, 12, 50,  self.navigationController.navigationBar.size.height-25);
    [_btnAlbum setTitle:@"相册" forState:UIControlStateNormal];
    _btnAlbum.titleLabel.font = MKFONT(15);
    [_btnAlbum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnAlbum addTarget:self action:@selector(SelectAlbumAndStills:) forControlEvents:UIControlEventTouchUpInside];
    _btnAlbum.layer.masksToBounds = YES;
    _btnAlbum.layer.cornerRadius = 3;
    [self.navigationController.navigationBar addSubview:_btnAlbum];
    
}
-(void) setDefautButtn:(UIButton*)sender
{
    if ([sender isEqual:_btnAlbum])
    {
        [_btnAlbum setBackgroundColor:RGBA(80, 77, 75, 1)];
        [_btnAlbum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_btnStills setBackgroundColor:[UIColor clearColor]];
        [_btnStills setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if ([sender isEqual:_btnStills])
    {
        [_btnStills setBackgroundColor:RGBA(80, 77, 75, 1)];
        [_btnStills setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_btnAlbum setBackgroundColor:[UIColor clearColor]];
        [_btnAlbum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

#pragma mark 相册、剧照按钮
-(void) SelectAlbumAndStills:(UIButton*)sender
{
    //设置按钮颜色
    [self setDefautButtn:sender ];
    if ([sender isEqual:_btnAlbum])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CancelLoadImage" object:nil];
        _isStills = NO;
        [_arrayStillsSelected removeAllObjects];
        _arrayStillsSelected = [NSMutableArray arrayWithArray:self.selectedAssetArray];
        [self.selectedAssetArray removeAllObjects];
        
        //重新将相册数组赋值
        self.selectedAssetArray = [NSMutableArray arrayWithArray:_arrayAlbumSelected];
        [self loadAssetsGroups];
    }
    if ([sender isEqual:_btnStills])
    {
        _isStills = YES;
        [_arrayAlbumSelected removeAllObjects];
        _arrayAlbumSelected = [NSMutableArray arrayWithArray:self.selectedAssetArray];
        [self.selectedAssetArray removeAllObjects];
        
        self.selectedAssetArray = [NSMutableArray arrayWithArray:_arrayStillsSelected];
        [self loadStills];
    }
}

#pragma mark 加载剧照图片
-(void)loadStills
{
    self.assetsArray = [[NSMutableArray alloc ] init];
    self.arrayBigImage  = [[NSMutableArray alloc ] init];

    [ServiceStills getStills:self._movieId includeMainHaibao:@1 array:^(NSArray *dramaArray)
    {
        for (int i= 0; i < [dramaArray count]; i++)
        {
            StillsModel *stillsModel =[dramaArray objectAtIndex:i];
            
            [self.assetsArray addObject:stillsModel.url_small];
            [self.arrayBigImage addObject:stillsModel.url];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [Tool showWarningTip:@"加载剧照失败"  time:2.0f];
    }];
}

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
              NSMutableDictionary  *dic = [NSMutableDictionary dictionaryWithCapacity:0];
              for (JKAssets  *asset in weakSelf.selectedAssetArray)
              {
                  if (asset.groupPropertyID)
                  {
                      NSInteger  count = [[dic objectForKey:asset.groupPropertyID] integerValue];
                      [dic setObject:[NSNumber numberWithInteger:count+1] forKey:asset.groupPropertyID];
                  }
              }
          }
          else
          {
              weakSelf.titleButton.enabled = NO;
          }
     }];
    // Validation
}

- (void)setSelectAssetsGroup:(ALAssetsGroup *)selectAssetsGroup
{
    if (_selectAssetsGroup != selectAssetsGroup)
    {
        _selectAssetsGroup = selectAssetsGroup;
        [self loadAllAssetsForGroups];
    }
}
//读取相册
- (void)loadAllAssetsForGroups
{
    [self.selectAssetsGroup setAssetsFilter:ALAssetsFilterFromJKImagePickerControllerFilterType(self.filterType)];
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
                  [assetsGroup setAssetsFilter:ALAssetsFilterFromJKImagePickerControllerFilterType(weakSelf.filterType)];
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
        }
         failureBlock:^(NSError *error)
        {

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
    NSMutableArray *arrayStills = [[NSMutableArray alloc ] init];
    if(_isStills)
    {
        [_arrayStillsSelected removeAllObjects];
        for (int i = 0 ; i < [self.selectedAssetArray count]; i++)
        {
            [_arrayStillsSelected addObject:[Tool MosaicString:self.selectedAssetArray[i] replaceString:@"!388"]];
        }
    }
    else
    {
        _arrayAlbumSelected = [NSMutableArray arrayWithArray:self.selectedAssetArray];
        for (int i = 0 ; i < [_arrayStillsSelected count]; i++)
        {
            [arrayStills addObject:[Tool MosaicString:_arrayStillsSelected[i] replaceString:@"!388"]];
        }
         [_arrayStillsSelected removeAllObjects];
         _arrayStillsSelected  = arrayStills;
    }
        
    if ([_delegate respondsToSelector:@selector(imagePickerController:didSelectAssets:stills:isSource:firslCheck:)])
    {
        [_delegate imagePickerController:self didSelectAssets:_arrayAlbumSelected stills:_arrayStillsSelected isSource:_selectButton.selected firslCheck:_isStillsOrAbu];
    }
}

static NSString *kJKImagePickerCellIdentifier = @"kJKImagePickerCellIdentifier";
static NSString *kJKAssetsFooterViewIdentifier = @"kJKAssetsFooterViewIdentifier";

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(!_isStills)  //不是剧照，从相册加载
    {
        return [self.assetsArray count]+1;
    }
    else
    {
        return [self.assetsArray count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    AlbumViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJKImagePickerCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    if(!_isStills)  //不是剧照，从相册加载
    {
        //取消加载网络图片
        [cell._imageView sd_cancelCurrentImageLoad ];
        
        cell.isStills = _isStills;
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
   }
   else//剧照
   {
       cell.isStills = _isStills;
       [cell setimage:self.assetsArray[indexPath.row]];
       
       NSURL *assetURL = self.assetsArray[indexPath.row];
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
                                                                                      withReuseIdentifier:kJKAssetsFooterViewIdentifier
                                                                                             forIndexPath:indexPath];
        if(_isStills)
        {
            footerView.textLabel.text = [NSString stringWithFormat:@"剧照已全部看完~"];
        }
        else
        {
            footerView.textLabel.text =@"";
        }
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
    if(_isStills)
        [self browerPhotoes:self.arrayBigImage page:[indexPath row]];
    else
        [self browerPhotoes:self.assetsArray page:[indexPath row]];
}
#pragma mark - 放大后选择图片
- (void)photoBrowser:(JKPhotoBrowser *)photoBrowser didSelectAtIndex:(NSInteger)index
{
    NSURL *assetURL;
    if (_isStills)
    {
        assetURL =  self.assetsArray[index];
    }
    else
    {
        ALAsset *asset = self.assetsArray[index];
        assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    }
    [self addAssetsObject:assetURL];
    [self resetFinishFrame];
    [self.collectionView reloadData];
}

- (void)photoBrowser:(JKPhotoBrowser *)photoBrowser didDeselectAtIndex:(NSInteger)index
{
    NSURL *assetURL;
    if (_isStills)
    {
        assetURL =  self.assetsArray[index];
    }
    else
    {
        ALAsset *asset = self.assetsArray[index];
        assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    }
    [self removeAssetsObject:assetURL];
    [self resetFinishFrame];
    [self.collectionView reloadData];
}


#pragma mark- 浏览大图
- (void)browerPhotoes:(NSArray *)array page:(NSInteger)page
{
    JKPhotoBrowser  *photoBorwser = [[JKPhotoBrowser alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if(!_isStills)
        photoBorwser.isStills = NO;
    else
        photoBorwser.isStills = YES;
    photoBorwser.delegate = self;
    photoBorwser.currentPage = page;
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
        [Tool showWarningTip:@"你已经选择了6张图片"  time:2.0f];
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
    if (self.selectedImageCount++ >=6)
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
        if(!_isStills)//非剧照
        {
            if ([_isStillsOrAbu length] == 0)
            {
                _isStillsOrAbu =@"album";
            }
            // Add asset URL
            NSURL *assetURL = [assetsCell.asset valueForProperty:ALAssetPropertyAssetURL];
            [self addAssetsObject:assetURL];
            [self resetFinishFrame];
            assetsCell.isSelected = YES;
           
        }
        else
        {
            if ([_isStillsOrAbu length] == 0)
            {
                _isStillsOrAbu =@"stills";
            }
//            assetsCell.nImageCount = self.selectedImageCount;
            [self addAssetsObject:assetsCell.imageUrl];
            [self resetFinishFrame];
            assetsCell.isSelected = YES;
        }
    }
}
//取消选择照片
- (void)didDeselectItemAssetsViewCell:(AlbumViewCell *)assetsCell
{
    self.selectedImageCount--;
    
    if(!_isStills)//非剧照
    {
//        assetsCell.nImageCount = self.selectedImageCount;
        NSURL *assetURL = [assetsCell.asset valueForProperty:ALAssetPropertyAssetURL];
        [self removeAssetsObject:assetURL];
        [self resetFinishFrame];
        assetsCell.isSelected = NO;
    }
    else
    {
//         assetsCell.nImageCount = self.selectedImageCount;
        [self removeAssetsObject:assetsCell.imageUrl];
        [self resetFinishFrame];
        assetsCell.isSelected = NO;
    }
}

- (void)removeAssetsObject:(NSURL *)assetURL
{
    if(!_isStills)//非剧照
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
    else
    {
        for (int i=0;i< [self.selectedAssetArray count] ;i++ )
        {
            if ([assetURL isEqual:self.selectedAssetArray[i] ])
            {
                [self.selectedAssetArray removeObjectAtIndex:i];
                break;
            }
        }
    }
}

- (void)addAssetsObject:(NSURL *)assetURL
{
    if(!_isStills)
    {
        NSURL *groupURL = [self.selectAssetsGroup valueForProperty:ALAssetsGroupPropertyURL];
        NSString *groupID = [self.selectAssetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
        JKAssets  *asset = [[JKAssets alloc] init];
        asset.groupPropertyID = groupID;
        asset.groupPropertyURL = groupURL;
        asset.assetPropertyURL = assetURL;
        [self.selectedAssetArray addObject:asset];
    }
    else
    {
        [self.selectedAssetArray addObject:[NSString stringWithFormat:@"%@",assetURL]];
    }
}

- (BOOL)assetIsSelected:(NSURL *)assetURL
{
    if(!_isStills)
    {
        for (JKAssets *asset in self.selectedAssetArray)
        {
            if ([assetURL isEqual:asset.assetPropertyURL])
            {
                return YES;
            }
        }
    }
    else
    {
        for (int i=0;i< [self.selectedAssetArray count] ;i++ )
        {
            if ([assetURL isEqual:self.selectedAssetArray[i] ])
            {
                return YES;
            }
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
        [_collectionView registerClass:[AlbumViewCell class] forCellWithReuseIdentifier:kJKImagePickerCellIdentifier];
        [_collectionView registerClass:[JKAssetsCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kJKAssetsFooterViewIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collectionView];     
    }
    return _collectionView;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_Selectimage" object:nil];
}

///////////////////////////////////

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
