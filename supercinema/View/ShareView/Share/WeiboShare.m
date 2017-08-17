//
//  WeiboShare.m
//  supercinema
//
//  Created by mapollo91 on 19/4/17.
//
//

#import "WeiboShare.h"

@implementation WeiboShare

-(BOOL)checkIsInstall{
    if(![WeiboSDK isWeiboAppInstalled])
    {
        [Tool showWarningTip:@"您未安装该应用程序" time:2];
        return NO;
    }
    return YES;
}

-(void)shareImage:(UIImage *)shareImage{
    if(![self checkIsInstall])
    {
        return;
    }
    
    WBMessageObject *message = [WBMessageObject message];
    WBImageObject *image = [WBImageObject object];
    image.imageData = UIImagePNGRepresentation(shareImage);
    message.imageObject = image;
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    [WeiboSDK sendRequest:request];
}

@end
