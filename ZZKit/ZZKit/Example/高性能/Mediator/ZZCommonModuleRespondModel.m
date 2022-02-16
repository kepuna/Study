//
//  ZZCommonModuleRespondModel.m
//  ZZKit
//
//  Created by MOMO on 2021/10/22.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZCommonModuleRespondModel.h"

@implementation ZZCommonModuleRespondModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _autoInit = YES;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([self isKindOfClass:[object class]]) {
        if ([self.name isEqualToString:[((ZZCommonModuleRespondModel *)object) name]]) {
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)hash {
    return self.name.hash;
}

@end
