//
//  ZZInvocation.m
//  ZZKit
//
//  Created by MOMO on 2021/10/20.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZInvocation.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation ZZInvocation

+ (id)zz_target:(id)target invokeSelectorWithArgs:(SEL)selector, ... {
    va_list args;
    va_start(args, selector);
    id result = [self zz_target:target invokeSelector:selector args:args];
    va_end(args);
    return result;
}

+ (id)zz_target:(id)target invokeSelector:(SEL)selector args:(va_list)args {
    
    if (![target respondsToSelector:selector]) {
        NSAssert2(NO, @"%@ doesNotRecognizeSelector: %@", target, NSStringFromSelector(selector));
        return nil;
    }
    
    // 方法签名 包含了方法参数和返回值
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    
    // args
    [self buildInvocation:invocation signature:signature args:args];
    
    [invocation invoke];
    
    // result
    id result = [self returnValueWithInvocation:invocation signature:signature];
    return  result;
}


#pragma mark - Private

+ (void)buildInvocation:(NSInvocation *)invocation signature:(NSMethodSignature *)signature args:(va_list)args {
    
    //获取参数的个数
    NSUInteger argsCount = signature.numberOfArguments;
    
    for (NSUInteger index = 2; index < argsCount; index++) {
        const char *argType = [signature getArgumentTypeAtIndex:index];
        
        // 判断修饰符
        while (*argType == 'r' || // const 这里的  'r' 也可以替换成宏 _C_CONST
               *argType == 'n' || // in
               *argType == 'N' || // inout
               *argType == 'o' || // out
               *argType == 'O' || // bycopy
               *argType == 'R' || // byref
               *argType == 'V') { // oneway
            // 如果参数有修饰符这里需要 argType++
            argType++; // cutoff useless prefix
        }
        
        BOOL unsupportedType = NO;
        
        switch (*argType) {
            case _C_VOID:
            case _C_BOOL:
            case _C_CHR:
            case _C_UCHR:
            case _C_SHT:
            case _C_USHT:
            case _C_INT:
            case _C_UINT:
            case _C_LNG:
            case _C_ULNG: {
                //  type va_arg(va_list arg_ptr, type);
                // 功能：获取下一个参数的地址
                // 根据传入参数类型决定返回值类型
                int arg = va_arg(args, int);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_FLT: {
                double arg = va_arg(args, double);
                float argf = arg;
                [invocation setArgument:&argf atIndex:index];
            } break;
            case _C_DBL: {
                double arg = va_arg(args, double);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_LNG_LNG:
            case _C_ULNG_LNG: {
                long long arg = va_arg(args, long long);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case 'D': {
                long double arg = va_arg(args, long double);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_CHARPTR:
            case _C_PTR: {
                void *arg = va_arg(args, void *);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_SEL: {
                SEL arg = va_arg(args, SEL);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_CLASS: {
                Class arg = va_arg(args, Class);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_ID: {
                id arg = va_arg(args, id);
                [invocation setArgument:&arg atIndex:index];
            } break;
            case _C_STRUCT_B: {
                
                /*
                 strcmp函数是string compare(字符串比较)的缩写 用于比较两个字符串并根据比较结果返回整数。
                 基本形式为strcmp(str1,str2)，
                 若str1=str2，则返回零；
                 若str1<str2，则返回负数；
                 若str1>str2，则返回正数。
                 */
                
                if (strcmp(argType, @encode(CGPoint)) == 0) {
                    CGPoint arg = va_arg(args, CGPoint);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(CGSize)) == 0) {
                    CGSize arg = va_arg(args, CGSize);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(CGRect)) == 0) {
                    CGRect arg = va_arg(args, CGRect);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(CGVector)) == 0) {
                    CGVector arg = va_arg(args, CGVector);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(CGAffineTransform)) == 0) {
                    CGAffineTransform arg = va_arg(args, CGAffineTransform);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(CATransform3D)) == 0) {
                    CATransform3D arg = va_arg(args, CATransform3D);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(NSRange)) == 0) {
                    NSRange arg = va_arg(args, NSRange);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(UIOffset)) == 0) {
                    UIOffset arg = va_arg(args, UIOffset);
                    [invocation setArgument:&arg atIndex:index];
                } else if (strcmp(argType, @encode(UIEdgeInsets)) == 0) {
                    UIEdgeInsets arg = va_arg(args, UIEdgeInsets);
                    [invocation setArgument:&arg atIndex:index];
                } else {
                    unsupportedType = YES;
                }
                
            }break;
                
            default: {
                unsupportedType = YES;
            }break;
        }
    }
}

