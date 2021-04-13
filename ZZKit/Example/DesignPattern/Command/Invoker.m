//
//  Invoker.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/9.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "Invoker.h"
#import "AbstractCommand.h"

@implementation Invoker

- (instancetype)initWithCommand:(id<AbstractCommand>)command
{
    self = [super init];
    if (self) {
        _command = command;
    }
    return self;
}

- (void)call {
    [_command execute];
}

@end
