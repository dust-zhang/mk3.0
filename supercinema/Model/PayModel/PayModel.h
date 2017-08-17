//
//  PayModel.h
//  movikr
//
//  Created by Mapollo27 on 15/9/14.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "JSONModel.h"

//获取支付方式列表
@interface PayTypeModel : JSONModel
@property (nonatomic ,strong) NSString<Optional> *payTypeName;
@property (nonatomic ,strong) NSNumber<Optional> *payTypeId;
@property (nonatomic ,strong) NSString<Optional> *payTypeCode;
@end

@protocol PayTypeModel;
@interface PayModelList : JSONModel
@property (nonatomic, strong) NSArray <PayTypeModel,Optional> *list;
@property (nonatomic ,strong) NSNumber<Optional> *payEndTime;
@property (nonatomic ,strong) NSNumber<Optional> *notNeedPay;
@property (nonatomic ,strong) NSNumber<Optional> *currentTime;
@end

//App支付回调
@interface PayReturnModel : JSONModel
@property (nonatomic ,strong) NSNumber<Optional> *respMsg;
@property (nonatomic ,strong) NSString<Optional> *respStatus;
@property (nonatomic,strong)  NSNumber<Optional>* canContinue;
@end

//支付宝回调
@interface ZhifubaoModel : JSONModel
@property (nonatomic ,strong) NSString<Optional> *memo;
@property (nonatomic ,strong) NSString<Optional> *result;
@property (nonatomic ,strong) NSString<Optional> *resultStatus;
@end


//微信支付
@interface WeinxinPayModel : JSONModel
@property (nonatomic ,strong) NSString<Optional> *appid;
@property (nonatomic ,strong) NSString<Optional> *noncestr;
@property (nonatomic ,strong) NSString<Optional> *package;
@property (nonatomic ,strong) NSString<Optional> *partnerid;
@property (nonatomic ,strong) NSString<Optional> *prepayid;
@property (nonatomic ,strong) NSString<Optional> *sign;
@property (nonatomic ,strong) NSNumber<Optional> *timestamp;
@end

//Apple pay 支付
@interface ApplePayModel : JSONModel
//订单号
@property (strong,nonatomic) NSString *v_md5info;
//
@property (strong,nonatomic) NSString *v_orderstatus;
//
@property (strong,nonatomic) NSString *v_rcvname;
//
@property (strong,nonatomic) NSString *v_moneytype;
//
@property (strong,nonatomic) NSString *v_transtype;
//订单号
@property (strong,nonatomic) NSString *v_oid;
//订单金额
@property (strong,nonatomic) NSString *v_ymd;
// 0:预授权操作  1:消费操作
@property (strong,nonatomic) NSString *v_url;
//商品名称
@property (strong,nonatomic) NSString *v_rcvaddr;
//商品图案
@property (strong,nonatomic) NSString *v_ordername;
@property (strong,nonatomic) NSString *v_rcvtel;
@property (strong,nonatomic) NSString *v_ordip;
@property (strong,nonatomic) NSString *v_pmode;
@property (strong,nonatomic) NSString *v_mid;
@property (strong,nonatomic) NSString *v_amount;
@property (strong,nonatomic) NSString *v_rcvpost;
@end


@interface ThirdPayModel : JSONModel
@property (nonatomic ,strong) NSNumber<Optional> *respStatus;
@property (nonatomic ,strong) NSString<Optional> *respMsg;
@property (nonatomic ,strong) NSString<Optional> *payOrderId;
@property (nonatomic ,strong) NSString<Optional> *formXml;
@end

