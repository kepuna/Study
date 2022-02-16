//
//  StackOverCommunicator.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "StackOverCommunicator.h"

NSString *StackOverflowCommunicatorErrorDomain = @"StackOverflowCommunicatorErrorDomain";


@interface StackOverCommunicator ()

//@property (nonatomic, strong) NSURLConnection *fetchingConnection;
//
//// 接收到网络数据
//@property (nonatomic, strong) NSMutableData *receivedData;

@end

@implementation StackOverCommunicator


- (void)searchForQuestionsWithTag:(NSString *)tag {

    NSURL *requestURL = [NSURL URLWithString:@"http://mobile.ximalaya.com/feed/v1/recommend/classic/unlogin?pageId=1&pageSize=20&ts=1473389098.260717"];
    
    [self fetchContentAtURL:requestURL errorHandler:^(NSError *error) {
        if (self.delegate  && [self.delegate respondsToSelector:@selector(searchingForQuestionsFailedWithError:)]) {
            [self.delegate searchingForQuestionsFailedWithError:error];
        }
        
    } successHandler:^(NSString *responseJsonString) {
        if (self.delegate  && [self.delegate respondsToSelector:@selector(receivedQuestionsJSON:)]) {
            [self.delegate receivedQuestionsJSON:responseJsonString];
        }
    }];
}

- (void)downloadInformationForQuestionWithID:(NSInteger)identifier {
     
    NSLog(@"999999=++++ %zd++++",identifier);
     NSURL *requestURL = [NSURL URLWithString:@"http://mobile.ximalaya.com/feed/v1/recommend/classic/unlogin?pageId=2&pageSize=10&ts=1473389098.260717"];
    
    [self fetchContentAtURL:requestURL errorHandler:^(NSError *error) {
        if (self.delegate  && [self.delegate respondsToSelector:@selector(fetchingQuestionBodyFailedWithError:)]) {
            [self.delegate fetchingQuestionBodyFailedWithError:error];
        }
    } successHandler:^(NSString *responseJsonString) {
        if (self.delegate  && [self.delegate respondsToSelector:@selector(receivedQuestionBodyJSON:)]) {
            [self.delegate receivedQuestionBodyJSON:responseJsonString];
        }
    }];
}

- (void)downloadAnswersToQuestionWithID:(NSInteger)identifier {
    NSURL *requestURL = [NSURL URLWithString:@"http://mobile.ximalaya.com/feed/v1/recommend/classic/unlogin?pageId=2&pageSize=10&ts=1473389098.260717"];
    
    [self fetchContentAtURL:requestURL errorHandler:^(NSError *error) {
        
        if (self.delegate  && [self.delegate respondsToSelector:@selector(fetchingAnswersFailedWithError:)]) {
            [self.delegate fetchingAnswersFailedWithError:error];
        }
    } successHandler:^(NSString *responseJsonString) {
        if (self.delegate  && [self.delegate respondsToSelector:@selector(receivedAnswerListJSON:)]) {
            [self.delegate receivedAnswerListJSON:responseJsonString];
        }
    }];
    
}

#pragma mark - Private Method
- (void)dealloc {
    [self.fetchingConnection cancel];
}
/// 启动请求
- (void)launchConnectionForRequest: (NSURLRequest *)request  {
    [self cancelAndDiscardURLConnection];
    self.fetchingConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
}


- (void)fetchContentAtURL:(NSURL *)url errorHandler:(void(^)(NSError *error))errorBlock successHandler:(void (^)(NSString *responseJsonString))successBlock {
    
    self.fetchingURL = url;
    self.errorHandler = [errorBlock copy];
    self.successHandler = [successBlock copy];
    
    NSURLRequest *request = [NSURLRequest requestWithURL: self.fetchingURL];
    [self launchConnectionForRequest:request];
}

- (void)cancelAndDiscardURLConnection {
    [self.fetchingConnection cancel];
    self.fetchingConnection = nil;
}


#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    self.receivedData = nil;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode] != 200) {
        NSError *error = [NSError errorWithDomain: StackOverflowCommunicatorErrorDomain code: [httpResponse statusCode] userInfo: nil];
        self.errorHandler(error);
        [self cancelAndDiscardURLConnection];
    }
    else {
        self.receivedData = [[NSMutableData alloc] init];
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    self.receivedData = nil;
    self.fetchingConnection = nil;
    self.fetchingURL = nil;
    self.errorHandler(error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.fetchingConnection = nil;
    self.fetchingURL = nil;
    NSString *receivedText = [[NSString alloc] initWithData: self.receivedData
                                                   encoding: NSUTF8StringEncoding];
    self.receivedData = nil;
    self.successHandler(receivedText);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData: data];
}

@end
