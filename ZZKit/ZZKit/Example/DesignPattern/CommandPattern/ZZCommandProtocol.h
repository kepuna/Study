//
//  ZZCommandProtocol.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/14.
//  Copyright © 2020 HelloWorld. All rights reserved.
//。充当抽象命令类

/**
 

 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZZCommandProtocol <NSObject>

- (void)execute;

@end

NS_ASSUME_NONNULL_END
