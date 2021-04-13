//
//  ZZMinimizeCommand.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/14.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZMinimizeCommand.h"
#import "ZZWindowHandler.h"

@interface ZZMinimizeCommand ()
@property (nonatomic, strong) ZZWindowHandler *handler;
@end

@implementation ZZMinimizeCommand

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.handler = [ZZWindowHandler new];
    }
    return self;
}

/// 执行的具体实现
- (void)execute {
    [self.handler minimize];
}

@end
