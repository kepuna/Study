//
//  UIImageView+DNAdYYWebImage.m
//  JSONToView
//
//  Created by donews on 2019/7/9.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "UIImageView+DNAdYYWebImage.h"
#import "DNAdYYWebImageOperation.h"
#import "_DNAdYYWebImageSetter.h"
#import <objc/runtime.h>
//#import "DNAdsDetailModel.h"
//#import "DNAdReporter.h"
//#import "DNLogger.h"
//#import "DNAdSDKConst.h"

// Dummy class for category
@interface UIImageView_YYWebImage : NSObject @end
@implementation UIImageView_YYWebImage @end

static int _YYWebImageSetterKey;
static int _YYWebImageHighlightedSetterKey;


@implementation UIImageView (DNAdYYWebImage)

#pragma mark - image

- (NSURL *)yy_imageURL {
    _DNAdYYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageSetterKey);
    return setter.imageURL;
}

- (void)setYy_imageURL:(NSURL *)imageURL {
    [self yy_setImageWithURL:imageURL
                 placeholder:nil
                     options:kNilOptions
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:nil];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder {
    [self yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:kNilOptions
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:nil];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL options:(DNAdYYWebImageOptions)options {
    [self yy_setImageWithURL:imageURL
                 placeholder:nil
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:nil];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(DNAdYYWebImageOptions)options
                completion:(YYWebImageCompletionBlock)completion {
    [self yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:nil
                   transform:nil
                  completion:completion];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(DNAdYYWebImageOptions)options
                  progress:(YYWebImageProgressBlock)progress
                 transform:(YYWebImageTransformBlock)transform
                completion:(YYWebImageCompletionBlock)completion {
    [self yy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:progress
                   transform:transform
                  completion:completion];
}

- (void)yy_setImageWithURL:(NSURL *)imageURL
               placeholder:(UIImage *)placeholder
                   options:(DNAdYYWebImageOptions)options
                   manager:(DNAdYYWebImageManager *)manager
                  progress:(YYWebImageProgressBlock)progress
                 transform:(YYWebImageTransformBlock)transform
                completion:(YYWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [DNAdYYWebImageManager sharedManager];
    
    _DNAdYYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageSetterKey);
    if (!setter) {
        setter = [_DNAdYYWebImageSetter new];
        objc_setAssociatedObject(self, &_YYWebImageSetterKey, setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    _yy_dispatch_sync_on_main_queue(^{
        if ((options & YYWebImageOptionSetImageWithFadeAnimation) &&
            !(options & YYWebImageOptionAvoidSetImage)) {
            if (!self.highlighted) {
                [self.layer removeAnimationForKey:_YYWebImageFadeAnimationKey];
            }
        }
        
        if (!imageURL) {
            if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
                self.image = placeholder;
            }
            return;
        }
        
        // get the image from memory as quickly as possible
        UIImage *imageFromMemory = nil;
        if (manager.cache &&
            !(options & YYWebImageOptionUseNSURLCache) &&
            !(options & YYWebImageOptionRefreshImageCache)) {
            imageFromMemory = [manager.cache getImageForKey:[manager cacheKeyForURL:imageURL] withType:DNAdYYImageCacheTypeMemory];
        }
        if (imageFromMemory) {
            if (!(options & YYWebImageOptionAvoidSetImage)) {
                self.image = imageFromMemory;
            }
            if(completion) completion(imageFromMemory, imageURL, YYWebImageFromMemoryCacheFast, YYWebImageStageFinished, nil);
            return;
        }
        
        if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
            self.image = placeholder;
        }
        
        __weak typeof(self) _self = self;
        dispatch_async([_DNAdYYWebImageSetter setterQueue], ^{
            YYWebImageProgressBlock _progress = nil;
            if (progress) _progress = ^(NSInteger receivedSize, NSInteger expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress(receivedSize, expectedSize);
                });
            };
            
            __block int32_t newSentinel = 0;
            __block __weak typeof(setter) weakSetter = nil;
            YYWebImageCompletionBlock _completion = ^(UIImage *image, NSURL *url, DNAdYYWebImageFromType from, DNAdYYWebImageFromType stage, NSError *error) {
                __strong typeof(_self) self = _self;
                BOOL setImage = (stage == YYWebImageStageFinished || stage == YYWebImageStageProgress) && image && !(options & YYWebImageOptionAvoidSetImage);
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (setImage && self && !sentinelChanged) {
                        BOOL showFade = ((options & YYWebImageOptionSetImageWithFadeAnimation) && !self.highlighted);
                        if (showFade) {
                            CATransition *transition = [CATransition animation];
                            transition.duration = stage == YYWebImageStageFinished ? _YYWebImageFadeTime : _YYWebImageProgressiveFadeTime;
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            transition.type = kCATransitionFade;
                            [self.layer addAnimation:transition forKey:_YYWebImageFadeAnimationKey];
                        }
                        self.image = image;
                    }
                    if (completion) {
                        if (sentinelChanged) {
                            completion(nil, url, YYWebImageFromNone, YYWebImageStageCancelled, nil);
                        } else {
                            completion(image, url, from, stage, error);
                        }
                    }
                });
            };
            
            newSentinel = [setter setOperationWithSentinel:sentinel url:imageURL options:options manager:manager progress:_progress transform:transform completion:_completion];
            weakSetter = setter;
        });
    });
}

