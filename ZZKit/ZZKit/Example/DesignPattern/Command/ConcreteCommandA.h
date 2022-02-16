//
//  ConcreteCommandA.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/9.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  具体的命令类 - 它与请求接受者 相关联， 它在实现抽象命令类的 execute方法时， 调用“请求接受者”的action方法

#import <Foundation/Foundation.h>
#import "AbstractCommand.h"
NS_ASSUME_NONNULL_BEGIN

@interface ConcreteCommandA : NSObject <AbstractCommand>

@end

NS_ASSUME_NONNULL_END
