//
//  CounterModel.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/8.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "CounterModel.h"

@interface CounterModel ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation CounterModel

- (instancetype)initWithUserDefault:(NSUserDefaults *)defaults
{
    self = [super init];
    if (self) {
        self.defaults = defaults;
        self.count = [self getCountInDefaults];
    }
    return self;
}
//
//- (NSInteger)getCountInDefaults {
//    NSNumber *reminderId = 
//}

@end
