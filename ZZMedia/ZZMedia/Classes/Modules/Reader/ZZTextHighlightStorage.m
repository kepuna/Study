//
//  ZZTextHighlightStorage.m
//  HighPerformance
//
//  Created by MOMO on 2020/7/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZTextHighlightStorage.h"

@interface ZZTextHighlightStorage ()

@end

@implementation ZZTextHighlightStorage {
    
    NSMutableAttributedString *_mutableAttributedString;
    NSRegularExpression       *_expression;
}

#pragma mark - @Overwrite
- (instancetype)init
{
    self = [super init];
    if (self) {
        _mutableAttributedString = [NSMutableAttributedString new];
        NSString *pattern = @"(\\*\\w+(\\s*\\w+)*\\s*\\*)";
        _expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    }
    return self;
}

- (NSString *)string {
    return _mutableAttributedString.string;
}

- (NSDictionary<NSAttributedStringKey, id> *)attributesAtIndex:(NSUInteger)location effectiveRange:(nullable NSRangePointer)range {
    return [_mutableAttributedString attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [self beginEditing];
    [_mutableAttributedString replaceCharactersInRange:range withString:str];
    [self edited:(NSTextStorageEditedCharacters) range:range changeInLength:str.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range {
    [self beginEditing];
    [_mutableAttributedString setAttributes:attrs range:range];
    [self edited: NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

// NSTextStorage 中下面这个方法在每次字符有变动的时候都会调用
// 在这个方法中，我们先清除当前可编辑的段落中之前的富文本属性，然后用正则去匹配我们的目标单词，进而给目标单词设置我们想要的属性
- (void)processEditing {
    
    [super processEditing];
    
    // 去除当前段落的颜色属性，
    NSRange paragaphRange = [self.string paragraphRangeForRange:self.editedRange];
    [self removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
    
    // 根据正则匹配，添加新属性
    [_expression enumerateMatchesInString:self.string options:NSMatchingReportProgress range:paragaphRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        [self addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
    }];
    
}

@end
