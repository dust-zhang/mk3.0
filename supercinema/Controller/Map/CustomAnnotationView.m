//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"


@interface CustomAnnotationView ()
@end

@implementation CustomAnnotationView


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH-80, (27+28+20+20+27)/2+15);
        self.backgroundColor = RGBA(0, 0, 0, 0);
        
        UILabel *labelBg = [[UILabel alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-80, (27+28+20+20+27)/2)];
        labelBg.backgroundColor = RGBA(0, 0, 0, 0.8);
        [labelBg.layer setMasksToBounds:YES];
        [labelBg.layer setCornerRadius:4];
        [self addSubview:labelBg];
        
        //影院名称
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 27/2,SCREEN_WIDTH-170,14)];
        self.nameLabel.backgroundColor  = [UIColor clearColor];
        self.nameLabel.textAlignment    = NSTextAlignmentLeft;
        self.nameLabel.textColor        = [UIColor whiteColor];
        self.nameLabel.font             = MKFONT(14);
        [labelBg addSubview:self.nameLabel];
        //影院地址
        self.labelAddress= [[UILabel alloc] initWithFrame:CGRectMake(5, self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+10,SCREEN_WIDTH-170,10)];
        self.labelAddress.backgroundColor  = [UIColor clearColor];
        self.labelAddress.textAlignment    = NSTextAlignmentLeft;
        self.labelAddress.textColor        = [UIColor whiteColor];
        self.labelAddress.font             = MKFONT(10);
        [labelBg addSubview:self.labelAddress];
        
        //圆点
        UIImageView *imageLocation= [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-(92/4),self.frame.size.height-10 ,92/2,92/2)];
        [imageLocation setImage:[UIImage imageNamed:@"image_currentLocation.png"]];
        [self addSubview:imageLocation];
        
        UIButton *btnNav = [[UIButton alloc ] initWithFrame:CGRectMake(self.frame.size.width-70-11, 15, 70, 30)];
        [btnNav setTitle:@"      导航" forState:UIControlStateNormal];
        [btnNav setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnNav.titleLabel.font = MKFONT(14);
        btnNav.backgroundColor = RGBA(117, 112, 255, 1);
        btnNav.layer.masksToBounds = YES;
        btnNav.layer.cornerRadius = 4;
        [btnNav addTarget:self action:@selector(onButtonNav) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnNav];
        
        UIImageView *imageNav= [[UIImageView alloc] initWithFrame:CGRectMake(10,5 ,31/2,38/2)];
        [imageNav setImage:[UIImage imageNamed:@"btn_Navigation.png"]];
        [btnNav addSubview:imageNav];
        
    }
    
    return self;
}

-(void)onButtonNav
{
    if ([self._navigationDelegate respondsToSelector:@selector(onButtonNavigation)])
    {
        [self._navigationDelegate onButtonNavigation];
    }
}

-(void) setText:(CinemaModel *)model
{
    [self.nameLabel setText:model.cinemaName];
    [self.labelAddress setText:model.address];
}
@end
