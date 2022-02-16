//
//  ZZAutoLayout1ViewController.m
//  ZZKit
//
//  Created by donews on 2019/6/25.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZAutoLayout1ViewController.h"

@interface ZZAutoLayout1ViewController ()

@property (nonatomic, strong) UIView *redview;
@property (nonatomic, strong) UIView *blueview;

@end

@implementation ZZAutoLayout1ViewController

/*
 
 代码实现AutoLayout要注意的点：
    1.要先禁止视图的autoresizing功能，视图的下列属性设置为NO：
        view.translatesAutoresizingMaskIntoConstraints = NO;
    2.添加约束之前，一定保证相关控件都已经添加到各自的父视图上。
    3.不再需要为视图设置frame。
 
 代码实现AutoLayout的步骤如下：
    1.创建一个NSLayoutConstraint类的实例对象作为具体的约束对象。将这个具体的约束对象添加到对应的视图上去
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.redview = [[UIView alloc] init];
    _redview.backgroundColor = [UIColor redColor];
    _redview.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.blueview = [[UIView alloc] init];
    _blueview.backgroundColor = [UIColor blueColor];
    _blueview.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_redview];
    [self.view addSubview:_blueview];
    
    //redview在垂直方向上距离边界为50
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.redview attribute:NSLayoutAttributeTop relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeTop) multiplier:1 constant:150];
    
    //设置redview的宽
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.redview attribute:(NSLayoutAttributeWidth) relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:200];
    
    //设置reaview的高
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.redview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:150];
    
    //redview距离左边界为50
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.redview attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:50];
    
//    // 蓝色试图和红色view等宽登高
//    NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:self.blueview attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:self.redview attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
//
//     NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:self.blueview attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:self.redview attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
//
//    NSLayoutConstraint *constraint7 = [NSLayoutConstraint constraintWithItem:self.blueview attribute:NSLayoutAttributeTop relatedBy:(NSLayoutRelationEqual) toItem:self.redview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
//
//    NSLayoutConstraint *constraint8 = [NSLayoutConstraint constraintWithItem:self.blueview attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-50];
    
    
    // 蓝色试图和红色view等宽登高
    NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:self.blueview attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:self.redview attribute:NSLayoutAttributeCenterY multiplier:1 constant:-10];
//
//    NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:self.blueview attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:self.redview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
     NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:self.blueview attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.redview attribute:NSLayoutAttributeRight multiplier:1 constant:10];
    
//        NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:self.blueview attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.redview attribute:NSLayoutAttributeRight multiplier:1 constant:10];
//
//        NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:self.blueview attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:self.redview attribute:NSLayoutAttributeTop multiplier:1 constant:10];
    
    NSLayoutConstraint *constraint7 = [NSLayoutConstraint constraintWithItem:self.blueview attribute:(NSLayoutAttributeWidth) relatedBy:NSLayoutRelationEqual toItem:self.redview attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    NSLayoutConstraint *constraint8 = [NSLayoutConstraint constraintWithItem:self.blueview attribute:(NSLayoutAttributeHeight) relatedBy:NSLayoutRelationEqual toItem:self.redview attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    
    [self.view addConstraint:constraint1];
    [self.view addConstraint:constraint2];
    [self.view addConstraint:constraint3];
    [self.view addConstraint:constraint4];
    [self.view addConstraint:constraint5];
    [self.view addConstraint:constraint6];
    [self.view addConstraint:constraint7];
    [self.view addConstraint:constraint8];
    
}


- (void)demo1 {}

@end
