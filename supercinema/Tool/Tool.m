//
//  Tool.m
//  movikr
//
//  Created by zeyuan on 15/5/27.
//  Copyright (c) 2015年 zeyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSStringURLEncoding.h"
#import "NSData+ImageContentType.h"

@implementation Tool


/**
 *  时间转字符串转
 *
 *  @param date NSDate
 *  @param format 格式
 *
 *  @return 返回字符串
 */
+(NSString*) dateToString:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

/************************************************************************
 功能：异或加密，返回加密后的字符串
 参数：str 要加密字符串,k密钥
 *************************************************************************/
+ (NSString *)xor:(NSString *)src key:(NSString *)key
{
    if (src.length == 0 || key.length == 0) {
        return nil;
    }
    const char *srcchar = [src UTF8String];
    const char *keychar = [key UTF8String];
	
    NSString *result = [[NSString alloc] init];
    int pan, pin;
	int j = 0;
    for (int i = 0; i < src.length; i++)
    {
		pan = srcchar[i];
		pin = keychar[j++ % key.length];
        result = [result stringByAppendingString:[NSString stringWithFormat:@"%0.2X",pan^pin]];
    }
    return result;
}

+ (int)charToint:(char)theChar
{
    if (theChar >= '0' && theChar <='9')
    {
        return theChar - '0';
    }
    else if (theChar >= 'A' && theChar <= 'F')
    {
        return theChar - 'A' + 10;
    }
    return 0;
}


/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (CGSize) CalcString:(NSString *)value fontSize:(UIFont *)fontSize andWidth:(float)width
{
    CGSize sizeToFit =[self boundingRectWithSize:value
                                        textFont:fontSize
                                        textSize:CGSizeMake(width, CGFLOAT_MAX)];
    return sizeToFit;
}

+ (CGSize)boundingRectWithSize:(NSString *)text textFont:(UIFont *)font textSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
}

//计算文字宽度
+(CGFloat) calStrWidth:(NSString *)value height:(CGFloat)height
{
    CGSize size = [self boundingRectWithSize:value textFont:MKFONT(height) textSize:CGSizeMake(MAXFLOAT, height)];
    return size.width;
}

/**
 @method    自动计算控件长度（评论条数使用）
 @param     text 待计算的字符串
 @result    返回控件长度
 */
+(float) calcCtrlLength:(NSString*)text
{
    if([text length] == 1)
        return 20;
    else if ([text length] == 2)
        return 25;
    else if([text length] > 2)
        return [text length]*10.0f;
    
    return 0;
}


/**
 *  获取系统版本号
 *
 *  @return 单精度版本号
 */
+(NSString *) getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //NSLog(@"%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]);
    return  [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}


/**
 *  是否为闰年
 *
 *  @return 是闰年返回TRUE，不是则返回FALSE
 */
+(BOOL) isLeapYear:(NSInteger)year
{
    if ((year % 4  == 0 && year % 100 != 0)  || year % 400 == 0)
        return TRUE;
    else
        return FALSE;
}

/**
 *  计算字符串的字数
 */
+(int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p)
        {
            p++;
            strlength++;
        }
        else
        {
            p++;
        }
    }
    
    //"一"这个字符统计有问题
    int hasSpecialCount=0;
    for (NSInteger i=0; i<strtemp.length; i++)
    {
        NSString *currChar = [strtemp substringWithRange:NSMakeRange(i, 1)];
        if([currChar isEqualToString:@"一"])
        {
            hasSpecialCount++;
        }
    }
    return (strlength+1+hasSpecialCount)/2;
}

/**
 *  计算字符串的字符数(精确字符数)
 */
+(int)unicodeLengthOfString:(NSString*)strtemp
{
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p)
        {
            p++;
            strlength++;
        }
        else
        {
            p++;
        }
    }
    return strlength;
    
}

