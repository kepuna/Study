//
//  SeatChangeCommand.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/12/28.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "Command.h"

NS_ASSUME_NONNULL_BEGIN

@interface SeatChangeCommand : Command

/// 是否在游戏中
@property (nonatomic, assign, getter=isGaming) BOOL gaming;

/// 换座之前的座位id
@property (nonatomic, copy) NSString *fromSeatId;

/// 要换到的座位id
@property (nonatomic, copy) NSString *toSeatId;

@end

NS_ASSUME_NONNULL_END
