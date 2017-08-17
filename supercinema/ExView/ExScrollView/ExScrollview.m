//
//  ExScrollview.m
//  movikr
//
//  Created by Mapollo27 on 15/6/11.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "ExScrollview.h"

@implementation ExScrollview
@synthesize delegate;

- (void)dealloc
{
    [scrollView release];
    [noteTitle release];
    delegate=nil;
    if (pageControl)
    {
        [pageControl release];
    }
    [super dealloc];
}

-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr selImage:(int) index
{
    if ((self=[super initWithFrame:rect]))
    {
        nImageCount = [imgArr  count];
        currentPage =0;
        viewSize=rect;
        NSUInteger pageCount=[imgArr count];
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        for (int i=0; i<pageCount; i++)
        {
            UIImageView *imgView=[[[UIImageView alloc] init] autorelease];
            [imgView setBackgroundColor:[UIColor blackColor]];
            [imgView setImage:[imgArr objectAtIndex:i ]];
            [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.layer.masksToBounds = YES;
            [scrollView addSubview:imgView];
        }
        [self addSubview:scrollView];
        
        //左箭头
        leftButton = [[UIButton alloc ] initWithFrame:CGRectMake(5, 100, 53, 53)];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"btn_left.png"] forState:UIControlStateNormal];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"btn_left_selected.png"] forState:UIControlStateHighlighted];
        [leftButton addTarget:self action:@selector(onButtonLeft) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        
        //右箭头
        rightButton = [[UIButton alloc ] initWithFrame:CGRectMake(rect.size.width-53-5, 100, 53, 53)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"btn_right.png"] forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"btn_right_selected.png"] forState:UIControlStateHighlighted];
        [rightButton addTarget:self action:@selector(onButtonRight) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        //如果只有一只图片
        if (nImageCount == 1)
            [self hideLeftRightButton];
        else
            [self showRightHideLeftButton];
    
        [self setDfaultSelectImage:index];

        arrayAsideCon = [[NSMutableArray alloc ] initWithObjects:@"",@"", nil];
     }
    return self;
}
-(void) onButtonLeft
{
    currentPage--;
    if (-1 ==currentPage )
    {
        currentPage = 0;
        return;
    }
    [scrollView setContentOffset:CGPointMake(viewSize.size.width*currentPage, 0) animated:YES];
}
-(void) onButtonRight
{
    currentPage++;
    if (nImageCount ==currentPage )
        return;
    [scrollView setContentOffset:CGPointMake(viewSize.size.width*currentPage, 0) animated:YES];
}


#pragma mark 设置显示选中的图片
-(void) setDfaultSelectImage:(int ) index
{
     [scrollView setContentOffset:CGPointMake(viewSize.size.width*index , 0) animated:YES];
}


#pragma  mark 显示隐藏左右活动按钮
-(void) showLeftHideRightButton
{
    [leftButton setHidden:NO];
    [rightButton setHidden:YES];
}

-(void) showRightHideLeftButton
{
    [leftButton setHidden:YES];
    [rightButton setHidden:NO];
}
-(void) showRightLeftButton
{
    [leftButton setHidden:NO];
    [rightButton setHidden:NO];
}

-(void) hideLeftRightButton
{
    [leftButton setHidden:YES];
    [rightButton setHidden:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(page == 0)
        [self showRightHideLeftButton];
    else
        [self showRightLeftButton];
    if(page == nImageCount-1)
        [self showLeftHideRightButton];
    currentPage = page;
    if ([delegate respondsToSelector:@selector(EScrollerViewDidClicked:)])
    {
        [delegate EScrollerViewDidClicked:page];
    }
}


@end
