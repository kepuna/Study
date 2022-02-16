//
//  ZZVideoEncoder.h
//  ZZKit
//
//  Created by MOMO on 2021/5/10.
//  Copyright © 2021 donews. All rights reserved.
//

#import <VideoToolbox/VideoToolbox.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, ZZVideoEncoderType) {
    ZZVideoH264Encoder = 264,
//    ZZVideoH265Encoder = 265,
};

@interface ZZVideoEncoder : NSObject

@property (nonatomic, assign) ZZVideoEncoderType encoderType;

/// 初始化
/// @param width 将要编码的视频的宽
/// @param height 将要编码的视频的高
/// @param fps 帧率
/// @param bitrate 比特率
/// @param isSupportRealTimeEncode 是否支持实时编码
/// @param encoderType 编码类型

- (instancetype)initWithWidth:(int)width
                       height:(int)height
                          fps:(int)fps
                      bitrate:(int)bitrate
    isSupportRealTimeEncode:(BOOL)isSupportRealTimeEncode
                encoderType:(ZZVideoEncoderType)encoderType;

/**
 Restart
 */
- (void)configEncoderWithWidth:(int)width
                        height:(int)height;


/**
 Start encode data
 */
- (void)startEncodeDataWithBuffer:(CMSampleBufferRef)buffer
                 isNeedFreeBuffer:(BOOL)isNeedFreeBuffer;

/**
 Force insert I frame
 */
- (void)forceInsertKeyFrame;

/**
 Free resources
 */
- (void)freeVideoEncoder;

@end

NS_ASSUME_NONNULL_END
