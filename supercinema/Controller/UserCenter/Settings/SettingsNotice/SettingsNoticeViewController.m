//
//  SettingsNoticeViewController.m
//  supercinema
//
//  Created by mapollo91 on 9/12/16.
//
//

#import "SettingsNoticeViewController.h"
#import "ZJSwitch.h"

@interface SettingsNoticeViewController ()

@end

@implementation SettingsNoticeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(246, 246, 251, 1);
    
    [self initController];
}

-(void)initController
{
    //顶部View标题
    [self._labelTitle setText:@"通知设置"];

    //提示语
    UILabel *labelPrompt = [[UILabel alloc] initWithFrame:CGRectMake(15, 64+30, SCREEN_WIDTH-15*2, 12)];
    [labelPrompt setBackgroundColor:[UIColor clearColor]];
    [labelPrompt setTextColor:RGBA(123, 122, 152, 1)];
    [labelPrompt setTextAlignment:NSTextAlignmentLeft];
    [labelPrompt setFont:MKFONT(12)];
    [labelPrompt setText:@"打开通知，向好友发送你的消息状态"];
    [self.view addSubview:labelPrompt];
    
    //白色背景
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, labelPrompt.frame.origin.y+labelPrompt.frame.size.height+10, SCREEN_WIDTH, 226)];
    [viewBG setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewBG];
    
    NSArray *arrLabelName = @[@"为短评点赞",@"添加关注的人",@"添加看过的影片",@"添加想看的影片",@"参与线上活动"];
    for (int i = 0; i < arrLabelName.count; i++)
    {
        //功能说明
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(15, 15+45*i, SCREEN_WIDTH, 15)];
        [labelName setBackgroundColor:[UIColor clearColor]];
        [labelName setTextColor:RGBA(51, 51, 51, 1)];
        [labelName setTextAlignment:NSTextAlignmentLeft];
        [labelName setFont:MKFONT(15)];
        [labelName setText:arrLabelName[i]];
        [viewBG addSubview:labelName];
        
        //功能按钮
//        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30-42, 8+45*i, 42, 24)];
//        //switchButton.backgroundColor = [UIColor redColor];
//        //切换后颜色
//        switchButton.onTintColor = RGBA(117, 112, 255, 1);
//        //边框颜色
//        switchButton.tintColor = RGBA(239, 239, 244, 1);
//        //按钮颜色
//        //switchButton.thumbTintColor = [UIColor grayColor];
//        [switchButton setOn:NO animated:YES];
//        [switchButton addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
//        [viewBG addSubview:switchButton];
        
        ZJSwitch *switch0 = [[ZJSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30-42, 8+45*i, 42, 24)];
        switch0.onBorderColor = RGBA(117, 112, 255, 1);
        switch0.offBorderColor =  RGBA(239, 239, 244, 1);
        //打开颜色
        switch0.onTintColor =  RGBA(117, 112, 255, 1);
        //默认颜色
        switch0.tintColor = RGBA(239, 239, 244, 1);
        //开关颜色
        switch0.thumbTintColor = [UIColor whiteColor];
        [switch0 addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        [viewBG addSubview:switch0];


        
        //分割线
        UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(15, 45+45*i, SCREEN_WIDTH-15, 0.5)];
        [labelLine setBackgroundColor:RGBA(0, 0, 0, 0.05)];
        [viewBG addSubview:labelLine];
    }

    //确认修改按钮
    UIButton *btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(15, viewBG.frame.origin.y+viewBG.frame.size.height+30, SCREEN_WIDTH-15*2, 40)];
    [btnConfirm setBackgroundColor:RGBA(0, 0, 0, 1)];
    [btnConfirm setTitle:@"确认修改" forState:UIControlStateNormal];
    [btnConfirm setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    [btnConfirm.titleLabel setFont:MKFONT(15)];//按钮字体大小
    [btnConfirm.layer setCornerRadius:20.f];//按钮设置圆角
    [btnConfirm addTarget:self action:@selector(onButtonConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnConfirm];
}

-(void)switchChange:(id)sender
{
    UISwitch *mySwitch = (UISwitch *)sender;
    if (mySwitch.isOn)
    {
        NSLog(@"开关开启");
    }
    else
    {
        NSLog(@"开关关闭");
    }
}

//确认修改
-(void)onButtonConfirm
{
    NSLog(@"点击确认修改");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
