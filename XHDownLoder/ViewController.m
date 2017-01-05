//
//  ViewController.m
//  XHDownLoder
//
//  Created by 邢浩 on 2016/12/29.
//  Copyright © 2016年 邢浩. All rights reserved.
//
/**下载模块:waring --> 下载是要涉及到版权的,慎用啊!!!*/


#import "ViewController.h"
#import "XHSandBoxFile.h"
#import "XHDownLoadPresenter.h"
#import "XHDownLoadDB.h"
#import "XHDownLoadContent.h"

#define downloadurl @"http://dh-download.buddiestv.com/7c626913e0b0b3bbc1e227aad0507ff4"
#define downloadurl1 @"http://dh-download.buddiestv.com/cd321b91ea69e848a36b2e7f6e9af86b"
#define downloadurl2 @"http://dh-download.buddiestv.com/393ee6a8c69a21b6238f7cc6848a14fa"
#define downloadurl3 @"http://dh-download.buddiestv.com/aac879b92ee5d9c2cbcfb2083b29ac4e"

@interface ViewController ()<XHDownLoadPresenterDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progressLoadView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //2，获取Documents目录路径的方法：
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    NSLog(@"document 路径 -- %@",docDir);
    [XHDownLoadPresenter sharedPresenter].downLoadPresenterDelegate = self;
}

- (IBAction)beginDownLoadEvent:(id)sender {/**开始下载*/
    [[XHDownLoadDB shareDownLoadDB] creatDataBase:@"download.sqlite" WithListName:@"download"];
    
    
    
//    [[XHDownLoadPresenter sharedPresenter] startDownLoadRequestUrlString:downloadurl];
}

- (IBAction)pauseDownLoadEvent:(id)sender {/**暂停下载*/
//    [[XHDownLoadPresenter sharedPresenter] pauseDownLoadRequestUrlString:downloadurl];
    XHDownLoadContent * content = [[XHDownLoadContent alloc] initWithUrl:downloadurl];
    content.fileID = @"1";
    content.fileName = @"2";
    content.fileTime = @"3";
    content.fileType = @"4";
    content.fileStatus = 1;
    content.fileSize = @"5";
    content.filePath_temp = @"6";
    content.filePath_result = @"7";
    content.currentFileSize = 2;
    content.fileUrl = @"8";
    [[XHDownLoadDB shareDownLoadDB] insertDataWithDataBase:@"download" WithTarget:content];
}

- (IBAction)recoverDownLoadEvent:(id)sender {/**恢复下载*/
//    [[XHDownLoadPresenter sharedPresenter] recoverDownLoadRequestUrlString:downloadurl];
//    [[XHDownLoadDB shareDownLoadDB] deleteDataWithDataBase:@"download" WithTarget:@"1"];
    XHDownLoadContent * content = [[XHDownLoadContent alloc] initWithUrl:downloadurl];
    content.fileID = @"1";
    content.fileName = @"222222";
    content.fileTime = @"333333";
    content.fileType = @"444444";
    content.fileStatus = 111111;
    content.fileSize = @"5555555";
    content.filePath_temp = @"6666666";
    content.filePath_result = @"777777";
    content.currentFileSize = 222222;
    content.fileUrl = @"888888";
    [[XHDownLoadDB shareDownLoadDB] updateDataWithDataBase:@"download" WithTarget:content];
}

- (IBAction)deleteDownLoadEvent:(id)sender {/**取消下载*/
//    NSArray * source = [[XHDownLoadDB shareDownLoadDB] queryDataWithDataBase:@"download"];
    [[XHDownLoadDB shareDownLoadDB] queryDataWithDataBase:@"download" WithBlcok:^(NSArray * _Nullable source) {
        NSLog(@"%@",source);
    }];
}

- (void)updateProgressLoadView:(float)progress WithUrl:(NSURL *)url{
   
    [self.progressLoadView setProgress:progress];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
