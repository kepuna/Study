//
//  ZZRecogizeCardManager.m
//  ZZMedia_Example
//
//  Created by MOMO on 2020/9/16.
//  Copyright © 2020 iPhoneHH. All rights reserved.
// https://www.jianshu.com/p/ac4c4536ca3e

#import "ZZRecogizeCardManager.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <TesseractOCR/TesseractOCR.h>

@implementation ZZRecogizeCardManager


+ (instancetype)recognizeCardManager {
    static ZZRecogizeCardManager *recognizeCardManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recognizeCardManager = [[ZZRecogizeCardManager alloc] init];
    });
    return recognizeCardManager;
}

- (void)recognizeCardWithImage:(UIImage *)cardImage compleate:(CompleateBlock)compleate {
    //扫描身份证图片，并进行预处理，定位号码区域图片并返回
    UIImage *numberImage = [self _opencvScanCard:cardImage];
    if (numberImage == nil) {
        compleate(nil);
    }
    
    //利用TesseractOCR识别文字
    [self tesseractRecognizeImage:numberImage compleate:^(NSString *numbaerText) {
        compleate(numbaerText);
    }];
}

//扫描身份证图片，并进行预处理，定位号码区域图片并返回
- (UIImage *)_opencvScanCard:(UIImage *)image {
    // 将UIImage 转换成Mat
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);
    
    // 转换为灰度图
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    // 利用阈值二值化
    cv::threshold(resultImage, resultImage, 100, 255, CV_THRESH_BINARY);
    //腐蚀，填充（腐蚀是让黑色点变大）
    cv::Mat erodeElement = getStructuringElement(cv::MORPH_RECT, cv::Size(26,26));
    cv::erode(resultImage, resultImage, erodeElement);
    
     //轮廊检测
    //定义一个容器来存储所有检测到的轮廊
    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(resultImage, contours, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cvPoint(0, 0));
    
    //取出身份证号码区域
    std::vector<cv::Rect> rects;
    cv::Rect numberRect = cv::Rect(0,0,0,0);
    std::vector<std::vector<cv::Point>>::const_iterator itContours = contours.begin();
    for ( ; itContours != contours.end(); ++itContours) {
        cv::Rect rect = cv::boundingRect(*itContours);
        rects.push_back(rect);
        //算法原理
        if (rect.width > numberRect.width && rect.width > rect.height * 5) {
            numberRect = rect;
        }
    }
    
    //身份证号码定位失败
    if (numberRect.width == 0 || numberRect.height == 0) {
        return nil;
    }
    
    //定位成功成功，去原图截取身份证号码区域，并转换成灰度图、进行二值化处理
    cv::Mat matImage;
    UIImageToMat(image, matImage);
    resultImage = matImage(numberRect);
    
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    cv::threshold(resultImage, resultImage, 80, 255, CV_THRESH_BINARY);
    //将Mat转换成UIImage
    UIImage *numberImage = MatToUIImage(resultImage);
    return numberImage;
}

//利用TesseractOCR识别文字
- (void)tesseractRecognizeImage:(UIImage *)image compleate:(CompleateBlock)compleate {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
        tesseract.image = [image g8_blackAndWhite];
        tesseract.image = image;
        // Start the recognition
        [tesseract recognize];
        //执行回调
        compleate(tesseract.recognizedText);
        
        
//        self.tesseract = [[G8Tesseract alloc] initWithLanguage:@"chi_sim"];
//
//        tesseract.charWhitelist = @"0123456789";
//
//        self.tesseract.image = [i g8_blackAndWhite];
//
//          // Optional: Limit the area of the image Tesseract should recognize on to a rectangle
//        self.tesseract.rect = CGRectMake(0, 0, i.size.width, i.size.height);
//
//          // Optional: Limit recognition time with a few seconds
//        self.tesseract.maximumRecognitionTime = 2.0;
//
//          // Start the recognition
//        [self.tesseract recognize];
//
//          // Retrieve the recognized text
//        NSLog(@"识别:%@", [self.tesseract recognizedText]);
    });
}

@end
