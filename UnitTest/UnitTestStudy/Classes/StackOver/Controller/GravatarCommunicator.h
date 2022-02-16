//
//  GravatarCommunicator.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GravatarCommunicatorDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface GravatarCommunicator : NSObject <NSURLConnectionDataDelegate>


@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, weak) id <GravatarCommunicatorDelegate> delegate;
@property (nonatomic, strong) NSURLConnection *connection;

- (void)fetchDataForURL: (NSURL *)location;

@end

NS_ASSUME_NONNULL_END
