//
//  ZZDownloadOperation.h
//  ZZKit
//
//  Created by donews on 2019/7/16.
//  Copyright © 2019年 donews. All rights reserved.
//  自定义NSOperation 执行下载操作

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 
 自定义NSOperation 执行下载操作
    封装一个队列操作，创建N个线程，队列控制并发
    通过线程tag查找对应图片
    通过队列tag查找对应队列
    缓存设置 内存缓存和磁盘缓存
    下载完成通过delegate或block进行回调通知
 */

@protocol ZZDownloadOperationDelegate;


typedef void(^DownloadImageDataBlock)(NSData *data, int tag);
typedef void(^DownloadImageBlock)(UIImage *image, int tag, int queueTag);

NS_ASSUME_NONNULL_BEGIN

@interface ZZDownloadOperation : NSOperation {
    BOOL executing; // 是否执行中  默认是NO
    BOOL finished; // 是否执行完毕 默认是NO
}

//block
@property (nonatomic, copy) DownloadImageDataBlock imageDataBlock;
//标识
@property (nonatomic, assign) int tag;
//代理
@property (nonatomic, strong) id<ZZDownloadOperationDelegate> delegate;

//初始化
- (instancetype)initWithUrlStr:(NSString*)urlStr;
+ (instancetype)downloadOperationWithUrlStr:(NSString*)urlStr;

@end

NS_ASSUME_NONNULL_END


//线程操作协议
@protocol ZZDownloadOperationDelegate <NSObject>
//线程下载数据完成
- (void)downloadOperationWithData:(NSData*)data withTag:(int)tag;

@end

//下载操作协议
@protocol ZZDownloadImageDelegate <NSObject>
//图片回调
- (void)downloadImageFinishedWith:(UIImage*)image andTag:(int)tag withQueueTag:(int)queueTag;
@end
