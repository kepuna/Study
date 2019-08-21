//
//  UIColor+DNAd.h
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (DNAd)

+ (UIColor *)nvColorWithHexString:(NSString *)hexString;
+ (UIColor *)nvColorWithIntRed:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b;
+ (UIColor *)nvColorWithIntRed:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b alpha:(NSInteger)a;

@end
