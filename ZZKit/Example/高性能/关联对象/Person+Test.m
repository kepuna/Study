//
//  Person+Test.m
//  HighPerformance
//
//  Created by MOMO on 2021/2/18.
//  Copyright © 2021 HelloWorld. All rights reserved.
//

#import "Person+Test.h"
#import <objc/runtime.h>

@implementation Person (Test)

- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    // 也可以使用下面这种方法
    // objc_setAssociatedObject(self, &nameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)name {
    return objc_getAssociatedObject(self, @selector(name));
    // return objc_getAssociatedObject(self, &nameKey);
}

@end
