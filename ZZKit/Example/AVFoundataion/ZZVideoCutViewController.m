//
//  ZZVideoCutViewController.m
//  ZZKit
//
//  Created by donews on 2019/5/5.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZVideoCutViewController.h"
//#import "AVVideoPlayerView.h"
//#import "ZZVideoTrimView.h"
#import "ZZVideoCompiler.h"
#import "ZZPublic.h"
#import "ZZShortVideoTrimView.h"
#import "ZZVideoObject.h"

@interface ZZVideoCutViewController ()<UIScrollViewDelegate,ZZVideoCompilerDelegate,ZZShortVideoTrimViewDelegate>

@property (nonatomic, strong) AVPlayerItem *avPlayerItem;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVURLAsset *videoAsset; // 视频素材
//@property (nonatomic, strong) AVVideoPlayerView *playerView; // 播放视频的view
@property (nonatomic, strong) ZZVideoCompiler *videoCompiler; // 视频编辑器
@property (nonatomic, strong) ZZShortVideoTrimView *trimView;
@property (nonatomic, strong) ZZVideoObject *videoObject; // 视频模型
@property (nonatomic, strong) NSTimer *avPlayerTimer;

@property (nonatomic, assign) CGFloat previewInterval;
@property (nonatomic, assign) CGFloat videoDuration; // 视频的总秒数

@end

@implementation ZZVideoCutViewController

- (instancetype)init {
    if (self = [super init]) {
        self.isEdit = YES;
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"AVVideoCutViewController 销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self invalidateTimer];
//    [self stopTransformImageTimer];
//    [RHCShortVideoMusicPlayer sharedPlayer].playerDelegate = nil;
//    [_videoCompiler stopRecomposeVideoFrames];
//    _videoCompiler = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    
    [self processingVideo];
    
//    self.sureBtn.userInteractionEnabled = YES;
//    if (self.avPlayerTimer) {
//        [self.avPlayerTimer setFireDate:[NSDate distantPast]];
//    }
//    [self startTransformImageTimer];
//    [self.editMusicView setMusicDelegate];
//    if (self.videoObject.musicObject) {
//        [self.editMusicView refreshBoardcastingMusic:self.videoObject];
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.playerView invalidatePlayer];
    
    
    [self pausePlay]; // 暂停播放
    
//    [self stopTransformImageTimer];
//    [self.editMusicView removeMusicDelegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self __initConfig];
    [self __setupControls];
    
    [self __initAvPlayerSetttings];

    [self getVideoPreviewPictures];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(applicationDidEnterBackground:)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:[UIApplication sharedApplication]];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(applicationDidBecomeActive:)
//                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)__initConfig {
    self.videoObject = [[ZZVideoObject alloc] init];
    self.videoAsset = [AVURLAsset assetWithURL:self.videoUrl];
    self.videoCompiler = [[ZZVideoCompiler alloc] initWithAVAsset:self.videoAsset delegate:self];
}

- (void)__initAvPlayerSetttings{
    
    if (self.avPlayerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayerItem];
    }
    
    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:_videoAsset];
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
    self.videoObject.videoStartTime = 0.;
    self.videoObject.videoEndTime = CMTimeGetSeconds(_videoAsset.duration);
    if (self.videoObject.videoEndTime > 30.0) {
        self.videoObject.videoEndTime = 30.0;
    }
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(self.videoObject.videoStartTime, _videoAsset.duration.timescale)];
    
    //playe播放的时候会一直调用
     __weak typeof(self) _self = self;
    //把时间间隔设置为， 1/ 30 秒，然后 block 里面更新 UI。就是一秒钟更新 30次UI
    //playe播放的时候会一直调用
    [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 30.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(_self) self = _self;
        [self replayWithCurrentTime:time];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayerItem];
}

