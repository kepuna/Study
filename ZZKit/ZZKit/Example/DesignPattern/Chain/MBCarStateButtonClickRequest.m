//
//  MBCarStateButtonClickRequest.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/9.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "MBCarStateButtonClickRequest.h"

@interface MBCarStateButtonClickRequest ()

@end

@implementation MBCarStateButtonClickRequest
- (instancetype)initWithGameState:(NSInteger)gameState
{
    self = [super init];
    if (self) {
       _gameState = gameState;
    }
    return self;
}

- (void)printTip {
    NSLog(@"++++++++ %zd",self.gameState);
}

@end
