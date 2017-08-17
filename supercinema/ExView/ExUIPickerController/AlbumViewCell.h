//
//  AlbumViewCell.h
//  JKImagePicker
//
//  Created by Jecky on 15/1/12.
//  Copyright (c) 2015年 Jecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class AlbumViewCell;

@protocol AlbumViewCellDelegate <NSObject>
@optional
- (void)startPhotoAssetsViewCell:(AlbumViewCell *)assetsCell;
- (void)didSelectItemAssetsViewCell:(AlbumViewCell *)assetsCell;
- (void)didDeselectItemAssetsViewCell:(AlbumViewCell *)assetsCell;

@end

@interface AlbumViewCell : UICollectionViewCell

@property (nonatomic, weak) id<AlbumViewCellDelegate>  delegate;
@property (nonatomic, strong) ALAsset   *asset;
@property (nonatomic, assign) BOOL      isSelected;
@property (nonatomic, assign) BOOL      isStills;
@property (nonatomic, strong) NSURL     *imageUrl;
//统计选择图片数量
@property (nonatomic, assign) int       nImageCount;
@property (nonatomic, strong) UIImageView *_imageView;
@property (nonatomic, strong) UIButton    *photoButton;
@property (nonatomic, strong) UIButton    *checkButton;



- (void)setimage:(NSURL *)imageUrl;

@end
