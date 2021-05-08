//
//  ZZAudioUnitCaptureManager.h
//  ZZKit
//
//  Created by MOMO on 2021/5/6.
//  Copyright © 2021 donews. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "XDXSingleton.h"

NS_ASSUME_NONNULL_BEGIN

struct ZZCaptureAudioData {
    void        *data;
    int         size;
    UInt32      inNumberFrames;
    int64_t     pts;
};

/// 结构体指针
typedef struct ZZCaptureAudioData *ZZCaptureAudioDataRef;

@protocol ZZAudioUnitCaptureDelegate <NSObject>

@optional;
- (void)receiveAudioDataByDevice:(ZZCaptureAudioDataRef)audioDataRef;

@end

@interface ZZAudioUnitCaptureManager : NSObject
SingletonH

@property (nonatomic, weak) id<ZZAudioUnitCaptureDelegate> delegate;

/// Audio Unit 是否正在运行
@property (nonatomic, assign, readonly) BOOL isRunning;

+ (instancetype)getInstance;
- (void)startAudioCapture;
- (void)stopAudioCapture;

- (AudioStreamBasicDescription)getAudioDataFormat;

@end

NS_ASSUME_NONNULL_END
