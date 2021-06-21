//
//  AVVideoCompositionController.m
//  ZZKit
//
//  Created by donews on 2019/4/26.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "AVVideoCompositionController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVPlayerViewController.h>


@interface AVVideoCompositionController ()

@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, copy) NSString *videoPath;

@property (nonatomic, strong) AVURLAsset *assetTwo;
@property (nonatomic, copy) NSString *videoPath2;
@end

@implementation AVVideoCompositionController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createAssert];
//    [self __getAssertTrack];
    
    [self demo1];
}

#pragma mark - 合成两个视频 - 无音频
- (void)demo1 {
    
    //读取资源
    NSString *videoPath1 = [[NSBundle mainBundle] pathForResource:@"V_Tianyuan" ofType:@"mp4"];
    NSString *videoPath2 = [[NSBundle mainBundle] pathForResource:@"V_sexlove" ofType:@"mp4"];
    
    BOOL isExist1 = [[NSFileManager defaultManager] fileExistsAtPath:videoPath1];
    BOOL isExist2 = [[NSFileManager defaultManager] fileExistsAtPath:videoPath2];
    if (!isExist1 || !isExist2) {
        return;
    }
    

    // 创建视频素材
//    AVURLAsset *asset1 = [AVURLAsset assetWithURL:[NSURL URLWithString:videoPath1]];
//    AVURLAsset *asset2 = [AVURLAsset assetWithURL:[NSURL URLWithString:videoPath2]];
    //    假如目录文件路径是 filePath (没有指定协议类型),调用  [AVAsset assetWithURL:[NSURL URLWithString: filePath]]; 是无法正常的加载AVAsset. 下面有详细说明
    AVURLAsset *asset1 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath1]];
    AVURLAsset *asset2 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath2]];

    AVAssetTrack *videoAssetTrack1 = [asset1 tracksWithMediaType:AVMediaTypeVideo].firstObject;
    AVAssetTrack *videoAssetTrack2 = [asset2 tracksWithMediaType:AVMediaTypeVideo].firstObject;
    
     //创建工程文件 所有操作 在这里完成
    AVMutableComposition *composition = [AVMutableComposition composition];
    // 视频轨道
    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:(AVMediaTypeVideo) preferredTrackID:(kCMPersistentTrackID_Invalid)];

    // 向视频轨道中添加媒体片段
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack1.timeRange.duration) ofTrack:videoAssetTrack1 atTime:kCMTimeZero error:nil];
     [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack2.timeRange.duration) ofTrack:videoAssetTrack2 atTime:kCMTimeZero error:nil];
    
    // 导出合成的视频
    NSArray *presetArray = [AVAssetExportSession exportPresetsCompatibleWithAsset:composition];
    if ([presetArray containsObject:AVAssetExportPresetMediumQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:composition presetName:(AVAssetExportPresetMediumQuality)];
        NSString *savePath = [self getFilePath:YES]; // 保存路径
        if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:savePath error:nil];
        }
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputURL = [NSURL fileURLWithPath:savePath];
        if (![exportSession.supportedFileTypes containsObject:AVFileTypeMPEG4]) {
             NSLog(@"不支持导出MP4格式");
            return;
        }
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:savePath]) {
                    [self play:savePath];
                }
            } else if (exportSession.status == AVAssetExportSessionStatusFailed) {
                NSLog(@"导出失败 -》 %@",exportSession.error);
            } else if (exportSession.status == AVAssetExportSessionStatusCancelled) {
                 NSLog(@"导出取消");
            } else {
                NSLog(@"导出错误");
            }
        }];
    } else {
        NSLog(@"prset不匹配");
    }
}



/*
 
 音频时长 比 音频长时  -》 视频播放消息 音频还在继续
 视频长度比音频长时
 
 */

- (void)createAssert {
    
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"V5" ofType:@"mp4"];
     NSString *videoPath2 = [[NSBundle mainBundle] pathForResource:@"V_003" ofType:@"mp4"];
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:videoPath];
    if (!isExist) {
        return;
    }
    // 创建资源
    self.asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    self.assetTwo = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath2]];
