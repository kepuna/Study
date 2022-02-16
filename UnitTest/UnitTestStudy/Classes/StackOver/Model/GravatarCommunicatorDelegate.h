//
//  GravatarCommunicatorDelegate.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GravatarCommunicatorDelegate <NSObject>

- (void)communicatorReceivedData: (NSData *)data forURL: (NSURL *)url;

- (void)communicatorGotErrorForURL: (NSURL *)url;

@end

NS_ASSUME_NONNULL_END
