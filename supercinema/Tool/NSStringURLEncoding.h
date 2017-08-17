//
//  NSStringURLEncoding.h
//  movikr
//
//  Created by Mapollo27 on 16/4/20.
//  Copyright © 2016年 movikr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringURLEncoding)
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
@end
