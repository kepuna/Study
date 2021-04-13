//
//  ConcreteCommandB.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/9.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ConcreteCommandB.h"
#import "ReceiverB.h"
@interface ConcreteCommandB ()
@property (nonatomic, strong) ReceiverB *receiver;
@end

@implementation ConcreteCommandB
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.receiver = [ReceiverB new];
    }
    return self;
}
-(void)execute {
    [self.receiver handleActionForCommmanB];
}
@end
