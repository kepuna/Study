//
//  MBCarStateActionChainHeader.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/10.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "MBCarStateActionChainHeader.h"

@implementation MBCarStateActionChainHeader
@synthesize nextAction = _nextAction;

- (void)processRequest:(MBCarStateButtonClickRequest *)request {
    [self.nextAction processRequest:request];
}
@end
