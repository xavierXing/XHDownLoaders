//
//  XHDownLoadContent.m
//  XHDownLoder
//
//  Created by 邢浩 on 2017/1/1.
//  Copyright © 2017年 邢浩. All rights reserved.
//

#import "XHDownLoadContent.h"

#define fileType_video @"video/mp4"
#define unknow @"未知"
@implementation XHDownLoadContent

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.fileName = url.lastPathComponent;
        self.fileUrl = url;
        self.fileSize = unknow;
        self.fileTime = [self creatFileDownLoadDate:[NSDate new]];
        self.fileType = fileType_video;
        self.filePath_temp = unknow;
        self.filePath_result = unknow;
        self.fileStatus = DownLoadStatus_downing;
    }
    return self;
}
#pragma mark -生成时间
- (NSString *)creatFileDownLoadDate:(NSDate *)date {
    NSDateFormatter * matter = [NSDateFormatter new];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * dateStr = [matter stringFromDate:date];
    return dateStr;
}
@end
