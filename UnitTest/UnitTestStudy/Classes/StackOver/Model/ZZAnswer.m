//
//  ZZAnswer.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/31.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZAnswer.h"

@implementation ZZAnswer

- (NSComparisonResult)compare:(ZZAnswer *)otherAnswer {
    if (self.accepted && !(otherAnswer.accepted)) {
        return NSOrderedAscending;
    }else if (!self.accepted && otherAnswer.accepted){
        return NSOrderedDescending;
    }
    if (self.score > otherAnswer.score) {
        return NSOrderedAscending;
    } else if (self.score < otherAnswer.score) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

@end
