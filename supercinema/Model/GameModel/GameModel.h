//
//  GameModel.h
//  supercinema
//
//  Created by dust on 2017/2/9.
//
//

#import <JSONModel/JSONModel.h>
#import "UserModel.h"

@interface GameChestModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* id;
@property(nonatomic,strong) NSNumber<Optional>* status;
@end

@interface GameDataModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* dayFinishPlayTimes;
@property(nonatomic,strong) NSNumber<Optional>* dayPlayMayGetGoodsTimes;
@property(nonatomic,strong) NSNumber<Optional>* dayPlayMayGetChestTimes;
@property(nonatomic,strong) NSNumber<Optional>* roundGameTime;
@property(nonatomic,strong) NSNumber<Optional>* totalValidGoldCount;
@property(nonatomic,strong) NSNumber<Optional>* totalPlayTimes;
@property(nonatomic,strong) GameChestModel<Optional>* chest;
@end

@interface GameUserDataModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* currentTime;
@property(nonatomic,strong) NSString<Optional>* defaultCinemaId;
@property(nonatomic,strong) BrowseUserModel<Optional>* user;
@property(nonatomic,strong) GameDataModel<Optional>* gameData;
@property(nonatomic,strong) NSArray<Optional>* supports;
@end

//开始游戏
@protocol StrokesIndexAndCountListModel;
@interface GameStartModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* currentTime;
@property(nonatomic,strong) NSNumber<Optional>* roundId;
@property(nonatomic,strong) NSNumber<Optional>* firstPlay;
@property(nonatomic,strong) NSString<Optional>* defaultCinemaId;
@property(nonatomic,strong) NSArray<Optional,StrokesIndexAndCountListModel>* strokesIndexAndCountList;
@end

@interface StrokesIndexAndCountListModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* strokesIndex;
@property(nonatomic,strong) NSString<Optional>* count;
@end

//完成游戏
@protocol GameGoodsList;
@interface GameFinishModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* currentTime;
@property(nonatomic,strong) NSNumber<Optional>* firstPlayGoods;
@property(nonatomic,strong) NSArray<Optional,GameGoodsList>* gameGoodsList;
@property(nonatomic,strong) NSNumber<Optional>* goodsCount;
@end


//领取奖励
@protocol GameGoodsList;
@interface GameReceiveChestModel : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* respStatus;
@property(nonatomic,strong) NSString<Optional>* respMsg;
@property(nonatomic,strong) NSString<Optional>* seq;
@property(nonatomic,strong) NSNumber<Optional>* currentTime;
@property(nonatomic,strong) NSNumber<Optional>* goodsCount;
@property(nonatomic,strong) NSArray<Optional,GameGoodsList>* gameGoodsList;
@end

@interface GameGoodsList : JSONModel
@property(nonatomic,strong) NSNumber<Optional>* id;
@property(nonatomic,strong) NSString<Optional>* resourceName;
@property(nonatomic,strong) NSNumber<Optional>* singleSendCount;
@property(nonatomic,strong) NSString<Optional>* unitName;
@property(nonatomic,strong) NSNumber<Optional>* worth;
@property(nonatomic,strong) NSNumber<Optional>* resourceType;
@end










