//
//  AbstractCommand.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/9.
//  Copyright © 2020 HelloWorld. All rights reserved.
//。抽象命令类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AbstractCommand <NSObject>

@required;
- (void)execute;

@end

NS_ASSUME_NONNULL_END
