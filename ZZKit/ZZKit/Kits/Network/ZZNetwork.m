//
//  ZZNetwork.m
//  ZZKit
//
//  Created by donews on 2019/5/26.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZNetwork.h"
#import "NSDictionary+AXNetworkingMethods.h"

@interface  ZZNetwork()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSURLSessionTask *task;

@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, copy) NSDictionary *parameters;
@property (nonatomic, copy) ZZNetworkCompletionBlock completionBlock;
@property NSTimeInterval timeoutInterval;

@end

@implementation ZZNetwork

- (instancetype)initWithURLString:(NSString *)url method:(NSString *)method parameters:(id)parameters timeoutInterval:(NSTimeInterval)timeoutInterval completionBlock:(ZZNetworkCompletionBlock)completionBlock {

    self = [super init];
    if (self) {
        NSParameterAssert(method);
        NSParameterAssert(url);
        NSParameterAssert(completionBlock);
    
        self.method = method;
        self.URLString = url;
        self.parameters = parameters;
        self.timeoutInterval = timeoutInterval;
        self.completionBlock = completionBlock;

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 10; // 默认超时时长10秒
        configuration.HTTPMaximumConnectionsPerHost = 4; // 最大并发数 4
        self.session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

/*
 NSURLSession 的使用过程：
 1 构造 NSURLRequest
        确定 URL
        确定 HTTP 方法（GET、POST 等）
        添加特定的 HTTP 头
        填充 HTTP Body
2 驱动 session.dataTaskWithRequest 方法，开始请求
 */
- (void)fire {
    [self buildRequest];
    [self buildBody];
    [self fireTask];
}

- (void)buildRequest {
    
    //    GET 方法下，params 在经过 url encode 之后直接附在 URL 末尾发送给服务器
    //    如果是 GET 方法，那就把处理过的 params 增加到 URL 后面
    if ([self.method isEqualToString:@"GET"] && self.parameters) {
        [self.URLString stringByAppendingString:[self.parameters CT_transformToUrlParamString]];
    }
    
    NSURL *url = [NSURL URLWithString:self.URLString];
    self.request = [NSMutableURLRequest requestWithURL:url];
    self.request.HTTPMethod = self.method;
    [self.request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Content-Type"];
    if (self.timeoutInterval) {
      self.request.timeoutInterval = self.timeoutInterval;
    }
   
    
    //    POST 方法下有几个协议可供选择，此处没有文件上传，我们采用较简单的 application/x-www-form-urlencoded 方式发送请求
    if ([self.method isEqualToString:@"POST"]) {
        //        [request addValue:@"" forHTTPHeaderField:@""];
        //        request.HTTPBody = Network().buildParams(params)
        // HTTPHeaderField??
        [self.request setValue:[NSString stringWithFormat:@"application/json"] forHTTPHeaderField:@"Accept"];
        // ????
        
    }
}

- (void)buildBody {
    if (self.parameters.count > 0 && ![self.method isEqualToString:@"GET"]) {
        self.request.HTTPBody = [self buildParams:self.parameters];
    }
}

- (void)fireTask {
    // 通过request初始化task
    __block NSURLSessionDataTask *dataTask = nil;
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    dataTask = [self.session dataTaskWithRequest:self.request
                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                   CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
                                   if (error) {
                                       self.completionBlock(dataTask, nil, error,endTime);
                                   } else {
                                       
                                       NSError *serializationError = nil;
                                       id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&serializationError];
                                       if (serializationError) {
                                           self.completionBlock(dataTask,nil,serializationError,endTime);
                                           return ;
                                       }
                                       self.completionBlock(dataTask,result,error,endTime);
                                   }
                               }];
    
    [dataTask resume]; //创建的task是停止状态，需要我们去启动
    self.task = dataTask;
}

- (NSData *)buildParams:(NSDictionary *)params {
    if (!params) return nil;
    return [NSJSONSerialization dataWithJSONObject:params options:0 error:NULL];
}

@end
