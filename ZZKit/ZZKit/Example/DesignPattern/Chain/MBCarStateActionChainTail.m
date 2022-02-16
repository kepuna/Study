//
//  MBCarStateActionChainTail.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/10.
//  Copyright © 2020 HelloWorld. All rights reserved.
// 责任链尾 - 不做任何处理 - 仅是为了方便操作

#import "MBCarStateActionChainTail.h"

@implementation MBCarStateActionChainTail
@synthesize nextAction = _nextAction;

- (void)processRequest:(MBCarStateButtonClickRequest *)request {
    [self.nextAction processRequest:request];
}
@end
