//
//  ZZThread7ViewController.m
//  ZZKit
//
//  Created by donews on 2019/7/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZThread7ViewController.h"
#import "ZZNoCocurrentOperation.h"
#import "ZZCocurrentOperation.h"

@interface ZZThread7ViewController ()

@property (nonatomic,strong) NSOperationQueue *myQueue; 

@end

@implementation ZZThread7ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self demoNoCocurrent];
//    [self demoCocurrent];
    
}

#pragma mark - 自定义非并发
- (void)demoNoCocurrent {
    ZZNoCocurrentOperation *operation1 = [[ZZNoCocurrentOperation alloc] init];
    [operation1 start];
    
    //    默认情况下，该operation在当前调用start的线程中执行.其实如果我们创建多个自定义的ZZNoCocurrentOperation，并放入NSOperationQueue中，这些任务也是并发执行的，只不过因为我们没有处理并发情况下，线程执行完，KVO等操作，因此不建议在只实现main函数的情况下将其加入NSOperationQueue，只实现main一般只适合自定义非并发的
}

#pragma mark - 自定义并发
- (void)demoCocurrent {
    
    self.myQueue = [[NSOperationQueue alloc] init];
    ZZCocurrentOperation *operation1 = [[ZZCocurrentOperation alloc] init];
    ZZCocurrentOperation *operation2 = [[ZZCocurrentOperation alloc] init];
    [self.myQueue addOperation:operation1];
    [self.myQueue addOperation:operation2];
    ZZCocurrentOperation *operation3 = [[ZZCocurrentOperation alloc] init];
    [self.myQueue addOperation:operation3];

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
