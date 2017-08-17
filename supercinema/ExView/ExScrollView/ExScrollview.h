//
//  ExScrollview.h
//  movikr
//
//  Created by Mapollo27 on 15/6/11.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EScrollerViewDelegate <NSObject>
@optional
-(void)EScrollerViewDidClicked:(int)index;
@end

@interface ExScrollview : UIView<UIScrollViewDelegate>
{
    CGRect                  viewSize;
    UIScrollView            *scrollView;
    UIPageControl           *pageControl;
    id<EScrollerViewDelegate> delegate;
    int                     currentPageIndex;
    UILabel                 *noteTitle;
    UIButton                *leftButton;
    UIButton                *rightButton;
    NSUInteger              nImageCount;
    int                     currentPage ;
    NSString                *strAside;
    NSString                *strContent;
    NSMutableArray          *arrayAsideCon;
}

@property(nonatomic,retain)id<EScrollerViewDelegate> delegate;
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr selImage:(int) index;
@end
