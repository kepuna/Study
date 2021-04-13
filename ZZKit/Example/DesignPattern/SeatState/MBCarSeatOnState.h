//
//  MBCarSeatOnState.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/3.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  坐上有人状态 - 此时，不能开不能关， 但是队长可以管理： 抱下踢出..


#import <Foundation/Foundation.h>
#import "MBCarSeatStateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBCarSeatOnState : NSObject<MBCarSeatStateProtocol>

@end

NS_ASSUME_NONNULL_END
