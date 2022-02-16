//
//  BrowseOverflowObjectConfiguration.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/8/13.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "BrowseOverflowObjectConfiguration.h"
#import "StackOverManager.h"
#import "AvatarStore.h"

#import "StackOverCommunicator.h"
#import "AnswerBuilder.h"
#import "QuestionBuilder.h"

@implementation BrowseOverflowObjectConfiguration

- (StackOverManager *)stackOverflowManager {
    StackOverManager *manager = [[StackOverManager alloc] init];
    manager.communicator = [[StackOverCommunicator alloc] init];
    manager.communicator.delegate = manager;
    manager.bodyCommunicator = [[StackOverCommunicator alloc] init];
    manager.bodyCommunicator.delegate = manager;
    manager.questionBuilder = [[QuestionBuilder alloc] init];
    manager.answerBuilder = [[AnswerBuilder alloc] init];
    return manager;
}

- (AvatarStore *)avatarStore {
    static AvatarStore *avatarStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avatarStore = [[AvatarStore alloc] init];
        [avatarStore useNotificationCenter: [NSNotificationCenter defaultCenter]];
    });
    return avatarStore;
}

@end
