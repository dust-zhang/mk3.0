//
//  ActivityDetailsViewController.m
//  supercinema
//
//  Created by mapollo91 on 7/3/17.
//
//

#import "ActivityDetailsViewController.h"

@interface ActivityDetailsViewController ()

@end

@implementation ActivityDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initController];
    [self setActivityDetailsFrameAndData];
}

//初始化
-(void)initController
{
    //顶部View //获取当前影院名称
    self._labelTitle.text = [Config getCinemaName];
    self.view.backgroundColor = RGBA(255, 255, 255, 1);
    
    //整体的ScrollView
    _scrollViewContent = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [_scrollViewContent setBackgroundColor:RGBA(246, 246, 255, 1)];
    [self.view addSubview:_scrollViewContent];
    
    //活动图片
    _imageActivity = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageActivity.backgroundColor = [UIColor redColor];
    [_scrollViewContent addSubview:_imageActivity];
    
    //参加人数
    _labelJoinPeople = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelJoinPeople.backgroundColor = RGBA(0, 0, 0, 0.5);
    _labelJoinPeople.layer.cornerRadius = 12;
    _labelJoinPeople.layer.masksToBounds = YES;
    [_labelJoinPeople setFont:MKFONT(10)];
    [_labelJoinPeople setTextColor:RGBA(255, 255, 255, 1)];
    [_labelJoinPeople setTextAlignment:NSTextAlignmentCenter];
    _labelJoinPeople.hidden = YES;
    [_imageActivity addSubview:_labelJoinPeople];
    
    //活动标题
    _labelActivityTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelActivityTitle.backgroundColor = [UIColor clearColor];
    [_labelActivityTitle setFont:MKFONT(20)];
    [_labelActivityTitle setTextColor:RGBA(51, 51, 51, 1)];
    _labelActivityTitle.numberOfLines = 0;
    _labelActivityTitle.lineBreakMode = NSLineBreakByCharWrapping;
    [_scrollViewContent addSubview:_labelActivityTitle];
    
    //活动时间
    _labelActivityTimeTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelActivityTimeTitle.backgroundColor = [UIColor clearColor];
    [_labelActivityTimeTitle setFont:MKFONT(15)];
    [_labelActivityTimeTitle setTextColor:RGBA(102, 102, 102, 1)];
    [_labelActivityTimeTitle setTextAlignment:NSTextAlignmentLeft];
    _labelActivityTimeTitle.text = @"活动时间";
    [_scrollViewContent addSubview:_labelActivityTimeTitle];
    
    _labelActivityTime = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelActivityTime.backgroundColor = [UIColor clearColor];
    [_labelActivityTime setFont:MKFONT(12)];
    [_labelActivityTime setTextColor:RGBA(249, 81, 81, 1)];
    [_labelActivityTime setTextAlignment:NSTextAlignmentLeft];
    [_scrollViewContent addSubview:_labelActivityTime];
    
    //活动描述
    _labelActivityDetailsTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelActivityDetailsTitle.backgroundColor = [UIColor clearColor];
    [_labelActivityDetailsTitle setFont:MKFONT(15)];
    [_labelActivityDetailsTitle setTextColor:RGBA(102, 102, 102, 1)];
    [_labelActivityDetailsTitle setTextAlignment:NSTextAlignmentLeft];
    _labelActivityDetailsTitle.text = @"活动描述";
    [_scrollViewContent addSubview:_labelActivityDetailsTitle];
    
    _labelActivityDetails = [[UILabel alloc] initWithFrame:CGRectZero];
    _labelActivityDetails.backgroundColor = [UIColor clearColor];
    [_labelActivityDetails setFont:MKFONT(12)];
    [_labelActivityDetails setTextColor:RGBA(51, 51, 51, 1)];
    _labelActivityDetails.numberOfLines = 0;//能换行
    _labelActivityDetails.lineBreakMode = NSLineBreakByCharWrapping;//能换行
    [_scrollViewContent addSubview:_labelActivityDetails];
    
    //详情按钮
    _btnCheckDetails = [[UIButton alloc] initWithFrame:CGRectZero];
    _btnCheckDetails.backgroundColor = [UIColor clearColor];
    [_btnCheckDetails .titleLabel setFont:MKFONT(15)];//按钮字体大小
    [_btnCheckDetails setTitle:@"查看详情" forState:UIControlStateNormal];
    [_btnCheckDetails addTarget:self action:@selector(onButtonCheckDetails) forControlEvents:UIControlEventTouchUpInside];
    [_scrollViewContent addSubview:_btnCheckDetails];

    //=================整体参加按钮背景=================
    _viewJoinButtonBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-58, SCREEN_WIDTH, 58)];
    _viewJoinButtonBG.backgroundColor = RGBA(255, 255, 255, 1);
    _viewJoinButtonBG.hidden = NO;
    [self.view addSubview:_viewJoinButtonBG];
    
    //开通按钮
    _btnJoinActivity = [[UIButton alloc] initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH-15*2, 40)];
    [_btnJoinActivity setBackgroundColor:[UIColor clearColor]];
    [_btnJoinActivity setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    [_btnJoinActivity .titleLabel setFont:MKFONT(15)];//按钮字体大小
    [_btnJoinActivity.layer setCornerRadius:20.f];//按钮设置圆角
    [_btnJoinActivity addTarget:self action:@selector(onButtonJoinActivity) forControlEvents:UIControlEventTouchUpInside];
    [_viewJoinButtonBG addSubview:_btnJoinActivity];
    
    //蒙层
    _imageShadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, _viewJoinButtonBG.frame.origin.y-6, SCREEN_WIDTH, 6)];
    _imageShadow.backgroundColor = [UIColor clearColor];
    _imageShadow.image = [UIImage imageNamed:@"img_shadow.png"];
    _imageShadow.hidden = NO;
    [self.view addSubview:_imageShadow];
}

