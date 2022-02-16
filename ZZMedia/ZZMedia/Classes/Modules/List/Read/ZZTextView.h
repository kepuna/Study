//
//  ZZTextView.h
//  ZZMedia_Example
//
//  Created by MOMO on 2020/8/25.
//  Copyright © 2020 iPhoneHH. All rights reserved.
//

/*
 需求：获取点击 UITextView 的某个单词，高亮显示。

 思路：创建 textView 的子类。先获取 touchPoint，然后用 textView.layoutManager 的 characterIndexForPoint: 方法获取点击的字符的位置，从位置向前后遍历直到遇到空格就能获取点击的单词的 NSRange，有了 range 就能获取点击的单词，或者高亮显示。
 */
#import <UIKit/UIKit.h>
@class ZZTextView;
NS_ASSUME_NONNULL_BEGIN

@protocol ZZTextViewDelegate <NSObject>

@optional;
- (void)textView:(ZZTextView *)textView didClickByWord:(NSString *)word;

@end

@interface ZZTextView : UITextView
@property (nonatomic, weak) id<ZZTextViewDelegate> customDelegate;
@end

NS_ASSUME_NONNULL_END
