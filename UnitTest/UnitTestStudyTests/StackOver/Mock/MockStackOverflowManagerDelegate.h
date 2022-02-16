//
//  MockStackOverflowManagerDelegate.h
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverManagerDelegate.h"

@class ZZQuestion;
NS_ASSUME_NONNULL_BEGIN

@interface MockStackOverflowManagerDelegate : NSObject <StackOverManagerDelegate>

@property (strong) NSError *fetchError;
@property (strong) NSArray *fetchedQuestions;
@property (strong) ZZQuestion *successQuestion;
@property (strong) ZZQuestion *bodyQuestion;

@end

NS_ASSUME_NONNULL_END
