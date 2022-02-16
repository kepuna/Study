//
//  CounterModel.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/8.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CounterModel : NSObject

@property (nonatomic) NSInteger count;

- (instancetype)initWithUserDefault:(NSUserDefaults *)defaults;

/// 加
- (void)increment;
/// 减
- (void)decrement;

- (NSInteger)getCountInDefaults;
@end

NS_ASSUME_NONNULL_END
