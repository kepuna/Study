//
//  UserBuilder.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "UserBuilder.h"
#import "ZZPerson.h"

@implementation UserBuilder

+ (ZZPerson *)personFromDictionary:(NSDictionary *)ownerValues {
    
    NSString *name = [ownerValues objectForKey: @"display_name"];
    NSString *avatarURL = [NSString stringWithFormat: @"http://www.gravatar.com/avatar/%@", [ownerValues objectForKey: @"email_hash"]];
    if (name == nil) {
        name = [ownerValues objectForKey: @"nickname"];
    }
    ZZPerson *owner = [[ZZPerson alloc] initWithName: name avatarLocation: avatarURL];
    return owner;
}

@end
