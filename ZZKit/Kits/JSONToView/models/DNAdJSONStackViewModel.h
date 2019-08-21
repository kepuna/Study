//
//  DNAdJSONStackViewModel.h
//  JSONToView
//
//  Created by donews on 2019/6/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONModel.h"

@interface DNAdJSONStackViewModel : DNAdJSONModel

/**
 StackView内的视图数组
 */
@property (nonatomic, strong) NSArray <DNAdJSONModel *> *subViews;

/**
 布局模式 默认是Horizontal
 */
@property (nonatomic, assign) UILayoutConstraintAxis layout;

/**
 设置StackView内视图之间的间距
 */
@property(nonatomic) CGFloat spacing;

@end

