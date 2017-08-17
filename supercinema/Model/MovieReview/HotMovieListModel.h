//
//  HotMovieList.h
//  movikr
//
//  Created by Mapollo27 on 15/9/14.
//  Copyright (c) 2015年 movikr. All rights reserved.
//

#import "JSONModel.h"

@interface MovieListModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>*   respStatus;
@property (nonatomic,strong) NSString<Optional>*   respMsg;
@property (nonatomic,strong) NSString<Optional>*   seq;
@property (nonatomic,strong) NSArray<Optional,MovieModel>*   hotMovieList;
@property (nonatomic,strong) NSArray<Optional,MovieModel>*   comingSoonMovieList;
@end

@interface SearchMovieListModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>*   respStatus;
@property (nonatomic,strong) NSString<Optional>*   respMsg;
@property (nonatomic,strong) NSNumber<Optional>*   currentTime;
@property (nonatomic,strong) NSString<Optional>*   seq;
@property (nonatomic,strong) NSNumber<Optional>*   pageSize;
@property (nonatomic,strong) NSNumber<Optional>*   pageTotal;
@property (nonatomic,strong) NSNumber<Optional>*   pageIndex;
@property (nonatomic,strong) NSArray<Optional,MovieModel>*   movieList;
@end
