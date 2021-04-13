//
//  MMLogView.h
//  HighPerformance
//
//  Created by MOMO on 2021/3/3.
//  Copyright © 2021 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMLogView : UIView

- (void)updateLog:(NSString *)logText;

@property (nonatomic, copy) void(^indexBlock)(NSInteger index);

@property (nonatomic, copy) void(^cleanButtonIndexBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
