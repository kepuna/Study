//
//  ZZInvocation.h
//  ZZKit
//
//  Created by MOMO on 2021/10/20.
//  Copyright © 2021 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZInvocation<__covariant T : id> : NSObject

// VA_LIST 是在C语言中解决变参问题的一组宏，所在头文件：#include <stdarg.h>，用于获取不确定个数的参数。
+ (T)zz_target:(id)target invokeSelectorWithArgs:(SEL)selector, ...;
+ (T)zz_target:(id)target invokeSelector:(SEL)selector args:(va_list)args;

@end

NS_ASSUME_NONNULL_END
