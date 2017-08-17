//
//  FollowMovieModel.h
//  movikr
//
//  Created by Mapollo28 on 15/12/23.
//  Copyright © 2015年 movikr. All rights reserved.
//

#import "JSONModel.h"

@interface FollowMovieModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSString<Optional>* movieId;
@property(nonatomic,strong) NSNumber<Optional>* follow;
@end

