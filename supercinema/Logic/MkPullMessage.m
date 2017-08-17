//
//  MkPullMessage.m
//  movikr
//
//  Created by Mapollo27 on 16/4/11.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import "MkPullMessage.h"
#import "NotificationView.h"

@implementation MkPullMessage
NotificationView *notificationView = nil;
//0:刚插入状态显示
//1：已经显示，以后不再显示
//2：今天已经显示，以后每天都显示
//3：只弹出没有查看，再次打开app继续显示
//读取本地消息
//triggerType 出发条件 某个view
+(NSMutableArray *)getLocalNotifiction:(int ) triggerType typeTime:(NSString *)typeTime
{
    NSString *sql = @"";
    CinemaPullModel * model = [[CinemaPullModel alloc ] init];
    //读取本地数据成功后，保存当前时间，在读取每天显示数据时使用
    model = [sqlDatabase selectCinemaTime:[Config getCinemaId]];
    
    //如果存储的时间和本地时间不一致，则重新写入时间，读取每天显示的数据和每次触发条件的数据
//    NSLog(@"\n%@\n%@",[Config getSystemDate:typeTime],[Tool returnTime:model.pullTime format:@"YYYY-MM-dd"]);
    if(![[Config getSystemDate:typeTime] isEqualToString:[Tool returnTime:model.pullTime format:@"YYYY-MM-dd"]] )
    {
        sql = [NSString stringWithFormat:@"select * from table_notice where showHide != 1 and actionType=%d and validstarttime<='%@' and validendtime>='%@' and cinemaid='%@' "
               ,triggerType,[Tool returnTime:model.pullTime format:@"YYYY-MM-dd HH:mm:ss"] ,[Tool returnTime:model.pullTime format:@"YYYY-MM-dd HH:mm:ss"],[Config getCinemaId]];
    }
    else
    {
        sql= [NSString stringWithFormat:@"select * from table_notice where showHide != 1 and showHide != 2 and actionType=%d and validstarttime<='%@' and validendtime>='%@' and cinemaid='%@'"
               ,triggerType,[Tool returnTime:model.pullTime format:@"YYYY-MM-dd HH:mm:ss"] ,[Tool returnTime:model.pullTime format:@"YYYY-MM-dd HH:mm:ss"],[Config getCinemaId]];
    }
    NSMutableArray *searchResultArray = [self returnMaxLastUpdateTimeData:[sqlDatabase selectNoticeData:sql]];
    
    //保存服务器时间
    [Config saveSystemDate:[Tool returnTime:model.pullTime format:@"YYYY-MM-dd"] type:typeTime];
    
    return searchResultArray;
}
+(NSMutableArray *)returnMaxLastUpdateTimeData:(NSMutableArray *)arr
{
    for (int i = 0; i < [arr count]; i++)
    {
        if ([arr count] == 1)
        {
            return arr;
        }
        else
        {
            NotifyListModel *notifyModel = notifyModel = arr[0];

            NotifyListModel *notifyModelNext = [[NotifyListModel alloc] init];
            
            
            if ( [arr count]> 0 )
            {
                notifyModelNext = arr[1];
            }
//            NSLog(@"%@\n%@",notifyModel.lastUpdateTime ,notifyModelNext.lastUpdateTime );
            if ([notifyModel.lastUpdateTime integerValue] <[notifyModelNext.lastUpdateTime integerValue]  )
            {
                [arr removeObjectAtIndex:0];
                i = 0;
            }
            else
            {
                [arr removeObjectAtIndex:1];
            }
        }
    }
    return arr;
}
+(void) showPushMessage:(UINavigationController *)navigationController triggerType:(int ) triggerType apnsModel:(NotifyListModel *)model typeTime:(NSString *)typeTime
{
    //apns 过来的通知
    if(model)
    {
        [self apnsShowNotice:model.jumpUrl type:model.jumpType apnsModel:model nav:navigationController];
    }
    else
    {
        NSMutableArray *arrLocation = [[NSMutableArray alloc ] initWithArray:[self getLocalNotifiction:triggerType typeTime:typeTime]];
        NSLog(@"%@",arrLocation );
        if ([arrLocation count] > 0 && arrLocation !=nil)
        {
            NotifyListModel *notifyModel = arrLocation[0];
            [self showNotice:notifyModel nav:navigationController];
        }
    }
}

