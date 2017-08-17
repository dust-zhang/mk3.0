//
//  WechatShare.h
//  supercinema
//
//  Created by mapollo91 on 19/4/17.
//
//

#import <Foundation/Foundation.h>
#import "BaseShare.h"

@interface WechatShare : BaseShare

-(void)sendShareToWeiChatOfNew:(int)scence shareImage:(UIImage *)shareImage;

-(void)sendShareToWeiChatContent:(shareInfoModel *)shareInfo scence:(int)scence;
@end
