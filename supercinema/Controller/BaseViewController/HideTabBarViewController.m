//
//  HideTabBarViewController.m
//  supercinema
//
//  Created by dust on 16/10/12.
//
//

#import "HideTabBarViewController.h"

@interface HideTabBarViewController ()

@end

@implementation HideTabBarViewController

- (void)viewDidLoad
{
    //电池条变为黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [Tool hideTabBar];
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBA(246, 246, 250, 1)];
    [self initTopView];
}

-(void)initTopView
{
    //顶部View
    self._viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self._viewTop.backgroundColor = RGBA(255, 255, 255, 1);
    [self.view addSubview:self._viewTop];
    
    //标题
    self._labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(41, 30, SCREEN_WIDTH-41*2, 17)];//23+15;SCREEN_WIDTH-(23+15)*2
    [self._labelTitle setBackgroundColor:[UIColor clearColor]];
    [self._labelTitle setTextColor:RGBA(51, 51, 51,1)];
    [self._labelTitle setTextAlignment:NSTextAlignmentCenter];
    [self._labelTitle setFont:MKFONT(17)];
    [self._labelTitle setUserInteractionEnabled:YES];
    [self._viewTop addSubview:self._labelTitle];
    
    //描边
    self._labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5)];
    [self._labelLine setBackgroundColor:RGBA(0, 0, 0, 0.05)];
    [self._viewTop addSubview:self._labelLine];
    
    //返回按钮
    self._btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 23, 82/2, 30)];
    [self._btnBack setImage:[UIImage imageNamed:@"btn_backBlack.png"] forState:UIControlStateNormal];
    [self._btnBack addTarget:self action:@selector(onButtonBack) forControlEvents:UIControlEventTouchUpInside];
    [self._viewTop addSubview:self._btnBack];
}

//返回按钮
-(void)onButtonBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) hideBackButton
{
    [self._btnBack setHidden:YES];
}


-(void) backViewControllor:(NSError *)error index:(int)index
{
    NSInteger nCode = error.code;
    [Tool showWarningTip:error.domain time:2];
    
    if (nCode == -37)//已支付
    {
//        UserCardViewController* userCard = [[UserCardViewController alloc] init];
//        [self.navigationController pushViewController:userCard animated:YES];
    }
    else if( nCode <= -10 && nCode >= -21)
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -index)] animated:YES];
    }
    else if (nCode == -59 || nCode == -38)//订单已取消、支付超时
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -index)] animated:YES];
    }
    else if (nCode == 8004)//服务繁忙，请重试
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -index)] animated:YES];
    }
    else
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -index)] animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
