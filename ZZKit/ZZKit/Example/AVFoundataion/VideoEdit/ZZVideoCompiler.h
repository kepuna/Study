//
//  ZZVideoCompiler.h
//  ZZKit
//
//  Created by donews on 2019/4/30.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol ZZVideoCompilerDelegate <NSObject>

@optional
-(void)fetchKeyFramesCompleted;
-(void)fetchKeyFramesWithKeyNum:(NSInteger)num;
-(void)videoFrameCaptured:(CGImageRef)imageRef;

@end

@interface ZZVideoCompiler : NSObject


@property (nonatomic,weak) id <ZZVideoCompilerDelegate> delegate;
//@property (nonatomic,assign) BOOL isRecomposing;


/**
 初始化视频编辑器

 @param videoAVAsset 视频asset素材
 @param delegate 编辑器代理
 @return 视频编辑器实例
 */
- (id)initWithAVAsset:(AVURLAsset *)videoAVAsset delegate:(id)delegate;


/**
获取分解后的视频帧数据

 @param timeSlotArray 保存了NSValue的数组,数组里每一个对象都是CMTime结构体,表示你想要生成的图片在视频中的时间点
 @param dirPath 存放图片帧的文件夹路径
 @param index 当前帧的下标
 */
- (void)fetchKeyFramesFromVideo:(NSArray <NSValue *>*)timeSlotArray saveImageDirPath:(NSString*)dirPath index:(int)index;

@end

