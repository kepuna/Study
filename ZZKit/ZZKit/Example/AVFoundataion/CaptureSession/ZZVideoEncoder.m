//
//  ZZVideoEncoder.m
//  ZZKit
//
//  Created by MOMO on 2021/5/10.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZVideoEncoder.h"
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>
#include "log4cplus.h"


uint32_t g_capture_base_time = 0; // ???

@interface ZZVideoEncoder ()

// encoder property
@property (assign, nonatomic) BOOL isSupportEncoder;
@property (assign, nonatomic) BOOL isSupportRealTimeEncode;
@property (assign, nonatomic) BOOL needForceInsertKeyFrame;
@property (assign, nonatomic) int  width;
@property (assign, nonatomic) int  height;
@property (assign, nonatomic) int  fps;
@property (assign, nonatomic) int  bitrate;
@property (assign, nonatomic) int  errorCount;

@property (nonatomic, assign) BOOL needResetKeyParamSetBuffer;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation ZZVideoEncoder {
    VTCompressionSessionRef     mSession;
}


#pragma mark - Callback

static void ZZVideoEncoderCallBack(
        void * CM_NULLABLE outputCallbackRefCon,
        void * CM_NULLABLE sourceFrameRefCon,
        OSStatus status,
        VTEncodeInfoFlags infoFlags,
        CMSampleBufferRef sampleBuffer ) {
    
    NSLog(@"<<<<< ✅ 处理函数");
    
}


- (instancetype)initWithWidth:(int)width
                       height:(int)height
                          fps:(int)fps
                      bitrate:(int)bitrate
      isSupportRealTimeEncode:(BOOL)isSupportRealTimeEncode
                  encoderType:(ZZVideoEncoderType)encoderType {
    
    self = [super init];
    if (self) {
        mSession = NULL;
        _width = width;
        _height = height;
        _fps = fps;
        _bitrate = bitrate << 10;  //convert to bps
        _errorCount = 0;
        _isSupportEncoder = NO;
        _encoderType = encoderType;
        _lock = [[NSLock alloc] init];
        _isSupportRealTimeEncode = isSupportRealTimeEncode;
        _needResetKeyParamSetBuffer = YES;
        
        if (encoderType == ZZVideoH264Encoder) {
            _isSupportEncoder = YES;
        }

        log4cplus_info("Video Encoder:","Init encoder width:%d, height:%d, fps:%d, bitrate:%d, is support encoder:%d, encoder type:H%lu", width, height, fps, bitrate, isSupportRealTimeEncode, (unsigned long)encoderType);
    }
    return self;
}

- (void)configEncoderWithWidth:(int)width height:(int)height {
    log4cplus_info("Video Encoder:", "configure encoder with and height for init,with = %d,height = %d",width, height);
    
    if(width == 0 || height == 0) {
        log4cplus_error("Video Encoder:", "encoder param can't is null. width:%d, height:%d",width, height);
        return;
    }
    self.width = width;
    self.height = height;
    
    mSession = [self configEncoderWithEncoderType:self.encoderType width:self.width height:self.height fps:self.fps bitrate:self.bitrate isSupportRealtimeEncode:self.isSupportRealTimeEncode iFrameDuration:30 lock:self.lock callback:ZZVideoEncoderCallBack];
}

- (void)startEncodeDataWithBuffer:(CMSampleBufferRef)buffer isNeedFreeBuffer:(BOOL)isNeedFreeBuffer {
    [self startEncodeWithBuffer:buffer
                        session:mSession
               isNeedFreeBuffer:isNeedFreeBuffer
                         isDrop:NO
        needForceInsertKeyFrame:self.needForceInsertKeyFrame
                           lock:self.lock];
    if (self.needForceInsertKeyFrame) {
        self.needForceInsertKeyFrame = NO;
    }
}

- (void)forceInsertKeyFrame {
    self.needForceInsertKeyFrame = YES;
}

#pragma mark - Private Method

