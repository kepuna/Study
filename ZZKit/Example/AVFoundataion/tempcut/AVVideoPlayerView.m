//
//  AVVideoPlayerView.m
//  ZZKit
//
//  Created by donews on 2019/4/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "AVVideoPlayerView.h"
#import "ZZVideoObject.h"

@interface AVVideoPlayerView ()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;
//@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, strong) ZZVideoObject *videoObject; // 视频模型

@end

@implementation AVVideoPlayerView

- (void)invalidatePlayer {
    if (self.player) {
        [self.player pause];
        [self.player removeObserver:self forKeyPath:@"timeControlStatus"];
        [self.playItem removeObserver:self forKeyPath:@"status"];
    }
}

- (instancetype)initWithFrame:(CGRect)frame videoAsset:(AVURLAsset *)asset {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.asset = asset;
        [self avPlayerSetttings];
    }
    return self;
}

- (void)avPlayerSetttings {
    
    if (self.playItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playItem];
    }
    
    self.videoObject = [[ZZVideoObject alloc] init];
    self.videoObject.videoStartTime = 0.;
    self.videoObject.videoEndTime = CMTimeGetSeconds(self.asset.duration);
    self.playItem = [[AVPlayerItem alloc] initWithAsset:self.asset];
    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playItem];
    [self.player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerLayer.contentsScale = [UIScreen mainScreen].scale;
    self.playerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:self.playerLayer];
    
    [self.player seekToTime:CMTimeMakeWithSeconds(self.videoObject.videoStartTime, self.asset.duration.timescale)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playItem];
}

- (void)movieToEnd {
    
    [self.player seekToTime:CMTimeMakeWithSeconds(self.videoObject.videoStartTime, self.asset.duration.timescale) completionHandler:
     ^(BOOL finish){
         if (self.endPlayBlock) {
             self.endPlayBlock();
         }
//         [self.editMusicView restartMusicWhileVideoReplay];
//         [self playerStartPlay];
//         NSLog(@"22222222222");
     }];
}

//- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor blackColor];
//        self.videoUrl = videoUrl;
//        self.videoObject = [[ZZVideoObject alloc] init];
//        self.videoObject.videoStartTime = 0.;
//         self.videoAsset = [AVURLAsset assetWithURL:self.videoUrl];
//        self.videoObject.videoEndTime = CMTimeGetSeconds(self.videoAsset.duration);
//
//        self.playItem = [[AVPlayerItem alloc] initWithURL:videoUrl];
//        [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//
//        self.player = [AVPlayer playerWithPlayerItem:self.playItem];
//        [self.player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
//
//        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//        self.playerLayer.contentsScale = [UIScreen mainScreen].scale;
//        self.playerLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        [self.layer addSublayer:self.playerLayer];
//
//
//
//
//    }
//    return self;
//}

#pragma mark - KVO属性播放属性监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.playItem.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"KVO：未知状态，此时不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
                if (@available(iOS 10.0, *)) {
                    if (!_player.timeControlStatus || _player.timeControlStatus != AVPlayerTimeControlStatusPaused) {
                        [self.player play];
                        if (self.startPlayBlock) {
                            self.startPlayBlock(CMTimeGetSeconds(self.player.currentTime));
                        }
//                        if (!self.isEdited) {
//                            line.hidden = NO;
//                            [self startTimer];
//                        }
                    }
                } else {
                    [self.player play];
                }
                NSLog(@"KVO：准备完毕，可以播放");
                break;
            case AVPlayerStatusFailed:
                NSLog(@"KVO：加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }
    
    if ([keyPath isEqualToString:@"timeControlStatus"]) {
        // 剪切完视频后自动循环播放
        if (@available(iOS 10.0, *)) {
            if (self.player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
                [self.player seekToTime:CMTimeMake(0, 1)];
                [self.player play];
            }
        } else {
            [self.player play];
        }
    }
}


@end
