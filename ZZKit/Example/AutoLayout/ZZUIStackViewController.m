//
//  ZZUIStackViewController.m
//  ZZKit
//
//  Created by donews on 2019/6/27.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZUIStackViewController.h"

@interface ZZUIStackViewController ()

@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation ZZUIStackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    一个StackView只能选择一种布局模式
    self.stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 150)];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.spacing = 10;
    self.stackView.distribution = UIStackViewDistributionFillEqually;
    self.stackView.alignment = UIStackViewAlignmentFill;
    self.stackView.backgroundColor = [UIColor greenColor];
    for (NSInteger i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] init];
        UIView *view2 = [[UIView alloc] init];
        view2.backgroundColor = [UIColor blueColor];
        [view addSubview:view2];
        view.backgroundColor = [UIColor colorWithRed:random()%256/255.0 green:random()%256/255.0 blue:random()%256/255.0 alpha:1];
//        addArrangedSubview和addSubview有很大的区别，使用前者是将试图添加进StackView的布局管理，
//        后者只是简单的加在试图的层级上，并不接受StackView 的布局管理
        [self.stackView addArrangedSubview:view];
        view2.frame = view.bounds;
    }
    [self.view addSubview:self.stackView];
//    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
//    NSLayoutConstraint *Constraint1 = [NSLayoutConstraint constraintWithItem:self.stackView attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
//
//    NSLayoutConstraint *Constraint2 = [NSLayoutConstraint constraintWithItem:self.stackView attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:100];
//
//    NSLayoutConstraint *Constraint3 = [NSLayoutConstraint constraintWithItem:self.stackView attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
//
//    NSLayoutConstraint *Constraint4 = [NSLayoutConstraint constraintWithItem:self.stackView attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.2 constant:0];
//
//    [self.view addConstraint:Constraint1];
//    [self.view addConstraint:Constraint2];
//    [self.view addConstraint:Constraint3];
//    [self.view addConstraint:Constraint4];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
