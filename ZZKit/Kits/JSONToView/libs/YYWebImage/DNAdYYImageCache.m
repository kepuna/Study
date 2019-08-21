//
//  YYImageCache.m
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 15/2/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "DNAdYYImageCache.h"
#import "DNAdYYImage.h"
#import "UIImage+DNAdYYWebImage.h"
#import "DNAdYYCache.h"
#import "DNAdYYImage.h"

static inline dispatch_queue_t YYImageCacheIOQueue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

static inline dispatch_queue_t YYImageCacheDecodeQueue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
}


@interface DNAdYYImageCache ()
- (NSUInteger)imageCost:(UIImage *)image;
- (UIImage *)imageFromData:(NSData *)data;
@end


@implementation DNAdYYImageCache

- (NSUInteger)imageCost:(UIImage *)image {
    CGImageRef cgImage = image.CGImage;
    if (!cgImage) return 1;
    CGFloat height = CGImageGetHeight(cgImage);
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
    NSUInteger cost = bytesPerRow * height;
    if (cost == 0) cost = 1;
    return cost;
}

- (UIImage *)imageFromData:(NSData *)data {
    NSData *scaleData = [DNAdYYDiskCache getExtendedDataFromObject:data];
    CGFloat scale = 0;
    if (scaleData) {
        scale = ((NSNumber *)[NSKeyedUnarchiver unarchiveObjectWithData:scaleData]).doubleValue;
    }
    if (scale <= 0) scale = [UIScreen mainScreen].scale;
    UIImage *image;
    if (_allowAnimatedImage) {
        image = [[DNAdYYImage alloc] initWithData:data scale:scale];
        if (_decodeForDisplay) image = [image yy_imageByDecoded];
    } else {
        DNAdYYImageDecoder *decoder = [DNAdYYImageDecoder decoderWithData:data scale:scale];
        image = [decoder frameAtIndex:0 decodeForDisplay:_decodeForDisplay].image;
    }
    return image;
}

#pragma mark Public

+ (instancetype)sharedCache {
    static DNAdYYImageCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                   NSUserDomainMask, YES) firstObject];
        cachePath = [cachePath stringByAppendingPathComponent:@"com.ibireme.yykit"];
        cachePath = [cachePath stringByAppendingPathComponent:@"images"];
        cache = [[self alloc] initWithPath:cachePath];
    });
    return cache;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"YYImageCache init error" reason:@"YYImageCache must be initialized with a path. Use 'initWithPath:' instead." userInfo:nil];
    return [self initWithPath:@""];
}

- (instancetype)initWithPath:(NSString *)path {
    DNAdYYMemoryCache *memoryCache = [DNAdYYMemoryCache new];
    memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    memoryCache.countLimit = NSUIntegerMax;
    memoryCache.costLimit = NSUIntegerMax;
    memoryCache.ageLimit = 12 * 60 * 60;
    
    DNAdYYDiskCache *diskCache = [[DNAdYYDiskCache alloc] initWithPath:path];
    diskCache.customArchiveBlock = ^(id object) { return (NSData *)object; };
    diskCache.customUnarchiveBlock = ^(NSData *data) { return (id)data; };
    if (!memoryCache || !diskCache) return nil;
    
    self = [super init];
    _memoryCache = memoryCache;
    _diskCache = diskCache;
    _allowAnimatedImage = YES;
    _decodeForDisplay = YES;
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    [self setImage:image imageData:nil forKey:key withType:DNAdYYImageCacheTypeAll];
}

