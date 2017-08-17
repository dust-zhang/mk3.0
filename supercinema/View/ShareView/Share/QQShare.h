//
//  QQShare.h
//  supercinema
//
//  Created by mapollo91 on 19/4/17.
//
//

#import <Foundation/Foundation.h>
#import "BaseShare.h"

@interface QQShare : BaseShare

-(void)handleSendResult:(QQApiSendResultCode)sendResult;

@end
