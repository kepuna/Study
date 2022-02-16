//
//  ZZInvocation.h
//  ZZMedia
//
//  Created by MOMO on 2020/8/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZInvocation<__covariant R : id> : NSObject

+ (R)md_target:(id)target invokeSelectorWithArgs:(SEL)selector, ...;

+ (R)md_target:(id)target invokeSelector:(SEL)selector args:(va_list)args;

@end

NS_ASSUME_NONNULL_END
