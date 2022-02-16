//
//  DNAdJSONStackViewModel.m
//  JSONToView
//
//  Created by donews on 2019/6/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONStackViewModel.h"
#import "DNAdJSONMappers.h"

@implementation DNAdJSONStackViewModel

+(instancetype)modelWithDictionary:(NSDictionary *)dictionaryValue
{
    DNAdJSONStackViewModel *model = [DNAdJSONStackViewModel new];
    [model setModelWithDictionary:dictionaryValue];
    return model;
}

- (void)setModelWithDictionary:(NSDictionary *)dictionaryValue
{
    [super setModelWithDictionary:dictionaryValue];
    NSString *layout = [dictionaryValue objectForKey:@"layout"];
    self.spacing = [[dictionaryValue objectForKey:@"spacing"] floatValue];
    if ([layout isEqualToString:@"V"]) {
        self.layout = UILayoutConstraintAxisVertical;
    } else {
        self.layout = UILayoutConstraintAxisHorizontal;
    }
    
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
