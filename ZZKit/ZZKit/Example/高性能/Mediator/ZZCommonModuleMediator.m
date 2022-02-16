//
//  ZZCommonModuleMediator.m
//  ZZKit
//
//  Created by MOMO on 2021/10/20.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZCommonModuleMediator.h"
#import "ZZCommonModuleProtocol.h"
#import "ZZCommonModuleRespondModel.h"
#import "ZZInvocation.h"
#import <objc/runtime.h>
#import <Aspects/Aspects.h>

#define ZZCommonModulePerformVCMethod(vc, method) \
for (id<ZZCommonModuleProtocol> obj in ws.modulesDict.allValues) { \
    if ([obj respondsToSelector:@selector(method)]) { \
        [obj method(vc)]; \
    } \
}

#define ZZCommonModuleAutoInit(type) \
    [ws.moduleNamesInitDict[@(type)] enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) { \
    [ws moduleWithName:obj]; \
}];

@interface ZZCommonModuleMediator ()

// protocol - impClass
@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *modulesClassDict;

// protocol - modules
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<ZZCommonModuleProtocol>> *modulesDict;

// dynamic regist module
@property (nonatomic, strong) NSMapTable<NSString *, id> *weakModulesObjTable;

// int [] 初始化时机的字典
// 每种初始化枚举类型 对应一个数组
// 数组中存的是 protocol的字符串
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSMutableArray<NSString *> *> *moduleNamesInitDict;

// regist response  (key - set<MBCommonModuleRespondModel>)
@property (nonatomic, strong) NSMutableDictionary <id, NSMutableOrderedSet<ZZCommonModuleRespondModel *> *> *respondNames;

@property (nonatomic, strong) NSMutableArray <id<AspectToken>> *aspectTokens;

@property (nonatomic, assign, getter=isDestroyed) BOOL destroyed;

@end

@implementation ZZCommonModuleMediator

static  ZZCommonModuleMediator *_instance;
+ (instancetype)shared
{
    if (!_instance) {
        _instance = [[self alloc] initModuleConfig];
        _instance.destroyed = false;
    }
    return _instance;
}

- (instancetype)initModuleConfig
{
    self = [super init];
    if (self) {
        _modulesClassDict = [NSMutableDictionary new];
        _modulesDict = [NSMutableDictionary new];
        _moduleNamesInitDict = [NSMutableDictionary new];
        
//        _servicesDict        = [NSMutableDictionary new];
//        _servicesObjTable    = [NSMapTable strongToWeakObjectsMapTable]; // strong references to the keys and weak references to the values.
        
        _weakModulesObjTable = [NSMapTable strongToWeakObjectsMapTable];
        _respondNames = [NSMutableDictionary new];
        
        // 向_moduleNamesInitDict字典中添加数据
        // 添加key是i， value是新建的可变数组
        for (NSInteger i = ZZCommonModuleInitViewDidLoad; i <= ZZCommonModuleInitViewDidAppear; i++) {
            [_moduleNamesInitDict setObject:NSMutableArray.new forKey:@(i)];
        }
    }
    return self;
}

+ (BOOL)leaveModuleMediator:(NSInteger)reason {
    if (_instance) {
        [_instance _vorDeallocModules:reason];
    }
    _instance = nil;
    return YES;
}

