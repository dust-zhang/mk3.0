//
//  MKPackJson.m
//  movikr
//
//  Created by Mapollo27 on 15/5/29.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "MKPackJson.h"
#import "SDVersion.h"

@implementation MKPackJson
/*
 (80, "iPhone"),
 (81, "iPad"),
 (60, "Android"),
 (21, "Meego"),
 (22, "Symbian"),
 (12, "WindowsPhone"),
 (11, "QT"),
 (10, "H5"),
 (9, "pc");
 */
+(NSDictionary *)getRequestHeader
{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *credential=[Config getCredential];
    NSDictionary *header=@{@"v":@"1.0",
                           @"a":@"5593474a67e58e43d9006c95",
                           @"av":[[[NSBundle mainBundle] infoDictionary ] objectForKey:@"CFBundleShortVersionString"],
                           @"c":credential?credential:@"",
                           @"d":idfv,
                           @"clientType":@"80",
                           @"deviceSystemVersion":[[UIDevice currentDevice] systemVersion],//系统版本
                           @"deviceBrand":[Tool getDeviceName],//手机品牌
                           @"deviceModel":[[Tool getDeviceName] substringWithRange:NSMakeRange(6, [[Tool getDeviceName] length]-6 )],//设备型号
                           @"fingerprint":[Tool md5:[Tool getDeviceId]]//设备标识
                           };
    return header;
}

@end
