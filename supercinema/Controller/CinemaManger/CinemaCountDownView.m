//
//  CinemaDetailView.m
//  movikr
//
//  Created by zeyuan on 15/5/19.
//  Copyright (c) 2015年 zeyuan. All rights reserved.
//

#import "CinemaCountDownView.h"


@implementation CinemaCountDownView

-(id)initWithFrame:(CGRect)frame cinemaModel:(CinemaModel*)cinemaModel navigation:(UINavigationController *)nav
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:RGBA(0, 0, 0,0)];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        self._arrayMap = [[NSMutableArray alloc] init];
        self._navigationController = nav;
        self._cinemaModel = cinemaModel;
        
        [self initCtrl];
        [self addCinemaBrowsingHistory:[cinemaModel.cinemaId stringValue]];
    }
    return self;
}

#pragma mark 切换影院记录
-(void) addCinemaBrowsingHistory:(NSString *)cinemaId
{
    [ServicesCinema addCinemaBrowseRecord:@"" longitude:@"" lastVisitCinemaId:cinemaId model:^(RequestResult *model) {

    } failure:^(NSError *error) {

    }];
}

-(void)initCtrl
{
    _realTimeBlur = [[XHRealTimeBlur alloc] initWithFrame:self.bounds];
    _realTimeBlur.blurStyle = XHBlurStyleTranslucent;
    _realTimeBlur.hasTapGestureEnable = NO;
    [self addSubview:_realTimeBlur];

    UIImageView *imageViewCinemaTop = [[UIImageView alloc ] initWithFrame:self.bounds];
    [imageViewCinemaTop setImage:[UIImage imageNamed:@"image_cinemabg.png"]];
    [self addSubview:imageViewCinemaTop];

    UIButton *btnClose = [[UIButton alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 23, 40, 40)];
    [btnClose setTitle:@"跳过" forState:UIControlStateNormal];
    [btnClose.titleLabel setFont:MKFONT(13)];
    [btnClose.layer setCornerRadius:20 ];
    [btnClose.layer setMasksToBounds:YES];
    [btnClose setBackgroundColor:RGBA(0, 0, 0, 0.5)];
    [btnClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClose];
    
    UIButton *btnBack = [[UIButton alloc ] initWithFrame:CGRectMake(20, btnClose.frame.origin.y, 40, 40)];
    [btnBack setImage:[UIImage imageNamed:@"image_CinemaBack_black.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(onButtonBack) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBack];
    
    //影院标题
    CGSize size = [Tool CalcString:self._cinemaModel.cinemaName fontSize:MKBOLDFONT(18) andWidth:SCREEN_WIDTH-80];
    _labelCinemaName = [[UILabel alloc] initWithFrame:CGRectMake(40, (IPhone5?200/2:btnClose.frame.origin.y+btnClose.frame.size.height+45), SCREEN_WIDTH-80, size.height)];
    [_labelCinemaName setFont:MKBOLDFONT(18)];
    [_labelCinemaName setTextAlignment:NSTextAlignmentCenter];
    [_labelCinemaName setTextColor:[UIColor whiteColor]];
//    [_labelCinemaName setBackgroundColor:[UIColor redColor]];
    _labelCinemaName.userInteractionEnabled=YES;
    _labelCinemaName.numberOfLines = 0;
    _labelCinemaName.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:_labelCinemaName];
    [_labelCinemaName setText:self._cinemaModel.cinemaName];
    
    //影院营业时间
    size = [Tool CalcString:[NSString stringWithFormat:@"营业时间\n%@ - %@",self._cinemaModel.businessStartTime,self._cinemaModel.businessEndTime] fontSize:MKFONT(12) andWidth:SCREEN_WIDTH];
    _labelBusinessHours = [[UILabel alloc] initWithFrame:CGRectMake(0, _labelCinemaName.frame.origin.y+_labelCinemaName.frame.size.height+(IPhone5?154/4:80), SCREEN_WIDTH, size.height)];
    [_labelBusinessHours setFont:MKFONT(12) ];
    [_labelBusinessHours setTextAlignment:NSTextAlignmentCenter];
    [_labelBusinessHours setTextColor:[UIColor whiteColor]];
    [_labelBusinessHours setText:[NSString stringWithFormat:@"营业时间\n%@ - %@",self._cinemaModel.businessStartTime,self._cinemaModel.businessEndTime] ];
    [_labelBusinessHours setLineBreakMode:NSLineBreakByCharWrapping];
    _labelBusinessHours.numberOfLines = 0;
    [self addSubview:_labelBusinessHours];
    [_labelBusinessHours setHidden:YES];
    if([self._cinemaModel.businessStartTime length] >0)
    {
        [_labelBusinessHours setHidden:NO];
    }
    
    UIView *countDown = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2,  _labelBusinessHours.frame.origin.y+_labelBusinessHours.frame.size.height+60, 100, 100)];
    [countDown setBackgroundColor:[UIColor clearColor]];
    [self addSubview:countDown];
    
    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [_progressLabel setText:@"3"];
    [_progressLabel setFont:[UIFont systemFontOfSize:60]];
    [_progressLabel setTextColor:RGBA(255, 255, 255, 1)];
    [_progressLabel setTextAlignment:NSTextAlignmentCenter];
    [countDown addSubview:_progressLabel];
    
    _progressTimer = [[KKProgressTimer alloc] initWithFrame:countDown.bounds];
    [_progressTimer setProgressBackgroundColor:RGBA(255,255,255,0.1)];
    [_progressTimer setProgressColor:RGBA(255,255,255,0.1)];
    [_progressTimer setCircleBackgroundColor:RGBA(0,0,0,0.1)];
    [countDown addSubview:_progressTimer];
    
    UIView *xLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 100, 0.6)];
    [xLine setBackgroundColor:RGBA(0, 0, 0,0.4)];
    [countDown addSubview:xLine];
    
    UIView *yLine = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 0.6, 100)];
    [yLine setBackgroundColor:RGBA(0, 0, 0,0.4)];
    [countDown addSubview:yLine];
    [self performSelector:@selector(progressStart) withObject:nil afterDelay:0.3];

    //影院剩余座位
    _labelSurplusSeat = [[UILabel alloc] initWithFrame:CGRectMake(0,countDown.frame.origin.y+countDown.frame.size.height+(IPhone5?50:190/2), SCREEN_WIDTH, 12)];
    [_labelSurplusSeat setFont:MKFONT(12) ];
    [_labelSurplusSeat setTextColor:RGBA(255, 255, 255,0.6)];
    [_labelSurplusSeat setTextAlignment:NSTextAlignmentCenter];
    [_labelSurplusSeat setText:[NSString stringWithFormat:@"%@个影厅 %@个座位",self._cinemaModel.hallCount,self._cinemaModel.seatCount] ];
    [self addSubview:_labelSurplusSeat];
    [_labelSurplusSeat setHidden:YES];
    if([self._cinemaModel.hallCount intValue] >0)
    {
        [_labelSurplusSeat setHidden:NO];
    }
    
    for (int i= 0 ; i < [self._cinemaModel.featureList count];  i++ )
    {
        FeatureListModel*model =  self._cinemaModel.featureList[i];
        
        if ([self._cinemaModel.featureList count] == 1)
        {
            _label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-30,_labelSurplusSeat.frame.origin.y+_labelSurplusSeat.frame.size.height+30/2, 60, 20)];
            [_label setFont:MKFONT(9) ];
            [_label setTextColor:RGBA(255, 255, 255,1)];
            [_label setBackgroundColor:RGBA(0, 0, 0, 0.2)];
            [_label setTextAlignment:NSTextAlignmentCenter];
            [_label.layer setCornerRadius:4];
            [_label.layer setMasksToBounds:YES];
            [_label setText:model.featureCode];
            [self addSubview:_label];
        }
        else if ([self._cinemaModel.featureList count] == 2)
        {
            _label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-70 +i*(70),_labelSurplusSeat.frame.origin.y+_labelSurplusSeat.frame.size.height+30/2, 60, 20)];
            [_label setFont:MKFONT(9) ];
            [_label setTextColor:RGBA(255, 255, 255,1)];
            [_label setBackgroundColor:RGBA(0, 0, 0, 0.2)];
            [_label setTextAlignment:NSTextAlignmentCenter];
            [_label.layer setCornerRadius:4];
            [_label.layer setMasksToBounds:YES];
            [_label setText:model.featureCode];
            [self addSubview:_label];

        }
        else
        {
            _label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-110 +i*(70),_labelSurplusSeat.frame.origin.y+_labelSurplusSeat.frame.size.height+30/2, 60, 20)];
            [_label setFont:MKFONT(9) ];
            [_label setTextColor:RGBA(255, 255, 255,1)];
            [_label setBackgroundColor:RGBA(0, 0, 0, 0.2)];
            [_label setTextAlignment:NSTextAlignmentCenter];
            [_label.layer setCornerRadius:4];
            [_label.layer setMasksToBounds:YES];
            [_label setText:model.featureCode];
            [self addSubview:_label];
            if (i == 2)
            {
                break;
            }
        }
    }
    //影院地址
    if (self._cinemaModel.address)
    {
        CGSize size = [Tool CalcString:self._cinemaModel.address fontSize:MKFONT(12) andWidth: SCREEN_WIDTH-120-12-10];
        _locationILabel = [[UILabel alloc] initWithFrame:CGRectMake(60+12+10, _labelSurplusSeat.frame.size.height+_labelSurplusSeat.frame.origin.y+51, SCREEN_WIDTH-120-12-10, size.height)];
        [_locationILabel setText:self._cinemaModel.address];
        _locationILabel.lineBreakMode = NSLineBreakByWordWrapping;
        _locationILabel.numberOfLines = 0;
        [_locationILabel setFont:MKFONT(12) ];
        [_locationILabel setTextColor:RGBA(255, 255, 255,0.6)];
        [_locationILabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_locationILabel];
        
        //图标
        _locationImg = [[UIImageView alloc]initWithFrame:CGRectMake(60, _locationILabel.frame.origin.y +_locationILabel.frame.size.height/2-29/4, 24/2, 29/2)];
        [_locationImg setImage:[UIImage imageNamed:@"image_CinemaLocationWhite.png"]];
        [self addSubview:_locationImg];
    }
    
}

