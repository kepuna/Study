//
//  ZZCocurrentOperation.h
//  ZZKit
//
//  Created by donews on 2019/7/12.
//  Copyright © 2019年 donews. All rights reserved.
//  自定义并发的NSOperation

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 自定义并发的NSOperation需要以下步骤
 
    1.start方法：该方法必须实现
    2.main:该方法可选，如果你在start方法中定义了你的任务，则这个方法就可以不实现，但通常为了代码逻辑清晰，通常会在该方法中定 义自己的任务
    3.isExecuting isFinished 主要作用是在线程状态改变时，产生适当的KVO通知
    4.isConcurrent :必须覆盖并返回YES
 */
@interface ZZCocurrentOperation : NSOperation {
    BOOL executing; // 是否执行中  默认是NO
    BOOL finished; // 是否执行完毕 默认是NO
}

@end

NS_ASSUME_NONNULL_END
