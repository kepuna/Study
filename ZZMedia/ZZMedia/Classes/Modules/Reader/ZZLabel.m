//
//  ZZLabel.m
//  HighPerformance
//
//  Created by MOMO on 2020/7/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZLabel.h"

@interface ZZLabel ()

@property (nonatomic, strong) NSMutableArray <NSAttributedString *> *subAttributedStringsArrM; /// 子串数组

@property (nonatomic, strong) NSMutableArray <NSValue *> *subAttributedStringRangesArrM; /// Range数组

@property (nonatomic, strong) NSMutableArray <TextKitStringBlock> *stringOptionsArrM; // Block数组

@property (nonatomic, strong) NSTextStorage *textStorage;

@property (nonatomic, strong) NSLayoutManager *layoutManager;

@property (nonatomic, strong) NSTextContainer *textContainer;

@end

@implementation ZZLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.subAttributedStringsArrM = [NSMutableArray array];
        self.subAttributedStringRangesArrM = [NSMutableArray array];
        self.stringOptionsArrM = [NSMutableArray array];
        /// 初始化TextKit的配置
        [self setupSystemTextKitConfiguration];
    }
    return self;
}

#pragma mark -  Overwrite
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textContainer.size = self.bounds.size;
}

- (void)drawTextInRect:(CGRect)rect {

    [super drawTextInRect:rect];
    NSRange range = NSMakeRange(0, self.textStorage.length);
    [self.layoutManager drawBackgroundForGlyphRange:range atPoint:CGPointMake(0.0, 0.0)];
    [self.layoutManager drawGlyphsForGlyphRange:range atPoint:CGPointMake(0.0, 0.0)];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    //根据点来获取该位置glyph的index
    NSInteger glythIndex = [self.layoutManager glyphIndexForPoint:point inTextContainer:self.textContainer];
    
     //获取该glyph对应的rect
    CGRect glythRect = [self.layoutManager boundingRectForGlyphRange:NSMakeRange(glythIndex, 1) inTextContainer:self.textContainer];

    //最终判断该字形的显示范围是否包括点击的location
    if (CGRectContainsPoint(glythRect, point)) {
        NSInteger characterIndex = [self.layoutManager characterIndexForGlyphAtIndex:glythIndex];
        [self.subAttributedStringRangesArrM enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = obj.rangeValue;
            if (NSLocationInRange(characterIndex, range)) {
                TextKitStringBlock block = self.stringOptionsArrM[idx];
                block(self.subAttributedStringsArrM[idx]);
            }
        }];
    }
}

#pragma mark -  Public Function

- (void)appendString:(NSAttributedString *)attributeString attrStringBlock:(TextKitStringBlock)attrStringBlock {
    
    [self.subAttributedStringsArrM addObject:attributeString];
    
    // 获取子串在storage中的range
    NSRange range = NSMakeRange(self.textStorage.length, attributeString.length);
    [self.subAttributedStringRangesArrM addObject:[NSValue valueWithRange:range]];
    
    [self.stringOptionsArrM addObject:attrStringBlock];
    [self.textStorage appendAttributedString:attributeString];
}

#pragma mark -  Private Function

- (void)setupSystemTextKitConfiguration
{
    // textStorage 存储要显示的字符串
    self.textStorage = [[NSTextStorage alloc] init];

    // layoutManager管理显示字符串的布局
    self.layoutManager = [[NSLayoutManager alloc] init];

    // textContainer 决定字符串显示的区域
    self.textContainer = [[NSTextContainer alloc] init];

    // NSTextStorage 这个方法来添加一个布局对象
    [self.textStorage addLayoutManager:self.layoutManager];

    // NSLayoutManager中的这个方法来添加一个显示区域对象
    [self.layoutManager addTextContainer:self.textContainer];
}

#pragma mark -  Getter && Setter

- (void)setText:(NSString *)text {
    [super setText:text];
      NSLog(@">>>>>>>> = %@",self.text);
    [self setupSystemTextKitConfiguration];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
      NSLog(@">>>>>>>>== = %@",attributedText);
    [self setupSystemTextKitConfiguration];
}

@end
