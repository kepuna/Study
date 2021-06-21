//
//  ZZVideoTrimFrameCell.h
//  ZZKit
//
//  Created by donews on 2019/4/29.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZZVideoTrimFrameCell : UITableViewCell

@property (nonatomic, strong) UIImageView *backgroundImageView;
- (void)setImageWithCount:(NSInteger)count imagePath:(NSString *)savePath imageHeight:(CGFloat)height;

@end

