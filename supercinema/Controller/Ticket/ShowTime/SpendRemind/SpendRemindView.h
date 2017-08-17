//
//  SpendRemindView.h
//  supercinema
//
//  Created by Mapollo28 on 2017/4/13.
//
//

#import <UIKit/UIKit.h>

@interface SpendRemindView : UIView
{
    UIView          *_viewCover;
    UIScrollView    *_scrollView;
}
@property (nonatomic, copy)void(^hideSpend)(void);
-(instancetype) initWithFrame:(CGRect)frame arrRemind:(NSArray*)arrRemind;
@end
