//
//  InspectableStackOverflowCommunicator.h
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/8/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

//#import "StackOverCommunicator.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "StackOverCommunicator.h"

NS_ASSUME_NONNULL_BEGIN

/*
 只有在测试用例中才需要探查那么视图访问的URL， 所以不应该是StackOverCommunicator本类API的一部分；
 这项功能应该定义一个 子类 InspectableStackOverflowCommunicator，由子类来提供。
 */
@interface InspectableStackOverflowCommunicator : StackOverCommunicator

- (NSURL *)URLToFetch;
- (NSURLConnection *)currentURLConnection;

@end

NS_ASSUME_NONNULL_END
