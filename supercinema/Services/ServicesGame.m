//
//  ServicesGame.m
//  supercinema
//
//  Created by dust on 2017/2/9.
//
//

#import "ServicesGame.h"
#import "GameModel.h"

@implementation ServicesGame

+ (void)getUserGameData:(NSString *) gameId
                  result:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"gameId":[Tool urlIsNull:gameId] };

    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        //NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
        [MKNetWorkRequest POST:URL_GETGAMEINFO parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             GameUserDataModel *gameUserModel =[[GameUserDataModel alloc] initWithDictionary:responseObject error:nil];
             
             if([gameUserModel.respStatus  intValue]  == 1 )
             {
//                 NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!100",gameUserModel.user.portraitUrl]]];
//                 if (imageData)
//                 {
//                    gameUserModel.user.portraitUrl = [NSString stringWithFormat:@"data:image/png;base64,%@",[imageData base64EncodedStringWithOptions:0]];
                    gameUserModel.defaultCinemaId = [Config getCinemaId];
//                    sleep(1);
                    if(success)
                        success([gameUserModel toJSONString]);
//                 }
             }
             else
             {
                 if(success)
                     success([gameUserModel toJSONString]);
             }
             

         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)startPlayGame:(NSString *) gameId playInCinemaId:(NSString *) cinemaId
                result:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"gameId":[Tool urlIsNull:gameId],
                          @"playInCinemaId":[Tool urlIsNull:cinemaId]
                          };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GAMESTART parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
//             NSLog(@"%@",[responseObject JSONString]);
             GameStartModel *gameModel =[[GameStartModel alloc] initWithDictionary:responseObject error:nil];
             gameModel.defaultCinemaId = [Config getCinemaId];
             if(success)
                success([gameModel toJSONString]);

         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)finishPlayGame:(NSString *) roundId goldCount:(NSString *) goldCount isFirstPlay:(NSString *)isFirstPlay strokesIndexAndCountList:(NSArray *)strokesIndexAndCountList
                 result:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"roundId":[Tool urlIsNull:roundId],
                          @"goldCount":[Tool urlIsNull:goldCount],
                          @"isFirstPlay":[NSNumber numberWithInt:[[Tool urlIsNull:isFirstPlay] intValue]],
                          @"strokesIndexAndCountList":strokesIndexAndCountList
                          };
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GAMEFINISH parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
//             NSLog(@"%@",[responseObject JSONString]);
             if(success)
                     success([responseObject JSONString]);

         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)cancelRound:(NSString *) roundId
              result:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"roundId":[Tool urlIsNull:roundId]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GAMECANCELROUND parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
            if(success)
                success([responseObject JSONString]);
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}

+ (void)receiveChest:(NSString *) chestId
               result:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *body =@{@"chestId":[Tool urlIsNull:chestId]};
    
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GAMERECEIVECHEST parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
//             NSLog(@"%@",[responseObject JSONString]);
             if(success)
                 success([responseObject JSONString]);
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }
}
//获取商城可售列表
+ (void)getGroupGoodsList:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        [MKNetWorkRequest POST:URL_GAMEGETGROUPGOODSLIST parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             if(success)
                 success([responseObject JSONString]);
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }

}
//购买商城商品
+ (void)buyGoods:(NSString *) goodsId
          result:(void (^)(NSString *responseObject))success failure:(void (^)(NSError *error))failure
{
    if ([MKNetWorkState getNetWorkState] == AFNetworkReachabilityStatusNotReachable)
    {
        if(failure)
            failure([NSError errorWithDomain:requestErrorTip code:noNetWorkCode  userInfo:nil]);
    }
    else
    {
        NSDictionary *body =@{@"goodsId":[Tool urlIsNull:goodsId]};
        [MKNetWorkRequest POST:URL_GAMEBUYGOODS parameters:body success:^(NSURLSessionDataTask *task, id responseObject)
         {
             if(success)
                 success([responseObject JSONString]);
             
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             if(failure)
                 failure([NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil]);
         }];
    }

}



@end
