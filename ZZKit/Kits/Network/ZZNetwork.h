//
//  ZZNetwork.h
//  ZZKit
//
//  Created by donews on 2019/5/26.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ZZNetworkCompletionBlock)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError *error, CFAbsoluteTime interval);

NS_ASSUME_NONNULL_BEGIN

@interface ZZNetwork : NSObject

- (instancetype)initWithURLString:(NSString *)url method:(NSString *)method parameters:(nullable id)parameters timeoutInterval:(NSTimeInterval)timeoutInterval completionBlock:(ZZNetworkCompletionBlock)completionBlock;
- (void)fire;

@end

NS_ASSUME_NONNULL_END