- (VTCompressionSessionRef)configEncoderWithEncoderType:(ZZVideoEncoderType)encoderType
                                                  width:(int)width
                                                 height:(int)height
                                                    fps:(int)fps
                                                bitrate:(int)bitrate
                                isSupportRealtimeEncode:(BOOL)isSupportRealtimeEncode
                                         iFrameDuration:(int)iFrameDuration
                                                   lock:(NSLock *)lock
                                               callback:(VTCompressionOutputCallback)callback {
    
    [lock lock];
    
    //1 Create compression session
    VTCompressionSessionRef session = [self createCompressionSessionWithEncoderType:encoderType
                                                                              width:width
                                                                             height:height
                                                                           callback:callback];
    
    //2 Set session property
    [self setCompressionSessionPropertyWithSession:session
                                               fps:fps
                                           bitrate:bitrate
                           isSupportRealtimeEncode:isSupportRealtimeEncode
                                    iFrameDuration:iFrameDuration
                                       encoderType:encoderType];
    
    //3 Prepare to encode
    OSStatus status = VTCompressionSessionPrepareToEncodeFrames(session);
    [lock unlock];
    if (status != noErr) {
        if (session) {
            [self tearDownSessionWithSession:session lock:lock];
        }
        log4cplus_error("Video Encoder:", "create encoder failed, status: %d",(int)status);
        return NULL;
    }
    log4cplus_info("Video Encoder:","create encoder success");
    return session;
}

- (VTCompressionSessionRef)createCompressionSessionWithEncoderType:(ZZVideoEncoderType)encoderType
                                                             width:(int)width
                                                            height:(int)height
                                                          callback:(VTCompressionOutputCallback)callback {
    
    CMVideoCodecType codecType;
    if (encoderType == ZZVideoH264Encoder) {
        codecType = kCMVideoCodecType_H264;
    } else {
        return nil;
    }
    
    // 创建视频编码器 session
    VTCompressionSessionRef session;
    OSStatus status = VTCompressionSessionCreate(NULL,
                                                 width,
                                                 height,
                                                 codecType,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 callback,
                                                 (__bridge void *)self,
                                                 &session);
    if (status != noErr) {
        log4cplus_error("Video Encoder:", "%s: Create session failed:%d",__func__,(int)status);
        return nil;
    }
    return session;
}

