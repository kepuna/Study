//
//  ConcreteCommandA.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/9.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ConcreteCommandA.h"
#import "ReceiverA.h"

@interface ConcreteCommandA ()
@property (nonatomic, strong) ReceiverA *receiver;
@end

@implementation ConcreteCommandA
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.receiver = [ReceiverA new];
    }
    return self;
}

- (void)execute {
    [self.receiver handleActionForCommmanA];
}
@end
