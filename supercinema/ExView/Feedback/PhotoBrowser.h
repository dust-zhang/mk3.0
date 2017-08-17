//
//  PhotoBrowser.h
//  movikr
//
//  Created by mapollo91 on 10/3/16.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoImagePickerController.h"

@protocol PhotoBrowserDelegate <NSObject>
-(void)deleteImage:(int)selectedCount;
@end


@interface PhotoBrowser : UIView
{
    UIImageView* imageView;
}

//接收上个view 传过来的图片
@property (nonatomic,strong) UIImage    *_image;
@property (nonatomic,assign) int        _selectedCount;
@property (nonatomic,strong) NSArray    *_arrImageSize;
@property (nonatomic, weak) id <PhotoBrowserDelegate> photoBrowserDelegate;

- (void)show:(BOOL)animated;
- (void)hide;

@end





