//
//  JKImagePickerController.h
//  JKImagePicker
//
//  Created by Jecky on 15/1/9.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JKAssets.h"


typedef NS_ENUM(NSUInteger, JKImagePickerControllerFilterType)
{
    JKImagePickerControllerFilterTypeNone,
    JKImagePickerControllerFilterTypePhotos,
    JKImagePickerControllerFilterTypeVideos
};

UIKIT_EXTERN ALAssetsFilter * ALAssetsFilterFromJKImagePickerControllerFilterType(JKImagePickerControllerFilterType type);

@class JKImagePickerController;
@protocol JKImagePickerControllerDelegate <NSObject>

@optional
- (void)imagePickerController:(JKImagePickerController *)imagePicker
               didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
                   firslCheck:(NSString *)stilss_alubm;

- (void)imagePickerController:(JKImagePickerController *)imagePicker
              didSelectAssets:(NSArray *)albumAssets
                       stills:(NSArray *)stillsAssets
                     isSource:(BOOL)source
                   firslCheck:(NSString *)stilss_alubm;
- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker;

@end

@interface JKImagePickerController : UIViewController
{
    UIButton *_btnFinish;
    UIButton *_btnAlbum;
    UIButton *_btnStills;
    BOOL      _isStills;
    //    保存已经选择的照片或者剧照
    NSMutableArray *_arrayAlbumSelected; //相册
    NSMutableArray *_arrayStillsSelected;//剧照
    
//    判断先选择的剧照还是相册
    NSString    *_isStillsOrAbu;
}
@property (nonatomic, weak) id<JKImagePickerControllerDelegate> delegate;
@property (nonatomic, assign) JKImagePickerControllerFilterType filterType;
@property (nonatomic, assign) BOOL              showsCancelButton;
@property (nonatomic, assign) BOOL              allowsMultipleSelection;
@property (nonatomic, assign) NSUInteger        minimumNumberOfSelection;
@property (nonatomic, assign) NSUInteger        maximumNumberOfSelection;
@property (nonatomic, assign) NSUInteger        selectedImageCount;
@property (nonatomic, strong) NSMutableArray    *selectedAssetArray;
@property (nonatomic, strong) NSMutableArray    *selectedStillsArray;
@property (nonatomic, strong) ALAssetsLibrary   *assetsLibrary;
@property (nonatomic, strong) NSArray           *groupTypes;
@property (nonatomic, assign) BOOL              showsAssetsGroupSelection;
@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UIButton          *titleButton;
@property (nonatomic, strong) UIButton          *arrowImageView;
@property (nonatomic, strong) UIButton          *touchButton;
@property (nonatomic, strong) UIView            *overlayView;
@property (nonatomic, strong) ALAssetsGroup     *selectAssetsGroup;
@property (nonatomic, strong) NSMutableArray    *assetsArray;
@property (nonatomic, strong) NSMutableArray    *arrayBigImage;
@property (nonatomic, assign) NSUInteger        numberOfAssets;
@property (nonatomic, assign) NSUInteger        numberOfPhotos;
@property (nonatomic, assign) NSUInteger        numberOfVideos;
@property (nonatomic, strong) UIToolbar         *toolbar;
@property (nonatomic, strong) UIButton          *selectButton;
@property (nonatomic, strong) UIButton          *finishButton;
@property (nonatomic, strong) UILabel           *finishLabel;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) NSMutableArray    *arrayStills;
@property (nonatomic, strong) NSNumber          *_movieId;


@end



