//
//  AvatarStore.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GravatarCommunicatorDelegate.h"
NS_ASSUME_NONNULL_BEGIN

extern NSString *AvatarStoreDidUpdateContentNotification;

@interface AvatarStore : NSObject <GravatarCommunicatorDelegate>
{
    NSMutableDictionary *dataCache;
    NSMutableDictionary *communicators;
    NSNotificationCenter *notificationCenter;
}


- (NSData *)dataForURL: (NSURL *)url;
- (void)didReceiveMemoryWarning: (NSNotification *)note;
- (void)useNotificationCenter: (NSNotificationCenter *)center;
- (void)stopUsingNotificationCenter: (NSNotificationCenter *)center;

@end

NS_ASSUME_NONNULL_END
