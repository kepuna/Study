//
//  ZZOperationModel.h
//  HighPerformance
//
//  Created by MOMO on 2020/7/8.
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

@interface ZZOperationModel : NSObject

@property (nonatomic, assign) NSInteger online; // 1 在线 2 离线
@property (nonatomic, assign) NSNumber *seatState; // 0未锁 1锁定

//@property (nonatomic, assign) NSInteger caption; // 0不是队长 1 表示是队长

//  队长的 0 1 2 4 代表锁定、 在线、可关闭、可开启
//  队员的 0 1 2 4 代表锁定、 在线、可加入、已关闭



/// 0是观众 1是队员
@property (nonatomic, assign) NSInteger role;
/// 4个阶段
@property (nonatomic, assign) MBCarRoomGameState gameState;



@property (nonatomic, assign) NSInteger buttonTip;

// 1 在线
// 2 离线-未锁 CanClose
// 4 离线-锁定 CanOpen
@property (nonatomic, assign) NSInteger helpState;



@end

NS_ASSUME_NONNULL_END
