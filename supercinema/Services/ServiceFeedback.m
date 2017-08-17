//
//  ServiceFeedback.m
//  movikr
//
//  Created by Mapollo27 on 3/11/16.
//  Copyright © 2016 movikr. All rights reserved.
//

#import "ServiceFeedback.h"

@implementation ServiceFeedback

+ (void)upLoadFeedbackContent:(NSInteger)feedbackType feedbackContent:(NSString *) feedbackContent email:(NSString *)email imageList:(NSArray *)arryImage
                    model:(void (^)(RequestResult *model))success  failure:(void (^)(NSError *error))failure
{
    NSDictionary* body = @{@"feedbackType":[NSString stringWithFormat:@"%ld",(long)feedbackType],
                           @"feedbackContent":[Tool urlIsNull:feedbackContent],
                           @"email":[Tool urlIsNull:email],
                           @"imageList":arryImage,
                           @"clientVersion":[[UIDevice currentDevice] systemVersion],
                           @"deviceName":[Tool getDeviceName]};
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_FEEDBACK parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
             NSLog(@"%@",[responseObject JSONString]);
             RequestResult *result =[[RequestResult alloc] initWithDictionary:responseObject error:nil];
             if ([result.respStatus intValue] == 1)
             {
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     success(result);
                 }
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:result.respMsg code:[result.respStatus intValue]  userInfo:nil]);
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}


@end
