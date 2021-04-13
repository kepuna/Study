//
//  MBCarStateButtonClickRequest.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/9.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MBCarRoomGameState) {
    MBCarRoomGameStateWaitJoin = 0, // 等待队员加入
    MBCarRoomGameStateWaitPrepare = 1, // 等待队员准备
    MBCarRoomGameStateDrive = 2,  // 待发车
    MBCarRoomGameStateGaming = 3  // 已发车 游戏中
};

// 队长不做处理


// 队员 1 和各个阶段做 & 操作
// 观众 0 和各个阶段做&操作

// 队长不做处理
  
  // 队员 1 和各个阶段做 & 操作
  // 观众 0 和各个阶段做&操作

@interface MBCarStateButtonClickRequest : NSObject

// 游戏状态0(等待队员加入)  1(等待队员准备)  2(待发车)  3(进行中)
@property (nonatomic, readonly, assign) MBCarRoomGameState gameState;

@property (nonatomic, assign, getter=isPrepared) BOOL prepared; // 是否已准备

- (instancetype)initWithGameState:(NSInteger)gameState;
- (void)printTip;

@end

NS_ASSUME_NONNULL_END
