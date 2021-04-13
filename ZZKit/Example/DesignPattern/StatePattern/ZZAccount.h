//
//  ZZAccount.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/2.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZAccountStateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

//银行账户：环境类
@interface ZZAccount : NSObject <ZZAccountStateProtocol>

@property (nonatomic, strong) id<ZZAccountStateProtocol> state;
@property (nonatomic, assign) double balance; // 账户余额

/// 初始化方法
/// @param owner 开户名
/// @param init 初始金额
- (instancetype)initWithOwner:(NSString *)owner init:(double)init;

@end

NS_ASSUME_NONNULL_END