-(void)progressStart
{
    __block int timerIndex = 3;
    __block CGFloat i = 0;
    [_progressLabel setText:@"3"];
    [_progressTimer startWithBlock:^CGFloat
    {
        float num = ((i++ >= 80) ? (i = 0) : i) / 80;
        if(i >= 80)
        {
            timerIndex--;
            if (timerIndex <= 0)
            {
                [_progressTimer stop];
                [self performSelector:@selector(closeView) withObject:nil afterDelay:0.2];
            }
            if (timerIndex > 0)
            {
                [_progressLabel setText:[NSString stringWithFormat:@"%i",timerIndex]];
            }
        }
        return num;
    }];
}

#pragma mark  关闭倒计时View
-(void)closeView
{
    [MobClick event:mainViewbtn161];
    //保存影院名字
    [Config saveCinemaName:self._cinemaModel.cinemaName];
    //保存影院id
    [Config saveCinemaId:[self._cinemaModel.cinemaId stringValue]];
    
    [_progressTimer stop];
    [self removeFromSuperview];
    //移除首页数据
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REMOVEHOMEDATA object:nil];
    //刷新首页数据
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHCINEMAHOME object:nil];
    //刷新首页加载bool值
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_REFRESHHOMELOADBOOL object:nil];
    //切换到影院首页
    NSDictionary* dictHome = @{@"tag":@0};
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];

    [self._navigationController popToRootViewControllerAnimated:NO];
    
    //切换影院重新拉取通知
    [[NSNotificationCenter defaultCenter ] postNotificationName:NOTIFITION_SHOWCINEMAVIEWMSG object:nil];
}

-(void) onButtonBack
{
    [MobClick event:mainViewbtn162];
    [_progressTimer stop];
    [self removeFromSuperview];
    
}
@end
