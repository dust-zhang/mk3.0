//
//  SearchModel.h
//  supercinema
//
//  Created by dust on 16/11/25.
//
//

#import <JSONModel/JSONModel.h>
#import "HotMovieListModel.h"
#import "UserModel.h"

@interface SearchModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *seq;
@property (nonatomic,strong) NSNumber <Optional> *totalOfMovie;
@property (nonatomic,strong) NSArray  <Optional,MovieModel> *movieList;
@property (nonatomic,strong) NSNumber <Optional> *totalOfCinema;
@property (nonatomic,strong) NSArray  <Optional,CinemaModel> *cinemaList;
@property (nonatomic,strong) NSNumber <Optional> *totalOfUser;
@property (nonatomic,strong) NSArray  <Optional,FollowPersonListModel> *userList;
@end

@protocol citylistModel;
@interface CityModel : JSONModel
@property (nonatomic,strong) NSArray <Optional,citylistModel> *citylist;
@end

@interface citylistModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *name;
@property (nonatomic,strong) NSString <Optional> *firstLetter;
@property (nonatomic,strong) NSString <Optional> *cityCode;
@property (nonatomic,strong) NSString <Optional> *adCode;
@property (nonatomic,strong) NSString <Optional> *py;
@property (nonatomic,strong) NSNumber <Optional> *id;
@end


@protocol HotCityModel;
@interface HotCityListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *seq;
@property (nonatomic,strong) NSArray <Optional,HotCityModel> *hotCityList;
@end

@interface HotCityModel : JSONModel
@property (nonatomic,strong) NSString <Optional> *cityId;
@property (nonatomic,strong) NSString <Optional> *cityName;
@end

