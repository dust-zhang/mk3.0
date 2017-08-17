//
//  ScrollViewForStill.h
//  animition
//
//  Created by dust on 2017/3/27.
//  Copyright © 2017年 dust. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSBrowseModel.h"

@protocol openStillDelegate <NSObject>
@optional
-(void)OpenStill:(NSArray *)arrStills ImageIndex:(NSInteger)index;
@end

@interface ScrollViewForStill : UIScrollView
{
    NSMutableArray *_arrStill;
    NSMutableArray *_arrAllStill;
    MSSBrowseModel *browseItem;
}
- (id)initWithFrame:(CGRect)frame arrStill:(NSMutableArray *)arr;

@property(nonatomic, weak) id<openStillDelegate> _openStillDelegate;

@end

