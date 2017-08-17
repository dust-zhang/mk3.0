//
//  LoadFailedView.h
//  supercinema
//
//  Created by dingdingdangdang on 2017/5/16.
//
//

#import <UIKit/UIKit.h>

@interface LoadFailedView : UIView
@property (nonatomic, copy)void(^refreshData)(void);
-(id)initWithFrame:(CGRect)frame;

@end