- (void)setCompressionSessionPropertyWithSession:(VTCompressionSessionRef)session
                                             fps:(int)fps
                                         bitrate:(int)bitrate
                         isSupportRealtimeEncode:(BOOL)isSupportRealtimeEncode
                                  iFrameDuration:(int)iFrameDuration
                                     encoderType:(ZZVideoEncoderType)encoderType {
    
    int maxCount = 3;
    if (!isSupportRealtimeEncode) {
        // ?? kVTCompressionPropertyKey_MaxFrameDelayCount
        if ([self isSupportPropertyWithSession:session key:kVTCompressionPropertyKey_MaxFrameDelayCount]) {
//           ?? CFTypeRef
            CFNumberRef ref = CFNumberCreate(NULL, kCFNumberNSIntegerType, &maxCount);
            [self setSessionPropertyWithSession:session key:kVTCompressionPropertyKey_MaxFrameDelayCount value:ref];
            CFRelease(ref);
        }
    }
    
    if (fps) {
        // kVTCompressionPropertyKey_ExpectedFrameRate: 期望帧率,帧率以每秒钟接收的视频帧数量来衡量.此属性无法控制帧率而仅仅作为编码器编码的指示.以便在编码前设置内部配置.
        if ([self isSupportPropertyWithSession:session key:kVTCompressionPropertyKey_ExpectedFrameRate]) {
            int value = fps;
            CFNumberRef ref = CFNumberCreate(NULL, kCFNumberSInt32Type, &value);
            [self setSessionPropertyWithSession:session key:kVTCompressionPropertyKey_ExpectedFrameRate value:ref];
            CFRelease(ref);
        }
    } else {
        log4cplus_error("Video Encoder:", "Current fps is 0");
        return;
    }
    
    if (bitrate) {
        if ([self isSupportPropertyWithSession:session key:kVTCompressionPropertyKey_AverageBitRate]) {
            int value = bitrate;
            CFNumberRef ref = CFNumberCreate(NULL, kCFNumberSInt32Type, &value);
            [self setSessionPropertyWithSession:session key:kVTCompressionPropertyKey_AverageBitRate value:ref];
            CFRelease(ref);
        }
    } else {
        log4cplus_error("Video Encoder:", "Current bitrate is 0");
        return;
    }
    
    if ([self isSupportPropertyWithSession:session key:kVTCompressionPropertyKey_RealTime]) {
//        CFBooleanRef
        [self setSessionPropertyWithSession:session key:kVTCompressionPropertyKey_RealTime value:isSupportRealtimeEncode ? kCFBooleanTrue : kCFBooleanFalse];
    }
    
    // Ban B frame
    if ([self isSupportPropertyWithSession:session key:kVTCompressionPropertyKey_AllowFrameReordering]) {
        // 用来设置是否编 B 帧，High profile 支持 B 帧，但 WebRTC 禁用了 B 帧，因为 B 帧会加大延迟。
        [self setSessionPropertyWithSession:session key:kVTCompressionPropertyKey_AllowFrameReordering value:kCFBooleanFalse];
    }
    
    // H264 的Profile 和level
    if (encoderType == ZZVideoH264Encoder) {
        if (isSupportRealtimeEncode) {
            //  指定编码比特流的配置文件和级别。可用的配置文件和级别因格式和视频编码器而异。视频编码器应该在可用的地方使用标准密钥，而不是标准模式。
            if ([self isSupportPropertyWithSession:session key:kVTCompressionPropertyKey_ProfileLevel]) {
                if (@available(iOS 11.0, *)) {
                    [self setSessionPropertyWithSession:session key:kVTCompressionPropertyKey_ProfileLevel value:kVTProfileLevel_H264_Main_AutoLevel];
                }
            }
        } else {
            if([self isSupportPropertyWithSession:session key:kVTCompressionPropertyKey_ProfileLevel]) {
                [self setSessionPropertyWithSession:session key:kVTCompressionPropertyKey_ProfileLevel value:kVTProfileLevel_H264_Baseline_AutoLevel];
            }
            
            if([self isSupportPropertyWithSession:session key:kVTCompressionPropertyKey_H264EntropyMode]) {
                [self setSessionPropertyWithSession:session key:kVTCompressionPropertyKey_H264EntropyMode value:kVTH264EntropyMode_CAVLC];
            }
        }
    }
    
    if ([self isSupportPropertyWithSession:session key:kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration]) {
        int value = iFrameDuration;
        CFNumberRef ref = CFNumberCreate(NULL, kCFNumberNSIntegerType, &value);
        [self setSessionPropertyWithSession:session key:kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration value:ref];
        CFRelease(ref);
    }
    
    log4cplus_info("Video Encoder:", "The compression session max frame delay count = %d, expected frame rate = %d, average bitrate = %d, is support realtime encode = %d, I frame duration = %d",maxCount, fps, bitrate, isSupportRealtimeEncode,iFrameDuration);
}

- (BOOL)isSupportPropertyWithSession:(VTCompressionSessionRef)session key:(CFStringRef)key {
    
    OSStatus status;
    // 注意这里定义成static的目的
    static CFDictionaryRef supportedPropertyDictionary;
    if (!supportedPropertyDictionary) {
        // 调用VTSessionCopySupportedPropertyDictionary函数可以将当前session支持的所有属性拷贝到指定的字典中,以后在设置属性前先在字典中查询是否支持即可.
        status = VTSessionCopySupportedPropertyDictionary(session, &supportedPropertyDictionary);
        if (status != noErr) {
            return NO;
        }
    }
    
    BOOL isSupport = [NSNumber numberWithBool:CFDictionaryContainsKey(supportedPropertyDictionary, key)].boolValue;
    return isSupport;
}

- (OSStatus)setSessionPropertyWithSession:(VTCompressionSessionRef)session key:(CFStringRef)key value:(CFTypeRef)value {
    // 0x0 ??
    if (value == nil || value == NULL || value == 0x0) {
        return noErr;
    }
    
    OSStatus status = VTSessionSetProperty(session, key, value);
    if (status != noErr) {
        log4cplus_error("Video Encoder:", "Set session of %s Failed, status = %d",CFStringGetCStringPtr(key, kCFStringEncodingUTF8),status);
    }
    return status;
}

