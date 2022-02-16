//
//  ZZAudioQueueCaptureManager.h
//  ZZKit
//
//  Created by MOMO on 2021/4/30.
//  Copyright © 2021 donews. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "XDXSingleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZAudioQueueCaptureManager : NSObject
SingletonH

+ (instancetype)getInstance;

/**
 * Start / Stop Audio Queue
 */

- (void)startAudioCapture;
- (void)stopAudioCapture;

/**
 * Start / Pause / Stop record file
 */
- (void)startRecordFile;
- (void)pauseAudioCapture;
- (void)stopRecordFile;

@end

NS_ASSUME_NONNULL_END
