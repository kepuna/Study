//
//  ZZDownloadImage.m
//  ZZKit
//
//  Created by donews on 2019/7/16.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZDownloadImage.h"

static int const  kImageViewTag = 1990;

@interface ZZDownloadImage ()

@property (nonatomic,strong) NSOperationQueue *queue; // 下载图片的队列
@property (nonatomic,strong)NSCache *imageCache;
@property (nonatomic,copy)NSString *cachePath; // 图片缓存路径
@property (nonatomic,assign)int imageStartTag;

@end

@implementation ZZDownloadImage

#pragma mark - 初始化
- (instancetype)initWithUrlStrArray:(NSArray<NSString*>*)urlArray withStartTag:(int)startTag{
    self = [super init];
    if (self) {
        self.urlArray = urlArray;
        self.imageStartTag = startTag;
    }
    return self;
}

- (instancetype)initWithUrlStr:(NSString*)urlStr {
    self = [super init];
    if (self) {
        self.urlStr = urlStr;
    }
    return self;
}

+ (instancetype)downloadImageWithUrlStrArray:(NSArray<NSString*>*)urlArray withStartTag:(int)startTag {
    return [[ZZDownloadImage alloc] initWithUrlStrArray:urlArray withStartTag:startTag];
}

+ (instancetype)downloadImageWithUrlStr:(NSString*)urlStr {
    return [[ZZDownloadImage alloc] initWithUrlStr:urlStr];
}

#pragma mark - 加载图片
- (void)starDownloadImage {
    
    //设置内存缓存和磁盘缓存大小
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:self.MemoryCapacity * 1024 * 1024 diskCapacity:self.diskCapacity * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    //加载数据
    for (int i=0; i < self.urlArray.count; i++) {
        int imageTag = self.imageStartTag + i; // 图片的tag
        NSString *urlStr = self.urlArray[i];
        
         //从内存缓存中读取图片
         UIImage *memoryImage = [self.imageCache objectForKey:urlStr];
        if (memoryImage) {
            //block回调结果
            if (self.downloadFinishedBlock) {
                self.downloadFinishedBlock(memoryImage,imageTag,self.tag);
            }
            //代理回调结果
            if ([self.delegate respondsToSelector:@selector(downloadImageFinishedWith:andTag:withQueueTag:)]) {
                [self.delegate downloadImageFinishedWith:memoryImage andTag:imageTag withQueueTag:self.tag];
            }
            continue;
        }
        
        //从磁盘缓存中读取图片
        NSString *imagePath=[urlStr lastPathComponent];
        NSString *imageCachePath = [self.cachePath stringByAppendingPathComponent:imagePath];
        NSData *data = [NSData dataWithContentsOfFile:imageCachePath];
        if (data) {
            UIImage *diskImage = [UIImage imageWithData:data];
            //block回调结果
            if (self.downloadFinishedBlock) {
                self.downloadFinishedBlock(diskImage,imageTag,self.tag);
            }
            //代理回调结果
            if ([self.delegate respondsToSelector:@selector(downloadImageFinishedWith:andTag:withQueueTag:)]) {
                [self.delegate downloadImageFinishedWith:diskImage andTag:imageTag withQueueTag:self.tag];
            }
            continue;
        }
        
        //创建线程加载图片
         self.queue.maxConcurrentOperationCount = self.maxOperationCount;
        ZZDownloadOperation *op = [ZZDownloadOperation downloadOperationWithUrlStr:urlStr];
        op.tag = i + kImageViewTag;
        
        if (self.urlArray.count < self.maxOperationCount) {
            [op start]; // 开始执行任务
        } else {
            [self.queue addOperation:op];
        }
        
        //线程回调结果
        [op setImageDataBlock:^(NSData *data, int tag) {
            UIImage *image = [UIImage imageWithData:data];
            
            //写入内存缓存
            [self.imageCache setObject:image forKey:urlStr];
            //写入磁盘缓存
            [data writeToFile:imageCachePath atomically:YES];
            
            //block回调
            if (self.downloadFinishedBlock) {
                NSLog(@"tage ======%d",tag);
                self.downloadFinishedBlock(image,tag,self.tag);
            }
            //代理回调
            if ([self.delegate respondsToSelector:@selector(downloadImageFinishedWith:andTag:withQueueTag:)]) {
                [self.delegate downloadImageFinishedWith:image andTag:tag withQueueTag:self.tag];
            }
        }];
    }
}

#pragma mark - Getters & Setters
//初始化 set方法 单个url装进数组
- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    _urlArray = [NSArray arrayWithObject:urlStr];
}

- (NSString *)cachePath {
    if (!_cachePath) {
        _cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    }
    return _cachePath;
}

- (NSCache *)imageCache {
    if (!_imageCache) {
        _imageCache = [[NSCache alloc] init];
        _imageCache.countLimit = 100;
        
    }
    return _imageCache;
}

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSUInteger)MemoryCapacity {
    if (!_MemoryCapacity) {
        _MemoryCapacity = 1;
    }
    return _MemoryCapacity;
}

- (NSUInteger)diskCapacity {
    if (!_diskCapacity) {
        _diskCapacity = 10;
    }
    return _diskCapacity;
}

- (int)maxOperationCount {
    if (!_maxOperationCount) {
        _maxOperationCount = 2;
    }
    return _maxOperationCount;
}

@end