- (void)setImage:(UIImage *)image imageData:(NSData *)imageData forKey:(NSString *)key withType:(DNAdYYImageCacheType)type {
    if (!key || (image == nil && imageData.length == 0)) return;
    
    __weak typeof(self) _self = self;
    if (type & DNAdYYImageCacheTypeMemory) { // add to memory cache
        if (image) {
            if (image.yy_isDecodedForDisplay) {
                [_memoryCache setObject:image forKey:key withCost:[_self imageCost:image]];
            } else {
                dispatch_async(YYImageCacheDecodeQueue(), ^{
                    __strong typeof(_self) self = _self;
                    if (!self) return;
                    [self.memoryCache setObject:[image yy_imageByDecoded] forKey:key withCost:[self imageCost:image]];
                });
            }
        } else if (imageData) {
            dispatch_async(YYImageCacheDecodeQueue(), ^{
                __strong typeof(_self) self = _self;
                if (!self) return;
                UIImage *newImage = [self imageFromData:imageData];
                [self.memoryCache setObject:newImage forKey:key withCost:[self imageCost:newImage]];
            });
        }
    }
    if (type & DNAdYYImageCacheTypeDisk) { // add to disk cache
        if (imageData) {
            if (image) {
                [DNAdYYDiskCache setExtendedData:[NSKeyedArchiver archivedDataWithRootObject:@(image.scale)] toObject:imageData];
            }
            [_diskCache setObject:imageData forKey:key];
        } else if (image) {
            dispatch_async(YYImageCacheIOQueue(), ^{
                __strong typeof(_self) self = _self;
                if (!self) return;
                NSData *data = [image yy_imageDataRepresentation];
                [DNAdYYDiskCache setExtendedData:[NSKeyedArchiver archivedDataWithRootObject:@(image.scale)] toObject:data];
                [self.diskCache setObject:data forKey:key];
            });
        }
    }
}

- (void)removeImageForKey:(NSString *)key {
    [self removeImageForKey:key withType:DNAdYYImageCacheTypeAll];
}

- (void)removeImageForKey:(NSString *)key withType:(DNAdYYImageCacheType)type {
    if (type & DNAdYYImageCacheTypeMemory) [_memoryCache removeObjectForKey:key];
    if (type & DNAdYYImageCacheTypeDisk) [_diskCache removeObjectForKey:key];
}

- (BOOL)containsImageForKey:(NSString *)key {
    return [self containsImageForKey:key withType:DNAdYYImageCacheTypeAll];
}

- (BOOL)containsImageForKey:(NSString *)key withType:(DNAdYYImageCacheType)type {
    if (type & DNAdYYImageCacheTypeMemory) {
        if ([_memoryCache containsObjectForKey:key]) return YES;
    }
    if (type & DNAdYYImageCacheTypeDisk) {
        if ([_diskCache containsObjectForKey:key]) return YES;
    }
    return NO;
}

- (UIImage *)getImageForKey:(NSString *)key {
    return [self getImageForKey:key withType:DNAdYYImageCacheTypeAll];
}

- (UIImage *)getImageForKey:(NSString *)key withType:(DNAdYYImageCacheType)type {
    if (!key) return nil;
    if (type & DNAdYYImageCacheTypeMemory) {
        UIImage *image = [_memoryCache objectForKey:key];
        if (image) return image;
    }
    if (type & DNAdYYImageCacheTypeDisk) {
        NSData *data = (id)[_diskCache objectForKey:key];
        UIImage *image = [self imageFromData:data];
        if (image && (type & DNAdYYImageCacheTypeMemory)) {
            [_memoryCache setObject:image forKey:key withCost:[self imageCost:image]];
        }
        return image;
    }
    return nil;
}

- (void)getImageForKey:(NSString *)key withType:(DNAdYYImageCacheType)type withBlock:(void (^)(UIImage *image, DNAdYYImageCacheType type))block {
    if (!block) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = nil;
        
        if (type & DNAdYYImageCacheTypeMemory) {
            image = [_memoryCache objectForKey:key];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(image, DNAdYYImageCacheTypeMemory);
                });
                return;
            }
        }
        
        if (type & DNAdYYImageCacheTypeDisk) {
            NSData *data = (id)[_diskCache objectForKey:key];
            image = [self imageFromData:data];
            if (image) {
                [_memoryCache setObject:image forKey:key];
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(image, DNAdYYImageCacheTypeDisk);
                });
                return;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(nil, DNAdYYImageCacheTypeNone);
        });
    });
}

- (NSData *)getImageDataForKey:(NSString *)key {
    return (id)[_diskCache objectForKey:key];
}

- (void)getImageDataForKey:(NSString *)key withBlock:(void (^)(NSData *imageData))block {
    if (!block) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = (id)[_diskCache objectForKey:key];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(data);
        });
    });
}

@end
