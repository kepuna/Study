//
//  DNAdJSONLabel.m
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONLabel.h"
#import "UIView+DNAdFrame.h"

@implementation DNAdJSONLabel

- (void)setModel:(DNAdJSONLabelModel *)model
{
    _model = model;
    if (_model) {
        self.text = _model.text;
        [self obtainJsonLabelInfoWithModel:_model];
    }
}

- (BOOL)validateData:(NSString *)jsonString
{
    return [jsonString isKindOfClass:[NSString class]] || jsonString == nil;
}

- (void)obtainJsonLabelInfoWithModel:(DNAdJSONLabelModel *)model
{
    
    if (_model.backgroundColor) {
        self.backgroundColor = _model.backgroundColor;
    }
    
    if (_model.textColor) {
        self.textColor = _model.textColor;
    }
    
    if (model.corner) {
        self.layer.cornerRadius = model.corner;
        self.layer.masksToBounds = YES;
    }
    
    if (model.border) {
        self.layer.borderWidth = model.border;
        self.layer.borderColor = model.borderColor?model.borderColor.CGColor:[UIColor blackColor].CGColor;
    }
    
    self.numberOfLines = _model.numberOfLines;
    self.font = [self getFontWithModel:_model];
    if (model.event) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(s_tapEvent)];
        [self addGestureRecognizer:tap];
    }
}

- (void)s_tapEvent {
    NSLog(@"点击了Label");
}

- (UIFont *)getFontWithModel:(DNAdJSONLabelModel *)model
{
    UIFont *currentFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    //字体大小
    CGFloat fontSize = model.textSize;
    if (fabs(fontSize - 0) <= 0.5) {
        fontSize = currentFont.pointSize;
    }
    UIFont *jsonFont = [UIFont fontWithName:currentFont.fontName size:fontSize];
    return jsonFont;
}

@end
