//
//  DNAdJSONBaseModel.h
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNAdJSONBaseModel : NSObject

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionaryValue;
- (void)setModelWithDictionary:(NSDictionary *)dictionaryValue;

@end

