//
//  ZZAccountNormalState.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/2.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZAccountNormalState.h"
#import "ZZAccountOverdraftState.h"
#import "ZZAccountRestrictedState.h"
#import "ZZAccount.h"
@implementation ZZAccountNormalState
@synthesize account = _account;


#pragma mark - 4种行为
- (void)deposit:(double)amount {
    [_account setBalance: _account.balance + amount];
    [self stateCheck];
}

- (void)withdraw:(double)amount {
    [_account setBalance:_account.balance - amount];
    [self stateCheck];
}

- (void)computeInterest {
    NSLog(@"正常状态，无须支付利息！");
}

/// 状态转换
- (void)stateCheck {
    if (self.account.balance > -2000 && self.account.balance <=0) {
        ZZAccountOverdraftState *state = [ZZAccountOverdraftState alloc];
        state.account = self.account;
        [self.account setState:state];
    } else if(self.account.balance == -2000) {
        ZZAccountRestrictedState *state = [ZZAccountRestrictedState alloc];
        state.account = self.account;
        [self.account setState:state];
    } else if (self.account.balance < -2000) {
        NSLog(@"操作受限！");
    }
}

@end
