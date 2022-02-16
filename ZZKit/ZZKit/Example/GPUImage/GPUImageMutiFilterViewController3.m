//
//  GPUImageMutiFilterViewController3.m
//  ZZKit
//
//  Created by donews on 2019/5/8.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "GPUImageMutiFilterViewController3.h"
#import <GPUImage.h>

@interface GPUImageMutiFilterViewController3 ()

@property (nonatomic,strong) GPUImageVideoCamera    *videoCamera;
@property (nonatomic,strong) GPUImageView           *filterImageView;
@property (nonatomic,strong) GPUImageFilterGroup    *filterGroup;

@end

@implementation GPUImageMutiFilterViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 初始化 videoCamera
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    _videoCamera.horizontallyMirrorRearFacingCamera  = NO;
    
    // 初始化 filterGroup
    _filterGroup = [[GPUImageFilterGroup alloc] init];
    [_videoCamera addTarget:_filterGroup];
    
    GPUImageRGBFilter *filter1         = [[GPUImageRGBFilter alloc] init];
    GPUImageToonFilter *filter2        = [[GPUImageToonFilter alloc] init];
    GPUImageSepiaFilter *filter3       = [[GPUImageSepiaFilter alloc] init];
    GPUImageColorInvertFilter *filter4 = [[GPUImageColorInvertFilter alloc] init];
    [self addGPUImageFilter:filter1];
    [self addGPUImageFilter:filter2];
    [self addGPUImageFilter:filter3];
    [self addGPUImageFilter:filter4];
    
    // 初始化 imageView
    _filterImageView  = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_filterImageView];
    [_filterGroup addTarget:_filterImageView];
    
     [_videoCamera startCameraCapture];
}

#pragma mark 将滤镜加在FilterGroup中并且设置初始滤镜和末尾滤镜
- (void)addGPUImageFilter:(GPUImageFilter *)filter {

    [self.filterGroup addFilter:filter];
    
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    NSInteger count = self.filterGroup.filterCount;
    if (count == 1){
        self.filterGroup.initialFilters = @[newTerminalFilter];  //设置初始滤镜
        self.filterGroup.terminalFilter = newTerminalFilter; //设置末尾滤镜
    } else {
        GPUImageOutput<GPUImageInput> *terminalFilter = self.filterGroup.terminalFilter;
        NSArray *initialFilters = self.filterGroup.initialFilters;
        [terminalFilter addTarget:newTerminalFilter];
        
        self.filterGroup.initialFilters = @[initialFilters[0]];  //设置初始滤镜
        self.filterGroup.terminalFilter = newTerminalFilter; //设置末尾滤镜
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
