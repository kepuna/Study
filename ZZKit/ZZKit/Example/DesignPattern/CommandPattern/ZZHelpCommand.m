//
//  ZZHelpCommand.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/14.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZHelpCommand.h"
#import "ZZHelpHandler.h"

@interface ZZHelpCommand ()
// 内部持有 请求接收者的引用
@property (nonatomic, strong) ZZHelpHandler *handler;
@end

@implementation ZZHelpCommand

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.handler = [ZZHelpHandler new];
    }
    return self;
}

/// help命令执行的具体实现
/// 调用请求接受者的业务方法
- (void)execute {
    [self.handler display];
}

@end
