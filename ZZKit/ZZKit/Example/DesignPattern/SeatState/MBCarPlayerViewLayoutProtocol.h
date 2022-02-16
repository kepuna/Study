//
//  MBCarPlayerViewLayoutProtocol.h
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/3.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  车队玩家布局

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBCarPlayerViewLayoutProtocol <NSObject>

- (void)setupUI;
- (void)subviewsLayout;

@end

NS_ASSUME_NONNULL_END
