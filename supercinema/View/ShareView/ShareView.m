//
//  ShareViewController.m
//  movikr
//
//  Created by Mapollo25 on 15/6/1.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "ShareView.h"
#import "UIERealTimeBlurView.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>


//调用分享后，超过多长时间没有回调就算是分享成功
#define waitShareConfirmTimeLength  120
#define WeiBoScenceValue    1000
#define QQScenceValue    1001
#define QzoneScenceValue    1002
#define ButtonShareWeiboTag
static ShareView *GlobalShareView;

@implementation ShareView
{
    ///图标的高度
    CGFloat logoWidth;
    ///图标的宽度
    CGFloat logoHeight;
    //文字的高度
    CGFloat labelHeight;
    ///图标相对文字的间距
    CGFloat logoToLabelHeight;
    ///图片之间的间距
    CGFloat logoToLogoHeight;
    NSInteger currScence;
    
    NSTimer *shareConfirmTimer;
}

+(ShareView*)getShareInstance
{
    if(!GlobalShareView)
    {
        GlobalShareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    
    //NSLog(@"返回了分享对象的实例");
    
    return GlobalShareView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
        logoHeight=45;
        logoWidth=60;
        labelHeight=15;
        logoToLabelHeight=14;
        logoToLogoHeight=28;
        [self initShareCtrl];
    }
    return self;
}

