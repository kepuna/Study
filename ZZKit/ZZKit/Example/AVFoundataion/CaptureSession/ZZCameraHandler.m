//
//  ZZCameraHandler.m
//  ZZKit
//
//  Created by MOMO on 2021/5/7.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZCameraHandler.h"
#import "ZZCameraModel.h"

@interface ZZCameraHandler () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) ZZCameraModel *cameraModel;

@end

@implementation ZZCameraHandler

- (void)dealloc {
    [self stopRunning];
    // Terminating app due to uncaught exception 'NSRangeException', reason: 'Cannot remove an observer <ZZCameraHandler 0x282c87280> for the key path "torchMode" from <ZZCameraHandler 0x282c87280> because it is not registered as an observer.'
//    [self removeObserver:self forKeyPath:@"torchMode"];
}

- (void)startRunning {
    [self.session startRunning];
}

- (void)stopRunning {
    [self.session stopRunning];
}

- (void)configureCameraWithModel:(ZZCameraModel *)model {
    NSError *error = nil;
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // Set resolution
    session.sessionPreset = model.preset;
    // Set position of camera (front / back )
    AVCaptureDevice *device = [self getCaptureDevicePosition:model.position];
    
    // Set frame rate and resolution
    [self setCameraFrameRateAndResolutionWithFrameRate:model.frameRate
                                      resolutionHeight:model.resolutionHeight
                                             bySession:session
                                              position:model.position
                                           videoFormat:model.videoFormat];
    
    // Set torch mode
    if ([device hasTorch]) {
        [device lockForConfiguration:&error];
        if ([device isTorchModeSupported:model.torchMode]) {
            device.torchMode = model.torchMode;
            [device addObserver:self forKeyPath:@"torchMode" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        } else {
            NSLog(@"The device not support current torch mode : %ld!",model.torchMode);
        }
        [device unlockForConfiguration];
    } else {
        NSLog(@"The device not support torch!");
    }
    
    // Set exposure mode
    if ([device isExposureModeSupported:model.exposureMode]) {
        CGPoint exposurePoint = CGPointMake(0.5f, 0.5f);
        [device setExposurePointOfInterest:exposurePoint];
        [device setExposureMode:model.exposureMode];
    } else {
        NSLog(@"The device not support current exposure mode : %ld!",model.exposureMode);
    }
    
    // Set flash mode 闪光灯
    // 自定义相机一般使用AVCaptureStillImageOutput实现。但是AVCaptureStillImageOutput在iOS 10以后已经被弃用了。所以我们使用AVCapturePhotoOutput来实现。AVCapturePhotoOutput的功能自然会更加强大，不仅支持简单的JPEG图片拍摄，还支持Live照片和RAW格式拍摄。

    if ([device hasFlash]) {
        if (@available(iOS 10.0, *)) {
            NSArray *outputs = session.outputs;
            for (AVCaptureOutput *output in outputs) {
                if ([output isMemberOfClass:AVCapturePhotoOutput.class]) {
                    AVCapturePhotoOutput *photoOutput = (AVCapturePhotoOutput *)output;
                    BOOL falshSupported = [[photoOutput supportedFlashModes] containsObject:@(model.flashMode)];
                    if (falshSupported) {
                        AVCapturePhotoSettings *photoSettings = photoOutput.photoSettingsForSceneMonitoring;
                        photoSettings.flashMode = model.flashMode;
                    }else {
                        NSLog(@"The device not support current flash mode : %ld!",model.flashMode);
                    }
                }
            }
            
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            if ([device isFlashModeSupported:model.flashMode]) {
                [device setFlashMode:model.flashMode];
            }else {
                NSLog(@"The device not support current flash mode : %ld!",model.flashMode);
            }
#pragma clang diagnostic pop
        }
        
    } else {
        NSLog(@"The device not support flash!");
    }
    
    // Set white balance mode 设置白平衡
    if ([device isWhiteBalanceModeSupported:model.whiteBalanceMode]) {
        [device setWhiteBalanceMode:model.whiteBalanceMode];
    } else {
        NSLog(@"The device not support current white balance mode : %ld!",model.whiteBalanceMode);
    }
    
    // Add input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error != noErr) {
        NSLog(@"Configure device input failed:%@",error.localizedDescription);
        return;
    }
    
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    
    // config and add output
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    AVCaptureAudioDataOutput *audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    if ([session canAddOutput:videoDataOutput]) {
        [session addOutput:videoDataOutput];
    }
    if ([session canAddOutput:audioDataOutput]) {
        [session addOutput:audioDataOutput];
    }
    
    videoDataOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:model.videoFormat] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    // ????
    videoDataOutput.alwaysDiscardsLateVideoFrames = NO;
    
    // Use serial queue to receive audio / video data
    dispatch_queue_t videoQueue = dispatch_queue_create("videoQueue", NULL);
    dispatch_queue_t audioQueue = dispatch_queue_create("audioQueue", NULL);
    
    [audioDataOutput setSampleBufferDelegate:self queue:audioQueue];
    [videoDataOutput setSampleBufferDelegate:self queue:videoQueue];
    
    // Set video Stabilization 设置视频稳定
    if (model.isEnableVideoStabilization) {
        [self adjustVideoStabilizationWithOutput:videoDataOutput];
    }
    
    // Set video preview
    CALayer *previewViewLayer = [model.previewView layer];
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    previewViewLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    videoPreviewLayer.frame = model.previewView.frame;
    videoPreviewLayer.videoGravity = model.videoGravity;
    
    if ([[videoPreviewLayer connection] isVideoOrientationSupported]) {
        [videoPreviewLayer.connection setVideoOrientation:model.videoOrientation];
    } else {
        NSLog(@"Not support video Orientation!");
    }
    
    [previewViewLayer insertSublayer:videoPreviewLayer atIndex:0];
    
    self.input = input;
    self.cameraModel = model;
    self.session = session;
    self.videoDataOutput = videoDataOutput;
    self.videoPreviewLayer = videoPreviewLayer;
}

