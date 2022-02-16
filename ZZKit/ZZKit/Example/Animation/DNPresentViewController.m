//
//  DNPresentViewController.m
//  PushTransitionDemo
//
//  Created by donews on 2019/8/14.
//  Copyright © 2019年 sjimac01. All rights reserved.
//

#import "DNPresentViewController.h"
#import "DNDismissViewController.h"
#import "DRFPhotoPresentAnimation.h"

@interface DNPresentViewController ()<UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIButton *userButton;             //

@end

@implementation DNPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testBtn];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)testBtn {
    // 登录按钮
    self.userButton.frame = CGRectMake(100,138, 44, 44);
    self.userButton.layer.masksToBounds = YES;
    self.userButton.layer.cornerRadius = 22;
    [self.userButton addTarget:self action:@selector(userButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.userButton setImage:[UIImage imageNamed:@"Mine_photo_define"] forState:UIControlStateNormal];
    [self.view addSubview:self.userButton];
}

- (void)userButtonClick {
    
    //   Present 转场
    DNDismissViewController *detail = [[DNDismissViewController alloc]init];
    detail.transitioningDelegate = self;
    [self presentViewController:detail animated:YES completion:nil];
}

// MARK: 设置动画代理 (Present 转场)
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    DRFPhotoPresentAnimation *animation = [[DRFPhotoPresentAnimation alloc] init];
    return animation;
}

- (UIButton *)userButton {
    if (_userButton == nil) {
        _userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _userButton.backgroundColor = [UIColor clearColor];
    }
    return _userButton;
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
