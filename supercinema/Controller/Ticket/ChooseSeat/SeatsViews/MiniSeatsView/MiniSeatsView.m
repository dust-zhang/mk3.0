//
//  MiniSeatsView.m
//

#import "MiniSeatsView.h"

@implementation MiniMeIndicator
- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置颜色，仅填充4条边
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 2.0);//线的宽度
    
    CGContextStrokeRect(context,CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));//画方框
}

- (void)dealloc
{
    
}

@end

@implementation MiniSeatsView
{
    //传入得座位图ScrollView
    UIScrollView *_scrollView;
    //记录Scrollview得初始zoomScale
    float _baselineZoomscale;
    //缩略图View缩放比例
    float _ratio;
    UIView *_seatsView;
    UIImageView *_miniSeatsImageView;
    MiniMeIndicator *_miniMeIndicator;
}

- (id)initWithUIScrollView:(UIScrollView *)scrollView seatsView:(UIView*)seatsView frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _seatsView = seatsView;
        //设置缩略图View尺寸
        [self setFrame:frame];
        
        [self setScaling:_seatsView];
        self.clipsToBounds = YES;
        _baselineZoomscale = _scrollView.zoomScale;
        _miniSeatsImageView = [[UIImageView alloc]initWithImage:[self captureScreen:_seatsView]];
        _miniSeatsImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_miniSeatsImageView];
        
        
        float deltaZoomScale = _scrollView.zoomScale / _baselineZoomscale;
        _miniMeIndicator = [[MiniMeIndicator alloc]initWithFrame:CGRectMake(
                                                                   _scrollView.contentOffset.x/_ratio/deltaZoomScale,
                                                                   (_scrollView.contentOffset.y)/_ratio/deltaZoomScale,
                                                                   self.frame.size.width/deltaZoomScale,
                                                                   self.frame.size.height/deltaZoomScale)];
        _miniMeIndicator.backgroundColor = [UIColor clearColor];
        [self addSubview:_miniMeIndicator];
    }
    return self;
}

-(void)reCaptureScreenAndUpateView
{
    UIImage* screenImage = [self captureScreen:_seatsView];
    _miniSeatsImageView.image = screenImage;
}

//设置缩略图缩放比例
- (void)setScaling:(UIView *)seatsView
{
    _ratio = seatsView.frame.size.width / self.frame.size.width;
}

-(UIImage*)captureScreen:(UIView*) viewToCapture
{
    CGRect rect = [viewToCapture bounds];
//    rect.size.height -= 70;
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,0.0f);
    [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - UIScrollViewDelegate related methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDragging");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self refreshMiniMeIndicator];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   // NSLog(@"scrollViewDidEndDragging");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
   // NSLog(@"scrollViewWillBeginDecelerating");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // NSLog(@"scrollViewDidEndDecelerating");
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // NSLog(@"scrollViewDidZoom");
    [self refreshMiniMeIndicator];
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    //NSLog(@"scrollViewDidEndZooming");
    [self refreshMiniMeIndicator];
}

-(void)refreshMiniMeIndicator
{
    float deltaZoomScale = _scrollView.zoomScale / _baselineZoomscale;
    CGFloat indicatorWidth = _scrollView.frame.size.width/_ratio/deltaZoomScale;
    CGFloat indicatorHeight = _scrollView.frame.size.height/_ratio/deltaZoomScale;
    //边界处理
    if(indicatorWidth >= self.frame.size.width)
    {
        indicatorWidth = self.frame.size.width;
    }
    if(indicatorHeight >= self.frame.size.height)
    {
        indicatorHeight = self.frame.size.height;
    }
    _miniMeIndicator.frame =
    CGRectMake(_scrollView.contentOffset.x/_ratio/deltaZoomScale,
               _scrollView.contentOffset.y/_ratio/deltaZoomScale,
               indicatorWidth,
               indicatorHeight);
    [_miniMeIndicator setNeedsDisplay];
}
@end