-(void)initShareCtrl
{
//    //毛玻璃背景
//    UIERealTimeBlurView *viewBlue=[[UIERealTimeBlurView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+10)];
//    viewBlue.renderStatic=YES;
//    [self addSubview:viewBlue];
    
    XHRealTimeBlur* realTimeBlur = [[XHRealTimeBlur alloc] initWithFrame:self.bounds];
    realTimeBlur.blurStyle = XHBlurStyleTranslucent;
    realTimeBlur.hasTapGestureEnable = NO;
    [self addSubview:realTimeBlur];
    
    //分享到
    UILabel* labelShare = [[UILabel alloc]initWithFrame:CGRectMake(0, 386/2, SCREEN_WIDTH, 15)];
    labelShare.text = @"分享到";
    labelShare.textColor = RGBA(255, 255, 255, 0.7);
    labelShare.font = MKFONT(15);
    labelShare.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelShare];
    
    CGFloat space = (SCREEN_WIDTH - 75 - 50*3)/2;
    for (int i = 0; i < 6; i++)
    {
        _btnFrame[i] = CGRectMake(75/2+(50+space)*(i%3), labelShare.frame.origin.y+labelShare.frame.size.height+33+(50+75/2)*(i/3), 50, 50);
    }
    
    //微信
    _buttonWeiChat=[[UIButton alloc]initWithFrame:_btnFrame[0]];
    [_buttonWeiChat setImage:[UIImage imageNamed:@"button_share_weichat.png"] forState:UIControlStateNormal];
    _buttonWeiChat.backgroundColor=[UIColor clearColor];
    [_buttonWeiChat.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_buttonWeiChat addTarget:self action:@selector(touchUpShareToWeiChat:) forControlEvents:UIControlEventTouchUpInside];
    
    //微信朋友圈
    _buttonWeiChatFriend=[[UIButton alloc]initWithFrame:_btnFrame[1]];
    [_buttonWeiChatFriend setImage:[UIImage imageNamed:@"button_share_weichat_friend.png"] forState:UIControlStateNormal];
    _buttonWeiChatFriend.backgroundColor=[UIColor clearColor];
    [_buttonWeiChatFriend.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_buttonWeiChatFriend addTarget:self action:@selector(touchUpShareToFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    _buttonWeiChat.tag=1;
    _buttonWeiChatFriend.tag=2;
    _tagBtnWeiChatFriend = _buttonWeiChatFriend.tag;

    [self addSubview:_buttonWeiChat];
    [self addSubview:_buttonWeiChatFriend];
    
    //新浪微博
    _buttonWeiBo=[[UIButton alloc]initWithFrame:_btnFrame[2]];
    [_buttonWeiBo setImage:[UIImage imageNamed:@"button_share_weibo.png"] forState:UIControlStateNormal];
    _buttonWeiBo.backgroundColor=[UIColor clearColor];
    [_buttonWeiBo.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_buttonWeiBo addTarget:self action:@selector(touchUpShareToWeibo:) forControlEvents:UIControlEventTouchUpInside];

    _buttonWeiBo.tag = _tagBtnWeiChatFriend+1;
    _tagBtnWeiBo = _buttonWeiBo.tag;
    [self addSubview:_buttonWeiBo];
    
    //QQ好友
    _buttonQQ=[[UIButton alloc]initWithFrame:_btnFrame[4]];
    [_buttonQQ setImage:[UIImage imageNamed:@"button_share_qq_friend.png"] forState:UIControlStateNormal];
    _buttonQQ.backgroundColor=[UIColor clearColor];
    [_buttonQQ.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_buttonQQ addTarget:self action:@selector(touchUpShareToQQ:) forControlEvents:UIControlEventTouchUpInside];
    
    //QQ空间
    _buttonQQZone=[[UIButton alloc]initWithFrame:_btnFrame[3]];
    [_buttonQQZone setImage:[UIImage imageNamed:@"button_share_qzone.png"] forState:UIControlStateNormal];
    _buttonQQZone.backgroundColor=[UIColor clearColor];
    [_buttonQQZone.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_buttonQQZone addTarget:self action:@selector(touchUpShareToQQZone:) forControlEvents:UIControlEventTouchUpInside];
    
    _buttonQQ.tag=_tagBtnWeiBo+2;
    _buttonQQZone.tag=_tagBtnWeiBo+1;
    _tagBtnQQZone = _buttonQQ.tag;
    [self addSubview:_buttonQQ];
    [self addSubview:_buttonQQZone];
    
    //复制
    _buttonCopy=[[UIButton alloc]initWithFrame:_btnFrame[5]];
    [_buttonCopy setImage:[UIImage imageNamed:@"button_share_copy.png"] forState:UIControlStateNormal];
    _buttonCopy.backgroundColor=[UIColor clearColor];
    [_buttonCopy.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_buttonCopy addTarget:self action:@selector(touchUpCopy:) forControlEvents:UIControlEventTouchUpInside];
    _buttonCopy.tag=_buttonQQ.tag+1;
    [self addSubview:_buttonCopy];
    
    //返回按钮(左下角)
    UIButton *buttonClose = [[UIButton alloc] init];
    [buttonClose setImage:[UIImage imageNamed:@"img_movie_closeShare.png"] forState:UIControlStateNormal];
//    [buttonClose setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
    [buttonClose addTarget:self action:@selector(toucheUpClose) forControlEvents:UIControlEventTouchUpInside];
//    CGSize userBtnsize = CGSizeMake(53, 53);
//    CGFloat userBtnY = SCREEN_HEIGHT - userBtnsize.height - 10;
    [buttonClose setFrame:CGRectMake(15, 67/2, 17, 17)];
    buttonClose.backgroundColor=[UIColor clearColor];
    [self addSubview:buttonClose];
}

-(BOOL)checkIsInstallWX
{
    if(![WXApi isWXAppInstalled])
    {
        [Tool showWarningTip:@"未安装微信客户端"  time:1];
        return NO;
    }
    return YES;
}

-(BOOL)checkIsInstallWeiBo
{
    if(![WeiboSDK isWeiboAppInstalled])
    {
        [Tool showWarningTip:@"未安装新浪微博客户端"  time:1];
        return NO;
    }
    return YES;
}

-(BOOL)checkIsInstallQQ
{
    if (![TencentOAuth iphoneQQInstalled])
    {
        [Tool showWarningTip:@"未安装QQ客户端"  time:1];
        return NO;
    }
    return YES;
}

-(BOOL)checkIsInstallQQZone
{
    if (![TencentOAuth iphoneQQInstalled])
    {
        [Tool showWarningTip:@"未安装QQ空间客户端"  time:1];
        return NO;
    }
    return YES;
}

#pragma mark 微信
-(void)touchUpShareToWeiChat:(UIButton *)sender
{
    if(![self checkIsInstallWX])
    {
        return;
    }
    sender.enabled=NO;
    currScence=WXSceneSession;
    if(self.shareContentType==WeiChatShareContentTypeImage)
    {
        [self sendShareToWeiChatOfImage:WXSceneSession];
    }
    else
    {
        [self sendShareToWeiChatOfNew:WXSceneSession];
    }
    
    sender.enabled=YES;
}

#pragma mark 微信朋友圈
-(void)touchUpShareToFriend:(UIButton *)sender
{
    if(![self checkIsInstallWX])
    {
        return;
    }
    sender.enabled=NO;
    currScence=WXSceneTimeline;
    if(self.shareContentType==WeiChatShareContentTypeImage)
    {
        [self sendShareToWeiChatOfImage:WXSceneTimeline];
    }
    else
    {
        [self sendShareToWeiChatOfNew:WXSceneTimeline];
    }
    
    sender.enabled=YES;
}

#pragma mark 新浪微博
-(void)touchUpShareToWeibo:(UIButton*)sender
{
    if(![self checkIsInstallWeiBo])
    {
        return;
    }
    sender.enabled=NO;
    currScence=WeiBoScenceValue;
    [self messageToShare];
    sender.enabled=YES;
}

-(void)shareToWeibo:(WBMessageObject *) message
{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    [WeiboSDK sendRequest:request];
    
    [self autoCloseView];
    
    if (_buttonWeiBo)
    {
        _buttonWeiBo.enabled = YES;
    }
    //    UIButton *sender =(UIButton*)[self viewWithTag:ButtonShareWeiboTag];
    //    if(sender)
    //    {
    //        sender.enabled=YES;
    //    }
}

///构建分享到微浪微博的对象
- (void)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    self.shareTitle=[Tool clearSpaceAndNewline:self.shareTitle];
    self.shareDescription=[Tool clearSpaceAndNewline:self.shareDescription];
    if (self.shareTitle && self.shareTitle.length > 0 && self.shareDescription && self.shareDescription.length>0)
    {
        message.text = [NSString stringWithFormat:@"「%@」%@",self.shareTitle,self.shareDescription];
    }
    else if(self.shareTitle && self.shareTitle.length > 0)
    {
        message.text = [NSString stringWithFormat:@"「%@」",self.shareTitle];
    }
    else if(self.shareDescription && self.shareDescription.length>0)
    {
        message.text = [NSString stringWithFormat:@"%@",self.shareDescription];
    }
    NSInteger textLength = [Tool convertToInt:message.text];
    
    if(textLength>60)
    {
        NSLog(@"开始之前：%@",message.text);
        message.text =[NSString stringWithFormat:@"%@...",[message.text substringToIndex:60]];
        NSLog(@"截取之后：%@",message.text);
    }
    
    if(!message.text)
    {
        message.text=@"";
    }
    
    if(self.shareUrl&&self.shareUrl.length>0)
    {
        message.text=[NSString stringWithFormat:@"%@ 戳：%@ ",message.text,self.shareUrl];
    }
    
    message.text=[NSString stringWithFormat:@"%@%@",message.text, ShareToWeiboOfAccount];
    
    if(self.shareContentType==WeiChatShareContentTypeImage)
    {
        WBImageObject *image = [WBImageObject object];
        image.imageData = UIImagePNGRepresentation(self.shareImage);
        message.imageObject = image;
        [self shareToWeibo:message];
    }
    else if(self.shareContentType==WeiChatShareContentTypeNews&&self.shareImgUrl&&self.shareImgUrl.length>0)
    {
        WBImageObject *shareImage = [WBImageObject object];
        
        [self addTimer];
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.window withTitle:@"打开新浪微博中" withBlur:NO allowTap:NO];
        __weak typeof(self) weakSelf = self;
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:self.shareImgUrl]
                                                            options:0
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             [weakSelf killTimer];
             if (image && finished)
             {
                 [FVCustomAlertView hideAlertFromView:weakSelf.window fading:YES];
                 shareImage.imageData = UIImageJPEGRepresentation(image, 1.0);
                 message.imageObject = shareImage;
                 [weakSelf shareToWeibo:message];
             }else
             {
                 [Tool showWarningTip:@"分享失败，请重试" time:1.0 ];
             }
         }];
    }
    else
    {
        [self shareToWeibo:message];
    }
}

