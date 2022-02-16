//
//  ZZCameraModel.h
//  ZZKit
//
//  Created by MOMO on 2021/5/7.
//  Copyright © 2021 donews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCameraModel : NSObject

@property (nonatomic, strong) UIView *previewView;

/// 使用AVCaptureSessionPreset 指定摄像头采集的分辨率
@property (nonatomic, copy) AVCaptureSessionPreset preset;
@property (nonatomic, assign) int frameRate;
@property (nonatomic, assign) int resolutionHeight;

// OSType（也称作FourCC或ResType）通常作为一种4字节的类别标示名被使用在Mac OS里
//  -- 视频Codec和像素格式信息
@property (nonatomic, assign) OSType videoFormat;

// 手电筒
@property (nonatomic, assign) AVCaptureTorchMode torchMode;
// 对焦模式
@property (nonatomic, assign) AVCaptureFocusMode focusMode;
// 曝光模式
@property (nonatomic, assign) AVCaptureExposureMode exposureMode;
// 闪光灯
@property (nonatomic, assign) AVCaptureFlashMode flashMode;
// 白平衡
@property (nonatomic, assign) AVCaptureWhiteBalanceMode whiteBalanceMode;

// 首先要区分下屏幕方向与视频方向的概念
// 设备方向
@property (nonatomic, assign) AVCaptureDevicePosition position;
// 视频方向
@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;
// 屏幕填充方式
@property (nonatomic, copy  ) AVLayerVideoGravity videoGravity;
// 是否开启视频稳定
@property (nonatomic, assign) BOOL isEnableVideoStabilization;

- (instancetype)initWithPreviewView:(UIView *)previewView
                             preset:(AVCaptureSessionPreset)preset
                          frameRate:(int)frameRate
                   resolutionHeight:(int)resolutionHeight
                        videoFormat:(OSType)videoFormat
                          torchMode:(AVCaptureTorchMode)torchMode
                          focusMode:(AVCaptureFocusMode)focusMode
                       exposureMode:(AVCaptureExposureMode)exposureMode
                          flashMode:(AVCaptureFlashMode)flashMode
                   whiteBalanceMode:(AVCaptureWhiteBalanceMode)whiteBalanceMode
                           position:(AVCaptureDevicePosition)position
                       videoGravity:(AVLayerVideoGravity)videoGravity
                   videoOrientation:(AVCaptureVideoOrientation)videoOrientation
         isEnableVideoStabilization:(BOOL)isEnableVideoStabilization;

@end

NS_ASSUME_NONNULL_END
