//
//  FunctionButton.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/14.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "FunctionButton.h"


@interface FunctionButton ()
@property (nonatomic, copy) NSString *name; // 功能键的名称
@property (nonatomic, strong) id<ZZCommandProtocol> command; // 维持一个抽象命令对象的引用
@end

@implementation FunctionButton

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

// 为功能键注入命令
- (void)setCommand:(id<ZZCommandProtocol>)command {
    self.command = command;
}

//发送请求的方法
- (void)onClick {
    NSLog(@"点击功能键");
    [self.command execute];
}

@end