/**
 *  截取指定字符串
 *  @param  str 原始字符串
 *          starString，从哪个字符开始截取
 *          endString，到哪个字符结束
 *  @return 返回截取的字符串
 */
+(NSString *) cutString:(NSString*) str star:(NSString*) starString end:(NSString*)endString
{
    NSLog(@"%@",str);
    NSRange start = [str rangeOfString:starString];
    NSRange end = [str rangeOfString:endString];
    return  [str substringWithRange:NSMakeRange(start.location+1, end.location-start.location-1)];
}

/**
 *  替换字符串中的emoji表情
 */
+ (NSString *)disableEmoji:(NSString *)text
{
    __block BOOL returnValue = NO;
    __block NSMutableArray *emojiList=[[NSMutableArray alloc]init];
    
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                             options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                            [emojiList addObject:substring];
                                        }
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff)
                                    {
                                        returnValue = YES;
                                        [emojiList addObject:substring];
                                    }
                                    else if (0x2B05 <= hs && hs <= 0x2b07)
                                    {
                                        returnValue = YES;
                                        [emojiList addObject:substring];
                                    }
                                    else if (0x2934 <= hs && hs <= 0x2935)
                                    {
                                        returnValue = YES;
                                        [emojiList addObject:substring];
                                    }
                                    else if (0x3297 <= hs && hs <= 0x3299)
                                    {
                                        returnValue = YES;
                                        [emojiList addObject:substring];
                                    }
                                    else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
                                    {
                                        returnValue = YES;
                                        [emojiList addObject:substring];
                                    }
                                }
                            }];
    if(returnValue)
    {
        for (NSString *emoji in emojiList)
        {
            text=[text stringByReplacingOccurrencesOfString:emoji withString:@""];
        }
    }
    return text;
}


+(void) showWarningTip:(NSString *) message time:(float) delayTime
{
    if([message isEqualToString:@"未能找到使用指定主机名的服务器。"])
    {
        message = @"似乎已断开与互联网的连接";
    }
    if ([message isEqualToString:@"NSURLErrorDomain"])
    {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [FVCustomAlertView hideAlertFromView:window fading:NO];
    [FVCustomAlertView showDefaultWarningAlertOnView:window withTitle:message withBlur:NO allowTap:YES];
    [self performSelector:@selector(hideWarningTip:) withObject:window afterDelay:delayTime];
}
+(void)hideWarningTip:(UIWindow*)window
{
    UIWindow *window1 = [UIApplication sharedApplication].keyWindow;
    [FVCustomAlertView hideAlertFromView:window1 fading:NO];
}
//跟随view显示隐藏，生命周期跟view相同
+(void) showWarningTipForView:(NSString *) message time:(float) delayTime view:(UIView *)view
{
    [FVCustomAlertView hideAlertFromView:view fading:NO];
    [FVCustomAlertView showDefaultWarningAlertOnView:view withTitle:message withBlur:NO allowTap:YES];
    [self performSelector:@selector(hideWarningTipForView:) withObject:view afterDelay:delayTime];
}

+(void)hideWarningTipForView:(UIView *)view
{
    [FVCustomAlertView hideAlertFromView:view fading:NO];
}


+(void) showSuccessTip:(NSString *) message time:(float) delayTime
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [FVCustomAlertView hideAlertFromView:window fading:NO];
    [FVCustomAlertView showDefaultDoneAlertOnView:window withTitle:message withBlur:NO allowTap:YES];
    [self performSelector:@selector(hideSuccessTip:) withObject:window afterDelay:delayTime];
}

+(void)hideSuccessTip:(UIWindow*)window
{
    [FVCustomAlertView hideAlertFromView:window fading:NO];
}

+(void) showSuccessTip:(NSString *) message time:(float) delayTime view:(UIView *)view
{
    [FVCustomAlertView hideAlertFromView:view fading:NO];
    [FVCustomAlertView showDefaultDoneAlertOnView:view withTitle:message withBlur:NO allowTap:YES];
    [self performSelector:@selector(hideVIewSuccessTip:) withObject:view afterDelay:delayTime];
}