- (void)bindViewController:(__kindof UIViewController *)viewController {
    NSParameterAssert(viewController);
    if (!viewController) return;
    
    self.moduleContext.inVC = viewController;
    __weak typeof(self) ws = self;
    __weak typeof(viewController) wsVC = viewController;
    
    // Aspect 提供了两个方法， 一个用于类， 一个用于实例
    // Aspects 允许我们选择 hook 的时机是在方法执行之前，还是方法执行之后，甚至可以直接替换掉方法的实现
    // 该方法返回一个 AspectToken 对象，这个对象主要是 aspect 的唯一标识符
    // 控制器的生命周期阶段； hook住控制器各个生命周期的方法
    // 在生命周期的不同阶段去初始化相应的moudule， 因为有的module是在viewDidLoad阶段初始化的， 有的moudle是在viewWillAppear阶段初始化的...
    // 注意AspectPositionAfter 这个参数，它的意思是我们在实际的viewDidAppear 调用之后，再执行我们传入的block 中的代码
    
    id<AspectToken> didLoadToken = [viewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^{
        
        ws.moduleContext.inView = wsVC.view;
        ZZCommonModuleAutoInit(ZZCommonModuleInitViewDidLoad)
        ZZCommonModulePerformVCMethod(wsVC, viewDidLoad:)
        
    } error:NULL];
    
    id<AspectToken> willAppearToken = [viewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^{
        
        ZZCommonModuleAutoInit(ZZCommonModuleInitViewWillAppear)
        ZZCommonModulePerformVCMethod(wsVC, viewWillAppear:)
        
    } error:NULL];
    
    id<AspectToken> didAppearToken = [viewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^{
        
        ZZCommonModuleAutoInit(ZZCommonModuleInitViewDidAppear)
        ZZCommonModulePerformVCMethod(wsVC, viewDidAppear:)
        
    } error:NULL];
    
    id<AspectToken> willDisToken = [viewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^{
        
        ZZCommonModulePerformVCMethod(wsVC, viewWillDisappear:)
        
    } error:NULL];
    
    id<AspectToken> didDisToken = [viewController aspect_hookSelector:@selector(viewDidDisappear:) withOptions:AspectPositionAfter usingBlock:^{
        
        ZZCommonModulePerformVCMethod(wsVC, viewDidDisappear:)
        
    } error:NULL];
    
    if (!self.aspectTokens) {
        self.aspectTokens = [NSMutableArray new];
    }
    
    if (didLoadToken) {
        [self.aspectTokens addObject:didLoadToken];
    }
    if (willAppearToken) {
        [self.aspectTokens addObject:willAppearToken];
    }
    if (didAppearToken) {
        [self.aspectTokens addObject:didAppearToken];
    }
    if (willDisToken) {
        [self.aspectTokens addObject:willDisToken];
    }
    if (didDisToken) {
        [self.aspectTokens addObject:didDisToken];
    }
}


- (void)registerModuleWithProto:(nullable Protocol *)proto
                       impClass:(nullable Class)impClass
                       initType:(ZZCommonModuleInitType)initType
                      toMapMode:(nullable id)mapMode {
    
    NSParameterAssert(proto);
    NSParameterAssert(impClass);
    if (!proto || !impClass) { return; }
    
    if (![impClass conformsToProtocol:proto]) {
        NSAssert(NO, @">Moudle> %@ must be implementation %@ ...", impClass, NSStringFromProtocol(proto));
        return;
    }
    
    if (![impClass conformsToProtocol:@protocol(ZZCommonModuleProtocol)]) {
        NSAssert(NO, @">Moudle> %@ must be implementation ZZCommonModuleProtocol ...", impClass);
        return;
    }
    
    NSString *protoName = [self _getProtoNameWithProto:proto toMapMode:mapMode];
    [self.modulesClassDict setObject:impClass forKey:protoName];
    
    // 如果初始化时机里已经有该协议
    [self.moduleNamesInitDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSMutableArray<NSString *> * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj containsObject:protoName]) {
            [obj removeObject:protoName];
            *stop = YES;
        }
    }];
    
    NSMutableArray<NSString *> *protoStringArray = [self.moduleNamesInitDict objectForKey:@(initType)];
    if (protoStringArray) {
        if (protoName) {
            [protoStringArray addObject:protoName];
        }
    }
    
    //即刻初始化
    if (initType == ZZCommonModuleInitRegist) {
        [self moduleWithProto:proto];
    }
}

- (id)moduleWithName:(NSString *)name
{
    return [self moduleWithProto:NSProtocolFromString(name)];
}

- (id)moduleWithProto:(Protocol *)proto
{
    return [self moduleWithProto:proto
                        autoInit:YES];
}

