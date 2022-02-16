//
//  ZZSaleMachine.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/6/23.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  售卖机

#import <Foundation/Foundation.h>
@protocol ZZStateProtocol;
NS_ASSUME_NONNULL_BEGIN

@interface ZZSaleMachine : NSObject

@property (nonatomic, strong) id <ZZStateProtocol> currentState;
@property (nonatomic, assign) NSUInteger count; // 产品个数

/// 投币
- (void)putMoney;

/// 退钱
- (void)ejectMoney;

/// 按钮
- (void)pressButton;

@end

NS_ASSUME_NONNULL_END
