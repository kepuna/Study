//
//  ZZAudioQueueCaptureManager.m
//  ZZKit
//
//  Created by MOMO on 2021/4/30.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZAudioQueueCaptureManager.h"
#import <AVFoundation/AVFoundation.h>
#import "ZZAudioFileHandler.h"

// &就是获取某个对象的内存地址,使用它主要为了满足让Audio Queue的API可以将其查询到的值直接赋给这段内存地址,
// 比如下面会讲到的AudioSessionGetProperty查询方法中就是这样将查询出来的值赋值给我们定义的全局静态变量的.

#define kXDXAudioPCMFramesPerPacket 1
#define kXDXAudioPCMBitsPerChannel  16

static const int kNumberBuffers = 3;

//定义一个结构体存储音频相关属性,包括音频流格式,Audio Queue引用及Audio Queue队列中所使用的所有buffer组成的数据.
struct ZZRecorderInfo {
    AudioStreamBasicDescription mDataFormat; // 指定音频数据格式
    AudioQueueRef               mQueue;      // 应用程序创建的录制音频队列
    AudioQueueBufferRef         mBuffers[kNumberBuffers];  // 音频队列中音频数据指针的数据
};

//struct AQRecorderState {
//    AudioStreamBasicDescription mDataFormat; // 指定音频数据格式
//    AudioQueueRef               mQueue;     // 应用程序创建的录制音频队列
//    AudioQueueBufferRef         mBuffers[kNumberBuffers]; // 音频队列中音频数据指针的数据
//    AudioFileID                 mAudioFile; // 录制的文件
//    UInt32                      bufferByteSize; // 当前录制的文件大小 （单位bytes）
//    SInt64                      mCurrentPacket; // 要写入当前录制文件的音频数据包的索引
//    bool                        mIsRunning; // 当前音频队列是否正在运行
//};

// 结构体指针
typedef struct ZZRecorderInfo *ZZRecorderInfoType;

static ZZRecorderInfoType m_audioInfo;

@interface ZZAudioQueueCaptureManager ()

// 定义全局变量判断当前Audio Queue是否正在工作
@property (nonatomic, assign, readonly) BOOL isRunning;

// 当前是否正在录制
@property (nonatomic, assign) BOOL isRecordVoice;

@end

@implementation ZZAudioQueueCaptureManager
SingletonM

- (void)dealloc {
    free(m_audioInfo);
}

+ (instancetype)getInstance {
    return [[self alloc] init];
}

+ (void)initialize {
    m_audioInfo = malloc(sizeof(struct ZZRecorderInfo));
}

- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super init];
        
        // 设置如AAC这样的压缩数据格式,其原理是Audio Queue在内部帮我们做了一次转换
        [self configureAudioCaptureWithAudioInfo:m_audioInfo
                                        formatID:kAudioFormatLinearPCM // kAudioFormatLinearPCM / kAudioFormatMPEG4AAC
                                      sampleRate:44100
                                    channelCount:1
                                     durationSec:0.05 // ?
                                      bufferSize:1024
                                       isRunning:&self->_isRunning]; // &self->_isRunning
    });
    return _instace;
}

#pragma mark - Public Method

- (void)startAudioCapture {
    [self startAudioCaptureWithAudioInfo:m_audioInfo isRunning:&self->_isRunning];
}

- (void)stopAudioCapture {
    [self stopAudioQueueRecorderWithAudioInfo:m_audioInfo isRunning:&self->_isRunning];
}

- (void)startRecordFile {
    
    if (self.isRecordVoice) {
        return;
    }
    // ??? Magic Cookie
    BOOL isNeedMagicCookie = NO;
    
    if (m_audioInfo->mDataFormat.mFormatID == kAudioFormatLinearPCM) {
        isNeedMagicCookie = NO;
    } else {
        isNeedMagicCookie = YES;
    }
    [[ZZAudioFileHandler getInstance] startRecordVoiceByAudioQueue:m_audioInfo->mQueue
                                                 isNeedMagicCookie:isNeedMagicCookie
                                                         audioDesc:m_audioInfo->mDataFormat];
    
    self.isRecordVoice = YES;
    NSLog(@"❤️ Audio Recorder: Start record file.");
}

