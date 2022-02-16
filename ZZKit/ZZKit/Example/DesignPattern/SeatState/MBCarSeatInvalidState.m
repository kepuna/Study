//
//  MBCarSeatInvalidState.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/3.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "MBCarSeatInvalidState.h"

@implementation MBCarSeatInvalidState
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
    
}

- (void)canOpen {
    
}

- (void)canClose {
    
}
@end
