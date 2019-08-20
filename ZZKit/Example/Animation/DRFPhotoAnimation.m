//
//  DRFPhotoAnimation.m
//  PushTransitionDemo
//
//  Created by donews on 2019/8/14.
//  Copyright © 2019年 sjimac01. All rights reserved.
//

#import "DRFPhotoAnimation.h"

@implementation DRFPhotoAnimation

//设置转场动画的时长
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 2.f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    // 要push到的控制器
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.backgroundColor = [UIColor blueColor];
    // 当前控制器
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromViewController.view.backgroundColor = [UIColor orangeColor];
    
    UIView* toView = nil;
    UIView* fromView = nil;
    //UITransitionContextFromViewKey和UITransitionContextToViewKey定义在iOS8.0以后的SDK中，所以在iOS8.0以下SDK中将toViewController和fromViewController的view设置给toView和fromView
    //iOS8.0 之前和之后view的层次结构发生变化，所以iOS8.0以后UITransitionContextFromViewKey获得view并不是fromViewController的view
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    //这个非常重要，将toView加入到containerView中
    // 转场动画所有要呈现的元素都要放在containerView中，fromView默认已经在containerView中了
    [[transitionContext containerView]  addSubview:toView];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    toView.frame = CGRectMake(width, 0, width, height);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.frame = CGRectMake(0, 0, width, height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
}

@end
