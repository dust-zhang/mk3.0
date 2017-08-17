//
//  ThirdShareFactory.m
//  supercinema
//
//  Created by mapollo91 on 19/4/17.
//
//

#import "ThirdShareFactory.h"
#import "QQShare.h"
#import "QQZoneShare.h"
#import "WechatShare.h"
#import "WechatFriendsShare.h"
#import "WeiboShare.h"

@interface ThirdShareFactory ()

@end

@implementation ThirdShareFactory

+(BaseShare *)getShareInstance:(shareType)shareType{
    
    BaseShare *instance;
    if(shareType == qqShare)
    {
        instance = [[QQShare alloc] init];
    }
    else if(shareType == qqZoneShare)
    {
        instance = [[QQZoneShare alloc] init];
    }
    else if(shareType == weixinShare)
    {
        instance = [[WechatShare alloc] init];
    }
    else if(shareType == weixinFriendsShare)
    {
        instance = [[WechatFriendsShare alloc] init];
    }
    else if(shareType == weiboShare)
    {
        instance = [[WeiboShare alloc] init];
    }
    return instance;
    
}

+(shareType)getShareType:(NSInteger)type
{
    switch (type)
    {
        case 0:
            return weixinShare;
        case 1:
            return weixinFriendsShare;
        case 2:
            return weiboShare;
        case 3:
            return qqShare;
        case 4:
            return qqZoneShare;
        default:
            return unknow;
    }

}

+(BOOL)checkIsInstallApp:(shareType)shareType
{
    if(shareType == qqShare)
    {
        if (![TencentOAuth iphoneQQInstalled])
        {
            [Tool showWarningTip:@"未安装QQ客户端"  time:1];
            return NO;
        }
    }
    else if(shareType == qqZoneShare)
    {
        if (![TencentOAuth iphoneQQInstalled])
        {
            [Tool showWarningTip:@"未安装QQ空间客户端"  time:1];
            return NO;
        }
    }
    else if(shareType == weixinShare)
    {
        if(![WXApi isWXAppInstalled])
        {
            [Tool showWarningTip:@"未安装微信客户端"  time:1];
            return NO;
        }
    }
    else if(shareType == weixinFriendsShare)
    {
        if(![WXApi isWXAppInstalled])
        {
            [Tool showWarningTip:@"未安装微信客户端"  time:1];
            return NO;
        }
    }
    else if(shareType == weiboShare)
    {
        if(![WeiboSDK isWeiboAppInstalled])
        {
            [Tool showWarningTip:@"未安装新浪微博客户端"  time:1];
            return NO;
        }
    }

    return YES;
}




@end
