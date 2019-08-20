//
//  ZZGLKit1ViewController.h
//  ZZKit
//
//  Created by donews on 2019/5/9.
//  Copyright © 2019年 donews. All rights reserved.
//  通过GLKit，尽量简单地实现把一张图片绘制到屏幕。

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

//将ViewController改为从GLKViewController继承
/*
 ViewController从GLKViewController继承很多 基本功能
 如ViewController.view的类型自动变为GLKView（因为GLKViweController的view为GLKView类型）
 特别地，GLKViewController会自动重新设置OpenGL ES和应用的GLKView实例以响应设备方向的变化并可视化过渡效果，如淡入淡出
 
 */

@interface ZZGLKit1ViewController : GLKViewController

@end

