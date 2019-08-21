//
//  UIView+DNAdAutoLayout.m
//  JSONToView
//
//  Created by donews on 2019/6/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "UIView+DNAdAutoLayout.h"
#import "UIView+DNAdFrame.h"
#import "DNAdJSONModel.h"

// 判断字符串是否为空
#define DNAdStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length]< 1 ? YES : NO )

@implementation UIView (DNAdAutoLayout)

- (void)setWidthInView:(UIView *)rootView viewModel:(DNAdJSONModel *)viewModel {
    if (!viewModel.width|| isnan([viewModel.width floatValue])) {
        return;
    }
    CGFloat w = [viewModel.width floatValue];
    if (w > 0) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:w];
        [rootView addConstraint:constraint];
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeWidth multiplier:1 constant:-([viewModel.ml floatValue]+[viewModel.mr floatValue])];
        [rootView addConstraint:constraint];
    }
}

- (void)setHeightInView:(UIView *)rootView viewModel:(DNAdJSONModel *)viewModel {
    if (!viewModel.height || isnan([viewModel.height floatValue])) {
        return;
    }
    CGFloat h = [viewModel.height floatValue];
    if (h) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:h];
        [rootView addConstraint:constraint];
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeHeight multiplier:1 constant:-([viewModel.mt floatValue]+[viewModel.mb floatValue])];
        [rootView addConstraint:constraint];
    }
}

- (void)setLeftInView:(UIView *)rootView relativeView:(UIView *)relativeView equalView:(UIView *)equalView viewModel:(DNAdJSONModel *)viewModel {
    
    CGFloat left = [viewModel.ml floatValue];
    if (equalView) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:equalView attribute:NSLayoutAttributeLeft multiplier:1 constant:left];
        [rootView addConstraint:constraint];
    } else if (!viewModel.ml || isnan([viewModel.ml floatValue])) {
        return;
    } else if (relativeView) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:relativeView attribute:NSLayoutAttributeRight multiplier:1 constant:left];
        [rootView addConstraint:constraint];
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeLeft multiplier:1 constant:left];
        [rootView addConstraint:constraint];
    }
    
}

- (void)setTopInView:(UIView *)rootView relativeView:(UIView *)relativeView equalView:(UIView *)equalView viewModel:(DNAdJSONModel *)viewModel {
    
    CGFloat top = [viewModel.mt floatValue];
    if (equalView) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:equalView attribute:NSLayoutAttributeTop multiplier:1 constant:top];
        [rootView addConstraint:constraint];
    } else if (!viewModel.mt || isnan([viewModel.mt floatValue])) {
        return;
    } else if (relativeView) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:relativeView attribute:NSLayoutAttributeBottom multiplier:1 constant:top];
        [rootView addConstraint:constraint];
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeTop multiplier:1 constant:top];
        [rootView addConstraint:constraint];
    }
}

- (void)setRightInView:(UIView *)rootView relativeView:(UIView *)relativeView equalView:(UIView *)equalView viewModel:(DNAdJSONModel *)viewModel {
    
    CGFloat right = [viewModel.mr floatValue];
    if (equalView) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:equalView attribute:NSLayoutAttributeRight multiplier:1 constant:-(right)];
        [rootView addConstraint:constraint];
    } else if (!viewModel.mr || isnan([viewModel.mr floatValue])) {
        return;
    } else if (relativeView) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:relativeView attribute:NSLayoutAttributeLeft multiplier:1 constant:-(right)];
        [rootView addConstraint:constraint];
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeRight multiplier:1 constant:-(right)];
        [rootView addConstraint:constraint];
    }
}

- (void)setBottomInView:(UIView *)rootView relativeView:(UIView *)relativeView equalView:(UIView *)equalView viewModel:(DNAdJSONModel *)viewModel {
    
    CGFloat bottom = [viewModel.mb floatValue];
    if (equalView) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:equalView attribute:NSLayoutAttributeBottom multiplier:1 constant:-(bottom)];
        [rootView addConstraint:constraint];
    } else if (!viewModel.mb || isnan([viewModel.mb floatValue])) {
        return;
    } else if (relativeView) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:relativeView attribute:NSLayoutAttributeTop multiplier:1 constant:-(bottom)];
        [rootView addConstraint:constraint];
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeBottom multiplier:1 constant:-(bottom)];
        [rootView addConstraint:constraint];
    }
}

- (void)setCenterXInView:(UIView *)rootView relativeView:(UIView *)relativeView viewModel:(DNAdJSONModel *)viewModel {
    if (!viewModel.centerV || isnan( [viewModel.centerV floatValue])) {
        return;
    }
    CGFloat x = [viewModel.centerV floatValue];
    if (relativeView) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:relativeView attribute:NSLayoutAttributeCenterX multiplier:1 constant:x];
        [rootView addConstraint:constraint];
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeCenterX multiplier:1 constant:x];
        [rootView addConstraint:constraint];
    }
   
}

- (void)setCenterYInView:(UIView *)rootView relativeView:(UIView *)relativeView viewModel:(DNAdJSONModel *)viewModel {
    if (!viewModel.centerH || isnan( [viewModel.centerH floatValue])) {
        return;
    }
    CGFloat y = [viewModel.centerH floatValue];
    if (relativeView) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:relativeView attribute:NSLayoutAttributeCenterY multiplier:1 constant:y];
        [rootView addConstraint:constraint];
    } else {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeCenterY multiplier:1 constant:y];
        [rootView addConstraint:constraint];
    }
}

//- (void)setCenterX:(NSString *)centerX inView:(UIView *)rootView relativeView:(UIView *)relativeView {
//    if (DNAdStringIsEmpty(centerX) || isnan( [centerX floatValue])) {
//        return;
//    }
//    CGFloat x = [centerX floatValue];
//    if (relativeView) {
//        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:relativeView attribute:NSLayoutAttributeCenterX multiplier:1 constant:x];
//        [rootView addConstraint:constraint];
//    } else {
//        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeCenterX multiplier:1 constant:x];
//        [rootView addConstraint:constraint];
//    }
//}

//- (void)setCenterY:(NSString *)centerY inView:(UIView *)rootView relativeView:(UIView *)relativeView {
//    if (DNAdStringIsEmpty(centerY) || isnan( [centerY floatValue])) {
//        return;
//    }
//    CGFloat y = [centerY floatValue];
//
//    if (relativeView) {
//        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:relativeView attribute:NSLayoutAttributeCenterY multiplier:1 constant:y];
//        [rootView addConstraint:constraint];
//    } else {
//        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeCenterY multiplier:1 constant:y];
//        [rootView addConstraint:constraint];
//    }
//}



- (void)equalWidthInView:(UIView *)rootView relativeView:(UIView *)relativeView {
    if (relativeView) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:relativeView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        [rootView addConstraint:constraint];
    }
}

- (void)equalHeightInView:(UIView *)rootView relativeView:(UIView *)relativeView {
    if (relativeView) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:relativeView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        [rootView addConstraint:constraint];
    }
}


@end
