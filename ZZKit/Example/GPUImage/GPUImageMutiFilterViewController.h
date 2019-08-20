//
//  GPUImageMutiFilterViewController.h
//  ZZKit
//
//  Created by donews on 2019/5/7.
//  Copyright © 2019年 donews. All rights reserved.
//  多滤镜视频采集存储

#import <UIKit/UIKit.h>

/*
功能要求

 dmeo1 

 
 使用GPUImageFilterGroup混合滤镜的步骤如下：
 1）初始化要加载滤镜的GPUImagePicture对象initWithImage: smoothlyScaleOutput:
 2）初始化多个要被使用的单独的GPUImageFilter滤镜
 3）初始化GPUImageFilterGroup对象
 4）将FilterGroup加在之前初始化过的GPUImagePicture上
 5）将多个滤镜加在FilterGroup中(此处切记一定要设置好设置FilterGroup的初始滤镜和末尾滤镜)
 6）之前初始化过的GPUImagePicture处理图片 processImage
 7）拿到处理后的UIImage对象图片imageFromCurrentFramebuffer
 
 作者：绿豆粥与茶叶蛋
 链接：https://www.jianshu.com/p/1941eae75d01
 来源：简书
 简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
*/
NS_ASSUME_NONNULL_BEGIN

@interface GPUImageMutiFilterViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
