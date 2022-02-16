//
//  FakeTextContainer.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/7/29.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

/*
 如果单元测试也能包含其他单元测试的话，那么每个用例应该测试多少个条件那？
 
 一个设计良好的测试用例，应该只设定好某一种使用场景所需的前置条件，然后判断应用程序的代码是否能在此种情境下正确地执行。
 每一个测试用例之间，应该是独立的，且具有原子性，要么执行成功，要么失败。不存在中间态。
 
 */


//#define ZZAssertTrue(condition) do{\
//    if(condition) {\
//        NSLog(@"passed:" @ #condition);\
//    } else {\
//        NSLog(@"faild:" @ #condition);\
//    }\
//} while(0)

#define ZZAssertTrue(condition, msg) do{\
    if(!condition) {\
        NSLog(@"failed:" @ #condition @""msg);\
    }\
} while(0)

#import "FakeTextContainer.h"

@implementation FakeTextContainer

@end

@interface TemperatureConversionTests ()
@property (nonatomic, strong) FakeTextContainer *textField;
@property (nonatomic, strong) FakeTextContainer *fahrenheit;
@end

@implementation TemperatureConversionTests

- (void)testThatMinusFortyCelsiusIsMinusFortyFahrenheit {
    FakeTextContainer *textField = [FakeTextContainer new];
    textField.text = @"-40";
    
    FakeTextContainer *fahrenheit = [FakeTextContainer new];
    
    [self textFieldShouldReturn:textField];
    
    ZZAssertTrue([fahrenheit.text isEqualToString:@"-40"], @"-40 should equal -40f");
}

//- (void)convert

- (BOOL)textFieldShouldReturn:(id)celsiusField {
    self.fahrenheit.text = @"-40";
    return YES;
}

@end


