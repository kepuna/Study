//
//  ZZCameraHandler.h
//  ZZKit
//
//  Created by MOMO on 2021/5/7.
//  Copyright © 2021 donews. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZCameraModel;

@protocol ZZCameraHandlerDelegate <NSObject>

@optional;
- (void)zzCaptureOutput:(AVCaptureOutput *)output
   didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
          fromConnection:(AVCaptureConnection *)connection;

- (void)zzCaptureOutput:(AVCaptureOutput *)output
     didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer
          fromConnection:(AVCaptureConnection *)connection;

@end

@interface ZZCameraHandler : NSObject

@property (nonatomic, assign) id<ZZCameraHandlerDelegate> delegate;

@property (nonatomic, readonly, strong) ZZCameraModel *cameraModel;

/**
 *  Please congiure camera param to use it at the first time.
 *  Then you could start / stop camera.
 */
- (void)startRunning;
- (void)stopRunning;

- (void)configureCameraWithModel:(ZZCameraModel *)model;

/**
 * Set camera exposure value (-8 ~ 8)
 */
- (void)setExposureWithNewValue:(CGFloat)newExposureValue;

@end

NS_ASSUME_NONNULL_END
