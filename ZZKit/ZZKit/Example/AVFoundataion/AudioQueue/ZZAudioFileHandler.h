//
//  ZZAudioFileHandler.h
//  ZZKit
//
//  Created by MOMO on 2021/4/30.
//  Copyright © 2021 donews. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "XDXSingleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZAudioFileHandler : NSObject
SingletonH

+ (instancetype)getInstance;

/**
 * Write audio data to file.
 */
- (void)writeFileWithInNumBytes:(UInt32)inNumBytes
               ioNumPackets:(UInt32 )ioNumPackets
                   inBuffer:(const void *)inBuffer
               inPacketDesc:(const AudioStreamPacketDescription*)inPacketDesc;

#pragma mark - Audio Queue

/**
 * Start / Stop record By Audio Queue.
 */

- (void)startRecordVoiceByAudioQueue:(AudioQueueRef)audioQueue
                   isNeedMagicCookie:(BOOL)isNeedMagicCookie
                           audioDesc:(AudioStreamBasicDescription)audioDesc;

- (void)stopVoiceRecordByAudioQueue:(AudioQueueRef)audioQueue
                 isNeedMagicCookie:(BOOL)isNeedMagicCookie;

@end

NS_ASSUME_NONNULL_END
