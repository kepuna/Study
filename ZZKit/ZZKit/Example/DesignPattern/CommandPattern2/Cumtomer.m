//
//  Cumtomer.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/12/28.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "Cumtomer.h"
#import "Command.h"

@implementation Cumtomer

- (instancetype)initWithCommand:(Command *)command {
    self = [super init];
    if (self) {
        self.command = command;
    }
    return self;
}

- (void)action {
    [self.command execute];
}

@end
