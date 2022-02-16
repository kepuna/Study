//
//  ZZPersonModel.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/11/5.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

// 参考文章 异步测试 https://www.jianshu.com/p/3ea8be84f53a
// 逻辑测试 https://www.jianshu.com/p/15f347eb207c
//单元测试--性能测试 https://www.jianshu.com/p/3ea8be84f53a

NS_ASSUME_NONNULL_BEGIN

@interface ZZPersonModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

//字典转模型方法 此方法需要测试
+ (instancetype)personWithDict:(NSDictionary *)dict;

//增加一个模拟“异步加载个人数据”的网络请求数据方法：
+ (void)loadPersonAsync:(void(^)(ZZPersonModel *person))completion; //异步加载个人数据

@end

NS_ASSUME_NONNULL_END
