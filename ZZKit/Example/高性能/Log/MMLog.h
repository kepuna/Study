//
//  MMLog.h
//  HighPerformance
//
//  Created by MOMO on 2021/3/3.
//  Copyright © 2021 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMLog : NSObject

+ (void)setLogEnabled:(BOOL)enable;
+ (void)changeVisible;

@end

NS_ASSUME_NONNULL_END
