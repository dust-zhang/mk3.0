//
//  MKPay.m
//  movikr
//
//  Created by Mapollo27 on 15/9/18.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "MKPayManager.h"

@implementation MKPayManager

#pragma mark -- 支付宝支付
+(void) zhifubaoPay:(NSString *) orderString model:(void (^)(ZhifubaoModel *zfbModel))success
{
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:RbackParameter callback:^(NSDictionary *resultDic)
     {
         if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay:"]])
         {
            NSError* err = nil;
            ZhifubaoModel *model = [[ZhifubaoModel alloc] initWithString:[resultDic JSONString] error:&err];
            if(err!=nil)
            {
                NSLog(@"%@",err );
            }
            if(success)
                success(model);
         }
       
     }];
}

#pragma mark -- 微信支付
+(void) weixinPay:(WeinxinPayModel *) weixinModel
{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId =weixinModel.partnerid;// @"1273488801";
    request.prepayId=weixinModel.prepayid;// @"wx201509281755061f387968b80596929244";
    request.package = weixinModel.package;//@"Sign=WXPay";
    request.nonceStr=weixinModel.noncestr;// @"a1d7311f2a312426d710e1c617fcbc8c";
    request.timeStamp=[weixinModel.timestamp intValue];// 1443434104;
    request.sign= weixinModel.sign;//@"BE6A328038AF6F61BCD4E0193F9DF54F";
    [WXApi sendReq:request];
}

#pragma mark -- 构造apple pay 支付参数
+ (NSString *)PayNormaWith:(NSString *)payInfo applePayModel:(ApplePayModel *)model
{
    NSString *requestInfo = [NSString stringWithFormat:@"v_mid=%@&v_oid=%@&v_rcvname=%@&v_rcvaddr=%@&v_rcvtel=%@&v_rcvpost=%@&v_amount=%@&v_ymd=%@&v_orderstatus=%@&v_ordername=%@&v_moneytype=%@&v_url=%@&v_md5info=%@&v_paymentinfo=%@&v_ordip=%@&v_pmode=%@&v_transtype=%@",
                             model.v_mid,
                             model.v_oid,
                             model.v_rcvname,
                             model.v_rcvaddr,
                             model.v_rcvtel,
                             model.v_rcvpost,
                             model.v_amount,
                             model.v_ymd,
                             model.v_orderstatus,
                             model.v_ordername,
                             model.v_moneytype,
                             model.v_url,
                             model.v_md5info,
                             payInfo,
                             model.v_ordip,
                             model.v_pmode,
                             model.v_transtype];
    
    return requestInfo;
}



@end
