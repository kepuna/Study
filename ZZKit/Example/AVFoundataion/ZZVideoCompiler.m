//
//  ZZVideoCompiler.m
//  ZZKit
//
//  Created by donews on 2019/4/30.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZVideoCompiler.h"
#import <UIKit/UIKit.h>

@interface ZZVideoCompiler ()

@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator; // 分解视频帧的实例
@property (nonatomic, strong) AVURLAsset *videoAsset; // 视频素材
@property (nonatomic, assign) NSInteger fetchFrameCount;
@property (nonatomic, assign) NSInteger fetchedKeyFrames;

@end

@implementation ZZVideoCompiler

- (void)dealloc{
    self.delegate = nil;
    self.imageGenerator = nil;
}

- (id)initWithAVAsset:(AVURLAsset *)videoAVAsset delegate:(id)delegate{
    if (self = [super init]) {
        self.imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:videoAVAsset];
        self.imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        self.imageGenerator.appliesPreferredTrackTransform = YES;
        //防止时间出现偏差
        self.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        self.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        self.videoAsset = videoAVAsset;
        self.delegate = delegate;
//        self.isRecomposing = NO;
    }
    return self;
}


- (void)fetchKeyFramesFromVideo:(NSArray<NSValue *> *)timeSlotArray saveImageDirPath:(NSString *)dirPath index:(int)index {
    
     // maximumSize属性需要明确配置，默认情况下会保持图片的原始维度，设置该值会对图片进行缩放，提高性能。代码中设置CGSizeMake(200, 0)，确保图片遵循宽度，并根据宽高比自动设置高度
    self.imageGenerator.maximumSize = CGSizeMake(80, 80);
    self.fetchFrameCount = index;
    self.fetchedKeyFrames = index;
    
    /**
     生成一系列图片
     
     第一个参数是一个包含NSValue类型的数组,数组里每一个对象都是CMTime结构体,表示你想要生成的图片在视频中的时间点
     第二个参数是一个block,每生成一张图片都会回调这个block,这个block提供一个result的参数告诉你图片是否成功生成或者图片生成操作是否取消,在block中需要检查result，判断image是否成功生成，另外，需要持有generator直到生成图片的操作结束
     */
    __weak typeof(self) _self = self;
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:timeSlotArray completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        __strong typeof(_self) self = _self;
//        if (self.isRecomposing == NO) {
//            return;
//        }
        if (error) {
            NSLog(@"===================error:%@",error);
            self.fetchedKeyFrames += 1;
        } else {
            @autoreleasepool {
//                DDLogInfo(@"*******111********actual got image at time:%f", CMTimeGetSeconds(actualTime));
                if (image){
                    UIImage *frame = [UIImage imageWithCGImage:image];
                    if (dirPath != nil && dirPath.length) {
                        NSString *jpgPath = [NSString stringWithFormat:@"%@/IMG%ld.jpg",dirPath,(long)self.fetchFrameCount];
                        NSData *data = UIImageJPEGRepresentation(frame, 1.0);
                        [data writeToFile:jpgPath atomically:NO];
                    }
                    if (self.delegate && [self.delegate respondsToSelector:@selector(fetchKeyFramesWithKeyNum:)]) {
                        [self.delegate fetchKeyFramesWithKeyNum:self.fetchFrameCount];
                    }
                    self.fetchFrameCount += 1;
                    self.fetchedKeyFrames += 1;
//                    NSLog(@"---self.fetchFrameCount=-%zd---self.fetchedKeyFrames=%zd",self.fetchFrameCount,self.fetchedKeyFrames);
                }
//                DDLogInfo(@"================timeSlotArray.count IS %d , fetchFrameCount is %d, reslut = %d",timeSlotArray.count, self.fetchFrameCount, result);
            }
        }
        if (self.fetchedKeyFrames == timeSlotArray.count) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(fetchKeyFramesCompleted)]) {
                [self.delegate fetchKeyFramesCompleted];
            }
        }
    }];
}


@end