+(void)hideVIewSuccessTip:(UIView *)view
{
    [FVCustomAlertView hideAlertFromView:view fading:NO];
}



///获取设备的宽度(根据该宽度来获取图片的宽度，不一定和设备的宽度一致)
+(NSInteger)getLoadImageDeviceWidth
{
    return  SCREEN_WIDTH*2;
}

+(void) setLabelSpacing:(UILabel*)label spacing:(float)spacing alignment:(NSTextAlignment)alignment
{
    if ([label.text length] <= 0 )
    {
        label.text = @"";
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];//调整行间距
    [paragraphStyle setAlignment:alignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    label.attributedText = attributedString;
    if (alignment == NSTextAlignmentLeft)
    {
        [label sizeToFit];
    }
}


+(NSString *)MosaicString:(NSString *)originalString replaceString:(NSString *)rString
{
    return  [[ originalString substringToIndex:[originalString length]-[rString length]] stringByAppendingString:rString];
}

///获取新闻详细页的URL
+(NSString*)getArticleDetailUrl:(NSString*)baseUrl articleId:(NSInteger)articleId isClient:(BOOL)isClient sourceName:(NSString*)sourceName actionId:(NSInteger)actionId
{
    
    if(isClient)
    {
        NSString *credential=[Config getCredential];
        if(credential&&credential.length){
            credential=[[NSString stringWithFormat:@"%@", credential]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        else
        {
            credential=@"";
        }
        
        return [NSString  stringWithFormat:@"%@&isclient=1&c=%@&actionSource=%@&actionId=%ld",baseUrl,credential,sourceName,(long)actionId];
    }
    else
    {
        return [NSString  stringWithFormat:@"%@&isclient=0&user_id=%@&actionSource=%@&actionId=%ld",baseUrl,[Config getUserId],sourceName,(long)actionId];
    }
}

+(BOOL) imageIsGif:(NSString *)imageUrl
{
    if ([imageUrl length] <10)
    {
        return FALSE;
    }
//    NSLog(@"------%@",[imageUrl substringWithRange:NSMakeRange([imageUrl length]-7,3)] );

    if ([ [imageUrl substringWithRange:NSMakeRange([imageUrl length]-7,3)] isEqualToString:@"gif"])
        return TRUE;
    else
        return FALSE;
}

///清除文本里面的换行和空格字符
+(NSString*)clearSpaceAndNewline:(NSString*)oldStr
{
    if(oldStr&&oldStr.length>0)
    {
        NSString* newStr=@"";
        //去除掉首尾的空白字符和换行字符
        newStr = [oldStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        newStr = [newStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        newStr = [newStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        return newStr;
    }
    else
    {
        return @"";
    }
}

+(NSString *)urlIsNull:(NSString *)url
{
    if([Tool isBlankString:url])
    {
        return @"";
    }
    else
    {
        return url;
    }
}

+(BOOL) isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    if ([string isEqualToString:@"(null)"])
    {
        return YES;
    }
    return NO;
}

+ (NSString *)convertTime:(NSInteger)time
{
    if (time <=0)
    {
        return @"";
    }
    NSInteger minute = time /60;
    NSInteger second = time %60;
    NSString *minStr;
    NSString *secondStr;
    if (minute <10)
    {
        minStr = [NSString stringWithFormat:@"0%@",@(minute)];
    }
    else
    {
        minStr = [NSString stringWithFormat:@"%@",@(minute)];
    }
    if (second <10)
    {
        secondStr = [NSString stringWithFormat:@"0%@",@(second)];
    }
    else
    {
        secondStr = [NSString stringWithFormat:@"%@",@(second)];
    }
    return [NSString stringWithFormat:@"%@:%@",minStr,secondStr];
}

+(NSString *)returnTime:(NSNumber*)time format:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSDate *timeSp = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000];
    NSString *strTime = [dateFormatter stringFromDate: timeSp];
    return strTime;
}

+(NSNumber *)returnTimestamp:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *datenow = [dateFormatter dateFromString:time];
    return  [NSNumber numberWithInt:[[NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]] intValue]] ;
}
+(NSString *)returnWeek:(NSNumber*)time
{
    NSDate *timeSp = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:timeSp];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

+(NSString *)returnWeekFullName:(NSNumber*)time
{
    NSDate *timeSp = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:timeSp];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+(NSString *) returnStringPlus:(NSArray*)arr
{
    if ([arr count] == 0)
    {
        return @"";
    }
    if ([arr count] ==1)
    {
        return arr[0];
    }
    if ([arr count] ==2)
    {
        return [NSString stringWithFormat:@"%@,%@",arr[0],arr[1] ];
    }
    if ([arr count] ==3)
    {
        return [NSString stringWithFormat:@"%@,%@,%@",arr[0],arr[1] ,arr[2]];
    }
    if ([arr count] ==4)
    {
        return [NSString stringWithFormat:@"%@,%@,%@,%@",arr[0],arr[1],arr[2],arr[3] ];
    }
    return @"";
}

+(NSTimeInterval)calcTimeLength:(NSNumber *)endTime
{
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateEnd=[dateFormatter dateFromString:[Tool returnTime:endTime format:@"yyyy-MM-dd HH:mm:ss"]];
    
    NSTimeInterval timeCount =[dateEnd timeIntervalSinceDate:today];
    
    return timeCount;
}

+(NSTimeInterval)calcSysTimeLength:(NSNumber *)endTime SysTime:(NSNumber *)sysTime
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateEnd=[dateFormatter dateFromString:[Tool returnTime:endTime format:@"yyyy-MM-dd HH:mm:ss"]];
    NSDate *sysdateTime=[dateFormatter dateFromString:[Tool returnTime:sysTime format:@"yyyy-MM-dd HH:mm:ss"]];
    
    NSTimeInterval timeCount =[dateEnd timeIntervalSinceDate:sysdateTime];
    
    return timeCount;
}