- (void)yy_cancelCurrentImageRequest {
    _DNAdYYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageSetterKey);
    if (setter) [setter cancel];
}


#pragma mark - highlighted image

- (NSURL *)yy_highlightedImageURL {
    _DNAdYYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageHighlightedSetterKey);
    return setter.imageURL;
}

- (void)setYy_highlightedImageURL:(NSURL *)imageURL {
    [self yy_setHighlightedImageWithURL:imageURL
                            placeholder:nil
                                options:kNilOptions
                                manager:nil
                               progress:nil
                              transform:nil
                             completion:nil];
}

- (void)yy_setHighlightedImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder {
    [self yy_setHighlightedImageWithURL:imageURL
                            placeholder:placeholder
                                options:kNilOptions
                                manager:nil
                               progress:nil
                              transform:nil
                             completion:nil];
}

- (void)yy_setHighlightedImageWithURL:(NSURL *)imageURL options:(DNAdYYWebImageOptions)options {
    [self yy_setHighlightedImageWithURL:imageURL
                            placeholder:nil
                                options:options
                                manager:nil
                               progress:nil
                              transform:nil
                             completion:nil];
}

- (void)yy_setHighlightedImageWithURL:(NSURL *)imageURL
                          placeholder:(UIImage *)placeholder
                              options:(DNAdYYWebImageOptions)options
                           completion:(YYWebImageCompletionBlock)completion {
    [self yy_setHighlightedImageWithURL:imageURL
                            placeholder:placeholder
                                options:options
                                manager:nil
                               progress:nil
                              transform:nil
                             completion:completion];
}

- (void)yy_setHighlightedImageWithURL:(NSURL *)imageURL
                          placeholder:(UIImage *)placeholder
                              options:(DNAdYYWebImageOptions)options
                             progress:(YYWebImageProgressBlock)progress
                            transform:(YYWebImageTransformBlock)transform
                           completion:(YYWebImageCompletionBlock)completion {
    [self yy_setHighlightedImageWithURL:imageURL
                            placeholder:placeholder
                                options:options
                                manager:nil
                               progress:progress
                              transform:nil
                             completion:completion];
}

- (void)yy_setHighlightedImageWithURL:(NSURL *)imageURL
                          placeholder:(UIImage *)placeholder
                              options:(DNAdYYWebImageOptions)options
                              manager:(DNAdYYWebImageManager *)manager
                             progress:(YYWebImageProgressBlock)progress
                            transform:(YYWebImageTransformBlock)transform
                           completion:(YYWebImageCompletionBlock)completion {
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [DNAdYYWebImageManager sharedManager];
    
    _DNAdYYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageHighlightedSetterKey);
    if (!setter) {
        setter = [_DNAdYYWebImageSetter new];
        objc_setAssociatedObject(self, &_YYWebImageHighlightedSetterKey, setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    _yy_dispatch_sync_on_main_queue(^{
        if ((options & YYWebImageOptionSetImageWithFadeAnimation) &&
            !(options & YYWebImageOptionAvoidSetImage)) {
            if (self.highlighted) {
                [self.layer removeAnimationForKey:_YYWebImageFadeAnimationKey];
            }
        }
        if (!imageURL) {
            if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
                self.highlightedImage = placeholder;
            }
            return;
        }
        
        // get the image from memory as quickly as possible
        UIImage *imageFromMemory = nil;
        if (manager.cache &&
            !(options & YYWebImageOptionUseNSURLCache) &&
            !(options & YYWebImageOptionRefreshImageCache)) {
            imageFromMemory = [manager.cache getImageForKey:[manager cacheKeyForURL:imageURL] withType:DNAdYYImageCacheTypeMemory];
        }
        if (imageFromMemory) {
            if (!(options & YYWebImageOptionAvoidSetImage)) {
                self.highlightedImage = imageFromMemory;
            }
            if(completion) completion(imageFromMemory, imageURL, YYWebImageFromMemoryCacheFast, YYWebImageStageFinished, nil);
            return;
        }
        
        if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
            self.highlightedImage = placeholder;
        }
        
        __weak typeof(self) _self = self;
        dispatch_async([_DNAdYYWebImageSetter setterQueue], ^{
            YYWebImageProgressBlock _progress = nil;
            if (progress) _progress = ^(NSInteger receivedSize, NSInteger expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress(receivedSize, expectedSize);
                });
            };
            
            __block int32_t newSentinel = 0;
            __block __weak typeof(setter) weakSetter = nil;
            YYWebImageCompletionBlock _completion = ^(UIImage *image, NSURL *url, DNAdYYWebImageFromType from, DNAdYYWebImageFromType stage, NSError *error) {
                __strong typeof(_self) self = _self;
                BOOL setImage = (stage == YYWebImageStageFinished || stage == YYWebImageStageProgress) && image && !(options & YYWebImageOptionAvoidSetImage);
                BOOL showFade = ((options & YYWebImageOptionSetImageWithFadeAnimation) && self.highlighted);
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (setImage && self && !sentinelChanged) {
                        if (showFade) {
                            CATransition *transition = [CATransition animation];
                            transition.duration = stage == YYWebImageStageFinished ? _YYWebImageFadeTime : _YYWebImageProgressiveFadeTime;
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            transition.type = kCATransitionFade;
                            [self.layer addAnimation:transition forKey:_YYWebImageFadeAnimationKey];
                        }
                        self.highlightedImage = image;
                    }
                    if (completion) {
                        if (sentinelChanged) {
                            completion(nil, url, YYWebImageFromNone, YYWebImageStageCancelled, nil);
                        } else {
                            completion(image, url, from, stage, error);
                        }
                    }
                });
            };
            
            newSentinel = [setter setOperationWithSentinel:sentinel url:imageURL options:options manager:manager progress:_progress transform:transform completion:_completion];
            weakSetter = setter;
        });
    });
}

