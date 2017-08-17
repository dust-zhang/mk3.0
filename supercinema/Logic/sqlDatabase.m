//
//  sqlDatabase.m
//  bjnewshd
//
//  Created by dust on 14-7-28.
//
//

#import "sqlDatabase.h"
#import "FMDatabase.h"
#import <sys/xattr.h>

@implementation sqlDatabase

//获取数据库文件路径
+(NSString *) getDbPath
{
    //获取Document文件夹下的数据库文件，没有则创建
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSLog(@"%@",docPath);
    return [docPath stringByAppendingPathComponent:@"db_movikr.sqlite"];
}

//审核不通过问题解决
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if (NSURLIsExcludedFromBackupKey == nil)
    { // iOS <= 5.0.1
        const char* filePath = [[URL path] fileSystemRepresentation];
        const char* attrName = "com.movikr.supercinema";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    else
    { // iOS >= 5.1
        NSError *error = nil;
        [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        return error == nil;
    }
}
//创建数据库
+(BOOL) createTable:(NSString *)tableName
{
    //防止文件备份到icould
    [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[self getDbPath] ]];
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:[self getDbPath]];
    if (![database open])
    {
        NSLog(@"Open database failed");
        return FALSE;
    }
    //创建栏目表
    if (![database executeUpdate:tableName] )
    {
        [database close];
        return TRUE;
    }
    //关闭数据库
    [database close];
    return TRUE;
}

//通知**************************************************************************************************************
+(BOOL) insertNoticeData:(NSMutableArray *)array cinemaId:(NSString *)_cinemaId
{
    FMDatabase *database  = [FMDatabase databaseWithPath:[self getDbPath]];
    if (![database open])
    {
        NSLog(@"Open database failed");
        return FALSE;
    }
    
    for (NSUInteger i = 0 ; i<[array count]; i++)
    {
        NotifyListModel * notifyModel=[array objectAtIndex:i];
        
        if([notifyModel.status intValue] == 1) //只有已审核的才保存到本地
        {
            [database executeUpdate:@"insert into table_notice values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                  notifyModel.notifyId,
                  _cinemaId,
                  [Tool returnTime:notifyModel.validStartTime format:@"yyyy-MM-dd HH:mm:ss"],
                  [Tool returnTime:notifyModel.validEndTime format:@"yyyy-MM-dd HH:mm:ss"],
                  [Tool returnTime:notifyModel.activityEndTime format:@"yyyy-MM-dd HH:mm:ss"],
                  [Tool returnTime:notifyModel.lastUpdateTime format:@"yyyy-MM-dd HH:mm:ss"],
                  notifyModel.title,
                  notifyModel.notifyType,
                  notifyModel.jumpType,
                  notifyModel.jumpUrl,
                  notifyModel.movieId,
                  notifyModel.notifyImageUrl,
                  notifyModel.imageJumpUrlType,
                  notifyModel.notifyContent,
                  notifyModel.actionType,
                  notifyModel.conditionId,
                  notifyModel.frequencyType,
                  [Tool returnTime:notifyModel.currentTime format:@"yyyy-MM-dd HH:mm:ss"],
             @"0"];
            
        }
    }
    [database close];
    return TRUE;
}
+(NSMutableArray *) selectNoticeData:(NSString *)sql
{
    FMDatabase *database  = [FMDatabase databaseWithPath:[self getDbPath]];
    if (![database open])
    {
        NSLog(@"Open database failed");
    }
    
    FMResultSet* set = [database executeQuery:sql];
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    while ([set next])
    {
       NotifyListModel * notifyModel= [[NotifyListModel alloc ] init ];
        notifyModel.notifyId        = [NSNumber numberWithInt:[[set stringForColumn:@"notifyId"] intValue]];
        notifyModel.cinemaId        = [NSNumber numberWithInt:[[set stringForColumn:@"cinemaid"] intValue]];
        notifyModel.validStartTime  = [self stringFormat:[Tool returnTimestamp:[set stringForColumn:@"validStartTime"]]];
        notifyModel.validEndTime    = [self stringFormat:[Tool returnTimestamp:[set stringForColumn:@"validEndTime"]]];
        notifyModel.activityEndTime = [self stringFormat:[Tool returnTimestamp:[set stringForColumn:@"activityEndTime"]]];
        notifyModel.lastUpdateTime  = [self stringFormat:[Tool returnTimestamp:[set stringForColumn:@"lastupdatetime"]]];
        notifyModel.title           = [set stringForColumn:@"title"] ;
        notifyModel.notifyType      = [NSNumber numberWithInt:[[set stringForColumn:@"notifyType"] intValue]];
        notifyModel.jumpType        = [NSNumber numberWithInt:[[set stringForColumn:@"jumpType"] intValue]];
        notifyModel.jumpUrl         = [set stringForColumn:@"jumpUrl"];
        notifyModel.movieId         = [set stringForColumn:@"movieId"];
        notifyModel.notifyImageUrl  = [set stringForColumn:@"notifyImageUrl"];
        notifyModel.imageJumpUrlType  = [NSNumber numberWithInt:[[set stringForColumn:@"imageJumpUrlType"] intValue]];  
        notifyModel.notifyContent   = [set stringForColumn:@"notifyContent"];
        notifyModel.actionType      = [NSNumber numberWithInt:[[set stringForColumn:@"actionType"] intValue]];
        notifyModel.conditionId     = [NSNumber numberWithInt:[[set stringForColumn:@"conditionId"] intValue]];
        notifyModel.frequencyType   = [NSNumber numberWithInt:[[set stringForColumn:@"frequencyType"] intValue]];
        notifyModel.currentTime     = [self stringFormat:[Tool returnTimestamp:[set stringForColumn:@"currSysTime"]]];
        notifyModel.showHide        = [NSNumber numberWithInt:[[set stringForColumn:@"showHide"] intValue]];
        [array addObject:notifyModel];
    }
    [database close];
    return array;
}
+(NSNumber*) stringFormat:(NSNumber*)str
{
    NSString *strRes=[str stringValue];
    
    if ([[str stringValue] length]<13)
    {
        for (int i = 0; i< 13- [[str stringValue] length]; i++)
        {
            strRes = [strRes stringByAppendingString:@"0"];
        }
        return (NSNumber*)strRes  ;
    }
    else
    {
        return str;
    }
}
/*showHide状态：
0:刚插入状态显示
1：已经显示，以后不再显示
2：今天已经显示，以后每天都显示
3：只弹出没有查看，再次打开app继续显示
 
 frequencyType
 //频次
 1:用户首次触发成功后，不再触发,
 2:每日首次满足条件触发
 3:每次满足条件均触发）
*/
+(BOOL ) updateNotice:(NSNumber *)notifyId status:(NSNumber *)status
{
    NSString * sql = [NSString stringWithFormat:@"update table_notice set showHide = '%@' where notifyId='%@' and cinemaid='%@' ",status,notifyId,[Config getCinemaId]];
    if([self createTable:sql])
    {
        return TRUE;
    }
    return FALSE;
}