-(void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:5
                                              target:self
                                            selector:@selector(cancelLoading:)
                                            userInfo:nil
                                             repeats:NO];
    [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes
                             beforeDate:[NSDate dateWithTimeIntervalSinceNow:ORDERRUNMAXTIME]];
}

-(void)cancelLoading:(NSTimer*)timer
{
    [Tool showWarningTip:@"分享失败，请重试" time:1.0];
    //取消下载
    [[SDWebImageDownloader sharedDownloader] cancelAllDownloads];
    [self killTimer];
}

-(void) killTimer
{
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma 复制
-(void)touchUpCopy:(UIButton *)sender
{
    if ([self.shareUrl length] == 0)
    {
        [Tool showWarningTip:@"复制失败" time:2.0];
    }
    else
    {
        [Tool showSuccessTip:@"复制成功" time:2.0];
        UIPasteboard *pastboard=[UIPasteboard generalPasteboard];
        pastboard.string=self.shareUrl;
    }
    [self toucheUpClose];
}

#pragma mark QQ分享
-(void)touchUpShareToQQ:(UIButton *)sender
{
    if(![self checkIsInstallQQ])
    {
        return;
    }
    sender.enabled=NO;
    currScence=QQScenceValue;
    if(self.shareContentType==WeiChatShareContentTypeImage)
    {
        [self sendShareToQQOfImage:QQScenceValue];
    }
    else
    {
        [self sendShareToQQOfNew:QQScenceValue];
    }
    sender.enabled = YES;
}

#pragma mark QQ空间
-(void)touchUpShareToQQZone:(UIButton *)sender
{
    if(![self checkIsInstallQQZone])
    {
        return;
    }
    sender.enabled=NO;
    currScence=QzoneScenceValue;
    if(self.shareContentType==WeiChatShareContentTypeImage)
    {
        [self sendShareToQQOfImage:QzoneScenceValue];
    }
    else
    {
        [self sendShareToQQOfNew:QzoneScenceValue];
    }
    sender.enabled = YES;
}

//QQ图片分享
-(void)sendShareToQQOfImage:(int)scence
{
    self.shareDescription=[Tool clearSpaceAndNewline:self.shareDescription];
    NSInteger textLength = [Tool convertToInt:self.shareDescription];
    if(textLength>50)
    {
        self.shareDescription =[NSString stringWithFormat:@"%@...",[self.shareDescription substringToIndex:50]];
    }
    
    NSString *qqShareTitle;
    if(self.imageTitle&&self.imageTitle.length>0)
    {
        qqShareTitle = self.imageTitle;
    }
    else
    {
        qqShareTitle = shareImageToWeixinDefaultImageTitle;
    }
    NSData *imgData = UIImageJPEGRepresentation(self.shareImage,1.0);
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:self.shareUrl]
                                title: qqShareTitle
                                description:nil
                                previewImageData:imgData];
    newsObj.shareDestType = ShareDestTypeQQ;
    
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                               previewImageData:imgData
                                                          title:qqShareTitle
                                                    description:self.shareDescription];
    imgObj.shareDestType = ShareDestTypeQQ;
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode sent;
    if (scence == QQScenceValue)
    {
        sent = [QQApiInterface sendReq:req];
        [self startShareConfim];
        [self autoCloseView];
        [self handleSendResult:sent];
    }
    if (scence == QzoneScenceValue)
    {
        req = [SendMessageToQQReq reqWithContent:newsObj];
        sent = [QQApiInterface SendReqToQZone:req];
        [self startShareConfim];
        [self autoCloseView];
        [self handleSendResult:sent];
    }
}