- (void)setExposureWithNewValue:(CGFloat)newExposureValue {
    [self setExposureWithNewValue:newExposureValue device:self.input.device];
}

#pragma mark Exposure

- (void)setExposureWithNewValue:(CGFloat)newExposureValue device:(AVCaptureDevice *)device {
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        // ???
        [device setExposureTargetBias:newExposureValue completionHandler:nil];
        [device unlockForConfiguration];
    }
}

#pragma mark Video Stabilization

- (void)adjustVideoStabilizationWithOutput:(AVCaptureVideoDataOutput *)output {
    NSArray *devices = nil;
    if (@available(iOS 10.0, *)) {
        AVCaptureDeviceDiscoverySession *deviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:self.cameraModel.position];
        devices = deviceDiscoverySession.devices;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
#pragma clang diagnostic pop
    }
    
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device.activeFormat isVideoStabilizationModeSupported:AVCaptureVideoStabilizationModeAuto]) {
                // 支持视频稳定
                for (AVCaptureConnection *connection in output.connections) {
                    for (AVCaptureInputPort *port in [connection inputPorts]) {
                        if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                            if (connection.supportsVideoStabilization) {
                                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeStandard;
                            } else {
                                NSLog(@"connection don't support video stabilization");
                            }
                        }
                    }
                }
            } else {
                NSLog(@"device don't support video stablization");
            }
        }
    }
}

