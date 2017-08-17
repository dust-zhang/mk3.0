//
//  SnackDetailModel.h
//  supercinema
//
//  Created by dust on 16/11/15.
//
//

#import <JSONModel/JSONModel.h>
#import "SnackModel.h"

@interface SnackDetailModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *seq;
@property (nonatomic,strong) NSArray <Optional,SnackListModel> *goodsDetail;
@end



@interface CreateSnackModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *orderId;
@end

