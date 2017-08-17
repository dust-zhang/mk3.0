//
//  CardPackModel.h
//  supercinema
//
//  Created by dust on 16/11/28.
//
//

#import <JSONModel/JSONModel.h>
#import "MemberModel.h"

//有效卡包
@protocol cinemaAndCardRelationshipListModel;
@interface CardPackAllValidModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *seq;
@property (nonatomic,strong) NSArray <Optional,cinemaAndCardRelationshipListModel> *cinemaAndCardRelationshipList;
@end



@interface cinemaAndCardRelationshipListModel : JSONModel
@property (nonatomic,strong) CinemaModel <Optional> *cinema;
@property (nonatomic,strong) NSArray <Optional,CardListModel> *cardList;
@end


//无效卡包
@protocol cinemaAndCardRelationshipListModel;
@interface CardPackAllPastDueModel : JSONModel
@property (nonatomic,strong) NSNumber <Optional> *respStatus;
@property (nonatomic,strong) NSString <Optional> *respMsg;
@property (nonatomic,strong) NSString <Optional> *seq;
@property (nonatomic,strong) NSArray <Optional,cinemaAndCardRelationshipListModel> *cinemaAndCardRelationshipList;
@end
