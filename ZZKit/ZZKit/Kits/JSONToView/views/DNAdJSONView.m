//
//  DNAdJSONView.m
//  JSONToView
//
//  Created by donews on 2019/6/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONView.h"

@implementation DNAdJSONView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setModel:(DNAdJSONViewModel *)model
{
    _model = model;
    if (_model) {
        [self creatJsonTopViewWithModel:_model];
    }
}


- (void)creatJsonTopViewWithModel:(DNAdJSONViewModel *)model
{
    if (![model isKindOfClass:[DNAdJSONViewModel class]]) return;
    if (!model || ![model.type isEqualToString:@"view"]) {
        self.backgroundColor = [UIColor blackColor];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    } else {
        //背景色
        if (model.backgroundColor) {
            self.backgroundColor = model.backgroundColor;
        }
        if (model.corner) {
            self.layer.cornerRadius = model.corner;
        }
        if (model.border) {
            self.layer.borderWidth = model.border;
            self.layer.borderColor = model.borderColor?model.borderColor.CGColor:[UIColor blackColor].CGColor;
        }
        if (model.event) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(s_tapEvent)];
            [self addGestureRecognizer:tap];
        }
    }
}

- (void)s_tapEvent {
    NSLog(@"点击了JSONView");
}

@end
