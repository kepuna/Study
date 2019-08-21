//
//  DNAdJSONMappers.h
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNAdJSONMappers : NSObject


/**
 根据view的type返回不同Model类字符串

 @param key view的type类型
 */
- (NSString *)obtainViewByType:(NSString *)key;

@end

