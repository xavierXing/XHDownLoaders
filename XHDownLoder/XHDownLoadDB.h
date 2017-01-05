//
//  XHDownLoadDB.h
//  XHDownLoder
//
//  Created by 邢浩 on 2016/12/30.
//  Copyright © 2016年 邢浩. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHDownLoadContent;
typedef void(^quertData)(NSArray * _Nullable  source);
@interface XHDownLoadDB : NSObject

+ (nonnull XHDownLoadDB *)shareDownLoadDB;

#pragma mark -操作数据库
/** 创建数据 DBName后缀名必须以.sqlite命名*/
- (void)creatDataBase:(nonnull NSString *)DBName
         WithListName:(nonnull NSString *)listName;
/** 插入数据 */
- (void)insertDataWithDataBase:(nonnull NSString *)listName
                    WithTarget:(nonnull XHDownLoadContent *)model;
/** 删除数据 */
- (void)deleteDataWithDataBase:(nonnull NSString *)listName
                    WithTarget:(nonnull XHDownLoadContent *)model;
/** 更新数据 */
- (void)updateDataWithDataBase:(nonnull NSString *)listName
                    WithTarget:(nonnull XHDownLoadContent *)model;
/** 查询数据 */
- (void)queryDataWithDataBase:(nonnull NSString *)listName
                    WithBlcok:(nonnull quertData)block;

@end
