//
//  XHDownLoadPresenter.m
//  XHDownLoder
//
//  Created by 邢浩 on 2016/12/29.
//  Copyright © 2016年 邢浩. All rights reserved.
//

#import "XHDownLoadPresenter.h"
#import "ASILibary/ASIHTTPRequest.h"
#import "ASILibary/ASINetworkQueue.h"
#import "XHSandBoxFile.h"
#import "XHDownLoadContent.h"

#define result_path [XHSandBoxFile sharedSandBoxFile].filePath_result
#define temp_path [XHSandBoxFile sharedSandBoxFile].filePath_temp
#define content_key @"content_key"

@interface XHDownLoadPresenter ()<ASIHTTPRequestDelegate,ASIProgressDelegate>

@property(nonatomic, strong)ASINetworkQueue * downLoadQueue;/** 下载队列 */
@end

@implementation XHDownLoadPresenter

static XHDownLoadPresenter * downloadObj = nil;
+ (XHDownLoadPresenter *)sharedPresenter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadObj = [[XHDownLoadPresenter alloc] init];
    });
    return downloadObj;
}

#pragma mark -下载"ACTION"
/** 开始下载 */
- (void)startDownLoadRequestUrlString:(NSString *)urlString {
    NSURL * downloadRequset = [NSURL URLWithString:urlString];
    [self creatDownLoadSandBoxResultFile];
    [self creatDownLoadSandBoxTempFile];
    ASIHTTPRequest * ASIRequest = [self creatDownLoadRequest:downloadRequset];
    [self.downLoadQueue addOperation:ASIRequest];
    [_downLoadQueue go];
    NSLog(@"%lu",(unsigned long)_downLoadQueue.operations.count);
}
/** 暂停下载 */
- (void)pauseDownLoadRequestUrlString:(NSString *)urlString {
    for (ASIHTTPRequest * request in self.downLoadQueue.operations) {
        if ([request.url.absoluteString isEqualToString:urlString]) {
            [request clearDelegatesAndCancel];
        }
    }
}
/** 恢复下载 */
- (void)recoverDownLoadRequestUrlString:(NSString *)urlString {
    NSURL * recoverRequest = [NSURL URLWithString:urlString];
    ASIHTTPRequest * ASIRequest = [self creatDownLoadRequest:recoverRequest];
    [self.downLoadQueue addOperation:ASIRequest];
    [self.downLoadQueue go];
}
/** 取消下载 */
- (void)cancleDownLoadRequestUrlString:(NSString *)urlString {
    for (ASIHTTPRequest * request in self.downLoadQueue.operations) {
        if ([request.url.absoluteString isEqualToString:urlString]) {
            [request clearDelegatesAndCancel];
        }
    }
    NSString * deleteFileName = [NSString stringWithFormat:@"%@.mp4",urlString];
    [[XHSandBoxFile sharedSandBoxFile] deleteFileFromSandBoxTempWithFilePath:deleteFileName];
}

- (downLoadStatus)getDownloadStatus:(NSString *)urlString {
    return 0;
}

- (void)changeDownloadStatusWithUrl:(NSString *)urlString
                  WithCurrentStatus:(downLoadStatus)currentStatus
                  WithPurposeStatus:(downLoadStatus)purposeStatus {
    
}

#pragma mark -创建ASI请求
- (ASIHTTPRequest *)creatDownLoadRequest:(NSURL *)url {
    XHDownLoadContent * contentDic = [[XHDownLoadContent alloc] initWithUrl:url.absoluteString];
    ASIHTTPRequest * downLoadReuqest = [[ASIHTTPRequest alloc] initWithURL:url];
    downLoadReuqest.delegate = self;
    downLoadReuqest.uploadProgressDelegate = self;
    downLoadReuqest.downloadProgressDelegate = self;
    downLoadReuqest.userInfo = [NSDictionary dictionaryWithObject:contentDic forKey:content_key];
    downLoadReuqest.showAccurateProgress = YES;
    downLoadReuqest.numberOfTimesToRetryOnTimeout = 2;
    downLoadReuqest.shouldContinueWhenAppEntersBackground = YES;
    downLoadReuqest.useCookiePersistence = YES;
    downLoadReuqest.allowResumeForFileDownloads = YES;
    downLoadReuqest.timeOutSeconds = 30;
    [downLoadReuqest setDownloadDestinationPath:[self creatFilePathName:result_path WithUrl:url]];
    [downLoadReuqest setTemporaryFileDownloadPath:[self creatFilePathName:temp_path WithUrl:url]];
    return downLoadReuqest;
}
/** 创建下载路径 */
- (NSString *)creatFilePathName:(NSString *)path WithUrl:(NSURL *)url {
    NSString * nameStr = [NSString stringWithFormat:@"%@.mp4",[url.absoluteString lastPathComponent]];
    NSString * totalStr = [path stringByAppendingPathComponent:nameStr];
    NSLog(@"%@",totalStr);
    return totalStr;
}

