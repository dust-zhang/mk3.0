//
//  JKPhotoBrowser.h
//  JKPhotoBrowser
//
//  Created by Jecky on 14/12/29.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKImagePickerController.h"


@class JKPhotoBrowser;

@protocol JKPhotoBrowserDelegate <NSObject>
@optional
- (void)photoBrowser:(JKPhotoBrowser *)photoBrowser didSelectAtIndex:(NSInteger)index;
- (void)photoBrowser:(JKPhotoBrowser *)photoBrowser didDeselectAtIndex:(NSInteger)index;
@required
- (void)photoBrowserAddSelectCount:(JKPhotoBrowser *)photoBrowser ;
@required
- (void)photoBrowserReduceSelectCount:(JKPhotoBrowser *)photoBrowser;
@required
- (int)photoBrowserMaxSelectCount;
@required
- (int)photoBrowserSelectCount;
@required
- (NSMutableArray *)getSelectedAssetArray;
@required
- (UIViewController *)getPhotoController;

@end

@interface JKPhotoBrowser : UIView

//@property (nonatomic, weak) PhotoImagePickerController  *pickerController;
@property (nonatomic, weak) id<JKPhotoBrowserDelegate> delegate;
@property (nonatomic, strong) NSMutableArray        *assetsArray;
@property (nonatomic, assign) NSInteger             currentPage;
@property (nonatomic, assign) BOOL                  isStills;
@property (nonatomic, strong) UIButton              *btnNum;

- (void)show:(BOOL)animated;
- (void)hide;

@end
