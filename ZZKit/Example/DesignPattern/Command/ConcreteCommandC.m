//
//  ConcreteCommandC.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/9.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ConcreteCommandC.h"
#import "ReceiverC.h"
@interface ConcreteCommandC ()
@property (nonatomic, strong) ReceiverC *receiver;
@end

@implementation ConcreteCommandC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.receiver = [ReceiverC new];
    }
    return self;
}
-(void)execute {
    [self.receiver handleActionForCommmanC];
}
@end
