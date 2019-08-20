//
//  ZZVideoTrimFrameCell.m
//  ZZKit
//
//  Created by donews on 2019/4/29.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZVideoTrimFrameCell.h"

@interface ZZVideoTrimFrameCell ()


@end

@implementation ZZVideoTrimFrameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.backgroundImageView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setImageWithCount:(NSInteger)count imagePath:(NSString *)savePath imageHeight:(CGFloat)height{
    NSString *imagePath = [NSString stringWithFormat:@"%@/IMG%ld.jpg",savePath,(long)count];
    self.backgroundImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    self.backgroundImageView.frame = CGRectMake(0, 0, 50, height);
}

@end
