//
//  FakeURLResponse.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/8/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "FakeURLResponse.h"

@implementation FakeURLResponse
- (id)initWithStatusCode:(NSInteger)code {
    if ((self = [super init])) {
        statusCode = code;
    }
    return self;
}

- (NSInteger)statusCode {
    return statusCode;
}
@end
