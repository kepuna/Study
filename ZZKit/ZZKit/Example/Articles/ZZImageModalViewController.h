//
//  ZZImageModalViewController.h
//  ZZKit
//
//  Created by donews on 2019/6/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZImageModalViewController : UIViewController

// default is UIViewContentModeScaleToFill
@property(nonatomic) UIViewContentMode contentMode;
 // When YES, content and subviews are clipped to the bounds of the view. Default is NO.
@property(nonatomic) BOOL clipsToBounds;

@end

NS_ASSUME_NONNULL_END
