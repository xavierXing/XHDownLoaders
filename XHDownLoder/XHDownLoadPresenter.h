//
//  XHDownLoadPresenter.h
//  XHDownLoder
//
//  Created by 邢浩 on 2016/12/29.
//  Copyright © 2016年 邢浩. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {/**下载状态枚举*/
    downLoadStatus_downing,/**下载中*/
    downLoadStatus_pause,/**下载暂停*/
    downLoadStatus_wait,/**下载等待*/
    downLoadStatus_finish,/**下载完成*/
    downLoadStatus_fault,/**下载失败*/
    downLoadStatus_error,/**下载错误*/
} downLoadStatus;

@protocol XHDownLoadPresenterDelegate <NSObject>
/** 更新进度条 */
- (void)updateProgressLoadView:(float)progress WithUrl:(NSURL *)url;

@end

@interface XHDownLoadPresenter : NSObject

/** Objc代理 */
@property(nonatomic, weak)id<XHDownLoadPresenterDelegate> downLoadPresenterDelegate;


/**单例:实例化此对象*/
+ (XHDownLoadPresenter *)sharedPresenter;
/**sel:开始下载 parameter:下载的url*/
- (void)startDownLoadRequestUrlString:(NSString *)urlString;
/**sel:暂停下载 parameter:暂停的url*/
- (void)pauseDownLoadRequestUrlString:(NSString *)urlString;
/**sel:恢复下载 parameter:恢复的url*/
- (void)recoverDownLoadRequestUrlString:(NSString *)urlString;
/**sel:取消下载 parameter:取消的url*/
- (void)cancleDownLoadRequestUrlString:(NSString *)urlString;
/**sel:获取当前下载任务的状态 parameter:想要获取状态的url*/
- (downLoadStatus)getDownloadStatus:(NSString *)urlString;
/**sel:改变当前下载任务的状态 parameter:当前下载的url parameter:当前状态 parameter:目的状态*/
- (void)changeDownloadStatusWithUrl:(NSString *)urlString
                  WithCurrentStatus:(downLoadStatus)currentStatus
                  WithPurposeStatus:(downLoadStatus)purposeStatus;

@end
