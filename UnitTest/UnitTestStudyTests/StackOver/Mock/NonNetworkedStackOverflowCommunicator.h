//
//  NonNetworkedStackOverflowCommunicator.h
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/8/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "StackOverCommunicator.h"

NS_ASSUME_NONNULL_BEGIN

@interface NonNetworkedStackOverflowCommunicator : StackOverCommunicator
@property (nonatomic, copy) NSData *receivedData;
@end

NS_ASSUME_NONNULL_END
