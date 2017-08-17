//
//  PhotoBrowser.m
//  movikr
//
//  Created by mapollo91 on 10/3/16.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import "PhotoBrowser.h"
#import "ViewPostion.h"
#import "JKUtil.h"

@interface PhotoBrowser()

@property (nonatomic, strong) UIView   *topView;
@property (nonatomic, strong) UIView   *bottmView;

@end

@implementation PhotoBrowser

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [JKUtil getColor:@"282828"];
        self.autoresizesSubviews = YES;
//        [self collectionView];
        [self initControl];
        [self createTopView];
    }
    return self;
}

-(void)initControl
{
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self setBackgroundColor:[UIColor blackColor]];
    [self addSubview:imageView];
}

- (void )createTopView
{
    //顶部View
    UIView  *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    viewTop.backgroundColor = RGBA(255, 255, 255, 1);
    [self addSubview:viewTop];
    
    //描边
    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5)];
    labelLine.backgroundColor = RGBA(0, 0, 0, 0.05);
    [viewTop addSubview:labelLine];
    
    //返回按钮
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 23, 94/2, 30);
    [btnBack setBackgroundImage:[UIImage imageNamed:@"btn_closeBlack.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(onButtonBack) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:btnBack];
    
    //删除按钮
    UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.frame = CGRectMake(SCREEN_WIDTH-15-21, 27, 21, 21.5);
    [btnDelete setBackgroundColor:[UIColor clearColor]];
    [btnDelete setBackgroundImage:[UIImage imageNamed:@"btn_orderDelete.png"] forState:UIControlStateNormal];
    [btnDelete addTarget:self action:@selector(onButtonDelete) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:btnDelete];
}

- (void)show:(BOOL)animated
{
    if (animated)
    {
        imageView.image = self._image;
        
        //图片自适应宽高
//        [imageView setContentMode:UIViewContentModeCenter];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        

//        float width = [self._arrImageSize[0] floatValue];
//        float height = [self._arrImageSize[1] floatValue];
//        imageView.frame = CGRectMake(0, 64+(SCREEN_HEIGHT-64-70 - height)/2, width, height);
        
        self.hidden=YES;
        self.alpha=0;
        self.transform = CGAffineTransformMakeScale(0.3, 0.3);
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(1, 1);
                             self.hidden=NO;
                             self.alpha=1;
                         }completion:^(BOOL finish){
                             
                         }];
    }
    else
    {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

//删除图片
-(void)onButtonDelete
{
    NSLog(@"点击了删除按钮");
    
    if ([self.photoBrowserDelegate respondsToSelector:@selector(deleteImage:)])
    {
        [self.photoBrowserDelegate deleteImage:self._selectedCount];
    }
    [self hide];
}

//返回按钮
- (void)onButtonBack
{
    [self hide];
}

- (void)hide
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(0.3, 0.3);
                         self.hidden=NO;
                         self.alpha=0;
                     }completion:^(BOOL finish){
                         self.hidden = YES;
                         [self removeFromSuperview];
                     }];
}

@end
