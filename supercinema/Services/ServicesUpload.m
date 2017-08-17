//
//  ServicesUpload.m
//  movikr
//
//  Created by Mapollo27 on 15/9/1.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "ServicesUpload.h"

@protocol NSDictionary;
@implementation ServicesUpload

//解析上传图片
+(NSMutableArray *)getUploadYpaiParam:(NSDictionary *)stringJson
{
    NSMutableArray *arrayUpLoadImage=[[NSMutableArray alloc]init];
    NSDictionary *dicRoot=stringJson;
    NSArray *dataArray=[dicRoot objectForKey:@"uploadImageList" ];
    for (NSDictionary *upLoadDic in dataArray)
    {
        upLoadImageModel *list=[[upLoadImageModel alloc]init];
        
        list.upload_url = [dicRoot objectForKey:@"uploadHostUrl"];
        list.image_key = @"file";
        list.path = [upLoadDic objectForKey:@"uploadPath"];
        NSArray *dataArrayChild=[upLoadDic objectForKey:@"paramList" ] ;
       
        
        NSDictionary *dicC=dataArrayChild[0];
        list.policyKey = [dicC objectForKey:@"key"];
        list.policyValue = [dicC objectForKey:@"value"];
        
        dicC=dataArrayChild[1];
        list.signatureKey = [dicC objectForKey:@"key"];
        list.signatureValue = [dicC objectForKey:@"value"];
        [arrayUpLoadImage addObject:list];
    }
    return arrayUpLoadImage;
}


+ (void)requestUpdateImage:(NSInteger )count type:(NSString *) type
                   success:(void (^)(NSDictionary *suc))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body = @{@"imageCount":[NSString stringWithFormat:@"%ld",(long)count],
                           @"imageFormat":@"png",
                           @"imageCategory":type};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
           failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_ARTUPLOADIMAGE parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSLog(@"%@",[responseObject JSONString]);
            
            if(success)
                success(responseObject);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failure)
                failure(error);
        }];
    }
}


@end

