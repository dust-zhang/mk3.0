//
//  shareInfoModel.h
//  supercinema
//
//  Created by mapollo91 on 17/5/17.
//
//

#import <JSONModel/JSONModel.h>

@interface shareInfoModel : NSObject

@property(nonatomic,strong) NSString *_title;
@property(nonatomic,strong) NSString *_content;
@property(nonatomic,strong) NSString *_url;
@property(nonatomic,strong) NSString *_shareLogoUrl;

@end
