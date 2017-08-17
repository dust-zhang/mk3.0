//
//  PhotoImagePickerController.h
//  movikr
//
//  Created by mapollo91 on 8/3/16.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "JKAssets.h"
#import "JKAssetsGroupsView.h"
#import "JKUtil.h"

typedef NS_ENUM(NSUInteger, PhotoImagePickerControllerFilterType)
{
    PhotoImagePickerControllerFilterTypeNone,
    PhotoImagePickerControllerFilterTypePhotos,
    PhotoImagePickerControllerFilterTypeVideos
};

UIKIT_EXTERN ALAssetsFilter * ALAssetsFilterFromPhotoImagePickerControllerFilterType(PhotoImagePickerControllerFilterType type);

@class PhotoImagePickerController;

@protocol PhotoImagePickerControllerDelegate <NSObject>

@optional
- (void)imagePickerController:(PhotoImagePickerController *)imagePicker
               didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
                   firslCheck:(NSString *)stilss_alubm;

- (void)imagePickerController:(PhotoImagePickerController *)imagePicker
              didSelectAssets:(NSArray *)albumAssets
                     isSource:(BOOL)source;

- (void)imagePickerControllerDidCancel:(PhotoImagePickerController *)imagePicker;

@end

@interface PhotoImagePickerController : UIViewController
{
    UIButton *_btnFinish;           //完成按钮
    UIButton *_btnAlbum;            //相册按钮
    NSMutableArray *_arrayAlbumSelected; //相册
}

@property (nonatomic, weak) id<PhotoImagePickerControllerDelegate> delegate;
@property (nonatomic, assign) PhotoImagePickerControllerFilterType filterType;
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
@property (nonatomic, strong) UILabel           *titleLabel;        //按钮上的标签文字
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
@property (nonatomic, strong) NSString          *_movieId;
@property (nonatomic, strong) JKAssetsGroupsView    *assetsGroupsView;

@end
