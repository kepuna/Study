//
//  UnitTestStudyTests.m
//  UnitTestStudyTests
//
//  Created by donews on 2019/9/26.
//  Copyright © 2019年 HelloWorld. All rights reserved.
//

#import <XCTest/XCTest.h>
//#import "FakeTextContainer.h"
//#import "ZZTemperatureViewController.h"

@interface UnitTestStudyTests : XCTestCase
//@property (nonatomic, strong) FakeTextContainer *textField;
//@property (nonatomic, strong) FakeTextContainer *fahrenheit;
//@property (nonatomic, strong) ZZTemperatureViewController *convertViewController;
@end

@implementation UnitTestStudyTests


// // 一次单元测试前的准备工作，比如准备数据
// 每次调用测试方法之前都会调用该方法做重置工作
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    
//    self.convertViewController = [ZZTemperatureViewController new];
//    self.textField = [FakeTextContainer new];
//    self.fahrenheit = [FakeTextContainer new];
//
//    self.convertViewController.textField = (UITextField *) self.textField;
//    self.convertViewController.fahrenheitLabel = (UILabel *)self.fahrenheit;
}

- (void)testThatMinusFortyCelsiusIsMinusFortyFahrenheit {
   
//    self.textField.text = @"-40";
//    [self.convertViewController textFieldShouldReturn:(UITextField *)self.textField];
//    XCTAssertEqualObjects(self.fahrenheit.text, @"-40", @"In both Celsius and Fahrenheit -40 is the same temperature");

}

- (void)testThatOneHundredCelsiusIsTowOneTowFahenheit {
//    self.textField.text = @"100";
//    [self.convertViewController textFieldShouldReturn:(UITextField *)self.textField];
//    XCTAssertEqualObjects(self.fahrenheit.text, @"212", @"100 Celsius is 212 Fahrenheit");
}


// 一次单元测试结束的回收工作，比如销毁对象
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
