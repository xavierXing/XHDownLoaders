//
//  XHDownLoadDB.m
//  XHDownLoder
//
//  Created by 邢浩 on 2016/12/30.
//  Copyright © 2016年 邢浩. All rights reserved.
//

#import "XHDownLoadDB.h"
#import "FMDB.h"
#import "XHSandBoxFile.h"
#import "XHDownLoadContent.h"

@interface XHDownLoadDB ()
/** 全局数据库 */
@property(nonatomic, strong)FMDatabase * db;
/** 数据库队列 */
@property(nonatomic, strong)FMDatabaseQueue * queue;
/** 全库数据库路径 */
@property(nonatomic, strong)NSString * database_path;

@end

@implementation XHDownLoadDB

static XHDownLoadDB * downloadObjc = nil;
+ (XHDownLoadDB *)shareDownLoadDB {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadObjc = [[XHDownLoadDB alloc] init];
    });
    return downloadObjc;
}
#pragma mark -增,删,改,查
- (void)creatDataBase:(NSString *)DBName WithListName:(nonnull NSString *)listName{
    [[XHSandBoxFile sharedSandBoxFile] creatSandBoxDataBaseFile];
    _database_path = [[XHSandBoxFile sharedSandBoxFile].filePath_dataBase stringByAppendingPathComponent:DBName];
    __weak typeof(self) weakself = self;
    [self.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            BOOL result = [db executeUpdate:[weakself creatListSqliteWithListName:listName]];
            if (result) {
                NSLog(@"creat list success");
            }else {
                NSLog(@"creat list fail");
            }
        }
        weakself.db = db;
    }];
}
- (void)insertDataWithDataBase:(nonnull NSString *)listName WithTarget:(nonnull XHDownLoadContent *)model {
    XHDownLoadContent * content = model;
    /** 插入数据:数据库要打开, 插入的必须是对象不能是基本数据类型 */
    __weak typeof(self) weakself = self;
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:[weakself insertListSqliteWithListName:listName],content.fileID,content.fileName,content.fileUrl,content.fileSize,content.fileType,content.fileTime,content.filePath_result,content.filePath_temp,@(content.fileStatus),@(content.currentFileSize)];
        if (result) {
            NSLog(@"insert list success");
        } else {
            NSLog(@"insert list fail");
        }
    }];
    
}
- (void)deleteDataWithDataBase:(NSString *)listName WithTarget:(nonnull XHDownLoadContent *)model {
    __weak typeof(self) weakself = self;
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:[weakself deleteListSqliteWithListName:listName WithFileID:model.fileID]];
        if (result) {
            NSLog(@"delete success");
        } else {
            NSLog(@"delete fail");
        }
    }];
}
- (void)updateDataWithDataBase:(NSString *)listName WithTarget:(nonnull XHDownLoadContent *)model {
    __weak typeof(self) weakself = self;
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:[weakself updateListSqliteWithListName:listName WithFileID:model.fileID WithFileTarger:model]];
        if (result) {
            NSLog(@"update success");
        } else {
            NSLog(@"update fail");
        }
    }];
}
- (void)queryDataWithDataBase:(NSString *)listName WithBlcok:(nonnull quertData)block {
    NSMutableArray * resultArray = [NSMutableArray new];
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@",listName];
        FMResultSet * resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            XHDownLoadContent * content = [[XHDownLoadContent alloc] init];
            content.fileID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"fileID"]];
            content.fileName = [resultSet stringForColumn:@"fileName"];
            content.fileUrl = [resultSet stringForColumn:@"fileUrl"];
            content.fileSize = [resultSet stringForColumn:@"fileSize"];
            content.fileType = [resultSet stringForColumn:@"fileType"];
            content.fileTime = [resultSet stringForColumn:@"fileTime"];
            content.filePath_result = [resultSet stringForColumn:@"filePath_result"];
            content.filePath_temp = [resultSet stringForColumn:@"filePath_temp"];
            content.fileStatus = [resultSet intForColumn:@"fileStatus"];
            content.currentFileSize = [resultSet intForColumn:@"currentFileSize"];
            [resultArray addObject:content];
        }
        if (block) {
            block(resultArray);
        }
    }];
}

#pragma mek -sql语句
- (NSString *)creatListSqliteWithListName:(NSString *)listName {
    NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (fileID integer PRIMARY KEY AUTOINCREMENT,fileName text,fileUrl text,fileSize text,fileType text,fileTime text,filePath_result text,filePath_temp text,fileStatus integer,currentFileSize integer);",listName];
    return sql;
}
- (NSString *)insertListSqliteWithListName:(NSString *)listName {
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO %@ (fileID,fileName,fileUrl,fileSize,fileType,fileTime,filePath_result,filePath_temp,fileStatus,currentFileSize) VALUES (?,?,?,?,?,?,?,?,?,?);",listName];
    return sql;
}
- (NSString *)deleteListSqliteWithListName:(NSString *)listName WithFileID:(NSString *)fileID {
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE fileID = %@",listName,fileID];
    return sql;
}
- (NSString *)updateListSqliteWithListName:(NSString *)listName WithFileID:(NSString *)fileID WithFileTarger:(XHDownLoadContent *)model {
    NSString * sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = %@ , %@ = %@ , %@ = %@, %@ = %@ , %@ = %@ , %@ = %@, %@ = %@ , %@ = %@ , %@ = %@ WHERE fileID = %ld",listName,@"fileName",model.fileName,@"fileUrl",model.fileUrl,@"fileSize",model.fileSize,@"fileType",model.fileType,@"fileTime",model.fileTime,@"filePath_result",model.filePath_result,@"filePath_temp",model.filePath_temp,@"fileStatus",@(model.fileStatus),@"currentFileSize",@(model.currentFileSize),fileID.integerValue];
    
    return sql;
}
#pragma mark -属性
- (FMDatabaseQueue *)queue {
    if (!_queue) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:_database_path];
    }
    return _queue;
}

@end
