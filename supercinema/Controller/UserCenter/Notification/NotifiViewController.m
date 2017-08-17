//
//  NotifiViewController.m
//  supercinema
//
//  Created by Mapollo28 on 2016/12/1.
//
//

#import "NotifiViewController.h"

@interface NotifiViewController ()

@end

@implementation NotifiViewController

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _viewSociety.isFirst = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_viewSociety loadData];
    if (!_viewSociety.isFirst)
    {
        [_viewSociety setPointsHidden];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self._labelTitle.text = @"通知";
    self.view.backgroundColor = [UIColor whiteColor];
    self._labelLine.hidden = YES;
    [self initControl];
}

-(void)initControl
{
    NSArray* arrTitle = @[@"社交通知",@"系统通知"];
    UISegmentedControl* control = [[UISegmentedControl alloc]initWithItems:arrTitle];
    control.frame = CGRectMake((SCREEN_WIDTH-230)/2, self._labelTitle.frame.origin.y+self._labelTitle.frame.size.height+25, 230, 30);
    [control addTarget:self action:@selector(myAction:) forControlEvents:UIControlEventValueChanged];
    control.layer.masksToBounds = YES;
    control.layer.cornerRadius = control.frame.size.height/2;
    control.layer.borderColor = [RGBA(117, 112, 255, 1) CGColor];
    control.layer.borderWidth = 1;
    [control setSelectedSegmentIndex:0];
    control.tintColor = RGBA(117, 112, 255, 1);
    NSDictionary *dicDefault = [NSDictionary dictionaryWithObjectsAndKeys:RGBA(123, 122, 152, 1),
                                 NSForegroundColorAttributeName,
                                 MKFONT(14),
                                 NSFontAttributeName,nil];
    [control setTitleTextAttributes:dicDefault forState:UIControlStateNormal];
    NSDictionary *dicSelected = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                         NSForegroundColorAttributeName,
                         MKFONT(14),
                         NSFontAttributeName,nil];
    [control setTitleTextAttributes:dicSelected forState:UIControlStateSelected];
    [self.view addSubview:control];
    
    if ([_sModel.unReadCount intValue]>0)
    {
        _labelSCount = [[UILabel alloc]initWithFrame:CGRectMake(control.frame.origin.x+control.frame.size.width/2-5-20, control.frame.origin.y-10, 20, 20)];
        _labelSCount.layer.borderWidth = 1;
        _labelSCount.layer.borderColor = [[UIColor whiteColor] CGColor];
        _labelSCount.layer.masksToBounds = YES;
        _labelSCount.layer.cornerRadius = 10;
        _labelSCount.backgroundColor = [UIColor redColor];
        _labelSCount.text = [_sModel.unReadCount stringValue];
        _labelSCount.textAlignment = NSTextAlignmentCenter;
        _labelSCount.textColor = [UIColor whiteColor];
        _labelSCount.font = MKFONT(14);
        [self.view addSubview:_labelSCount];
    }
    
    _viewSociety = [[SocietyTableView alloc]initWithFrame:CGRectMake(0, control.frame.origin.y+control.frame.size.height+10, SCREEN_WIDTH, SCREEN_HEIGHT-control.frame.origin.y-control.frame.size.height-10) navigation:self.navigationController];
    _viewSociety.backgroundColor = RGBA(246, 246, 251, 1);
    _viewSociety.isFirst = YES;
    [self.view addSubview:_viewSociety];
    
    _viewNoti = [[UIScrollView alloc]initWithFrame:CGRectMake(0, control.frame.origin.y+control.frame.size.height+10, SCREEN_WIDTH, SCREEN_HEIGHT-control.frame.origin.y-control.frame.size.height-10)];
    _viewNoti.backgroundColor = RGBA(246, 246, 251, 1);
    [self.view addSubview:_viewNoti];
    [self loadFailed];
    
    _viewSociety.hidden = NO;
    _viewNoti.hidden = YES;
}

#pragma mark 加载失败 显示UI
-(void) loadFailed
{
    UIImageView* imgDefault = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-110/2)/2, 165/2, 110/2, 175/2)];
    imgDefault.image = [UIImage imageNamed:@"image_NoDataNotice.png"];
    [_viewNoti addSubview:imgDefault];
    
    UILabel* labelDefault = [[UILabel alloc]initWithFrame:CGRectMake(0, imgDefault.frame.origin.y+imgDefault.frame.size.height+15, SCREEN_WIDTH, 14)];
    labelDefault.text = @"系统居然什么都没通知!";
    [labelDefault setTextColor:RGBA(123, 122, 152, 1)];
    [labelDefault setTextAlignment:NSTextAlignmentCenter];
    [labelDefault setFont:MKFONT(14)];
    [_viewNoti addSubview:labelDefault];
}


-(void)myAction:(UISegmentedControl *)Seg
{
    if (Seg.selectedSegmentIndex == 0)
    {
        [MobClick event:myCenterViewbtn56];
        _viewSociety.hidden = NO;
        _viewNoti.hidden = YES;
    }
    else
    {
        [MobClick event:myCenterViewbtn61];
        _viewSociety.hidden = YES;
        [_labelSCount removeFromSuperview];
        _viewNoti.hidden = NO;
        [_viewSociety setPointsHidden];
    }
}

-(void)onButtonBack
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITION_USERCENTERSOCIALCOUNT object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
