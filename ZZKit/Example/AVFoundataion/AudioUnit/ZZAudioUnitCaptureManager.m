//
//  ZZAudioUnitCaptureManager.m
//  ZZKit
//
//  Created by MOMO on 2021/5/6.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZAudioUnitCaptureManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

const static NSString *kModuleName = @"XDXAudioUnitCapture";

static AudioUnit                    m_audioUnit;
static AudioBufferList              *m_BufferList;
static AudioStreamBasicDescription  m_audioDataFormat;

#define kXDXAudioPCMFramesPerPacket 1
#define KXDXAudioBitsPerChannel 16

#define INPUT_BUS  1      ///< A I/O unit's bus 1 connects to input hardware (microphone).
#define OUTPUT_BUS 0      ///< A I/O unit's bus 0 connects to output hardware (speaker).

@interface ZZAudioUnitCaptureManager ()

@property (nonatomic, assign, readwrite) BOOL isRunning;

@end

@implementation ZZAudioUnitCaptureManager
SingletonM

 static OSStatus AudioCaptureCallback(void *             inRefCon,
                         AudioUnitRenderActionFlags *    ioActionFlags,
                         const AudioTimeStamp *            inTimeStamp,
                         UInt32                            inBusNumber,
                         UInt32                            inNumberFrames,
                         AudioBufferList * __nullable    ioData) {
     return 0;
 }

- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super init];
        
        // Note: audioBufferSize conlud not more than durationSec max size.
        [_instace configureAudioInfoWithDataFormat:&m_audioDataFormat
                                          formatID:kAudioFormatLinearPCM
                                        sampleRate:44100
                                      channelCount:1
                                   audioBufferSize:2048
                                       durationSec:0.02 callBack:AudioCaptureCallback];
    });
    return _instace;
}

#pragma mark - Public

+ (instancetype)getInstance {
    return [[self alloc] init];
}

- (void)startAudioCapture {
    [self startAudioCaptureWithAudioUnit:m_audioUnit isRunning:&_isRunning];
}

- (void)stopAudioCapture {
    [self stopAudioCaptureWithAudioUnit:m_audioUnit isRunning:&_isRunning];
}

- (AudioStreamBasicDescription)getAudioDataFormat {
    return m_audioDataFormat;
}

#pragma mark - Private

- (void)startAudioCaptureWithAudioUnit:(AudioUnit)audioUnit isRunning:(BOOL *)isRunning {
    OSStatus status;
    if (*isRunning) {
        NSLog(@"%@:  %s - start recorder repeat \n",kModuleName,__func__);
        return;
    }
    status = AudioOutputUnitStart(audioUnit);
    if (status == noErr) {
        *isRunning = YES;
        NSLog(@"%@:  %s - start audio unit success \n",kModuleName,__func__);
    } else {
        *isRunning  = NO;
        NSLog(@"%@:  %s - start audio unit failed \n",kModuleName,__func__);
    }
}

- (void)stopAudioCaptureWithAudioUnit:(AudioUnit)audioUnit isRunning:(BOOL *)isRunning {
    if (*isRunning == NO) {
        return;
    }
    *isRunning = NO;
    if (audioUnit != NULL) {
        OSStatus status = AudioOutputUnitStop(audioUnit);
        if (status != noErr){
            NSLog(@"%@:  %s - stop audio unit failed. \n",kModuleName,__func__);
        }else {
            NSLog(@"%@:  %s - stop audio unit successful",kModuleName,__func__);
        }
    }
}

- (void)configureAudioInfoWithDataFormat:(AudioStreamBasicDescription *)dataFormat
                                formatID:(UInt32)formatID
                              sampleRate:(Float64)sampleRate
                            channelCount:(UInt32)channelCount
                         audioBufferSize:(int)audioBufferSize
                             durationSec:(float)durationSec
                                callBack:(AURenderCallback)callBack {
    
    // Configure ASBD
    [self configureAudioToAudioFormat:dataFormat byParamFormatID:formatID sampleRate:sampleRate channelCount:channelCount];
    
    // Set sample time
    [[AVAudioSession sharedInstance] setPreferredIOBufferDuration:durationSec error:NULL];
    
    // Configure Audio Unit
    m_audioUnit = [self configureAudioToAudioFormat:*dataFormat audioBufferSize:audioBufferSize callBack:callBack];
    
    
}

/// 配置Audio Unit
- (AudioUnit)configureAudioToAudioFormat:(AudioStreamBasicDescription)dataFormat audioBufferSize:(int)audioBufferSize callBack:(AURenderCallback)callBack {
    
    // 创建一个 Audio Unit 对象
    AudioUnit audioUnit = [self createAudioUnitObject];
    if (!audioUnit) {
        return NULL;
    }
    
    // 创建一个接收采集到音频数据的数据结构
    [self initCaptureAudioBufferWithAudioUnit:audioUnit channelCount:dataFormat.mChannelsPerFrame dataByteSize:audioBufferSize];
    
    // 设置audio unit属性
    [self setAudioUnitPropertyWithAudioUnit:audioUnit dataFormat:dataFormat];
    
    // 注册回调函数接收音频数据
    [self inputCaptureCallBackWithAudioUnit:audioUnit callBack:callBack];
    
    OSStatus status = AudioUnitInitialize(audioUnit);
    if (status != noErr) {
        NSLog(@"%@:  %s - couldn't init audio unit instance, status : %d \n",kModuleName,__func__,(int)status);
    }
    return audioUnit;
}

