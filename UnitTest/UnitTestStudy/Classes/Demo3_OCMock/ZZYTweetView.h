//
//  ZZYTweetView.h
//  UnitTestStudy
//
//  Created by donews on 2019/9/27.
//  Copyright © 2019年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZYTweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZYTweetView : UIView

//接口TweetView具有将单个推文添加到视图的方法
- (void)addTweet:(ZZYTweet *)aTweet;

@end

NS_ASSUME_NONNULL_END
