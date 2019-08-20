//
//  DNDismissViewController.m
//  PushTransitionDemo
//
//  Created by donews on 2019/8/14.
//  Copyright © 2019年 sjimac01. All rights reserved.
//

#import "DNDismissViewController.h"
#import "DRFPhotoDismissAnimation.h"

@interface DNDismissViewController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIButton *closeButton;             //
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;


@end

@implementation DNDismissViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.transitioningDelegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.closeButton.frame = CGRectMake(100,138, 44, 44);
    [self.view addSubview:self.closeButton];
    
    //添加手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(panGestureRecognizerAction:)];
    [self.view addGestureRecognizer:pan];
   
    
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan{
    
    //产生百分比
    CGFloat process = [pan translationInView:self.view].x / ([UIScreen mainScreen].bounds.size.width);
    
    process = MIN(1.0,(MAX(0.0, process)));
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.interactiveTransition = [UIPercentDrivenInteractiveTransition new];
        //触发dismiss转场动画
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (pan.state == UIGestureRecognizerStateChanged){
        [self.interactiveTransition updateInteractiveTransition:process];
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

- (void)s_closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    DRFPhotoDismissAnimation *animation = [[DRFPhotoDismissAnimation alloc] init];
    return animation;
    
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return self.interactiveTransition;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = [UIColor blueColor];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(s_closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
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