- (id)moduleWithProto:(Protocol *)proto
             autoInit:(BOOL)autoInit
{
    return [self moduleWithProto:proto
                         context:nil
                        autoInit:autoInit];
}

- (id)moduleWithProto:(Protocol *)proto
              context:(ZZCommonModuleContext *)context
             autoInit:(BOOL)autoInit
{
    return [self moduleWithProto:proto
                         context:context
                        autoInit:autoInit
                       toMapMode:nil];
}

- (id)moduleWithProto:(Protocol *)proto
              context:(ZZCommonModuleContext *)context
             autoInit:(BOOL)autoInit
            toMapMode:(id)mapMode
{
    NSParameterAssert(proto);
    if (!proto) return nil;
    if (self.isDestroyed) return nil;
    
    NSString *protoName = NSStringFromProtocol(proto);
    id<ZZCommonModuleProtocol> module = [self.modulesDict objectForKey:protoName];
    if (!module) {
        module = [self.weakModulesObjTable objectForKey:protoName];
    }
    if (autoInit && !module) {
        NSString *protoClassKey = [self _getProtoNameWithProto:proto toMapMode:mapMode];
        Class cls = [self.modulesClassDict objectForKey:protoClassKey];
        if (!cls) {
            return nil;
        }
        ZZCommonModuleContext *cxt = context ?: self.moduleContext;
        module = [[cls alloc] initWithModuleContext:cxt];
        if (module) {
            [self.modulesDict setObject:module forKey:protoName];
        } else {
            NSLog(@">Moudle> %@ is nil ...", cls);
        }
    }
    
    return  module;
}

- (void)removeModuleWithProto:(Protocol *)proto {
    NSParameterAssert(proto);
    if (!proto) return;
    
    NSString *protoName = NSStringFromProtocol(proto);
    id<ZZCommonModuleProtocol> module = [self.modulesDict objectForKey:protoName];
    if (module) {
        if ([module respondsToSelector:@selector(moduleDealloc:)]) {
            [module moduleDealloc:0];
        }
        [self.modulesDict removeObjectForKey:protoName];
    }
}


//////////////////////////////////////////////////////////////////////
/////////////////////    注册方法    //////////////////////////////////
////////////// 用于模块分发数据 - 分IM 与 selector //////////////////////
/////////////////////////////////////////////////////////////////////

- (void)registerRespondToProto:(Protocol *)proto
                     priority:(ZZCommonModuleRespondPriority)priority
                     autoInit:(BOOL)autoInit
                          type:(NSInteger)type, ... {
    NSParameterAssert(proto);
    if (!proto) return;
    
    NSString *protoName = NSStringFromProtocol(proto);
     
    // 处理可变参数逻辑
    va_list args;
    va_start(args, type);
    
    NSInteger value = type;
    while (value) {
        [self _registerRespondWithProtoName:protoName priority:priority autoInit:autoInit key:@(type)];
        value = va_arg(args, NSInteger);
    }
    va_end(args);
}

- (void)registerRespondToProto:(Protocol *)proto
                     priority:(ZZCommonModuleRespondPriority)priority
                         type:(NSInteger)type, ... {
    NSParameterAssert(proto);
    if (!proto) return;
    
    NSString *protoName = NSStringFromProtocol(proto);
    
    va_list args;
    va_start(args, type);
    
    NSInteger value = type;
    while (value) {
        [self _registerRespondWithProtoName:protoName priority:priority autoInit:YES key:@(value)];
        value =  va_arg(args, NSInteger);
    }
    va_end(args);
}

- (void)registerRespondToProto:(Protocol *)proto
                         type:(NSInteger)type, ... {

    NSParameterAssert(proto);
    if (!proto) return;
    
    NSString *protoName = NSStringFromProtocol(proto);
    
    va_list args;
    va_start(args, type);
    
    NSInteger value = type;
    while (value) {
        [self _registerRespondWithProtoName:protoName priority:ZZCommonModuleRespondPriorityDefalut autoInit:YES key:@(value)];
        value =  va_arg(args, NSInteger);
    }
    va_end(args);
}

