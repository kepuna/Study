//
//  MBCarPlayerContainerViewModule.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/3.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "MBCarPlayerContainerViewModule.h"
#import "MBCarSeatModel.h"

@interface MBCarPlayerContainerViewModule ()
@property (nonatomic, strong) NSMutableArray<MBCarSeatModel *> *seatModels;
@end

@implementation MBCarPlayerContainerViewModule

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createModels];
    }
    return self;
}

- (void)createModels {
    
    MBCarSeatModel *model = [MBCarSeatModel new];
    model.nickname = @"哈哈哈";
    model.avatarUrl = @"";
    model.playTimes = @"开车332次";
    model.roleText = @"队长";
    model.seatState = 0;
    
    
    MBCarSeatModel *model1 = [MBCarSeatModel new];
    model1.nickname = @"3333";
    model1.avatarUrl = @"";
    model1.playTimes = @"上车3次";
    model1.roleText = @"尊贵铂金";
    model1.seatState = 0;
    
    MBCarSeatModel *model2 = [MBCarSeatModel new];
    model2.nickname = @"";
    model2.avatarUrl = @"";
    model2.playTimes = @"上车3次";
    model2.roleText = @"";
    model2.seatState = 0;
    
    MBCarSeatModel *model3 = [MBCarSeatModel new];
    model3.nickname = @"";
    model3.avatarUrl = @"";
    model3.playTimes = @"";
    model3.roleText = @"";
    model3.seatState = 0;
    
    MBCarSeatModel *model4 = [MBCarSeatModel new];
    model4.nickname = @"";
    model4.avatarUrl = @"";
    model4.playTimes = @"";
    model4.roleText = @"";
    model4.seatState = 0;
    
    [self.seatModels addObject:model];
    [self.seatModels addObject:model1];
    [self.seatModels addObject:model2];
    [self.seatModels addObject:model3];
    [self.seatModels addObject:model4];
}

- (NSMutableArray<MBCarSeatModel *> *)seatModels {
    if (_seatModels == nil) {
        _seatModels = [NSMutableArray arrayWithCapacity:5];
    }
    return _seatModels;
}

@end
