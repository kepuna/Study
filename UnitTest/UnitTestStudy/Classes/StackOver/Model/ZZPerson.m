//
//  ZZPerson.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZPerson.h"

@implementation ZZPerson


- (instancetype)initWithName:(NSString *)name avatarLocation:(NSString *)avatarLocation
{
    self = [super init];
    if (self) {
        _name = name;
        _avatarURL = [NSURL URLWithString:avatarLocation];
    }
    return self;
}

@end
