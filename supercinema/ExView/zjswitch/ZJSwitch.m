/*
 * Copyright (c) 2014, James <jameszjhe@gmail.com> All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of James nor the names of its contributors may
 *       be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY JAMES "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL JAMES AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ZJSwitch.h"


#define ZJSwitchMinWidth 51.0f

#define ZJSwitchKnobSize ZJSwitchMaxHeight

@interface ZJSwitch ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *onContentView;
@property (nonatomic, strong) UIView *offContentView;
@property (nonatomic, strong) UIView *knobView;
@property (nonatomic, strong) UILabel *onLabel;
@property (nonatomic, strong) UILabel *offLabel;
@property (nonatomic, strong) UIView *borderView;

- (void)commonInit;

- (CGRect)roundRect:(CGRect)frameOrBounds;

- (void)handleTapTapGestureRecognizerEvent:(UITapGestureRecognizer *)recognizer;

- (void)handlePanGestureRecognizerEvent:(UIPanGestureRecognizer *)recognizer;

- (void)scaleKnodViewFrame:(BOOL)scale;

@end

@implementation ZJSwitch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[self roundRect:frame]];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:[self roundRect:bounds]];
    
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:[self roundRect:frame]];
    
    [self setNeedsLayout];
}

- (void)setOnText:(NSString *)onText
{
    if (_onText != onText) {
        _onText = onText;
        
        _onLabel.text = onText;
    }
}

- (void)setOffText:(NSString *)offText
{
    if (_offText != offText) {
        _offText = offText;
        
        _offLabel.text = offText;
    }
}

- (void)setOnTintColor:(UIColor *)onTintColor
{
    if (_onTintColor != onTintColor) {
        _onTintColor = onTintColor;
        
        _onContentView.backgroundColor = onTintColor;
        _borderView.backgroundColor = onTintColor;
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    if (_tintColor != tintColor) {
        _tintColor = tintColor;
        
        _borderView.backgroundColor = tintColor;
        _offContentView.backgroundColor = tintColor;
    }
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    if (_thumbTintColor != thumbTintColor) {
        _thumbTintColor = thumbTintColor;
        
        _knobView.backgroundColor = thumbTintColor;
    }
}

- (void)setOnTextColor:(UIColor *)onTextColor
{
    if (_onTextColor != onTextColor) {
        _onTextColor = onTextColor;
        
        _onLabel.textColor = onTextColor;
    }
}

- (void)setOffTextColor:(UIColor *)offTextColor
{
    if (_offTextColor != offTextColor) {
        _offTextColor = offTextColor;
        
        _offLabel.textColor = _offTextColor;
    }
}

- (void)setOnBorderColor:(UIColor *)borderColor
{
    if (_onBorderColor != borderColor) {
        _onBorderColor = borderColor;
        
        _borderView.layer.borderColor = borderColor.CGColor;
        _knobView.layer.borderColor = borderColor.CGColor;
        _offContentView.layer.borderColor = borderColor.CGColor;
        _onContentView.layer.borderColor = borderColor.CGColor;
    }
}

- (void)setOffBorderColor:(UIColor *)borderColor
{
    if (_offBorderColor != borderColor) {
        _offBorderColor = borderColor;
        
        _borderView.layer.borderColor = borderColor.CGColor;
        _knobView.layer.borderColor = borderColor.CGColor;
        _offContentView.layer.borderColor = borderColor.CGColor;
        _onContentView.layer.borderColor = borderColor.CGColor;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.containerView.frame = self.bounds;
    
    CGFloat r = CGRectGetHeight(self.containerView.bounds) / 2.0;
    
    self.containerView.layer.cornerRadius = r;
    self.containerView.layer.masksToBounds = YES;
    
    CGFloat margin = 0;
    
    self.borderView.frame = self.bounds;
    self.borderView.layer.borderWidth = 1.0;
    self.borderView.layer.cornerRadius = r;
    self.borderView.layer.masksToBounds = YES;
    
    if (!self.isOn) {
        // frame of off status
        self.onContentView.frame = CGRectMake(-1 * CGRectGetWidth(self.containerView.bounds),
                                              0,
                                              CGRectGetWidth(self.containerView.bounds),
                                              CGRectGetHeight(self.containerView.bounds));
        
        self.offContentView.frame = CGRectMake(0,
                                               0,
                                               CGRectGetWidth(self.containerView.bounds),
                                               CGRectGetHeight(self.containerView.bounds));
        
        self.knobView.frame = CGRectMake(margin,
                                         margin,
                                         self.bounds.size.height,
                                         self.bounds.size.height);
    } else {
        // frame of on status
        self.onContentView.frame = CGRectMake(0,
                                              0,
                                              CGRectGetWidth(self.containerView.bounds),
                                              CGRectGetHeight(self.containerView.bounds));
        
        self.offContentView.frame = CGRectMake(CGRectGetWidth(self.containerView.bounds),
                                               0,
                                               CGRectGetWidth(self.containerView.bounds),
                                               CGRectGetHeight(self.containerView.bounds));
        
        self.knobView.frame = CGRectMake(margin,
                                         margin,
                                         self.bounds.size.height,
                                         self.bounds.size.height);
    }
    
    CGFloat lHeight = 20.0f;
    CGFloat lMargin = r - (sqrtf(powf(r, 2) - powf(lHeight / 2.0, 2))) + margin;
    
    self.onLabel.frame = CGRectMake(lMargin,
                                    r - lHeight / 2.0,
                                    CGRectGetWidth(self.onContentView.bounds) - lMargin - self.bounds.size.height - 2 * margin,
                                    lHeight);
    
    self.offLabel.frame = CGRectMake(self.bounds.size.height + 2 * margin,
                                     r - lHeight / 2.0,
                                     CGRectGetWidth(self.onContentView.bounds) - lMargin - self.bounds.size.height - 2 * margin,
                                     lHeight);
}

- (void)setOn:(BOOL)on
{
    [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    if (_on == on) {
        return;
    }
    
    _on = on;
    
    CGFloat margin = (CGRectGetHeight(self.bounds) - self.bounds.size.height) / 2.0;
    
    CGRect onFrame = self.onContentView.frame;
    CGRect offFrame = self.offContentView.frame;
    CGRect knobFrame = self.knobView.frame;
    
    if (!self.isOn) {
        // frame of off status
        self.onContentView.frame = CGRectMake(-1 * CGRectGetWidth(self.containerView.bounds),
                                              0,
                                              CGRectGetWidth(self.containerView.bounds),
                                              CGRectGetHeight(self.containerView.bounds));
        
        self.offContentView.frame = CGRectMake(0,
                                               0,
                                               CGRectGetWidth(self.containerView.bounds),
                                               CGRectGetHeight(self.containerView.bounds));
        
        self.knobView.frame = CGRectMake(margin,
                                         margin,
                                         self.bounds.size.height,
                                         self.bounds.size.height);
        
        //self.borderView.layer.borderColor = _tintColor.CGColor;
        //self.knobView.backgroundColor = _tintColor;
        
        self.offContentView.layer.borderColor = _offBorderColor.CGColor;
        self.knobView.layer.borderColor = _offBorderColor.CGColor;
        self.offContentView.backgroundColor = _tintColor;
        
        self.knobView.layer.shadowColor = [UIColor clearColor].CGColor;
        self.layer.shadowColor = [UIColor clearColor].CGColor;
        
    } else {
        // frame of on status
        self.onContentView.frame = CGRectMake(0,
                                              0,
                                              CGRectGetWidth(self.containerView.bounds),
                                              CGRectGetHeight(self.containerView.bounds));
        
        self.offContentView.frame = CGRectMake(CGRectGetWidth(self.containerView.bounds),
                                               0,
                                               CGRectGetWidth(self.containerView.bounds),
                                               CGRectGetHeight(self.containerView.bounds));
        
        self.knobView.frame = CGRectMake(CGRectGetWidth(self.containerView.bounds) - margin - self.bounds.size.height,
                                         margin,
                                         self.bounds.size.height,
                                         self.bounds.size.height);
        
        self.onContentView.layer.borderColor = _onBorderColor.CGColor;
        self.knobView.layer.borderColor = _onBorderColor.CGColor;
        self.onContentView.backgroundColor = _onTintColor;
        
        self.layer.shadowOffset = CGSizeMake(5, 2);  // 设置阴影的偏移量
        self.layer.shadowRadius = 5.0;  // 设置阴影的半径
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
        self.layer.shadowOpacity = 0.36; // 设置阴影的不透明度
        
        self.knobView.layer.shadowRadius = 5.0;  // 设置阴影的半径
        self.knobView.layer.masksToBounds = NO;
        self.knobView.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
        self.knobView.layer.shadowOpacity = 0.36; // 设置阴影的不透明度
    }
    
    if (animated) {
        // on
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"bounds"];
        [animation1 setFromValue:[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(onFrame), CGRectGetHeight(onFrame))]];
        [animation1 setToValue:[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.onContentView.frame), CGRectGetHeight(self.onContentView.frame))]];
        [animation1 setDuration:0.3];
        [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.onContentView.layer addAnimation:animation1 forKey:NULL];
        
        CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation2 setFromValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(onFrame), CGRectGetMidY(onFrame))]];
        [animation2 setToValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.onContentView.frame), CGRectGetMidY(self.onContentView.frame))]];
        [animation2 setDuration:0.3];
        [animation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.onContentView.layer addAnimation:animation2 forKey:NULL];
        
        // off
        CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"bounds"];
        [animation3 setFromValue:[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(offFrame), CGRectGetHeight(offFrame))]];
        [animation3 setToValue:[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.offContentView.frame), CGRectGetHeight(self.offContentView.frame))]];
        [animation3 setDuration:0.3];
        [animation3 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.offContentView.layer addAnimation:animation3 forKey:NULL];
        
        CABasicAnimation *animation4 = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation4 setFromValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(offFrame), CGRectGetMidY(offFrame))]];
        [animation4 setToValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.offContentView.frame), CGRectGetMidY(self.offContentView.frame))]];
        [animation4 setDuration:0.3];
        [animation4 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.offContentView.layer addAnimation:animation4 forKey:NULL];
        
        // knob
        CABasicAnimation *animation5 = [CABasicAnimation animationWithKeyPath:@"bounds"];
        [animation5 setFromValue:[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(knobFrame), CGRectGetHeight(knobFrame))]];
        [animation5 setToValue:[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.knobView.frame), CGRectGetHeight(self.knobView.frame))]];
        [animation5 setDuration:0.3];
        [animation5 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.knobView.layer addAnimation:animation5 forKey:NULL];
        
        CABasicAnimation *animation6 = [CABasicAnimation animationWithKeyPath:@"position"];
        [animation6 setFromValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(knobFrame), CGRectGetMidY(knobFrame))]];
        [animation6 setToValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.knobView.frame), CGRectGetMidY(self.knobView.frame))]];
        [animation6 setDuration:0.3];
        [animation6 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.knobView.layer addAnimation:animation6 forKey:NULL];
    }
}

#pragma mark - Private API

- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    
    _onTintColor = [UIColor colorWithRed:130 / 255.0 green:200 / 255.0 blue:90 / 255.0 alpha:1.0];
    _tintColor = [UIColor colorWithWhite:0.75 alpha:1.0];
    _thumbTintColor = [UIColor clearColor];
    
    _textFont = [UIFont systemFontOfSize:10.0f];
    _onTextColor = [UIColor whiteColor];
    _offTextColor = _onTextColor;
    
    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    _containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:_containerView];
    
    _borderView = [[UIView alloc] initWithFrame:CGRectZero];
    _borderView.userInteractionEnabled = NO;
    _borderView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.2];
    _borderView.hidden = NO;
    [_containerView addSubview:_borderView];
    
    _onContentView = [[UIView alloc] initWithFrame:self.bounds];
    _onContentView.backgroundColor = [UIColor clearColor];
    _onContentView.layer.masksToBounds = NO;
    _onContentView.layer.borderWidth = 0.5;
    [_containerView addSubview:_onContentView];
    
    _offContentView = [[UIView alloc] initWithFrame:self.bounds];
    _offContentView.backgroundColor = [UIColor clearColor];
    _offContentView.layer.masksToBounds = NO;
    _offContentView.layer.borderWidth = 0.5;
    [_containerView addSubview:_offContentView];
    
    _onLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _onLabel.backgroundColor = [UIColor clearColor];
    _onLabel.textAlignment = NSTextAlignmentCenter;
    _onLabel.textColor = _onTextColor;
    _onLabel.font = _textFont;
    _onLabel.text = _onText;
    [_onContentView addSubview:_onLabel];
    
    _offLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _offLabel.backgroundColor = [UIColor clearColor];
    _offLabel.textAlignment = NSTextAlignmentCenter;
    _offLabel.textColor = _offTextColor;
    _offLabel.font = _textFont;
    _offLabel.text = _offText;
    [_offContentView addSubview:_offLabel];
    
    _knobView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _knobView.backgroundColor = [UIColor clearColor];
    _knobView.layer.cornerRadius = self.bounds.size.height / 2.0;
    _knobView.layer.borderWidth = 0.5;
    [_containerView addSubview:_knobView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTapTapGestureRecognizerEvent:)];
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePanGestureRecognizerEvent:)];
    [self addGestureRecognizer:panGesture];
}

- (CGRect)roundRect:(CGRect)frameOrBounds
{
    CGRect newRect = frameOrBounds;
    //
    //    if (newRect.size.height > ZJSwitchMaxHeight) {
    //        newRect.size.height = ZJSwitchMaxHeight;
    //    }
    //
    //    if (newRect.size.height < ZJSwitchMinHeight) {
    //        newRect.size.height = ZJSwitchMinHeight;
    //    }
    //
    //    if (newRect.size.width < ZJSwitchMinWidth) {
    //        newRect.size.width = ZJSwitchMinWidth;
    //    }
    
    return newRect;
}

- (void)handleTapTapGestureRecognizerEvent:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self setOn:!self.isOn animated:YES];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)handlePanGestureRecognizerEvent:(UIPanGestureRecognizer *)recognizer
{
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            [self scaleKnodViewFrame:YES];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            [self scaleKnodViewFrame:NO];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            break;
        }
        case UIGestureRecognizerStateEnded:
            [self setOn:!self.isOn animated:YES];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            break;
        case UIGestureRecognizerStatePossible:
            break;
    }
}

- (void)scaleKnodViewFrame:(BOOL)scale
{
    CGFloat margin = (CGRectGetHeight(self.bounds) - self.bounds.size.height) / 2.0;
    CGFloat offset = 6.0f;
    
    CGRect preFrame = self.knobView.frame;
    
    if (self.isOn) {
        self.knobView.frame = CGRectMake(CGRectGetWidth(self.containerView.bounds) - self.bounds.size.height - margin - (scale ? offset : 0),
                                         margin,
                                         self.bounds.size.height + (scale ? offset : 0),
                                         self.bounds.size.height);
    } else {
        self.knobView.frame = CGRectMake(margin,
                                         margin,
                                         self.bounds.size.height + (scale ? offset : 0),
                                         self.bounds.size.height);
    }
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"bounds"];
    [animation1 setFromValue:[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(preFrame), CGRectGetHeight(preFrame))]];
    [animation1 setToValue:[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(self.knobView.frame), CGRectGetHeight(self.knobView.frame))]];
    [animation1 setDuration:0.3];
    [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.knobView.layer addAnimation:animation1 forKey:NULL];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation2 setFromValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(preFrame), CGRectGetMidY(preFrame))]];
    [animation2 setToValue:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.knobView.frame), CGRectGetMidY(self.knobView.frame))]];
    [animation2 setDuration:0.3];
    [animation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.knobView.layer addAnimation:animation2 forKey:NULL];
}

@end
