//
//  XHSandBoxFile.m
//  XHDownLoder
//
//  Created by 邢浩 on 2016/12/29.
//  Copyright © 2016年 邢浩. All rights reserved.
//

#import "XHSandBoxFile.h"

#define document_filePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define library_filePath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]
#define tmp_filePath NSTemporaryDirectory()
#define cache_filePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define file_manager [NSFileManager defaultManager]

#define down_string @"download"
#define resultSourcePath @"resultSource"
#define tempSourcePath @"tempSource"
#define database_string @"database"

@interface XHSandBoxFile()

@end
@implementation XHSandBoxFile

static XHSandBoxFile * sandBoxObj = nil;
+ (XHSandBoxFile *)sharedSandBoxFile {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sandBoxObj = [[XHSandBoxFile alloc] init];
    });
    return sandBoxObj;
}
- (NSString *)getSandBoxDocumentFilePath {
    return document_filePath;
}
- (NSString *)getSandBoxTempFilePath {
    return tmp_filePath;
}
- (NSString *)getSandBoxLibraryFilePath {
    return library_filePath;
}
- (NSString *)getSandBoxCacheFilePath {
    return cache_filePath;
}

#pragma mark -操作沙盒:创建下载数据文件夹
- (BOOL)creatSandBoxDownLoadFilePathWithResult {
    return [file_manager createDirectoryAtPath:self.filePath_result withIntermediateDirectories:YES attributes:nil error:nil];
}
- (BOOL)creatSandBoxDownLoadFilePathWithTemp {
    return [file_manager createDirectoryAtPath:self.filePath_temp withIntermediateDirectories:YES attributes:nil error:nil];
}
- (BOOL)creatSandBoxDataBaseFile {
    return [file_manager createDirectoryAtPath:self.filePath_dataBase withIntermediateDirectories:YES attributes:nil error:nil];
}
#pragma mark -操作沙盒:写,读,删,移
- (BOOL)writeFileToSandBoxWithDocumentPath:(NSData *)data
                              WithFilePath:(NSString *)fileName {
    NSString * filePath = [self.filePath_result stringByAppendingPathComponent:fileName];
    return [data writeToFile:filePath atomically:YES];
}
- (NSData *)readFileFromSandBoxWithDocumentFilePath:(NSString *)fileName {
    NSString * filePath = [self.filePath_result stringByAppendingPathComponent:fileName];
    return [NSData dataWithContentsOfFile:filePath];
}
- (BOOL)deleteFileFromSandBoxDocumentWithFilePath:(NSString *)fileName {
    NSString * filePath = [self.filePath_result stringByAppendingPathComponent:fileName];
    return [file_manager removeItemAtPath:filePath error:nil];
}
- (BOOL)deleteFileFromSandBoxTempWithFilePath:(NSString *)fileName {
    NSString * filePath = [self.filePath_temp stringByAppendingPathComponent:fileName];
    return [file_manager removeItemAtPath:filePath error:nil];
}
- (BOOL)moveFileFromSandBoxWithFileName:(NSString *)fileName {
    NSString * currentPath = [self.filePath_temp stringByAppendingPathComponent:fileName];
    NSString * purposePath = [self.filePath_result stringByAppendingPathComponent:fileName];
    return [file_manager moveItemAtPath:currentPath toPath:purposePath error:nil];
}

#pragma mark -属性
- (NSString *)filePath_result {
    if (!_filePath_result) {
        _filePath_result = [[document_filePath stringByAppendingPathComponent:down_string] stringByAppendingPathComponent:resultSourcePath];
    }
    return _filePath_result;
}

- (NSString *)filePath_temp {
    if (!_filePath_temp) {
        _filePath_temp = [[document_filePath stringByAppendingPathComponent:down_string] stringByAppendingPathComponent:tempSourcePath];
    }
    return _filePath_temp;
}

- (NSString *)filePath_dataBase {
    if (!_filePath_dataBase) {
        _filePath_dataBase = [document_filePath stringByAppendingPathComponent:database_string];
    }
    return _filePath_dataBase;
}
@end