+(NSString *)PreserveTowDecimals:(NSNumber *)OriginalString
{
    NSString *strResult = [NSString stringWithFormat:@"%.2f",[OriginalString floatValue]/100 ];

    if ([[strResult substringFromIndex:[strResult length]-3] isEqualToString:@".00"])
    {
         return [NSString stringWithFormat:@"%.f",[OriginalString floatValue]/100 ];
    }
    else if ([[strResult substringFromIndex:[strResult length]-2] isEqualToString:@"00"])
    {
         return [NSString stringWithFormat:@"%.f",[OriginalString floatValue]/100 ];
    }
    else if ([[strResult substringFromIndex:[strResult length]-1] isEqualToString:@"0"])
    {
         return [NSString stringWithFormat:@"%.1f",[OriginalString floatValue]/100 ];
    }
    else
    {
        return  strResult;
    }
    return strResult;
}

+(NSString *)cutString:(NSArray *)arr
{
    if (arr.count==0)
    {
        return @"";
    }
    NSString *str = @"";
    if (arr.count>1)
    {
        for (int i = 0; i<arr.count; i++)
        {
            NSString* string = arr[i];
            if (i == arr.count-1)
            {
                str = [str stringByAppendingString:string];
            }
            else
            {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@／",string]];
            }
        }
    }
    else
    {
        str = arr[0];
    }
    return str;
}

+(NSArray *)cutOrderAndTicket:(NSString *)strOriginal
{
    NSArray *array;
    if ([strOriginal length] > 0)
    {
         array = [strOriginal componentsSeparatedByString:@"|"];
    }
    return array;
}

