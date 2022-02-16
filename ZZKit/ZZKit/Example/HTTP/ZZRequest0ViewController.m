//
//  ZZRequest0ViewController.m
//  ZZKit
//
//  Created by donews on 2019/5/23.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZRequest0ViewController.h"
#import "ZZNetworkManager.h"

@interface ZZRequest0ViewController ()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation ZZRequest0ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self sendRequestDemo2];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.task cancel];
    
    ZZNetworkManager *manager = [[ZZNetworkManager alloc] init];
//    @"http://mobile.ximalaya.com/mobile/discovery/v4/recommends?channel=ios-b1&device=iPhone&includeActivity=true&includeSpecial=true&scale=2&version=5.4.21"
    
    //    @"http://baidu.com"
    NSString *url = @"http://mobile.ximalaya.com/mobile/discovery/v4/recommends?channel=ios-b1&device=iPhone&includeActivity=true&includeSpecial=true&scale=2&version=5.4.21";

//    NSDictionary *params = @{@"accout":@"1111",@"pwd":@"456"};
    [manager GET:url completionBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nonnull error, CFAbsoluteTime interval) {
        if (error) {
            NSLog(@"请求Error:%@",error);
            return ;
        }
        NSLog(@"要休息5秒");
        sleep(5);
        NSLog(@"成功%@",responseObject);
    }];
}

/// 方式二 Block方式
- (void)sendRequestDemo2 {
//
//    NSURL *url = [NSURL URLWithString:@"http://mobile.ximalaya.com/mobile/discovery/v4/recommends?channel=ios-b1&device=iPhone&includeActivity=true&includeSpecial=true&scale=2&version=5.4.21"];
    
    
    NSURL *url = [NSURL URLWithString:@"http://baidu.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
//    request.HTTPMethod = @"POST";
//    request.HTTPBody = [@"username=Tom&pwd=123" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 15;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    // 通过request初始化task
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            if (error) {
                                                NSLog(@"网络Error:%@",error);
                                                return ;
                                            }
                                            NSLog(@"要休息3秒");
                                            sleep(3);
                                            NSLog(@"成功%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                        }];
    //创建的task是停止状态，需要我们去启动
    [task resume];
    self.task = task;
    
}


/// 方式一 代理的方式
- (void)sendRequestDemo1 {
    
    NSURL *url = [NSURL URLWithString:@"http://httpbin.org/get"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置request的缓存策略（决定该request是否要从缓存中获取）
    request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    //创建配置（决定要不要将数据和响应缓存在磁盘）
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //创建会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    //生成任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    //创建的task是停止状态，需要我们去启动
    [task resume];
}

//1.接收到服务器响应的时候调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"接收响应");
    //必须告诉系统是否接收服务器返回的数据
    //默认是completionHandler(NSURLSessionResponseAllow)
    //可以再这边通过响应的statusCode来判断否接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

//2.接受到服务器返回数据的时候调用,可能被调用多次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"接收到数据");
    //一般在这边进行数据的拼接，在方法3才将完整数据回调
}

//3.请求完成或者是失败的时候调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"请求完成或者是失败");
    //在这边进行完整数据的解析，回调
}

//4.将要缓存响应的时候调用（必须是默认会话模式，GET请求才可以）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler {
    //可以在这边更改是否缓存，默认的话是completionHandler(proposedResponse)
    //不想缓存的话可以设置completionHandler(nil)
    completionHandler(proposedResponse);
}

@end