-(void)setActivityDetailsFrameAndData
{
    //整体的ScrollView
    _scrollViewContent.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
    //活动图片
    _imageActivity.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2);
    [_imageActivity sd_setImageWithURL:[NSURL URLWithString:self._activityModel.activityImageUrl] placeholderImage:[UIImage imageNamed:@"image_Activity_finishBG.png"]];
    
    //参加人数
    _labelJoinPeople.frame = CGRectMake(_imageActivity.frame.size.width-15-75, _imageActivity.frame.size.height-10-24, 75, 24);
    //显示逻辑
    if ([self._activityModel.joinType intValue] == 0)
    {
        //领取
        [self setJoinPersonCount:self._activityModel.receiveCount joinType:self._activityModel.joinType];
    }
    else
    {
        //参加
        [self setJoinPersonCount:self._activityModel.joinCount joinType:self._activityModel.joinType];
    }
    
    //活动标题
    _labelActivityTitle.frame = CGRectMake(15, _imageActivity.frame.origin.y+_imageActivity.frame.size.height+20, SCREEN_WIDTH-15*2, 20);
    _labelActivityTitle.text = self._activityModel.activityTitle;
    [Tool setLabelSpacing:_labelActivityTitle spacing:2 alignment:NSTextAlignmentLeft];
    _labelActivityTitle.frame = CGRectMake(15, _imageActivity.frame.origin.y+_imageActivity.frame.size.height+20, SCREEN_WIDTH-15*2, _labelActivityTitle.frame.size.height);
    
    //活动时间
    _labelActivityTimeTitle.frame = CGRectMake(_labelActivityTitle.frame.origin.x, _labelActivityTitle.frame.origin.y+_labelActivityTitle.frame.size.height+35, _labelActivityTitle.frame.size.width, 15);
    
    _labelActivityTime.frame = CGRectMake(_labelActivityTimeTitle.frame.origin.x, _labelActivityTimeTitle.frame.origin.y+_labelActivityTimeTitle.frame.size.height+10, _labelActivityTitle.frame.size.width, 12);
    _labelActivityTime.text = [NSString stringWithFormat:@"%@ 至 %@",[Tool returnTime:self._activityModel.startValidTime format:@"yyyy年MM月dd日"],[Tool returnTime:self._activityModel.endValidTime format:@"yyyy年MM月dd日"]];
    
    //活动描述
    _labelActivityDetailsTitle.frame = CGRectMake(_labelActivityTitle.frame.origin.x,  _labelActivityTime.frame.origin.y+_labelActivityTime.frame.size.height+15, _labelActivityTitle.frame.size.width, 15);
    
    _labelActivityDetails.frame = CGRectMake(_labelActivityDetailsTitle.frame.origin.x, _labelActivityDetailsTitle.frame.origin.y+_labelActivityDetailsTitle.frame.size.height+10, _labelActivityTitle.frame.size.width, 12);
    
    //自适应高度
    _labelActivityDetails.frame = CGRectMake(_labelActivityDetailsTitle.frame.origin.x, _labelActivityDetailsTitle.frame.origin.y+_labelActivityDetailsTitle.frame.size.height+10, _labelActivityTitle.frame.size.width, 12);
    _labelActivityDetails.text = self._activityModel.activityDescription;
    [Tool setLabelSpacing:_labelActivityDetails spacing:2 alignment:NSTextAlignmentLeft];
    _labelActivityDetails.frame = CGRectMake(_labelActivityDetailsTitle.frame.origin.x, _labelActivityDetailsTitle.frame.origin.y+_labelActivityDetailsTitle.frame.size.height+10, _labelActivityTitle.frame.size.width, _labelActivityDetails.frame.size.height);

    //查看详情按钮
    _btnCheckDetails.frame = CGRectMake(SCREEN_WIDTH-15-70, _labelActivityDetails.frame.origin.y+_labelActivityDetails.frame.size.height+15, 70, 15);
    [_btnCheckDetails setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    //如果查看详情链接是空，则隐藏
    if(![Tool isBlankString:self._activityModel.detailUrl])
    {
        _btnCheckDetails.hidden = NO;
    }
    else
    {
        _btnCheckDetails.hidden = YES;
    }
    //计算ScrollView内容的高
    _scrollViewContent.contentSize = CGSizeMake(_scrollViewContent.frame.size.width, _btnCheckDetails.frame.origin.y+_btnCheckDetails.frame.size.height+100);
    
    
    //查看详情按钮显示逻辑
    [self setShowCheckDetails];
}

