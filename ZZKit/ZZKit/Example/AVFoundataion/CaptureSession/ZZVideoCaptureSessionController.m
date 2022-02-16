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
#import "ZZVideoEncoder.h"
#import "ZZVideoPlayerViewController.h"
#import "ZZCommonUtil.h"

@interface ZZVideoCaptureSessionController () <ZZCameraHandlerDelegate>

@property (nonatomic, strong) UIButton *startRecord;

@property (nonatomic, strong) UIButton *stopRecord;

@property (nonatomic, strong) ZZCameraHandler *cameraHandler;

@property (nonatomic, strong) ZZVideoEncoder *videoEncoder;

@property (nonatomic, assign) BOOL isNeedRecord;

@property (nonatomic, strong) UIButton *playBtn;

@end

@implementation ZZVideoCaptureSessionController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    [self configurevideoEncoder];
//    [self configureCamera];
    
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

- (void)configurevideoEncoder {
    
    self.videoEncoder = [[ZZVideoEncoder alloc] initWithWidth:1280
                                                       height:720
                                                          fps:30
                                                      bitrate:2048
                                      isSupportRealTimeEncode:NO
                                                  encoderType:ZZVideoH264Encoder];
//    self.videoEncoder.
    [self.videoEncoder configEncoderWithWidth:1280 height:720];
}

- (void)setupUI {
    [self.cameraHandler setExposureWithNewValue:0];
    
    [self.view addSubview:self.startRecord];
    [self.view addSubview:self.stopRecord];
    [self.view addSubview:self.playBtn];
}

#pragma mark - Action

- (void)s_startRecordAction {
    [self.videoEncoder forceInsertKeyFrame];
    self.isNeedRecord = YES;
}

- (void)s_stopRecordAction {
    self.isNeedRecord = NO;
}

- (void)s_playVideoAction {
    
    NSString* videoFilePath = [ZZCommonUtil bundlePath:@"V_sexlove.mp4"];
    ZZVideoPlayerViewController *vc = [ZZVideoPlayerViewController playerWithVideoPath:videoFilePath playerFrame:[UIScreen mainScreen].bounds playerStateDelegate:self parameters:nil];
    [[self navigationController] pushViewController:vc animated:YES];
}

#pragma mark - ZZCameraHandlerDelegate

- (void)zzCaptureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if ([output isKindOfClass:[AVCaptureVideoDataOutput class]]) {
        if (self.videoEncoder) {
            [self.videoEncoder startEncodeDataWithBuffer:sampleBuffer isNeedFreeBuffer:NO];
        }
    }
}

- (void)zzCaptureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
}

#pragma mark - Getters

- (UIButton *)startRecord {
    if(_startRecord == nil) {
        _startRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        _startRecord.frame = CGRectMake(50, 100, 60, 40);
        [_startRecord setTitle:@"Start" forState:UIControlStateNormal];
        _startRecord.backgroundColor = [UIColor darkTextColor];
        [_startRecord addTarget:self action:@selector(s_startRecordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startRecord;
}

- (UIButton *)stopRecord {
    if(_stopRecord == nil) {
        _stopRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopRecord.frame = CGRectMake(CGRectGetMaxX(self.startRecord.frame) + 20, 100, 60, 40);
        [_stopRecord setTitle:@"Stop" forState:UIControlStateNormal];
        _stopRecord.backgroundColor = [UIColor redColor];
        [_stopRecord addTarget:self action:@selector(s_stopRecordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopRecord;
}

- (UIButton *)playBtn {
    if(_playBtn == nil) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake(CGRectGetMaxX(self.stopRecord.frame) + 20, 100, 60, 40);
        [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
        _playBtn.backgroundColor = [UIColor darkTextColor];
        [_playBtn addTarget:self action:@selector(s_playVideoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}



@end
