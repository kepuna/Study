//
//  ZZTextHighlightStorage.h
//  HighPerformance
//
//  Created by MOMO on 2020/7/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
// 文本高亮

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 自定义的 NSTextStorage 中真正实现字符存储操作的是 NSMutableAttributedString
 
 
 */

@interface ZZTextHighlightStorage : NSTextStorage

@end

NS_ASSUME_NONNULL_END
