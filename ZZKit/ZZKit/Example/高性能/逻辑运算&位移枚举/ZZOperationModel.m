//
//  ZZOperationModel.m
//  HighPerformance
//
//  Created by MOMO on 2020/7/8.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZOperationModel.h"

@interface ZZOperationModel ()

@end
@implementation ZZOperationModel

- (NSInteger)helpState {
    NSInteger state = self.online;
    if (self.seatState) {
        state = (self.online << [self.seatState integerValue]); // 左移
    }
    return state;
}

- (NSInteger)buttonTip {
    return self.gameState & self.role;
}

@end
