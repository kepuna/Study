//
//  ZZAccountOverdraftState.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/2.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZAccountOverdraftState.h"
#import "ZZAccountNormalState.h"
#import "ZZAccountRestrictedState.h"
#import "ZZAccount.h"

@implementation ZZAccountOverdraftState
@synthesize account = _account;
- (void)deposit:(double)amount {
    [_account setBalance: _account.balance + amount];
    [self stateCheck];
}

- (void)withdraw:(double)amount {
    [_account setBalance:self.account.balance - amount];
    [self stateCheck];
}

- (void)computeInterest {
    NSLog(@"计算利息！");
}

- (void)stateCheck {
    if (self.account.balance > 0) {
        ZZAccountNormalState *state = [ZZAccountNormalState alloc];
        state.account = self.account;
        [self.account setState:state];
    } else if (self.account.balance == -2000) {
        ZZAccountRestrictedState *state = [ZZAccountRestrictedState alloc];
        state.account = self.account;
        [self.account setState:state];
    } else if (self.account.balance < -2000) {
          NSLog(@"操作受限！");
    }
}
@end
