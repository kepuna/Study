//
//  ZZAudioUnitFileHandler.h
//  ZZKit
//
//  Created by MOMO on 2021/5/6.
//  Copyright © 2021 donews. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "XDXSingleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZAudioUnitFileHandler : NSObject
SingletonH

+ (instancetype)getInstance;

/**
 * Write audio data to file.
 */
- (void)writeFileWithInNumBytes:(UInt32)inNumBytes
                   ioNumPackets:(UInt32 )ioNumPackets
                       inBuffer:(const void *)inBuffer
                   inPacketDesc:(nullable const AudioStreamPacketDescription*)inPacketDesc;

- (void)startRecordVoiceByAudioUnitByAudioConverter:(nullable AudioConverterRef)audioConverter needMagicCookie:(BOOL)isNeedMagicCookie audioDesc:(AudioStreamBasicDescription)audioDesc;

- (void)stopVoiceRecordAudioConverter:(nullable AudioConverterRef)audioConverter
                     needMagicCookie:(BOOL)isNeedMagicCookie;

@end

NS_ASSUME_NONNULL_END
