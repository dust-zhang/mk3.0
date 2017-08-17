//
//  PhotoPickerView.m
//  supercinema
//
//  Created by mapollo91 on 28/3/17.
//
//

#import "PhotoPickerView.h"


@interface PhotoPickerView ()

@end

@implementation PhotoPickerView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _arrItems = [[NSMutableArray alloc] init];
        _scrolloViewBG = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrolloViewBG.backgroundColor = [UIColor clearColor];
        _scrolloViewBG.delegate = self;
        [self addSubview:_scrolloViewBG];
    }
    return self;
}

-(void)reload
{
    if(_lastView)
    {
        [_lastView removeFromSuperview];
    }
    
    for (PhotoPickerView *item in _arrItems)
    {
        //清页面
        [item removeFromSuperview];
    }
    //清缓存
    [_arrItems removeAllObjects];
    
    if ([self.delegate dataCount] == 0)
    {
        return;
    }
    
    CGFloat allWidth = _scrolloViewBG.frame.size.width;
    CGFloat allHeight = 0;
    NSInteger dataCount = [self.delegate dataCount];
    
    NSInteger cellItemCount = [self.delegate cellItemCount];
    CGFloat itemPaddingRight = [self.delegate itemPaddingRight];
    CGFloat itemPaddingBottom = [self.delegate itemPaddingBottom];
    
    CGFloat width = (allWidth - itemPaddingRight * (cellItemCount-1)) / cellItemCount;
    CGFloat height = width;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (int i=0; i<[self.delegate dataCount]; i++)
    {
        x = (i%(cellItemCount))*(width+itemPaddingRight);
        y = ((int)(i/cellItemCount))*(height+itemPaddingBottom);
        
        PhotoViewItem *itemView = [[PhotoViewItem alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.delegate itemView:itemView AtIndex:i];
        itemView.tag = i;
        [_scrolloViewBG addSubview:itemView];
        [_arrItems addObject:itemView];
        //添加点击事件
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemViewClick:)];
        [click setNumberOfTapsRequired:1];//点击一次
        click.cancelsTouchesInView = NO;//设置可点击
        [itemView addGestureRecognizer:click];
    }
    
    if ([self.delegate lastViewIsShow])
    {
        //201704141359ZLY
//        x = (dataCount%(cellItemCount))*(width+itemPaddingRight);
//        y = ((int)(dataCount/cellItemCount))*(height+itemPaddingBottom);
//        _lastView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
//        [_scrolloViewBG addSubview:_lastView];
//        [self.delegate lastView:_lastView];
//        
//        //添加点击事件
//        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLastViewClick:)];
//        [click setNumberOfTapsRequired:1];//点击一次
//        click.cancelsTouchesInView = NO;//设置可点击
//        [_lastView addGestureRecognizer:click];
        
        x = (dataCount%(cellItemCount))*(width+itemPaddingRight);
        y = ((int)(dataCount/cellItemCount))*(height+itemPaddingBottom);
        _lastView = [[UIView alloc] initWithFrame:CGRectMake(x, y, _scrolloViewBG.frame.size.width, height)];
        [_scrolloViewBG addSubview:_lastView];
        [self.delegate lastView:_lastView];
    }
    
    allHeight = y + height;
    
    _scrolloViewBG.contentSize = CGSizeMake(allWidth, allHeight);
}

-(void)onItemViewClick:(UITapGestureRecognizer *)sender
{
    PhotoViewItem *viewItem = (PhotoViewItem *)(sender.view);
    
    if (self.isSingleCheck)
    {
        for(PhotoViewItem *unCheckViewItem in _arrItems)
        {
            if ([self.delegate respondsToSelector:@selector(uncheckItemStatus:)])
            {
                [self.delegate uncheckItemStatus:unCheckViewItem];
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(checkItemStatus:)])
        {
            [self.delegate checkItemStatus:viewItem];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(checkItemStatus:)])
        {
            [self.delegate checkItemStatus:viewItem];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(touchItem:AtIndex:)])
    {
        [self.delegate touchItem:viewItem AtIndex:sender.view.tag];
    }
}

-(void)onLastViewClick:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(touchLastView:)])
    {
        [self.delegate touchLastView:sender.view];
    }
}

#pragma mark ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > (_scrolloViewBG.contentSize.height-_scrolloViewBG.frame.size.height))
    {
        //scroll向上滚动
        NSLog(@"向上滑动");
        if ([self.delegate respondsToSelector:@selector(pullLoadData)])
        {
            [self.delegate pullLoadData];
        }
    }
//    else if (scrollView.contentOffset.y < 0)
//    {
//        //scroll向下滚动
//        NSLog(@"向下滑动");
//    }
}


@end
