//
//  ShareRedPackModel.h
//  supercinema
//
//  Created by dust on 2017/5/17.
//
//

#import <JSONModel/JSONModel.h>

@interface shareDataModel : JSONModel
@property(nonatomic,strong) NSString<Optional>* title;
@property(nonatomic,strong) NSString<Optional>* content;
@property(nonatomic,strong) NSString<Optional>* url;
@property(nonatomic,strong) NSString<Optional>* shareLogoUrl;
@end

@interface ShareRedPackModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* currentTime;
@property(nonatomic,strong) shareDataModel<Optional>* shareData;
@end