//QQ分享新闻
-(void)sendShareToQQOfNew:(int)scence
{
    self.shareDescription=[Tool clearSpaceAndNewline:self.shareDescription];
    NSInteger textLength = [Tool convertToInt:self.shareDescription];
    if(textLength>=50)
    {
        self.shareDescription =[NSString stringWithFormat:@"%@...",[self.shareDescription substringToIndex:50]];
    }
    //判断是否分享包含图片
    if(self.shareImgUrl.length>0)
    {
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:[NSURL URLWithString:self.shareUrl]
                                    title: self.shareTitle.length>0?self.shareTitle:@" "
                                    description:self.shareDescription.length>0?self.shareDescription:nil
                                    previewImageURL:[NSURL URLWithString:self.shareImgUrl]];
        newsObj.shareDestType = ShareDestTypeQQ;
        
        //将内容分享到qq
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        QQApiSendResultCode sent;
        if (scence == QQScenceValue)
        {
            sent = [QQApiInterface sendReq:req];
            [self startShareConfim];
            [self autoCloseView];
            [self handleSendResult:sent];
        }
        if (scence == QzoneScenceValue)
        {
            sent = [QQApiInterface SendReqToQZone:req];
            [self autoCloseView];
            [self handleSendResult:sent];
        }
    }
    else
    {
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:[NSURL URLWithString:self.shareUrl]
                                    title: self.shareTitle.length>0?self.shareTitle:@" "
                                    description:self.shareDescription.length>0?self.shareDescription:nil
                                    previewImageData:UIImagePNGRepresentation([UIImage imageNamed:@"image_share_weichat_defaut.png"])
                                    ];
        newsObj.shareDestType = ShareDestTypeQQ;
        
        //将内容分享到qq
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        QQApiSendResultCode sent;
        if (scence == QQScenceValue)
        {
            sent = [QQApiInterface sendReq:req];
            [self startShareConfim];
            [self autoCloseView];
            [self handleSendResult:sent];
        }
        if (scence == QzoneScenceValue)
        {
            sent = [QQApiInterface SendReqToQZone:req];
            [self startShareConfim];
            [self autoCloseView];
            [self handleSendResult:sent];
        }
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            //            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            //[msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        default:
        {
            break;
        }
    }
}


