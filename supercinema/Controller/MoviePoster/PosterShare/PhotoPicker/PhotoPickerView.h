//
//  PhotoPickerView.h
//  supercinema
//
//  Created by mapollo91 on 28/3/17.
//
//

#import <UIKit/UIKit.h>
#import "PhotoViewItem.h"

@protocol PhotoPickerViewDelegate <NSObject>
//填充内容
@required
-(void)itemView:(PhotoViewItem *)item AtIndex:(NSInteger)index;
//每行的数量
@required
-(NSInteger)cellItemCount;
//一共的数量
@required
-(NSInteger)dataCount;
//计算的最后一个View
@required
-(void)lastView:(UIView *)lastView;
//最后一个是否显示（加载更多按钮）
@required
-(BOOL)lastViewIsShow;
//设置列间距
-(CGFloat)itemPaddingRight;
//设置行间距
-(CGFloat)itemPaddingBottom;
//点击Item
-(void)touchItem:(PhotoViewItem *)item AtIndex:(NSInteger)index;
-(void)checkItemStatus:(PhotoViewItem *)item;
-(void)uncheckItemStatus:(PhotoViewItem *)item;
//点击LastView
-(void)touchLastView:(UIView *)lastView;
//上拉加载
-(void)pullLoadData;

@end

@interface PhotoPickerView : UIView<UIScrollViewDelegate>
{
    UIScrollView      *_scrolloViewBG;
    UIView            *_lastView;
    NSMutableArray    *_arrItems;
}
@property (nonatomic, weak) id<PhotoPickerViewDelegate> delegate;
@property (nonatomic, assign) BOOL isSingleCheck;       //是否单选

//初始化
-(id)initWithFrame:(CGRect)frame;
//重新加载
-(void)reload;


@end