+(void) apnsShowNotice:(NSString*)jumpUrl type:(NSNumber*)jumpType apnsModel:(NotifyListModel*)model nav:(UINavigationController*)navigation
{
    //跳转类型
    if([jumpType intValue] == 2)
    {
        //h5通知
        NotifyH5ViewController* h5ViewController = [[NotifyH5ViewController alloc]init];
        h5ViewController._notifyModel = model;
        [navigation pushViewController:h5ViewController animated:YES];
    }
    else
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
        
        if ([jumpUrl intValue] == 1)
        {
            [self switchTab:0];
            NSDictionary* dictHome = @{@"tag":@3};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
        }
        if ([jumpUrl intValue] == 2)
        {
            [self switchTab:0];
            MyCardViewController *myCardPackController = [[MyCardViewController alloc ]init];
            [navigation pushViewController:myCardPackController animated:YES];
        }
        if ([jumpUrl intValue] == 3)
        {
            [self switchTab:0];
            NSDictionary* dictHome = @{@"tag":@1};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
        }
        if ([jumpUrl intValue] == 4)
        {
            
        }
        if ([jumpUrl intValue] == 5)
        {
            [self switchTab:0];
            NSDictionary* dictHome = @{@"tag":@0};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
            [navigation popToRootViewControllerAnimated:YES];
        }
        if ([jumpUrl intValue] == 6)
        {
            [self switchTab:0];
            MovieModel *movieModel = [[MovieModel alloc ] init];
            movieModel.movieId = [NSNumber numberWithInt:[model.movieId intValue]];
            
            ShowTimeViewController* showTimeVC = [[ShowTimeViewController alloc]init];
            showTimeVC.hotMovieModel = movieModel;
            [navigation pushViewController:showTimeVC animated:YES];
        }
        if ([jumpUrl intValue] == 7)
        {
            //小卖部
            [self switchTab:0];
            NSDictionary* dictHome = @{@"tag":@2};
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFITION_HOMETOTAB object:nil userInfo:dictHome];
        }
        if ([jumpUrl intValue] == 8)
        {
            //我的订单
            [self switchTab:0];
            MyOrderViewController *myOrderController = [[MyOrderViewController alloc ] init];
            [navigation pushViewController:myOrderController animated:YES];
        }
        if ([jumpUrl intValue] == 9)
        {
            [self switchTab:2];
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [appDelegate switchTab:0];
        }
    }
    
}

+(void) switchTab:(int)type
{
    //type：0首页 1福利社 2个人中心
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate switchTab:type];
}

+(void) showNotice:(NotifyListModel *)notifyModel nav:(UINavigationController *)navigationController
{
    ////0:活动通知，1:广播公告，2:消息中心，3:启动页广告，4:H5通知
    switch ([notifyModel.notifyType intValue])
    {
        case 0://0:活动通知
        {
            if(notificationView)
            {
                [notificationView removeFromSuperview];
                notificationView = nil;
            }
            if (notificationView == nil)
            {
                notificationView = [[NotificationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) navigation:navigationController model:notifyModel isActive:TRUE];
                [[Tool getLastViewController:navigationController].view addSubview:notificationView];
            }
           
        }
            break;
        case 1://1:广播公告
        {
            //time :如果是0则一直处于显示状态，3：3秒后自动关闭
            [BroadcastView showMessageBoxView:notifyModel time:5 nav:navigationController];
        }
            break;
        case 2://2:消息中心
        {
            
        }
            break;
        case 3://3:启动页广告
        {
            
        }
            break;
        case 4://H5通知
        {
            if(notificationView)
            {
                [notificationView removeFromSuperview];
                notificationView = nil;
            }
            if (notificationView == nil)
            {
                notificationView = [[NotificationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) navigation:navigationController model:notifyModel isActive:FALSE];
                [[Tool getLastViewController:navigationController].view addSubview:notificationView];
            }
        }
            break;
        default:
            break;
    }
}


@end