- (void)inputCaptureCallBackWithAudioUnit:(AudioUnit)audioUnit callBack:(AURenderCallback)callBack {
    
    AURenderCallbackStruct captureCallback;
    captureCallback.inputProc = callBack;
    captureCallback.inputProcRefCon = (__bridge  void *)self;
    OSStatus status = AudioUnitSetProperty(audioUnit, kAudioOutputUnitProperty_SetInputCallback, kAudioUnitScope_Global, INPUT_BUS, &captureCallback, sizeof(captureCallback));
    if (status != noErr) {
        NSLog(@"%@:  %s - Audio Unit set capture callback failed, status : %d \n",kModuleName, __func__,(int)status);
    }
}

- (void)setAudioUnitPropertyWithAudioUnit:(AudioUnit)audioUnit dataFormat:(AudioStreamBasicDescription)dataFormat {
    
    // kAudioUnitProperty_StreamFormat: 通过先前创建的ASBD设置音频数据流的格式
    // kAudioOutputUnitProperty_EnableIO: 启用/禁用 对于 输入端/输出端
    
    OSStatus status;
    status = AudioUnitSetProperty(audioUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, INPUT_BUS, &dataFormat, sizeof(dataFormat));
    
    if (status != noErr) {
        NSLog(@"%@:  %s - set audio unit stream format failed, status : %d \n",kModuleName, __func__,(int)status);
    }
    
    // 打开输入端
    UInt32 enableFlag = 1;
    status = AudioUnitSetProperty(audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, INPUT_BUS, &enableFlag, sizeof(enableFlag));
    
    if (status != noErr) {
        NSLog(@"%@:  %s - could not enable input on AURemoteIO, status : %d \n",kModuleName, __func__, (int)status);
    }
    // 禁止输出端
    UInt32 disableFlag = 0;
    status = AudioUnitSetProperty(audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, OUTPUT_BUS, &disableFlag, sizeof(disableFlag));
    if (status != noErr) {
        NSLog(@"%@:  %s - could not enable output on AURemoteIO, status : %d \n",kModuleName, __func__,(int)status);
    }
}

- (void)initCaptureAudioBufferWithAudioUnit:(AudioUnit)audioUnit
                               channelCount:(int)channelCount
                               dataByteSize:(int)dataByteSize {
    
    // Disable AU buffer allocation for the recorder, we allocate our own
    UInt32 flag = 0;
    OSStatus status = AudioUnitSetProperty(audioUnit,
                                           kAudioUnitProperty_ShouldAllocateBuffer,
                                           kAudioUnitScope_Output,
                                           INPUT_BUS,
                                           &flag,
                                           sizeof(flag));
    
    if (status != noErr) {
        NSLog(@"%@:  %s - couldn't allocate buffer of callback, status : %d \n", kModuleName, __func__, (int)status);
    }
    
    AudioBufferList *bufferList = (AudioBufferList *)malloc(sizeof(AudioBufferList));
    bufferList->mNumberBuffers = 1;
    bufferList->mBuffers[0].mNumberChannels = channelCount;
    bufferList->mBuffers[0].mDataByteSize = dataByteSize;
    bufferList->mBuffers[0].mData = (UInt32 *)malloc(dataByteSize);
    
    m_BufferList = bufferList;
}

- (AudioUnit)createAudioUnitObject {
    AudioUnit audioUnit;
    // ????
    AudioComponentDescription audioDesc;
    audioDesc.componentType = kAudioUnitType_Output;
    audioDesc.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
    audioDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    audioDesc.componentFlags = 0;
    audioDesc.componentFlagsMask = 0;
    
    // ????
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &audioDesc);
    OSStatus status = AudioComponentInstanceNew(inputComponent, &audioUnit);
    if (status != noErr) {
        NSLog(@"%@:  %s - create audio unit failed, status : %d \n",kModuleName, __func__, (int)status);
        return NULL;
    }
    return audioUnit;
}

// ASBD  Audio Format
- (void)configureAudioToAudioFormat:(AudioStreamBasicDescription *)audioFormat byParamFormatID:(UInt32)formatID sampleRate:(Float64)sampleRate channelCount:(UInt32)channelCount {
    
    AudioStreamBasicDescription dataFormat = {0};
    UInt32 size = sizeof(dataFormat.mSampleRate);
    
    // Get hardwart origin sample rate. (Recommended it)
    Float64 hardwareSampleRate = 0;
    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate, &size, &hardwareSampleRate);
    dataFormat.mSampleRate = sampleRate;
    
    size = sizeof(dataFormat.mChannelsPerFrame);
    UInt32 hardwareNumberChannels = 0;
    AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels, &size, &hardwareNumberChannels);
    dataFormat.mChannelsPerFrame = channelCount;
    dataFormat.mFormatID = formatID;
    
    if (formatID == kAudioFormatLinearPCM) {
        dataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger  | kLinearPCMFormatFlagIsPacked;
        dataFormat.mBitsPerChannel = KXDXAudioBitsPerChannel;
        dataFormat.mBytesPerPacket = dataFormat.mBytesPerFrame = (dataFormat.mBitsPerChannel / 8) * dataFormat.mChannelsPerFrame;
        dataFormat.mFramesPerPacket = kXDXAudioPCMFramesPerPacket;
    }
    memcpy(audioFormat, &dataFormat, sizeof(dataFormat));
    
//    NSLog(@"%@:  %s - sample rate:%f, channel count:%d",kModuleName, __func__,sampleRate,channelCount);
}

@end