//当前活动参加人数显示逻辑
-(void)setJoinPersonCount:(NSNumber *)personCount joinType:(NSNumber *)joinType
{
    if ([personCount intValue] < 10)
    {
        _labelJoinPeople.hidden = YES;
    }
    else
    {
        _labelJoinPeople.hidden = NO;
        if ([joinType intValue] == 0)
        {
            //领取
            [_labelJoinPeople setText:[NSString stringWithFormat:@"%@人已领取",[Tool getPersonCount:personCount]]];
        }
        else
        {
            //参加
            [_labelJoinPeople setText:[NSString stringWithFormat:@"%@人已参加",[Tool getPersonCount:personCount]]];
        }
    }
    
//    if ([personCount intValue] < 10)
//    {
//        _labelJoinPeople.hidden = YES;
//    }
//    else if ([personCount intValue] < 1000)
//    {
//        _labelJoinPeople.hidden = NO;
//        if ([joinType intValue] == 0)
//        {
//            //领取
//            [_labelJoinPeople setText:[NSString stringWithFormat:@"%@人已领取",personCount]];
//        }
//        else
//        {
//            //参加
//            [_labelJoinPeople setText:[NSString stringWithFormat:@"%@人已参加",personCount]];
//        }
//    }
//    else
//    {
//        _labelJoinPeople.hidden = NO;
//        if ([joinType intValue] == 0)
//        {
//            //领取
//            [_labelJoinPeople setText:@"999+人已领取"];
//        }
//        else
//        {
//            //参加
//            [_labelJoinPeople setText:@"999+人已参加"];
//        }
//    }
}

