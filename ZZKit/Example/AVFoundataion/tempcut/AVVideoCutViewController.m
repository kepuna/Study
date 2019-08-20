//
//  AVVideoCutViewController.m
//  ZZKit
//
//  Created by donews on 2019/4/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "AVVideoCutViewController.h"
#import "AVVideoPlayerView.h"
#import "ZZVideoTrimView.h"
#import "ZZVideoCompiler.h"
#import "ZZPublic.h"
#import "ZZShortVideoTrimView.h"
//#import "ZZVideoObject.h"

@interface AVVideoCutViewController ()<UIScrollViewDelegate,ZZVideoCompilerDelegate,ZZShortVideoTrimViewDelegate>

@property (nonatomic, strong) AVURLAsset *videoAsset; // 视频素材
@property (nonatomic, strong) AVVideoPlayerView *playerView; // 播放视频的view
@property (nonatomic, strong) ZZVideoCompiler *videoCompiler; // 视频编辑器
@property (nonatomic, strong) ZZShortVideoTrimView *trimView;
//@property (nonatomic, strong) ZZVideoObject *videoObject; // 视频模型

@property (nonatomic, assign) CGFloat previewInterval;

@end

@implementation AVVideoCutViewController

- (instancetype)init {
    if (self = [super init]) {
        self.isEdit = YES;
//        self.videoObject = [[ZZVideoObject alloc] init];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"AVVideoCutViewController 销毁");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playerView invalidatePlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupControls];
}

- (void)getVideoPreviewPictures {
    
    NSInteger frameNum = 0;
//    NSInteger maxFrameNum = [self.videoTrimView imageFrameCountWithVideo:self.videoAsset]; // 原始视频的拆分后的帧数
     NSInteger maxFrameNum = [self.trimView setImagesWithVideo:self.videoAsset]; // 原始视频的拆分后的帧数
//    _previewInterval = CMTimeGetSeconds(self.playerView.playItem.asset.duration) / maxSlotNum;
    self.previewInterval = CMTimeGetSeconds(self.videoAsset.duration) / maxFrameNum; // 视频每一帧占的时间
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

- (void)setupControls {
    
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
    [self.trimView setImagesWithVideo:self.videoAsset];
    
}

#pragma mark - Button Action
- (void)s_backBtnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)s_okBtnAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark  - 播放器视图初始化 & 读取视频帧序列
- (void)__initPlayerWithUrl:(NSURL *)url {
    [self __initCompilerConfig];
    CGRect frame = CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.height - 80 - IPhoneXSefeAreaBottom(80) - 10);
    self.playerView = [[AVVideoPlayerView alloc] initWithFrame:frame videoAsset:self.videoAsset];
    [self.view addSubview:self.playerView];
     __weak typeof(self) _self = self;
    [self.playerView setStartPlayBlock:^(CGFloat currentTime) {
        __strong typeof(_self) self = _self;
        [self.trimView startPlayIndicateBarAnimationWithStartTime:currentTime];
//        [self playerStartPlay];
    }];
    
    [self.playerView setEndPlayBlock:^{
        __strong typeof(_self) self = _self;
        [self.trimView startPlayIndicateBarAnimationWithStartTime:0.0];
//        [self playerStartPlay];
    }];
}

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

- (void)playerStartPlay {
    [self.playerView.player play];
    [self.trimView startPlayIndicateBarAnimationWithStartTime:CMTimeGetSeconds(self.playerView.player.currentTime)];
}

#pragma mark - ZZShortVideoTrimViewDelegate
- (void)trimControlDidChangeLeftValue:(double)leftValue rightValue:(double)rightValue {
     NSLog(@"-----self.rightValue = %lf ----startTime = %lf",leftValue,rightValue);
    
    __weak typeof(self) _self = self;
    NSTimeInterval seekTime = leftValue;
    
    [self.playerView.player  seekToTime:CMTimeMakeWithSeconds(seekTime, self.videoAsset.duration.timescale) toleranceBefore:CMTimeMakeWithSeconds(0.01, self.videoAsset.duration.timescale) toleranceAfter:CMTimeMakeWithSeconds(0.01, self.videoAsset.duration.timescale) completionHandler:
     ^(BOOL finish){
         __strong typeof(_self) self = _self;
//         [self playerStartPlay];
          [self.trimView startPlayIndicateBarAnimationWithStartTime:CMTimeGetSeconds(self.playerView.player.currentTime)];
     }];
}


#pragma mark - Getters & Setters
- (void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    [self __initPlayerWithUrl:videoUrl];
    if (self.isEdit) { // 可编辑
        [self getVideoPreviewPictures];
    }
}

- (ZZShortVideoTrimView *)trimView {
    if (_trimView == nil) {
        Float64 duration = CMTimeGetSeconds(self.videoAsset.duration);
        _trimView = [[ZZShortVideoTrimView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - IPhoneXSefeAreaBottom(80), SCREEN_WIDTH, IPhoneXSefeAreaBottom(80)) videoDuration:duration];
        _trimView.delegate = self;
    }
    return _trimView;
}


@end
