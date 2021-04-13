//
//  MBCarSeatStateMachine.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/3.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MBCarSeatStateProtocol;
NS_ASSUME_NONNULL_BEGIN

@interface MBCarSeatStateMachine : NSObject

@property (nonatomic, strong) id <MBCarSeatStateProtocol> currentState;


/// 初始化
/// @param stateNum 状态Number
- (instancetype)initWithStateNum:(NSUInteger)stateNum;

@end

NS_ASSUME_NONNULL_END
