//
//  ZZOpenCVViewController.m
//  ZZMedia_Example
//
//  Created by MOMO on 2020/9/16.
//  Copyright © 2020 iPhoneHH. All rights reserved.
//

#import "ZZOpenCVViewController.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc/imgproc.hpp>

using namespace std;

@interface ZZOpenCVViewController ()

@end

@implementation ZZOpenCVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self openCVScaleImage];
    [self MatTest];
}


#pragma mark - Mat类
- (void)MatTest {
    // 创建一个行数(高度)为 3，列数(宽度)为 2 的图像，图像元 素是 8 位无符号整数类型，且有三个通道。图像的所有像素值被初始化为(0, 0, 255)。由于 OpenCV 中默认的颜色顺序为 BGR，因此这是一个全红色的图像。


    cv::Mat M(3, 2, CV_8UC3, cv::Scalar(0,0, 255));
    cout << "M=" << endl << "" << M << endl;
    
    M.create(3, 2, CV_8UC4);
    cout << "M = " << endl << " " << M << endl;
}


#pragma mark - OpenCV来缩放图片
/*
 介绍几个关键函数——cvResize和cvCreateImage
 
 函数功能：图像大小变换

 函数原型：

 void cvResize(

   const CvArr* src,

   CvArr* dst,

   int interpolation=CV_INTER_LINEAR

 );
 */
- (void)openCVScaleImage {
    
    UIImage *originalImage = [UIImage imageNamed:@"img1.jpeg"];
    
    cv::Mat resultImage =  [self cvMatFromUIImage:originalImage];
    
    
    
//       UIImageToMat(originalImage, resultImage);
    
    const char *pstrImageName = "images/img1.jpeg";
    const char *pstrSaveImageName = "img1_scale.jpeg";
    
    const char *pstrWindowsSrcTitle = "原图 (http://blog.csdn.net/MoreWindows)";
    const char *pstrWindowsDstTitle = "缩放图 (http://blog.csdn.net/MoreWindows)";
    
    double fScale = 0.314; // 缩放倍数
    CvSize czSize; //目标图像尺寸
    
    //从文件中读取图像
    IplImage *pSrcImage = cvLoadImage(pstrImageName, CV_LOAD_IMAGE_UNCHANGED);
    
    IplImage *pDstImage = NULL;
    
    std::cout << pSrcImage;
    
//    // 计算目标图像大小
//    czSize.width = pSrcImage->width * fScale;
//    czSize.height = pSrcImage->height * fScale;
//
//    // Create Image & Scale
//    pDstImage = cvCreateImage(czSize, pSrcImage->depth, pSrcImage->nChannels);
//    cvResize(pSrcImage, pDstImage, CV_INTER_AREA);
//
//    // Create Window
//    cvNamedWindow(pstrWindowsSrcTitle, CV_WINDOW_AUTOSIZE);
//    cvNamedWindow(pstrWindowsDstTitle, CV_WINDOW_AUTOSIZE);
//
//    // 在指定窗口中显示图像
//    cvShowImage(pstrWindowsSrcTitle, pSrcImage);
//    cvShowImage(pstrWindowsDstTitle, pDstImage);
//
//    // 等待按键事件
//    cvWaitKey();
//
//    // 保存图片
//    cvSaveImage(pstrSaveImageName, pDstImage);
//
//    cvDestroyWindow(pstrWindowsSrcTitle);
//    cvDestroyWindow(pstrWindowsDstTitle);
//    cvReleaseImage(&pSrcImage);
//    cvReleaseImage(&pDstImage);

}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image {
    // Core Graphics 框架
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    //每个组件8位，4个通道（颜色通道+ alpha）
    cv::Mat cvMat(rows, cols, CV_8UC4);
    
    // 1 pointer to data
    // 2 位图的宽度
    // 3 位图的高度
    // 4 每个组件的位数
    // 5 每行字节
    // 6 颜色空间
    // 7 位图信息标志
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data, cols, rows, 8, cvMat.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image {
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data, cols, rows, 8, cvMat.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    return cvMat;
}

// 处理之后，我们需要将Mat 转换回UIImage。 以下代码可以处理 灰度和彩色图像转换 （由if语句中的通道数确定）。
- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat {
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    // Create Data Provider
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols, cvMat.rows, 8, 8 * cvMat.elemSize(), cvMat.step[0], colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    
    // Getting UIImage for CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return finalImage;
}


#pragma mark - 采用系统自带的库进行实现图像灰度处理 - 超级繁琐
- (UIImage*)systemImageToGrayImage:(UIImage*)image{
    int width  = image.size.width;
    int height = image.size.height;
    //第一步：创建颜色空间(说白了就是开辟一块颜色内存空间)
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceGray();

    //第二步：颜色空间上下文(保存图像数据信息)
    //参数一：指向这块内存区域的地址（内存地址）
    //参数二：要开辟的内存的大小，图片宽
    //参数三：图片高
    //参数四：像素位数(颜色空间，例如：32位像素格式和RGB的颜色空间，8位）
    //参数五：图片的每一行占用的内存的比特数
    //参数六：颜色空间
    //参数七：图片是否包含A通道（ARGB四个通道）
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, 0, colorRef, kCGImageAlphaNone);
    //释放内存
    CGColorSpaceRelease(colorRef);

    if (context == nil) {
        return  nil;
    }

    //渲染图片
    //参数一：上下文对象
    //参数二：渲染区域
    //源图片
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);;

    //将绘制的颜色空间转成CGImage
    CGImageRef grayImageRef = CGBitmapContextCreateImage(context);

    //将c/c++图片转成iOS可显示的图片
    UIImage *dstImage = [UIImage imageWithCGImage:grayImageRef];

    //释放内存
    CGContextRelease(context);
    CGImageRelease(grayImageRef);

    return dstImage;
}

/// 利用OpenCV比较简单
- (UIImage*)imageToGrayImage:(UIImage*)image{

    //image源文件
    // 1.将iOS的UIImage转成c++图片（数据：矩阵）
    cv::Mat mat_image_gray;
    UIImageToMat(image, mat_image_gray);

    // 2. 将c++彩色图片转成灰度图片
    // 参数一：数据源
    // 参数二：目标数据
    // 参数三：转换类型
    cv::Mat mat_image_dst;
    
//    cvCvtColor(mat_image_gray, mat_image_dst, COLOR_BGRA2GRAY);
//    cvtColor(mat_image_gray, mat_image_dst, COLOR_BGRA2GRAY);

    // 3.灰度 -> 可显示的图片
//    cvtColor(mat_image_dst, mat_image_gray, COLOR_GRAY2BGR);

    // 4. 将c++处理之后的图片转成iOS能识别的UIImage
    return MatToUIImage(mat_image_gray);
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
