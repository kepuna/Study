//
//  ZZNetworkManager.m
//  ZZKit
//
//  Created by donews on 2019/5/26.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZNetworkManager.h"
#import "ZZNetwork.h"

@implementation ZZNetworkManager

- (void)GET:(NSString *)URLString completionBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nonnull, CFAbsoluteTime))completionBlock {
    [self GET:URLString parameters:nil completionBlock:completionBlock];
}

- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters completionBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nonnull, CFAbsoluteTime))completionBlock {
    [self GET:URLString parameters:parameters timeoutInterval:0 completionBlock:completionBlock];
}

- (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters timeoutInterval:(NSTimeInterval)timeoutInterval completionBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nonnull, CFAbsoluteTime))completionBlock {
    [self requestWithMehod:@"GET" URLString:URLString parameters:parameters timeoutInterval:timeoutInterval completionBlock:completionBlock];
}

- (void)POST:(NSString *)URLString completionBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nonnull, CFAbsoluteTime))completionBlock {
    [self POST:URLString completionBlock:completionBlock];
}

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters completionBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nonnull, CFAbsoluteTime))completionBlock {
    [self POST:URLString parameters:parameters timeoutInterval:0 completionBlock:completionBlock];
}

- (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters timeoutInterval:(NSTimeInterval)timeoutInterval completionBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nonnull, CFAbsoluteTime))completionBlock {
    [self requestWithMehod:@"POST" URLString:URLString parameters:parameters timeoutInterval:timeoutInterval completionBlock:completionBlock];
}

- (void)requestWithMehod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters completionBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nonnull, CFAbsoluteTime))completionBlock {
    [self requestWithMehod:method URLString:URLString parameters:parameters timeoutInterval:0 completionBlock:completionBlock];
}

- (void)requestWithMehod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters timeoutInterval:(NSTimeInterval)timeoutInterval completionBlock:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable, NSError * _Nonnull, CFAbsoluteTime))completionBlock {
    
    ZZNetwork *network = [[ZZNetwork alloc] initWithURLString:URLString method:method parameters:parameters timeoutInterval:timeoutInterval  completionBlock:completionBlock];
    [network fire];
}

@end