+ (id)returnValueWithInvocation:(NSInvocation *)invocation signature:(NSMethodSignature *)signature {
    
    // 返回值 编码的长度
    NSUInteger length = signature.methodReturnLength;
    if (length == 0) {
        return nil;
    }
    const char *resultType = signature.methodReturnType;
    while (*resultType == _C_CONST || // const
           *resultType == 'n' || // in
           *resultType == 'N' || // inout
           *resultType == 'o' || // out
           *resultType == 'O' || // bycopy
           *resultType == 'R' || // byref
           *resultType == 'V') { // oneway
        resultType++; // cutoff useless prefix
    }
    
    switch (*resultType) {
        case _C_VOID: {
            return nil;
        } break;
        case _C_BOOL: {
            BOOL resultType;
            [invocation getReturnValue:&resultType];
            return @(resultType);
        } break;
        case _C_CHR: {
            char resultType;
            [invocation getReturnValue:&resultType];
            return @(resultType);
        } break;
        case _C_UCHR: {
            unsigned char resultType;
            [invocation getReturnValue:&resultType];
            return @(resultType);
        } break;
        case _C_SHT: {
            short resultType;
            [invocation getReturnValue:&resultType];
            return @(resultType);
        } break;
        case _C_USHT: {
            unsigned short resultType;
            [invocation getReturnValue:&resultType];
            return @(resultType);
        } break;
        case _C_INT: {
            int resultType;
            [invocation getReturnValue:&resultType];
            return @(resultType);
        } break;
        case _C_UINT: {
            unsigned int resultType;
            [invocation getReturnValue:&resultType];
            return @(resultType);
        } break;
        case _C_LNG: {
            long resultType;
            [invocation getReturnValue:&resultType];
            return @(resultType);
        } break;
        case _C_ULNG: {
            unsigned long resultType;
            [invocation getReturnValue:&resultType];
            return @(resultType);
        } break;
        case _C_FLT: {
            float resultType;
            [invocation getReturnValue:&resultType];
            return @(resultType);
        } break;
        case _C_DBL: {
            double resultType;
            [invocation getReturnValue:&resultType];
            return @(resultType);
        } break;
        case _C_LNG_LNG: {
            long long resultType;
            [invocation getReturnValue:&resultType];
            return @(resultType);
        } break;
        case _C_ULNG_LNG: {
            unsigned long long resultType;
            [invocation getReturnValue:&resultType];
            return @(resultType);
        } break;
        case 'D': {
            long double resultType;
            [invocation getReturnValue:&resultType];
            return [NSNumber numberWithDouble:resultType];
        } break;
        case _C_CLASS: {
            Class resultType;
            [invocation getReturnValue:&resultType];
            return resultType;
        } break;
        case _C_ID: {
            __autoreleasing id resultType;
            [invocation getReturnValue:&resultType];
            return resultType;
        } break;
        default: {
            const char *objCType = signature.methodReturnType;
            char *buf = calloc(1, length);
            if (!buf) return nil;
            
            [invocation getReturnValue:buf];
            NSValue *resultType = [NSValue valueWithBytes:buf objCType:objCType];
            free(buf);
            return resultType;
        } break;
    }
}

@end