- (BOOL)setCameraFrameRateAndResolutionWithFrameRate:(int)frameRate
                                    resolutionHeight:(CGFloat)resolutionHeight
                                           bySession:(AVCaptureSession *)session
                                            position:(AVCaptureDevicePosition)position
                                         videoFormat:(OSType)videoFormat {
    
    AVCaptureDevice *captureDevice = [self getCaptureDevicePosition:position];
    BOOL isSuccess = NO;
    
    // AVCaptureDeviceFormat 输入设备的一些设置，可以用来修改一些设置，如ISO，慢动作，防抖等
    for (AVCaptureDeviceFormat *vFormat in captureDevice.formats) {
        CMFormatDescriptionRef videoDesc = vFormat.formatDescription;
        float maxFrameRate = [vFormat.videoSupportedFrameRateRanges objectAtIndex:0].maxFrameRate;
        // 使用CMFormatDescriptionGetMediaSubtype 函数获取 mac中的像素格式
        if (maxFrameRate >= frameRate && CMFormatDescriptionGetMediaSubType(videoDesc) == videoFormat) {
            // 使用锁配置相机属性,lockForConfiguration:,为了避免在你修改它时其他应用程序可能对它做更改.
            if ([captureDevice lockForConfiguration:NULL]) {
                // 对比镜头支持的分辨率和当前设置的分辨率
                CMVideoDimensions dims = CMVideoFormatDescriptionGetDimensions(videoDesc);
                if (dims.height == resolutionHeight && dims.width == [self getResolutionWidthByHeight:resolutionHeight]) {
                    [session beginConfiguration];
                    if ([captureDevice lockForConfiguration:NULL]) {
                        captureDevice.activeFormat = vFormat;
                        [captureDevice setActiveVideoMinFrameDuration:CMTimeMake(1, frameRate)];
                        [captureDevice setActiveVideoMaxFrameDuration:CMTimeMake(1, frameRate)];
                        [captureDevice unlockForConfiguration];
                    }
                    [captureDevice unlockForConfiguration];
                    [session commitConfiguration];
                    return YES;
                }
            } else {
                NSLog(@"%s: lock failed!",__func__);
            }
        }
    }
    NSLog(@"Set camera frame is success : %d, frame rate is %lu, resolution height = %f",isSuccess,(unsigned long)frameRate,resolutionHeight);
    return NO;
}

- (CGFloat)getResolutionWidthByHeight:(CGFloat)resolutionHeight {
    return 0;
}

- (AVCaptureDevice *)getCaptureDevicePosition:(AVCaptureDevicePosition)position {
    NSArray *devices = nil;
    if (@available(iOS 10.0, *)) {
        // AVCaptureDeviceType 种类
//        AVCaptureDeviceTypeBuiltInMicrophone //创建麦克风
//        AVCaptureDeviceTypeBuiltInWideAngleCamera //创建广角相机
//        AVCaptureDeviceTypeBuiltInTelephotoCamera //创建比广角相机更长的焦距。只有使用 AVCaptureDeviceDiscoverySession 可以使用
//        AVCaptureDeviceTypeBuiltInDualCamera //创建变焦的相机，可以实现广角和变焦的自动切换。使用同AVCaptureDeviceTypeBuiltInTelephotoCamera 一样。
//        AVCaptureDeviceTypeBuiltInDuoCamera //iOS 10.2 被 AVCaptureDeviceTypeBuiltInDualCamera 替换
        
        AVCaptureDeviceDiscoverySession *deviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
        devices =  deviceDiscoverySession.devices;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
#pragma clang diagnostic pop
    }
    
    for (AVCaptureDevice *device in devices) {
        if (position == device.position) {
            return device;
        }
    }
    return NULL;
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate & AVCaptureAudioDataOutputSampleBufferDelegate

/// 丢帧
- (void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if ([output isKindOfClass:[AVCaptureVideoDataOutput class]] == YES) {
        NSLog(@"Error: Drop video frame");
    }else {
        NSLog(@"Error: Drop audio frame");
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zzCaptureOutput:didDropSampleBuffer:fromConnection:)]) {
        [self.delegate zzCaptureOutput:output didDropSampleBuffer:sampleBuffer fromConnection:connection];
    }
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (!CMSampleBufferDataIsReady(sampleBuffer)) {
        NSLog( @"sample buffer is not ready. Skipping sample" );
        return;
    }
    
    if ([output isKindOfClass:AVCaptureVideoDataOutput.class]) {
        NSLog(@"capture: video data");
    } else if ([output isKindOfClass:AVCaptureAudioDataOutput.class]) {
        NSLog(@"capture: audio data");
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(zzCaptureOutput:didOutputSampleBuffer:fromConnection:)]) {
        [self.delegate zzCaptureOutput:output didOutputSampleBuffer:sampleBuffer fromConnection:connection];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"torchMode"]) {
        if ([change objectForKey:NSKeyValueChangeNewKey]) {
            //.....
        }
    }
}

@end
