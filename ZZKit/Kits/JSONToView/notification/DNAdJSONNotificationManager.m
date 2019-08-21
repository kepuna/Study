//
//  DNAdJSONNotificationManager.m
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONNotificationManager.h"
#import "DNAdJsonNotificationResultModel.h"

@implementation DNAdJSONNotificationManager


- (instancetype)init
{
    self = [super init];
    if (self) {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"MDAsynchronousResourceData" object:nil];
    }
    return self;
}

- (void)handleNotification:(NSNotification *)noti {
    id obj = noti.userInfo[@"imageView"];
    if([obj isKindOfClass:[DNAdJsonNotificationResultModel class]] && self.result) {
        self.result(obj);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
