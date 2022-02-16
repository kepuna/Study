//
//  UIWindow+MBLog.m
//  HighPerformance
//
//  Created by MOMO on 2021/3/3.
//  Copyright © 2021 HelloWorld. All rights reserved.
//

#import "UIWindow+MBLog.h"
#import "MMLog.h"

@implementation UIWindow (MBLog)

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (event.type == UIEventSubtypeMotionShake) {
        [MMLog changeVisible];
    }
}

@end