- (void)stopRecordFile {
    self.isRecordVoice = NO;
    BOOL isNeedMagicCookie = NO;
    if (m_audioInfo->mDataFormat.mFormatID == kAudioFormatLinearPCM) {
        isNeedMagicCookie = NO;
    } else {
        isNeedMagicCookie = YES;
    }
    [[ZZAudioFileHandler getInstance] stopVoiceRecordByAudioQueue:m_audioInfo->mQueue isNeedMagicCookie:isNeedMagicCookie];
    NSLog(@"Audio Recorder: Stop record file.");
}

#pragma mark - Private Method


/// 录制音频的回调函数
/// @param inUserData 自定义的数据,开发者可以传入一些我们需要的数据供回调函数使用
/// @param inAQ 调用回调函数的音频队列
/// @param inBuffer 装有音频数据的 audio queue buffer
/// @param inStartTime 当前音频数据的时间戳，主要用于同步
/// @param inNumberPacketDescriptions 数据包描述参数
/// @param inPacketDescs 音频数据中一组packet描述
static void ZZAudioQueueInputCallback (
                                    void * __nullable               inUserData,
                                    AudioQueueRef                   inAQ,
                                    AudioQueueBufferRef             inBuffer,
                                    const AudioTimeStamp *          inStartTime,
                                    UInt32                          inNumberPacketDescriptions,
                                const AudioStreamPacketDescription * __nullable inPacketDescs) {
    
    ZZAudioQueueCaptureManager *instance = (__bridge ZZAudioQueueCaptureManager *)inUserData;
    
    if (instance.isRecordVoice) {
        UInt32 bytesPerPacket = m_audioInfo->mDataFormat.mBytesPerPacket;
        if (inNumberPacketDescriptions == 0 && bytesPerPacket != 0) {
            inNumberPacketDescriptions = inBuffer->mAudioDataByteSize / bytesPerPacket;
        }
        
        // 写入文件
        [[ZZAudioFileHandler getInstance] writeFileWithInNumBytes:inBuffer->mAudioDataByteSize
                                                     ioNumPackets:inNumberPacketDescriptions
                                                         inBuffer:inBuffer->mAudioData
                                                     inPacketDesc:inPacketDescs];
    }
    
    if (instance.isRunning) {
        // ??? 参数
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    }
}

- (AudioStreamBasicDescription)getAudioFormatWithFormatID:(UInt32)formatID sampleRate:(Float64)sampleRate channelCount:(UInt32)channelCount {
    AudioStreamBasicDescription dataFormat = {0};
    
    UInt32 size = sizeof(dataFormat.mSampleRate);
    
    // Get hardware origin sample rate. (Recommended it)
    
//    Float64 hardwareSampleRate = 0;
//    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate, &size, &hardwareSampleRate);
    

    // Manual set sample rate
    dataFormat.mSampleRate = sampleRate;
    
//    size = sizeof(dataFormat.mChannelsPerFrame);
//    // Get hardware origin channels number. (Must refer to it)
//    UInt32 hardwareNumberChannels = 0;
//    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels, &size, &hardwareNumberChannels);
    
    dataFormat.mChannelsPerFrame = channelCount;
    
    // set audio format
    dataFormat.mFormatID = formatID;
    
    // set detail audio format params
    if (formatID == kAudioFormatLinearPCM) {
        // ?? 枚举的意思
        // ?? mFormatFlags ??
        dataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        dataFormat.mBitsPerChannel = kXDXAudioPCMBitsPerChannel;
        dataFormat.mBytesPerPacket = dataFormat.mBytesPerFrame = (dataFormat.mBitsPerChannel / 8) * dataFormat.mChannelsPerFrame;
        dataFormat.mFramesPerPacket = kXDXAudioPCMFramesPerPacket;
    } else if (formatID == kAudioFormatMPEG4AAC) {
        dataFormat.mFormatFlags = kMPEG4Object_AAC_Main;
    }
    
    NSLog(@"Audio Recorder: starup PCM audio encoder:%f,%d",sampleRate,channelCount);
    return dataFormat;
}

- (BOOL)startAudioCaptureWithAudioInfo:(ZZRecorderInfoType)audioInfo isRunning:(BOOL *)isRunning {
    if (*isRunning) {
        NSLog(@"Audio Recorder: Start recorder repeat");
        return NO;
    }
    
    OSStatus status = AudioQueueStart(audioInfo->mQueue, NULL);
    if (status != noErr) {
        NSLog(@"Audio Recorder: Audio Queue Start failed status:%d \n",(int)status);
        return NO;
    } else {
        NSLog(@"✅ Audio Recorder: Audio Queue Start successful");
        *isRunning = YES;
        return YES;
    }
}

