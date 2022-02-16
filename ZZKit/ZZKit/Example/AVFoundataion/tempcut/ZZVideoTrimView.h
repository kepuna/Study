//
//  ZZVideoTrimView.h
//  ZZKit
//
//  Created by donews on 2019/4/29.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZVideoTrimView : UIView

@property (nonatomic, copy) NSString *imagePath; // 存放缩略图文件夹路径


/**
 初始化方法

 @param frame trimview的frame
 @param duration 视频的时长
 @return ZZVideoTrimView实例
 */
- (instancetype)initWithFrame:(CGRect)frame duration:(Float64)duration;
//- (instancetype)initWithFrame:(CGRect)frame;

//- (void)setImageCount:(NSInteger)count;

/// 获取拆分后视频帧的数量
//- (NSInteger)setImagesWithVideo:(AVURLAsset *)video;
- (NSInteger)imageFrameCountWithVideo:(AVURLAsset *)video;

/// 刷新某帧图片
- (void)reloadImageAtIndex:(NSInteger)index;
/// 获取当前某一帧的下标
- (NSUInteger)getCurrentIndex;

/// 播放视频进度条动画
- (void)startPlayIndicateBarAnimationWithStartTime:(CGFloat)startTime;

@end

NS_ASSUME_NONNULL_END
