//
//  ZZThread1ViewController.h
//  ZZKit
//
//  Created by donews on 2019/5/17.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 https://www.jianshu.com/p/342b2ffbdd97
 https://www.jianshu.com/p/342b2ffbdd97
 iOS-网络请求依次执行，NSOperationQueue与dispatch_semaphore
 
 借助GCD的信号量dispatch_semaphore营造线程同步情况
 
 dispatch_semaphore信号量为基于计数器的一种多线程同步机制。
 用于解决在多个线程访问共有资源时候，会因为多线程的特性而引发数据出错的问题。
 
 */

@interface ZZThread1ViewController : UIViewController

@end

