//
//  MyMovieListModel.h
//  supercinema
//
//  Created by dust on 16/12/10.
//
//

#import <JSONModel/JSONModel.h>

@protocol MyMovieModel;
@interface MyMovieListModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>*  respStatus;
@property (nonatomic,strong) NSString<Optional>*  respMsg;
@property (nonatomic,strong) NSString<Optional>*  seq;
@property (nonatomic,strong) NSString<Optional>*  pageIndex;
@property (nonatomic,strong) NSString<Optional>*  pageTotal;
@property (nonatomic,strong) NSNumber<Optional>*  totalCount;
@property (nonatomic,strong) NSNumber <Optional> *currentTime;
@property (nonatomic,strong) NSArray<Optional,MyMovieModel>*   movieList;

@end



@interface MyMovieModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>*  movieId;
@property (nonatomic,strong) NSString<Optional>*  movieTitle;
@property (nonatomic,strong) NSString<Optional>*  rate;
@property (nonatomic,strong) NSString<Optional>*  myRate;
@property (nonatomic,strong) NSString<Optional>*  reviewId;
@property (nonatomic,strong) NSString<Optional>*  releaseDate;
@property (nonatomic,strong) NSString<Optional>*  shortDescription;
@property (nonatomic,strong) NSString<Optional>*  logoUrl;
@property (nonatomic,strong) NSNumber<Optional>*  buyTicketStatus;
@property (nonatomic,strong) NSNumber<Optional>*  followTime;

@end
