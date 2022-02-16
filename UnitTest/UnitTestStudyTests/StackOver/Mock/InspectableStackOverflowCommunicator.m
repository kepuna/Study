//
//  InspectableStackOverflowCommunicator.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/8/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "InspectableStackOverflowCommunicator.h"

@implementation InspectableStackOverflowCommunicator
- (NSURL *)URLToFetch {
    return self.fetchingURL;
}

- (NSURLConnection *)currentURLConnection {
    return self.fetchingConnection;
}
@end
