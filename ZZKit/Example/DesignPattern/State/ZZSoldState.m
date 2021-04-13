//
//  ZZSoldState.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/6/22.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZSoldState.h"

@implementation ZZSoldState
@synthesize machine = _machine;
- (instancetype)initWithMachine:(ZZSaleMachine *)machine
{
    self = [super init];
    if (self) {
        _machine = machine;
    }
    return self;
}

- (void)putMoney{
    NSLog(@"SoldState-putMoney:请稍后,正在进行商品出售");
}
 
-(void)ejectMoney{
     NSLog(@"SoldState-putMoney:请稍后,正在进行商品出售,无法退钱");
}
 
-(void)pressButton{
    NSLog(@"SoldState-putMoney:请在取出物品之后重新投币");
}
 
-(void)distribute{
//    [self.delegate realseProduct];
//    if ([self.delegate getCurrentCount]) {
//        [self.delegate setCurrentState:[self.delegate getNoMoneyState]];
//    }else{
//        [self.delegate setCurrentState:[self.delegate getSoldOutState]];
//    }
}

@end
