//
//  ZZYTwitterConnection.h
//  UnitTestStudy
//
//  Created by donews on 2019/9/27.
//  Copyright © 2019年 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZYTweet;
NS_ASSUME_NONNULL_BEGIN

@interface ZZYTwitterConnection : NSObject

//接口TwitterConnection具有检索新推文的方法 它返回Tweet对象数组，或者nil无法处理请求
- (NSArray<ZZYTweet *> *)fetchTweets;
+ (NSArray<ZZYTweet *> *)fetchTweets;


@end

NS_ASSUME_NONNULL_END
