//
//  ZZPerson.m
//  HighPerformance
//
//  Created by MOMO on 2020/6/23.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZPerson.h"
#import "ZZLanguage.h"

/*
 __covariant(协变):用于泛型数据强转类型，可以向上强转，子类可以转成父类。
 __contravariant(逆变):用于泛型数据强转类型，可以向下强转，父类可以转成子类。
 */
@implementation ZZPerson

/// 首先是没有添加协变和逆变
- (void)test {
    
    Java *java = [Java new];
    iOS *ios = [iOS new];
    
      // iOS  指定这个人会的是iOS
    ZZPerson<iOS *> *person = [ZZPerson new];
    person.language = ios;
    
    // Java   指定这个人会的是Java
    ZZPerson<Java *> *person2 = [ZZPerson new];
    person2.language = java;
}

/// 添加了协变 => 子类转父类
- (void)testCovariant {
    
    iOS *ios = [[iOS alloc]init];
//    ZZLanguage *language = [[ZZLanguage alloc]init];

    // iOS 只会iOS
    ZZPerson<iOS *> *p = [[ZZPerson alloc]init];
    p.language = ios;

    // Language 都会
    ZZPerson<ZZLanguage *> *p1 = [[ZZPerson alloc]init];
    p1 = p;
}


- (void)contravariant {

    // 第二步 定义泛型
//    iOS *ios = [[iOS alloc]init];
    ZZLanguage *language = [[ZZLanguage alloc]init];

    // 父类转子类  都会
    ZZPerson<ZZLanguage *> *p = [[ZZPerson alloc]init];
    p.language = language;

    // iOS  只会iOS
    ZZPerson<iOS *> *p1 = [[ZZPerson alloc]init];
    p1 = p;

    // 如果没添加逆变会报指针类型错误警告
}

@end