- (void)replayWithCurrentTime:(CMTime)time {
    
    double currentSeconds = CMTimeGetSeconds(time);
    
    double totalSeconds = self.videoObject.videoEndTime;
//    NSLog(@"---currentSeconds=--%lf++++ %lf",currentSeconds,totalSeconds);
//    WeakSelf
//    if (self.isShowSubtitle) {
//        [self checkSubTitleWithSecond:currentSeconds];
//    }
     __weak typeof(self) weakSelf = self;
    if (currentSeconds >= totalSeconds && totalSeconds < self.videoDuration) {
        NSLog(@"------$$$$$$$$$-----播放时长 %lf",CMTimeGetSeconds(CMTimeMakeWithSeconds(self.videoObject.videoStartTime, self.videoAsset.duration.timescale)));
        [self.avPlayer seekToTime:CMTimeMakeWithSeconds(self.videoObject.videoStartTime, self.videoAsset.duration.timescale) completionHandler:
         ^(BOOL finish){
//             [weakSelf.editMusicView restartMusicWhileVideoReplay];
             [weakSelf playerStartPlay];
         }];
    }
//    else if((currentSeconds <=  totalSeconds - self.videoObject.tietuItem.tietuImageTimeLength )&&(currentSeconds >=  totalSeconds - self.videoObject.tietuItem.tietuImageTimeLength - 0.2)){
//        if (!self.selelNoBtn)
//            [self.shortVideoView showTietuViewWithObject:self.videoObject.tietuItem withDelegate:self];
//    }
}

- (void)processingVideo{
    if (!self.avPlayerItem) {
        [self performSelector:@selector(processingVideo) withObject:nil afterDelay:0.5];
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf playvideo];
    });
}

- (void)playvideo{
     [self playerStartPlay];
}

- (void)movieToEnd {
    
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(self.videoObject.videoStartTime, self.videoAsset.duration.timescale) completionHandler:
     ^(BOOL finish){
//         [self.editMusicView restartMusicWhileVideoReplay]; 音乐播放
         [self playerStartPlay];
     }];
}

- (void)playerStartPlay {
    [self.avPlayer play];
//    NSLog(@"播放秒数 = %lf,,,",CMTimeGetSeconds(self.avPlayer.currentTime));
    [self.trimView startPlayIndicateBarAnimationWithStartTime:CMTimeGetSeconds(self.avPlayer.currentTime)];
}

- (void)playerPuase {
    [self.avPlayer pause];
    [self.trimView stopPlayIndicateBarAnimation];
}

- (void)pausePlay{
    [self playerPuase];
//    [self.editMusicView enterBackgroundMusicStop];
//    if (self.avPlayerTimer) {
//        [self.avPlayerTimer setFireDate:[NSDate distantFuture]];
//    }
}

- (void)getVideoPreviewPictures {
    
    NSInteger frameNum = 0;
    //    NSInteger maxFrameNum = [self.videoTrimView imageFrameCountWithVideo:self.videoAsset]; // 原始视频的拆分后的帧数
    NSInteger maxFrameNum = [self.trimView setImagesWithVideo:self.videoAsset]; // 原始视频的拆分后的帧数
    //    _previewInterval = CMTimeGetSeconds(self.playerView.playItem.asset.duration) / maxSlotNum;
    self.previewInterval = CMTimeGetSeconds(self.avPlayerItem.asset.duration) / maxFrameNum; // 视频每一帧占的时间
    NSMutableArray *timeSlotArray = [[NSMutableArray alloc]init];
    NSUInteger currentIndex = [self.trimView getCurrentIndex];
    
    for (frameNum = 0; frameNum <= maxFrameNum - 1; frameNum++) {
        if (frameNum < currentIndex) {
            continue;
        }
        if (frameNum != maxFrameNum - 1) {
            CMTime cmTime = CMTimeMakeWithSeconds(frameNum * _previewInterval, 24);
            [timeSlotArray addObject:[NSValue valueWithCMTime:cmTime]];
        } else {
            [timeSlotArray addObject:[NSValue valueWithCMTime:self.videoAsset.duration]];
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.videoCompiler fetchKeyFramesFromVideo:timeSlotArray saveImageDirPath:self.trimView.imagePath index:(int)currentIndex];
    });
}

- (void)__setupControls {
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 50)];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(s_backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 20, 60, 50)];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(s_okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    [self.view addSubview:self.trimView];
    
}

