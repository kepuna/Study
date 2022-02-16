//
//  ZZThread6ViewController.m
//  ZZKit
//
//  Created by donews on 2019/6/5.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZThread6ViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface ZZThread6ViewController ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation ZZThread6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self demoSession];
}

// 异步串行
- (void)demoAFN { // AFN3.0完成回调是在主线程
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    
    for (NSInteger index = 0; index < 10; index++) {
        dispatch_async(queue, ^{
            NSLog(@"任务%zd 开始 >>>%@",index,[NSThread currentThread]);
            NSString *url=@"https://www.baidu.com";
            [self.manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@">>>完成任务%zd ",index);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@">>>任务%zd失败 !!!",index);
            }];
            NSLog(@"任务%zd 结束...",index);
        });
    }
    
}

- (void)demoSession {
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    
    for (NSInteger index = 0; index < 100; index++) {
        dispatch_async(queue, ^{
            NSLog(@"任务%zd 开始 >>>%@",index,[NSThread currentThread]);
            NSURL *url = [NSURL URLWithString:@"http://baidu.com"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            request.HTTPMethod = @"POST";
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            configuration.timeoutIntervalForRequest = 10;
            configuration.HTTPMaximumConnectionsPerHost = 1;
            NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
            NSURLSessionTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     NSLog(@"回调线程%@",[NSThread currentThread]);
                                                }];
            [task resume];
        });
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
