//
//  SaveImageToAlbum.m
//  movikr
//
//  Created by Mapollo27 on 15/11/3.
//  Copyright © 2015年 movikr. All rights reserved.
//

#import "SaveImageToAlbum.h"
#include <CoreFoundation/CFBase.h>

@implementation SaveImageToAlbum

//
+(UIImage *)mergeImage:(OrderInfoModel*)orderInfo couponData:(NewsCouponInfoModel*)couponModel goodsData:(GoodsInfoModel*)goodsModel
{
    if(orderInfo)
    {
        //底图
        UIImage *downImage = [self changeImageSize:orderInfo couponData:couponModel];
        //影片头像圆图
        UIImage *topImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:orderInfo.onlineTickets.movie.movieLogoUrl] ]];
        UIImage *roundImage = [UIImage imageNamed:@"image_round.png"];
        UIGraphicsBeginImageContext(downImage.size);
        //Draw image2
        [downImage drawInRect:CGRectMake(0, 0, downImage.size.width, downImage.size.height)];
        //Draw image1
        [topImage drawInRect:CGRectMake(35, 350, 100, 100)];
        [roundImage drawInRect:CGRectMake(35, 350, 100, 100)];
    }
    else
    {
        //底图
        UIImage *downImage = [self changeImageSize:orderInfo couponData:couponModel];
        //影片头像圆图
        UIImage *topImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:couponModel.couponImgUrl]]];
        UIImage *roundImage = [UIImage imageNamed:@"image_round.png"];
        UIGraphicsBeginImageContext(downImage.size);
        //Draw image2
        [downImage drawInRect:CGRectMake(0, 0, downImage.size.width, downImage.size.height)];
        //Draw image1
        [topImage drawInRect:CGRectMake(35, 350, 100, 100)];
        [roundImage drawInRect:CGRectMake(35, 350, 100, 100)];

    }
   
    
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+(UIImage *)changeImageSize:(OrderInfoModel*)orderInfo couponData:(NewsCouponInfoModel*)couponModel
{
    UIImage *imageBase = [UIImage imageNamed:@"image_ablum.png"];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,imageBase.size.width, imageBase.size.height, 8, 4 * imageBase.size.width, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, imageBase.size.width, imageBase.size.height), imageBase.CGImage);
    
    CGFloat posx = 139;
    float   colorA=0.8f;
    //订单
    if (orderInfo)
    {
        //取票提示
        CTFrameDraw([self setTextBreakWrapp:orderInfo.onlineTickets.exchangeInfo
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 1230)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:27],context);
        NSArray *array = [Tool cutOrderAndTicket:orderInfo.onlineTickets.ticketKey];
        NSString *strOrder =@"";
        if ([array count] ==2 )
        {
            //strOrder = [NSString stringWithFormat:@"%@\n%@",array[0],array[1]];
            //取票码
            CTFrameDraw([self setTextBreakWrapp:[NSString stringWithFormat:@"%@",array[0]]
                                           rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 1160)
                                      fontColor:RGBA(0, 0, 0, 0.4) fontSize:27],context);
            
            CTFrameDraw([self setTextBreakWrapp:[NSString stringWithFormat:@"%@",array[1]]
                                           rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 1110)
                                      fontColor:RGBA(0, 0, 0, 0.4) fontSize:27],context);

        }
        else
        {
            strOrder = [NSString stringWithFormat:@"%@",array[0]];
            //取票码
            CTFrameDraw([self setTextBreakWrapp:[NSString stringWithFormat:@"%@",array[0]]
                                           rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 1160)
                                      fontColor:RGBA(0, 0, 0, 0.4) fontSize:27],context);
        }
       
        //电影名
        CTFrameDraw([self setTextBreakWrapp:orderInfo.onlineTickets.movie.movieTitle
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 970)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        //语言
        CTFrameDraw([self setTextBreakWrapp:orderInfo.onlineTickets.showtime.language
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 920)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:22],context);
        //厅
        CTFrameDraw([self setTextBreakWrapp:orderInfo.onlineTickets.hall.hallName
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 830)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        //电影院名称
        CTFrameDraw([self setTextBreakWrapp:orderInfo.onlineTickets.cinema.cinemaName
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 515)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        //地址
        CTFrameDraw([self setTextBreakWrapp:orderInfo.onlineTickets.cinema.cinemaAddress
                                       rect:CGRectMake(posx, 0, (IPhone4||IPhone5)?SCREEN_WIDTH*1.7f:SCREEN_WIDTH*1.3, 465)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:22],context);
        //客服中心
        CTFrameDraw([self setTextBreakWrapp:@"客服中心"
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 370)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        //热线电话
        CTFrameDraw([self setTextBreakWrapp:[Config getHotLineTel]
                                       rect:CGRectMake(510, 0, SCREEN_WIDTH*2, 370)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        //电话服务时间
        CTFrameDraw([self setTextBreakWrapp:[Config getHotLineTelTime]
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 325)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:22],context);
        //须知
        CTFrameDraw([self setTextBreakWrapp:@"购票提示\n1.影票售出后不退不换\n2.卖品售出后不退不换\n3.会员卡售出后不退不换"
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 225)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:22],context);
        //版本类型3d imax
        CTFrameDraw([self setTextBreakWrapp:orderInfo.onlineTickets.showtime.versionDesc
                                       rect:CGRectMake(240, 0, SCREEN_WIDTH*2, 920)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:22],context);
        //日期
        CTFrameDraw([self setTextBreakWrapp:[Tool returnTime:orderInfo.onlineTickets.showtime.startPlayTime format:@"MM月dd日"]
                                       rect:CGRectMake(580, 0, SCREEN_WIDTH*2, 970)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        //时间
        CTFrameDraw([self setTextBreakWrapp:[Tool returnTime:orderInfo.onlineTickets.showtime.startPlayTime format:@"HH:mm"]
                                       rect:CGRectMake(623, 0, SCREEN_WIDTH*2, 920)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        //播放属性
        if([orderInfo.onlineTickets.hall.hallFeatureCode length] > 0)
        {
            CTFrameDraw([self setTextBreakWrapp:orderInfo.onlineTickets.hall.hallFeatureCode
                                           rect:CGRectMake(580, 0, SCREEN_WIDTH*2, 830)
                                      fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        }
        
        NSString *strSeat=@"";
        for (int i = 0 ; i < [orderInfo.onlineTickets.seateNames count]; i++)
        {
            strSeat =[strSeat stringByAppendingString:[orderInfo.onlineTickets.seateNames objectAtIndex:i]];
            if (i==1)
            {
                strSeat =[strSeat stringByAppendingString:@"\n" ];
            }
            else
            {
                if ([ orderInfo.onlineTickets.seateNames[i]  length] == 4)
                    strSeat =[strSeat stringByAppendingString:IPhone4?@"\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t":@"\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t" ];
                else if ([ orderInfo.onlineTickets.seateNames[i]  length] == 5)
                    strSeat =[strSeat stringByAppendingString:IPhone4?@"\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t":@"\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t" ];
                else if ([ orderInfo.onlineTickets.seateNames[i]  length] == 6)
                    strSeat =[strSeat stringByAppendingString:IPhone4?@"\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t":@"\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t" ];
                else
                    strSeat =[strSeat stringByAppendingString:IPhone4?@"\t\t\t\t\t\t\t\t\t\t":@"\t\t\t\t\t\t\t\t\t\t\t" ];
            }
        }
        //座位图
        CTFrameDraw([self setTextBreakWrapp:strSeat rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 790)
                                  fontColor:RGBA(0, 0, 0, colorA)
                                   fontSize:27],context);
        //价格合计
        //orderInfo.onlineTickets.totalPrice = @255450;
        NSInteger nTotlePriceLength = 0;
        nTotlePriceLength =[[Tool PreserveTowDecimals:orderInfo.onlineTickets.totalPrice] length];
        if (nTotlePriceLength == 1)
        {
            if ([[Tool PreserveTowDecimals:orderInfo.onlineTickets.totalPrice] intValue] == 1)
                posx =643;
            else
                posx =638;
        }
        else if (nTotlePriceLength == 2)
        {
            posx =620;
        }
        else if (nTotlePriceLength == 3)
        {
            if ([[Tool PreserveTowDecimals:orderInfo.onlineTickets.totalPrice] intValue] < 10)
                posx =614;
            else
                posx =600;
        }
        else if (nTotlePriceLength == 4)
        {
            if ([[Tool PreserveTowDecimals:orderInfo.onlineTickets.totalPrice] intValue] < 100)
                 posx =592;
            else
                 posx =583;
        }
        else if (nTotlePriceLength == 5)
        {
            if ([[Tool PreserveTowDecimals:orderInfo.onlineTickets.totalPrice] intValue] < 1000)
                 posx =572;
            else
                 posx =565;
        }
        else
        {
            posx =555;
        }
        
        CTFrameDraw([self setTextBreakWrapp:[NSString stringWithFormat:@"￥%@",
                                             [Tool PreserveTowDecimals:orderInfo.onlineTickets.totalPrice]]
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 650)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:33],context);
        
        NSInteger nServicePriceLength = 0;
        nServicePriceLength =[[Tool PreserveTowDecimals:orderInfo.onlineTickets.serviceFee] length];
        if (nServicePriceLength == 1)
        {
                posx =543;
        }
        else if(nServicePriceLength == 2)
        {
            posx =530;
        }
        else if(nServicePriceLength == 3)
        {
            if ([[Tool PreserveTowDecimals:orderInfo.onlineTickets.serviceFee] intValue] <2 )
                posx =526;
            else
                posx =525;
        }
        NSLog(@"%@",orderInfo.onlineTickets.serviceFee);
        //服务费
        CTFrameDraw([self setTextBreakWrapp:[NSString stringWithFormat:@"含服务费%@元/张",
                                             [Tool PreserveTowDecimals:orderInfo.onlineTickets.serviceFee]]
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 600)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:22],context);
    }
    else
    {
        //取票提示
        CTFrameDraw([self setTextBreakWrapp:couponModel.exchangeDesc
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 1230)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:27],context);
        //取票码
        CTFrameDraw([self setTextBreakWrapp:[NSString stringWithFormat:@"ID:%@", couponModel.uniqueId]
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 1160)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:27],context);
        //小卖名
        CTFrameDraw([self setTextBreakWrapp:couponModel.couponName
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 970)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        //数量
        CTFrameDraw([self setTextBreakWrapp:[NSString stringWithFormat:@"%@%@",couponModel.quantity,couponModel.unit]
                                       rect:CGRectMake(640, 0, SCREEN_WIDTH*2, 970)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        //有效期
        CTFrameDraw([self setTextBreakWrapp:[NSString stringWithFormat:@"有效期至:%@\n",
                                             [Tool returnTime:couponModel.validEndDate format:@"yyyy年MM月dd日"]]
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 920)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        
        //电影院名称
        CTFrameDraw([self setTextBreakWrapp:couponModel.cinemaName
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 515)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        //地址
        CTFrameDraw([self setTextBreakWrapp:couponModel.cinemaAddress
                                       rect:CGRectMake(posx, 0, (IPhone4||IPhone5)?SCREEN_WIDTH*1.7f:SCREEN_WIDTH*1.3, 465)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:22],context);
        //客服中心
        CTFrameDraw([self setTextBreakWrapp:@"客服中心"
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 370)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        //热线电话
        CTFrameDraw([self setTextBreakWrapp:[Config getHotLineTel]
                                       rect:CGRectMake(510, 0, SCREEN_WIDTH*2, 370)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:27],context);
        //电话服务时间
        CTFrameDraw([self setTextBreakWrapp:[Config getHotLineTelTime]
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 325)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:22],context);
        //须知
        CTFrameDraw([self setTextBreakWrapp:@"购票提示\n1.影票售出后不退不换\n2.卖品售出后不退不换\n3.会员卡售出后不退不换"
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 225)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:22],context);
        //描述
        CTFrameDraw([self setTextBreakWrapp:couponModel.couponDesc
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 820)
                                  fontColor:RGBA(0, 0, 0, colorA)
                                   fontSize:27],context);
        // 提示
        CTFrameDraw([self setTextBreakWrapp:couponModel.useTip//@"友情提示:凭电影票，领取卖品"
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 600)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:22],context);
        //价格合计
        if ([[Tool PreserveTowDecimals:couponModel.totalPrice] length] == 2)
            posx =620;
        else
            posx =605;
        CTFrameDraw([self setTextBreakWrapp:[NSString stringWithFormat:@"￥%@",[Tool PreserveTowDecimals:couponModel.totalPrice]]
                                       rect:CGRectMake(posx, 0, SCREEN_WIDTH*2, 650)
                                  fontColor:RGBA(0, 0, 0, colorA) fontSize:33],context);
        //服务费
        CTFrameDraw([self setTextBreakWrapp:[NSString stringWithFormat:@"含服务费%@元/%@",
                                             [Tool PreserveTowDecimals:couponModel.servicePrice],couponModel.unit]
                                       rect:CGRectMake(530, 0, SCREEN_WIDTH*2, 600)
                                  fontColor:RGBA(0, 0, 0, 0.4) fontSize:22],context);
    }
    
    CGImageRef imgCombined = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *retImage = [UIImage imageWithCGImage:imgCombined];
    CGImageRelease(imgCombined);
    return retImage;
}
+(CFDictionaryRef) setFontSizeAndColor:(CGFloat) fontSize fontColor:(UIColor *)color
{
    CTFontRef ctfont = CTFontCreateWithName((CFStringRef)[UIFont systemFontOfSize:20].fontName, fontSize, NULL);
    CGColorRef ctColor = color.CGColor;
    CFStringRef keys[] = { kCTFontAttributeName,kCTForegroundColorAttributeName };
    CFTypeRef values[] = { ctfont,ctColor};
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    return attr;
}

+(CTFrameRef)setTextBreakWrapp:(NSString *)text rect:(CGRect)rect fontColor:(UIColor *)color fontSize:(CGFloat) fontSize
{
    CFStringRef ctStr = CFStringCreateWithCString(nil, [text UTF8String], kCFStringEncodingUTF8);
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;//换行模式
    CTTextAlignment alignment = kCTRightTextAlignment;//对齐方式
    float lineSpacing =20.0;//行间距
    CTParagraphStyleSetting paraStyles[3] =
    {
        {.spec = kCTParagraphStyleSpecifierLineBreakMode,.valueSize = sizeof(CTLineBreakMode), .value = (const void*)&lineBreakMode},
        {.spec = kCTParagraphStyleSpecifierAlignment,.valueSize = sizeof(CTTextAlignment), .value = (const void*)&alignment},
        {.spec = kCTParagraphStyleSpecifierLineSpacing,.valueSize = sizeof(CGFloat), .value = (const void*)&lineSpacing},
    };
    
    CTParagraphStyleRef style = CTParagraphStyleCreate(paraStyles,3);
    [attributedText addAttribute:(NSString*)(kCTParagraphStyleAttributeName) value:(id)style range:NSMakeRange(0,[text length])];
    CFRelease(style);
    CFAttributedStringRef attrString = CFAttributedStringCreate(NULL,ctStr, [self setFontSizeAndColor:fontSize fontColor:color]);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0),path,NULL);
    return frame;
}


@end
