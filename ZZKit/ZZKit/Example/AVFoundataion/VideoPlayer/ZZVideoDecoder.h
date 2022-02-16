//
//  ZZVideoDecoder.h
//  ZZKit
//
//  Created by MOMO on 2021/5/13.
//  Copyright © 2021 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include "libswresample/swresample.h"
#include "libavutil/pixdesc.h"


NS_ASSUME_NONNULL_BEGIN

/*
 我们会 直接使用FFmpeg开源库来负责输入模块的协议解析、封装格式拆分、 解码操作等行为
 
 首先，来看一下整体的运行流程，整个运行流程分为以下几个阶 段:
 1)建立连接、准备资源阶段。
 2)不断读取数据进行解封装、解码、处理数据阶段。
 3)释放资源阶段。
 
 以上就是输入端的整体流程，其中第二个阶段会是一个循环，并且 放在单独的线程中来运行
 */

@interface ZZVideoDecoder : NSObject

// 该接口主要负责建立与媒体资源 的连接通道，并且分配一些全局需要用到的资源，将建立连接的通道与 分配资源的结果返回到调用端。
- (BOOL)openFileWithPath:(NSString *)path paramters:(NSDictionary *)patameters error:(NSError **)error;


@end

NS_ASSUME_NONNULL_END
