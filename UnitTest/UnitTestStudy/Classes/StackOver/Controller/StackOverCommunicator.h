//
//  StackOverCommunicator.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

/*
有两种情况：
 通信器不能从StackOverflow网站的API获取信息，它会告诉Manager类出错的原因
 通信器获取到了JSON格式数据，并将其传送回Manager类，后者设法从中构建出Question对象。
 
 */

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicatorDelegate.h"

extern NSString *StackOverflowCommunicatorErrorDomain;

@interface StackOverCommunicator : NSObject <NSURLConnectionDataDelegate>

// 获取数据的url
@property (nonatomic, strong) NSURL *fetchingURL;
/// 网络请求的 NSURLConnection 对象
@property (nonatomic, strong) NSURLConnection *fetchingConnection;
/// 接收到的数据
@property (nonatomic, strong) NSMutableData *receivedData;


/// 代理对象 - 各请求的代理回调
@property (nonatomic, weak) id <StackOverflowCommunicatorDelegate> delegate;

/// 错误的Block回调
@property (nonatomic, copy) void(^errorHandler)(NSError *error);
@property (nonatomic, copy) void(^successHandler)(NSString *string);


/// 获取某个话题上的提问列表
- (void)searchForQuestionsWithTag: (NSString *)tag;

- (void)downloadInformationForQuestionWithID: (NSInteger)identifier;
- (void)downloadAnswersToQuestionWithID: (NSInteger)identifier;

- (void)cancelAndDiscardURLConnection;

@end

