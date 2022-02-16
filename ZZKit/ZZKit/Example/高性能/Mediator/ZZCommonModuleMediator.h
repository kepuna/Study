//
//  ZZCommonModuleMediator.h
//  ZZKit
//
//  Created by MOMO on 2021/10/20.
//  Copyright © 2021 donews. All rights reserved.
//  模块解耦中间件

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZZCommonModuleContext.h"
#import "ZZCommonModuleDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZCommonModuleMediator : NSObject


/**
 module初始化需要的context
 */
@property (nonatomic, strong, nullable) ZZCommonModuleContext *moduleContext;


/**
 *  获取一个模块中转器(非单例，必须被业务持有)
 */
+ (nonnull instancetype)shared;

/**
 *  退出房间时需要手动调用
 */
+ (BOOL)leaveModuleMediator:(NSInteger)reason;

/**
 绑定viewController 用于获知VC的生命周期
 */
- (void)bindViewController:(nonnull __kindof UIViewController *)viewController;

//////////////////////////////////////////////////////////////////////
////////////////生命周期由Mediator管理//////////////////////////////////
/////////////////////////////////////////////////////////////////////

#pragma mark - 模块注册

/**
 注册module
 
 @param proto proto
 @param impClass 实现类 - 类必须实现 ZZCommonModuleProtocol 协议
 @param initType 初始化时机
 @param mapMode 映射模板时需要，默认为nil
 */

- (void)registerModuleWithProto:(nullable Protocol *)proto
                       impClass:(nullable Class)impClass
                       initType:(ZZCommonModuleInitType)initType
                      toMapMode:(nullable id)mapMode;


- (void)registerModuleWithProto:(nullable Protocol *)proto
                       impClass:(nullable Class)impClass
                       initType:(ZZCommonModuleInitType)initType;

- (void)registerModuleWithProto:(nullable Protocol *)proto
                       impClass:(nullable Class)impClass;


#pragma mark - 模块获取

/**
 获取module
 
 可以获取到通过registerModuleWithName:...注册的module
 
 @param proto proto
 @param context context / 默认值为 self.moduleContext
 @param autoInit 是否自动初始化 / 默认YES
 @param mapMode 映射模板时需要，默认为nil
 */

- (nullable id)moduleWithIdProto:(nullable id)proto
                       context:(nullable ZZCommonModuleContext *)context
                      autoInit:(BOOL)autoInit
                     toMapMode:(nullable id)mapMode;

- (nullable id)moduleWithIdProto:(nullable id)proto
                       context:(nullable ZZCommonModuleContext *)context
                      autoInit:(BOOL)autoInit;

- (nullable id)moduleWithIdProto:(nullable id)proto
                        autoInit:(BOOL)autoInit;

- (nullable id)moduleWithIdProto:(nullable id)proto;


#pragma mark -  模块移除

/**
 移除module
 
 @param proto proto
 */

- (void)removeModuleWithProto:(nullable Protocol *)proto;

//////////////////////////////////////////////////////////////////////
/////////////////////    注册方法    //////////////////////////////////
////////////// 用于模块分发数据 - 分IM 与 selector //////////////////////
/////////////////////////////////////////////////////////////////////

/**
 注册IM type 与之对应响应的module ，如果module未初始化会自动初始化

 @param proto proto
 @param priority 响应优先级
 @param type IM 消息类型 eventType
 @param autoInit 使用时是否自动初始化 YES
 @param ... 多个type types不能为0 ,为0会自动结束
 */

- (void)registerRespondToProto:(Protocol *)proto
                     priority:(ZZCommonModuleRespondPriority)priority
                     autoInit:(BOOL)autoInit
                         type:(NSInteger)type, ...;

- (void)registerRespondToProto:(Protocol *)proto
                    priority:(ZZCommonModuleRespondPriority)priority
                        type:(NSInteger)type, ...;

- (void)registerRespondToProto:(Protocol *)proto
                         type:(NSInteger)type, ...;


/**
 分发IM 数据
 
 @param type IM 消息类型 eventType
 @param aSel module实现IM消息出来方法
 @param param 传递的参数， 参数个数类型最好与sel中的类型匹配
 比如 sel = resmethod:(id)abc type:(NSInteger)type tes:(float)dd
 传递的参数应该为 NSObject.new, 1, 2.5
 注意：float 与 int 不能混用， dd 参数需要加小数点， 不能为3 ； type 也一样。
 如果sel的第一个参数为整数，则param传nil为跳过， 其他的参数正常传
 */

- (void)respondType:(NSInteger)type
           selector:(nonnull SEL)aSel
              param:(nonnull id)param
            va_list:(va_list)args;

- (void)respondType:(NSInteger)type
           selector:(nonnull SEL)aSel
              param:(nonnull id)param, ...;

- (void)respondType:(NSInteger)type
 selectorWithParams:(SEL)aSel, ...;



/**
 注册 respond selector 与之对应的module
 
 @param aSel module需要响应的方法
 @param proto proto
 @param priority 响应优先级
 @param autoInit 使用时是否自动初始化 YES
 */

- (void)registerRespondSelector:(nonnull SEL)aSel
                        toProto:(nonnull Protocol *)proto
                       priority:(ZZCommonModuleRespondPriority)priority
                       autoInit:(BOOL)autoInit;

- (void)registerRespondSelector:(nonnull SEL)aSel
                        toProto:(nonnull Protocol *)proto
                       priority:(ZZCommonModuleRespondPriority)priority;

- (void)registerRespondSelector:(nonnull SEL)aSel
                        toProto:(nonnull Protocol *)proto;


/**
 分发 respond selector
 
 @param aSel module需要响应的方法
 @param param 传递的参数， 参数个数类型最好与sel中的类型匹配
 比如 sel = resmethod:(id)abc type:(NSInteger)type tes:(float)dd
 传递的参数应该为 NSObject.new, 1, 2.5
 注意：float 与 int 不能混用， dd 参数需要加小数点， 不能为3 ； type 也一样。
 如果sel的第一个参数为整数，则param传nil为跳过， 其他的参数正常传
 */

- (void)respondSelector:(nullable SEL)aSel
                  param:(nullable id)param, ...;

- (void)respondSelectorWithParams:(nonnull SEL)aSel, ...;


/**
 dispatch
 */

- (void)dispatchSelector:(nonnull SEL)aSel
                   param:(nonnull id)param, ...;

- (void)dispatchSelector:(nonnull SEL)aSel
                   param:(id)param
                 va_list:(va_list)args;


+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