-(void)setShowCheckDetails
{
    //结束日期
    long  currentTime = [[Tool getSystemTime] longValue];
    long  endTime = [self._activityModel.endValidTime longValue];
//    long  leftTime = (endTime - currentTime)/1000/24/60/60;
    if (currentTime < endTime)
    {
//        if (leftTime == 0)
//        {
//            _labelActivityTime.text = @"今日结束";
//        }
//        else
//        {
//            //            _labelActivityTime.text = [NSString stringWithFormat:@"%ld天后结束",leftTime];
//            _labelActivityTime.text = [NSString stringWithFormat:@"%@ 至 %@",[Tool returnTime:self._activityModel.startValidTime format:@"yyyy年MM月dd日"],[Tool returnTime:self._activityModel.endValidTime format:@"yyyy年MM月dd日"]];
//        }
        //查看详情显示逻辑（活动时间没过期就可以点击，颜色是紫色）
        [_btnCheckDetails setEnabled:YES];
        [_btnCheckDetails setTitleColor:RGBA(117, 112, 255, 1) forState:UIControlStateNormal];//按钮文字颜色
    }
    else
    {
//        _labelActivityTime.text = @"活动已结束";
        //查看详情显示逻辑（活动时间过期就不能点击，颜色是置灰）
        [_btnCheckDetails setEnabled:NO];
        [_btnCheckDetails setTitleColor:RGBA(180, 180, 180, 1) forState:UIControlStateNormal];//按钮文字颜色
    }
    _labelActivityTime.text = [NSString stringWithFormat:@"%@ 至 %@",[Tool returnTime:self._activityModel.startValidTime format:@"yyyy年MM月dd日"],[Tool returnTime:self._activityModel.endValidTime format:@"yyyy年MM月dd日"]];
    
    //按钮显示状态
    [self btnShowStateJoinStatus:self._activityModel.joinStatus];
}

-(void)btnShowStateJoinStatus:(NSNumber *)joinStatus
{
    //列表的显示状态
    /*
     *  listShowStatus
     *  1:即将开始 2:去参加 3:已参加 4:已结束
     */
    
    //按钮状态
    /*
     *  joinType
     *  0：立即领取:(joinStatus 4,5,6) 1：无； 2：立即参加:(joinStatus 1,2,3) 3：抽奖
     */
    
    /*
     *  joinStatus
     *  0：无按钮情况； 1：未参加； 2：用户已经报名； 3：用户已经不能参加了（数量不足，次数限制）
     *  4：可以领取； 5：不可以领取 6：已经领取，但是不能继续领取 7：已经抢光，商品数量不足
     *  8：未开始； 9：已结束
     */
    
    /*
     *  validUseCount
     *  有效的使用次数（立即领取、抽奖形式的活动，在判断joinStatus的前提下，还需要判断有效次数>0）
     */
    
    //按钮点击状态 0:隐藏 1：可点击 2：不能点击
    int btnStatus = 0;
    NSString *btnText = @"";
    
    switch ([joinStatus intValue])
    {
        case 0:
            //无按钮情况
            btnStatus = 0;
            break;
        case 1:
            //未参加
            btnText = @"立即参加";
            btnStatus = 1;
            break;
        case 2:
            //用户已经报名
            btnText = @"已参加";
            btnStatus = 2;
            break;
        case 3:
            //活动无效
            btnText = @"已抢光";
            btnStatus = 2;
            break;
        case 4:
            //可以领取
            btnText = @"立即领取";
            btnStatus = 1;
            break;
        case 5:
            //活动无效
            btnText = @"已抢光";
            btnStatus = 2;
            break;
        case 6:
            //已经领取，但是不能继续领取
            btnText = @"已领取";
            btnStatus = 2;
            break;
        case 7:
            //活动物品没有了
            btnText = @"已抢光";
            btnStatus = 2;
            break;
        case 8:
            //未开始
            btnText = @"即将开始";
            btnStatus = 1;
            break;
        case 9:
            //已结束
            btnText = @"已结束";
            btnStatus = 2;
            break;
            
        default:
            btnStatus = 0;
            break;
    }
    //参加按钮状态（是否可点击） & 文本显示
    [self setJoinButtonStatus:btnStatus text:btnText];
}

#pragma mark 参加按钮状态 & 文本
-(void)setJoinButtonStatus:(int)status text:(NSString *)text
{
    if (status == 1)
    {
        [_btnJoinActivity setTitle:text forState:UIControlStateNormal];
        [_btnJoinActivity setEnabled:YES];
        
        if ([self._activityModel.joinStatus intValue] == 8)
        {
            //如果是即将开始
            [_btnJoinActivity setBackgroundImage:[UIImage imageNamed:@"btn_ActivityDetails_goutoBegin.png"] forState:UIControlStateNormal];
        }
        else
        {
            //其他类型
            [_btnJoinActivity setBackgroundImage:[UIImage imageNamed:@"btn_ActivityDetails_goutoJoin.png"] forState:UIControlStateNormal];
        }
    }
    else if (status == 2)
    {
        [_btnJoinActivity setTitle:text forState:UIControlStateNormal];
        [_btnJoinActivity setEnabled:NO];
        [_btnJoinActivity setBackgroundImage:[UIImage imageNamed:@"btn_ActivityDetails_gouto_gray.png"] forState:UIControlStateNormal];
    }
    else
    {
//        _btnJoinActivity.hidden = YES;
        _viewJoinButtonBG.hidden = YES;
        _imageShadow.hidden = YES;
    }
}

