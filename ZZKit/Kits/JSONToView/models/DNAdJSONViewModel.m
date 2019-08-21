//
//  DNAdJSONViewModel.m
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONViewModel.h"
#import "DNAdJSONMappers.h"

@implementation DNAdJSONViewModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionaryValue {
    DNAdJSONViewModel *model = [[DNAdJSONViewModel alloc] init];
    [model setModelWithDictionary:dictionaryValue];
    return model;
}

- (void)setModelWithDictionary:(NSDictionary *)dictionaryValue
{
    [super setModelWithDictionary:dictionaryValue];
    NSArray *subViews = [dictionaryValue objectForKey:@"subViews"];
    NSMutableArray *subViewModels = [NSMutableArray array];
    for (NSDictionary *subView in subViews) {
        NSString *viewType = [subView objectForKey:@"type"];
        Class modelCls = NSClassFromString([[DNAdJSONMappers new] obtainViewByType:viewType]);
        DNAdJSONModel *model = [modelCls modelWithDictionary:subView];
        if (model) {
            [subViewModels addObject:model];
        }
    }
    self.subViews = subViewModels;
}

@end
