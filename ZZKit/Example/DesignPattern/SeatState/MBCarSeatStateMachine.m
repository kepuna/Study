//
//  MBCarSeatStateMachine.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/3.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "MBCarSeatStateMachine.h"
#import "MBCarSeatInvalidState.h"

@implementation MBCarSeatStateMachine

- (instancetype)initWithStateNum:(NSUInteger)stateNum
{
    self = [super init];
    if (self) {
        // 初始状态为无效状态
        self.currentState = [[MBCarSeatInvalidState alloc] initWithMachine:self];
    }
    return self;
}

@end
