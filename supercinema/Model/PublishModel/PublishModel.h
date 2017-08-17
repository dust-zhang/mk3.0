//
//  ItemData.h
//  movikr
//
//  Created by zhangjingfei on 17/5/15.
//  Copyright (c) 2015年 zeyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface StillsModel : JSONModel
//剧照
@property(nonatomic,strong) NSNumber<Optional> *id;
@property(nonatomic,strong) NSString<Optional> *url_small;
@property(nonatomic,strong) NSString<Optional> *url;
@property(nonatomic,strong) NSString<Optional> *urlOfBig;

@end


@interface PublishItem : JSONModel
@property(nonatomic,strong) NSString<Optional> *Ctitle;
@property(nonatomic,strong) NSString<Optional> *content;

@end
