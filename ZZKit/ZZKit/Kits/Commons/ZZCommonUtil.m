//
//  ZZCommonUtil.m
//  ZZKit
//
//  Created by MOMO on 2021/5/13.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZCommonUtil.h"

@implementation ZZCommonUtil

+(NSString *)bundlePath:(NSString *)fileName {
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+(NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}


@end
