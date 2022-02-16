//
//  ZZAccount.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/2.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZAccount.h"
#import "ZZAccountStateProtocol.h"
#import "ZZAccountNormalState.h"
@interface ZZAccount ()

@property (nonatomic, copy) NSString *owner; // 开户名


@end
@implementation ZZAccount
- (instancetype)initWithOwner:(NSString *)owner init:(double)init
{
    self = [super init];
    if (self) {
        self.owner = owner;
        self.balance = self.balance + init;
        self.state = [ZZAccountNormalState new];
        self.state.account = self;
        NSLog(@"---%@ 开户，初始金额为：%lf",self.owner, init);
    }
    return self;
}

- (void)deposit:(double)amount {
    NSLog(@"%@ 存款 %f",self.owner, amount);
    [self.state deposit:amount];
    NSLog(@"现在余额为：%f",self.balance);
    NSLog(@"现在账户状态为：%@",self.state);
}

- (void)computeInterest {
    //调用状态对象的computeInterest()方法
    [self.state computeInterest];
}



- (void)withdraw:(double)amount {
    NSLog(@"%@ 取款 %f",self.owner, amount);
    [self.state withdraw:amount];
    NSLog(@"现在余额为：%f",self.balance);
    NSLog(@"现在账户状态为：%@",self.state);
}


@end
