//
//  ZZYTwitterViewController.h
//  UnitTestStudy
//
//  Created by donews on 2019/9/27.
//  Copyright © 2019年 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZYTwitterConnection.h"
#import "ZZYTweetView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZYTwitterViewController : UIViewController
@property (nonatomic, strong) ZZYTwitterConnection *connection;/**< 一个处理Twitter API调用的类 */
@property (nonatomic, strong) ZZYTweetView *tweetView;/**< 视图类 */
- (void)updateTweetView;
- (void)updateTweetView2;
@end

NS_ASSUME_NONNULL_END
