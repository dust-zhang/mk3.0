//
//  HideTabBarViewController.h
//  supercinema
//
//  Created by dust on 16/10/12.
//
//

#import <UIKit/UIKit.h>

@interface HideTabBarViewController : UIViewController

@property(nonatomic, strong)UIView      *_viewTop;
@property(nonatomic, strong)UILabel     *_labelLine;
@property(nonatomic, strong)UILabel     *_labelTitle;
@property(nonatomic, strong)UIButton    *_btnBack;

-(void) hideBackButton;
-(void) onButtonBack;
-(void) backViewControllor:(NSError *)error index:(int)index;


@end
