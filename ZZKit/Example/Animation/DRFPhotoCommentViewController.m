//
//  DRFPhotoCommentViewController.m
//  PushTransitionDemo
//
//  Created by donews on 2019/8/14.
//  Copyright © 2019年 sjimac01. All rights reserved.
//

#import "DRFPhotoCommentViewController.h"
#import "DRFPhotoPopAnimation.h"

@interface DRFPhotoCommentViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;

@end

@implementation DRFPhotoCommentViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    //添加pan手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(panGestureRecognizerAction:)];
    [self.view addGestureRecognizer:pan];
  
}

//触发转场动画，通过手势产生百分比数值，更新转场动画状态：
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan{
    
    //产生百分比
    CGFloat process = [pan translationInView:self.view].x / ([UIScreen mainScreen].bounds.size.width);
    
    process = MIN(1.0,(MAX(0.0, process)));
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
        //触发pop转场动画
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (pan.state == UIGestureRecognizerStateChanged){
        // 触发pop转场动画，然后在转场动画结束之前通过- (void)updateInteractiveTransition:(CGFloat)percentComplete更改转场动画的完成的百分比，那么转场动画将由实现UIViewControllerInteractiveTransitioning的类接管，而不是由定时器管理，之后就可以随意设置动画状态了
        [self.interactiveTransition updateInteractiveTransition:process]; // 更新百分比
    }else if (pan.state == UIGestureRecognizerStateEnded
              || pan.state == UIGestureRecognizerStateCancelled){
        if (process > 0.5) {
            [ self.interactiveTransition finishInteractiveTransition];
        }else{
            [ self.interactiveTransition cancelInteractiveTransition];
        }
        self.interactiveTransition = nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        return [[DRFPhotoPopAnimation alloc] init];
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[DRFPhotoPopAnimation class]]) {
        return self.interactiveTransition;
    }
    return nil;
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
