//
//  QQZoneShare.m
//  supercinema
//
//  Created by mapollo91 on 19/4/17.
//
//

#import "QQZoneShare.h"

@implementation QQZoneShare

//分享图片
-(void)shareImage:(UIImage *)shareImage
{
    if(![super checkIsInstall])
    {
        return;
    }

    NSData *imgData = UIImageJPEGRepresentation(shareImage,1.0);
    
    NSArray *photoArray = [NSArray arrayWithObject:imgData];

    QQApiImageArrayForQZoneObject *img = [QQApiImageArrayForQZoneObject objectWithimageDataArray:photoArray
                                                                                           title:@""];
    img.shareDestType = AuthShareType_QQ;
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
}

//分享内容
-(void)shareContent:(shareInfoModel *)shareInfo
{
    if(![super checkIsInstall])
    {
        return;
    }
    
    QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareInfo._url]
                                                       title:shareInfo._title
                                                 description:shareInfo._content
                                             previewImageURL:[NSURL URLWithString:shareInfo._shareLogoUrl]];
    [imgObj setTitle:shareInfo._title ? : @""];
    [imgObj setCflag:kQQAPICtrlFlagQZoneShareOnStart]; //不要忘记设置这个flag
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

@end
