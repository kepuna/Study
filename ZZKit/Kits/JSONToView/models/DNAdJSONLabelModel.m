//
//  DNAdJSONLabelModel.m
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONLabelModel.h"
#import "UIColor+DNAd.h"

@implementation DNAdJSONLabelModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionaryValue{
    DNAdJSONLabelModel *model = [DNAdJSONLabelModel new];
    [model setModelWithDictionary:dictionaryValue];
    return model;
}

-(void)setModelWithDictionary:(NSDictionary *)dictionaryValue
{
    [super setModelWithDictionary:dictionaryValue];
    self.numberOfLines = [[dictionaryValue objectForKey:@"numberOfLines"] integerValue];
    self.lineSpacing = [[dictionaryValue objectForKey:@"lineSpacing"] doubleValue];
    
    NSString *textColor = [dictionaryValue objectForKey:@"textColor"];
    if (textColor.length) {
        self.textColor = [UIColor nvColorWithHexString:textColor];
    }
    self.textSize = [[dictionaryValue objectForKey:@"textSize"] doubleValue];
    self.text = [dictionaryValue objectForKey:@"text"];
    
    
    //    NSArray *textList = [dictionaryValue objectForKey:@"textList"];
    //    NSMutableArray *subViewModels = [NSMutableArray array];
    //    for (NSDictionary *txt in textList) {
    //        MDJsonLabelContentModel *model = [MDJsonLabelContentModel modelWithDictionary:txt];
    //        if (model) {
    //            [subViewModels addObject:model];
    //        }
    //    }
    //    self.textList = subViewModels;
}

@end