+(BOOL ) updateNotice:(NSNumber *)status cinemaId:(NSString *)id
{
    NSString * sql = [NSString stringWithFormat:@"update table_notice set showHide = '0' where cinemaid='%@' and showHide= '%@' ",id,status];
    if([self createTable:sql])
    {
        return TRUE;
    }
    return FALSE;
}

+(BOOL) deleteNotice:(NSString *)sql
{
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:[self getDbPath]];
    if (![database open])
    {
        NSLog(@"Open database failed");
        return FALSE;
    }
    if (![database executeUpdate:sql ] )
    {
        return FALSE;
    }
    //关闭数据库
    [database close];
    return TRUE;
}

//**************************************************************************************************************
+(CinemaPullModel *)selectCinemaTime:(NSString *)_cinemaId
{
    FMDatabase *database  = [FMDatabase databaseWithPath:[self getDbPath]];
    if (![database open])
    {
        NSLog(@"Open database failed");
    }
    NSString *strSql =[NSString stringWithFormat:@"select * from table_pull where cinemaid = '%@' ",_cinemaId ];
    FMResultSet* set = [database executeQuery:strSql ];
    CinemaPullModel * cinemaPullModel = nil;
    while ([set next])
    {
        CinemaPullModel * cinemaPullModel1 = [[CinemaPullModel alloc ] init];
        cinemaPullModel1.cinemaId  = [NSNumber numberWithInt:[[set stringForColumn:@"cinemaid"] intValue]];
        cinemaPullModel1.pullTime  = [set stringForColumn:@"pulldatetime"];
        cinemaPullModel =cinemaPullModel1;
    }
    //关闭数据库
    [database close];
     return cinemaPullModel;
}
+(BOOL) insertPullTime:(NSNumber *)pullTime cinemaId:(NSString *)_cinemaId
{
    FMDatabase *database  = [FMDatabase databaseWithPath:[self getDbPath]];
    if (![database open])
    {
        NSLog(@"Open database failed");
        return FALSE;
    }
    if( ![database executeUpdate:@"insert into table_pull values (?,?)",_cinemaId,pullTime])
    {
        return FALSE;
    }
    [database close];
    return TRUE;
}

+(BOOL) updateTablePull:(NSString *)sql
{
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:[self getDbPath]];
    if (![database open])
    {
        NSLog(@"Open database failed");
        return FALSE;
    }
    if (![database executeUpdate:sql ] )
    {
        return FALSE;
    }
    //关闭数据库
    [database close];
    return TRUE;
}

+(BOOL) dropTable:(NSString *)tableName
{
    //获取数据库并打开
    FMDatabase *database  = [FMDatabase databaseWithPath:[self getDbPath]];
    if (![database open])
    {
        NSLog(@"Open database failed");
        return FALSE;
    }
    if (![database executeUpdate:[NSString stringWithFormat:@"drop table %@",tableName] ] )
    {
        return FALSE;
    }
    //关闭数据库
    [database close];
    return TRUE;
}


@end
