//
//  AVVideoCutDragView.h
//  ZZKit
//
//  Created by donews on 2019/4/28.
//  Copyright © 2019年 donews. All rights reserved.
//  裁剪时左右拖拽的view

#import <UIKit/UIKit.h>

@interface AVVideoCutDragView : UIView

- (instancetype)initWithFrame:(CGRect)frame Left:(BOOL)left;

@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

/// 操作点是否在self视图上
- (BOOL)pointInsideSelf:(CGPoint)point;
/// 操作点是否在左右拖拽的条上
- (BOOL)pointInsideImgView:(CGPoint)point;

@end

