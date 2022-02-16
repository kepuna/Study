//
//  ZZInvocationViewController.m
//  ZZKit
//
//  Created by MOMO on 2021/10/20.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZInvocationViewController.h"
#import "ZZInvocation.h"

@interface ZZInvocationViewController ()

@end

@implementation ZZInvocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self invocationDemo1];
    NSNumber *res = [self invocationDemo4];
//    NSLog(@"res为：%@",res);
    
//    NSString *name = [NSString stringWithFormat:@"zz"];
//    [self zzInvocationWithSelector:@selector(methodWithName:age:height:) param:name,10,180];
    
    [self zzInvocation];
}

// 1. 调用无参无返回值的方法

- (void)invocationDemo1 {
    
    // 根据方法 创建签名对象
    /**
     创建实例方法的签名
     NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(instanceMethod1)];
     
     根据签名对象创建 NSInvocaion
     NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
     
     invocation.target = self;
     invocation.selector = @selector(instanceMethod1);
     
     */

    // 创建类方法的签名
    NSMethodSignature *signature = [[self class] methodSignatureForSelector:@selector(classMethod1)];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    invocation.target = [self class];
    invocation.selector = @selector(classMethod1);
    
    [invocation invoke];
}

- (void)instanceMethod1 {
    NSLog(@"实例方法 - 无参无返回值");
}

+ (void)classMethod1 {
    NSLog(@"类方法 - 无参无返回值");
}


// 2. 调用有参无返回值的方法

- (void)invocationDemo2 {
    
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(instanceMethod2WithAge:name:)];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = @selector(instanceMethod2WithAge:name:);
    
    NSInteger age = 10;
    NSString *name = @"ZJ";
    [invocation setArgument:&age atIndex:2];
    [invocation setArgument:&name atIndex:3];
    
    [invocation invoke];
    
}

- (void)instanceMethod2WithAge:(NSInteger)age name:(NSString *)name {
    NSLog(@"实例方法 - 有参数无返回值 age=%zd, name=%@",age, name);
}


// 3. 调用有参有返回值的方法

- (void)invocationDemo3 {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(instanceMethod3WithAge:name:height:)];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    invocation.target = self;
    invocation.selector = @selector(instanceMethod3WithAge:name:height:);
    
    NSInteger age = 10;
    NSString *name = @"ZJ";
    CGFloat height = 185.5;
    
    [invocation setArgument:&age atIndex:2];
    [invocation setArgument:&name atIndex:3];
    [invocation setArgument:&height atIndex:4];
    
    [invocation invoke];
    
    // 获取方法返回值
   CGFloat res = 0;
    [invocation getReturnValue:&res];
    
    NSLog(@"res为：%lf",res);
}


- (CGFloat)instanceMethod3WithAge:(NSInteger)age name:(NSString *)name height:(CGFloat)height {
    NSLog(@"实例方法 - 有参数 有返回值 age=%zd, name=%@, height=%lf",age, name,height);
    return height + 15;
}

// 3. 返回值是对象类型时

- (NSNumber *)invocationDemo4 {
    
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(instanceMethod4:num2:)];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    invocation.target = self;
    invocation.selector = @selector(instanceMethod4:num2:);
    
    NSInteger num1 = 10;
    NSInteger num2 = 15;
    
    [invocation setArgument:&num1 atIndex:2];
    [invocation setArgument:&num2 atIndex:3];
    [invocation invoke];
    
    // 获取方法返回值
    void *res = NULL;
    [invocation getReturnValue:&res];
    NSNumber *result = (__bridge NSNumber *)res;
    return result;
}

- (NSNumber *)instanceMethod4:(NSInteger)num1 num2:(NSInteger)num2 {
    return @(num1 + num2);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)zzInvocation {
    [ZZInvocation zz_target:self invokeSelectorWithArgs:@selector(methodWithName:age:height:),@"zjeng",32,180.f];
}



- (void)zzInvocationWithSelector:(nonnull SEL)aSel
                           param:(nonnull id)param, ... {
    
    va_list args;
    // 以固定参数的地址为起点确定变参的内存起始地址，获取第一个参数的首地址
    va_start(args, param);
    [ZZInvocation zz_target:self invokeSelector:aSel args:args];
    va_end(args);
}

- (void)methodWithName:(NSString *)name age:(NSUInteger)age height:(CGFloat)height {
    
    NSLog(@"测试ZZInvocation---- name=%@,age=%zd, height=%lf",name, age, height);
}

@end
