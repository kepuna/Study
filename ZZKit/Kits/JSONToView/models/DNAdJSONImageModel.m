//
//  DNAdJSONImageModel.m
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONImageModel.h"

@implementation DNAdJSONImageModel


+ (instancetype)modelWithDictionary:(NSDictionary *)dictionaryValue {
    DNAdJSONImageModel *model = [[DNAdJSONImageModel alloc] init];
    [model setModelWithDictionary:dictionaryValue];
    return model;
}

-(void)setModelWithDictionary:(NSDictionary *)dictionaryValue
{
    [super setModelWithDictionary:dictionaryValue];
    self.url = [dictionaryValue objectForKey:@"url"];
    self.localImageName = [dictionaryValue objectForKey:@"localImageName"];
    self.isNeedCallBack = [dictionaryValue objectForKey:@"isNeedCallBack"];
    
}

@end
