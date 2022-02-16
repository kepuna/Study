//
//  ZZCommonModuleRespondModel.h
//  ZZKit
//
//  Created by MOMO on 2021/10/22.
//  Copyright © 2021 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZCommonModuleDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZCommonModuleRespondModel : NSObject

// 对应 protoName 字符串
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL autoInit;
@property (nonatomic, assign) ZZCommonModuleRespondPriority priority;

@end

NS_ASSUME_NONNULL_END
