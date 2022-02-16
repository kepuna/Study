//
//  ZZCommonModuleProtocol.h
//  ZZMedia
//
//  Created by MOMO on 2020/8/31.
//

#import "ZZCommonModuleLifeCycleProtocol.h"
#import "ZZCommonModuleDefine.h"
#import "ZZCommonModuleContext.h"

@protocol ZZCommonModuleProtocol <NSObject, ZZCommonModuleLifeCycleProtocol>

@required
- (instancetype)initWithModuleContext:(__kindof ZZCommonModuleContext *)moduleContext;

@property (nonatomic, strong, readonly) ZZCommonModuleContext *moduleContext;

/**
 用于模块间通信
 
 @param event 每个模块可以自己定义枚举
 @param info 传递的参数
 @param callback 执行回调
 */
- (BOOL)handleEvent:(NSInteger)event
           userInfo:(id)info
           callback:(ZZCommonModulesCallback)callback;

/**
 module销毁时会调用
 */
- (void)moduleDealloc:(NSInteger)reason;

// unavailable
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

