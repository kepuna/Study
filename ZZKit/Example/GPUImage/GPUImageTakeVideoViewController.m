//
//  GPUImageTakeVideoViewController.m
//  ZZKit
//
//  Created by donews on 2019/4/25.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "GPUImageTakeVideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface GPUImageTakeVideoViewController ()

@property(nonatomic,strong)AVMutableComposition *mutableComposition;
@property(nonatomic,strong)AVAsset *nebual1Asset;
@property(nonatomic,strong)AVAsset *nebual3Asset;
@property(nonatomic,strong)AVAsset *backhole2Asset;
@property(nonatomic,strong)AVAsset *vidAsset;

@property(nonatomic,strong)AVMutableCompositionTrack *mutableVideoTrack;
@property(nonatomic,strong)AVMutableCompositionTrack *mutableAudioTrack;

@property(nonatomic,strong)AVAsset *compositionAsset;
@property(nonatomic,strong)AVPlayerItem *playerItem;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerLayer *playerLayer;
@property(nonatomic,strong)NSString *storePath;

@end

@implementation GPUImageTakeVideoViewController

/*
 
 生活中我们经常可能碰到这么一种需求，你有两段视频，你想将两段视频组合成一个视频，你还想为组合的这段新视频添加背景音乐，这就要用到媒体组合技术，AVMutableComposition是这个技术的一个核心的类，他继承于AVComposition类，AVComposition类又继承于AVAsset资源类。
 现在有四段视频，比如视频1，视频2，视频3，视频4，实现功能，将视频1，视频2，视频3组合一段视频，视频3要保证视频3的视频数据和音频数据保持一致，提取视频4的音频数据作为新视频的前段的背景音乐。
 
 作者：jiangamh
 链接：https://www.jianshu.com/p/c6be05ffe418
 来源：简书
 简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAssetInfo];
    [self com];
}

-(void)setAssetInfo
{
    NSURL *nebula1Url = [[NSBundle mainBundle] URLForResource:@"V_001" withExtension:@"mp4"];
    NSURL *nebula3Url = [[NSBundle mainBundle] URLForResource:@"V_002" withExtension:@"mp4"];
    NSURL *backholeUrl = [[NSBundle mainBundle] URLForResource:@"V5" withExtension:@"mp4"];
    NSURL *vidUrl = [[NSBundle mainBundle] URLForResource:@"V_sexlove" withExtension:@"mp4"];
    
    self.storePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    self.storePath = [self.storePath stringByAppendingPathComponent:@"cm.mp4"];
    
    self.nebual1Asset = [AVURLAsset URLAssetWithURL:nebula1Url options:nil];
    self.nebual3Asset = [AVURLAsset URLAssetWithURL:nebula3Url options:nil];
    self.backhole2Asset = [AVURLAsset URLAssetWithURL:backholeUrl options:nil];
    self.vidAsset = [AVURLAsset URLAssetWithURL:vidUrl options:nil];
    
    self.mutableComposition = [AVMutableComposition composition];
    
    //添加音频轨道和视频轨道
    self.mutableVideoTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    self.mutableAudioTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
}

- (void)com {
    
    CMTime startTime = kCMTimeZero;
    CMTime duration = self.nebual1Asset.duration;
    
    AVAssetTrack *video1Track = [[self.nebual1Asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    // 向视频轨道中添加媒体片段
    [self.mutableVideoTrack insertTimeRange:CMTimeRangeMake(startTime, duration) ofTrack:video1Track atTime:kCMTimeZero error:nil];
    
    AVAssetTrack *video2Track = [[self.nebual3Asset tracksWithMediaType:AVMediaTypeVideo]firstObject];
    // 向视频轨道中添加媒体片段
    [self.mutableVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.nebual3Asset.duration) ofTrack:video2Track atTime:CMTimeAdd(startTime, duration) error:nil];
    
    AVAssetTrack *vidVideoTrack = [[self.vidAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    // 向视频轨道中添加媒体片段
    [self.mutableVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.vidAsset.duration) ofTrack:vidVideoTrack atTime:CMTimeAdd(self.nebual3Asset.duration, self.nebual1Asset.duration) error:nil];
    
    AVAssetTrack *audioTrack = [[self.backhole2Asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    // 向音频轨道中添加媒体片段
    [self.mutableAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(self.nebual3Asset.duration, self.nebual1Asset.duration)) ofTrack:audioTrack atTime:kCMTimeZero error:nil];
    
    AVAssetTrack *vidAudioTrack = [[self.vidAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    // 向音频轨道中添加媒体片段
    [self.mutableAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.vidAsset.duration) ofTrack:vidAudioTrack atTime:CMTimeAdd(self.nebual1Asset.duration, self.nebual3Asset.duration) error:nil];
    
    //导出
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:self.mutableComposition presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.outputURL = [NSURL fileURLWithPath:self.storePath];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        //导出完成
        if (exportSession.status == AVAssetExportSessionStatusCompleted ) {         //横屏播放
            [self switchScreen];
            //简单播放
            [self playerCompostionVideo];
        }
    }];
}

/*
 
 横屏实现，强制横屏主要用当前的设备的setOrientation方法，当然首先需要判断是否能够响应该方法，如何可以就调用，这里使用了NSInvocation调用对象，其实NSInvocation封装了调用函数所需的所有的信息，比如那个对象发起调用－target，调用哪个方法－selector，调用的参数setArgument设置，如何有返回值也可以通过getReturn方法得到，这里需要注意的是使用setArgument设置参数时参数的索引之从2开始，其实这一点一点都不奇怪，我们要知道IMP函数指针指向的函数前两个参数就是隐藏的target，selector，所有从2开始。
 */

-(void)switchScreen
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
            
        {
            SEL selector=NSSelectorFromString(@"setOrientation:");
            
            NSInvocation *invocation =[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            
            [invocation setSelector:selector];
            
            [invocation setTarget:[UIDevice currentDevice]];
            
            int val =UIInterfaceOrientationLandscapeRight;
            
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    });
    
}

// 3 playerCompostionVideo简单的播放
-(void)playerCompostionVideo
{
    NSFileManager *fileMange = [NSFileManager defaultManager];
    if ([fileMange fileExistsAtPath:self.storePath]) {
        
        NSURL *videoUrl = [NSURL fileURLWithPath:self.storePath];
        self.compositionAsset = [AVAsset assetWithURL:videoUrl];
        self.playerItem = [[AVPlayerItem alloc] initWithAsset:self.compositionAsset];
        //kvo跟踪playerItem的status状态
        [self.playerItem addObserver:self forKeyPath:@"status" options:0 context:nil];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.playerLayer.frame = self.view.bounds;
            [self.view.layer addSublayer:self.playerLayer];
        });
    }
}


// 4 使用KVO观察AVPlayerItem的status状态，当AVPlayerItemStatusReadyToPlay处于准备播放状态时，开始播放
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem*)object;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
        //播放
        [self.player play];
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
