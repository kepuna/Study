//
//  ZZNoMoenyState.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/6/22.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZNoMoenyState.h"

@implementation ZZNoMoenyState
@synthesize machine = _machine;
- (instancetype)initWithMachine:(ZZSaleMachine *)machine
{
    self = [super init];
    if (self) {
        _machine = machine;
    }
    return self;
}

- (void)putMoney {
    NSLog(@"NoMoneyState-putMoney:投放钱币");
}

- (void)ejectMoney {
     NSLog(@"NoMoneyState-ejectMoney:没有投入钱币,无法退钱");
}

- (void)pressButton {
     NSLog(@"NoMoneyState-pressButton:请先投币");
}

- (void)distribute {
     NSLog(@"NoMoneyState-distribute:请投币");
}

@end
