//
//  ZZAutoLayout0ViewController.m
//  ZZKit
//
//  Created by donews on 2019/6/19.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZAutoLayout0ViewController.h"

@interface ZZAutoLayout0ViewController ()

@end

@implementation ZZAutoLayout0ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *adView = [[UIView alloc] init];
    adView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:adView];
    
    //    1.首先，创建视图控件，添加到self.view上
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.backgroundColor = [UIColor redColor];
    [adView addSubview:imgView];
    
    UILabel *text1 = [[UILabel alloc] init];
    text1.text = @"标题";
    text1.backgroundColor = [UIColor greenColor];
    [adView addSubview:text1];
    
    adView.translatesAutoresizingMaskIntoConstraints = NO;
    imgView.translatesAutoresizingMaskIntoConstraints = NO;
    text1.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSNumber *margin = @(10);
    NSNumber *spacing = @(5);
    NSDictionary *views = NSDictionaryOfVariableBindings(adView,imgView,text1);
     NSDictionary *mertrics = NSDictionaryOfVariableBindings(margin,spacing);
    
     NSString *vfl = @"|-margin-[adView]-margin-|";
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:mertrics views:views];
    [self.view addConstraints:constraints];
    
    NSString *vfl1 = @"V:|-[adView(<=200)]-|";
    
    NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views];
    [self.view addConstraints:constraints1];
    

    
    NSString *vfl2 = @"|-margin-[imgView(<=110)]-[text1]-margin-|";
    NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:mertrics views:views];
    [adView addConstraints:constraints2];
    
    CGFloat h = 110 * 3 / 4;
    NSString *vfl3 = [NSString stringWithFormat:@"V:|-margin-[imgView(>=%lf)]-margin-|",h];
    NSArray *constraints3 = [NSLayoutConstraint constraintsWithVisualFormat:vfl3 options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:mertrics views:views];
    [adView addConstraints:constraints3];
    
    
    NSString *vfl4 = @"V:|-margin-[text1(==20)]-margin-|";
    NSArray *constraints4 = [NSLayoutConstraint constraintsWithVisualFormat:vfl4 options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:mertrics views:views];
    [adView addConstraints:constraints4];
    
    
    
    
    
    
//    UILabel *text1 = [[UILabel alloc] init];
//    text1.text = @"标题";
//    text1.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:text1];
//
//    UILabel *text2 = [[UILabel alloc] init];
//    text2.text = @"广告";
//    text2.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:text2];
//
//    //2.然后，记得要把AutoresizingMask布局关掉
//    view_1.translatesAutoresizingMaskIntoConstraints = NO;
//    text1.translatesAutoresizingMaskIntoConstraints = NO;
//    text1.translatesAutoresizingMaskIntoConstraints = NO;
//
//    //3.接着，添加约束
//    NSNumber *margin = @(10);
//    NSNumber *spacing = @(20);
//    NSDictionary *views = NSDictionaryOfVariableBindings(view_1,text1,text2);
//
//    // 添加水平方向的约束1
//    NSString *vfl = @"H:|-margin-[view_1]-spacing-[view_2(==view_1)]-margin-|";
//    NSDictionary *mertrics = NSDictionaryOfVariableBindings(margin,spacing);
//    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:mertrics views:views];
//    [self.view addConstraints:constraints];
//
//    // 添加水平方向的约束2
//    NSString *vfl1 = @"H:|-margin-[view_3]-margin-|";
//    NSDictionary *mertrics1 = NSDictionaryOfVariableBindings(margin,spacing);
//    NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:kNilOptions metrics:mertrics1 views:views];
//    [self.view addConstraints:constraints1];
//
//    // 添加竖直方向的约束
//    NSString *vfl2 = @"V:|-margin-[view_1(<=300)]-margin-[view_3]-spacing-|";
//    NSDictionary *mertrics2 = NSDictionaryOfVariableBindings(margin, spacing);
//    NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:kNilOptions metrics:mertrics2 views:views];
//    [self.view addConstraints:constraints2];
}


@end
