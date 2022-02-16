//
//  ZZVideoPlayerViewController.h
//  ZZKit
//
//  Created by MOMO on 2021/5/13.
//  Copyright © 2021 donews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPlayerStateDelegate.h"

/*
 调度器，内部维护音视频同步模块、音频 输出模块、视频输出模块，为客户端代码提供开始播放、暂停、继续播 放、停止播放接口;为音频输出模块和视频输出模块提供两个获取数据 的接口。
 */
@interface ZZVideoPlayerViewController : UIViewController

@property (nonatomic, copy, readonly) NSString *videoPath;

- (instancetype)initWithVideoPath:(NSString *)path
                      playerFrame:(CGRect)frame
              playerStateDelegate:(id<ZZPlayerStateDelegate>)delegate
                       parameters:(NSDictionary *)parameters;

- (instancetype)initWithVideoPath:(NSString *)path
                      playerFrame:(CGRect)frame
              playerStateDelegate:(id<ZZPlayerStateDelegate>)delegate
                       parameters:(NSDictionary *)parameters
      outputEAGLContextShareGroup:(EAGLSharegroup *)shareGroup;

+ (instancetype)playerWithVideoPath:(NSString *)path
                      playerFrame:(CGRect)frame
              playerStateDelegate:(id<ZZPlayerStateDelegate>)delegate
                       parameters:(NSDictionary *)parameters;

+ (instancetype)playerWithVideoPath:(NSString *)path
                      playerFrame:(CGRect)frame
              playerStateDelegate:(id<ZZPlayerStateDelegate>)delegate
                       parameters:(NSDictionary *)parameters
        outputEAGLContextShareGroup:(EAGLSharegroup *)shareGroup;


@end
