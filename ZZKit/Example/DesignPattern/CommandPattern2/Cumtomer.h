//
//  Cumtomer.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/12/28.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Command;

NS_ASSUME_NONNULL_BEGIN

@interface Cumtomer : NSObject

@property (nonatomic, strong) Command *command;

- (instancetype)initWithCommand:(Command *)command;

- (void)action;

@end

NS_ASSUME_NONNULL_END
