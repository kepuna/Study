//
//  ZZAccountRestrictedState.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/2.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZAccountRestrictedState.h"
#import "ZZAccountNormalState.h"
#import "ZZAccountOverdraftState.h"
#import "ZZAccount.h"

@implementation ZZAccountRestrictedState
@synthesize account = _account;

- (void)deposit:(double)amount {
    [_account setBalance: _account.balance + amount];
    [self stateCheck];
}

- (void)withdraw:(double)amount {
    NSLog(@"帐号受限，n不能取款");
}

- (void)computeInterest {
    NSLog(@"计算利息！");
}

- (void)stateCheck {
    if (self.account.balance > 0) {
        ZZAccountNormalState *state = [ZZAccountNormalState alloc];
        state.account = self.account;
        [self.account setState:state];
    } else if (self.account.balance > -2000) {
        ZZAccountOverdraftState *state = [ZZAccountOverdraftState alloc];
        state.account = self.account;
        [self.account setState:state];
    }
}

@end
