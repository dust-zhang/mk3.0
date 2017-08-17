//
//  ExUITextView.m
//  movikr
//
//  Created by Mapollo28 on 15/11/23.
//  Copyright © 2015年 movikr. All rights reserved.
//

#import "ExUITextView.h"

@implementation ExUITextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.myTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.userInteractionEnabled = YES;
        self.btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnDelete.frame = CGRectMake(frame.size.width-15, (frame.size.height-15)/2, 15, 15);
        [self.btnDelete setBackgroundImage:[UIImage imageNamed:@"image_CinemaClear.png"] forState:UIControlStateNormal];
        [self.btnDelete addTarget:self action:@selector(onButtonDelete:) forControlEvents:UIControlEventTouchUpInside];
        if (self.myTextField.text.length>0)
        {
            self.btnDelete.hidden = NO;
        }
        else
        {
            self.btnDelete.hidden = YES;
        }
        [self addSubview:self.myTextField];
        [self addSubview:self.btnDelete];
    }
    return self;
}

-(void)onButtonDelete:(UIButton*)sender
{
    if ([self.tfDelegate respondsToSelector:@selector(showHide:)]) {
        [self.tfDelegate showHide:self];
    }
}

@end
