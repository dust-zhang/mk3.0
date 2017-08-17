//
//  WechatShare.m
//  supercinema
//
//  Created by mapollo91 on 19/4/17.
//
//

#import "WechatShare.h"

@implementation WechatShare

-(BOOL)checkIsInstall{
    if(![WXApi isWXAppInstalled])
    {
        [Tool showWarningTip:@"您未安装该应用程序" time:2];
        return NO;
    }
    return YES;
}

#pragma mark 分享图片
-(void)shareImage:(UIImage *)shareImage{
    if(![self checkIsInstall])
    {
        return;
    }
    
    [self sendShareToWeiChatOfNew:WXSceneSession shareImage:shareImage];
}

-(void)sendShareToWeiChatOfNew:(int)scence shareImage:(UIImage *)shareImage
{
    float multiple = 3.1;
    if (IPhone5 || IPhone6)
    {
        multiple = 2.5;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    if (scence == WXSceneSession)
    {
        //微信
        UIImage *thumbImage = [[UIImage alloc] init];
        thumbImage = [ImageOperation changeImageSize:shareImage scaleToSize:CGSizeMake(CGImageGetWidth(shareImage.CGImage)/multiple, CGImageGetHeight(shareImage.CGImage)/multiple)];
        [message setThumbImage:thumbImage];
    }
    else
    {
        //朋友圈
        UIImage *thumbImage = [[UIImage alloc] init];
        [message setThumbImage:thumbImage];
    }
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(shareImage,1);
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scence;
    [WXApi sendReq:req];
}

#pragma mark 分享内容
-(void)shareContent:(shareInfoModel *)shareInfo 
{
    if(![self checkIsInstall])
    {
        return;
    }
    
    [self sendShareToWeiChatContent:shareInfo scence:WXSceneSession];
}

-(void)sendShareToWeiChatContent:(shareInfoModel *)shareInfo scence:(int)scence
{
    /**** 组装数据 - star ****/
    WXMediaMessage *message = [WXMediaMessage message];
    //url
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareInfo._url;
    message.mediaObject = ext;
    //title
    message.title = shareInfo._title;
    //content
    message.description = shareInfo._content;
    //shareLogoUrl
//    NSData *dataLogoUrl =[shareInfo._shareLogoUrl dataUsingEncoding:NSUTF8StringEncoding];
//    UIImage *imageShareLogo = [UIImage imageWithData:dataLogoUrl];
    UIImage *imageShareLogo = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareInfo._shareLogoUrl]]];
    [message setThumbImage:imageShareLogo];
    /**** 组装数据 - end ****/
    
    //发送请求
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scence;
    [WXApi sendReq:req];
}

@end
