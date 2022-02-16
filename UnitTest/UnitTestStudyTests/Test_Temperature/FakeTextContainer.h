//
//  FakeTextContainer.h
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/7/29.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  不需要配置一个完成的UITextField对象， 只需要创建一个含有text属性的简单对象即可

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FakeTextContainer : NSObject
@property (nonatomic, copy) NSString *text;
@end


@interface TemperatureConversionTests : NSObject

- (void)testThatMinusFortyCelsiusIsMinusFortyFahrenheit ;

- (BOOL)textFieldShouldReturn:(id)celsiusField;

@end

NS_ASSUME_NONNULL_END
