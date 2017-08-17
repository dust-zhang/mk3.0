//
//  sqlDatabase.h
//  bjnewshd
//
//  Created by dust on 14-7-28.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import <sys/xattr.h>
#import "UpLoadModel.h"
#import "NotifictionModel.h"

#define table_notice @"create table table_notice (notifyId integer PRIMARY KEY,cinemaid text,validStartTime datetime,validEndTime datetime,activityEndTime datetime,lastupdatetime datetime,title text,notifyType text,jumpType text,jumpUrl text,movieId text,notifyImageUrl text,imageJumpUrlType text,notifyContent text,actionType text,conditionId text,frequencyType text,currSysTime datetime,showHide int default 0 )"
#define table_pull @"create table table_pull (cinemaid integer PRIMARY KEY,pulldatetime text )"


@interface sqlDatabase : NSObject

+(BOOL) createTable:(NSString *)tableName;

//插入通知数据
+(BOOL) insertNoticeData:(NSMutableArray *)array cinemaId:(NSString *)_cinemaId;;
+(NSMutableArray *) selectNoticeData:(NSString *)sql;
+(BOOL ) updateNotice:(NSNumber *)notifyId status:(NSNumber *)status;
+(BOOL ) updateNotice:(NSNumber *)status cinemaId:(NSString *)id;
//补齐0
+(NSNumber*) stringFormat:(NSNumber*)str;
+(BOOL) deleteNotice:(NSString *)sql;
//获取影院上次拉取时间
+(CinemaPullModel *)selectCinemaTime:(NSString *)_cinemaId;
+(BOOL) insertPullTime:(NSNumber *)pullTime cinemaId:(NSString *)_cinemaId;
+(BOOL) updateTablePull:(NSString *)sql;
+(BOOL) dropTable:(NSString *)tableName;

@end
