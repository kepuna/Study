//
//  ZZVideoCaptureSessionController.m
//  ZZKit
//
//  Created by MOMO on 2021/5/7.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZVideoCaptureSessionController.h"
#import "ZZCameraModel.h"
#import "ZZCameraHandler.h"

@interface ZZVideoCaptureSessionController () <ZZCameraHandlerDelegate>

@property (nonatomic, strong) ZZCameraHandler *cameraHandler;

@end

@implementation ZZVideoCaptureSessionController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self configureCamera];
    
    [self setupUI];
}

- (void)configureCamera {
    
    ZZCameraModel *model = [[ZZCameraModel alloc] initWithPreviewView:self.view
                                                               preset:AVCaptureSessionPreset1280x720
                                                            frameRate:30
                                                     resolutionHeight:720
                                                          videoFormat:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
                                                            torchMode:AVCaptureTorchModeOff
                                                            focusMode:AVCaptureFocusModeLocked
                                                         exposureMode:AVCaptureExposureModeContinuousAutoExposure
                                                            flashMode:AVCaptureFlashModeAuto
                                                     whiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance
                                                             position:AVCaptureDevicePositionBack
                                                         videoGravity:AVLayerVideoGravityResizeAspect
                                                     videoOrientation:AVCaptureVideoOrientationLandscapeRight
                                           isEnableVideoStabilization:YES];
    
    ZZCameraHandler *handler = [[ZZCameraHandler alloc] init];
    self.cameraHandler = handler;
    handler.delegate = self;
    [handler configureCameraWithModel:model];
    [handler startRunning];
    
    
}

- (void)setupUI {
    
    [self.cameraHandler setExposureWithNewValue:0];
}

@end
