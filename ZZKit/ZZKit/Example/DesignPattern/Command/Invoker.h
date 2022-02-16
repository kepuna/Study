//
//  Invoker.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/9.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  调用者 - 即请求发送者 - 即命令的发出者

#import <Foundation/Foundation.h>
@protocol AbstractCommand;
NS_ASSUME_NONNULL_BEGIN

@interface Invoker : NSObject

@property (nonatomic, readonly, weak) id<AbstractCommand> command;
- (instancetype)initWithCommand:(id<AbstractCommand>)command;
/// 业务方法，用于调用命令类的execute方法
- (void)call;

@end

NS_ASSUME_NONNULL_END
