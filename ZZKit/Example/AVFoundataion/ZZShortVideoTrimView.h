//
//  ZZShortVideoTrimView.h
//  ZZKit
//
//  Created by donews on 2019/5/5.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ZZShortVideoTrimViewDelegate <NSObject>

/// 拖拽左右滑条时的回调
- (void)trimControlDidChangeLeftValue:(double)leftValue rightValue:(double)rightValue;

@end

@interface ZZShortVideoTrimView : UIView

@property(nonatomic, assign) float leftValue;
@property(nonatomic, assign) float rightValue;
@property (nonatomic, strong) UIImageView   *maskImageView;
@property(nonatomic, weak) id<ZZShortVideoTrimViewDelegate> delegate;


@property(nonatomic, strong) NSString *imagePath;

/// 初始化方法
- (id)initWithFrame:(CGRect)frame videoDuration:(float)duration;
- (void)reloadImageWithCount:(NSInteger)count;
- (NSUInteger)getCurrentIndex;

- (void)setImageCount:(NSInteger)count;
- (NSInteger)setImagesWithVideo:(AVAsset *)video;
- (void)startPlayIndicateBarAnimationWithStartTime:(CGFloat)startTime;
- (void)stopPlayIndicateBarAnimation;

@end

