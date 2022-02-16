//
//  GravatarCommunicator.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "GravatarCommunicator.h"

@implementation GravatarCommunicator

- (void)fetchDataForURL:(NSURL *)location {
    self.url = location;
    
    // 请求数据
    NSURLRequest *request = [NSURLRequest requestWithURL: location];
    self.connection = [NSURLConnection connectionWithRequest: request delegate: self];
}

#pragma mark NSURLConnection Delegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
   
    if (self.delegate && [self.delegate respondsToSelector:@selector(communicatorReceivedData:forURL:)]) {
        [self.delegate communicatorReceivedData:[self.receivedData copy] forURL:self.url];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData: data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(communicatorGotErrorForURL:)]) {
        [self.delegate communicatorGotErrorForURL:self.url];
    }
}

@end
