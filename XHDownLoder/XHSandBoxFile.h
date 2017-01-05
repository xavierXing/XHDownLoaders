//
//  XHSandBoxFile.h
//  XHDownLoder
//
//  Created by 邢浩 on 2016/12/29.
//  Copyright © 2016年 邢浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHSandBoxFile : NSObject

@property(nonatomic, strong, nullable)NSString * filePath_result;
@property(nonatomic, strong, nullable)NSString * filePath_temp;
@property(nonatomic, strong, nullable)NSString * filePath_dataBase;

+ (nonnull XHSandBoxFile *)sharedSandBoxFile;/**单例:实例化此对象*/

- (nonnull NSString *)getSandBoxDocumentFilePath;/**获取沙盒Document文件夹路径*/
- (nonnull NSString *)getSandBoxTempFilePath;/**获取沙盒Temp文件夹路径*/
- (nonnull NSString *)getSandBoxLibraryFilePath;/**获取沙盒Libary文件夹路径*/
- (nonnull NSString *)getSandBoxCacheFilePath;/**获取沙盒Cache文件夹路径*/

/**创建result文件夹,缓存已完成的下载数据*/
- (BOOL)creatSandBoxDownLoadFilePathWithResult;
/**创建result文件夹,缓存未完成的下载数据*/
- (BOOL)creatSandBoxDownLoadFilePathWithTemp;
/** 创建管理数据库文件的文件夹 */
- (BOOL)creatSandBoxDataBaseFile;
/**sel:将下载好的文件保存到沙盒中 parameter:下载好的数据 parameter:要保存文件的名字*/
- (BOOL)writeFileToSandBoxWithDocumentPath:(nonnull NSData *)data
                              WithFilePath:(nonnull NSString *)fileName;
/**sel:将下载的文件从沙盒中读取 parameter:要读取文件的名称*/
- (nonnull NSData *)readFileFromSandBoxWithDocumentFilePath:(nonnull NSString *)fileName;
/**sel:将下载的文件从沙盒中删除 parameter:要删除文件的名称*/
- (BOOL)deleteFileFromSandBoxDocumentWithFilePath:(nonnull NSString *)fileName;
/**sel:将下载中的文件从沙盒中删除 parameter:要删除文件的名称*/
- (BOOL)deleteFileFromSandBoxTempWithFilePath:(nonnull NSString *)fileName;
/**sel:将下载完成的文件从temp文件移动到result文件夹 parameter:要移动文件的名称*/
- (BOOL)moveFileFromSandBoxWithFileName:(nonnull NSString *)fileName;

@end
