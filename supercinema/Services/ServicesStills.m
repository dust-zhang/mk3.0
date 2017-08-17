//
//  ServiceStills.m
//  movikr
//
//  Created by Mapollo27 on 15/8/27.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "ServicesStills.h"

@protocol NSDictionary;
@implementation ServiceStills

+ (void)getStills:(NSNumber*)movieId includeMainHaibao:(NSNumber *)_includeMainHaibao
            array:(void (^)(NSArray *arrStills))success failure:(void (^)(NSError *error))failure
{
    //_includeMainHaibao 0:不包含主海报，1:包含主海报
    NSDictionary *body;
    if (IPhone4 || IPhone5)
    {
        body = @{@"movie_id":movieId,
                 @"includeMainHaibao":_includeMainHaibao,
                 @"width":@"640"};
    }
    if (IPhone6)
    {
        body = @{@"movie_id":movieId,
                 @"includeMainHaibao":_includeMainHaibao,
                 @"width":@"750"};
    }
    if (IPhone6plus)
    {
        body = @{@"movie_id":movieId,
                 @"includeMainHaibao":_includeMainHaibao,
                 @"width":@"828"};
    }
    
    //发送请求
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
         [MKNetWorkRequest POST:URL_STILLS parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",[responseObject JSONString]);
             
             RequestResult* head = [[RequestResult alloc] initWithDictionary:responseObject  error:nil];
             if ([head.respStatus intValue] == 1)
             {
                 NSMutableArray *stillsArray= [[NSMutableArray alloc] init];
                 if([responseObject isKindOfClass:[NSDictionary class]])
                 {
                     NSArray<NSDictionary> *arrDic = [responseObject objectForKey:@"stills"];
                     if(arrDic!=nil && [arrDic count]>0)
                     {
                         for (NSDictionary *drama in arrDic)
                         {
                             NSError* err = nil;
                             StillsModel *stillsModel = [[StillsModel alloc] initWithString:[drama JSONString] error:&err];
                             if(err!=nil)
                             {
                                 NSLog(@"%@",err );
                             }
                             if ([stillsModel.urlOfBig length] == 0 )
                             {
                                 stillsModel.urlOfBig = stillsModel.url;
                             }
                             [stillsArray addObject:stillsModel];
                         }
                     }
                 }
                 if(success)
                     success(stillsArray);
             }
             else
             {
                 if(failure)
                     failure([NSError errorWithDomain:head.respMsg code:[head.respStatus  intValue ] userInfo:nil]);
             }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"%@",[error localizedDescription]);
             if(failure)
                 failure(error);
         }];

    }
}


@end
