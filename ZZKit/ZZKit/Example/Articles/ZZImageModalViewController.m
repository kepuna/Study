//
//  ZZImageModalViewController.m
//  ZZKit
//
//  Created by donews on 2019/6/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZImageModalViewController.h"

@interface ZZImageModalViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *imageView1;

@end

@implementation ZZImageModalViewController

/*
 
 在开发当中有时会有这样的需求,将从服务器端下载下来的图片添加到imageView 当中展示
 但是下载下来的图片尺寸大小不固定,宽高也有可能不成比例
 如果直接设置imageView的image属性而不设置contentMode那么图片会默认填满整个容器,导致图片变形,影响美观.
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.imageView1];
    
    self.imageView.contentMode = self.contentMode;
    self.imageView1.contentMode = self.contentMode;
    self.imageView.clipsToBounds = self.clipsToBounds;
    self.imageView1.clipsToBounds =  self.clipsToBounds;
    
//    很明显感觉到人物已经变形了 .UIView 提供了1个属性 UIViewContentMode 来设置内容的填充模式
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        CGRect frame = CGRectMake(10, 200, self.view.bounds.size.width - 20, 150);
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.image = [UIImage imageNamed:@"PIC_1.jpeg"];
        _imageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _imageView;
}

- (UIImageView *)imageView1 {
    if (_imageView1 == nil) {
        
        CGRect frame = CGRectMake(10, CGRectGetMaxY(self.imageView.frame) + 20, self.view.bounds.size.width - 20, 150);
        _imageView1 = [[UIImageView alloc] initWithFrame:frame];
        _imageView1.image = [UIImage imageNamed:@"P1.jpeg"];
        _imageView1.backgroundColor = [UIColor lightGrayColor];
    }
    return _imageView1;
}
@end
