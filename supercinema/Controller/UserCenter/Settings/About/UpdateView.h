//
//  UpdateViewController.h
//  supercinema
//
//  Created by dust on 16/11/30.
//
//

#import <UIKit/UIKit.h>
#import "HideTabBarViewController.h"

@interface UpdateView :UIView
{
    NSString            *_url;
    int                 _isUpdate;
    UIButton            *_btnCancel;
}

@property (nonatomic ,strong) NSDictionary *_dicVer;
-(instancetype)initWithFrame:(CGRect)frame dic:(NSDictionary *)dic showHideBackBtn:(BOOL)status;

@end
