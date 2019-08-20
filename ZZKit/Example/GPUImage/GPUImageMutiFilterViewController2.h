//
//  GPUImageMutiFilterViewController2.h
//  ZZKit
//
//  Created by donews on 2019/5/8.
//  Copyright © 2019年 donews. All rights reserved.
//  使用GPUImageFilterPipeline混合滤镜

#import <UIKit/UIKit.h>

/*
 
 1）初始化要加载滤镜的GPUImagePicture对象initWithImage: smoothlyScaleOutput:
 2）初始化GPUImageView并加在自己的UIImageView对象上
 3）初始化多个要被使用的单独的GPUImageFilter滤镜
 4）把多个单独的滤镜对象放到数组中
 5）初始化创建GPUImageFilterPipeline对象initWithOrderedFilters: input: output:
        参数1：滤镜数组
        参数2：GPUImagePicture对象
        参数3：GPUImageOutput对象如：GPUImageView
 6）之前初始化过的GPUImagePicture处理图片 processImage
 7）拿到处理后的UIImage对象图片currentFilteredFrame
 
 作者：绿豆粥与茶叶蛋
 链接：https://www.jianshu.com/p/1941eae75d01
 
 https://www.jianshu.com/p/ed9e82733c5c

 */

@interface GPUImageMutiFilterViewController2 : UIViewController

@end

