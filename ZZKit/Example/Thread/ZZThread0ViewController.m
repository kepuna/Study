//
//  ZZThread0ViewController.m
//  ZZKit
//
//  Created by donews on 2019/5/17.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZThread0ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "DNStatisticWeakTimer.h"

@interface ZZThread0ViewController ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) DNStatisticWeakTimer *timer; // 定时器问题 和 线程问题

@property (nonatomic, strong) dispatch_group_t group;
@property (nonatomic, strong) dispatch_queue_t queue ;


@end

@implementation ZZThread0ViewController

- (void)dealloc {
    [self __removeTimer];
    NSLog(@">>> %s 销毁",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self demo1];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self __removeTimer];
}

- (void)__addTimer {
    [self __removeTimer];
    self.timer = [DNStatisticWeakTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(task_3) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
}

- (void)__removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)demo1 {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    for (int j=0; j<10; j++) {
        dispatch_group_async(group, queue, ^{
            
            NSLog(@"--##-%@",[NSThread currentThread]);
            NSString *url=@"https://www.baidu.com";
            [self.manager POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%d",j);//顺序打印
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%d",j);//顺序打印
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
    }
    dispatch_group_notify(group, queue, ^{
        //所有请求返回数据后执行
        NSLog(@"End");
    });
    
}

- (void)demo2 {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    for (int j=0; j<10; j++) {
        
        dispatch_group_async(group, queue, ^{
            NSString *url=@"https://www.baidu.com";
            [self.manager POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"11111111111");//顺序打印
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"11111111111");//顺序打印
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
        
        dispatch_group_async(group, queue, ^{
            NSString *url=@"https://www.baidu.com";
            [self.manager POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"22222222");//顺序打印
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"22222222");//顺序打印
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
        
        dispatch_group_async(group, queue, ^{
            NSString *url=@"https://www.baidu.com";
            [self.manager POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"333333333");//顺序打印
                NSLog(@"------------------j = %d-------------",j);//顺序打印
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"333333333");//顺序打印
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
        
    }
    
    dispatch_group_notify(group, queue, ^{
        //所有请求返回数据后执行
        NSLog(@"End");
    });
}

- (void)demo3 {
    [self __addTimer];
    self.group = dispatch_group_create();
    self.queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    
    [self task_1];
    [self task_2];
    [self task_3];
//    dispatch_group_async(group, queue, ^{
//        [self task_1];
//    });
//
//    dispatch_group_async(group, queue, ^{
//        [self task_2];
//    });
//
//    dispatch_group_async(group, queue, ^{
//        [self task_3];
//    });
//    dispatch_group_notify(group, queue, ^{
//        //所有请求返回数据后执行
//        NSLog(@"End");
//    });
    
    dispatch_group_notify(self.group, self.queue, ^{
        //所有请求返回数据后执行
        NSLog(@"End");
    });
    
}

- (void)task_1 {
    
    dispatch_group_async(self.group, self.queue, ^{
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSString *url=@"https://www.baidu.com";
        [self.manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@">>>>>> 1> 获取token ");
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@">>>>>> 1>：获取token失败");
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
}

- (void)task_2 {
    
    dispatch_group_async(self.group, self.queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSString *url=@"https://www.baidu.com";
        [self.manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@">>>>>> 2>：上传七牛");
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@">>>>>> 2>：上传七牛失败");
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
}

- (void)task_3 {
    NSLog(@"开始执行定时任务 %@",[NSThread currentThread]);
    dispatch_group_async(self.group, self.queue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSString *url=@"https://www.baidu.com";
        [self.manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@">>>>>> 3>：图片地址上传服务器");
            
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@">>>>>> 3>：图片地址上传服务器失败");
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
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