#pragma mark 查看详情
-(void)onButtonCheckDetails
{
    [self openWebview:self._activityModel];
}

//打开WebView
-(void)openWebview:(ActivityModel*)model
{
    [MobClick event:mainViewbtn116];
    //    NotifyH5ViewController *notifyH5Controller = [[NotifyH5ViewController alloc]init];
    //    notifyH5Controller._shareUrlStr = model.detailUrl;
    //    [self._navigationController pushViewController:notifyH5Controller animated:YES];
    
    NSString *strGet = [Tool stringH5Url:model.detailUrl systime:[Tool getSystemTime] ];
    ActivityCenterWebViewController* webViewController = [[ActivityCenterWebViewController alloc]init];
    webViewController._url = [NSURL URLWithString:strGet];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark 领取活动
-(void)onButtonJoinActivity
{
    //判断登录状态
    if ( ![Config getLoginState ])
    {
        //没有登录，弹出登录页
        [self showLoginController];
        return;
    }
    //列表的显示状态
    if ([self._activityModel.joinStatus intValue] == 8)
    {
        //如果是活动未开始
        //弹提示框
        [Tool showWarningTip:@"别心急，活动还没开始哦~" time:2];
    }
    else
    {
        if (![Tool isBlankString:self._activityModel.buttonLink])
        {
            NSString *strGet = [Tool stringH5Url:self._activityModel.buttonLink systime:[Tool getSystemTime] ];
            ActivityCenterWebViewController* webViewController = [[ActivityCenterWebViewController alloc]init];
            webViewController._url = [NSURL URLWithString:strGet];
            [self.navigationController pushViewController:webViewController animated:YES];
        }
        else
        {
            [MobClick event:mainViewbtn115];
            if ([self._activityModel.joinType intValue] == 0)
            {
                //立即领取
                [self immediatelyReceive:self._activityModel];
            }
            if ([self._activityModel.joinType intValue] == 2 || [self._activityModel.joinType intValue] == 3)
            {
                //立即参加
                [self immediatelyJoin:self._activityModel];
            }
        }
    }
}

#pragma mark 立即领取
-(void)immediatelyReceive:(ActivityModel *) activityModel
{
    __weak ActivityDetailsViewController *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServiceActivity receiveActivity:[Config getCinemaId] activityId:activityModel.activityId model:^(ActivityRootModel *model)
     {
         [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
         if (model.activityGrantList.count <=0)
         {
             [Tool showWarningTip:@"手慢了,下次加油: (" time:2.0];
         }
         else
         {
             AwardView* awardView = [[AwardView alloc]  initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) arr:model.activityGrantList shareRedpackFee:nil];
             [weakself.view.window addSubview:awardView];
             
             [UIView animateWithDuration:0.4
                              animations:^{
                                  awardView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                                  awardView.hidden=NO;
                                  awardView.alpha=1;
                              }completion:^(BOOL finish){
                                  
                              }];
         }
         //刷新领取 & 参加后的UI
         [weakself btnShowStateJoinStatus:model.joinStatus];
         
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
         [Tool showWarningTip:error.domain time:1.5f ];
     }];
}

#pragma mark 立即参加
-(void)immediatelyJoin:(ActivityModel *) activityModel
{
    __weak ActivityDetailsViewController *weakself = self;
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.view withTitle:@"加载中..." withBlur:NO allowTap:NO];
    [ServiceActivity joinActivity:[Config getCinemaId] activityId:activityModel.activityId model:^(RequestResult *model)
     {
         [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
         //[Tool showWarningTip:model.respMsg time:1 ];
         //刷新领取 & 参加后的UI
         [weakself btnShowStateJoinStatus:model.joinStatus];
     } failure:^(NSError *error) {
         [FVCustomAlertView hideAlertFromView:weakself.view fading:YES];
         [Tool showWarningTip:error.domain time:1 ];
     }];
}

#pragma mark 弹出登录view
-(void)showLoginController
{
    LoginViewController *loginControlller = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginControlller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end



