//
//  NonNetworkedStackOverflowCommunicator.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/8/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "NonNetworkedStackOverflowCommunicator.h"

@implementation NonNetworkedStackOverflowCommunicator
@synthesize receivedData = _receivedData;

- (void)setReceivedData:(NSData *)data {
    _receivedData = [data mutableCopy];
}

- (NSData *)receivedData {
    return [_receivedData copy];
}
@end
