//
//  ItemData.h
//  movikr
//
//  Created by zhangjingfei on 17/5/15.
//  Copyright (c) 2015年 zeyuan. All rights reserved.
//

#import <Foundation/Foundation.h>


//版本更新
@interface VersionUpdateModel : JSONModel
@property(nonatomic,strong) NSNumber    <Optional>  *respStatus;
@property(nonatomic,strong) NSString    <Optional>  *respMsg;
@property(nonatomic,strong) NSString    <Optional>  *seq;
//@property(nonatomic,strong) NSString    <Optional>  *updateClientUrl;
//@property(nonatomic,strong) NSString    <Optional>  *versionNew;
//@property(nonatomic,strong) NSString    <Optional>  *updateDescription;
@property(nonatomic,strong) NSNumber    <Optional>  *needUpdate;//是否有新版本可以更新
@property(nonatomic,strong) NSNumber    <Optional>  *mustUpdate;//是否强制更新
@end


//版本更新
@interface SystemConfigModel : JSONModel
@property(nonatomic,strong) NSString    <Optional>  *key;
@property(nonatomic,strong) NSString    <Optional>  *value;
@end
