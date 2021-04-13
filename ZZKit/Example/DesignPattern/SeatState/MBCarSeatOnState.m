//
//  MBCarSeatOnState.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/3.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "MBCarSeatOnState.h"

@implementation MBCarSeatOnState
@synthesize stateMachine = _stateMachine;

- (instancetype)initWithMachine:(MBCarSeatStateMachine *)machine
{
    self = [super init];
    if (self) {
        _stateMachine = machine;
    }
    return self;
}

- (void)canSeat {
    // 已经在坐上了
}

- (void)canOpen {
    // 不能开启
}

- (void)canClose {
    // 不能关闭
}

@end
