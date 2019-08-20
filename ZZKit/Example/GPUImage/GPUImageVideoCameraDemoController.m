//
//  GPUImageVideoCameraDemoController.m
//  ZZKit
//
//  Created by donews on 2019/5/7.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "GPUImageVideoCameraDemoController.h"
#import <GPUImage.h>

@interface GPUImageVideoCameraDemoController ()

@property (nonatomic, strong) GPUImageView *gpuImageView;
@property (nonatomic, strong) GPUImageVideoCamera *gpuVideoCamera;

@end

@implementation GPUImageVideoCameraDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupCamera];
    
}

- (void)setupUI {
    
    self.gpuImageView = [[GPUImageView alloc] init];
    self.gpuImageView.frame = self.view.bounds;
    [self.view addSubview:self.gpuImageView];
}

/*
 GPUImageView填充模式
 
 typedef enum {
    kGPUImageFillModeStretch,
    kGPUImageFillModePreserveAspectRatio,
    kGPUImageFillModePreserveAspectRatioAndFill
 } GPUImageFillModeType;
 
 如果是kGPUImageFillModeStretch 图像拉伸，直接使宽高等于1.0即可，原图像会直接铺满整个屏幕
 如果是kGPUImageFillModePreserveAspectRatio 保持原宽高比，并且图像不超过屏幕。那么以当前屏幕大小为准
 如果是kGPUImageFillModePreserveAspectRatioAndFill 保持原宽高比，并且图像要铺满整个屏幕。那么图像大小为准
 
 */
- (void)setupCamera {
    
    self.gpuVideoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
   
    self.gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;  //GPUImageView填充模式
    
    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];//滤镜
    [self.gpuVideoCamera addTarget:filter];
    [filter addTarget:self.gpuImageView];
    
    //Start camera capturing, 里面封装的是AVFoundation的session的startRunning
    [self.gpuVideoCamera startCameraCapture];
    
    //屏幕方向的检测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - Action && Notification
- (void)orientationDidChange:(NSNotification *)noti {
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    self.gpuVideoCamera.outputImageOrientation = orientation;
    self.gpuImageView.frame = self.view.bounds;
}


@end