/**
 *  获取分享到微信的对象
 *
 *  @return 分享的内容可能是包含图片或者纯文本的，所以返回的是基类
 */
-(void)sendShareToWeiChatOfNew:(int) scence
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.scene=scence;
    WXMediaMessage *message = [WXMediaMessage message];
    if([self.imageType isEqualToString:@"game"] && scence == 1)
    {
        message.title = self.shareDescription;
        message.description = self.shareTitle;
    }
    else
    {
        message.title = self.shareTitle;
        message.description = self.shareDescription;
    }
    //    NSLog(@"%@\n%@",self.shareTitle,self.shareDescription);
    
    NSString* strType;
    if (scence == WXSceneSession)
    {
        strType = @"打开微信中";
    }
    else
    {
        strType = @"正在分享朋友圈";
    }
    
    //判断是否分享包含图片
    if(self.shareImgUrl.length > 0)
    {
        [self addTimer];
        [FVCustomAlertView showDefaultLoadingAlertOnView:self withTitle:strType withBlur:NO allowTap:NO];
        __weak typeof(self) weakSelf = self;
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:self.shareImgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
        }completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             [weakSelf killTimer];
             if (image&&finished)
             {
                 [FVCustomAlertView hideAlertFromView:weakSelf fading:YES];
                 UIImage *newImage = [ImageOperation changeImageSize:image scaleToSize:CGSizeMake(180, 180)];
                 [message setThumbImage:newImage];
                 
                 WXWebpageObject *ext=[WXWebpageObject object];
                 ext.webpageUrl=self.shareUrl;
                 message.mediaObject=ext;
                 
                 req.message=message;
                 req.bText=NO;
                 [WXApi sendReq:req];
                 if(scence==WXSceneSession)
                 {
                     [weakSelf startShareConfim];
                 }
                 [weakSelf autoCloseView];
             }
             else
             {
                 [Tool showWarningTip:@"分享失败，请重试" time:1.0 ];
             }
         }];
    }
    else
    {
        UIImage *image=[UIImage imageNamed:@"image_share_weichat_defaut.png"];
        [message  setThumbImage:image];
        
        WXWebpageObject *ext=[WXWebpageObject object];
        ext.webpageUrl=self.shareUrl;
        message.mediaObject=ext;
        
        req.message=message;
        req.bText=NO;
        [WXApi sendReq:req];
        
        if(scence==WXSceneSession)
        {
            [self startShareConfim];
        }
        [self autoCloseView];
    }
}

/**
 *  图片分享到微信
 *
 *  @param scence
 */
-(void)sendShareToWeiChatOfImage:(int)scence
{
    WXMediaMessage *message = [WXMediaMessage message];
    //    UIImage* thumbImage =[UIImage imageWithData:UIImageJPEGRepresentation(self.shareImage, 1.0)];
    //    if(thumbImage.size.width>280)
    //    {
    //        thumbImage=[ImageOperation changeImageSize:thumbImage scaleToSize:CGSizeMake(280,thumbImage.size.height/thumbImage.size.width*280)];
    //    }
    self.thumbImage = [ImageOperation changeImageSize:self.thumbImage scaleToSize:CGSizeMake(200,self.thumbImage.size.height/self.thumbImage.size.width*200)];
    
    if(self.imageTitle&&self.imageTitle.length>0)
    {
        message.title=self.imageTitle;
    }
    else
    {
        message.title=shareImageToWeixinDefaultImageTitle;
    }
    [message setThumbImage:self.thumbImage];
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(self.shareImage, 1.0);
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scence;
    
    [WXApi sendReq:req];
    
    if(scence==WXSceneSession)
    {
        [self startShareConfim];
    }
    
    [self autoCloseView];
    
}

