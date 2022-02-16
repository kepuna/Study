//
//  MMCircleMenu.h
//  HighPerformance
//
//  Created by MOMO on 2021/3/3.
//  Copyright © 2021 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSInteger, MMIconType) {
    
    MMIconTypePlus = 0, // +
    MMIconTypeUserDraw,  // 用户自定义
    MMIconTypeCustomImage, // 图
};

NS_ASSUME_NONNULL_BEGIN

@interface MMCircleMenu : UIControl

/**
 *  中间按钮大小 ; 默认(50,50)
 */
@property (nonatomic, assign) CGSize centerButtonSize;

/**
 *  类型
 */
@property (nonatomic, assign) MMIconType centerIconType;

/**
 *  默认为 nil,  KFIconTypeCustomImage 才有效
 */
@property (nonatomic, strong) UIImage* centerIcon;

/**
 *  主色
 */
@property (nonatomic, strong) UIColor* mainColor;

/**
 *  config function
 *
 *  @param icons        icon 数组
 *  @param innerCircleRadius  内径半径
 */
- (void)loadButtonWithIcons:(NSArray<UIImage*>*)icons innerCircleRadius:(CGFloat)innerCircleRadius;

/**
 *
 */
@property (nonatomic, strong) void (^buttonClickBlock) (NSInteger idx);

/**
 *  MMIconTypeUserDraw, 可在这里自定义
 */
@property (nonatomic, strong) void (^drawCenterButtonIconBlock)(CGRect rect , UIControlState state);


@property (nonatomic, assign) BOOL isOpened;


/**
 * 打开菜单后的偏移量
 */
@property (nonatomic, assign) CGSize offsetAfterOpened;

@end

NS_ASSUME_NONNULL_END
