//
//  ZZHuman.h
//  HighPerformance
//
//  Created by MOMO on 2020/6/29.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZHuman : NSObject

@property (nonatomic, copy) NSString *name;
//@property (nonatomic ,strong) NSMutableArray *family;
@property (nonatomic, strong) NSHashTable *family;

+ (instancetype) humanWithName:(NSString *)name;

+ (void)demoTest;
/// 循环引用♻️
+ (void)demoTestCycle;

+ (void)demoHashTable;

+ (void)demoMapTable;

@end

NS_ASSUME_NONNULL_END
