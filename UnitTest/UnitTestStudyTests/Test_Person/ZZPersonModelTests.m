//
//  ZZPersonModelTests.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/11/5.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZZPersonModel.h"


/**
 
 注意事项：
 
 不是所有的方法都需要测试。
    - 例如：私有方法不需要测试！只有暴露在 .h 中的方法需要测试！面向对象有一个原则：开闭原则！
 所有跟 UI 有关的都不需要测试，也不好测试。
    - 把 业务逻辑 代码封装出来！变成可以测试的代码，让程序更加健壮！
 一般而言，代码的覆盖度大概在 50% ~ 70%
    -从github上得知：YYModel测试覆盖度为83%，AFNetworking测试覆盖度为77%，两者都是比较高的
 

 
 */

@interface ZZPersonModelTests : XCTestCase

@end

@implementation ZZPersonModelTests

//XCTAssert(expression, ...)
//XCTAssert(条件, 不满足条件的描述)

// 一次单元测试前的准备工作，比如准备数据
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

// 一次单元测试结束的回收工作，比如销毁对象
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testPersonModel {
    
    // 1.测试 name和age 是否一致
    [self checkPersonWithDict:@{@"name":@"zhou", @"age":@30}];
    
    /** 2.测试出 age 不符合实际，那么需要在字典转模型方法中对age加以判断：
     if (obj.age <= 0 || obj.age >= 130) {
     obj.age = 0;
     }
     */
    [self checkPersonWithDict:@{@"name":@"zhang",@"age":@200}];
    
    // 3.测试出 name 为nil的情况，因此在XCTAssert里添加条件：“person.name == nil“
    [self checkPersonWithDict:@{}];
    
    // 4.测试出 Person类中没有 title 这个key，在字典转模型方法中实现：- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
    [self checkPersonWithDict:@{@"name":@"zhou", @"age":@30, @"title":@"boss"}];
    
    // 5.总体再验证一遍，结果Build Succeeded，测试全部通过
    [self checkPersonWithDict:@{@"name":@"zhou", @"age":@-1, @"title":@"boss"}];
    
    // 到目前为止 Person 的 工厂方法测试完成！✅
}

// 根据字典检查新建的 person 信息
- (void)checkPersonWithDict:(NSDictionary *)dict {
    
    ZZPersonModel *person = [ZZPersonModel personWithDict:dict];
    // 获取字典中的信息
    NSString *name = dict[@"name"];
    NSInteger age = [dict[@"age"] integerValue];
    
    // 1.检查名字
    XCTAssert([name isEqualToString:person.name] || person.name == nil, @"姓名不一致");
    
    // 2.检查年龄
    if (person.age > 0 && person.age < 130) {
        XCTAssert(age == person.age, @"年龄不一致");
    } else {
        XCTAssert(person.age == 0, @"年龄超限");
    }
}

- (void)testLoadPersonAsync{
    
//    要用到系统提供的XCTestExpectation这个类 以及- (void)waitForExpectationsWithTimeout:(NSTimeInterval)timeout handler:(nullable XCWaitCompletionHandler)handler这个方法来测试
    XCTestExpectation *expectation = [self expectationWithDescription:@"异步加载 Person"]; // 只有在异步操作时间超过了预设时间时Description才会在Log中打印出来
    [ZZPersonModel loadPersonAsync:^(ZZPersonModel * _Nonnull person) {
        XCTAssertNotNil(person.name, @"名字不能为空");
        XCTAssert(person.age > 0, @"年龄不正确");
        // 标注预期达成 该方法用于表示这个异步测试结束了，每一个XCTestExpectation都需要对应一个fulfill，否则将会导致测试失败
        [expectation fulfill];
    }];
    
    // 等待 5s 期望预期达成
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        //等待5秒，若该测试未结束（未收到 fulfill方法）则测试结果为失败
        //Do something when time out
        // handler 也可以设置为nil
    }];
}

// 单元测试模拟方法
- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

//此方法可以测试出一个方法运行过程的耗时时间,
- (void)testPerformanceExample {
    
    /*
      我们来测试Person文件中的字典转模型这个方法：+ (instancetype)personWithDict:(NSDictionary *)dict；的耗时性能
     
     相同的代码重复执行 10 次，统计计算时间，平均时间！
     性能测试代码一旦写好，可以随时测试！
     */
    
    [self measureBlock:^{
        
//        NSTimeInterval start = CACurrentMediaTime();
        // 测试用例，循环10000次，为了演示效果
        for (NSInteger i = 0; i < 10000; i++) {
            [ZZPersonModel personWithDict:@{@"name":@"zhang",@"age":@20}];
        }
        
        // 传统测试代码耗时方法
//        NSLog(@"%lf",CACurrentMediaTime() - start);
    }];
    
//    从输出结果可以看出，相同的代码重复执行 10 次，统计计算时间，得到平均时间，也计算出了标准差等
//    小知识：
//    测试一段代码（函数/方法）的执行时间，我们通常是用到CFAbsoluteTimeGetCurrent()或者CACurrentMediaTime()函数，通过差值来计算出时间间隔
}

@end
