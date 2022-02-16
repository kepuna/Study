//
//  ZZLabel.h
//  HighPerformance
//
//  Created by MOMO on 2020/7/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TextKitStringBlock)(NSAttributedString *attributeString);

@interface ZZLabel : UILabel

//字符串更新并添加回调
- (void)appendString:(NSAttributedString *)attributeString attrStringBlock:(TextKitStringBlock)attrStringBlock;

@end

NS_ASSUME_NONNULL_END
