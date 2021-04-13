//
//  MBCarSeatStateProtocol.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/3.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBCarSeatStateMachine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MBCarSeatStateProtocol <NSObject>

@property (nonatomic, weak) MBCarSeatStateMachine *stateMachine;

- (instancetype)initWithMachine:(MBCarSeatStateMachine *)machine;

/// 可以上座 - 座位处于开启且没人的状态下可上座
- (void)canSeat;
///  开启座位
- (void)canOpen;
///  关闭座位
- (void)canClose;
@end

NS_ASSUME_NONNULL_END
