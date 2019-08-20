//
//  ZZThread1ViewController.m
//  ZZKit
//
//  Created by donews on 2019/5/17.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZThread1ViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface ZZThread1ViewController ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation ZZThread1ViewController

/**
 第一步：客户端请求服务器，拿到服务器生成的七牛token
 第二步：客户端上传图片到七牛，成功后拿到七牛返回的图片地址
 第三步：将图片地址再次上传到服务器
 先得到token，再上传七牛，最后上传服务器图片地址，顺序不可乱。
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo1];
}

- (void)demo1 {
    //第一步：获取token
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self task_1];
    }];
    
    //第二步：上传七牛
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self task_2];
    }];
    
    //第三步：图片地址上传服务器
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self task_3];
    }];
    
    //设置依赖
    [operation2 addDependency:operation1];      //任务二依赖任务一
    [operation3 addDependency:operation2];      //任务三依赖任务二
    
    //创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation3, operation2, operation1] waitUntilFinished:NO];
    
    /*
     
     再次引入问题：
     上文说了，task_2为发送图片到七牛，修改头像这种一张图片上传没问题。
     但是项目需求，需要一次上传很多张图片。七牛并没有提供多图片上传，最后希望达到效果，task_2任务包含大量的图片的并发上传。
     
     详情看简书吧
     
     */
}

#pragma mark - Event Method

- (void)task_1 {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSString *url=@"https://www.baidu.com";
    [self.manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@">>>>>> 第一步：获取token ");
        
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@">>>>>> 第一步：获取token失败");
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)task_2 {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSString *url=@"https://www.baidu.com";
    [self.manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@">>>>>> 第二步：上传七牛");
        
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@">>>>>> 第二步：上传七牛失败");
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

- (void)task_3 {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSString *url=@"https://www.baidu.com";
    [self.manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@">>>>>> 第三步：图片地址上传服务器");
        
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@">>>>>> 第三步：图片地址上传服务器失败");
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}


#pragma mark - Getters & Setters
-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager=[AFHTTPSessionManager manager];
        _manager.requestSerializer.timeoutInterval = 20;
        _manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    }
    return _manager;
}


@end
