//
//  AVVideoCutDragView.m
//  ZZKit
//
//  Created by donews on 2019/4/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "AVVideoCutDragView.h"

@interface AVVideoCutDragView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic ,assign) BOOL isLeft;

@end

@implementation AVVideoCutDragView

- (instancetype)initWithFrame:(CGRect)frame Left:(BOOL)left {
    if (self = [super initWithFrame:frame]) {
        self.isLeft = left;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backView];
        [self addSubview:self.imgView];
    }
    return self;
}

#pragma mark - Getters & Setters
- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.6;
    }
    return _backView;
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        CGRect frame = CGRectZero;
        if (self.isLeft) {
            frame = CGRectMake(width-10, 0, 10, height);
        }
        else {
            frame = CGRectMake(0, 0, 10, height);
        }
        _imgView = [[UIImageView alloc] initWithFrame:frame];
        _imgView.image = [UIImage imageNamed:@"drag.jpg"];
    }
    return _imgView;
}

// 该方法用来判断点击事件发生的位置是否处于当前视图范围内
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return [self pointInsideSelf:point];
}

- (BOOL)pointInsideSelf:(CGPoint)point{
    CGRect relativeFrame = self.bounds;
    // UIEdgeInsetsInsetRect 在原先的rect上内切出另一个rect出来，-为变大，+为变小
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, _hitTestEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}

- (BOOL)pointInsideImgView:(CGPoint)point{
    CGRect relativeFrame = self.imgView.frame;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, _hitTestEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}


@end
