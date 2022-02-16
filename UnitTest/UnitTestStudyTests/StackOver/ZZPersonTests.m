//
//  ZZPersonTests.m
//  UnitTestStudyTests
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZZPerson.h"

@interface ZZPersonTests : XCTestCase
@property (nonatomic, strong) ZZPerson *person;
@end

@implementation ZZPersonTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.person = [[ZZPerson alloc] initWithName:@"Kepuna" avatarLocation:@"http://img.momocdn.com/album/CC/03/CC03C224-3430-C76F-F4F7-BE20AD72DFF420190126_250x250.webp"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.person = nil;
}

- (void)testThatPersonHasTheRightName {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCTAssertEqualObjects(self.person.name, @"Kepuna",@"execpint a person to provide its name");
}

- (void)testThatPersonHasAvatarURL {
    NSURL *url = self.person.avatarURL;
    XCTAssertEqualObjects([url absoluteString], @"http://img.momocdn.com/album/CC/03/CC03C224-3430-C76F-F4F7-BE20AD72DFF420190126_250x250.webp", @"The Person`s avatar should be represented by a URL");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
