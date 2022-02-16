//
//  ZZStateProtocol.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/6/22.
//  Copyright © 2020 HelloWorld. All rights reserved.
//。状态行为协议

#import <Foundation/Foundation.h>
#import "ZZSaleMachine.h"
NS_ASSUME_NONNULL_BEGIN

/*
 售卖机的4种状态
 - 有钱，没钱，售卖、售罄
 
 售卖机的4中行为， 每种状态不同的行为
 - 投币
 - 退钱
 按钮
 发布
 
 */

@protocol ZZStateProtocol <NSObject>

@property (nonatomic, weak) ZZSaleMachine *machine;

- (instancetype)initWithMachine:(ZZSaleMachine *)machine;
@optional
/// 投币
- (void)putMoney;

/// 退钱
- (void)ejectMoney;

/// 按钮
- (void)pressButton;

/// 发布
- (void)distribute;

@end

NS_ASSUME_NONNULL_END
