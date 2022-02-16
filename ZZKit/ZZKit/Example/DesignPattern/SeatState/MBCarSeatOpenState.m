//
//  MBCarSeatOpenState.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/3.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "MBCarSeatOpenState.h"
#import "MBCarSeatCloseState.h"
@implementation MBCarSeatOpenState
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
    // 座位开启状态，可以上坐
}

- (void)canOpen {
    // 开启状态，切换当前状态为可关闭
    self.stateMachine.currentState = [[MBCarSeatCloseState alloc] initWithMachine:self.stateMachine];
}

- (void)canClose {
   // 切换到可关闭状态
   
}

@end
