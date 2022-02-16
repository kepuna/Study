//
//  FunctionButton.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/14.
//  Copyright © 2020 HelloWorld. All rights reserved.
//。充当请求的调用者 (请求的发送者)

#import <Foundation/Foundation.h>
#import "ZZCommandProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FunctionButton : NSObject

- (void)setCommand:(id<ZZCommandProtocol>)command;

@end

NS_ASSUME_NONNULL_END