#pragma mark - 分发IM

- (void)respondType:(NSInteger)type
           selector:(SEL)aSel
              param:(id)param
            va_list:(va_list)args
{
    NSParameterAssert(aSel);
    if (!aSel) return;
    
    NSNumber *typeKey = @(type);
    // ? 为什么用 NSMutableOrderedSet
    NSMutableOrderedSet <ZZCommonModuleRespondModel *> *set = [self.respondNames objectForKey:typeKey];
    for (ZZCommonModuleRespondModel *obj in set) {
        id module = [self moduleWithProto:NSProtocolFromString(obj.name) autoInit:obj.autoInit];
        if (!module) continue;
        // 调用 注册的方法
        [self _respondObjSelector:aSel toObj:module param:param vaList:args];
    }
}


- (void)respondType:(NSInteger)type
           selector:(SEL)aSel
              param:(id)param, ...
{
    NSParameterAssert(aSel);
    if (!aSel) return;
    
    NSNumber *typeKey = @(type);
    NSMutableOrderedSet <ZZCommonModuleRespondModel *> *set = [self.respondNames objectForKey:typeKey];
    for (ZZCommonModuleRespondModel *obj in set) {
        id module = [self moduleWithProto:NSProtocolFromString(obj.name) autoInit:obj.autoInit];
        if (!module) continue;
        
        va_list args;
        va_start(args, param);
        [self _respondObjSelector:aSel toObj:module param:param vaList:args];
        va_end(args);
    }
}

- (void)respondType:(NSInteger)type
 selectorWithParams:(SEL)aSel, ...
{
    NSParameterAssert(aSel);
    if (!aSel) return;
    
    NSNumber *typeKey = @(type);
    NSMutableOrderedSet <ZZCommonModuleRespondModel *> *set = [self.respondNames objectForKey:typeKey];
    
    for (ZZCommonModuleRespondModel *obj in set) {
        id module = [self moduleWithProto:NSProtocolFromString(obj.name) autoInit:obj.autoInit];
        if (!module) continue;
        va_list args;
        va_start(args, aSel);
        [ZZInvocation zz_target:module invokeSelector:aSel args:args];
        va_end(args);
    }
}

#pragma mark - 注册 Respond Selector

- (void)registerRespondSelector:(nonnull SEL)aSel
                        toProto:(nonnull Protocol *)proto
                       priority:(ZZCommonModuleRespondPriority)priority
                       autoInit:(BOOL)autoInit {
    NSParameterAssert(proto);
    NSParameterAssert(aSel);
    if (!proto || !aSel) return;
    
    NSString *protoName = NSStringFromProtocol(proto);
    NSString *selName = NSStringFromSelector(aSel);
    
    [self _registerRespondWithProtoName:protoName priority:priority autoInit:autoInit key:selName];
}

- (void)registerRespondSelector:(SEL)aSel
                       toProto:(Protocol *)proto
                       priority:(ZZCommonModuleRespondPriority)priority {
    [self registerRespondSelector:aSel toProto:proto priority:priority autoInit:YES];
}

- (void)registerRespondSelector:(SEL)aSel
                        toProto:(Protocol *)proto {
    [self registerRespondSelector:aSel toProto:proto priority:ZZCommonModuleRespondPriorityDefalut];
}

#pragma mark - 分发 Respond Selector

- (void)respondSelector:(nullable SEL)aSel
                  param:(nullable id)param, ... {
    NSParameterAssert(aSel);
    if (!aSel) return;
    
    NSString *selName = NSStringFromSelector(aSel);
    if (!selName) return;
    
    NSMutableOrderedSet<ZZCommonModuleRespondModel *> *set = [self.respondNames objectForKey:selName];
    
    for (ZZCommonModuleRespondModel *obj in set.copy) {
        Protocol *protocol = NSProtocolFromString(obj.name);
        id module = [self moduleWithProto:protocol autoInit:obj.autoInit];
        if (!module) {
            continue;
        }
        
        va_list args;
        va_start(args, param);
        [self _respondObjSelector:aSel toObj:module param:param vaList:args];
        va_end(args);
    }
}