//    NSLog(@"asset.duration 资源的时长 == %f",CMTimeGetSeconds(self.asset.duration));
}

- (void)__getAssertTrack {
    
    if (!self.asset) {
        return;
    }
    
    // 获取素材的视频轨道
    AVAssetTrack *videoAssetTrack = [[self.assetTwo tracksWithMediaType:AVMediaTypeVideo]
                                      objectAtIndex:0];
    // 获取素材的音频轨道
    AVAssetTrack *audioAssetTrack = [[self.asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];

//    NSLog(@"asset.naturalSize == %@",NSStringFromCGSize(videoAssetTrack.naturalSize));
//    NSLog(@"audioAssetTrack.count == %zd",[self.asset tracksWithMediaType:AVMediaTypeAudio].count);
    
    //2.工程文件 所有操作 在这里完成
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    //工程视频轨道
    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    // 用于显示目的的可视化媒体数据的首选转换
    [videoCompositionTrack setPreferredTransform:videoAssetTrack.preferredTransform];

#warning 只有将videoAssetTrack 和 audioAssetTrack 插入到对应的 工程视频轨道、工程音频轨道才可以对视频素材、音频素材进行编辑处理
    // 将videoAssetTrack 插入到videoCompositionTrack视频轨
    
    // 这块是裁剪,rangtime .前面的是开始时间,后面是裁剪多长 (我这裁剪的是从第二秒开始裁剪，裁剪2.55秒时长.)
//    CMTime CMTimeMakeWithSeconds(
//        Float64 seconds,   //第几秒的截图,是当前视频播放到的帧数的具体时间
//        int32_t preferredTimeScale //首选的时间尺度 "每秒的帧数"
//    )
    CMTime startTime = CMTimeMakeWithSeconds(0.0f, 30);
    CMTime duration = CMTimeMakeWithSeconds(10.0f, 30);
    CMTimeRange cutRange = CMTimeRangeMake(startTime,duration);
    NSError *videoError;
    [videoCompositionTrack insertTimeRange:cutRange ofTrack:videoAssetTrack atTime:kCMTimeZero error:&videoError];
    if (videoError) {
        NSLog(@"videoError == %@",videoError);
    }
    
    //工程音频轨道
    AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    // 将audioAssetTrack插入到audioCompositionTrack音频轨
    CMTime startTime1 = CMTimeMakeWithSeconds(10.0f, 30);
    CMTime duration1 = CMTimeMakeWithSeconds(10.0f, 30);
    CMTimeRange cutRange1 = CMTimeRangeMake(startTime1,duration1);
    NSError *audioError;
    [audioCompositionTrack insertTimeRange:cutRange1 ofTrack:audioAssetTrack atTime:kCMTimeZero error:&audioError];
    if (audioError) {
        NSLog(@"audioError == %@",audioError);
    }
     NSLog(@"处理后工程的时长 == %f",CMTimeGetSeconds(composition.duration));
   
#warning 接下来就可以着手处理了
    //3.剪切视频
    //操作指令 在一个指令的时间范围内，某个轨道的状态；
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerIns = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoAssetTrack];
    [videoCompositionLayerIns setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
   
    //一个指令，决定一个timeRange内每个轨道的状态，包含多个layerInstruction；
    AVMutableVideoCompositionInstruction *videoCompositionIns = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    [videoCompositionIns setTimeRange:CMTimeRangeMake(kCMTimeZero, composition.duration)];
    videoCompositionIns.backgroundColor = [UIColor redColor].CGColor;
    videoCompositionIns.layerInstructions = @[videoCompositionLayerIns]; // 可以包含多个layerInstruction


    //操作指令集合
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.instructions = @[videoCompositionIns];
    videoComposition.renderSize = CGSizeMake(1920, 1080);
    videoComposition.renderScale = 1;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    
    //添加水印
    
    /** 水印 */
    // CGSize videoSize = CGSizeMake(videoAssetTrack.naturalSize.width, videoAssetTrack.naturalSize.height);
    //    CATextLayer *textLayer = [CATextLayer layer];
    
    //  textLayer.backgroundColor = [UIColor redColor].CGColor;
    //   textLayer.string = @"123456";
    //   textLayer.bounds = CGRectMake(0, 0, videoSize.width * 0.5, videoSize.height * 0.5);
    //添加水印 和 动画
    //   CALayer *baseLayer = [CALayer layer];
    //    [baseLayer addSublayer:textLayer];
    //    baseLayer.position = CGPointMake(videoComposition.renderSize.width/2, videoComposition.renderSize.height/2);
    
    //    CALayer *videoLayer = [CALayer layer];
    //    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    //    CALayer *parentLayer = [CALayer layer];
    //   parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    
    //    [parentLayer addSublayer:videoLayer];
    //    [parentLayer addSublayer:baseLayer];
    //    AVVideoCompositionCoreAnimationTool *animalTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    //    videoComposition.animationTool = animalTool;
    
    
    //给水印添加动画
    // CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    //    baseAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    //   baseAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    //   baseAnimation.repeatCount = 5;
    //  baseAnimation.beginTime = AVCoreAnimationBeginTimeAtZero;
    // baseAnimation.duration = 1;
    //  baseAnimation.removedOnCompletion = NO;
    //[textLayer addAnimation:baseAnimation forKey:@"hehe"];
   
     //4.输出视频
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPreset1920x1080];
    exporter.videoComposition = videoComposition;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.outputURL = [NSURL fileURLWithPath:[self getFilePath:YES] isDirectory:YES];
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        
        switch (exporter.status) {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"exporting failed %@",[exporter error]);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"export cancelled");
                break;
            case AVAssetExportSessionStatusCompleted: {
                NSLog(@"剪切成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self play:[self getFilePath:NO]];
                });
                break;
            }
            default:
                break;
        }
    }];
}


