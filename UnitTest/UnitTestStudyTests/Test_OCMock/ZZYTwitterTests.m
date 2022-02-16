//
//  ZZYTwitterTests.m
//  UnitTestStudyTests
//
//  Created by donews on 2019/9/27.
//  Copyright © 2019年 HelloWorld. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "ZZYTwitterViewController.h"

@interface ZZYTwitterTests : XCTestCase

@end

@implementation ZZYTwitterTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

//使用OCMock，创建一个模拟对象ZZYTwitterConnection并编写如下测试
- (void)testDisplaysTweetsRetrievedFromConnection
{
    ZZYTwitterViewController *controller = [[ZZYTwitterViewController alloc] init];
//    创建一个模拟对象TwitterConnection
    id mockConnection = OCMClassMock(ZZYTwitterConnection.class);
    controller.connection = mockConnection;
    
//    模拟fetchTweets方法返回的数组值
    ZZYTweet *tweet1 = [ZZYTweet new];
    tweet1.title = @"OCMock is best";
    ZZYTweet *tweet2 = [ZZYTweet new];
    tweet2.title = @"Hello World!";
    NSArray *tweetArray = @[tweet1,tweet2];
    OCMStub([mockConnection fetchTweets]).andReturn(tweetArray);
    
//    模拟出来一个ZZYTweetView类
    id mockView = OCMClassMock(ZZYTweetView.class);
    controller.tweetView = mockView;
//    这里执行updateTweetView后，[mockView addTweet:]加入了tweet1和tweet2
    [controller updateTweetView];
//    [controller updateTweetView2];
//--------------------------------
//  验证使用对应参数的方法是否被调用
//--------------------------------
    
    // 成功
    OCMVerify([mockView addTweet:tweet1]);
    OCMVerify([mockView addTweet:tweet2]);
    OCMVerify([mockView addTweet:[OCMArg any]]); // [OCMArg any]匹配所有的参数值，既tweet1和tweet2
    
    
    //失败，因为执行[controller updateTweetView];的时候，mockView没有添加tweet3，所以验证不通过
//       ZZYTweet *tweet3 = [ZZYTweet new];
//       tweet3.title = @"I am three";
//        OCMVerify([mockView addTweet:tweet3]);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
