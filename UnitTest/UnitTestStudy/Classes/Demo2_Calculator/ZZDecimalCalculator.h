//
//  ZZDecimalCalculator.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/11/5.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

/**
 ### 案例
 
 项目中后台金额相关的接口返回都是以“分”为单位，但是实际展示或计算时需要以“元”为单位，同时为了避免 Float、Double 等类型计算带来的误差，所以这里有一个简单的十进制数计算工具类来进行项目中的金额转换和计算


 本类提供了“元”转“分” 和 “分”转“元”的快捷方法
 以及一个自定义的十进制数运算
 
 🤔️ 通常情况下对于这样一个工具类使用单元测试应该如何测试 ？？
 
 查看在XCTest框架下编写的用例： ZZDecimalCalculatorTest
 
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 运算类型 */
typedef NS_ENUM(NSUInteger, ZZDecimalCalculatorCalculationType) {
    ZZDecimalCalculatorCalculationTypeAdding,       /** 加法 */
    ZZDecimalCalculatorCalculationTypeSubtracting,  /** 减法 */
    ZZDecimalCalculatorCalculationTypeMultiplying,  /** 乘法 */
    ZZDecimalCalculatorCalculationTypeDividing      /** 除法 */
};

/** 舍入运算类型 */
typedef NS_ENUM(NSUInteger, ZZDecimalCalculatorRoundingModeType) {
    ZZDecimalCalculatorRoundingModeTypeRoundPlain,  /** 四舍五入 */
    ZZDecimalCalculatorRoundingModeTypeNSRoundDown, /** 去尾法 */
    ZZDecimalCalculatorRoundingModeTypeNSRoundUp    /** 进一法 */
};

@interface ZZDecimalCalculator : NSObject

+ (instancetype)shareInstance;

/**
 ”分“转换为”元“，进一法 保留两位小数
 
 @param centsString “分”字符串
 @return “元”字符串
 
 */
- (NSString *)convertCentsIntoYuan:(NSString *)centsString;


/**
 ”元“转换为”分“，进一法保留零位小数
 
 @param yuanString “元”字符串
 @return ”分“字符串
 
 */
- (NSString *)convertYuanIntoCents:(NSString *)yuanString;


/**
 自定义十进制计算
 
 @param numOneString 计算数字一（减法为被减数，除法为被除数）
 @param numTwoString 计算数字二（减法为减数，除法为除数）
 @param calculationType 运算类型（加、减、乘、除）
 @param scale 保留精确位（小数点后零省去）
 @param roundingMode 舍入运算类型
 @return 计算结果（异常状态返回空字符串@""）
 */
- (NSString *)calculateNumOne:(NSString *)numOneString
                       numTwo:(NSString *)numTwoString
              calculationType:(ZZDecimalCalculatorCalculationType)calculationType
                        scale:(NSUInteger)scale
                 roundingMode:(ZZDecimalCalculatorRoundingModeType)roundingMode;

@end

NS_ASSUME_NONNULL_END