+(NSString *)cutOrderId:(NSString *)orderId
{
    NSString *strResult= @"";
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 5; i < [orderId length]; i++)
    {
        [array addObject: [orderId substringWithRange:NSMakeRange(i,1)] ];
    }

    for (int i = 0; i < [array count]; i++)
    {
        if ([[array objectAtIndex:0] intValue]==0)
        {
            [array removeObjectAtIndex:0];//删除0
        }
    }
    
    for (int i = 0; i < [array count]; i++)
    {
        if( i%3 == 0)
        {
            strResult =[strResult stringByAppendingString:@" "];
            strResult =[strResult stringByAppendingString:array[i]];
        }
        else
        {
            strResult =[strResult stringByAppendingString:array[i]];
        }
    }
    return  strResult;
}

+(BOOL)compareAString:(NSString*)aString andBString:(NSString*)bString
{
    BOOL result = [aString compare:bString
               options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame;
    return result;
}

+(NSString *)getCinemaIdOrName:(NSString *)strResouce
{
    NSString *strChar;
    for(int i = 0; i < [strResouce length]; i++)
    {
        strChar = [strResouce substringWithRange:NSMakeRange(i, 1)];
        if ([strChar isEqualToString:@"="])
        {
            return [strResouce substringFromIndex:i+1];
        }
    }
    return @"";
}

+(BOOL)isQRCodeCorrect:(NSString*)code
{
    if ([code rangeOfString:@"movikr://"].location != NSNotFound )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(NSArray *)analysisQR:(NSString *)QrResult
{
    NSArray *array;
    if ([QrResult length] > 0)
    {
        array = [QrResult componentsSeparatedByString:@"?"];
        if ([array count] > 0)
        {
            QrResult = [array[0] substringFromIndex:[@"movikr://" length]];
            array = [QrResult componentsSeparatedByString:@"/"];
        }
      
    }
    return array;
}


+(NSString *) getSystemDate:(NSString *)format
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    return [dateformatter stringFromDate:senddate];
}

+(BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL) validateTel:(NSString *)telNO
{
    NSString *regex = @"^(701\\d{8})|(1[0-9]{10})$";//@"^(701\\d{8})|^((13[0-9])|(147)|(145)|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}$"
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:telNO];
}

+(NSString *)getDeviceName
{
    return DeviceVersionNames[[GetDeviceName deviceVersion]];
}

+(NSString*)getRedPacketDetail:(NSNumber*)type useLimit:(NSNumber*)limit
{
    NSString* detail = @"";
    int packetType = [type intValue];
    int useLimit = [limit intValue];
    if (packetType == 0)
    {
        //票红包
        if (useLimit == 0)
        {
            //不限制
            detail = @"每张电影票可使用多个";
        }
        if (useLimit == 1)
        {
            //票数
            detail = @"限每张电影票使用1个";
        }
        if (useLimit == 2)
        {
            //订单
            detail = @"每笔订单仅限使用1个";
        }
    }
    else if (packetType == 3)
    {
        //会员卡红包
        if (useLimit == 0)
        {
            //不限制
            detail = @"每张会员卡可使用多个";
        }
        if (useLimit == 2)
        {
            //订单
            detail = @"每笔订单仅限使用1个";
        }
    }
    else if (packetType == 4)
    {
        //小卖红包
        if (useLimit == 0)
        {
            //不限制
            detail = @"每份卖品可使用多个";
        }
        if (useLimit == 1)
        {
            //卖品数
            detail = @"限每份卖品使用1个";
        }
        if (useLimit == 2)
        {
            //订单
            detail = @"每笔订单仅限使用1个";
        }
    }
    detail = [detail stringByAppendingString:@"，不与其他红包共用。"];
    return detail;
}

//md5 16位加密 （大写）
+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );

    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

