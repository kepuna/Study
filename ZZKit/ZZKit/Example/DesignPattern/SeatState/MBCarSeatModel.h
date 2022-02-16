//
//  MBCarSeatModel.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/3.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBCarSeatModel : NSObject

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatarUrl; // 头像地址
@property (nonatomic, copy) NSString *roleText; // 角色描述
@property (nonatomic, copy) NSString *playTimes; // 上车/开车 次数
/// 1 坐上有人 2开启可上坐 3关闭，可开启 4无效
@property (nonatomic, assign) NSInteger seatState; // 座位状态

@end

NS_ASSUME_NONNULL_END
