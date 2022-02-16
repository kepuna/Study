//
//  ZZPersonModel.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/11/5.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZPersonModel.h"

@implementation ZZPersonModel

+ (instancetype)personWithDict:(NSDictionary *)dict {
    ZZPersonModel *obj = [[self alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    // 预防处理age超限
    if (obj.age <= 0 || obj.age >= 130) {
        obj.age = 0;
    }
    return obj;
}
// 预防处理没有找到的key
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

+ (void)loadPersonAsync:(void (^)(ZZPersonModel * _Nonnull))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 模拟网络延迟 2s
        [NSThread sleepForTimeInterval:2.0];
        ZZPersonModel *person = [ZZPersonModel personWithDict:@{@"name":@"zhang", @"age":@25}];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(person);
            }
        });
    });
}

@end
