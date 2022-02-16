//
//  StackOverflowCommunicatorTests.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/8/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  测试模拟网络数据

#import <XCTest/XCTest.h>
#import "InspectableStackOverflowCommunicator.h"
#import "NonNetworkedStackOverflowCommunicator.h"
#import "FakeURLResponse.h"
#import "MockStackOverflowManager.h"

@interface StackOverflowCommunicatorTests : XCTestCase {
     InspectableStackOverflowCommunicator *communicator;
    NonNetworkedStackOverflowCommunicator *nnCommunicator;
    MockStackOverflowManager *manager;
    
    FakeURLResponse *fourOhFourResponse;
    NSData *receivedData;
}

@end

@implementation StackOverflowCommunicatorTests

- (void)setUp {
    
    communicator = [[InspectableStackOverflowCommunicator alloc] init];
    nnCommunicator = [[NonNetworkedStackOverflowCommunicator alloc] init];
    
    manager = [[MockStackOverflowManager alloc] init];
    nnCommunicator.delegate = manager;
    fourOhFourResponse = [[FakeURLResponse alloc] initWithStatusCode: 404];
    receivedData = [@"Result" dataUsingEncoding: NSUTF8StringEncoding];
}

- (void)tearDown {
     [communicator cancelAndDiscardURLConnection];
}

#pragma mark - communicator - InspectableStackOverflowCommunicator
/// 模拟测试 通信器类里一些网络请求数据的方法
- (void)testSearchingForQuestionsOnTopicCallsTopicAPI {
    [communicator searchForQuestionsWithTag: @"ios"];
    XCTAssertEqualObjects([[communicator URLToFetch] absoluteString], @"http://mobile.ximalaya.com/feed/v1/recommend/classic/unlogin?pageId=1&pageSize=20&ts=1473389098.260717");
}

- (void)testFillingInQuestionBodyCallsQuestionAPI {http://mobile.ximalaya.com/feed/v1/recommend/classic/unlogin?pageId=1&pageSize=20&ts=1473389098.260717
    [communicator downloadInformationForQuestionWithID: 12345];
    XCTAssertEqualObjects([[communicator URLToFetch] absoluteString], @"http://api.stackoverflow.com/1.1/questions/12345?body=true", @"Use the question API to get the body for a question");
}

- (void)testFetchingAnswersToQuestionCallsQuestionAPI {
    [communicator downloadAnswersToQuestionWithID: 12345];
    XCTAssertEqualObjects([[communicator URLToFetch] absoluteString], @"http://api.stackoverflow.com/1.1/questions/12345/answers?body=true", @"Use the question API to get answers on a given question");
}

- (void)testSearchingForQuestionsCreatesURLConnection {
    [communicator searchForQuestionsWithTag: @"ios"];
    XCTAssertNotNil([communicator currentURLConnection], @"There should be a URL connection in-flight now.");
}

- (void)testStartingNewSearchThrowsOutOldConnection {
    [communicator searchForQuestionsWithTag: @"ios"];
    NSURLConnection *firstConnection = [communicator currentURLConnection];
    [communicator searchForQuestionsWithTag: @"cocoa"];
    XCTAssertFalse([[communicator currentURLConnection] isEqual: firstConnection], @"The communicator needs to replace its URL connection to start a new one");
}

/*
 
 ## 404 情况

 NSURLConnection在发送URL请求之后获取到服务器所回复的信息主体， 那么即使该信息主体所描述的是一个协议级别错误 而不是所需要的数据， NSURLConnection 还是会认为当前的请求已经处理成功了。

 所以需要查看Response信息中所包含的具体内容，以判断是否有HTTP 404 这种错误状态码， 以便合理地应对各种状况。

 下面所列的这个测试方法描述的是 获取同个话题相关的问题列表的Response， 其余情况与此类似。
 
 这些测试方法已经提供了足够多的信息，使得我们能以之实现StackOverflowCommunicator类中那些触发回调逻辑的方法。
 */

