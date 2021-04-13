//
//  ZZAccountNormalState.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/2.
//  Copyright © 2020 HelloWorld. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ZZAccountStateProtocol.h"
NS_ASSUME_NONNULL_BEGIN
/// 账户三种状态之一 - 普通状态
@interface ZZAccountNormalState : NSObject<ZZAccountStateProtocol>

@end

NS_ASSUME_NONNULL_END
