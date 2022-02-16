//
//  ZZRecogizeCardManager.h
//  ZZMedia_Example
//
//  Created by MOMO on 2020/9/16.
//  Copyright © 2020 iPhoneHH. All rights reserved.
// https://www.jianshu.com/p/ac4c4536ca3e

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^CompleateBlock)(NSString *text);

@interface ZZRecogizeCardManager : NSObject


/**
*  初始化一个单例
*
*  @return 返回一个RecogizeCardManager的实例对象
*/
+ (instancetype)recognizeCardManager;

/**
*  根据身份证照片得到身份证号码
*
*  @param cardImage 传入的身份证照片
*  @param compleate 识别完成后的回调
*/
- (void)recognizeCardWithImage:(UIImage *)cardImage compleate:(CompleateBlock)compleate;

@end

