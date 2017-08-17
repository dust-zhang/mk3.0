//
//  Tool.h
//  movikr
//
//  Created by zeyuan on 15/5/27.
//  Copyright (c) 2015年 zeyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "SDVersion.h"
#import "SFHFKeychainUtils.h"

@interface Tool : NSObject

///异或加密
+ (NSString *)xor:(NSString *)pan key:(NSString *)k;
///日期转字符串
+(NSString*) dateToString:(NSDate *)date format:(NSString *)format;
///计算文字高度
+ (CGSize) CalcString:(NSString *)value fontSize:(UIFont *)fontSize andWidth:(float)width;
//计算文字宽度
+(CGFloat) calStrWidth:(NSString *)value height:(CGFloat)height;
///计算文字的显示区域
+ (CGSize)boundingRectWithSize:(NSString *)text textFont:(UIFont *)font textSize:(CGSize)size;
///返回控件长度
+(float) calcCtrlLength:(NSString*)text;
///获取系统版本
+(NSString *) getAppVersion;
///是否为闰年
+(BOOL) isLeapYear:(NSInteger)year;
///计算字符串的字数
+(int)convertToInt:(NSString*)strtemp;
///计算字符串的字符数(精确字符数)
+(int)unicodeLengthOfString:(NSString*)strtemp;
///清空旁白和内容
//+(void)removeAllStillsAndContent;
//截取字符串
+(NSString *) cutString:(NSString*) str star:(NSString*) starString end:(NSString*)endString;
///替换字符串中的emoji表情
+ (NSString *)disableEmoji:(NSString *)text;
///通用提示
+(void) showWarningTip:(NSString *) message time:(float) delayTime;
+(void) showWarningTipForView:(NSString *) message time:(float) delayTime view:(UIView *)view;
///成功提示
+(void) showSuccessTip:(NSString *) message time:(float) delayTime;
//跟随view的提示
+(void) showSuccessTip:(NSString *) message time:(float) delayTime view:(UIView *)view;
///获取设备的宽度(根据该宽度来获取图片的宽度，不一定和设备的宽度一致)
+(NSInteger)getLoadImageDeviceWidth;
//设置uilable行高
+(void) setLabelSpacing:(UILabel*)label spacing:(float)spacing alignment:(NSTextAlignment)alignment;
//拼接字符串
+(NSString *)MosaicString:(NSString *)originalString replaceString:(NSString *)rString;
///获取新闻详细页的URL
+(NSString*)getArticleDetailUrl:(NSString*)baseUrl articleId:(NSInteger)articleId isClient:(BOOL)isClient sourceName:(NSString*)sourceName actionId:(NSInteger)actionId;
//判断图片是否为gif
+(BOOL) imageIsGif:(NSString *)imageUrl;
///清除文本里面的换行和空格字符
+(NSString*)clearSpaceAndNewline:(NSString*)oldStr;
//判断url是否为空
+(NSString *)urlIsNull:(NSString *)url;
//将NSInteger转成时间格式
+ (NSString *)convertTime:(NSInteger)time;
//将时间戳转成时间格式
+(NSString *)returnTime:(NSNumber*)time format:(NSString*)format;
//将时间转时间戳
+(NSNumber *)returnTimestamp:(NSString *)time;
//通过时间戳获取星期几
+(NSString *)returnWeek:(NSNumber*)time;
+(NSString *)returnWeekFullName:(NSNumber*)time;
//将string转nsdic
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//选择的座位组合，
+(NSString *) returnStringPlus:(NSArray*)arr;
//计算时间间隔（返回时间戳）
+(NSTimeInterval)calcTimeLength:(NSNumber *)endTime;
//计算时间间隔（返回时间戳及服务器时间戳）
+(NSTimeInterval)calcSysTimeLength:(NSNumber *)endTime SysTime:(NSNumber *)SysTime;
//保留两位小数，如果最后精确位是0则抹去
+(NSString *)PreserveTowDecimals:(NSNumber *)OriginalString;
//分割数组 "／"
+(NSString *)cutString:(NSArray *)arr;
//分割字符串“|”
+(NSArray *)cutOrderAndTicket:(NSString *)strOriginal;
//截取显示订单号
+(NSString *)cutOrderId:(NSString *)orderId;
//不区分大小写比较两个字符串
+(BOOL)compareAString:(NSString*)aString andBString:(NSString*)bString;
//扫面二维码结果
+(NSString *)getCinemaIdOrName:(NSString *)strResouce;
//二维码结果是否正确
+(BOOL)isQRCodeCorrect:(NSString*)code;
//解析二维码扫描的结果
+(NSArray *)analysisQR:(NSString *)QrResult;
//获取系统时间
+(NSString *) getSystemDate:(NSString *)format;
//验证email
+(BOOL) validateEmail:(NSString *)email;
//验证手机号
+(BOOL) validateTel:(NSString *)telNO;
//获取设备名字
+(NSString *)getDeviceName;
//获取红包说明
+(NSString*)getRedPacketDetail:(NSNumber*)type useLimit:(NSNumber*)limit;
//MD5加密
+(NSString *)md5:(NSString *)str;
+(NSString *)stringH5Url:(NSString *) url systime:(NSNumber *)sysTime;
+(NSString *)stringH5UrlExchangeVoucheTime:(NSString *) url systime:(NSNumber *)sysTime;
//隐藏tabbar
+(void)hideTabBar;
+(void)showTabBar;
//获取设备唯一标示
+ (NSString *)getDeviceId;
+(UIViewController*)getLastViewController:(UINavigationController*)nav;
//根据支付、退款数字返回文字描述
+(NSString *) returnPayRefundStatus:(NSNumber *)status;
//读取本地测试json文件
+(NSString*) readLocationJsonFile:(NSString *)fileName;
//从图片中按指定的位置大小截取图片的一部分 
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
//计算日前间隔
+ (NSString *)getLeftStartTime:(NSNumber*)start endTime:(NSNumber*)end;
//计算场次日期
+ (NSString *)getShowTimeDate:(NSNumber*)start endTime:(NSNumber*)end;
//判断字符串是否为空
+(BOOL) isBlankString:(NSString *)string;
+(NSNumber*)getNotifyId:(NSNumber*)notifyId cinemaId:(NSNumber*)cinemaId;
//判断url是否是图片
+(BOOL) urlIsImage:(NSString *)url;
//人数
+(NSString*)getPersonCount:(NSNumber*)number;
//下载图片
+ (void)downloadImage:(NSString *) urlString button:(UIButton*)btn imageView:(UIImageView*)imageView defaultImage:(NSString*)defaultStr;
//获取系统时间
+(NSNumber *) getSystemTime;
//设置关键字高亮
+(NSMutableAttributedString *)setKeyAttributed:(NSString *)originResult key:(NSString *)searchKey fontSize:(UIFont*) font;
//数字加“，”
+(NSString *)numberFotmat:(NSString *)num;

@end