+(NSString *)stringH5Url:(NSString *) url systime:(NSNumber *)sysTime
{
    NSString *strEncrypt = [NSString stringWithFormat:@"%@%@%@%@",[NSNumber numberWithInt:[[Config getCinemaId] intValue]], [Config getCredential], sysTime ,url];
    NSString *strH5Url = [NSString stringWithFormat:@"%@act/api/appInvoke?loginToken=%@&sign=%@&activityUrl=%@&cinemaId=%@&reqTime=%@",
                        [Config getConfigInfo:@"h5BaseHost"],
                        [Config getCredential],
                        [Tool md5:strEncrypt],
                        [[Tool urlIsNull:url] URLEncodedString],
                        [NSNumber numberWithInt:[[Config getCinemaId] intValue]],
                        sysTime
                        ];
    return strH5Url ;
}

+(NSString *)stringH5UrlExchangeVoucheTime:(NSString *) url systime:(NSNumber *)sysTime
{
    NSString *newUrl =[NSString stringWithFormat:@"%@?%@",url,sysTime];
    NSString *strEncrypt = [NSString stringWithFormat:@"%@%@%@%@",[NSNumber numberWithInt:[[Config getCinemaId] intValue]], [Config getCredential], sysTime ,newUrl];
    NSString *strH5Url = [NSString stringWithFormat:@"%@act/api/appInvoke?loginToken=%@&sign=%@&activityUrl=%@&cinemaId=%@&reqTime=%@",
                          [Config getConfigInfo:@"h5BaseHost"],
                          [Config getCredential],
                          [Tool md5:strEncrypt],
                          [[Tool urlIsNull:newUrl] URLEncodedString],
                          [NSNumber numberWithInt:[[Config getCinemaId] intValue]],
                          sysTime
                          ];
    return strH5Url ;
}

+(void)hideTabBar
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                         delegate._tabBarView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, tabbarHeight);
                     }];
}

+(void)showTabBar
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                         delegate._tabBarView.frame = CGRectMake(0, SCREEN_HEIGHT-tabbarHeight, SCREEN_WIDTH, tabbarHeight);
                     }];
}

+ (NSString *)getDeviceId
{
    //判断本地是否存在设备id
    if ([[Config getDeviceId] length] > 0 )
    {
        return [Config getDeviceId];
    }
    
    NSString *SERVICE_NAME = @"com.movikr.supercinema";
    NSString * str =  [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:SERVICE_NAME error:nil];  // 从keychain获取数据
    if ([str length]<=0)
    {
        str  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];  // 保存UUID作为手机唯一标识符
        [SFHFKeychainUtils storeUsername:@"UUID"
                             andPassword:str
                          forServiceName:SERVICE_NAME
                          updateExisting:1
                                   error:nil];  // 往keychain添加数据
    }
    //将设备标示存到本地
    [Config saveDeviceId:str];
    return str;

}
+(UIViewController*)getLastViewController:(UINavigationController*)nav
{
    NSArray *viewControllers = nav.viewControllers;
    NSLog(@"%@",[viewControllers objectAtIndex:0]);
    return [viewControllers objectAtIndex:0];
}

+(NSString *) returnPayRefundStatus:(NSNumber *)status
{
    if ([status intValue] == 1 )
    {
        return @"待支付";
    }
    if ([status intValue] == 2 )
    {
        return @"待使用";
    }
    if ([status intValue] == 3 )
    {
        return @"退款中";
    }
    if ([status intValue] == 4 )
    {
        return @"已退款";
    }
    if ([status intValue] == 5 )
    {
        return @"已完成";
    }
    if ([status intValue] == 6 )
    {
        return @"出票中";
    }
    return @"未知类型";
}

