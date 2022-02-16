//
//  AvatarStore.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "AvatarStore.h"
#import "GravatarCommunicator.h"
#import <UIKit/UIKit.h>

NSString *AvatarStoreDidUpdateContentNotification = @"AvatarStoreDidUpdateContentNotification";

@implementation AvatarStore

- (instancetype)init
{
    self = [super init];
    if (self) {
        dataCache = [[NSMutableDictionary alloc] init];
        communicators = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSData *)dataForURL:(NSURL *)url {
    if (url == nil) {
        return nil;
    }
    NSData *avatarData = [dataCache objectForKey: [url absoluteString]];
    if (avatarData == nil) {
        // 请求头像
        GravatarCommunicator *communicator = [[GravatarCommunicator alloc] init];
        [communicators setObject: communicator forKey: [url absoluteString]];
        communicator.delegate = self;
        [communicator fetchDataForURL: url];
    }
    return avatarData;
}

- (void)didReceiveMemoryWarning:(NSNotification *)note {
    [dataCache removeAllObjects];
}

- (void)useNotificationCenter:(NSNotificationCenter *)center {
    [center addObserver: self selector: @selector(didReceiveMemoryWarning:) name: UIApplicationDidReceiveMemoryWarningNotification object: nil];
    notificationCenter = center;
}

- (void)stopUsingNotificationCenter:(NSNotificationCenter *)center {
    [center removeObserver: self];
    notificationCenter = nil;
}

- (void)communicatorGotErrorForURL:(NSURL *)url {
    [communicators removeObjectForKey: [url absoluteString]];
}

- (void)communicatorReceivedData:(NSData *)data forURL:(NSURL *)url {
    if (url == nil || data == nil) {
        return;
    }
    [dataCache setObject:data forKey:[url absoluteString]];
    [communicators removeObjectForKey: [url absoluteString]];
    NSNotification *note = [NSNotification notificationWithName: AvatarStoreDidUpdateContentNotification object: self];
    [notificationCenter postNotification: note];
}

@end
