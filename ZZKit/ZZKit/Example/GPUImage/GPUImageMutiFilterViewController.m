//
//  GPUImageMutiFilterViewController.m
//  ZZKit
//
//  Created by donews on 2019/5/7.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "GPUImageMutiFilterViewController.h"
#import <GPUImage.h>

@interface GPUImageMutiFilterViewController ()

@property (nonatomic, strong) GPUImagePicture *imagePicture;
@property (nonatomic, strong) GPUImageFilterGroup *groupFilter; // 混合滤镜
@property (nonatomic, strong) UIImageView *showImageView;

@end

@implementation GPUImageMutiFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.showImageView];
    
    UIImage *image = [UIImage imageNamed:@"PIC_3"];
    
    //1 初始化GPUImagePicture
    self.imagePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    
    //2 初始化多种滤镜
//    GPUImageColorInvertFilter *invertFilter = [[GPUImageColorInvertFilter alloc] init]; //反色滤镜
    GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc]init];  //伽马线滤镜
    gammaFilter.gamma = 0.2;
    GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc]init]; //曝光度滤镜
    exposureFilter.exposure = -1.0;
    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init]; //怀旧
    
    //3 初始化GPUImageFilterGroup
    self.groupFilter = [[GPUImageFilterGroup alloc] init];
    // 4 将滤镜组加在GPUImagePicture上 (self.imagePicture作为响应链的源头)
    [self.imagePicture addTarget:self.groupFilter];
    
    // 5 将滤镜加在FilterGroup中
//    [self addGPUImageFilter:invertFilter];
    [self addGPUImageFilter:gammaFilter];
    [self addGPUImageFilter:exposureFilter];
    [self addGPUImageFilter:sepiaFilter];
    
    // 6 处理图片
    [self.imagePicture processImage];
    [self.groupFilter useNextFrameForImageCapture];
    
    // 7 拿到处理后的图片
    UIImage *dealedImage = [self.groupFilter imageFromCurrentFramebuffer];
    // 8 显示在imageView上
    self.showImageView.image = dealedImage;
}

#pragma mark 将滤镜加在FilterGroup中并且设置初始滤镜和末尾滤镜
- (void)addGPUImageFilter:(GPUImageFilter *)filter {
    
    
    [self.groupFilter addFilter:filter];
    
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    NSInteger count = self.groupFilter.filterCount;
    if (count == 1){
        self.groupFilter.initialFilters = @[newTerminalFilter];  //设置初始滤镜
        self.groupFilter.terminalFilter = newTerminalFilter; //设置末尾滤镜
    } else {
        GPUImageOutput<GPUImageInput> *terminalFilter = self.groupFilter.terminalFilter;
        NSArray *initialFilters = self.groupFilter.initialFilters;
        [terminalFilter addTarget:newTerminalFilter];
        
        self.groupFilter.initialFilters = @[initialFilters[0]];  //设置初始滤镜
        self.groupFilter.terminalFilter = newTerminalFilter; //设置末尾滤镜
    }
}

#pragma mark - Getters & Setters 
- (UIImageView *)showImageView {
    if (_showImageView == nil) {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.frame = self.view.bounds;
        _showImageView.contentMode =  UIViewContentModeScaleAspectFit;
    }
    return _showImageView;
}

@end
