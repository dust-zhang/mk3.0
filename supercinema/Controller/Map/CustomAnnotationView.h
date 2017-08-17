//
//  CustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>


@protocol  navigationDelegate<NSObject>
-(void)onButtonNavigation;
@end


@interface CustomAnnotationView : MAAnnotationView
@property (nonatomic, strong) UIImage *portrait;
@property (nonatomic, strong) UIView *calloutView;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *labelAddress;
@property(nonatomic,assign) id <navigationDelegate> _navigationDelegate;

-(void) setText:(CinemaModel *)model;

@end

