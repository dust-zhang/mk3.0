//
//  MovieItem.h
//  movikr
//
//  Created by zeyuan on 15/6/23.
//  Copyright (c) 2015年 movikr. All rights reserved.
//
#import <JSONModel/JSONModel.h>

//预告片model
@interface TrailerModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *videoId;
@property (nonatomic,strong) NSString <Optional> *videoUrl;
@property (nonatomic,strong) NSString <Optional> *coverImageUrl;
@end

@protocol StillModel;
@protocol TagModel;
@interface MovieModel : JSONModel
@property (nonatomic,strong) NSNumber<Optional>*            movieId;
@property (nonatomic,strong) NSString<Optional>*            movieTitle;
@property (nonatomic,strong) NSString<Optional>*            rate;                 //评分
@property (nonatomic,strong) NSString<Optional>*            releaseDate;          //上映日期
@property (nonatomic,strong) NSString<Optional>*            shortDescription;     //一句话
@property (nonatomic,strong) NSString<Optional>*            originName;           //产地
@property (nonatomic,strong) NSArray<Optional>*             emotionList;          //类型
@property (nonatomic,strong) NSString<Optional>*            logoUrl;
@property (nonatomic,strong) NSString<Optional>*            logoUrlOfBig;         //大的封面图片
@property (nonatomic,strong) NSArray<Optional>*             versionList;          //版本
@property (nonatomic,strong) NSNumber<Optional>*            buyTicketStatus;      //购票按钮状态  0：不能购票,1：正常购票,2：超前预售
@property (nonatomic,strong) NSNumber<Optional>*            userIsFollow;
@property (nonatomic,strong) NSNumber<Optional>*            followCount;
@property (nonatomic,strong) NSArray<Optional>*             actorList;            //演员
@property (nonatomic,strong) NSArray<Optional>*             directorList;         //导演
@property (nonatomic,strong) NSString<Optional>*            plot;                 //剧情
@property (nonatomic,strong) NSArray<StillModel,Optional>*  stillList;            //剧照集合
@property (nonatomic,strong) TrailerModel <Optional>*       trailer;              //预告片信息
@property (nonatomic,strong) NSString<Optional>*            doubanRate;           //豆瓣评分
@property (nonatomic,strong) NSString<Optional>*            imdbRate;             //imdb评分
@property (nonatomic,strong) NSArray<TagModel,Optional>*    tagList;              //标签集合
@property (nonatomic,strong) NSArray<Optional>*             movieViewTipList;     //观影提示
@property (nonatomic,strong) NSString<Optional>*            logoLandscapeUrl;     //横图Url
@property (nonatomic,strong) NSNumber<Optional>*            followTime;           //想看时间
@property (nonatomic,strong) NSNumber<Optional>*            duration;             //时长
@property (nonatomic,strong) NSArray<Optional>*             producerList;         //制片人列表
@property (nonatomic,strong) NSString<Optional>*            haibaoUrl;
@end

//剧照model
@interface StillModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *id;
@property (nonatomic,strong) NSString <Optional> *url;
@property (nonatomic,strong) NSString <Optional> *urlOfBig;
@end

//标签model
@interface TagModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *id;
@property (nonatomic,strong) NSString <Optional> *tagName;
@end

//关注影片list
@protocol MovieModel;
@interface FollowMovieListModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *seq;
@property (nonatomic,strong) NSArray <Optional,MovieModel> *movieList;
@property (nonatomic,strong) NSNumber <Optional> *pageIndex;
@property (nonatomic,strong) NSNumber <Optional> *pageTotal;
@property (nonatomic,strong) NSNumber <Optional> *totoalCount;
@property (nonatomic,strong) NSNumber <Optional> *currentTime;
@end