-(NSString *)getFilePath:(BOOL)isNew{
    
    NSString *url = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *str = [url stringByAppendingPathComponent:@"test.mp4"];
    
    if (isNew) unlink([str UTF8String]);
    NSLog(@"str == %@",str);
    return str;
}

-(void)play:(NSString *)url{
    
    AVAsset *assert = [AVAsset assetWithURL:[NSURL fileURLWithPath:url]];
    
    AVAssetTrack *videoAssetTrack = [assert tracksWithMediaType:AVMediaTypeVideo].firstObject;
    
    NSLog(@"assert.size == %@",NSStringFromCGSize(videoAssetTrack.naturalSize));
    
    AVAudioSession* session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    AVPlayer* player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:url]];
    AVPlayerViewController * playerController = [[AVPlayerViewController alloc] init];
    playerController.player = player;
    playerController.videoGravity = AVLayerVideoGravityResizeAspect;
    playerController.showsPlaybackControls = true;
    playerController.view.translatesAutoresizingMaskIntoConstraints = true;
    playerController.view.frame = self.view.bounds;
    [playerController.player play];
    [self presentViewController:playerController animated:YES completion:nil];
    
}

/*
在这里面要注意fileURLWithPath 和 URLWithString 两个方法的不同
 
 NSString*fileURL =@"file:///Users/username/Desktop/test.mp4";
 'NSURL*url1 = [NSURL URLWithString:fileURL];'
 NSLog(@"url1=%@",url1);
 
 NSString*filePath =@"/Users/username/Desktop/test.mp4";
 NSURL*url2 = [NSURL fileURLWithPath:filePath];
 NSLog(@"url2=%@",url1);
 
 NSURL*url3 = [NSURL URLWithString:filePath];
 NSLog(@"url3=%@",url1);
 
 打印出的结果:url1 = file:///Users/username/Desktop/test.mp4
 
 url2 = file:///Users/username/Desktop/test.mp4
 
 url3 = /Users/username/Desktop/test.mp4
 
 
 假如目录文件路径是 filePath (没有指定协议类型),调用  [AVAsset assetWithURL:[NSURL URLWithString: filePath]]; 是无法正常的加载AVAsset.
 但是  [NSURL fileURLWithPath:filePath] 会给默认给filePath 添加 file:// 协议头
 可以正常的加载资源文件.
 
 作者：蝼蚁撼树
 链接：https://www.jianshu.com/p/963d559b3323
 来源：简书
 简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
 
*/

@end
