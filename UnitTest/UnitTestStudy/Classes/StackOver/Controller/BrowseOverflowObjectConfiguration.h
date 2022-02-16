//
//  BrowseOverflowObjectConfiguration.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/8/13.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StackOverManager;
@class AvatarStore;


@interface BrowseOverflowObjectConfiguration : NSObject

/**
 * A fully configured StackOverflowManager instance.
 */
- (StackOverManager *)stackOverflowManager;

/**
 * A fully configured AvatarStore instance.
 */
- (AvatarStore *)avatarStore;

@end

