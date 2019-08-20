//
//  DRFPhotoDismissAnimation.m
//  PushTransitionDemo
//
//  Created by donews on 2019/8/14.
//  Copyright © 2019年 sjimac01. All rights reserved.
//

#import "DRFPhotoDismissAnimation.h"

@implementation DRFPhotoDismissAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 2.f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView* toView = nil;
    UIView* fromView = nil;
    UIView* transView = nil;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    transView = fromView;
    [[transitionContext containerView] insertSubview:toView belowSubview:fromView];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    transView.frame = CGRectMake(0,0, width, height);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        transView.frame = CGRectMake(width, 0, width, height);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    
}

@end
