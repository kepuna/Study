//
//  ZZPublic.h
//  ZZKit
//
//  Created by donews on 2019/4/25.
//  Copyright © 2019年 donews. All rights reserved.
//

#ifndef ZZPublic_h
#define ZZPublic_h


#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)

// 适配iOS 11 & iPhoneX

#define iPhoneX ([UIScreen mainScreen].bounds.size.height >=812 ? YES :NO)

#define IPhoneXSefeAreaBottom(y) (iPhoneX?ceil(y+24):y)
//#define IPHONEX_Y(y)(iPhoneX?ceil(y-34):y)

#define IPhoneStatuBarH (iPhoneX ? 44.00 : 20.00)
#define IPhoneNavH (IPhoneStatuBarH + 44)

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]



///-----------
/// 短视频编辑
///-----------
#define kMaxVideoDuration 15.0  // 视频时长最大限制
#define kMinVideoDuration 2.0 // 视频时长最小限制
#define kDefaultImageCount 10.0 // 默认视频拆分帧数


///-----------
/// 常用类头文件
///-----------
#import <YYCategories/UIView+YYAdd.h>



#endif /* ZZPublic_h */
