//
//  ThirdShareFactory.h
//  supercinema
//
//  Created by mapollo91 on 19/4/17.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "BaseShare.h"

@interface ThirdShareFactory : NSObject

+(shareType)getShareType:(NSInteger)type;
+(BaseShare *)getShareInstance:(shareType)shareType;
+(BOOL)checkIsInstallApp:(shareType)shareType;

@end
