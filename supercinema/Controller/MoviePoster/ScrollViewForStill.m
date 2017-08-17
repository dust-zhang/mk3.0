//
//  ScrollViewForStill.m
//  animition
//
//  Created by dust on 2017/3/27.
//  Copyright © 2017年 dust. All rights reserved.
//

#import "ScrollViewForStill.h"

@implementation ScrollViewForStill

- (id)initWithFrame:(CGRect)frame arrStill:(NSMutableArray *)arr
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setUserInteractionEnabled:YES];
        _arrStill = [[NSMutableArray alloc ] initWithArray:arr];
        _arrAllStill = [[NSMutableArray alloc ] initWithCapacity:0];
        
        for (int i = 0 ; i < [arr count] ; i++)
        {
            StillModel* model = arr[i];
            browseItem = [[MSSBrowseModel alloc ] init];
            browseItem.bigImageUrl =model.urlOfBig;
            [_arrAllStill addObject:browseItem];
        }
        
        [self setBackgroundColor:[UIColor greenColor]];
        [self initStillController:arr];
    }
    
    return self;
}

-(void) initStillController:(NSMutableArray *)arr
{
    [_arrStill removeAllObjects];
    NSInteger count = 20;
    if (arr.count<20)
    {
        count = arr.count;
    }
    for (int i = 0 ; i < count ; i++)
    {
        UIButton *btnStill = [[UIButton alloc ] initWithFrame:CGRectMake(18+110*i, 0, 100, 100)];
        StillModel* model = arr[i];
        [Tool downloadImage:model.url button:btnStill imageView:nil defaultImage:@"poster_loading.png"];
        btnStill.tag = i;
        [btnStill addTarget:self action:@selector(onButtonOpenStill:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnStill];
        //最后一张盖透明图“更多”
        if([arr count] >20)
        {
            if(i ==19)
            {
                UILabel *labelMore = [[UILabel alloc ] initWithFrame:btnStill.frame];
                [labelMore setBackgroundColor:RGBA(0, 0, 0, 0.5)];
                [labelMore setTextAlignment:NSTextAlignmentCenter];
                [labelMore setText:@"更多..."];
                [labelMore setTextColor:RGBA(255, 255, 255, 0.5)];
                [labelMore setFont:MKFONT(12)];
                [self addSubview:labelMore];
            }
        }
        
        //重新将数据添加到数组
        browseItem = [[MSSBrowseModel alloc ] init];
        browseItem.bigImageUrl =model.urlOfBig;
        [_arrStill addObject:browseItem];
    }  
    [self setContentSize:CGSizeMake( (110* count )+19, 100)];
}

-(void)onButtonOpenStill:(UIButton *)btn
{
    if ([self._openStillDelegate respondsToSelector:@selector(OpenStill:ImageIndex:)])
    {
        [self._openStillDelegate OpenStill:_arrAllStill ImageIndex:btn.tag ];
    }
}

@end
