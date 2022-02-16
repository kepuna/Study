//
//  UserBuilder.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZPerson;
NS_ASSUME_NONNULL_BEGIN

@interface UserBuilder : NSObject

+ (ZZPerson *) personFromDictionary: (NSDictionary *) ownerValues;

@end

NS_ASSUME_NONNULL_END
