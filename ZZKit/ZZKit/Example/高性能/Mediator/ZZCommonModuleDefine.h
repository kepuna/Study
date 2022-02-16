//
//  ZZCommonModuleDefine.h
//  ZZKit
//
//  Created by MOMO on 2021/10/20.
//  Copyright © 2021 donews. All rights reserved.
//

#ifndef ZZCommonModuleDefine_h
#define ZZCommonModuleDefine_h

// 定义modules 传递消息的回调block类型 无参可以随意传递参数
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
// 参数不能为bool 值， bool值会报错
typedef id(^ZZCommonModulesCallback)();
#pragma clang diagnostic pop


/**
 module初始化时机
 
 - ZZCommonModuleInitAuto: 自动/用到的时候才会初始
 - ZZCommonModuleInitViewDidLoad: viewController didload
 - ZZCommonModuleInitViewWillAppear: viewController willAppear
 - ZZCommonModuleInitViewDidAppear: viewController didAppear
 - ZZCommonModuleInitRegist: 注册即初始化
 */
typedef NS_ENUM(NSInteger, ZZCommonModuleInitType) {
    ZZCommonModuleInitAuto           = 0,
    ZZCommonModuleInitViewDidLoad    = 1,
    ZZCommonModuleInitViewWillAppear = 2,
    ZZCommonModuleInitViewDidAppear  = 3,
    ZZCommonModuleInitRegist         = 4,
};

/**
 响应优先级 默认defalut
 */
typedef NS_ENUM(NSInteger, ZZCommonModuleRespondPriority) {
    ZZCommonModuleRespondPriorityLow      = -100,
    ZZCommonModuleRespondPriorityDefalut  = 0,
    ZZCommonModuleRespondPriorityHigh     = 100,
};

#endif /* ZZCommonModuleDefine_h */
