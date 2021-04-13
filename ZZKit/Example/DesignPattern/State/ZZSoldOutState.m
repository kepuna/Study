//
//  ZZSoldOutState.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/6/23.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZSoldOutState.h"

@implementation ZZSoldOutState
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
     NSLog(@"SoldOutState-PutMoney:已售罄");
}

- (void)ejectMoney {
     NSLog(@"SoldOutState-ejectMoney:无法退钱");
}

-(void)pressButton{
    NSLog(@"SoldOutState-pressButton:无法售出");
}
 
-(void)distribute{
    NSLog(@"SoldOutState-distribute:无法分发");
}

@end
