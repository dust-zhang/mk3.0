//
//  MiniSeatsView.h
//

#import <UIKit/UIKit.h>

@interface MiniMeIndicator : UIView

@end

@interface MiniSeatsView : UIView

- (id)initWithUIScrollView:(UIScrollView *)scrollView seatsView:(UIView*)seatsView frame:(CGRect)frame;

//重新截取缩略图
-(void)reCaptureScreenAndUpateView;

/******************* ScrollView 滚动时候触发以下方法 *********************/
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewDidZoom:(UIScrollView *)scrollView;

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;

@end
