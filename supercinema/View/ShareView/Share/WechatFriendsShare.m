//
//  WechatFriendsShare.m
//  supercinema
//
//  Created by mapollo91 on 19/4/17.
//
//

#import "WechatFriendsShare.h"

@implementation WechatFriendsShare

//分享图片
-(void)shareImage:(UIImage *)shareImage{
    if(![super checkIsInstall])
    {
        return;
    }
    [self sendShareToWeiChatOfNew:WXSceneTimeline shareImage:shareImage];
}

//分享内容
-(void)shareContent:(shareInfoModel *)shareInfo
{
    if(![super checkIsInstall])
    {
        return;
    }
    [self sendShareToWeiChatContent:shareInfo scence:WXSceneTimeline];
}

@end
