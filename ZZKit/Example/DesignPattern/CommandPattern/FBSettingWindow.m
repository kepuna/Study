//
//  FBSettingWindow.m
//  ZZYDesignPattern
//
//  Created by MOMO on 2020/7/14.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "FBSettingWindow.h"
#import "FunctionButton.h"

@interface FBSettingWindow ()

@property (nonatomic, copy) NSString *title; // 窗口标题
@property (nonatomic, strong) NSMutableArray <FunctionButton *> *functionButtons;

@end

@implementation FBSettingWindow


- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}


- (NSMutableArray<FunctionButton *> *)functionButtons {
    if (_functionButtons == nil) {
        _functionButtons = [NSMutableArray arrayWithCapacity:3];
    }
    return  _functionButtons;
}

@end