+(NSString*) readLocationJsonFile:(NSString *)fileName
{
    NSString *contentPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    return  [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
}

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect
{
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

int HOUR = 24;

int SECOND = 60;

int MINITE = 60;

int MILLSECOND = 1000;


+ (NSString *)getLeftStartTime:(NSNumber*)start endTime:(NSNumber*)end {
    
    long long left = [end longLongValue] - [start longLongValue];
    long long day = left / (MILLSECOND * SECOND * MINITE * HOUR);
    long long hour = (left % (MILLSECOND * SECOND * MINITE * HOUR)) / (MILLSECOND * SECOND * MINITE);
    long long min = ((left % (MILLSECOND * SECOND * MINITE * HOUR)) % (MILLSECOND * SECOND * MINITE)) / (MILLSECOND * SECOND);
//    long long second = (((left % (MILLSECOND * SECOND * MINITE * HOUR)) % (MILLSECOND * SECOND * MINITE)) % (MILLSECOND * SECOND)) / MILLSECOND;
    
    if (day != 0)
    {
        if (day >= 10)
        {
            return [self returnTime:start format:@"yyyy年MM月dd日"];
        }
        return [NSString stringWithFormat:@"%lld%@", day, @"天前"];
    }
    else if (hour != 0)
        return [NSString stringWithFormat:@"%lld%@", hour, @"小时前"];
    else if (min != 0)
        return [NSString stringWithFormat:@"%lld%@", min, @"分钟前"];
//    else if (second != 0)
//        return [NSString stringWithFormat:@"%lld%@", second, @"秒前"];
    else
        return @"刚刚";
}

/**
 *  将时间戳(毫秒级)转换成 日期类型的当天结束时间(23:59:59)
 *  @param time 时间戳(毫秒级)
 *
 *  @return
 */
+(NSDate *)changeTimeToEndDate:(long long)time{
    
    NSDate *sysDate = [[NSDate alloc] initWithTimeIntervalSince1970:time/1000];
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    NSTimeZone* zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:sysDate];
    NSDate* localDate = [sysDate dateByAddingTimeInterval:interval];

    //设置时区
    [formater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formater setDateFormat:@"yyyyMMdd"];
    NSString *sysDateStr = [formater stringFromDate:localDate];
    NSString * dateStr = [NSString stringWithFormat:@"%@ 23:59:59", sysDateStr];
    
    NSDateFormatter* formater1 = [[NSDateFormatter alloc] init];
    [formater1 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formater1 setDateFormat:@"yyyyMMdd HH:mm:ss"];
    NSDate* sysEndDate = [formater1 dateFromString:dateStr];
    return sysEndDate;
}

/**
 *  将时间戳(毫秒级)转换成 utc时区 时间戳
 *  @param time 时间戳(毫秒级 NUMBER 类型)
 *
 *  @return
 */
+(long long)toUTCTime:(NSNumber *)time{
    NSString *showtimeStr = [Tool returnTime:time format:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* showtimeDate = [formater dateFromString:showtimeStr];
    long long showtimeTime = [showtimeDate timeIntervalSince1970] * 1000;
    return showtimeTime;
}

/**
 *  获取场次距系统时间
 *  @param start 场次时间
 *  @param end    系统时间
 *
 *  @return
 */
+ (NSString *)getShowTimeDate:(NSNumber*)start endTime:(NSNumber*)end
{
    long long eightHourNumber = 8*60*60*1000;

    //将场次时间 设置时区格式化 然后获取时区上得long型时间
    long long showtimeTime = [Tool toUTCTime:start] - eightHourNumber;
    
    //系统时间
    long long endDateTime = [end longLongValue];
    
    //今天结束时间(日期类型)
    NSDate* sysEndDate = [Tool changeTimeToEndDate:endDateTime];
    
    //今天结束时间(时间戳 毫秒级)
    long long sysTodayEndTime = [sysEndDate timeIntervalSince1970] * 1000 - eightHourNumber;
    //昨天结束时间
    long long sysYesterdayEndTime = sysTodayEndTime - MILLSECOND * SECOND * MINITE * HOUR;
    //明天结束时间
    long long sysTomorrowEndTime = sysTodayEndTime + MILLSECOND * SECOND * MINITE * HOUR;
    //后天结束时间
    long long sysDayAfterTomorrowEndTime = sysTomorrowEndTime + MILLSECOND * SECOND * MINITE * HOUR;
    
    if (showtimeTime <= sysYesterdayEndTime)
    {
        //昨天之前
        return [self returnWeek:start];
    }
    else if (showtimeTime <= sysTodayEndTime)
    {
        return @"今天";
    }
    else if (showtimeTime > sysTodayEndTime && showtimeTime < sysTomorrowEndTime)
    {
        return @"明天";
    }
    else if (showtimeTime > sysTomorrowEndTime && showtimeTime < sysDayAfterTomorrowEndTime)
    {
        return @"后天";
    }
    else
    {
        return [self returnWeek:start];
    }
}

+(NSNumber*)getNotifyId:(NSNumber*)notifyId cinemaId:(NSNumber*)cinemaId
{
    NSString* strNotifyId = [notifyId stringValue];
    NSString* strCinemaId = [cinemaId stringValue];
    NSString* string = [strNotifyId substringWithRange:NSMakeRange(0, strNotifyId.length-strCinemaId.length)];
    return [NSNumber numberWithInt:[string intValue]];
}

+(BOOL) urlIsImage:(NSString *)url
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *string = [NSData sd_contentTypeForImageData:data];
    if ([string length] == 0)
    {
        return FALSE;
    }
    NSLog(@"%@",string);
    return TRUE;
}

//人数
+(NSString*)getPersonCount:(NSNumber*)number
{
    NSInteger count = [number integerValue];
    if (count == 0)
    {
        return @"点赞";
    }
    else if (count >999)
    {
        return @"999+";
    }
    else
    {
        return [number stringValue];
    }
}

+ (void)downloadImage:(NSString *)urlString button:(UIButton*)btn imageView:(UIImageView*)imageView defaultImage:(NSString*)defaultStr
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL* url = [NSURL URLWithString:urlString];
    BOOL existBool = [manager diskImageExistsForURL:url];//判断是否有缓存
    if (existBool)
    {
        UIImage* image =  [[manager imageCache]imageFromDiskCacheForKey:url.absoluteString];
        if (btn)
        {
            [btn setBackgroundImage:image forState:UIControlStateNormal];
        }
        if (imageView)
        {
            imageView.image = image;
        }
    }
    else
    {
        if (btn)
        {
            [btn setBackgroundImage:[UIImage imageNamed:defaultStr] forState:UIControlStateNormal];
        }
        if (imageView)
        {
            imageView.image = [UIImage imageNamed:defaultStr];
        }
        [manager downloadImageWithURL:[NSURL URLWithString:urlString]
                                                       options:0
                                                      progress:nil
                                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                         if (!error && image)
                                                         {
                                                             if (btn)
                                                             {
                                                                 [btn setBackgroundImage:image forState:UIControlStateNormal];
                                                             }
                                                             if (imageView)
                                                             {
                                                                 imageView.image = image;
                                                             }
                                                         }
                                                     }];
    }
}

+(NSNumber *) getSystemTime
{
    UInt64 systime = [[NSDate date] timeIntervalSince1970]*1000;
    NSNumber *newSystime = [NSNumber numberWithUnsignedInteger:systime];
    return newSystime;
}
+(NSMutableAttributedString *)setKeyAttributed:(NSString *)originResult key:(NSString *)searchKey fontSize:(UIFont*) font
{
    // 获取关键字的位置
    NSRange range = [[originResult lowercaseString] rangeOfString:[searchKey lowercaseString]];
    // 转换成可以操作的字符串类型.
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:originResult];
    // 添加属性(粗体)
    [attribute addAttribute:NSFontAttributeName value:font range:range];
    // 关键字高亮
    [attribute addAttribute:NSForegroundColorAttributeName value:RGBA(117, 112, 255, 1) range:range];
    return attribute;
}

+(NSString *)numberFotmat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

@end
