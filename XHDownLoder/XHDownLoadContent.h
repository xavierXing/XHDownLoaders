//
//  XHDownLoadContent.h
//  XHDownLoder
//
//  Created by 邢浩 on 2017/1/1.
//  Copyright © 2017年 邢浩. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DownLoadStatus_downing,/** 正在下载 */
    DownLoadStatus_pause,/** 下载暂停 */
    DownLoadStatus_fail,/** 下载失败 */
    DownLoadStatus_finish,/** 下载完成 */
    DownLoadStatus_wait,/** 下载等待 */
} DownLoadStatus;

@interface XHDownLoadContent : NSObject

@property(nonatomic, strong)NSString * fileID;/** 文件ID:唯一 */
@property(nonatomic, strong)NSString * fileName;/** 文件名称 */
@property(nonatomic, strong)NSString * fileUrl;/** 文件下载的url */
@property(nonatomic, strong)NSString * fileSize;/** 文件总大小 */
@property(nonatomic, strong)NSString * fileType;/** 文件类型 */
@property(nonatomic, strong)NSString * fileTime;/** 文件开始下载的时间 */
@property(nonatomic, strong)NSString * filePath_result; /** 文件存放路径 */
@property(nonatomic, strong)NSString * filePath_temp;/** 文件暂时存放路径 */
@property(nonatomic, assign)DownLoadStatus fileStatus;/** 文件下载状态 */
@property(nonatomic, assign)long long currentFileSize;/** 当前文件接收了多少data */

#pragma mark -初始化
- (instancetype)initWithUrl:(NSString *)url;

@end
