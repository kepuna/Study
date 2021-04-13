//
//  ZZPhotoAlbumCell.m
//  HighPerformance
//
//  Created by MOMO on 2020/10/26.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZPhotoAlbumCell.h"

@interface ZZPhotoAlbumCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end
@implementation ZZPhotoAlbumCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView  = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
