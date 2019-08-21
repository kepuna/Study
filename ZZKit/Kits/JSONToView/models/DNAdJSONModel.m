//
//  DNAdJSONModel.m
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONModel.h"
#import "UIColor+DNAd.h"

@implementation DNAdJSONModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionaryValue {
    DNAdJSONModel *model = [[DNAdJSONModel alloc] init];
    [model setModelWithDictionary:dictionaryValue];
    return model;
}

-(void)setModelWithDictionary:(NSDictionary *)dictionaryValue
{
    self.type = [dictionaryValue objectForKey:@"type"];
    NSString *backgroundColorHex = [dictionaryValue objectForKey:@"bgColor"];
    NSString *borderColorHex = [dictionaryValue objectForKey:@"borderColor"];
    if (backgroundColorHex.length) {
        self.backgroundColor = [UIColor nvColorWithHexString:backgroundColorHex];
    }
    if (borderColorHex.length) {
        self.borderColor = [UIColor nvColorWithHexString:borderColorHex];
    }
    self.event = [dictionaryValue objectForKey:@"event"];
    
    self.viewId = [dictionaryValue objectForKey:@"vid"];
    self.rmlId = [dictionaryValue objectForKey:@"rmlId"];
    self.rmrId = [dictionaryValue objectForKey:@"rmrId"];
    self.rmtId = [dictionaryValue objectForKey:@"rmtId"];
    self.rmbId = [dictionaryValue objectForKey:@"rmbId"];
    
    self.chId = [dictionaryValue objectForKey:@"chId"];
    self.cvId =  [dictionaryValue objectForKey:@"cvId"];
    
    self.equalLeftId = [dictionaryValue objectForKey:@"elId"];
    self.equalRightId = [dictionaryValue objectForKey:@"erId"];
    self.equalTopId = [dictionaryValue objectForKey:@"etId"];
    self.equalBottomId = [dictionaryValue objectForKey:@"ebId"];
    self.equalWidthId = [dictionaryValue objectForKey:@"ewId"];
    self.equalHeightId = [dictionaryValue objectForKey:@"ehId"];
    
    self.mt = [dictionaryValue objectForKey:@"mt"];
    self.ml = [dictionaryValue objectForKey:@"ml"];
    self.mr = [dictionaryValue objectForKey:@"mr"];
    self.mb = [dictionaryValue objectForKey:@"mb"];
    self.height = [dictionaryValue objectForKey:@"h"];
    self.width = [dictionaryValue objectForKey:@"w"];
    
    self.centerH = [dictionaryValue objectForKey:@"ch"] ;
    self.centerV = [dictionaryValue objectForKey:@"cv"] ;
    self.corner =  [[dictionaryValue objectForKey:@"corner"] floatValue];
    self.border = [[dictionaryValue objectForKey:@"border"] floatValue];
    if (isnan(self.corner)) {
        self.corner = 0;
    }
    if (isnan(self.border)) {
        self.border = 0;
    }
}


@end