- (void)testReceivingResponseDiscardsExistingData {
    nnCommunicator.receivedData = [@"Hello" dataUsingEncoding: NSUTF8StringEncoding];
    [nnCommunicator searchForQuestionsWithTag: @"ios"];
    [nnCommunicator connection: nil didReceiveResponse: nil];
    XCTAssertEqual([nnCommunicator.receivedData length], (NSUInteger)0, @"Data should have been discarded");
}

- (void)testReceivingResponseWith404StatusPassesErrorToDelegate {
    [nnCommunicator searchForQuestionsWithTag: @"ios"];
    [nnCommunicator connection: nil didReceiveResponse: (NSURLResponse *)fourOhFourResponse];
    XCTAssertEqual([manager topicFailureErrorCode], 404, @"Fetch failure was passed through to delegate");
}


- (void)testNoErrorReceivedOn200Status {
    FakeURLResponse *twoHundredResponse = [[FakeURLResponse alloc] initWithStatusCode: 200];
    [nnCommunicator searchForQuestionsWithTag: @"ios"];
    [nnCommunicator connection: nil didReceiveResponse: (NSURLResponse *)twoHundredResponse];
    XCTAssertFalse([manager topicFailureErrorCode] == 200, @"No need for error on 200 response");
}

- (void)testReceiving404ResponseToQuestionBodyRequestPassesErrorToDelegate {
    [nnCommunicator downloadInformationForQuestionWithID: 12345];
    [nnCommunicator connection: nil didReceiveResponse: (NSURLResponse *)fourOhFourResponse];
    XCTAssertEqual([manager bodyFailureErrorCode], 404, @"Body fetch error was passed through to delegate");
}

- (void)testReceiving404ResponseToAnswerRequestPassesErrorToDelegate {
    [nnCommunicator downloadAnswersToQuestionWithID: 12345];
    [nnCommunicator connection: nil didReceiveResponse: (NSURLResponse *)fourOhFourResponse];
    XCTAssertEqual([manager answerFailureErrorCode], 404, @"Answer fetch error was passed to delegate");
}

- (void)testConnectionFailingPassesErrorToDelegate {
    [nnCommunicator searchForQuestionsWithTag: @"ios"];
    NSError *error = [NSError errorWithDomain: @"Fake domain" code: 12345 userInfo: nil];
    [nnCommunicator connection: nil didFailWithError: error];
    XCTAssertEqual([manager topicFailureErrorCode], 12345, @"Failure to connect should get passed to the delegate");
}

- (void)testSuccessfulQuestionSearchPassesDataToDelegate {
    [nnCommunicator searchForQuestionsWithTag: @"ios"];
    [nnCommunicator setReceivedData: receivedData];
    [nnCommunicator connectionDidFinishLoading: nil];
    XCTAssertEqualObjects([manager topicSearchString], @"Result", @"The delegate should have received data on success");
}

/*
 现在这个类只剩下一点点没完成，那就是当它从通信器对象中接收到数据时， 应该将这部分数据追加到已有响应数据的末尾 。
 针对此功能所写的测试方法如下：
 */

- (void)testSuccessfulBodyFetchPassesDataToDelegate {
    [nnCommunicator downloadInformationForQuestionWithID: 12345];
    [nnCommunicator setReceivedData: receivedData];
    [nnCommunicator connectionDidFinishLoading: nil];
    XCTAssertEqualObjects([manager questionBodyString], @"Result", @"The delegate should have received the question body data");
}

- (void)testSuccessfulAnswerFetchPassesDataToDelegate {
    [nnCommunicator downloadAnswersToQuestionWithID: 12345];
    [nnCommunicator setReceivedData: receivedData];
    [nnCommunicator connectionDidFinishLoading: nil];
    XCTAssertEqualObjects([manager answerListString], @"Result", @"Answer list should be passed to delegate");
}

- (void)testAdditionalDataAppendedToDownload {
    [nnCommunicator setReceivedData: receivedData];
    NSData *extraData = [@" appended" dataUsingEncoding: NSUTF8StringEncoding];
    [nnCommunicator connection: nil didReceiveData: extraData];
    NSString *combinedString = [[NSString alloc] initWithData: [nnCommunicator receivedData] encoding: NSUTF8StringEncoding];
    XCTAssertEqualObjects(combinedString, @"Result appended", @"Received data should be appended to the downloaded data");
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
