//
//  ZZAutoLayout2ViewController.m
//  ZZKit
//
//  Created by donews on 2019/6/25.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZAutoLayout2ViewController.h"

@interface ZZAutoLayout2ViewController ()

@property (nonatomic, strong) UIView *adView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *downloadLabel;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ZZAutoLayout2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.adView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.downloadLabel];
    [self.view addSubview:self.imgView];
    
    self.adView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.downloadLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // adView的布局
    NSLayoutConstraint *adviewLayout1 = [NSLayoutConstraint constraintWithItem:self.adView attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    NSLayoutConstraint *adviewLayout2 = [NSLayoutConstraint constraintWithItem:self.adView attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    NSLayoutConstraint *adviewLayout3 = [NSLayoutConstraint constraintWithItem:self.adView attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:100];
    
    NSLayoutConstraint *adviewLayout4 = [NSLayoutConstraint constraintWithItem:self.adView attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:220];
    
    NSLayoutConstraint *titleLayout1 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.adView attribute:NSLayoutAttributeLeft multiplier:1 constant:15];
    
    NSLayoutConstraint *titleLayout2 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self.adView attribute:NSLayoutAttributeRight multiplier:1 constant:-15];
    
    NSLayoutConstraint *titleLayout3 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:self.adView attribute:NSLayoutAttributeTop multiplier:1 constant:10];
    
    NSLayoutConstraint *titleLayout4 = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
    
    
    NSLayoutConstraint *descLayout1 = [NSLayoutConstraint constraintWithItem:self.descLabel attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.titleLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    NSLayoutConstraint *descLayout2 = [NSLayoutConstraint constraintWithItem:self.descLabel attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self.adView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    
     NSLayoutConstraint *descLayout3 = [NSLayoutConstraint constraintWithItem:self.descLabel attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:20];
    
    NSLayoutConstraint *descLayout4 = [NSLayoutConstraint constraintWithItem:self.descLabel attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80];
    
    NSLayoutConstraint *imgLayout1 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.titleLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    
    NSLayoutConstraint *imgLayout2 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self.titleLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    NSLayoutConstraint *imgLayout3 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    
     NSLayoutConstraint *imgLayout4 = [NSLayoutConstraint constraintWithItem:self.imgView attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self.descLabel attribute:NSLayoutAttributeTop multiplier:1 constant:-10];
    
    
    [self.view addConstraint:adviewLayout1];
    [self.view addConstraint:adviewLayout2];
    [self.view addConstraint:adviewLayout3];
    [self.view addConstraint:adviewLayout4];
    
    [self.view addConstraint:titleLayout1];
     [self.view addConstraint:titleLayout2];
     [self.view addConstraint:titleLayout3];
     [self.view addConstraint:titleLayout4];
    
    [self.view addConstraint:descLayout1];
    [self.view addConstraint:descLayout2];
    [self.view addConstraint:descLayout3];
    [self.view addConstraint:descLayout4];
    
    [self.view addConstraint:imgLayout1];
     [self.view addConstraint:imgLayout2];
     [self.view addConstraint:imgLayout3];
     [self.view addConstraint:imgLayout4];
    
}

#pragma mark - Getters & Setters
- (UIView *)adView {
    if (_adView == nil) {
        _adView = [[UIView alloc] init];
        _adView.backgroundColor = [UIColor lightGrayColor];
    }
    return _adView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor darkGrayColor]];
        _titleLabel.text = @"这是一个广告的标题";
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc] init];
        [_descLabel setTextColor:[UIColor darkGrayColor]];
        _descLabel.text = @"广告描述";
    }
    return _descLabel;
}

- (UILabel *)downloadLabel {
    if (_downloadLabel == nil) {
        _downloadLabel = [[UILabel alloc] init];
        [_downloadLabel setTextColor:[UIColor darkGrayColor]];
        _downloadLabel.text = @"立即下载";
    }
    return _downloadLabel;
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor yellowColor];
    }
    return _imgView;
}

@end