- (void)yy_cancelCurrentHighlightedImageRequest {
    _DNAdYYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageHighlightedSetterKey);
    if (setter) [setter cancel];
}


//- (void)yy_setAdImageWithURL:(NSURL *)imageURL detailModel:(DNAdsDetailModel *)detailModel placeholder:(UIImage *)placeholder {
//    [self yy_setAdImageWithURL:imageURL detailModel:detailModel placeholder:placeholder completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, NSError * _Nullable error) {
//
//    }];
//}
//
//- (void)yy_setAdImageWithURL:(NSURL *)imageURL detailModel:(DNAdsDetailModel *)detailModel placeholder:(UIImage *)placeholder completion:(void (^)(UIImage * _Nullable, NSURL * _Nonnull, NSError * _Nullable))completion {
//
//    if (!imageURL) {
//        return;
//    }
//
//    [[DNAdReporter sharedInstance] addEventWithBulider:^(DNAdEventBuilder *builder) {
//        builder.actname = DNEventAdMeterialData;
//        builder.codeid = detailModel.codeid;
//        builder.eventid = detailModel.eventid;
//        builder.adfrom = [NSString stringWithFormat:@"%zd",detailModel.ad_from];
//        builder.advismats = imageURL.absoluteString;
//        builder.adtitle = detailModel.title;
//        builder.aid = detailModel.aid;
//    }];
//
//    [self yy_setImageWithURL:imageURL placeholder:placeholder options:0  completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, DNAdYYWebImageFromType from, DNAdYYWebImageFromType stage, NSError * _Nullable error) {
//        if (error) {
//            [DNLogger log:@"图片物料加载失败:%@",error];
//            completion(image,url,error);
//            [[DNAdReporter sharedInstance] addEventWithBulider:^(DNAdEventBuilder *builder) {
//                builder.actname = DNEventAdMeterialDataFaild;
//                builder.codeid = detailModel.codeid;
//                builder.eventid = detailModel.eventid;
//                builder.errorcode = @(error.code);
//                builder.errormsg = [NSString stringWithFormat:@"%@",error];
//                builder.adfrom = [NSString stringWithFormat:@"%zd",detailModel.ad_from];
//                builder.advismats = imageURL.absoluteString;;
//                builder.adtitle = detailModel.title;
//                builder.aid = detailModel.aid;
//            }];
//        } else if (!image) {
//            NSError *error = [NSError errorWithDomain:DNAdErrorDomainMeterial code:DNAdErrorCodeSDevice userInfo:@{NSLocalizedDescriptionKey:@"广告物料转换image失败"}];
//            completion(nil,url,error);
//            [[DNAdReporter sharedInstance] addEventWithBulider:^(DNAdEventBuilder *builder) {
//                builder.actname = DNEventAdMeterialDataFaild;
//                builder.codeid = detailModel.codeid;
//                builder.eventid = detailModel.eventid;
//                builder.errorcode = @(error.code);
//                builder.errormsg = [NSString stringWithFormat:@"%@",error];
//                builder.adfrom = [NSString stringWithFormat:@"%zd",detailModel.ad_from];
//                builder.advismats = imageURL.absoluteString;;
//                builder.adtitle = detailModel.title;
//                builder.aid = detailModel.aid;
//            }];
//        } else { // 物料加载转换成功
//            [DNLogger log:@"物料加载转换成功"];
//            completion(image,url,error);
//            [[DNAdReporter sharedInstance] addEventWithBulider:^(DNAdEventBuilder *builder) {
//                builder.actname = DNEventAdMeterialDataSuccess;
//                builder.codeid = detailModel.codeid;
//                builder.eventid = detailModel.eventid;
//                builder.adfrom = [NSString stringWithFormat:@"%zd",detailModel.ad_from];
//                builder.advismats = imageURL.absoluteString;
//                builder.adtitle = detailModel.title;
//                builder.aid = detailModel.aid;
//            }];
//        }
//    }];
//}

@end
