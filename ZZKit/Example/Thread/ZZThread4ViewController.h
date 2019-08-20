//
//  ZZThread4ViewController.h
//  ZZKit
//
//  Created by donews on 2019/5/19.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZZThread4ViewController : UIViewController

/*
 
 @synchronized(self)的用法：
 
 @synchronized 的作用是创建一个互斥锁，保证此时没有其它线程对self对象进行修改。这个是objective-c的一个锁定令牌，防止self对象在同一时间内被其它线程访问，起到线程的保护作用。
 
 
例如：一个电影院，有3个售票员。一场电影的总数量固定。3个售票员售票时，要判断是非还有余票。

 */

@end

