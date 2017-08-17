//
//  AboutViewController.m
//  supercinema
//
//  Created by mapollo91 on 22/8/16.
//
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBA(246, 246, 251,1);    //设置背景颜色
    
    [self initCtrl];
}

//渲染UI
-(void)initCtrl
{
    //顶部View标题
    [self._labelTitle setText:@"关于"];

    //Logo
    UIImageView *aboutIcon = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, self._viewTop.frame.origin.y+self._viewTop.frame.size.height+60, 60, 60)];
    aboutIcon.backgroundColor = [UIColor clearColor];
    [aboutIcon setImage:[UIImage imageNamed:@"image_about.png"]];
    [self.view addSubview:aboutIcon];
    
    //当前版本
    UILabel *labelCurrentEdition = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-130)/2, aboutIcon.frame.origin.y+aboutIcon.frame.size.height+15, 120, 15)];
    [labelCurrentEdition setBackgroundColor:[UIColor clearColor]];
    [labelCurrentEdition setTextColor:RGBA(51, 51, 51,1)];
    [labelCurrentEdition setTextAlignment:NSTextAlignmentCenter]; //文字居中对齐
    [labelCurrentEdition setFont:MKFONT(15)];
    [labelCurrentEdition setText:[NSString stringWithFormat:@"当前版本V%@",[Tool getAppVersion]] ];
    [self.view addSubview:labelCurrentEdition];
    
    //背景View
    _viewBtnsBackground = [[UIView alloc] initWithFrame:CGRectMake(0, labelCurrentEdition.frame.origin.y+labelCurrentEdition.frame.size.height+30, SCREEN_WIDTH, 137/3*2)];
    [_viewBtnsBackground setBackgroundColor:RGBA(242, 242, 242,1)];
    [self.view addSubview:_viewBtnsBackground];
    
    //关于按钮
    NSArray *arrAboutName = @[@"使用协议",@"软件评分"];
    for (int i = 0; i < [arrAboutName count]; i++)
    {
        //点击按钮
        UIButton *btnClick = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClick.frame = CGRectMake(0, (45*i), SCREEN_WIDTH, 45);
        btnClick.tag  = 1000 + i;//设置button的tag
        btnClick.backgroundColor = RGBA(255, 255, 255,1);
        [btnClick addTarget:self action:@selector(onButtonAbouts:) forControlEvents:UIControlEventTouchUpInside];
        [_viewBtnsBackground addSubview:btnClick];
        
        //显示文字的Label
        UILabel *_labelAboutName = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-15, 15)];
        [_labelAboutName setBackgroundColor:[UIColor clearColor]];
        [_labelAboutName setTextColor:RGBA(51, 51, 51,1)];
        [_labelAboutName setTextAlignment:NSTextAlignmentLeft]; //文字向左对齐
        [_labelAboutName setFont:MKFONT(15)];
        [_labelAboutName setText:arrAboutName[i]];
        [btnClick addSubview:_labelAboutName];
       
        if (i !=0)
        {
            UILabel *_labelLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            [_labelLine setBackgroundColor:RGBA(246, 246, 251,0.5)];
            [btnClick addSubview:_labelLine];
        }
    }
}

-(void)onButtonAbouts:(UIButton *)btn
{
    switch (btn.tag)
    {
        case 1000:
            [MobClick event:myCenterViewbtn124];
            [self toContract];
            break;
        case 1001:
        {
            [MobClick event:myCenterViewbtn126];
            [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/chao-ji-dian-ying-yuan-chang/id1017593088?mt=8"] ];
        }
            break;
            
        default:
            break;
    }
}

//打开使用协议
-(void)toContract
{
    __weak typeof(self) weakSelf = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServicesSystem getProtocolContent:^(NSString *protocolContent)
     {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
         [weakSelf createContractView:protocolContent];
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:self.view fading:YES];
     }];
}

-(void)toUpdateView
{
    __weak typeof(self) weakSelf = self;
    [ServicesSystem getVersionInfo:^(NSDictionary *versionModel)
     {
         if( ![[versionModel objectForKey:@"needUpdate"] boolValue] )
         {
             [Tool showWarningTip:@"没有可用更新" time:1];
         }
         else
         {
             UpdateView *updateView = [[UpdateView alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT) dic:versionModel showHideBackBtn:NO];
             [weakSelf.view addSubview:updateView];
             [UIView animateWithDuration:0.25 animations:^{
                 updateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
             } completion:^(BOOL finished) {
                 
             }];
         }
         
     } failure:^(NSError *error) {
     }];

}


-(void) createContractView:(NSString *)proctrolText
{
    ContractView* _contractView = [[ContractView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) str:proctrolText];
    _contractView.backgroundColor = [UIColor clearColor];
    _contractView.hidden = YES;
    _contractView.alpha = 0;
    _contractView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [self.view addSubview:_contractView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _contractView.transform = CGAffineTransformMakeScale(1, 1);
                         _contractView.hidden = NO;
                         _contractView.alpha = 1;
                     }completion:^(BOOL finish){
                         
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end