- (BOOL)stopAudioQueueRecorderWithAudioInfo:(ZZRecorderInfoType)audioInfo isRunning:(BOOL *)isRunning {
    if (*isRunning == NO) {
        NSLog(@"Audio Recorder: Stop recorder repeat \n");
        return NO;
    }
    if (!audioInfo->mQueue) {
        NSLog(@"Audio Recorder: stop Audio Queue failed, the queue is nil.");
        return NO;
    }
    OSStatus stopRes = AudioQueueStop(audioInfo->mQueue, true);
    if(stopRes != noErr) {
        NSLog(@"Audio Recorder: stop Audio Queue failed.");
        return NO;
    }
    NSLog(@"Audio Recorder: stop Audio Queue success.");
    return YES;
}

- (void)configureAudioCaptureWithAudioInfo:(ZZRecorderInfoType)audioInfo
                                  formatID:(UInt32)formatID
                                sampleRate:(Float64)sampleRate
                              channelCount:(UInt32)channelCount
                               durationSec:(float)durationSec
                                bufferSize:(UInt32)bufferSize
                                 isRunning:(BOOL *)isRunning {
    
    // Get Audio format ASBD=AudioStreamBasicDescription
    audioInfo->mDataFormat = [self getAudioFormatWithFormatID:formatID sampleRate:sampleRate channelCount:channelCount];
    
    // set sample time
    NSError *error;
    [[AVAudioSession sharedInstance] setPreferredIOBufferDuration:durationSec error:&error];
    
    // New Audio Queue
    // &就是获取某个对象的内存地址,使用它主要为了满足让Audio Queue的API可以将其查询到的值直接赋给这段内存地址
    // 这里传self的目的是在 回调函数里拿到self来用
    OSStatus status = AudioQueueNewInput(&audioInfo->mDataFormat,
                                         ZZAudioQueueInputCallback,
                                         (__bridge void *)(self),
                                         NULL,
                                         kCFRunLoopCommonModes,
                                         0, &audioInfo->mQueue);
    if (status != noErr) {
        NSLog(@"❌ Audio Recorder: audio queue new input failed status:%d \n",(int)status);
    }
    
    // Set audio format for audio queue
    UInt32 size = sizeof(audioInfo->mDataFormat);
    AudioQueueGetProperty(audioInfo->mQueue, kAudioQueueProperty_StreamDescription, &audioInfo->mDataFormat, &size);
    
    if (status != noErr) {
        NSLog(@"Audio Recorder: get ASBD status:%d",(int)status);
    }
    
    // Set capture data size
    UInt32 maxBufferByteSize = 0;
    if (audioInfo->mDataFormat.mFormatID == kAudioFormatLinearPCM) {
        int frames = (int)ceil(durationSec * audioInfo->mDataFormat.mSampleRate);
        // 帧数 * 每一帧占用字节数 * 每一帧的声道数
        maxBufferByteSize =  frames * audioInfo->mDataFormat.mBytesPerFrame * audioInfo->mDataFormat.mChannelsPerFrame;
    
    } else {
        // AAC durationSec MIN: 23.219708 ms
        maxBufferByteSize = durationSec * audioInfo->mDataFormat.mSampleRate;
        if (maxBufferByteSize < 1024) {
            maxBufferByteSize = 1024;
        }
    }
    
    if (bufferSize > maxBufferByteSize || bufferSize == 0) {
        bufferSize = maxBufferByteSize;
    }
    
    // Allocate and Enqueue
    for (int i = 0; i != kNumberBuffers; i++) {
        status = AudioQueueAllocateBuffer(audioInfo->mQueue, bufferSize, &audioInfo->mBuffers[i]);
        if (status != noErr) {
            NSLog(@"Audio Recorder: Allocate buffer status:%d",(int)status);
        }
        // ??? 参数
        status = AudioQueueEnqueueBuffer(audioInfo->mQueue, audioInfo->mBuffers[i], 0, NULL);
        if (status != noErr) {
            NSLog(@"Audio Recorder: Enqueue buffer status:%d",(int)status);
        }
    }
}

@end
