//
//  ZZSaleMachine.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/6/23.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZSaleMachine.h"
#import "ZZNoMoenyState.h"
#import "ZZHasMoneyState.h"
#import "ZZSoldState.h"
#import "ZZSoldOutState.h"

@interface ZZSaleMachine ()
@property (nonatomic, strong) ZZNoMoenyState *noMoneyState;
@property (nonatomic, strong) ZZHasMoneyState *hasMoneyState;
@property (nonatomic, strong) ZZSoldState *soldState;
@property (nonatomic, strong) ZZSoldOutState *soldOutState;

@end

@implementation ZZSaleMachine

- (instancetype)initWithCount:(NSUInteger)count
{
    self = [super init];
    if (self) {
        self.count = count;
        self.currentState = [[ZZNoMoenyState alloc] initWithMachine:self];;
    }
    return self;
}

- (void)putMoney {
    [self.currentState putMoney];
    self.currentState = [[ZZHasMoneyState alloc] initWithMachine:self];
}

- (void)ejectMoney {
    [self.currentState ejectMoney];
    self.currentState = [[ZZNoMoenyState alloc] initWithMachine:self];
}

- (void)pressButton {
    [self.currentState pressButton];
    self.currentState = [[ZZSoldState alloc] initWithMachine:self];
}

@end