- (void)respondSelectorWithParams:(SEL)aSel, ...
{
    NSParameterAssert(aSel);
    if (!aSel) return;
    
    NSString *selName = NSStringFromSelector(aSel);
    if (!selName) return;
    
    NSMutableOrderedSet<ZZCommonModuleRespondModel *> *set = [self.respondNames objectForKey:selName];
    
    for (ZZCommonModuleRespondModel *obj in set.copy) {
        Protocol *protocol = NSProtocolFromString(obj.name);
        id module = [self moduleWithProto:protocol autoInit:obj.autoInit];
        if (!module) {
            continue;
        }
        
        va_list args;
        va_start(args, aSel);
        [ZZInvocation zz_target:module invokeSelector:aSel args:args];
        va_end(args);
    }
}

#pragma mark - dispatch

- (void)dispatchSelector:(nonnull SEL)aSel
                   param:(nonnull id)param, ... {
    NSParameterAssert(aSel);
    if (!aSel) return;
    
    NSString *selName = NSStringFromSelector(aSel);
    if (!selName) return;
    
    NSDictionary *currentModulesDict = self.modulesDict.copy ?: @{};
    
    for (NSString *key in currentModulesDict) {
        id<ZZCommonModuleProtocol> obj = [currentModulesDict objectForKey:key];
        if ([obj respondsToSelector:aSel]) {
            va_list args;
            va_start(args, param);
            [self _respondObjSelector:aSel toObj:obj param:param vaList:args];
            va_end(args);
        }
    }
}

- (void)dispatchSelector:(SEL)aSel
                   param:(id)param
                 va_list:(va_list)args
{
    NSParameterAssert(aSel);
    if (!aSel) return;
    
    NSString *selName = NSStringFromSelector(aSel);
    if (!selName) return;
    
    NSDictionary *currentModulesDict = self.modulesDict.copy ?: @{};
    for (NSString *key in currentModulesDict) {
        id<ZZCommonModuleProtocol> obj = [currentModulesDict objectForKey:key];
        if ([obj respondsToSelector:aSel]) {
            [self _respondObjSelector:aSel toObj:obj param:param vaList:args];
        }
    }
}

#pragma mark - Private Method

- (void)_registerRespondWithProtoName:(NSString *)name
                       priority:(ZZCommonModuleRespondPriority)priority
                       autoInit:(BOOL)autoInit
                             key:(id)key {
    if (!key) return;
    NSMutableOrderedSet<ZZCommonModuleRespondModel *> *set = [self.respondNames objectForKey:key];
    if (!set) {
        set = [[NSMutableOrderedSet alloc] init];
        [self.respondNames setObject:set forKey:key];
    }
    
    // crate response model
    ZZCommonModuleRespondModel *respondModel = [[ZZCommonModuleRespondModel alloc] init];
    respondModel.name = name;
    respondModel.priority = priority;
    respondModel.autoInit = autoInit;
    
    if ([set containsObject:respondModel]) {
        [set removeObject:respondModel];
    }
    
    __block BOOL hasInsert = NO;
    [set enumerateObjectsUsingBlock:^(ZZCommonModuleRespondModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.priority <= priority) {
            [set insertObject:obj atIndex:idx];
            hasInsert = YES;
            *stop = YES;
        }
    }];
    
    if (!hasInsert) {
        [set addObject:respondModel];
    }
}

