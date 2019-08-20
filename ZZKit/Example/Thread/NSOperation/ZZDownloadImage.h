//
//  ZZDownloadImage.h
//  ZZKit
//
//  Created by donews on 2019/7/16.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZDownloadOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZDownloadImage : NSObject

//下载完图片的代理
@property (nonatomic,strong)id<ZZDownloadImageDelegate> delegate;
//标识 (队列的标识tag)
@property (nonatomic,assign)int tag;

//加载图片完成
@property (nonatomic, copy) DownloadImageBlock downloadFinishedBlock;
//加载单张时使用
@property (nonatomic,copy)NSString *urlStr;
//加载多张时使用
@property (nonatomic,strong)NSArray *urlArray;
//队列线程最大并发数
@property (nonatomic,assign)int  maxOperationCount;


//磁盘缓存 内存缓存 单位：M
@property (nonatomic,assign)NSUInteger diskCapacity;
@property (nonatomic,assign)NSUInteger MemoryCapacity;

//初始化传url数组
- (instancetype)initWithUrlStrArray:(NSArray<NSString*>*)urlArray withStartTag:(int)startTag ;
//初始化单url
- (instancetype)initWithUrlStr:(NSString*)urlStr ;
//类工厂
+ (instancetype)downloadImageWithUrlStrArray:(NSArray<NSString*>*)urlArray withStartTag:(int)startTag ;
+ (instancetype)downloadImageWithUrlStr:(NSString*)urlStr ;

//开始下载
- (void)starDownloadImage;

@end

NS_ASSUME_NONNULL_END
