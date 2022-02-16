//
//  MBCarStateActionChainHeader.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/10.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  责任链头 - 不做任何处理 - 仅是为了方便操作

#import <Foundation/Foundation.h>
#import "MBCarStateButtonActionChain.h"
NS_ASSUME_NONNULL_BEGIN

@interface MBCarStateActionChainHeader : NSObject <MBCarStateButtonActionChain>

@end

NS_ASSUME_NONNULL_END
