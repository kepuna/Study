//
//  ZZQuestion.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/30.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZQuestion.h"

@interface ZZQuestion ()
@property (nonatomic, strong) NSMutableSet *answerSet;
@end

@implementation ZZQuestion

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.answerSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addAnswer:(ZZAnswer *)answer {
    [self.answerSet addObject:answer];
}

- (NSArray *)answers {
    return [[self.answerSet allObjects] sortedArrayUsingSelector:@selector(compare:)];
}

//- (NSDate *)date {
//    return [NSDate date];
//}

@end