-(void)autoCloseView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self toucheUpClose];
    });
}

-(void)toucheUpClose
{
    [self.shareDelegate touchUpCloseShare];
}


#pragma mark 增加分享统计
-(void)addShareCount
{
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *shareContentTypeOfString;
    if(self.shareObjectType==ShareContentTypeOfActivity)
    {
        shareContentTypeOfString=@"activity";
    }
    else if(self.shareObjectType==ShareContentTypeOfArticle)
    {
        shareContentTypeOfString=@"article";
    }
    else if(self.shareObjectType==ShareContentTypeOfTopicImage)
    {
        shareContentTypeOfString=@"topic";
    }
    else
    {
        shareContentTypeOfString=@"";
    }
    
    NSString *shareTarget;
    switch (currScence)
    {
        case WXSceneSession:
            shareTarget=@"WXSceneSession";
            break;
        case WXSceneTimeline:
            shareTarget=@"WXSceneTimeline";
            break;
        case WeiBoScenceValue:
            shareTarget=@"weibo";
            break;
        case QQScenceValue:
            shareTarget=@"qq";
            break;
        case QzoneScenceValue:
            shareTarget=@"qq.qzone";
            break;
        default:
        {
            NSLog(@"无法找到share target");
            shareTarget=@"";
        }
            break;
    }
    NSDictionary *b = @{@"content_type":shareContentTypeOfString,
                        @"id":[[NSNumber alloc]initWithInteger:self.shareObjectId],
                        @"target":shareTarget};
   [MKNetWorkRequest POST:URL_CONTENTSHARE parameters:b success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSDictionary *head = [responseObject objectForKey:@"h"];
         NSNumber *s = [head objectForKey:@"s"];
         int statusCode = [s intValue];
         if (statusCode != 200) {
             NSLog(@"分享次数失败");
         }else{
             NSLog(@"分型次数增加成功");
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         //         NSLog(@"Require Error: %@\nresponseContent:%@", error,operation.responseString);
     }];
}


-(void)startShareConfim
{
    [self endShareConfirm];
    shareConfirmTimer=[NSTimer scheduledTimerWithTimeInterval:waitShareConfirmTimeLength
                                                       target:self
                                                     selector:@selector(autoAddShareCount)
                                                     userInfo:nil
                                                      repeats:NO];
}

-(void)endShareConfirm
{
    if (shareConfirmTimer != nil)
    {
        [shareConfirmTimer invalidate];
        shareConfirmTimer = nil;
        NSLog(@"成销毁计时器");
    }
    else
    {
        NSLog(@"找不到计时器，不需要销毁");
    }
}

-(void)autoAddShareCount
{
    if(shareConfirmTimer)
    {
        NSLog(@"进入了自动增加分享的函数");
        [self endShareConfirm];
        [self addShareCount];
    }
    else
    {
        NSLog(@"无法自动去分享");
    }
}

//#pragma mark 微信、QQ回调
-(void) onResp:(NSObject*)resp
{
    //QQ回调
    if([resp isKindOfClass:[SendMessageToQQResp class]])
    {
        SendMessageToQQResp* qqResp = (SendMessageToQQResp*)resp;
        [self endShareConfirm];
        if([qqResp.result isEqualToString:@"0"])
        {
            [self addShareCount];
        }
        else
        {
            NSLog(@"分享取消了：code:%@",qqResp.errorDescription);
        }
    }
}

