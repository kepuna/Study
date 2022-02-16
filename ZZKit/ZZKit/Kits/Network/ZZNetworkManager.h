//
//  ZZNetworkManager.h
//  ZZKit
//
//  Created by donews on 2019/5/26.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@interface ZZNetworkManager : NSObject

/**
 GET请求 不带参数

 @param URLString 请求的URL地址
 @param completionBlock 请求完成回调
 */
- (void)GET:(NSString *)URLString completionBlock:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError *error, CFAbsoluteTime interval))completionBlock;


/**
 GET请求 带参数

 @param URLString 请求的URL地址
 @param parameters 请求的参数
 @param completionBlock 请求完成回调
 */
- (void)GET:(NSString *)URLString parameters:(nullable NSDictionary *)parameters completionBlock:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError *error, CFAbsoluteTime interval))completionBlock;


/**
 GET请求 带参数 & 请求超时时间

 @param URLString 请求的URL地址
 @param parameters 请求的参数
 @param timeoutInterval 请求超时时间
 @param completionBlock 请求完成回调
 */
- (void)GET:(NSString *)URLString parameters:(nullable NSDictionary *)parameters timeoutInterval:(NSTimeInterval)timeoutInterval completionBlock:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError *error, CFAbsoluteTime interval))completionBlock;

/**
 POST请求 不带参数
 
 @param URLString 请求的URL地址
 @param completionBlock 请求完成回调
 */
- (void)POST:(NSString *)URLString completionBlock:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError *error, CFAbsoluteTime interval))completionBlock;

/**
 POST请求 带参数
 
 @param URLString 请求的URL地址
 @param parameters 请求的参数
 @param completionBlock 请求完成回调
 */
- (void)POST:(NSString *)URLString parameters:(nullable NSDictionary *)parameters completionBlock:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError *error, CFAbsoluteTime interval))completionBlock;

/**
 POST请求 带参数 & 请求超时时间
 
 @param URLString 请求的URL地址
 @param parameters 请求的参数
 @param timeoutInterval 请求超时时间
 @param completionBlock 请求完成回调
 */
- (void)POST:(NSString *)URLString parameters:(nullable NSDictionary *)parameters timeoutInterval:(NSTimeInterval)timeoutInterval completionBlock:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError *error, CFAbsoluteTime interval))completionBlock;


@end
NS_ASSUME_NONNULL_END
