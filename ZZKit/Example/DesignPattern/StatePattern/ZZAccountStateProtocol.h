//
//  ZZAccountStateProtocol.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/2.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZAccount;
NS_ASSUME_NONNULL_BEGIN

@protocol ZZAccountStateProtocol <NSObject>

@property (nonatomic, weak) ZZAccount *account;

//- (instancetype)initWithAccount:(ZZAccount *)account;

/// 存款
- (void)deposit:(double)amount;
/// 取款
- (void)withdraw:(double)amount;
/// 计算利息
- (void)computeInterest;
/// 状态检测
- (void)stateCheck;



@end

NS_ASSUME_NONNULL_END
