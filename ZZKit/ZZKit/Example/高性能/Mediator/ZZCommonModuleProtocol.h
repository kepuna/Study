//
//  ZZCommonModuleProtocol.h
//  ZZKit
//
//  Created by MOMO on 2021/10/20.
//  Copyright © 2021 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZCommonModuleContext.h"
#import "ZZCommonModuleLifeCycleProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ZZCommonModuleProtocol <NSObject, ZZCommonModuleLifeCycleProtocol>

/**
 module 初始化时调用
 */
- (instancetype)initWithModuleContext:(__kindof ZZCommonModuleContext *)moduleContext;
/**
 module 销毁时调用
 */
- (void)moduleDealloc:(NSInteger)reason;

// unavailable
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
