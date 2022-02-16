//
//  DRFPhotoViewController.m
//  PushTransitionDemo
//
//  Created by donews on 2019/8/14.
//  Copyright © 2019年 sjimac01. All rights reserved.
//

#import "DRFPhotoViewController.h"
#import "DRFPhotoAnimation.h"
#import "DRFPhotoCommentViewController.h"

@interface DRFPhotoViewController () <UINavigationControllerDelegate>

@property (strong, nonatomic) UIButton *userButton;             //

@end

@implementation DRFPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [self testBtn];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
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
   
//    push 转场
    DRFPhotoCommentViewController *detail = [[DRFPhotoCommentViewController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
    
}

#pragma mark - UIViewControllerAnimatedTransitioning 转场动画
/*
 创建一个遵循<UIViewControllerAnimatedTransitioning>协议的动画过渡管理对象
 */
// MARK: 设置代理 (Push 转场)
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return [[DRFPhotoAnimation alloc] init];
    }
    return nil;
}


- (UIButton *)userButton {
    if (_userButton == nil) {
        _userButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _userButton.backgroundColor = COLOR_CLEAR;
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
