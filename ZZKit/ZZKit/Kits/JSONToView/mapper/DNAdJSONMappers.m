//
//  DNAdJSONMappers.m
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONMappers.h"

@implementation DNAdJSONMappers

- (NSString *)obtainViewByType:(NSString *)key {
    return [self allViewMappers][key];
}

- (NSDictionary *)allViewMappers {
    return @{
             @"view":@"DNAdJSONViewModel",
             @"label":@"DNAdJSONLabelModel",
             @"imageView":@"DNAdJSONImageModel",
             @"stackView":@"DNAdJSONStackViewModel"
             };}

@end
