//
//  ZZTextView.m
//  ZZMedia_Example
//
//  Created by MOMO on 2020/8/25.
//  Copyright © 2020 iPhoneHH. All rights reserved.
//

#import "ZZTextView.h"

@implementation ZZTextView


// 重写触摸开始函数
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 获取当前触摸位置的字符所属的字母(提示：触摸位置需向下调整10个点，以便与文本元素对齐)
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    touchPoint.y -= 10;

    // 获取点击的字母的位置
    NSInteger characterIndex = [self.layoutManager characterIndexForPoint:touchPoint inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
    
    // 获取单词的范围 range 由起始位置和长度构成。
    NSRange range = [self _getWordRange:characterIndex];
    [self _modifyAttributeInRange:range];  // 高亮单词
    
    [super touchesBegan:touches withEvent:event];
}

//获取单词的范围
- (NSRange)_getWordRange:(NSInteger)characterIndex {
    NSInteger left = characterIndex - 1;
    NSInteger right = characterIndex + 1;
    NSInteger length = 0;
    NSString *string = self.attributedText.string;

    // 往左遍历直到空格
    while (left >=0) {
        NSString *s=[string substringWithRange:NSMakeRange(left, 1)];

        if ([self _isLetter:s]) {
            left --;
        } else {
            break;
        }
    }

    // 往右遍历直到空格
    while (right < self.text.length) {
        NSString *s=[string substringWithRange:NSMakeRange(right, 1)];

        if ([self _isLetter:s]) {
            right ++;
        } else {
            break;
        }
    }

    // 此时 left 和 right 都指向空格
    left ++;
    right --;
 
    length = right - left + 1;
    NSRange range = NSMakeRange(left, length);

    return range;
}

//判断是否字母
- (BOOL)_isLetter:(NSString *)str {
    char letter = [str characterAtIndex:0];
    if ((letter >= 'a' && letter <='z') || (letter >= 'A' && letter <= 'Z')) {
        return YES;
    }
    return NO;
}

//修改属性字符串
- (void)_modifyAttributeInRange:(NSRange)range {

    
    
    NSString *string = self.attributedText.string.copy;
    NSDictionary *attrDict = self.typingAttributes;
    
    NSLog(@"-----%@---%@",string,NSStringFromRange(range));
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:string attributes:attrDict];

    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    [attrString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];
    self.attributedText = attrString;
    
    NSString *word = [string substringWithRange:range];
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(textView:didClickByWord:)]) {
        [self.customDelegate textView:self didClickByWord:word];
    }
    
}

// 禁止掉长按 复制、剪切...
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

// 禁止掉长按效果
- (BOOL)canBecomeFirstResponder {
    return NO;
}

@end
