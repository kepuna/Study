//
//  AVVideoPlayerView.h
//  ZZKit
//
//  Created by donews on 2019/4/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import <AVFoundation/AVPlayerItem.h>
//#import <AVFoundation/AVPlayerLayer.h>
//#import <AVFoundation/AVPlayer.h>

@interface AVVideoPlayerView : UIView

@property (nonatomic, strong) AVPlayerItem *playItem;
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, copy) void(^startPlayBlock)(CGFloat currentTime); // 开始播放
@property (nonatomic, copy) void(^endPlayBlock)(void); // 结束播放


/**
 初始化播放器视图

 @param frame AVPlayerLayer的大小
 @param videoUrl 视频的地址url
 @return 播放器视图
 */
- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl;

- (instancetype)initWithFrame:(CGRect)frame videoAsset:(AVURLAsset *)asset;


- (void)avPlayerSetttings;

/**
 释放播放器
 */
- (void)invalidatePlayer;


@end

