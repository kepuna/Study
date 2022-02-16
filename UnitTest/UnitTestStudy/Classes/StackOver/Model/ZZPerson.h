//
//  ZZPerson.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZPerson : NSObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, strong) NSURL *avatarURL;

- (instancetype)initWithName:(NSString *)name avatarLocation:(NSString *)avatarLocation;
@end

NS_ASSUME_NONNULL_END
