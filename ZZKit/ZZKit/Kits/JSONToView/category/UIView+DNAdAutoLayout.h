//
//  UIView+DNAdAutoLayout.h
//  JSONToView
//
//  Created by donews on 2019/6/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DNAdJSONModel;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DNAdAutoLayout)


- (void)setWidthInView:(UIView *)rootView viewModel:(DNAdJSONModel *)viewModel;

- (void)setHeightInView:(UIView *)rootView viewModel:(DNAdJSONModel *)viewModel;

/**
 在某个控件 左边的margin
 比如 B控件在A控件的左边 10pt
 这里relativeView指的就是A控件 left就是10pt (传入rml)
 */
- (void)setLeftInView:(UIView *)rootView relativeView:(nullable UIView  *)relativeView equalView:(nullable UIView *)equalView viewModel:(DNAdJSONModel *)viewModel;

/**
 在某个控件 右边的margin
 */
- (void)setRightInView:(UIView *)rootView relativeView:(nullable UIView  *)relativeView equalView:(nullable UIView *)equalView viewModel:(DNAdJSONModel *)viewModel;

/**
 在某个控件 上边的margin
 */
- (void)setTopInView:(UIView *)rootView relativeView:(nullable UIView *)relativeView equalView:(nullable UIView *)equalView viewModel:(DNAdJSONModel *)viewModel;

/**
 在某个控件 下边的margin
 */
- (void)setBottomInView:(UIView *)rootView relativeView:(nullable UIView  *)relativeView equalView:(nullable UIView *)equalView viewModel:(DNAdJSONModel *)viewModel;

/**
 相对某个控件的CenterX
 
 @param centerX 距离CenterX的偏移量
 @param rootView 父控件
 @param relativeView 参照物控件
 */
- (void)setCenterXInView:(UIView *)rootView relativeView:(nullable UIView  *)relativeView viewModel:(DNAdJSONModel *)viewModel;
- (void)setCenterYInView:(UIView *)rootView relativeView:(nullable UIView  *)relativeView viewModel:(DNAdJSONModel *)viewModel;

- (void)equalWidthInView:(UIView *)rootView relativeView:(nullable UIView  *)relativeView;
- (void)equalHeightInView:(UIView *)rootView relativeView:(nullable UIView  *)relativeView;

@end

NS_ASSUME_NONNULL_END