#pragma mark -ASIHTTPRequestDelegate
/** ASI请求开始 */
- (void)requestStarted:(ASIHTTPRequest *)request {
    
}
/** 接受到ASI请求头的时候 */
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    NSLog(@"%@",responseHeaders);
    XHDownLoadContent * content = [request.userInfo objectForKey:content_key];
    content.fileSize = [responseHeaders objectForKey:@"Content-Length"];
    content.filePath_result = request.downloadDestinationPath;
    content.filePath_temp = request.temporaryFileDownloadPath;
}
/** ASI请求已经完成 */
- (void)requestFinished:(ASIHTTPRequest *)request {
    
}
/** ASI请求失败 */
- (void)requestFailed:(ASIHTTPRequest *)request {
    
}

#pragma mark -ASIProgressDelegate
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes {
   
    XHDownLoadContent * content = [request.userInfo objectForKey:content_key];
    long long currentSize = content.currentFileSize + bytes;
    content.currentFileSize = currentSize;
    float newProgress = content.currentFileSize / content.fileSize.floatValue;
    if (self.downLoadPresenterDelegate &&
        [self.downLoadPresenterDelegate conformsToProtocol:@protocol(XHDownLoadPresenterDelegate)] &&
        [self.downLoadPresenterDelegate respondsToSelector:@selector(updateProgressLoadView:WithUrl:)]) {
        [self.downLoadPresenterDelegate updateProgressLoadView:newProgress WithUrl:request.url];
    }
}

#pragma mark -创建result，temp文件夹
- (void)creatDownLoadSandBoxResultFile {
    BOOL result =  [[XHSandBoxFile sharedSandBoxFile] creatSandBoxDownLoadFilePathWithResult];
    if (result) {
        NSLog(@"success ..");
    }
}
- (void)creatDownLoadSandBoxTempFile {
    BOOL result =[[XHSandBoxFile sharedSandBoxFile] creatSandBoxDownLoadFilePathWithTemp];
    if (result) {
        NSLog(@"success ...");
    }
}

#pragma mark -属性
- (ASINetworkQueue *)downLoadQueue {
    if (!_downLoadQueue) {
        _downLoadQueue = [[ASINetworkQueue alloc] init];
        [_downLoadQueue reset];
        [_downLoadQueue setRequestDidFailSelector:@selector(downLoadFail:)];
        [_downLoadQueue setRequestDidFinishSelector:@selector(downLoadFinish:)];
        [_downLoadQueue setRequestDidStartSelector:@selector(downLoadStart:)];
        [_downLoadQueue setRequestDidReceiveResponseHeadersSelector:@selector(downLoadReceiveHeaders:)];
        [_downLoadQueue setDelegate:self];
        [_downLoadQueue setDownloadProgressDelegate:self];
        [_downLoadQueue setShowAccurateProgress:YES];
        [_downLoadQueue setMaxConcurrentOperationCount:3];
    }
    return _downLoadQueue;
}
#pragma mark -属性SEL
- (void)downLoadStart:(ASIHTTPRequest *)requset {
    NSLog(@"start");
}

- (void)downLoadFinish:(ASIHTTPRequest *)requset {
    NSLog(@"finsh");
}

- (void)downLoadReceiveHeaders:(ASIHTTPRequest *)requset {
    NSLog(@"receive");
}

- (void)downLoadFail:(ASIHTTPRequest *)requset {
    NSLog(@"fail");
}
@end
