//
//  ShowTabBarViewController.m
//  supercinema
//
//  Created by dust on 16/10/12.
//
//

#import "ShowTabBarViewController.h"

@interface ShowTabBarViewController ()

@end

@implementation ShowTabBarViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Tool showTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