-(void)onResponse:(NSObject*)response
{
    //微信分享回调
    if([response isKindOfClass:[SendMessageToWXResp class]])
    {
        SendMessageToWXResp* wxResp = (SendMessageToWXResp*)response;
        [self endShareConfirm];
        if(wxResp.errCode == WXSuccess)
        {
            [self addShareCount];
        }
        else
        {
            NSLog(@"分享取消了：code:%d",wxResp.errCode);
        }
    }
    //微信登录回调
    if([response isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp* wxResp = (SendAuthResp*)response;
        if (wxResp.code.length>0)
        {
            [self getAccess_token:wxResp.code];
        }
        else
        {
            if ([self.shareDelegate respondsToSelector:@selector(thirdLoginFailed)])
            {
                [self.shareDelegate thirdLoginFailed];
            }
        }
    }
}

-(void)getAccess_token:(NSString*)code
{
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",backWeChatPayAppId,weChatAppSecret,code];
    
    NSURL *zoneUrl = [NSURL URLWithString:url];
    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
    if (data)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *token = [NSString stringWithFormat:@"%@",[dic objectForKey:@"access_token"]];
        NSString *unionId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unionid"]];
        NSInteger authorizeStatus = 1;
        
        if ([self.shareDelegate respondsToSelector:@selector(thirdLoginSucceed:unionId:loginType:authorizeStatus:)])
        {
            [self.shareDelegate thirdLoginSucceed:token unionId:unionId loginType:1 authorizeStatus:authorizeStatus];
        }
        [self getUserInfo:dic];
    }
    else
    {
        if ([self.shareDelegate respondsToSelector:@selector(thirdLoginFailed)])
        {
            [self.shareDelegate thirdLoginFailed];
        }
    }
}

-(void)getUserInfo:(NSDictionary*)dict
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",[dict objectForKey:@"access_token"],[dict objectForKey:@"openid"]];
    NSURL *zoneUrl = [NSURL URLWithString:url];
    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
    if (data)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
    }
    
}

- (void)onReq:(QQBaseReq *)req
{
    
}

#pragma mark 新浪微博登录
+(void)weiboThirdLogin
{
    [[ShareView getShareInstance] authorizeWeiboAccount];
}

#pragma mark QQ登录
+(void)QQLogin
{
    [[ShareView getShareInstance] authorizeQQAcount];
}

#pragma mark 微信登录
+(void)weixinLogin
{
    [[ShareView getShareInstance] authorizeWeixinAcount];
}

-(void)authorizeWeiboAccount
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

-(void)authorizeQQAcount
{
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:regitserTencentAppId andDelegate:(id)self];
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    [_tencentOAuth setAuthShareType:AuthShareType_QQ];
    [_tencentOAuth authorize:permissions inSafari:NO];
}

-(void)authorizeWeixinAcount
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

#pragma mark 新浪微博回调
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if((int)response.statusCode==WeiboSDKResponseStatusCodeSuccess)
        {
            [self addShareCount];
        }
        else if((int)response.statusCode==WeiboSDKResponseStatusCodeUserCancel)
        {
            NSLog(@"用户取消了分享");
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
            NSLog(@"%@",message);
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        if (response.statusCode==WeiboSDKResponseStatusCodeSuccess)
        {
            NSString *token = [NSString stringWithFormat:@"%@",[(WBAuthorizeResponse *)response accessToken]];
            NSString *unionId = [NSString stringWithFormat:@"%@",[(WBAuthorizeResponse *)response userID]];
            NSInteger authorizeStatus = 1;
            if ([self.shareDelegate respondsToSelector:@selector(thirdLoginSucceed:unionId:loginType:authorizeStatus:)])
            {
                [self.shareDelegate thirdLoginSucceed:token unionId:unionId loginType:2 authorizeStatus:authorizeStatus];
            }
            
        }
        else
        {
            if ([self.shareDelegate respondsToSelector:@selector(thirdLoginFailed)])
            {
                [self.shareDelegate thirdLoginFailed];
            }
        }
    }
}

#pragma mark QQ登录回调
-(void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        NSString *token = _tencentOAuth.accessToken;
        NSString *unionId = _tencentOAuth.openId;
        NSInteger authorizeStatus = 1;
        //  记录登录用户的OpenID、Token以及过期时间
        if ([self.shareDelegate respondsToSelector:@selector(thirdLoginSucceed:unionId:loginType:authorizeStatus:)])
        {
            [self.shareDelegate thirdLoginSucceed:token unionId:unionId loginType:3 authorizeStatus:authorizeStatus];
        }
    }
    else
    {
        if ([self.shareDelegate respondsToSelector:@selector(thirdLoginFailed)])
        {
            [self.shareDelegate thirdLoginFailed];
        }
    }
}

//登录失败
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if ([self.shareDelegate respondsToSelector:@selector(thirdLoginFailed)])
    {
        [self.shareDelegate thirdLoginFailed];
    }
}

//登录时网络有问题的回调
-(void)tencentDidNotNetWork
{
    if ([self.shareDelegate respondsToSelector:@selector(thirdLoginFailed)])
    {
        [self.shareDelegate thirdLoginFailed];
    }
}

@end