- (void)startEncodeWithBuffer:(CMSampleBufferRef)sampleBuffer session:(VTCompressionSessionRef)session isNeedFreeBuffer:(BOOL)isNeedFreeBuffer isDrop:(BOOL)isDrop needForceInsertKeyFrame:(BOOL)needForceInsertKeyFrame lock:(NSLock *)lock {
    
    [lock lock];
    if (session == NULL) {
        log4cplus_error("Video Encoder:", "%s,session is empty",__func__);
        [lock unlock];
        [self handleEncodeFailedWithIsNeedFreeBuffer:isNeedFreeBuffer sampleBuffer:sampleBuffer];
        return;
    }
    
    //the first frame must be iframe then create the reference timeStamp;
    static BOOL isFirstFrame = YES;
    if (isFirstFrame && g_capture_base_time == 0) {
        // ??? CMSampleBufferGetPresentationTimeStamp
        CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        g_capture_base_time = CMTimeGetSeconds(pts); // system absolutly time(s)
        isFirstFrame = NO;
        log4cplus_error("Video Encoder:","start capture time = %u",g_capture_base_time);
    }
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CMTime presentationTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    
    // Switch different source data will show mosaic because timestamp not sync.
    static int64_t lastPts = 0;
    int64_t currentPts = (int64_t)(CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer)) * 1000);
    if (currentPts - lastPts < 0) {
        log4cplus_error("Video Encoder:","Switch different source data the timestamp < last timestamp, currentPts = %lld, lastPts = %lld, duration = %lld",currentPts, lastPts, currentPts - lastPts);
        [lock unlock];
        [self handleEncodeFailedWithIsNeedFreeBuffer:isNeedFreeBuffer sampleBuffer:sampleBuffer];
        return;
    }
    lastPts = currentPts;
    
    OSStatus status = noErr;
    NSDictionary *properties = @{
        (__bridge NSString *)kVTEncodeFrameOptionKey_ForceKeyFrame:@(needForceInsertKeyFrame)
    };
    status = VTCompressionSessionEncodeFrame(session,
                                             imageBuffer,
                                             presentationTimeStamp,
                                             kCMTimeInvalid,
                                             (__bridge CFDictionaryRef)properties,
                                             NULL,
                                             NULL);
    if (status != noErr) {
        log4cplus_error("Video Encoder:", "encode frame failed");
        [lock unlock];
        [self handleEncodeFailedWithIsNeedFreeBuffer:isNeedFreeBuffer sampleBuffer:sampleBuffer];
    }
    
    [lock unlock];
    if (isNeedFreeBuffer) {
        if (sampleBuffer != NULL) {
            CFRelease(sampleBuffer);
            log4cplus_debug("Video Encoder:", "release the sample buffer");
        }
    }
}

// isNeedFreeBuffer ???
- (void)handleEncodeFailedWithIsNeedFreeBuffer:(BOOL)isNeedFreeBuffer sampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    // if sample buffer are from system needn't to release, if sample buffer are from we create need to release.
    if (isNeedFreeBuffer) {
        if (sampleBuffer != NULL) {
            CFRelease(sampleBuffer);
            log4cplus_debug("Video Encoder:", "release the sample buffer");
        }
    }
}

- (void)tearDownSessionWithSession:(VTCompressionSessionRef)session lock:(NSLock *)lock {
    log4cplus_error("Video Encoder:","tear down session");
    [lock lock];
    if (session == NULL) {
        log4cplus_error("Video Encoder:", "%s current compression is NULL",__func__);
        [lock unlock];
        return;
    }
    VTCompressionSessionCompleteFrames(session, kCMTimeInvalid);
    VTCompressionSessionInvalidate(session);
    CFRelease(session);
    session = NULL;
    [lock unlock];
}

- (void)dealloc {
    [self tearDownSessionWithSession:mSession lock:self.lock];
}

@end
