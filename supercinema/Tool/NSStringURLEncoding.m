//
//  NSStringURLEncoding.m
//  movikr
//
//  Created by Mapollo27 on 16/4/20.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import "NSStringURLEncoding.h"
#import <CoreFoundation/CFURL.h>

@implementation NSString (NSStringURLEncoding)

- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), kCFStringEncodingUTF8));
    return encodedString;
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self,CFSTR(""),kCFStringEncodingUTF8));
    return result;  
}  
@end