#pragma mark - Button Action
- (void)s_backBtnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)s_okBtnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark  - 播放器视图初始化 & 读取视频帧序列
//- (void)__initPlayerWithUrl:(NSURL *)url {
//    [self __initCompilerConfig];
//    CGRect frame = CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.height - 80 - IPhoneXSefeAreaBottom(80) - 10);
//    self.playerView = [[AVVideoPlayerView alloc] initWithFrame:frame videoAsset:self.videoAsset];
//    [self.view addSubview:self.playerView];
//    __weak typeof(self) _self = self;
//    [self.playerView setStartPlayBlock:^(CGFloat currentTime) {
//        __strong typeof(_self) self = _self;
//        [self.trimView startPlayIndicateBarAnimationWithStartTime:currentTime];
//        //        [self playerStartPlay];
//    }];
//
//    [self.playerView setEndPlayBlock:^{
//        __strong typeof(_self) self = _self;
//        [self.trimView startPlayIndicateBarAnimationWithStartTime:0.0];
//        //        [self playerStartPlay];
//    }];
//}

- (void)__initCompilerConfig {
    self.videoAsset = [AVURLAsset assetWithURL:self.videoUrl];
    self.videoCompiler = [[ZZVideoCompiler alloc] initWithAVAsset:self.videoAsset delegate:self];
}

#pragma mark -- ZZVideoCompilerDelegate
- (void)fetchKeyFramesWithKeyNum:(NSInteger)num{
    __weak typeof(self) _self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(_self) self = _self;
        //        [self.trimView reloadImageAtIndex:num];
        [self.trimView reloadImageWithCount:num];
    });
}

- (void)fetchKeyFramesCompleted{
    //     __weak typeof(self) _self = self;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        __strong typeof(_self) self = _self;
    //        if (!bself.videoObject.coverImage) {
    //            bself.videoObject.coverImage = [bself.videoCompiler getVideoPreviewImage:bself.videoAsset imageSize:bself.filterPreview.size];
    //            bself.sureBtn.userInteractionEnabled = YES;
    //        }
    //    });
}


#pragma mark - ZZShortVideoTrimViewDelegate
- (void)trimControlDidChangeLeftValue:(double)leftValue rightValue:(double)rightValue {
//    NSLog(@"-----leftValue = %lf ----rightValue = %lf",leftValue,rightValue);
    
    __weak typeof(self) wSelf = self;
    NSTimeInterval seekTime = leftValue;
    [_avPlayer seekToTime:CMTimeMakeWithSeconds(seekTime, _videoAsset.duration.timescale) toleranceBefore:CMTimeMakeWithSeconds(0.01, _videoAsset.duration.timescale) toleranceAfter:CMTimeMakeWithSeconds(0.01, _videoAsset.duration.timescale) completionHandler:
     ^(BOOL finish){
         [wSelf playerStartPlay];
     }];
    if (self.videoObject.videoEndTime !=rightValue) {
        self.videoObject.videoEndTime = rightValue;
    }
    self.videoObject.videoStartTime = leftValue;
//     [self resetMusicDuration];
//    [wSelf replayWithCurrentTime:self.avPlayer.currentTime];
}


#pragma mark - Getters & Setters
//- (void)setVideoUrl:(NSURL *)videoUrl {
//    _videoUrl = videoUrl;
//    [self __initPlayerWithUrl:videoUrl];
//    if (self.isEdit) { // 可编辑
//        [self getVideoPreviewPictures];
//    }
//}

- (ZZShortVideoTrimView *)trimView {
    if (_trimView == nil) {
        self.videoDuration = CMTimeGetSeconds(self.videoAsset.duration);
        _trimView = [[ZZShortVideoTrimView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - IPhoneXSefeAreaBottom(80), SCREEN_WIDTH, IPhoneXSefeAreaBottom(80)) videoDuration:self.videoDuration];
        _trimView.delegate = self;
        [_trimView setImagesWithVideo:self.videoAsset];
    }
    return _trimView;
}


@end
