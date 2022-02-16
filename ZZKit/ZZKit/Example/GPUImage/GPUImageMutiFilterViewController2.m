//
//  GPUImageMutiFilterViewController2.m
//  ZZKit
//
//  Created by donews on 2019/5/8.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "GPUImageMutiFilterViewController2.h"
#import <GPUImage.h>

@interface GPUImageMutiFilterViewController2 ()

@property (nonatomic, strong) GPUImagePicture *imagePicture;
@property (nonatomic, strong) GPUImageView *gpuImageView;
@property (nonatomic, strong) UIImageView *showImageView;

@end

@implementation GPUImageMutiFilterViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.showImageView];
    
     UIImage *image = [UIImage imageNamed:@"PIC_3"];
     self.showImageView.image = [self applyPipelineFilter:image];
    
    
//    //1 初始化GPUImagePicture
//    self.imagePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
//
//    //2 初始化多种滤镜
//    //    GPUImageColorInvertFilter *invertFilter = [[GPUImageColorInvertFilter alloc] init]; //反色滤镜
//    GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc]init];  //伽马线滤镜
//    gammaFilter.gamma = 0.2;
//    GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc]init]; //曝光度滤镜
//    exposureFilter.exposure = -1.0;
//    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init]; //怀旧
//
//    // 3 初始化myGpuImageView
//    self.gpuImageView = [[GPUImageView alloc] initWithFrame:self.showImageView.bounds];
//    [self.showImageView addSubview:self.gpuImageView];
//
//    // 4 把多个滤镜对象放到数组中
//    NSMutableArray *filterArr = [NSMutableArray array];
////    [filterArr addObject:invertFilter];
//    [filterArr addObject:gammaFilter];
//    [filterArr addObject:exposureFilter];
//    [filterArr addObject:sepiaFilter];
//
//    // 5 创建GPUImageFilterPipeline对象
//    GPUImageFilterPipeline *filterPipline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:filterArr input:self.imagePicture output:self.gpuImageView];
//
//    // 6 处理图片
//    [self.imagePicture processImage];
//    [sepiaFilter useNextFrameForImageCapture];
//
//    //7 拿到处理后的图片
//    UIImage *dealedImage = [filterPipline currentFilteredFrame];
//    // 8 显示在imageView上
//    self.showImageView.image = dealedImage;
    
}

- (UIImage *)applyGroupFilter:(UIImage *)image              //实际是把filter一个个链接起来的
{
    GPUImagePicture *pic=[[GPUImagePicture alloc]initWithImage:image];
    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
    
    // 添加 filter
    /**
     原理：
     1. filterGroup(addFilter) 滤镜组添加每个滤镜
     2. 按添加顺序（可自行调整）前一个filter(addTarget) 添加后一个filter
     3. filterGroup.initialFilters = @[第一个filter]];
     4. filterGroup.terminalFilter = 最后一个filter;
     */
    GPUImageRGBFilter *filter1         = [[GPUImageRGBFilter alloc] init];
    GPUImageToonFilter *filter2        = [[GPUImageToonFilter alloc] init];
    GPUImageColorInvertFilter *filter3 = [[GPUImageColorInvertFilter alloc] init];
    GPUImageSepiaFilter       *filter4 = [[GPUImageSepiaFilter alloc] init];
    [filterGroup addFilter:filter1];
    [filterGroup addFilter:filter2];
    [filterGroup addFilter:filter3];
    [filterGroup addFilter:filter4];
    [filter1 addTarget:filter2];
    [filter2 addTarget:filter3];
    [filter3 addTarget:filter4];
    filterGroup.initialFilters=@[filter1];
    filterGroup.terminalFilter=filter4;
    [filterGroup forceProcessingAtSize:image.size];
    [pic removeAllTargets];
    [pic addTarget:filterGroup];
    [pic processImage];
    [filterGroup useNextFrameForImageCapture];
    return [filterGroup imageFromCurrentFramebuffer];
}

/*
 filterGroup的很多操作都是利用最后一个Filter实现的，例如：
 
 //GPUImageFilterGroup.m文件
 - (void)useNextFrameForImageCapture;
 {
 [self.terminalFilter useNextFrameForImageCapture];
 }
 
 - (CGImageRef)newCGImageFromCurrentlyProcessedOutput;
 {
 return [self.terminalFilter newCGImageFromCurrentlyProcessedOutput];
 }
 
 */

- (UIImage *)applyPipelineFilter:(UIImage *)image {
    
    GPUImagePicture *pic=[[GPUImagePicture alloc]initWithImage:image];
    //RGB滤镜
    GPUImageRGBFilter * RGBFilter = [[GPUImageRGBFilter alloc] init];
    //卡通滤镜
    GPUImageToonFilter * toonFilter = [[GPUImageToonFilter alloc] init];
    NSMutableArray *arrayTemp=[NSMutableArray array];
    [arrayTemp addObject:RGBFilter];
    [arrayTemp addObject:toonFilter];
    GPUImageFilterPipeline * filterPipeline = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:arrayTemp input:pic output:[[GPUImageView alloc]init]];
    [pic processImage];
    [toonFilter useNextFrameForImageCapture];//这个filter是toonFilter
    return [filterPipeline currentFilteredFrame];
}

/*
 
 Pieline内部也把Filter串连了起来：
 
 //GPUImageFilterPipeline.m文件
 - (void)_refreshFilters {
 
 id prevFilter = self.input;
 GPUImageOutput<GPUImageInput> *theFilter = nil;
 
 for (int i = 0; i < [self.filters count]; i++) {
 theFilter = [self.filters objectAtIndex:i];
 [prevFilter removeAllTargets];
 [prevFilter addTarget:theFilter];
 prevFilter = theFilter;
 }
 
 [prevFilter removeAllTargets];
 //output为显示视图，可使用GPUImageView，也可为nil
 if (self.output != nil) {
 [prevFilter addTarget:self.output];
 }
 }
 
 */

//混合滤镜原理
//模仿group与pipeline，快速实现混合滤镜：
+ (UIImage *)applyChainFilter:(UIImage *)image
{
    GPUImagePicture *pic=[[GPUImagePicture alloc]initWithImage:image];
    GPUImageRGBFilter *filter1         = [[GPUImageRGBFilter alloc] init];
    GPUImageToonFilter *filter2        = [[GPUImageToonFilter alloc] init];
    GPUImageColorInvertFilter *filter3 = [[GPUImageColorInvertFilter alloc] init];
    //串连起来
    [filter1 addTarget:filter2];
    [filter2 addTarget:filter3];
    [pic removeAllTargets];
    [pic addTarget:filter1];
    
    [filter1 forceProcessingAtSize:image.size];
    [filter2 forceProcessingAtSize:image.size];
    [filter3 forceProcessingAtSize:image.size];
    //处理得到图片
    [pic processImage];
    [filter3 useNextFrameForImageCapture];
    return [filter3 imageFromCurrentFramebuffer];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
