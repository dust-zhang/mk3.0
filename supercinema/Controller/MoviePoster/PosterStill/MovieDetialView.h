//
//  MovieDetialView
//  supercinema
//
//  Created by lianyanmin on 17/3/27.
//
//

#import "XHRealTimeBlur.h"

@interface MovieDetialView : UIView
{
    UIView          *_viewCover;
    UIScrollView    *_scrollView;
}
@property (nonatomic, copy)void(^hideDetail)(void);
-(instancetype) initWithFrame:(CGRect)frame model:(MovieModel *)movieModel;

@end
