//
//  FakeURLResponse.h
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/8/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FakeURLResponse : NSObject
{
    NSInteger statusCode;
}
- (id)initWithStatusCode: (NSInteger)code;
- (NSInteger)statusCode;

@end

NS_ASSUME_NONNULL_END
