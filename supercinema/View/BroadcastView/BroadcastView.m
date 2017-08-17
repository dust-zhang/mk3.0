//
//  BroadcastView.m
//  movikr
//
//  Created by Mapollo27 on 16/4/11.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import "BroadcastView.h"
#import "sqlDatabase.h"
#define viewHeight   51.5

static UIView *currentView = nil;
NotifyListModel *_model;
UINavigationController *_navigationController;


@implementation BroadcastView

+(void) showMessageBoxView:(NotifyListModel *) model time:(float) delayTime nav:(UINavigationController *)navigationController
{
    if (currentView)
    {
        [self closeCurrentView];
    }
    [[UIApplication sharedApplication ] setStatusBarHidden:YES];
    _model =model;
    _navigationController =navigationController;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    //背景
    currentView = [[UIView alloc] initWithFrame:CGRectMake(0, -viewHeight, SCREEN_WIDTH,viewHeight )];
    [currentView setUserInteractionEnabled:YES];
    [currentView setBackgroundColor:RGBA(0, 0, 0, 1)];
    //title
    UILabel *lableFont = [[UILabel alloc] initWithFrame:CGRectMake(50, 7, SCREEN_WIDTH-100, 14)];
    [lableFont setText:model.title];
    [lableFont setTextColor:[UIColor whiteColor]];
    [lableFont setFont:MKFONT(14) ];
    [lableFont setBackgroundColor:[UIColor clearColor]];
    [lableFont setTextAlignment:NSTextAlignmentLeft];
    [lableFont setUserInteractionEnabled:YES];
    [currentView addSubview:lableFont];

    //content
    UILabel *lableContent = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, SCREEN_WIDTH-100, 13)];
    [lableContent setText:model.notifyContent];
    [lableContent setTextColor:[UIColor whiteColor]];
    [lableContent setFont:MKFONT(12) ];
    [lableContent setBackgroundColor:[UIColor clearColor]];
    [lableContent setTextAlignment:NSTextAlignmentLeft];
    [lableContent setUserInteractionEnabled:YES];
    [currentView addSubview:lableContent];

    //声音小图标
    UIImageView *imageViewSound = [[UIImageView alloc ] initWithFrame:CGRectMake(15, (viewHeight-30)/2, 30, 30)];
    [imageViewSound setImage:[UIImage imageNamed:@"image_sound.png"]];
    [currentView addSubview:imageViewSound];

    //关闭按钮
    UIButton *btnClose = [[UIButton alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-viewHeight, 0, viewHeight, viewHeight)];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"btn_popviewclose.png"] forState:UIControlStateNormal];
//    btnClose.tag = 100;
    [btnClose addTarget:self action:@selector(hideMessageBox) forControlEvents:UIControlEventTouchUpInside];
    [currentView addSubview:btnClose];

    //打开连接
    UIButton *btnLink = [[UIButton alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60,viewHeight )];
    [btnLink setBackgroundColor:[UIColor clearColor]];
    [btnLink addTarget:self action:@selector(onButtonLink) forControlEvents:UIControlEventTouchUpInside];
    [currentView addSubview:btnLink];


    [window addSubview:currentView];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         currentView.frame =CGRectMake(0, 0, SCREEN_WIDTH, viewHeight);
                     }completion:^(BOOL finish){

                     }];
    if(delayTime > 0 )
    {
        [self performSelector:@selector(hideMessageBox) withObject:currentView afterDelay:delayTime];
    }
    
    //关闭广播公告
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(closeCurrentView) name:NOTIFITION_CLOSEBROADVIEW object:nil];
}

+(void) hideMessageBox
{
    [MobClick event:activityViewbtn9];
    //直接关闭，未读取
    if( ![sqlDatabase updateNotice:_model.notifyId  status:_model.frequencyType ])
    {
        NSLog(@"修改数据库失败！");
    }

    if (currentView)
    {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             currentView.frame =CGRectMake(0, -viewHeight, SCREEN_WIDTH, viewHeight);
                         }completion:^(BOOL finish){
                             [currentView removeFromSuperview];
                             currentView = nil;
                             [[UIApplication sharedApplication ] setStatusBarHidden:NO];
                         }];
    }
}

+(void)closeCurrentView
{
    if (currentView)
    {
        [currentView removeFromSuperview];
        currentView = nil;
        [[UIApplication sharedApplication ] setStatusBarHidden:NO];
    }
}


+(void) onButtonLink
{
    [MobClick event:activityViewbtn8];
    [self hideMessageBox];
    //跳转类型 1:无，2:h5页面，3:app内界面
    if([_model.jumpType intValue] == 2)
    {
        //h5通知
        NotifyH5ViewController* h5ViewController = [[NotifyH5ViewController alloc]init];
        h5ViewController._notifyModel = _model;
        [_navigationController pushViewController:h5ViewController animated:YES];
    }
    if([_model.jumpType intValue] == 3)
    {
        /*
         1:活动中心"
         2:卡包页"
         3:钻石-vip特权页（捡便宜）"
         4:成长任务页"
         5:首页"
         6:影片购票页
         7:小卖部”
         8:我的订单”
         9:个人中心
         */
        if ([_model.jumpUrl intValue] == 1)
        {
            NSDictionary* dictTab = @{@"tag":@0};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
            NSDictionary* dictHome = @{@"tag":@3};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
        }
        if ([_model.jumpUrl intValue] == 2)
        {
            MyCardViewController *myCardPackController = [[MyCardViewController alloc ]init];
            [_navigationController pushViewController:myCardPackController animated:YES];
        }
        if ([_model.jumpUrl intValue] == 3)
        {
            NSDictionary* dictTab = @{@"tag":@0};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
            NSDictionary* dictHome = @{@"tag":@1};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
        }
        if ([_model.jumpUrl intValue] == 4)
        {
            
        }
        if ([_model.jumpUrl intValue] == 5)
        {
            NSDictionary* dictTab = @{@"tag":@0};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
            [_navigationController popToRootViewControllerAnimated:YES];
        }
        if ([_model.jumpUrl intValue] == 6)
        {
            MovieModel *model = [[MovieModel alloc ] init];
            model.movieId = [NSNumber numberWithInt:[_model.movieId intValue]];
            
            ShowTimeViewController* showTimeVC = [[ShowTimeViewController alloc]init];
            showTimeVC.hotMovieModel = model;
            [_navigationController pushViewController:showTimeVC animated:YES];
        }
        if ([_model.jumpUrl intValue] == 7)
        {
            //小卖部
            NSDictionary* dictTab = @{@"tag":@0};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
            
            NSDictionary* dictHome = @{@"tag":@2};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
        }
        if ([_model.jumpUrl intValue] == 8)
        {
            //我的订单
            MyOrderViewController *myOrderController = [[MyOrderViewController alloc ] init];
            [_navigationController pushViewController:myOrderController animated:YES];
        }
        if ([_model.jumpUrl intValue] == 9)
        {
            NSDictionary* dictTab = @{@"tag":@2};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETABBAR object:nil userInfo:dictTab];
        }
    }
    
}


@end