- (void)_respondObjSelector:(SEL)aSel
                      toObj:(id)obj
                      param:(id)param
                     vaList:(va_list)args
{
    
    NSParameterAssert(aSel);
    NSParameterAssert(obj);
    
    if (!aSel || !obj) return;
    
    // 动态向对象发消息
    NSMethodSignature *signature = [obj methodSignatureForSelector:aSel];
    NSParameterAssert(signature);
    if (!signature) return;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = obj;
    invocation.selector = aSel;
    if (!invocation) {
        return;
    }
    
    /**
     0 -> self
     1 -> selector
     2 -> 第一个参数
     */
    
    NSUInteger tArgIndex = 2;
    NSUInteger argumentCount = signature.numberOfArguments;
    const char *argType = [signature getArgumentTypeAtIndex:2];
    
    // Skip const type qualifier.
    if (argType[0] == _C_CONST) argType++;
    if (strcmp(argType, @encode(id)) == 0 ||
        strcmp(argType, @encode(Class)) == 0) {
        tArgIndex = 3;
        [invocation setArgument:&param atIndex:2];
        if (argumentCount == 3) {
            [invocation invoke];
            return;
        }
    }
    
    for (NSUInteger argIndex = tArgIndex; argIndex < argumentCount; argIndex ++) {
        [self _setInvocationArgument:signature invocation:invocation argIndex:argIndex vaList:args];
    }
    
    [invocation invoke];
}

- (void)_setInvocationArgument:(NSMethodSignature *)signature
                    invocation:(NSInvocation *)invocation
                      argIndex:(NSUInteger)argIndex
                        vaList:(va_list)args
{
    const char *argType = [signature getArgumentTypeAtIndex:argIndex];
    
    // Skip const type qualifier.
    if (argType[0] == _C_CONST) argType++;
    
    if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0) {
        id valueObj = va_arg(args, id);
        [invocation setArgument:&valueObj atIndex:argIndex];
    } else if (strcmp(argType, @encode(SEL)) == 0) {
        SEL selector = va_arg(args, SEL);
        [invocation setArgument:&selector atIndex:argIndex];
    } else if (strcmp(argType, @encode(Class)) == 0) {
        Class theClass = va_arg(args, Class);
        [invocation setArgument:&theClass atIndex:argIndex];
    } else if (strcmp(argType, @encode(char)) == 0) {
        char ch = va_arg(args, int);
        [invocation setArgument:&ch atIndex:argIndex];
    } else if (strcmp(argType, @encode(int)) == 0) {
        int value = va_arg(args, int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(short)) == 0) {
        short value = va_arg(args, int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(long)) == 0) {
        long value = va_arg(args, long);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(long long)) == 0) {
        long long value = va_arg(args, long long);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(unsigned char)) == 0) {
        unsigned char value = va_arg(args, unsigned int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(unsigned int)) == 0) {
        unsigned int value = va_arg(args, unsigned int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(unsigned short)) == 0) {
        unsigned short value = va_arg(args, unsigned int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(unsigned long)) == 0) {
        unsigned long value = va_arg(args, unsigned long);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
        unsigned long long value = va_arg(args, unsigned long long);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(float)) == 0) {
        float value = va_arg(args, double);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(double)) == 0) {
        double value = va_arg(args, double);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(BOOL)) == 0) {
        BOOL value = va_arg(args, int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(bool)) == 0) {
        bool value = va_arg(args, int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(char *)) == 0) {
        char * value = va_arg(args, char *);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(void (^)(void))) == 0) {
        id value = va_arg(args, id);
        [invocation setArgument:&value atIndex:argIndex];
    } else {
        char *values = va_arg(args, char *);
        NSValue *va = [NSValue valueWithBytes:values objCType:argType];
        [invocation setArgument:&va atIndex:argIndex];
    }
}

- (NSString *)_getProtoNameWithProto:(Protocol *)proto
                           toMapMode:(id)mapMode {
    NSString *protoName = NSStringFromProtocol(proto);
    if (mapMode) {
        protoName = [NSString stringWithFormat:@"%@__%@", protoName, mapMode];
    }
    return protoName;
}

- (void)_vorDeallocModules:(NSInteger)reason
{
    if (self.isDestroyed) return;
    self.destroyed = YES;
    [self.modulesDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<ZZCommonModuleProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(moduleDealloc:)]) {
            [obj moduleDealloc:reason];
        }
    }];
    
    // aspectTokens ..
}

@end
