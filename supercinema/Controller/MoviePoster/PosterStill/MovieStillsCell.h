//
//  PictureCollectionViewCell.h
//  NotificationDemo
//
//  Created by lianyanmin on 17/3/22.
//  Copyright © 2017年 lianyanmin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StillModel;

@interface MovieStillsCell : UICollectionViewCell

-(void)setData:(StillModel*)model;

@property (nonatomic, strong) UIImageView *_imageView;

@end
