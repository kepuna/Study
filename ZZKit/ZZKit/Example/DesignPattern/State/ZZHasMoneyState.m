//
//  ZZHasMoneyState.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/6/22.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZHasMoneyState.h"

@implementation ZZHasMoneyState
@synthesize machine = _machine;
- (instancetype)initWithMachine:(ZZSaleMachine *)machine
{
    self = [super init];
    if (self) {
        _machine = machine;
    }
    return self;
}

-(void)putMoney{
    NSLog(@"HasMoneyState-putMoney:已经投入了钱，暂不支持投入");
}
 
-(void)ejectMoney{
    NSLog(@"HasMoneyState-ejectMoney:退钱,重新设置售卖机为无前状态");
}
 
-(void)pressButton{
   NSLog(@"HasMoneyState-pressButton:按钮按下,取货");
}
 
-(void)distribute{
  NSLog(@"HasMoneyState-distribute:无法进行取出商品,请先按按钮");
}

@end
