//
//  ZZViewController.m
//  ZZMedia
//
//  Created by iPhoneHH on 08/05/2020.
//  Copyright (c) 2020 iPhoneHH. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZSpeechViewController.h"
#import <ZZMedia/ZZReadListViewController.h>
#import "ZZRecognizeCardViewController.h"
#import "ZZOpenCVViewController.h"

@interface ZZViewController ()

@end

@implementation ZZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor greenColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    

    ZZSpeechViewController *vc = [ZZSpeechViewController new];
//    ZZReadListViewController *vc = [ZZReadListViewController new];
    
//     ZZRecognizeCardViewController *vc = [ZZRecognizeCardViewController new];
    
//    ZZOpenCVViewController *vc = [ZZOpenCVViewController new];

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
